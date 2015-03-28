module SecEdgar
  module BasicStats
    extend self

    def precision(tp, fp)
      tp.fdiv(tp + fp)
    end

    def recall(tp, fn)
      tp.fdiv(tp + fn)
    end

    def f_beta(tp, fp, fn, beta)
      p = precision(tp, fp)
      r = recall(tp, fn)
      b2 = beta ** 2
      (1 + b2) * ((p * r).fdiv((b2 * p) + r))
    end

    def f1(tp, fp, fn)
      p = precision(tp, fp)
      r = recall(tp, fn)
      2 * ((p * r).fdiv(p + r))
    end
  end
end
