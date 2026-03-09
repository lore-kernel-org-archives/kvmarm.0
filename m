Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA5A3EF0D3
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073585; cv=none; b=Nviho2V+ySZCOuve9WGzJ5OpJIt4CnPhnGPx+ONjQMK8eufBQnyhWZ0aLBUEChQTix4PE1LOZ6/xvF0qb7TYgj8wX4P8TIXSzJrzONu1V5E+q1zsMja2hQ9icmXx0RvJFH/T+ye4mnRgiu9lcCRayolhv5GMp3oBUPCy+XK0QsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073585; c=relaxed/simple;
	bh=Qjw69/BBWT9BSPH1lQiEuT1/lOOedls+e1TJNd0iMvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m+KMyYLwh2UKRDDCPyhqJy/yAYCOOp3XHe+TEKISAtUvwilQBVhYQMviifZD/rexiv9w/uOK+e8E2RDgdxP1U7knBqVthM6rjpVW5obPgnJ1xE4WWvk6Yz5aMN9+/R6Mv7xjv926CRVzkG4hn9C7SCmhgb5HYUwygfEydAId8Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dEBdCzzD; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dEBdCzzD"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4853a9467c5so7787635e9.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073582; x=1773678382; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2KM8z/si7HcTp05zjHIB0T7h5Dhh3bTdr1CGW99HQcs=;
        b=dEBdCzzDPzPcc++cwxVW7OUCZBUUKPyLnLkqlJQopwU1/7Y5JL2zs1jjR9UNM7v6f3
         UpKjmKIb0x6RIe4wKL+oyWZT0HwXd6tipSMhCSW8kplZey2eCXCrmhOPVw4zeoDkBgOA
         PVcjBNlnReIXhP9fvhrkfLWl5GHBYOFinX0BhqNdI/Iv/cCJ0cvzrTjUjWLpC3vVh7Jq
         NEb4TgaloUjRlevSs6aQglSS/dU1nZSRiwx4eiZbLNojq3kQnU5VGT0H7b8pXkisA0Ww
         GaWuBYhXy0lawPD8eyoES5jxfL3OiWeIufb5/0XW3xCrcLgOmXGQLhOIXygYhQQhGLQT
         Ahzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073582; x=1773678382;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2KM8z/si7HcTp05zjHIB0T7h5Dhh3bTdr1CGW99HQcs=;
        b=nNYl9PVko+ziKHpiMUWLB7dhtXaKgi851jX1XbajsFnaOKD75Wm8HToPXasur0+VfA
         JX6L+tSl+qg5BAPTrQS5uoxGZupNBYLo+BiFwoyQv3USua4QNHMvMkOuzCsl5DyH0wMV
         ivg2HvsBYlJ8Odge6qPxd3AKkUiL9MjAKO4gx4WMWqFAiv+qyVlOIX80fReCtnYi33HQ
         osTRg+nUtRdZfod/FPNF2CRge1q9NoEWsQcVAqASPLfCvN7ejTeic6wB4By7Q0Q+8rFv
         mReu06yChu71RthzaQG5869IE/IChaeJ9ne4oGUEykHlO2Xh401PM6msFh1+Qugr8v/N
         wOPw==
X-Gm-Message-State: AOJu0Yyw3m6wCAMajQY24FEf8KwgAkIE3Pxbp54Qc12z5aOjXOUt125f
	zC8t9tTZxDdYnnTvDjNCq+OZT31GGmLr61yAzgd5ZrAPYE+OwHz9UhzRDaXCy2Wh+QXzFMD7Gs/
	vtYzT2cJ+zltdhAZM1S0iVg==
X-Received: from wmv11.prod.google.com ([2002:a05:600c:26cb:b0:485:3539:bc05])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:138a:b0:47e:e2eb:bc22 with SMTP id 5b1f17b1804b1-4852691c5bamr216470615e9.5.1773073581753;
 Mon, 09 Mar 2026 09:26:21 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:25:07 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-22-vdonnefort@google.com>
