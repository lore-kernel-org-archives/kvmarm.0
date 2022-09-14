Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C57ECAAD3
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 08:36:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B2E44BC59;
	Wed, 14 Sep 2022 04:36:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g1K0O43M0etA; Wed, 14 Sep 2022 04:36:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEC054BC52;
	Wed, 14 Sep 2022 04:36:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A275F4BC0D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hr6Se4h4j-XB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 04:36:14 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 427A84BC08
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:14 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id BECBD61934;
 Wed, 14 Sep 2022 08:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DDFC433D7;
 Wed, 14 Sep 2022 08:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663144573;
 bh=+ewCsnrdNhV0AzcfOXHfzK18Mu/Wv5i811rz22Ijlkc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=h/jl6iKJO0TYOkHJbji70HNTepQgFfrbBPiMRCqAXVEzbRELMj0kgqc3js4Y/kbc2
 9oWgtl5fvN5PahPQnEiVacsYMrAd6vLJb0z42HTBr7XIvqi/+/OBt3QL61qRexPrto
 ejXftK3yxrMthTWw9nHz9CL5RYgM0PNe8hZpYOljJWWhReTxWgDEZYne0m4487ErGu
 8azs8UFxVfh734Gl483pSi7mJjJjN6sgO8fOQc+y5QbEfOAEWybJVRxrmTk8bKRURx
 JJolhQAfjJa4b4sS6a2Bc2aMTeaIVXHu4+XgYuzzep+4xlRSp972bxJA5oqtXJao5z
 4bwoL0UVA1GCA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 18/25] KVM: arm64: Consolidate stage-2 initialisation into
 a single function
Date: Wed, 14 Sep 2022 09:34:53 +0100
Message-Id: <20220914083500.5118-19-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
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

From: Quentin Perret <qperret@google.com>

The initialisation of guest stage-2 page-tables is currently split
across two functions: kvm_init_stage2_mmu() and kvm_arm_setup_stage2().
That is presumably for historical reasons as kvm_arm_setup_stage2()
originates from the (now defunct) KVM port for 32-bit Arm.

Simplify this code path by merging both functions into one, taking care
to map the 'struct kvm' into the hypervisor stage-1 early on in order to
simplify the failure path.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h  |  2 +-
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/include/asm/kvm_mmu.h  |  2 +-
 arch/arm64/kvm/arm.c              | 27 +++++++++++++--------------
 arch/arm64/kvm/mmu.c              | 27 ++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c            | 29 -----------------------------
 6 files changed, 41 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8aa8492dafc0..89e63585dae4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -135,7 +135,7 @@
  * 40 bits wide (T0SZ = 24).  Systems with a PARange smaller than 40 bits are
  * not known to exist and will break with this configuration.
  *
- * The VTCR_EL2 is configured per VM and is initialised in kvm_arm_setup_stage2().
+ * The VTCR_EL2 is configured per VM and is initialised in kvm_init_stage2_mmu.
  *
  * Note that when using 4K pages, we concatenate two first level page tables
  * together. With 16K pages, we concatenate 16 first level page tables.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1f2933f0f687..93f25231b247 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -987,8 +987,6 @@ int kvm_set_ipa_limit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 
-int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
-
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b208da3bebec..b5320da8544c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -165,7 +165,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
-int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
+int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 23fa39c243eb..f5be9241479a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -139,28 +139,24 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
-	ret = kvm_arm_setup_stage2(kvm, type);
-	if (ret)
-		return ret;
-
-	ret = kvm_init_stage2_mmu(kvm, &kvm->arch.mmu);
-	if (ret)
-		return ret;
-
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
-		goto out_free_stage2_pgd;
+		return ret;
 
 	ret = pkvm_init_host_vm(kvm);
 	if (ret)
-		goto out_free_stage2_pgd;
+		goto err_unshare_kvm;
 
 	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
 		ret = -ENOMEM;
-		goto out_free_stage2_pgd;
+		goto err_unshare_kvm;
 	}
 	cpumask_copy(kvm->arch.supported_cpus, cpu_possible_mask);
 
+	ret = kvm_init_stage2_mmu(kvm, &kvm->arch.mmu, type);
+	if (ret)
+		goto err_free_cpumask;
+
 	kvm_vgic_early_init(kvm);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
@@ -169,9 +165,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
 
-	return ret;
-out_free_stage2_pgd:
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	return 0;
+
+err_free_cpumask:
+	free_cpumask_var(kvm->arch.supported_cpus);
+err_unshare_kvm:
+	kvm_unshare_hyp(kvm, kvm + 1);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6dc658b9d75d..4b24e9e1e96b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -640,15 +640,40 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
  * kvm_init_stage2_mmu - Initialise a S2 MMU structure
  * @kvm:	The pointer to the KVM structure
  * @mmu:	The pointer to the s2 MMU structure
+ * @type:	The machine type of the virtual machine
  *
  * Allocates only the stage-2 HW PGD level table(s).
  * Note we don't need locking here as this is only called when the VM is
  * created, which can only be done once.
  */
-int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
+int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type)
 {
+	u32 kvm_ipa_limit = get_kvm_ipa_limit();
 	int cpu, err;
 	struct kvm_pgtable *pgt;
+	u64 mmfr0, mmfr1;
+	u32 phys_shift;
+
+	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+		return -EINVAL;
+
+	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
+	if (phys_shift) {
+		if (phys_shift > kvm_ipa_limit ||
+		    phys_shift < ARM64_MIN_PARANGE_BITS)
+			return -EINVAL;
+	} else {
+		phys_shift = KVM_PHYS_SHIFT;
+		if (phys_shift > kvm_ipa_limit) {
+			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
+				     current->comm);
+			return -EINVAL;
+		}
+	}
+
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	kvm->arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
 
 	if (mmu->pgt != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 0e08fbe68715..1522edf71a32 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -395,32 +395,3 @@ int kvm_set_ipa_limit(void)
 
 	return 0;
 }
-
-int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
-{
-	u64 mmfr0, mmfr1;
-	u32 phys_shift;
-
-	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
-		return -EINVAL;
-
-	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
-	if (phys_shift) {
-		if (phys_shift > kvm_ipa_limit ||
-		    phys_shift < ARM64_MIN_PARANGE_BITS)
-			return -EINVAL;
-	} else {
-		phys_shift = KVM_PHYS_SHIFT;
-		if (phys_shift > kvm_ipa_limit) {
-			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
-				     current->comm);
-			return -EINVAL;
-		}
-	}
-
-	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
-	kvm->arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
-
-	return 0;
-}
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
