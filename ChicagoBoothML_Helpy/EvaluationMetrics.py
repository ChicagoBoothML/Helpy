from __future__ import division
from collections import OrderedDict
from numpy import log, sqrt
from pandas import DataFrame


def mse(y_hat, y):
    return ((y_hat - y) ** 2).mean()


def rmse(y_hat, y):
    return sqrt(mse(y_hat, y))


def bin_class_dev(p_hat, y, pos_cat=None, tiny=1e-32):
    if y.dtype == 'category':
        y_bool = y == pos_cat
    else:
        y_bool = y.astype(bool)
    return - 2 * (y_bool * log(p_hat + tiny) + (1 - y) * log(1 - p_hat + tiny)).mean()


def bin_classif_eval_hard_pred(hard_predictions, actuals, pos_cat=None):

    if hard_predictions.dtype == 'category':
        hard_predictions_bool = hard_predictions == pos_cat
    else:
        hard_predictions_bool = hard_predictions.astype(bool)

    if actuals.dtype == 'category':
        actuals_bool = actuals == pos_cat
    else:
        actuals_bool = actuals.astype(bool)

    opposite_hard_predictions_bool = ~ hard_predictions_bool
    opposite_actuals_bool = ~ actuals_bool

    nb_samples = len(actuals)
    nb_pos = sum(actuals_bool)
    nb_neg = sum(opposite_actuals_bool)
    nb_pred_pos = sum(hard_predictions_bool)
    nb_pred_neg = sum(opposite_hard_predictions_bool)
    nb_true_pos = sum(hard_predictions_bool * actuals_bool)
    nb_true_neg = sum(opposite_hard_predictions_bool * opposite_actuals_bool)
    nb_false_pos = sum(hard_predictions_bool * opposite_actuals_bool)
    nb_false_neg = sum(opposite_hard_predictions_bool * actuals_bool)

    accuracy = (nb_true_pos + nb_true_neg) / nb_samples
    recall = nb_true_pos / nb_pos
    specificity = nb_true_neg / nb_neg
    precision = nb_true_pos / nb_pred_pos
    f1_score = (2 * precision * recall) / (precision + recall)

    return OrderedDict(
        accuracy=accuracy,
        recall=recall,
        specificity=specificity,
        precision=precision,
        f1_score=f1_score)


def bin_classif_eval(predictions, actuals, pos_cat=None, thresholds=.5):

    if (predictions.dtype == 'category') or isinstance(predictions, ('int', 'int64', 'bool')):
        return bin_classif_eval_hard_pred(predictions, actuals, pos_cat=pos_cat)

    if isinstance(thresholds, (float, int)):

        hard_predictions = predictions >= thresholds
        metrics = bin_classif_eval_hard_pred(hard_predictions, actuals, pos_cat)
        metrics['deviance'] = bin_class_dev(predictions, actuals, pos_cat)
        return metrics

    else:

        metrics = DataFrame(dict(threshold=thresholds))
        column_names = [
            'accuracy',
            'recall',
            'specificity',
            'precision',
            'f1_score',
            'deviance']
        metrics[:, column_names] = 0.

        for i in range(len(thresholds)):
            metrics.ix[i, column_names] = bin_classif_eval(
                predictions, actuals, pos_cat=pos_cat, thresholds=thresholds[i])

        return metrics