Subject: [PATCH v14 21/30] KVM: arm64: Initialise hyp_nr_cpus for nVHE hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Knowing the number of CPUs is necessary for determining the boundaries
of per-cpu variables, which will be used for upcoming hypervisor
tracing. hyp_nr_cpus which stores this value, is only initialised for
the pKVM hypervisor. Make it accessible for the nVHE hypervisor as well.

With the kernel now responsible for initialising hyp_nr_cpus, the
nr_cpus parameter is no longer needed in __pkvm_init.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 76ce2b94bd97..4bf63025061e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -129,8 +129,7 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __pkvm_init_switch_pgd(phys_addr_t pgd, unsigned long sp,
 		void (*fn)(void));
-int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
-		unsigned long *per_cpu_base, u32 hyp_va_bits);
+int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 #endif
 
@@ -147,5 +146,6 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
 extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
+extern unsigned long kvm_nvhe_sym(hyp_nr_cpus);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 410ffd41fd73..1371f9b3ecea 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -35,6 +35,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
 #include <asm/kvm_pkvm.h>
@@ -2465,7 +2466,7 @@ static int __init do_pkvm_init(u32 hyp_va_bits)
 	preempt_disable();
 	cpu_hyp_init_context();
 	ret = kvm_call_hyp_nvhe(__pkvm_init, hyp_mem_base, hyp_mem_size,
-				num_possible_cpus(), kern_hyp_va(per_cpu_base),
+				kern_hyp_va(per_cpu_base),
 				hyp_va_bits);
 	cpu_hyp_init_features();
 
@@ -2674,6 +2675,8 @@ static int __init init_hyp_mode(void)
 		kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu] = (unsigned long)page_addr;
 	}
 
+	kvm_nvhe_sym(hyp_nr_cpus) = num_possible_cpus();
+
 	/*
 	 * Map the Hyp-code called directly from the host
 	 */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 5f9d56754e39..f8a7b8c04c49 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -30,8 +30,6 @@ enum pkvm_component_id {
 	PKVM_ID_FFA,
 };
 
-extern unsigned long hyp_nr_cpus;
-
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e7790097db93..8ae3c348ed81 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -486,17 +486,15 @@ static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
 	DECLARE_REG(unsigned long, size, host_ctxt, 2);
-	DECLARE_REG(unsigned long, nr_cpus, host_ctxt, 3);
-	DECLARE_REG(unsigned long *, per_cpu_base, host_ctxt, 4);
-	DECLARE_REG(u32, hyp_va_bits, host_ctxt, 5);
+	DECLARE_REG(unsigned long *, per_cpu_base, host_ctxt, 3);
+	DECLARE_REG(u32, hyp_va_bits, host_ctxt, 4);
 
 	/*
 	 * __pkvm_init() will return only if an error occurred, otherwise it
 	 * will tail-call in __pkvm_init_finalise() which will have to deal
 	 * with the host context directly.
 	 */
-	cpu_reg(host_ctxt, 1) = __pkvm_init(phys, size, nr_cpus, per_cpu_base,
-					    hyp_va_bits);
+	cpu_reg(host_ctxt, 1) = __pkvm_init(phys, size, per_cpu_base, hyp_va_bits);
 }
 
 static void handle___pkvm_cpu_set_vector(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 90bd014e952f..d8e5b563fd3d 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -341,8 +341,7 @@ void __noreturn __pkvm_init_finalise(void)
 	__host_enter(host_ctxt);
 }
 
-int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
-		unsigned long *per_cpu_base, u32 hyp_va_bits)
+int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_base, u32 hyp_va_bits)
 {
 	struct kvm_nvhe_init_params *params;
 	void *virt = hyp_phys_to_virt(phys);
@@ -355,7 +354,6 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 		return -EINVAL;
 
 	hyp_spin_lock_init(&pkvm_pgd_lock);
-	hyp_nr_cpus = nr_cpus;
 
 	ret = divide_memory_pool(virt, size);
 	if (ret)
-- 
2.53.0.473.g4a7958ca14-goog

