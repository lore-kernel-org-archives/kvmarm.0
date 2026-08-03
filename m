Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18393423A85;
	Mon,  3 Aug 2026 13:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764726; cv=none; b=oebrnqA5FK6wR59XoXsQk62xe4Kyw9ZLshVo2PyVMmMu2Noz0byikUvSyvgHbZfUR4wIR2v0lkva/Whhwur4H7pdZbg1tMHuCZtm2fGBSHsr41Y92jcrZbrWjncCBtQYnwXwtL2DQlffHiRqXLsBwojisfnJ1F2zxDOESkrF0gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764726; c=relaxed/simple;
	bh=RIL7oE0ereG/ijnO1qlh3vLGborUE/e/mQqj+8n28ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+V6q3bV2fuGlupF0/T1L0Cemtd0oSIiJZgj0coh39KyfLZJRY/OnBvE9q19vVTMwEDb7CYeWCywLdYwt1jw3DAwlXAwAXWmIZB7df/oSCnO2aWIUprfRYNZ+2v/HGCj4Mtz2yxoZ6sanHI1Y1y28dNeqC4MbCfyhntQdR3iDGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=E1flnbaT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="E1flnbaT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DF2C1596;
	Mon,  3 Aug 2026 06:45:19 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E53543F66F;
	Mon,  3 Aug 2026 06:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764723; bh=RIL7oE0ereG/ijnO1qlh3vLGborUE/e/mQqj+8n28ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1flnbaTU10dNTMlHlP8atUzPqGKrWFfsJu17NHHVHjllmF1uhH5v2l4FsY8bhMRy
	 MufHKdsuM4Kv0d+8miOT519XjVSRBjLIdkiGpyKb9+fZsvE5wEvXk+PPGBTX3aioMj
	 549iiMShhWl0aSsxYKAcOCFmZ21mQGtD7AtyNyGU=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 14/45] KVM: arm64: CCA: Add basic infrastructure for creating a realm
Date: Mon,  3 Aug 2026 14:43:30 +0100
Message-ID: <20260803134403.80630-15-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the skeleton functions for creating and destroying a realm.
The IPA size requested is checked against what the RMM supports.

The actual work of constructing the realm will be added in future
patches.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Remove realm->params and only temporarily allocate the page when the
   realm is being created.
Changes since v14:
 * Adapt to the RMM v2.0-bet2 realm parameter layout and SRO-based realm
   creation.
Changes since v13:
 * Rebased and updated to RMM-v2.0-bet1.
 * Auxiliary granules have been removed in RMM-v2.0-bet1
Changes since v12:
 * Drop the RMM_PAGE_{SHIFT,SIZE} defines - the RMM is now configured to
   be the same as the host's page size.
 * Rework delegate/undelegate functions to use the new RMI range based
   operations.
Changes since v11:
 * Major rework to drop the realm configuration and make the
   construction of realms implicit rather than driven by the VMM
   directly.
 * The code to create RDs, handle VMIDs etc is moved to later patches.
Changes since v10:
 * Rename from RME to RMI.
 * Move the stage2 cleanup to a later patch.
Changes since v9:
 * Avoid walking the stage 2 page tables when destroying the realm -
   the real ones are not accessible to the non-secure world, and the RMM
   may leave junk in the physical pages when returning them.
 * Fix an error path in realm_create_rd() to actually return an error value.
Changes since v8:
 * Fix free_delegated_granule() to not call kvm_account_pgtable_pages();
   a separate wrapper will be introduced in a later patch to deal with
   RTTs.
 * Minor code cleanups following review.
Changes since v7:
 * Minor code cleanup following Gavin's review.
Changes since v6:
 * Separate RMM RTT calculations from host PAGE_SIZE. This allows the
   host page size to be larger than 4k while still communicating with an
   RMM which uses 4k granules.
Changes since v5:
 * Introduce free_delegated_granule() to replace many
   undelegate/free_page() instances and centralise the comment on
   leaking when the undelegate fails.
 * Several other minor improvements suggested by reviews - thanks for
   the feedback!
