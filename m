Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A7D17165C
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901169; cv=none; b=MdoJlK0JdnI8Xwd5r/0mKUYeaI37KoTzfR070Cw+jb4aQaLeFLc0bRI32j4+iEq+AStnOpLxHs800jFQ7APk10c6tpJ6vR5Gh3YvOwmULxIBlESJE0Z3C4c3iYK/AT+vdhq3+0nD9fX13y7zMRuPouH2Lzj1HiM3/y2VBk1UnhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901169; c=relaxed/simple;
	bh=vZy2kqPLunagZe+Vkenwk9W9hl+ShPOAw7sJhur0iAk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LDMVrwLroPToNAnF2FNviblaLzPUNETOGCnVB+4MWfahh7mSkmJM5D7kYjrsixlTt9O2A6jzQ72lj3u4mDjb8unuxizICPvCOqwLWQwqh982QiYJ3eOXyvJ7dAphsexUA0imZ1qMXK+9lbkjlLMzprox+nD+MZesOIw3m3T6gHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GdeP74mu; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GdeP74mu"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-42108822a8eso17421395e9.0
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901166; x=1717505966; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k08Q99kcebudj91vVsxUzYTvnpbAZeHoffLjW6jA5l0=;
        b=GdeP74muQ6gBdZzkEV9emGoiqL8z5VmPi0VrK4guoU5Lw3aEEilGeY4UTISbrGHA2E
         u76WQ08DGP6qaD0isZvXY5gefG1dC3w015Ru29JcfSfIzKinY/gAb85/nm81CPGlEy+w
         FoAdrVpovU6Hy3deETYptrtlMINURuUeo2VA7MTAugClJnQDpZhiwjJXCNYi+F18Q1ak
         4AFUai94saF1XQHwsqUek4og1Ce5zhFYA4eavjU0DlHzocdo84zByiqOJTS2OhxVIbqk
         9Cik7YuPDOUNPTINUFcEy/WqJ9v6iISbSrL1+BC/GATEoimaASibh+joY6mTOAiMud9U
         n1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901166; x=1717505966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k08Q99kcebudj91vVsxUzYTvnpbAZeHoffLjW6jA5l0=;
        b=B8AtE+E/HrbY0FS3UBdRqP/6Dw4KsXSzc/bF/n+6ZhO/JByF+OYQk4/dKQs7h3LyaA
         hB6xb4W96BNBWhnPBcIfQygkZHOVeZEmLsSPFdaPCzSLeOQKATAM/tKFwTCcJShHkIM7
         95YQDwxlQT25SP/Rz9m8N54S7gPsRbHijDHtvhg0GZNr7fCjJxj1RTnubxXnnf09T7a+
         FsTpVnGSiPP91X7NhvB/7Q59IQ//sjWdMTOwuGoOKSdtO6OyKlP4/TKWospS+D4nIaWv
         hmyhNYVc5smFJEW9IGsCfW9Wuro+ERYQsY9Z/mJ05sffWlLHSo6T3kFwKkDkP3E+9wF0
         8TDA==
X-Gm-Message-State: AOJu0Yw7+58bL4dXZbpq0/JKZjPizwX/vUReymLNoWJtz9pqx6y26YBF
	GxNHjatB7KxCko5hAI3E0+FIeuS1sfZUunExhg2gaYUWGUC1SyvjBzMAf+HDoNy7m2/CbdH0v+z
	bWt3sCIvYxfoz2fj3sNiMNAoeT5TDxzaqsLm+DIVTj+ptLdHVhu6ILFnenoy35jjSnzEUWIlpvk
	VFZqI+GeNXpE+DielzNwPoPXGtRZU=
X-Google-Smtp-Source: AGHT+IGExxKtxZN8TH2SOHy8rNHxD8eDAeJ9awVkquf2hhvgo1kw2ypAwDVW/9/fRtMGcDtjLTXGDlcA6Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3b1f:b0:41f:3f3:2fd5 with SMTP id
 5b1f17b1804b1-4210816fb47mr2547815e9.0.1716901166027; Tue, 28 May 2024
 05:59:26 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:07 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-5-tabba@google.com>
