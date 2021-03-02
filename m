Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B50CC433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B525964F3F
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B525964F3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 618E74B658;
	Tue,  2 Mar 2021 10:00:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bc8MSbyfiM13; Tue,  2 Mar 2021 10:00:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B25B74B680;
	Tue,  2 Mar 2021 10:00:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CE714B0C8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ETuXB5PPWTZP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:43 -0500 (EST)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27E664B645
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:43 -0500 (EST)
Received: by mail-qv1-f73.google.com with SMTP id k4so15135313qvf.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=SyC2r4edwP6B0yWtbCjHDwPrvUJOrNqhRtLgavKZNac=;
 b=Xqn+6oZNaHl/40KM2Wc7bBy6MtV4gYKmvgdRk9bfP4ZmCUU/VF963mPFlkvVo7js/2
 WzTtK8XXLsS0Mh+FthXr84xC+sK+FgUR9E8U6H0sj3d+Yhx2MmfPoIrkiQnEwHKt+R0g
 BZ+hTNkISFQA8VAnEaUu7+ipW1hpl+g9zUpTDiAzQ7n5AeUOt+XoGmTmNXjSVC4i5tsv
 ZtFm2HZF7Omdgi2JPr1Ca8X55ToX+ug8EzyMPVPwQ18uocaj7msXq8q23ry1OBeiy2Ob
 fFc3r8b6O6F0Fw2srPJMBAWfzi8EyIR3Zt7fs++XsQGAzevRU5xo1Sf61aTKkN5cprwp
 XX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SyC2r4edwP6B0yWtbCjHDwPrvUJOrNqhRtLgavKZNac=;
 b=Lv6yZvudjAvWDcuWmnY1jbxSOjGsNkuHx/EOi1uzUyy4uMH7AiCIfncMorXO3Gkes8
 3inuFDWIkcA8EnMT0o2tw8bmdKkfQ7OsFWq79QNvC9AxzfGNga9cUPHd48YHA1UqADZW
 xTQTf9jLFvOCHNrYzaRt2L3SmrksJ0WuWK4oUbzqR1jrRlxFy9I7MjhZu3OYDiFKSvVL
 mhVCt/Hq0wotgpP9aVj5j/mmrNmLIQRjDqqDVqrjeAJ03l6U2QR1I1X00hV3vpBXMHEw
 Q6628/+PEFzOg0NCYPPyldIybkJfwceVbxYaV4+H0DuB+HZfEorO5CXaGE73E+GDf6f3
 hC3Q==
X-Gm-Message-State: AOAM531/vdTnv3dIDlipvTZGSHtVrKh98Mrmj//MmL6QTl1ovZyeP4cC
 lCHaY6vEIOG9NImZdta+2hdmPXewVH8X
X-Google-Smtp-Source: ABdhPJw7QYqL2U7XfAj+Gjs6VA7D5Zu5g4S0ut2jMfRdsJ2Foi4hzz5d401xlIBhBsaM1dnO3TcsvNZU9z2v
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:ea29:: with SMTP id
 t9mr3984058qvp.52.1614697242537; Tue, 02 Mar 2021 07:00:42 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:46 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-17-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 16/32] KVM: arm64: Elevate hypervisor mappings creation at
 EL2
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

Previous commits have introduced infrastructure to enable the EL2 code
to manage its own stage 1 mappings. However, this was preliminary work,
and none of it is currently in use.

Put all of this together by elevating the mapping creation at EL2 when
memory protection is enabled. In this case, the host kernel running
at EL1 still creates _temporary_ EL2 mappings, only used while
initializing the hypervisor, but frees them right after.

As such, all calls to create_hyp_mappings() after kvm init has finished
turn into hypercalls, as the host now has no 'legal' way to modify the
hypevisor page tables directly.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  2 +-
 arch/arm64/kvm/arm.c             | 87 +++++++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c             | 43 ++++++++++++++--
 3 files changed, 120 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 5c42ec023cc7..ce02a4052dcf 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -166,7 +166,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
-int kvm_mmu_init(void);
+int kvm_mmu_init(u32 *hyp_va_bits);
 
 static inline void *__kvm_vector_slot2addr(void *base,
 					   enum arm64_hyp_spectre_vector slot)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 26e573cdede3..5a97abdc3ba6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1421,7 +1421,7 @@ static void cpu_prepare_hyp_mode(int cpu)
 	kvm_flush_dcache_to_poc(params, sizeof(*params));
 }
 
-static void cpu_init_hyp_mode(void)
+static void hyp_install_host_vector(void)
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
+	hyp_install_host_vector();
 
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
@@ -1691,18 +1700,59 @@ static void teardown_hyp_mode(void)
 	}
 }
 
