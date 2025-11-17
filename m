Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB8F26E6F6
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419409; cv=none; b=XR+jPECbDIWZZYsIh2N9jll3eMp9wyfzLhvdzwWigf1bEO426iJEU4ckwK3eG9wVZL7I2P+9aH+CWE373Nc5Qxlo4KOYzVOYBqfvwkIUy2pkfoP1VWP2yVHktCWNXrmbxja0MH9PTLB3nwvS8Tywl44lGK6m/9lvDHlnCCyWAvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419409; c=relaxed/simple;
	bh=jcQ49p7+7TtUyheqo4nLS8YmIoNFvSLGQOcaPlQH4rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZV8CO2FEL3Wv61cOoJI3jusZ4MAwD+nRYWpq7FmzFiE96RlV69WMTSK94tYG3ZfJ6ViJHYwS+VR+Um1gbRedL2nVI2KRhT0ERb9BzuQaGGfwNiSwdvukJ8UgdsUDWtU4A1vNeTcICHb/7Y3wuy6eKbVni/CcrkgM+UpPnWW0te0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FglN7A55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FglN7A55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951C1C2BCB2;
	Mon, 17 Nov 2025 22:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419409;
	bh=jcQ49p7+7TtUyheqo4nLS8YmIoNFvSLGQOcaPlQH4rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FglN7A55Y7VPdgdDSi2IbWKXZmkAuHGhTGrd/vhTk5JdWknRX6FsAwg439TKDgUgE
	 ecZwT5nvvRe9yqXMedzk+iId3pqqvcs44GPWNSCyvi8s8pwjKMyIVXBKDxtFjasT77
	 SmTvjjQjuyl+rlqleRYDJRLuX9fl/bLVzO6/9m6eqPefpQaVsJXCysvOmtkY3N7Ulj
	 /aAeuzCaL0pt2AaeWkERDbDIw13Zq7azExYrrb+dUy3i9lNP8FRzF/w22l6BmyRy7G
	 MaiLGyO2wwTTn/T1ha8xWQ9pd3Z+mZ+DLMkNFaRo3lHAYFNTsHy9rY7pBykoQeU7sq
	 vkgSBTG/dWlcA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 03/14] KVM: arm64: nv: Forward FEAT_XNX permissions to the shadow stage-2
Date: Mon, 17 Nov 2025 14:43:14 -0800
Message-ID: <20251117224325.2431848-4-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for FEAT_XNX to shadow stage-2 MMUs, being careful to only
evaluate XN[0] when the feature is actually exposed to the VM.
Restructure the layering of permissions in the fault handler to assume
pX and uX then restricting based on the guest's stage-2 afterwards.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 37 +++++++++++++++++++++++++++--
 arch/arm64/kvm/mmu.c                | 23 ++++++++++++++----
 arch/arm64/kvm/nested.c             |  5 +++-
 3 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index f7c06a840963..5d967b60414c 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -120,9 +120,42 @@ static inline bool kvm_s2_trans_writable(struct kvm_s2_trans *trans)
 	return trans->writable;
 }
 
-static inline bool kvm_s2_trans_executable(struct kvm_s2_trans *trans)
+static inline bool kvm_has_xnx(struct kvm *kvm)
 {
-	return !(trans->desc & BIT(54));
+	return cpus_have_final_cap(ARM64_HAS_XNX) &&
+		kvm_has_feat(kvm, ID_AA64MMFR1_EL1, XNX, IMP);
+}
+
+static inline bool kvm_s2_trans_exec_el0(struct kvm *kvm, struct kvm_s2_trans *trans)
+{
+	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, trans->desc);
+
+	if (!kvm_has_xnx(kvm))
+		xn &= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10);
+
+	switch (xn) {
+	case 0b00:
+	case 0b01:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline bool kvm_s2_trans_exec_el1(struct kvm *kvm, struct kvm_s2_trans *trans)
+{
+	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, trans->desc);
+
+	if (!kvm_has_xnx(kvm))
+		xn &= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10);
+
+	switch (xn) {
+	case 0b00:
+	case 0b11:
+		return true;
+	default:
+		return false;
+	}
 }
 
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d30..96f1786c72fe 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1521,6 +1521,16 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 	*prot |= kvm_encode_nested_level(nested);
 }
 
+static void adjust_nested_exec_perms(struct kvm *kvm,
+				     struct kvm_s2_trans *nested,
+				     enum kvm_pgtable_prot *prot)
+{
+	if (!kvm_s2_trans_exec_el0(kvm, nested))
+		*prot &= ~KVM_PGTABLE_PROT_UX;
+	if (!kvm_s2_trans_exec_el1(kvm, nested))
+		*prot &= ~KVM_PGTABLE_PROT_PX;
+}
+
 #define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
 
 static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
@@ -1572,11 +1582,12 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
-	if (exec_fault ||
-	    (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
-	     (!nested || kvm_s2_trans_executable(nested))))
+	if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		prot |= KVM_PGTABLE_PROT_X;
 
+	if (nested)
+		adjust_nested_exec_perms(kvm, nested, &prot);
+
 	kvm_fault_lock(kvm);
 	if (mmu_invalidate_retry(kvm, mmu_seq)) {
 		ret = -EAGAIN;
@@ -1851,11 +1862,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
 			prot |= KVM_PGTABLE_PROT_DEVICE;
-	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
-		   (!nested || kvm_s2_trans_executable(nested))) {
+	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
 		prot |= KVM_PGTABLE_PROT_X;
 	}
 
+	if (nested)
+		adjust_nested_exec_perms(kvm, nested, &prot);
+
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f04cda40545b..92b2a69f0b89 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -788,7 +788,10 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 		return 0;
 
 	if (kvm_vcpu_trap_is_iabt(vcpu)) {
-		forward_fault = !kvm_s2_trans_executable(trans);
+		if (vcpu_mode_priv(vcpu))
+			forward_fault = !kvm_s2_trans_exec_el1(vcpu->kvm, trans);
+		else
+			forward_fault = !kvm_s2_trans_exec_el0(vcpu->kvm, trans);
 	} else {
 		bool write_fault = kvm_is_write_fault(vcpu);
 
-- 
2.47.3

