Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB982BE7A3
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510307; cv=none; b=pdeYqLl3k974Lapfeu27HnwvjTEKhodGtOqLbq6UnIN4hqvrOOGJ9irA+ThKf7mpnQ+sDGs9P77VkR1FbA3W4phPAN6qmIiZXCs96tN/3ZHGQzQeCHGERNDIblSKnZCFrVJsU00Kcs9rlqGcb5a4j5I1rWthEF27CdQDWg2SobU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510307; c=relaxed/simple;
	bh=ukS/hePPonycrg9r313f+paqDEVzP34VnPUrCOh2p4I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eCQd32yVkIVgN3L5y+6oaVCxLahJR5X1aZUPWtHoTjgqTBrvpIbbehepPlYUArLBcIUem393GPdyj2IHNYkF53n2LbYj/bRrqEqCxEoKnUUkRzpjaFJYQBpX5s/ruffpTbTNwF5+BsYjsb4KYmubrqFTuvskHFufm6ue/MZtqzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uqtojkb0; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uqtojkb0"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76bcf2cac36so317095b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510304; x=1755115104; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aHvZdAUvNaaZFmbhTqFilDj1JXSRU8dLYlLgEZc/oCw=;
        b=uqtojkb0LTOG0Jn0B9hKo64qCJY0zEZMsvO62ndVkqCg9D61RklTBf73Y4ZZqt3fp4
         0TmjEiyFu5Asc2WpHAehrYYQ2po+jNKC8l6XYUHEGVSqQglFpeWF4lkI249xDkSdu+WU
         JtOa2eta/7Vl6FteFKfQYsMKnh6imC9L9BBu4Zjb1ztu6iFvdRkgtlvLkXynT2Unb7tn
         mcqZNgKuyHPqosv3EeJUR30z1AV1y2YdJMaf/e34lGQsRWFtCzccvYHDAqbTJyo3orsT
         j8Ca3v4EShudppGJ5aKHpmPZmUNZ79EY7QxWMc41hsFWgOKiurWsy8Aro+Zstb2pi59j
         10QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510304; x=1755115104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aHvZdAUvNaaZFmbhTqFilDj1JXSRU8dLYlLgEZc/oCw=;
        b=VMx1UQmS8dS4HuLMzQGFQxh1Rq4Vc9YGbFWiDQhC01hXfVUOqCHyzuN9zSpMLF3GOx
         3iiDqhA4R1eYEfUeX6v4aZf5QEA1BlbEOaS2zO+ZaV7la3ey16TLBsGAFrEELPPixWei
         hNN+bcfnYC3xA6L+Qdv2ZzuN6S7Iw614atFz7hx4W2D//b4pncQNYNqu5YjRJKyGKsmp
         v9SmLwuyLiZtVNs/f4qF8HWkJyBbeU9gNyJSqy5B2Iy8A8aw2L0tCTIutSvtGZ93kUQA
         dAEYUJDPz6ZT4H4qFcXsrlCotiXuJ1qM7L92IwDwy5uX79+ApHbb2oEOlOubQhgzIrvN
         uqAA==
X-Forwarded-Encrypted: i=1; AJvYcCVfHjfD1pyfTUobWHNTKTJiY81HBZuIpmGCEyxtGovECWklAM16tj0dNlTwfGI7BSNZsTLeBis=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKeRKgrDf7Lgc7043Tu+7KuQUxTXf+U81DooeQQsuov6wSciqA
	Y02t8IpYimwNJhWvMmhJ69aTbjDtTKd5WpE+qZ25qSPQsuQ0VCqUy5BoCX5T7Gwl3XVrkqA+BMR
	QVeV1uw==
X-Google-Smtp-Source: AGHT+IGfcxFcqE+WO40f0G1jJJ785vOiC3NUhX/6TGZEyq4CvV1J0auJAX6NhvanreP79iKSuzsragVBkJw=
X-Received: from pfvf15.prod.google.com ([2002:a05:6a00:1acf:b0:746:3162:8be1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:999f:b0:220:78b9:f849
 with SMTP id adf61e73a8af0-240331272admr5902393637.24.1754510303927; Wed, 06
 Aug 2025 12:58:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:52 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-31-seanjc@google.com>
Subject: [PATCH v5 30/44] KVM: x86/pmu: Move initialization of valid PMCs
 bitmask to common x86
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Move all initialization of all_valid_pmc_idx to common code, as the logic
is 100% common to Intel and AMD, and KVM heavily relies on Intel and AMD
having the same semantics.  E.g. the fact that AMD doesn't support fixed
counters doesn't allow KVM to use all_valid_pmc_idx[63:32] for other
purposes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c           | 4 ++++
 arch/x86/kvm/svm/pmu.c       | 1 -
 arch/x86/kvm/vmx/pmu_intel.c | 5 -----
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a4fe0e76df79..4246e1d2cfcc 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -932,6 +932,10 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_has_mediated_pmu(vcpu))
 			kvm_pmu_call(write_global_ctrl)(pmu->global_ctrl);
 	}
+
+	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
+	bitmap_set(pmu->all_valid_pmc_idx, KVM_FIXED_PMC_BASE_IDX,
+		   pmu->nr_arch_fixed_counters);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index b777c3743304..9ffd44a5d474 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -209,7 +209,6 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->nr_arch_fixed_counters = 0;
-	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
 }
 
 static void amd_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6352d029298c..1de94a39ca18 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -579,11 +579,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->raw_event_mask |= (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED);
 	}
 
-	bitmap_set(pmu->all_valid_pmc_idx,
-		0, pmu->nr_arch_gp_counters);
-	bitmap_set(pmu->all_valid_pmc_idx,
-		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
-
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
 	if (intel_pmu_lbr_is_compatible(vcpu) &&
 	    (perf_capabilities & PERF_CAP_LBR_FMT))
-- 
2.50.1.565.gc32cd1483b-goog