+static int do_pkvm_init(u32 hyp_va_bits)
+{
+	void *per_cpu_base = kvm_ksym_ref(kvm_arm_hyp_percpu_base);
+	int ret;
+
+	preempt_disable();
+	hyp_install_host_vector();
+	ret = kvm_call_hyp_nvhe(__pkvm_init, hyp_mem_base, hyp_mem_size,
+				num_possible_cpus(), kern_hyp_va(per_cpu_base),
+				hyp_va_bits);
+	preempt_enable();
+
+	return ret;
+}
+
+static int kvm_hyp_init_protection(u32 hyp_va_bits)
+{
+	void *addr = phys_to_virt(hyp_mem_base);
+	int ret;
+
+	ret = create_hyp_mappings(addr, addr + hyp_mem_size, PAGE_HYP);
+	if (ret)
+		return ret;
+
+	ret = do_pkvm_init(hyp_va_bits);
+	if (ret)
+		return ret;
+
+	free_hyp_pgds();
+
+	return 0;
+}
+
 /**
  * Inits Hyp-mode on all online CPUs
  */
 static int init_hyp_mode(void)
 {
+	u32 hyp_va_bits;
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
 	 * Allocate Hyp PGD and setup Hyp identity mapping
 	 */
-	err = kvm_mmu_init();
+	err = kvm_mmu_init(&hyp_va_bits);
 	if (err)
 		goto out_err;
 
@@ -1818,6 +1868,14 @@ static int init_hyp_mode(void)
 			goto out_err;
 	}
 
+	if (is_protected_kvm_enabled()) {
+		err = kvm_hyp_init_protection(hyp_va_bits);
+		if (err) {
+			kvm_err("Failed to init hyp memory protection\n");
+			goto out_err;
+		}
+	}
+
 	return 0;
 
 out_err:
@@ -1826,6 +1884,16 @@ static int init_hyp_mode(void)
 	return err;
 }
 
+static int finalize_hyp_mode(void)
+{
+	if (!is_protected_kvm_enabled())
+		return 0;
+
+	static_branch_enable(&kvm_protected_mode_initialized);
+
+	return 0;
+}
+
 static void check_kvm_target_cpu(void *ret)
 {
 	*(int *)ret = kvm_target_cpu();
@@ -1942,8 +2010,15 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		goto out_hyp;
 
+	if (!in_hyp_mode) {
+		err = finalize_hyp_mode();
+		if (err) {
+			kvm_err("Failed to finalize Hyp protection\n");
+			goto out_hyp;
+		}
+	}
+
 	if (is_protected_kvm_enabled()) {
-		static_branch_enable(&kvm_protected_mode_initialized);
 		kvm_info("Protected nVHE mode initialized successfully\n");
 	} else if (in_hyp_mode) {
 		kvm_info("VHE mode initialized successfully\n");
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4d41d7838d53..9d331bf262d2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -221,15 +221,39 @@ void free_hyp_pgds(void)
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
+	WARN_ON(!hyp_pgtable);
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
@@ -291,6 +315,16 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	unsigned long base;
 	int ret = 0;
 
+	if (!kvm_host_owns_hyp_mappings()) {
+		base = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
+					 phys_addr, size, prot);
+		if (IS_ERR_OR_NULL((void *)base))
+			return PTR_ERR((void *)base);
+		*haddr = base;
+
+		return 0;
+	}
+
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
 	/*
@@ -1270,10 +1304,9 @@ static struct kvm_pgtable_mm_ops kvm_hyp_mm_ops = {
 	.virt_to_phys		= kvm_host_pa,
 };
 
-int kvm_mmu_init(void)
+int kvm_mmu_init(u32 *hyp_va_bits)
 {
 	int err;
-	u32 hyp_va_bits;
 
 	hyp_idmap_start = __pa_symbol(__hyp_idmap_text_start);
 	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
@@ -1287,8 +1320,8 @@ int kvm_mmu_init(void)
 	 */
 	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
 
-	hyp_va_bits = 64 - ((idmap_t0sz & TCR_T0SZ_MASK) >> TCR_T0SZ_OFFSET);
-	kvm_debug("Using %u-bit virtual addresses at EL2\n", hyp_va_bits);
+	*hyp_va_bits = 64 - ((idmap_t0sz & TCR_T0SZ_MASK) >> TCR_T0SZ_OFFSET);
+	kvm_debug("Using %u-bit virtual addresses at EL2\n", *hyp_va_bits);
 	kvm_debug("IDMAP page: %lx\n", hyp_idmap_start);
 	kvm_debug("HYP VA range: %lx:%lx\n",
 		  kern_hyp_va(PAGE_OFFSET),
@@ -1313,7 +1346,7 @@ int kvm_mmu_init(void)
 		goto out;
 	}
 
-	err = kvm_pgtable_hyp_init(hyp_pgtable, hyp_va_bits, &kvm_hyp_mm_ops);
+	err = kvm_pgtable_hyp_init(hyp_pgtable, *hyp_va_bits, &kvm_hyp_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
