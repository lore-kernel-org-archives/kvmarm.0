Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91FB2D63FC
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510291; cv=none; b=DFxjZbCxoIuSDeQoQonhRzwD6n98fFmNq5PKfwE+CadAAKou/WESDg9wc1a6mNgUw7g6rDkoUINU3YCf55gx0q+MedzfeNJPmTTSUBibY5gr3khJnbrvtbZePfojAT+Bjw43hi4UbzHSDu85YctSq+ULzPdPwfEQGk/6GyDebMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510291; c=relaxed/simple;
	bh=C53ygBWjsMP+UcUorpUgoXrWlq5dJSRuSmIlt0jKd/U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OIm1TKFWPSDlzPhnY0T3q7alg8owyEsRKkbTXYfyTJfG7b2IZIi26qa51A2e6jihQHJeqhOnmWmvkSXOh2tvKz60XlMEK04cz0us6WgowyhUQkErP7OaArJiGJD+q+qXIO8PBix3NDeqzOzVDHkOiPVMYw8WUM91NhXkMz7F+LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jHJdZ+uq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jHJdZ+uq"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31eec17b5acso271631a91.2
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510288; x=1755115088; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=x5qdlfMt7f/v/zSfpvn0pZJb5j/BJcw1RvQoZStHDYU=;
        b=jHJdZ+uqfRbdwUR7JF6HhpeByYKZD3EuGlg1skExpAwqOi916BmHKwPRw4BZqLRX1C
         wQMUN0QWhfkfxj0cFn2XtE2huFBS43+crCX28yeA5FHyK672uKsbfH7Xwg6FI/g+h/5e
         N+lJObryJo5FWsNPZKv3qAbgF0Yg1kwCM6fVVG1QEryz5pQ0ieTKTX+T43I0naoC36fu
         epeFGftLa77laW0DI8NrzYcqWrg6ENzF0dyossdkrVVTnBelcaAFSHiAJu3oY30g0cbx
         Th7VDuAs1awjkawruRX797tJB+wJsi6QQjAFqau3/8k0e1nbu+w10MlEuaRWaEnJJP9u
         wM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510288; x=1755115088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x5qdlfMt7f/v/zSfpvn0pZJb5j/BJcw1RvQoZStHDYU=;
        b=MTS3LodZ5OGfkoRQPEMJ/Y3V6t4RwDfEey49/ZJl4tn4WLg/bqOAL+D06TnengOZZK
         4K32s9iiXqVqtDVbGoAIaOCIdLdkJWZXIoyR0YE+HziN4+f4iQxi90NOCFuAr7n5or2b
         QAER7lGtIr2WHtufS/+vxzr6JpOaOSCLWw43mfpa4fPJ/eUv9xDRJhUA452mAHrrd+Jb
         Oc9CVOmTWCwVKWzGMJMFqWlIzMunfQ83NGaNrzmnwlI2vKvTfBiRWdR2ghviARman8dS
         OUW2SLWiuWuBUrQnnaQbwN4oqBW9JdGhnGZ+AVvN2UgF5A1lAps7LaurcfS20tSboQoj
         7o9w==
X-Forwarded-Encrypted: i=1; AJvYcCU4wkjXsCkpARAEzJWtassyvObPHV3Rr1S7qBv2tldk4Kb7DcCLYg78Q/2VaLKsxAzulwrnXg4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiXvIQrbqBmT3FekEYNZ7VoMxiqF7/8AwdeSEUrcMyXaAkP7bC
	ZuwOBAoRcV2ffMM5hRA4VuOjaBnZGHFE6a/WXZs0L2T50o9xoBoWOltl/NAB8MBDnPz7A5iYoHn
	CTXDnug==
X-Google-Smtp-Source: AGHT+IFfF+d9RBweWfYhERWBY7pftrU4yG2unJrGI6enSH3CQtm8m01r3mZaRpes0DVZoNbRLzozGADRUKg=
X-Received: from pjbeu16.prod.google.com ([2002:a17:90a:f950:b0:31e:dd67:e98])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ac1:b0:31e:f193:1822
 with SMTP id 98e67ed59e1d1-32166ccac82mr5178351a91.28.1754510287763; Wed, 06
 Aug 2025 12:58:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:43 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-22-seanjc@google.com>
Subject: [PATCH v5 21/44] KVM: x86/pmu: Register PMI handler for mediated vPMU
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

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

Register a dedicated PMI handler with perf's callback when mediated PMU
support is enabled.  Perf routes PMIs that arrive while guest context is
loaded to the provided callback, by modifying the CPU's LVTPC to point at
a dedicated mediated PMI IRQ vector.

WARN upon receipt of a mediated PMI if there is no active vCPU, or if the
vCPU doesn't have a mediated PMU.  Even if a PMI manages to skid past
VM-Exit, it should never be delayed all the way beyond unloading the vCPU.
And while running vCPUs without a mediated PMU, the LVTPC should never be
wired up to the mediated PMI IRQ vector, i.e. should always be routed
through perf's NMI handler.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 10 ++++++++++
 arch/x86/kvm/pmu.h |  2 ++
 arch/x86/kvm/x86.c |  3 ++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 4d4bb9b17412..680523e9d11e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -155,6 +155,16 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 		perf_get_hw_event_config(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 }
 
+void kvm_handle_guest_mediated_pmi(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!vcpu || !kvm_vcpu_has_mediated_pmu(vcpu)))
+		return;
+
+	kvm_make_request(KVM_REQ_PMI, vcpu);
+}
+
 static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index f5b6181b772c..e038bce76b9e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -46,6 +46,8 @@ struct kvm_pmu_ops {
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
 
+void kvm_handle_guest_mediated_pmi(void);
+
 static inline bool kvm_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
 {
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 396d1aa81732..2c34dd3f0222 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9693,7 +9693,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		set_hv_tscchange_cb(kvm_hyperv_tsc_notifier);
 #endif
 
-	__kvm_register_perf_callbacks(ops->handle_intel_pt_intr, NULL);
+	__kvm_register_perf_callbacks(ops->handle_intel_pt_intr,
+				      enable_mediated_pmu ? kvm_handle_guest_mediated_pmi : NULL);
 
 	if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_mmu_enabled)
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SW_PROTECTED_VM);
-- 
2.50.1.565.gc32cd1483b-goog

