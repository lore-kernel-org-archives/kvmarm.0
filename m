Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D004FC433E6
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4870A2399A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4870A2399A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC2654B370;
	Fri,  8 Jan 2021 07:16:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C8gDp5tIGC2n; Fri,  8 Jan 2021 07:16:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 543644B3E6;
	Fri,  8 Jan 2021 07:16:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA3434B3E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HPS3xU12B036 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:16:03 -0500 (EST)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 405A74B3DD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:03 -0500 (EST)
Received: by mail-qv1-f74.google.com with SMTP id l3so8089052qvr.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=/oJOiodTmUn3adVtPGhw7M8zv8JCp37BW1nUJ/LMPTQ=;
 b=pU/9SM07gIQWUokQHD3qTj/NffUXCMLsM8TsFEn4oVEVeZPwQv+BFOZFalEFokXz6m
 kebX9OWnC7Ufx8YeV5eb2zUbyi2hDbPPOsnyH+9qSOApc6p+Wl1Na1hoVzx/LRIXJ52f
 U2FNQrVVHJgMRVlcsycw6jGoo8I4B3KKr584MmnydYCeH/D3TXeZB9nzMvXB8+cJ6FEP
 vooAmBFoUQci3tycOUbChjhEypy8Yifjabxebh2m5fIDJQ7vigXwCb38PZk6kKpVK90X
 cqGoUojnqYzUoItkHpdGgVO16Rafonm42FcVi46NZNkrSW5TPUtN7G880l7qgTpGuXAB
 Ns6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/oJOiodTmUn3adVtPGhw7M8zv8JCp37BW1nUJ/LMPTQ=;
 b=j9GdSteJ3chRwV2xnMzvFgWb9BiHCYEzrIeH8x/xVK8+eIVnrH/uyZvxbtFWLZRTIc
 5FUIMhDObwGC2GgHftTywY6fwbGiRaOxZzBdFoX9pn4h2HHJ5xJg7XPgADn3a/0Apm/n
 tUmW8JeN2IVIg8rvZ2OBtEBO7d5ZMOZVfY/bvy5m/uzNI5Ngyj0HXCAzgAQ4ztbLVOkb
 UkQxWRXr1cdOqHlo0l011XFog5QjvJk8G2XYMKLmJxhE8USl7VXiP5iOg7UNm0edID+Y
 9eMq+BicqUGOOaqCbUg+qnkTmXNZ5oGulzd1orEBlnCR60qW8fTfdOGDeWyQsA/+oF1S
 EYAg==
X-Gm-Message-State: AOAM533PxGcb1fItYpv98QuCoFNo4j2cMtRyRBxNOravarb+GiwvS/Ip
 8p1P/wBQpu+WOmhDROuEuTbBRE8quOOp
X-Google-Smtp-Source: ABdhPJzgKPDINojiI0dbVwoX+0TC5gHxTs7z5Z+8Zygu+vvUzA255jllaF6UbGDN3Gp4kXcFpUe67wJWaUvz
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:da07:: with SMTP id
 x7mr6289768qvj.39.1610108162797; Fri, 08 Jan 2021 04:16:02 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:15 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-18-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 17/26] KVM: arm64: Elevate Hyp mappings creation at EL2
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Previous commits have introduced infrastructure at EL2 to enable the Hyp
code to manage its own memory, and more specifically its stage 1 page
tables. However, this was preliminary work, and none of it is currently
in use.

Put all of this together by elevating the hyp mappings creation at EL2
when memory protection is enabled. In this case, the host kernel running
at EL1 still creates _temporary_ Hyp mappings, only used while
initializing the hypervisor, but frees them right after.

As such, all calls to create_hyp_mappings() after kvm init has finished
turn into hypercalls, as the host now has no 'legal' way to modify the
hypevisor page tables directly.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  1 -
 arch/arm64/kvm/arm.c             | 62 +++++++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c             | 34 ++++++++++++++++++
 3 files changed, 92 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index d7ebd73ec86f..6c8466a042a9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -309,6 +309,5 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
 	 */
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
-
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6af9204bcd5b..e524682c2ccf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1421,7 +1421,7 @@ static void cpu_prepare_hyp_mode(int cpu)
 	kvm_flush_dcache_to_poc(params, sizeof(*params));
 }
 
-static void cpu_init_hyp_mode(void)
+static void kvm_set_hyp_vector(void)
 {
 	struct kvm_nvhe_init_params *params;
 	struct arm_smccc_res res;
@@ -1439,6 +1439,11 @@ static void cpu_init_hyp_mode(void)
 	params = this_cpu_ptr_nvhe_sym(kvm_init_params);
 	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init), virt_to_phys(params), &res);
 	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
