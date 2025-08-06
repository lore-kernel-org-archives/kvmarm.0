Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B002D3EDF
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510281; cv=none; b=ZhH+O+DCvTNfkIkIBxVoyuIbbILqAf3HMWq3c/cC8A1zeEAP+KNVYr/YJyeq5J5BT1zoOOF+xt26djlkd2o9gewzFU0yOh/sF/i6Bzwt5JWanJ+HZ3FGZCEEy03HYoNf1q7dmZ4l3AdDqsbvBZNsO5kLZxy6EuLrAXD8nvHel4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510281; c=relaxed/simple;
	bh=S2PXduPc6MjaQTDHugYUZGj6hH4KjT2QfQWxoS/aD0c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z4pDeR3fIkEKXvK7iG+sOzNQmoJXaFcP9TU+TzRwMQkROPEy4sp2YgFupeM22QbfksbXDay0vGoAxdQNB1sukTUk5dJ6O4IyHSnzVzr0CpdxcQM/RtaIg3hCg2sDOJpcmCwdXOCVVZprrf3SbY7ktP5BlNdAzBAO9PM/i5tDbp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L4BhS+4Y; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L4BhS+4Y"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ed2a7d475so260572a91.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510278; x=1755115078; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JPhdbzRHNYwbPflarjN5FFRR+xgGKTfGx/VQdQ/Orqk=;
        b=L4BhS+4YoGK4e3Z44Uzx0oWqANgxwTW4sUspwdy31uViV7C8JOQJKt+4rGYBWRZI3L
         J83NYLzyCGQKuYoh5c9/MnJttsujh3BlurBqJuD1xVOWx5mJZ/VNiDzK/jUmLPFXqI7f
         jsZkxp3PecARuAhd1FhqxIAxSY7vz8nhTZR5ukhx8vwH0Cs1f0G/2l0V0dMytD2kvo/0
         3SAArC5wP2GAwl9h7DmEs4r++iQ6GHBelYnRiGibY7tWTIY/OSQnErzhsbQLaDemN9jV
         hyobk5EZTNxZ76d+g31hEOgZi9n8Pi0rrj7A/aeUVJFjPRaR0VvLO7qtiN1EfK8vF674
         wYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510278; x=1755115078;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JPhdbzRHNYwbPflarjN5FFRR+xgGKTfGx/VQdQ/Orqk=;
        b=pa593+7pkWc3GiivwSNDIrL/Yb9E9Q5dpEKikyjSd0AXYeRm3GuP1514VPWgvM5bLo
         SD/YAQQ+cNSqTj5k4tlY6y/utHxl6VJJyEZ9ap2E1oA9+F7ZOgBYV/mjSOm7zl8h00C1
         zmK9kUSulzytLQn08LQr1Mfewbcr7GXbLfbcvmaEniT9Ifgv2fnFr0PsOaM/2X1qfPQS
         uBs/33DnCcYiakIUHWzbEep33AtqADoizdlchtRiBqE5ewgKOn8h30Ob8PDxXBdKhNij
         q7jPSa2bAU5tBfg7UiczTHQCt+mq2a+pAcNI2ved3sLoSNNjQbRHvgrsSe65g0FNyH7J
         Wniw==
X-Forwarded-Encrypted: i=1; AJvYcCVkYFL7/1C3AGoj6yCzhCypMUCG5SBzP/+iBtBtqFfQZ4JeMKLxTLTImGK0ZDriR8Ys1EVJUXc=@lists.linux.dev
X-Gm-Message-State: AOJu0YykWRmOcubG5S4fUepMZB7KUXt1p4veNx53dCECsUlTI9GQEYRw
	DNGuoTfmq9SCrBk0f/RmBCZ2gu/zzBV8kfEnBomFKAIBSSWpy4EiLRwRNwsCXz0kndoNoT0iiFg
	s87AQGw==