Subject: [PATCH v3 04/11] KVM: arm64: Allocate memory mapped at hyp for host
 sve state in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Protected mode needs to maintain (save/restore) the host's sve
state, rather than relying on the host kernel to do that. This is
to avoid leaking information to the host about guests and the
type of operations they are performing.

As a first step towards that, allocate memory mapped at hyp, per
cpu, for the host sve state. The following patch will use this
memory to save/restore the host state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
Note that the last patch in this series will consolidate the
setup of the host's fpsimd and sve states, which currently take
place in two different locations. Moreover, that last patch will
also place the host fpsimd and sve_state pointers in a union.
---
 arch/arm64/include/asm/kvm_host.h | 17 ++++++++
 arch/arm64/include/asm/kvm_hyp.h  |  1 +
 arch/arm64/include/asm/kvm_pkvm.h |  9 ++++
 arch/arm64/kvm/arm.c              | 68 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  2 +
 arch/arm64/kvm/hyp/nvhe/setup.c   | 24 +++++++++++
 arch/arm64/kvm/reset.c            |  3 ++
 7 files changed, 124 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8170c04fde91..90df7ccec5f4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -76,6 +76,7 @@ static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int __ro_after_init kvm_sve_max_vl;
+extern unsigned int __ro_after_init kvm_host_sve_max_vl;
 int __init kvm_arm_init_sve(void);
 
 u32 __attribute_const__ kvm_target_cpu(void);
@@ -521,6 +522,20 @@ struct kvm_cpu_context {
 	u64 *vncr_array;
 };
 
+struct cpu_sve_state {
+	__u64 zcr_el1;
+
+	/*
+	 * Ordering is important since __sve_save_state/__sve_restore_state
+	 * relies on it.
+	 */
+	__u32 fpsr;
+	__u32 fpcr;
+
+	/* Must be SVE_VQ_BYTES (128 bit) aligned. */
+	__u8 sve_regs[];
+};
+
 /*
  * This structure is instantiated on a per-CPU basis, and contains
  * data that is:
@@ -534,7 +549,9 @@ struct kvm_cpu_context {
  */
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
+
 	struct user_fpsimd_state *fpsimd_state;	/* hyp VA */
+	struct cpu_sve_state *sve_state;	/* hyp VA */
 
 	/* Ownership of the FP regs */
 	enum {
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 2ab23589339a..d313adf53bef 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -143,5 +143,6 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
+extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ad9cfb5c1ff4..cd56acd9a842 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -128,4 +128,13 @@ static inline unsigned long hyp_ffa_proxy_pages(void)
 	return (2 * KVM_FFA_MBOX_NR_PAGES) + DIV_ROUND_UP(desc_max, PAGE_SIZE);
 }
 
+static inline size_t pkvm_host_sve_state_size(void)
+{
+	if (!system_supports_sve())
+		return 0;
+
+	return size_add(sizeof(struct cpu_sve_state),
+			SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_sve_max_vl)));
+}
+
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9996a989b52e..1acf7415e831 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1931,6 +1931,11 @@ static unsigned long nvhe_percpu_order(void)
 	return size ? get_order(size) : 0;
 }
 
+static size_t pkvm_host_sve_state_order(void)
+{
+	return get_order(pkvm_host_sve_state_size());
+}
+
 /* A lookup table holding the hypervisor VA for each vector slot */
 static void *hyp_spectre_vector_selector[BP_HARDEN_EL2_SLOTS];
 
@@ -2310,12 +2315,20 @@ static void __init teardown_subsystems(void)
 
 static void __init teardown_hyp_mode(void)
 {
+	bool free_sve = system_supports_sve() && is_protected_kvm_enabled();
 	int cpu;
 
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu) {
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
 		free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
+
+		if (free_sve) {
+			struct cpu_sve_state *sve_state;
+
+			sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
+			free_pages((unsigned long) sve_state, pkvm_host_sve_state_order());
+		}
 	}
 }
 
@@ -2398,6 +2411,50 @@ static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
 	return 0;
 }
 