Changes since v2:
 * Improved commit description.
 * Improved return failures for rmi_check_version().
 * Clear contents of PGD after it has been undelegated in case the RMM
   left stale data.
 * Minor changes to reflect changes in previous patches.
---
 arch/arm64/include/asm/kvm_emulate.h | 24 +++++++++++
 arch/arm64/include/asm/kvm_rmi.h     | 63 ++++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c                 | 12 ++++++
 arch/arm64/kvm/mmu.c                 | 18 +++++++-
 arch/arm64/kvm/rmi.c                 | 56 +++++++++++++++++++++++++
 5 files changed, 171 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c..e26d6755279f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -688,4 +688,28 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
 	}
 }
+
+static inline bool kvm_is_realm(struct kvm *kvm)
+{
+	if (static_branch_unlikely(&kvm_rmi_is_available))
+		return kvm->arch.is_realm;
+	return false;
+}
+
+static inline enum realm_state kvm_realm_state(struct kvm *kvm)
+{
+	return READ_ONCE(kvm->arch.realm.state);
+}
+
+static inline void kvm_set_realm_state(struct kvm *kvm,
+				       enum realm_state new_state)
+{
+	WRITE_ONCE(kvm->arch.realm.state, new_state);
+}
+
+static inline bool kvm_realm_is_created(struct kvm *kvm)
+{
+	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 57d24b244c95..cefd00b76806 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -6,12 +6,75 @@
 #ifndef __ASM_KVM_RMI_H
 #define __ASM_KVM_RMI_H
 
+#include <linux/arm-smccc-rmi.h>
+
+/**
+ * enum realm_state - State of a Realm
+ *
+ * Mirrors the RMM's Realm lifecycle states where they are meaningful to KVM,
+ * with REALM_STATE_DYING being a KVM-internal state used to prevent further
+ * requests while teardown is in progress. KVM does not track REALM_SYSTEM_OFF
+ * or REALM_ZOMBIE separately as they naturally lead to teardown.
+ */
+enum realm_state {
+	/**
+	 * @REALM_STATE_NONE:
+	 *      Realm has not yet been created. rmi_realm_create() has not
+	 *      yet been called.
+	 */
+	REALM_STATE_NONE,
+	/**
+	 * @REALM_STATE_NEW:
+	 *      Realm is under construction, rmi_realm_create() has been
+	 *      called, but it is not yet activated. Pages may be populated.
+	 */
+	REALM_STATE_NEW,
+	/**
+	 * @REALM_STATE_ACTIVE:
+	 *      Realm has been created and is eligible for execution with
+	 *      rmi_rec_enter(). Pages may no longer be populated with
+	 *      rmi_data_create().
+	 */
+	REALM_STATE_ACTIVE,
+	/**
+	 * @REALM_STATE_DYING:
+	 *      Realm is in the process of being destroyed or has already been
+	 *      destroyed.
+	 */
+	REALM_STATE_DYING,
+	/**
+	 * @REALM_STATE_DEAD:
+	 *      Realm has been destroyed.
+	 */
+	REALM_STATE_DEAD
+};
+
 /**
  * struct realm - Additional per VM data for a Realm
+ *
+ * @rd: Kernel mapping of the RMM-managed Realm Descriptor (RD) granule
+ * @sro: Preallocated SRO state context for Realm MMU operations
+ * @state: The lifetime state machine for the realm
+ * @ia_bits: Number of valid Input Address bits in the IPA
  */
 struct realm {
+	void *rd;
+	/*
+	 * Reused by RTT map/unmap SRO commands. Those commands are only
+	 * issued from Realm stage-2 map/unmap paths while kvm->mmu_lock is
+	 * held for write, including Realm fault handling where
+	 * kvm_fault_lock() takes the write side, so concurrent use is
+	 * serialized.
+	 */
+	struct rmi_sro_state *sro;
+	enum realm_state state;
+	unsigned int ia_bits;
 };
 
 void kvm_init_rmi(void);
+u32 kvm_rmm_ipa_limit(void);
+
+int kvm_init_realm(struct kvm *kvm);
+void kvm_destroy_realm(struct kvm *kvm);
 
 #endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b961c22fce3d..c4d906861736 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -266,6 +266,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
 
+	/* Initialise the realm bits after the generic bits are enabled */
+	if (kvm_is_realm(kvm)) {
+		ret = kvm_init_realm(kvm);
+		if (ret)
+			goto err_uninit_mmu;
+	}
+
 	return 0;
 
 err_uninit_mmu:
@@ -328,6 +335,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_unshare_hyp(kvm, kvm + 1);
 
 	kvm_arm_teardown_hypercalls(kvm);
+	if (kvm_is_realm(kvm))
+		kvm_destroy_realm(kvm);
 }
 
 static bool kvm_has_full_ptr_auth(void)