X-Google-Smtp-Source: AGHT+IFSe1FbjsND/XiMAlJbwSv08tGHE8p8b2tGPxUBNGb/T59D+jgsyqvY56UbSdKD1Cfbmzp8QhdLT3k=
X-Received: from pjzj16.prod.google.com ([2002:a17:90a:eb10:b0:313:274d:3007])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c86:b0:312:ffdc:42b2
 with SMTP id 98e67ed59e1d1-32167541295mr4635514a91.23.1754510278028; Wed, 06
 Aug 2025 12:57:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:38 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-17-seanjc@google.com>
Subject: [PATCH v5 16/44] KVM: Add a simplified wrapper for registering perf callbacks
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

Add a parameter-less API for registering perf callbacks in anticipation of
introducing another x86-only parameter for handling mediated PMU PMIs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c      |  2 +-
 arch/loongarch/kvm/main.c |  2 +-
 arch/riscv/kvm/main.c     |  2 +-
 arch/x86/kvm/x86.c        |  2 +-
 include/linux/kvm_host.h  | 11 +++++++++--
 virt/kvm/kvm_main.c       |  5 +++--
 6 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 888f7c7abf54..6c604b5214f2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2328,7 +2328,7 @@ static int __init init_subsystems(void)
 	if (err)
 		goto out;
 
-	kvm_register_perf_callbacks(NULL);
+	kvm_register_perf_callbacks();
 
 out:
 	if (err)
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 80ea63d465b8..f62326fe29fa 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -394,7 +394,7 @@ static int kvm_loongarch_env_init(void)
 	}
 
 	kvm_init_gcsr_flag();
-	kvm_register_perf_callbacks(NULL);
+	kvm_register_perf_callbacks();
 
 	/* Register LoongArch IPI interrupt controller interface. */
 	ret = kvm_loongarch_register_ipi_device();
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 67c876de74ef..cbe842c2f615 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -159,7 +159,7 @@ static int __init riscv_kvm_init(void)
 		kvm_info("AIA available with %d guest external interrupts\n",
 			 kvm_riscv_aia_nr_hgei);
 
-	kvm_register_perf_callbacks(NULL);
+	kvm_register_perf_callbacks();
 
 	rc = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
 	if (rc) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5af2c5aed0f2..d80bbd5e0859 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9689,7 +9689,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		set_hv_tscchange_cb(kvm_hyperv_tsc_notifier);
 #endif
 
-	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
+	__kvm_register_perf_callbacks(ops->handle_intel_pt_intr, NULL);
 
 	if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_mmu_enabled)
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SW_PROTECTED_VM);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15656b7fba6c..20c50eaa0089 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1731,10 +1731,17 @@ static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
 #ifdef CONFIG_GUEST_PERF_EVENTS
 unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu);
 
-void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void));
+void __kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void),
+				   void (*mediated_pmi_handler)(void));
+
+static inline void kvm_register_perf_callbacks(void)
+{
+	__kvm_register_perf_callbacks(NULL, NULL);
+}
+
 void kvm_unregister_perf_callbacks(void);
 #else
-static inline void kvm_register_perf_callbacks(void *ign) {}
+static inline void kvm_register_perf_callbacks(void) {}
 static inline void kvm_unregister_perf_callbacks(void) {}
 #endif /* CONFIG_GUEST_PERF_EVENTS */
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ecafab2e17d9..d477a7fda0ae 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6429,10 +6429,11 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.handle_mediated_pmi	= NULL,
 };
 
-void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void))
+void __kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void),
+				   void (*mediated_pmi_handler)(void))
 {
 	kvm_guest_cbs.handle_intel_pt_intr = pt_intr_handler;
-	kvm_guest_cbs.handle_mediated_pmi = NULL;
+	kvm_guest_cbs.handle_mediated_pmi = mediated_pmi_handler;
 
 	perf_register_guest_info_callbacks(&kvm_guest_cbs);
 }
-- 
2.50.1.565.gc32cd1483b-goog