+}
+
+static void cpu_init_hyp_mode(void)
+{
+	kvm_set_hyp_vector();
 
 	/*
 	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
@@ -1481,7 +1486,10 @@ static void cpu_set_hyp_vector(void)
 	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
 	void *vector = hyp_spectre_vector_selector[data->slot];
 
-	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vector;
+	if (!is_protected_kvm_enabled())
+		*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vector;
+	else
+		kvm_call_hyp_nvhe(__pkvm_cpu_set_vector, data->slot);
 }
 
 static void cpu_hyp_reinit(void)
@@ -1489,13 +1497,14 @@ static void cpu_hyp_reinit(void)
 	kvm_init_host_cpu_context(&this_cpu_ptr_hyp_sym(kvm_host_data)->host_ctxt);
 
 	cpu_hyp_reset();
-	cpu_set_hyp_vector();
 
 	if (is_kernel_in_hyp_mode())
 		kvm_timer_init_vhe();
 	else
 		cpu_init_hyp_mode();
 
+	cpu_set_hyp_vector();
+
 	kvm_arm_init_debug();
 
 	if (vgic_present)
@@ -1714,13 +1723,52 @@ static int copy_cpu_ftr_regs(void)
 	return 0;
 }
 
+static int kvm_hyp_enable_protection(void)
+{
+	void *per_cpu_base = kvm_ksym_ref(kvm_arm_hyp_percpu_base);
+	int ret, cpu;
+	void *addr;
+
+	if (!is_protected_kvm_enabled())
+		return 0;
+
+	if (!hyp_mem_base)
+		return -ENOMEM;
+
+	addr = phys_to_virt(hyp_mem_base);
+	ret = create_hyp_mappings(addr, addr + hyp_mem_size - 1, PAGE_HYP);
+	if (ret)
+		return ret;
+
+	preempt_disable();
+	kvm_set_hyp_vector();
+	ret = kvm_call_hyp_nvhe(__pkvm_init, hyp_mem_base, hyp_mem_size,
+				num_possible_cpus(), kern_hyp_va(per_cpu_base));
+	preempt_enable();
+	if (ret)
+		return ret;
+
+	free_hyp_pgds();
+	for_each_possible_cpu(cpu)
+		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+
+	return 0;
+}
+
 /**
  * Inits Hyp-mode on all online CPUs
  */
 static int init_hyp_mode(void)
 {
 	int cpu;
-	int err = 0;
+	int err = -ENOMEM;
+
+	/*
+	 * The protected Hyp-mode cannot be initialized if the memory pool
+	 * allocation has failed.
+	 */
+	if (is_protected_kvm_enabled() && !hyp_mem_base)
+		return err;
 
 	/*
 	 * Copy the required CPU feature register in their EL2 counterpart
@@ -1854,6 +1902,12 @@ static int init_hyp_mode(void)
 	for_each_possible_cpu(cpu)
 		cpu_prepare_hyp_mode(cpu);
 
+	err = kvm_hyp_enable_protection();
+	if (err) {
+		kvm_err("Failed to enable hyp memory protection: %d\n", err);
+		goto out_err;
+	}
+
 	return 0;
 
 out_err:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3cf9397dabdb..9d4c9251208e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -225,15 +225,39 @@ void free_hyp_pgds(void)
 	if (hyp_pgtable) {
 		kvm_pgtable_hyp_destroy(hyp_pgtable);
 		kfree(hyp_pgtable);
+		hyp_pgtable = NULL;
 	}
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 }
 
+static bool kvm_host_owns_hyp_mappings(void)
+{
+	if (static_branch_likely(&kvm_protected_mode_initialized))
+		return false;
+
+	/*
+	 * This can happen at boot time when __create_hyp_mappings() is called
+	 * after the hyp protection has been enabled, but the static key has
+	 * not been flipped yet.
+	 */
+	if (!hyp_pgtable && is_protected_kvm_enabled())
+		return false;
+
+	BUG_ON(!hyp_pgtable);
+
+	return true;
+}
+
 static int __create_hyp_mappings(unsigned long start, unsigned long size,
 				 unsigned long phys, enum kvm_pgtable_prot prot)
 {
 	int err;
 
+	if (!kvm_host_owns_hyp_mappings()) {
+		return kvm_call_hyp_nvhe(__pkvm_create_mappings,
+					 start, size, phys, prot);
+	}
+
 	mutex_lock(&kvm_hyp_pgd_mutex);
 	err = kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
 	mutex_unlock(&kvm_hyp_pgd_mutex);
@@ -295,6 +319,16 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	unsigned long base;
 	int ret = 0;
 
+	if (!kvm_host_owns_hyp_mappings()) {
+		base = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
+					 phys_addr, size, prot);
+		if (!base)
+			return -ENOMEM;
+		*haddr = base;
+
+		return 0;
+	}
+
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
 	/*
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
