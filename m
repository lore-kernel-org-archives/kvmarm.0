Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F77320B216;
	Fri, 10 Jan 2025 11:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736506863; cv=none; b=gnG1yp9rJrMidZHKeOVbspLy+GNtRJEml/juzF+q4QL7bJ8VgtNne4JJmrkqhnt7QSRI3+sV5peqz3cxANWnkNpG2FVHYU6pb77zMQsr1K6JuV108e3ptxI/hsZM63EeiN7ZnXpb+TUbklifVYt88box7K6XJEcy5WXbNylj9Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736506863; c=relaxed/simple;
	bh=wX1cvsZl0Gee/1vXpjR21iffk4CLgXLHBJvGmHQoMwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHgTa7dURku9WrOz6Y09az8FQGNeXmwVQ0FKk7iopjLPBiXmG813Ouey+/qYPiPBongx59dW5/tzd89QeqEi5qN7KmpspeAcLeWyqQiMRI6I0nLDwOuXsDs842+vbAG2PmXp2GWR6IL5AdolaUvT/qvDPBLpco0IJ7/yntzQCQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVcqX3HJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVcqX3HJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01C2C4CEE5;
	Fri, 10 Jan 2025 11:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736506863;
	bh=wX1cvsZl0Gee/1vXpjR21iffk4CLgXLHBJvGmHQoMwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVcqX3HJARW23MBB7HIpwfgbrnzUbc2Xdp7r/MXz5XW48w0UiqIWjbK3XxVO1S7x1
	 fzfroHhsjit5PfoacoZwKjdKL4fzm60CU5LoBs+yAjiQ8gHzJ5k7T6Nxu2D0b85uYx
	 v18Lk1TJH2dTwn28f5SJ6hZev/iy5YWdQs6mMEWhXsi60BM5bIFoJORwJ/6aZd5dU6
	 DZsUpwyj8ClIUd6wp9nqUwB8qdm3JUKSY648rPxv5fQFYKCDZJUaZ/fei1cE1mh/sz
	 HNsJnGfr8v558Q4aMk1XrwHVTVh5T3CEb9+LXCYSxPBCdiT3YhXZA3P2XHgmEoz8jL
	 VqX7Rll4Sq/6g==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH v2 6/7] KVM: arm64: MTE: Nested guest support
Date: Fri, 10 Jan 2025 16:30:22 +0530
Message-ID: <20250110110023.2963795-7-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently MTE feature is not enabled for a EL1 guest and similarly we
disable MTE_PERM. But we do add code in this patch to allow using
KVM_CAP_ARM_MTE_PERM with an EL1 guest. This will allow the usage of MTE
in nested guest even if some of the memory backing nested guest RAM is
not MTE capable (ex: page cache pages).

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 10 ++++++++++
 arch/arm64/kvm/mmu.c                | 10 ++++++++++
 arch/arm64/kvm/nested.c             | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 15 +++++++++++----
 4 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 233e65522716..4d6c0df3ef48 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -86,6 +86,8 @@ struct kvm_s2_trans {
 	bool writable;
 	bool readable;
 	int level;
+	int s2_fwb;
+	int mem_attr;
 	u32 esr;
 	u64 desc;
 };
@@ -120,10 +122,18 @@ static inline bool kvm_s2_trans_executable(struct kvm_s2_trans *trans)
 	return !(trans->desc & BIT(54));
 }
 
+static inline bool kvm_s2_trans_tagaccess(struct kvm_s2_trans *trans)
+{
+	if (trans->s2_fwb)
+		return (trans->mem_attr & MT_S2_FWB_NORMAL_NOTAGACCESS) != MT_S2_FWB_NORMAL_NOTAGACCESS;
+	return (trans->mem_attr & MT_S2_NORMAL_NOTAGACCESS) != MT_S2_NORMAL_NOTAGACCESS;
+}
+
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 			      struct kvm_s2_trans *result);
 extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
+int kvm_s2_handle_notagaccess_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans);
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 extern void kvm_nested_s2_wp(struct kvm *kvm);
 extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3610bea7607d..54e5bfe4f126 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1640,6 +1640,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		goto out_unlock;
 	}
 
+	if (nested && !kvm_s2_trans_tagaccess(nested))
+		mte_allowed = false;
+
 	/*
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
@@ -1836,6 +1839,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 			goto out_unlock;
 		}
 
+		ret = kvm_s2_handle_notagaccess_fault(vcpu, &nested_trans);
+		if (ret) {
+			esr = kvm_s2_trans_esr(&nested_trans);
+			kvm_inject_s2_fault(vcpu, esr);
+			goto out_unlock;
+		}
+
 		ipa = kvm_s2_trans_output(&nested_trans);
 		nested = &nested_trans;
 	}
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9b36218b48de..5867e0376444 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -290,6 +290,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 	out->writable = desc & (0b10 << 6);
 	out->level = level;
 	out->desc = desc;
+	out->mem_attr = desc & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
 	return 0;
 }
 
@@ -340,6 +341,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 
 	wi.be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
 
+	result->s2_fwb = !!(*vcpu_hcr(vcpu) & HCR_FWB);
 	ret = walk_nested_s2_pgd(gipa, &wi, result);
 	if (ret)
 		result->esr |= (kvm_vcpu_get_esr(vcpu) & ~ESR_ELx_FSC);
@@ -733,6 +735,27 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 	return forward_fault;
 }
 
+int kvm_s2_handle_notagaccess_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
+{
+	bool forward_fault = false;
+
+	trans->esr = 0;
+
+	if (!kvm_vcpu_trap_is_tagaccess(vcpu))
+		return 0;
+
+	if (!kvm_s2_trans_tagaccess(trans))
+		forward_fault = true;
+	else
+		forward_fault = false;
+
+	/* forward it as a permission fault with tag access set in ISS2 */
+	if (forward_fault)
+		trans->esr = esr_s2_fault(vcpu, trans->level, ESR_ELx_FSC_PERM);
+
+	return forward_fault;
+}
+
 int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
 {
 	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.far_el2, FAR_EL2);
@@ -844,6 +867,11 @@ static void limit_nv_id_regs(struct kvm *kvm)
 		NV_FTR(PFR1, CSV2_frac));
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR1_EL1, val);
 
+	/* For now no MTE_PERM support because MTE is disabled above */
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1);
+	val &= ~NV_FTR(PFR2, MTEPERM);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, val);
+
 	/* Hide ECV, ExS, Secure Memory */
 	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1);
 	val &= ~(NV_FTR(MMFR0, ECV)		|
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e2a5c2918d9e..cb7d4d32179c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1557,7 +1557,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 				       const struct sys_reg_desc *r)
 {
 	u32 id = reg_to_encoding(r);
-	u64 val;
+	u64 val, mask;
 
 	if (sysreg_visible_as_raz(vcpu, r))
 		return 0;
@@ -1587,8 +1587,14 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MPAM_frac);
 		break;
 	case SYS_ID_AA64PFR2_EL1:
-		/* We only expose FPMR */
-		val &= ID_AA64PFR2_EL1_FPMR;
+		mask = ID_AA64PFR2_EL1_FPMR;
+		/*
+		 * Since this is a stage-2 specific feature, only pass
+		 * if vcpu can run in vEL2
+		 */
+		if (vcpu_has_nv(vcpu))
+			mask |= ID_AA64PFR2_EL1_MTEPERM;
+		val &= mask;
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -2566,7 +2572,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_RAS_frac |
 				       ID_AA64PFR1_EL1_MTE)),
-	ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR),
+	ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR |
+					ID_AA64PFR2_EL1_MTEPERM),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
-- 
2.43.0