@@ -488,6 +497,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		else
 			r = kvm_supports_cacheable_pfnmap();
 		break;
+	case KVM_CAP_ARM_RMI:
+		r = static_key_enabled(&kvm_rmi_is_available);
+		break;
 
 	default:
 		r = 0;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..8b9efa8a3539 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -904,10 +904,14 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 
 static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 {
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	u32 kvm_ipa_limit = get_kvm_ipa_limit();
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;
 
+	if (kvm_is_realm(kvm))
+		kvm_ipa_limit = kvm_rmm_ipa_limit();
+
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
 	if (is_protected_kvm_enabled()) {
 		phys_shift = kvm_ipa_limit;
@@ -957,9 +961,18 @@ static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
 
 static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
 {
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
 
-	stage2_destroy_range(pgt, 0, BIT(ia_bits));
+	/*
+	 * Realm RTTs are inaccessible to the host and may contain stale data
+	 * after the RMM has released them. The non-root RTTs are explicitly
+	 * destroyed through RMI before the RD is destroyed; only the root PGD
+	 * pages remain to be freed here.
+	 */
+	if (!kvm_is_realm(kvm))
+		stage2_destroy_range(pgt, 0, BIT(ia_bits));
+
 	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
 }
 
@@ -1001,6 +1014,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 		return -EINVAL;
 	}
 
+	mmu->arch = &kvm->arch;
+
 	err = kvm_init_ipa_range(mmu, type);
 	if (err)
 		return err;
@@ -1009,7 +1024,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	if (!pgt)
 		return -ENOMEM;
 
-	mmu->arch = &kvm->arch;
 	err = KVM_PGT_FN(kvm_pgtable_stage2_init)(pgt, mmu, &kvm_s2_mm_ops);
 	if (err)
 		goto out_free_pgtable;
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 247c4f033945..528b01d5d71d 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -5,6 +5,8 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_pgtable.h>
 #include <asm/rmi_cmds.h>
 #include <asm/virt.h>
@@ -14,6 +16,60 @@ static bool rmi_has_feature(int reg, unsigned long feature)
 	return !!u64_get_bits(rmi_feat_reg(reg), feature);
 }
 
+u32 kvm_rmm_ipa_limit(void)
+{
+	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
+}
+
+void kvm_destroy_realm(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
+
+	if (!kvm_realm_is_created(kvm)) {
+		kfree(realm->sro);
+		realm->sro = NULL;
+		return;
+	}
+
+	kvm_set_realm_state(kvm, REALM_STATE_DYING);
+
+	if (realm->rd) {
+		phys_addr_t rd_phys = virt_to_phys(realm->rd);
+
+		if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
+			return;
+
+		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
+			return;
+		free_delegated_page(rd_phys);
+		realm->rd = NULL;
+	}
+
+	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys,
+					 pgd_size)))
+		return;
+
+	kvm_set_realm_state(kvm, REALM_STATE_DEAD);
+
+	/* Now that the realm is destroyed, free the entry-level RTTs. */
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
+
+	kfree(realm->sro);
+	realm->sro = NULL;
+}
+
+int kvm_init_realm(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+
+	realm->sro = kmalloc_obj(*realm->sro);
+	if (!realm->sro)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int rmm_check_features(void)
 {
 	if (kvm_lpa2_is_enabled() &&
-- 
2.43.0

