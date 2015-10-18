from ChicagoBoothML_Helpy.EvaluationMetrics import bin_classif_eval
from numpy import allclose, array
from numpy.random import choice, uniform
from pandas import Categorical, DataFrame
from sklearn.metrics import accuracy_score, f1_score, log_loss, precision_score, recall_score


def test_bin_classif_eval_metrics(nb_samples=1000, threshold=.5):
    """test: Binary Classification Metrics"""

    neg_class = 'Cat0'
    pos_class = 'Cat1'
    classes = neg_class, pos_class

    d = DataFrame(dict(
        actuals_cat=Categorical(choice(classes, size=nb_samples), categories=classes)))
    d['actuals_bool'] = d.actuals_cat == pos_class
    d['probs'] = uniform(size=nb_samples)
    d['hard_preds_bool'] = d.probs >= threshold
    d['hard_preds_cat'] = Categorical(
        map(lambda b: {False: neg_class, True: pos_class}[b], d.hard_preds_bool), categories=classes)

    scikit_learn_accuracy = accuracy_score(d.actuals_cat, d.hard_preds_cat)
    scikit_learn_recall = recall_score(d.actuals_cat, d.hard_preds_cat, pos_label=pos_class)
    scikit_learn_precision = precision_score(d.actuals_cat, d.hard_preds_cat, pos_label=pos_class)
    scikit_learn_f1_score = f1_score(d.actuals_cat, d.hard_preds_cat, pos_label=pos_class)
    scikit_learn_log_loss = log_loss(d.actuals_cat, array(d.probs))

    test = True

    # TEST: hard predictions (boolean format) vs. actuals (boolean format)
    metrics = bin_classif_eval(
        predictions=d.hard_preds_bool,
        actuals=d.actuals_bool)
    test &=\
        allclose(metrics['accuracy'], scikit_learn_accuracy) &\
        allclose(metrics['recall'], scikit_learn_recall) &\
        allclose(metrics['precision'], scikit_learn_precision) &\
        allclose(metrics['f1_score'], scikit_learn_f1_score)

    # TEST: hard predictions (boolean format) vs. actuals (categorical format)
    metrics = bin_classif_eval(
        predictions=d.hard_preds_bool,
        actuals=d.actuals_cat,
        pos_cat=pos_class)
    test &= \
        allclose(metrics['accuracy'], scikit_learn_accuracy) & \
        allclose(metrics['recall'], scikit_learn_recall) & \
        allclose(metrics['precision'], scikit_learn_precision) & \
        allclose(metrics['f1_score'], scikit_learn_f1_score)

    # TEST: hard predictions (categorical format) vs. actuals (boolean format)
    metrics = bin_classif_eval(
        predictions=d.hard_preds_cat,
        actuals=d.actuals_bool,
        pos_cat=pos_class)
    test &= \
        allclose(metrics['accuracy'], scikit_learn_accuracy) & \
        allclose(metrics['recall'], scikit_learn_recall) & \
        allclose(metrics['precision'], scikit_learn_precision) & \
        allclose(metrics['f1_score'], scikit_learn_f1_score)

    # TEST: hard predictions (categorical format) vs. actuals (categorical format)
    metrics = bin_classif_eval(
        predictions=d.hard_preds_cat,
        actuals=d.actuals_cat,
        pos_cat=pos_class)
    test &= \
        allclose(metrics['accuracy'], scikit_learn_accuracy) & \
        allclose(metrics['recall'], scikit_learn_recall) & \
        allclose(metrics['precision'], scikit_learn_precision) & \
        allclose(metrics['f1_score'], scikit_learn_f1_score)

    # TEST: probs vs. actuals (boolean format)
    metrics = bin_classif_eval(
        predictions=d.probs,
        actuals=d.actuals_bool)
    test &= \
        allclose(metrics['accuracy'], scikit_learn_accuracy) & \
        allclose(metrics['recall'], scikit_learn_recall) & \
        allclose(metrics['precision'], scikit_learn_precision) & \
        allclose(metrics['f1_score'], scikit_learn_f1_score) &\
        allclose(metrics['deviance'], 2 * scikit_learn_log_loss)

    # TEST: probs vs. actuals (categorical format)
    metrics = bin_classif_eval(
        predictions=d.probs,
        actuals=d.actuals_cat,
        pos_cat=pos_class)
    test &= \
        allclose(metrics['accuracy'], scikit_learn_accuracy) & \
        allclose(metrics['recall'], scikit_learn_recall) & \
        allclose(metrics['precision'], scikit_learn_precision) & \
        allclose(metrics['f1_score'], scikit_learn_f1_score) & \
        allclose(metrics['deviance'], 2 * scikit_learn_log_loss)


    assert test

# TEST: hard predictions (category format)