+static int init_pkvm_host_sve_state(void)
+{
+	int cpu;
+
+	if (!system_supports_sve())
+		return 0;
+
+	/* Allocate pages for host sve state in protected mode. */
+	for_each_possible_cpu(cpu) {
+		struct page *page = alloc_pages(GFP_KERNEL, pkvm_host_sve_state_order());
+
+		if (!page)
+			return -ENOMEM;
+
+		per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state = page_address(page);
+	}
+
+	/*
+	 * Don't map the pages in hyp since these are only used in protected
+	 * mode, which will (re)create its own mapping when initialized.
+	 */
+
+	return 0;
+}
+
+/*
+ * Finalizes the initialization of hyp mode, once everything else is initialized
+ * and the initialziation process cannot fail.
+ */
+static void finalize_init_hyp_mode(void)
+{
+	int cpu;
+
+	if (!is_protected_kvm_enabled() || !system_supports_sve())
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct cpu_sve_state *sve_state;
+
+		sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
+		per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state = kern_hyp_va(sve_state);
+	}
+}
+
 static void pkvm_hyp_init_ptrauth(void)
 {
 	struct kvm_cpu_context *hyp_ctxt;
@@ -2566,6 +2623,10 @@ static int __init init_hyp_mode(void)
 			goto out_err;
 		}
 
+		err = init_pkvm_host_sve_state();
+		if (err)
+			goto out_err;
+
 		err = kvm_hyp_init_protection(hyp_va_bits);
 		if (err) {
 			kvm_err("Failed to init hyp memory protection\n");
@@ -2730,6 +2791,13 @@ static __init int kvm_arm_init(void)
 	if (err)
 		goto out_subs;
 
+	/*
+	 * This should be called after initialization is done and failure isn't
+	 * possible anymore.
+	 */
+	if (!in_hyp_mode)
+		finalize_init_hyp_mode();
+
 	kvm_arm_initialised = true;
 
 	return 0;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 16aa4875ddb8..25e9a94f6d76 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -18,6 +18,8 @@ unsigned long __icache_flags;
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
+unsigned int kvm_host_sve_max_vl;
+
 /*
  * Set trap register values based on features in ID_AA64PFR0.
  */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 859f22f754d3..3fae42479598 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -67,6 +67,28 @@ static int divide_memory_pool(void *virt, unsigned long size)
 	return 0;
 }
 
+static int pkvm_create_host_sve_mappings(void)
+{
+	void *start, *end;
+	int ret, i;
+
+	if (!system_supports_sve())
+		return 0;
+
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		struct kvm_host_data *host_data = per_cpu_ptr(&kvm_host_data, i);
+		struct cpu_sve_state *sve_state = host_data->sve_state;
+
+		start = kern_hyp_va(sve_state);
+		end = start + PAGE_ALIGN(pkvm_host_sve_state_size());
+		ret = pkvm_create_mappings(start, end, PAGE_HYP);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 				 unsigned long *per_cpu_base,
 				 u32 hyp_va_bits)
@@ -125,6 +147,8 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 			return ret;
 	}
 
+	pkvm_create_host_sve_mappings();
+
 	/*
 	 * Map the host sections RO in the hypervisor, but transfer the
 	 * ownership from the host to the hypervisor itself to make sure they
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 1b7b58cb121f..3fc8ca164dbe 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -32,6 +32,7 @@
 
 /* Maximum phys_shift supported for any VM on this host */
 static u32 __ro_after_init kvm_ipa_limit;
+unsigned int __ro_after_init kvm_host_sve_max_vl;
 
 /*
  * ARMv8 Reset Values
@@ -51,6 +52,8 @@ int __init kvm_arm_init_sve(void)
 {
 	if (system_supports_sve()) {
 		kvm_sve_max_vl = sve_max_virtualisable_vl();
+		kvm_host_sve_max_vl = sve_max_vl();
+		kvm_nvhe_sym(kvm_host_sve_max_vl) = kvm_host_sve_max_vl;
 
 		/*
 		 * The get_sve_reg()/set_sve_reg() ioctl interface will need
-- 
2.45.1.288.g0e0cd299f1-goog

