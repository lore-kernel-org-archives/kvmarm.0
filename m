Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E456177118
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 12:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417748; cv=none; b=gcr/G/o4EN08ZyjcVRwNeMee5pZYLc0COZ7ZOXamYqkq/rvk5irZQNYfZvHlr/sGbZcgymTILh0FggUX0m93LIKXDx8teqoMYkcrHaxtaCvuk7FkTVdaj18Z2JHSh8ajVRRegjXjAC1OrKuf+E0Gus8KpPZZi9XsPa4WO/gGZTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417748; c=relaxed/simple;
	bh=tkMipP+WRiCgQLdDzoQ91/ANsflp42xOcclERoPxV9E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a4j83f2TqIy0sMG03/w6UGYFtVHM54rHutH08ZytW1us9wwqW9AtDTLHS/IDMFEQzl7T95MomPMi2Ki3yJFXEEPCQcpOw2UunSGPDjQ4zrdJ/7hZiLhUYJEnCMpXK491S2aOih6r7rcvuyZOAlFj2Gc1Ld+4zHMPaOMALAg0uug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wePEMK8y; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wePEMK8y"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a50486746so63872097b3.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 05:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717417746; x=1718022546; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sTGa9ee7kynB2kUFXCQX/oU7GfoCHwTJqszwqlMKQJI=;
        b=wePEMK8y19q58Z0+vWTAZW99W6dJONJWHfuzkUOLA+31hj37dseGi1sVsT6Ts0LlRK
         PbSjl9LbrzPJrfScOnG4yQXrJAYSYTWk/IlA1xhcxU9zHKkxJ+5WtIuSaNBqsZVrfdBe
         zoNakBhGtVnpwtNfjXRvwdez4TJfoFnmexjTGk/R9vKQ82VgZ2Gp+lhhtpKBj3FDMXss
         6c2thRj6KrDGvk3n8nDDeXXOL1W98u/G1jTsxfIrIG4eg+ti2p08RGLSH9/miRcZt7NY
         KruRNMQe9WmYxhVHdAiP9y8NZshhUesV0vRvZ5SykR6X9rK/hG9aedQo1uiH7fjq7H4N
         AbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417746; x=1718022546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sTGa9ee7kynB2kUFXCQX/oU7GfoCHwTJqszwqlMKQJI=;
        b=Jil3b/oORL4mOsHUkAcCFixRgoTWkrpfdpAft9LKrOW6bjIKt6k3Rdp5ViGM4VHM7h
         pA2f78Af9hw6SjL8jwZmaO4+rQnELJS+QOjXsLmo4gNLMzu/aSq2XXIs3TjzW7wp5T2U
         z5+r48pvMVybjwNKxgEHfSRqHOjzL5MpgIfkJw5CBiuwn7D4EBmFni/Q4aKXNGF+hj/3
         2gX7vYlWLhTolE6SGEIOtQDwZfPT3vX4i4JFvN4ei/drgva2wCwpW1fL7xe+bagdS+E0
         KSx1xtYkbPzMApaJw5bu+oTMz6cVtFtWf72pYMpvbcN4uDMbOPDGq9Dlmd7HpiFKn1MY
         zvoQ==
X-Gm-Message-State: AOJu0Yy/ANpDE5i8d8sSvUTBp2eBuLozSpIXPApjou6V1bsW/CN+H73E
	36eeiFtG+970jng3hb2+w+m4lTamy+n87I1DkUrYLEHX3luHGkwnCWmEDCJm+CyRhNakGjTC8LU
	kgpKaqL79Qsl/TOSNrrT22P70fa6ls9HaACvKCMdoi6Bc0EPQ4Ou6yZVzFC7+aLkhV0kMZghx8s
	qM8n6Ff5O8/nyOOuwnZCRab/oF+8g=
X-Google-Smtp-Source: AGHT+IHMoqxkEn2XGo8mFMt6fgtaL2wxrhhVjaZ/6mDl0LTeqap9t8imXZRJL3eneuWbSaUiHFbdnBPU9g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:660c:b0:627:8b31:e81 with SMTP id
 00721157ae682-62c797bae26mr28259407b3.5.1717417745867; Mon, 03 Jun 2024
 05:29:05 -0700 (PDT)
Date: Mon,  3 Jun 2024 13:28:47 +0100
In-Reply-To: <20240603122852.3923848-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240603122852.3923848-6-tabba@google.com>
Subject: [PATCH v4 5/9] KVM: arm64: Allocate memory mapped at hyp for host sve
 state in pKVM
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

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
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
index 686cce7e4e96..b05bceca3385 100644
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

