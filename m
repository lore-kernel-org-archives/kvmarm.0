Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F681991C3;
	Mon, 28 Oct 2024 09:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730108452; cv=none; b=fc3jKbDUawasJHQc/FlTroSEDJw2+dPD4exrU27GBeuUMqYCTDJL4xQ981dgRrmPshHxTc7quOm5KGlJSysMQg0UqMsFs6aK2BGjIqTkB9cr+3GzV0uOWzk0cOLToCaPoZjqeQfI+0BWeNI0+b6eGt9BFdv0qpBBIaZPp7p60Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730108452; c=relaxed/simple;
	bh=G2GbVBqUrl/bAsu9wwCmWG5UWW1Trj57AeTzu57FnfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuEeO2n73bCxJ1qZZy4UnpyVakHhH+UPZnxYj36Aza+t+NyUXIfUQhoS2NpuIdW8yJwnzOVJiwNyJCpuSQC0qDJ+63hWO1al7xE7HUpRUICrR2wx3EAuDutyz5o4XJhcFlzX8GY3xiM0kv/2yO4yYJL3zvR9WAVWsrJDqD/1zAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jSS9RfBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jSS9RfBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864ABC4CEC3;
	Mon, 28 Oct 2024 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730108452;
	bh=G2GbVBqUrl/bAsu9wwCmWG5UWW1Trj57AeTzu57FnfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSS9RfBkSCnnPdCu2wVQvHxuuqy4udopoF4zaUlic+tFZf2ZW8eoma6SZoY4+7Agu
	 ILxq83L5EJ6nt/N6TDvo/HYW6ATlKxGP5T5+r3VIlVFXbcTwK7WddFAbcp7ywPAq0a
	 BWY8wK1oamFTPBHzHf+uASLl/5BjsT3Znk5P/T1zT0VkNUoJ2/IohdIYBfiNRxKXLS
	 YAVzh8OSGb9YPZV7XPLkhJa0pnhUa5qkQsXkKi7x6cRfm/bPqVDkz+m2Io+sXYA4eF
	 jzcr8TIBH50Vqz68u90QC+7pxSIEQxwdLgirrXhRV6yo9TpmKqPQ1Pi3Sj0VkPtI2t
	 G2fVt+FoqpdPA==
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
Subject: [PATCH 4/4] arm64: mte: Use stage-2 NoTagAccess memory attribute if supported
Date: Mon, 28 Oct 2024 15:10:14 +0530
Message-ID: <20241028094014.2596619-5-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
References: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the kernel won't start a guest if the MTE feature is enabled
and the guest RAM is backed by memory which doesn't support access tags.
Update this such that the kernel uses the NoTagAccess memory attribute
while mapping pages from VMAs for which MTE is not allowed. The fault
from accessing the access tags with such pages is forwarded to VMM so
that VMM can decide to kill the guest or remap the pages so that
access tag storage is allowed.

NOTE: We could also use KVM_EXIT_MEMORY_FAULT for this. I chose to
add a new EXIT type because this is arm64 specific exit type.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/include/asm/kvm_pgtable.h |  1 +
 arch/arm64/kvm/hyp/pgtable.c         | 16 +++++++++++++---
 arch/arm64/kvm/mmu.c                 | 28 ++++++++++++++++++++++------
 include/uapi/linux/kvm.h             |  7 +++++++
 5 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a601a9305b10..fa0149a0606a 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -373,6 +373,11 @@ static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
 	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
 }
 
+static inline bool kvm_vcpu_trap_is_tagaccess(const struct kvm_vcpu *vcpu)
+{
+	return !!(ESR_ELx_ISS2(kvm_vcpu_get_esr(vcpu)) & ESR_ELx_TagAccess);
+}
+
 static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC;
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 03f4c3d7839c..5657ac1998ad 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -252,6 +252,7 @@ enum kvm_pgtable_prot {
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
 	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
+	KVM_PGTABLE_PROT_NORMAL_NOTAGACCESS	= BIT(5),
 
 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b11bcebac908..bc0d9f08c49a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -677,9 +677,11 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 {
 	kvm_pte_t attr;
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
+	unsigned long prot_mask = KVM_PGTABLE_PROT_DEVICE |
+				  KVM_PGTABLE_PROT_NORMAL_NC |
+				  KVM_PGTABLE_PROT_NORMAL_NOTAGACCESS;
 
-	switch (prot & (KVM_PGTABLE_PROT_DEVICE |
-			KVM_PGTABLE_PROT_NORMAL_NC)) {
+	switch (prot & prot_mask) {
 	case KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC:
 		return -EINVAL;
 	case KVM_PGTABLE_PROT_DEVICE:
@@ -692,6 +694,12 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 			return -EINVAL;
 		attr = KVM_S2_MEMATTR(pgt, NORMAL_NC);
 		break;
+	case KVM_PGTABLE_PROT_NORMAL_NOTAGACCESS:
+		if (system_supports_notagaccess())
+			attr = KVM_S2_MEMATTR(pgt, NORMAL_NOTAGACCESS);
+		else
+			return -EINVAL;
+		break;
 	default:
 		attr = KVM_S2_MEMATTR(pgt, NORMAL);
 	}
@@ -872,7 +880,9 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
 static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
 {
 	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
-	return kvm_pte_valid(pte) && memattr == KVM_S2_MEMATTR(pgt, NORMAL);
+	return kvm_pte_valid(pte) &&
+	       ((memattr == KVM_S2_MEMATTR(pgt, NORMAL)) ||
+		(memattr == KVM_S2_MEMATTR(pgt, NORMAL_NOTAGACCESS)));
 }
 
 static bool stage2_pte_executable(kvm_pte_t pte)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b5824e93cee0..e56c6996332e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1647,12 +1647,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 *  not a permission fault implies a translation fault which
 		 *  means mapping the page for the first time
 		 */
-		if (mte_allowed) {
+		if (mte_allowed)
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
-		} else {
-			ret = -EFAULT;
-			goto out_unlock;
-		}
+		else
+			prot |= KVM_PGTABLE_PROT_NORMAL_NOTAGACCESS;
 	}
 
 	if (writable)
@@ -1721,6 +1719,15 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 		kvm_set_pfn_accessed(kvm_pte_to_pfn(pte));
 }
 
+static inline void kvm_prepare_notagaccess_exit(struct kvm_vcpu *vcpu,
+						 gpa_t gpa, gpa_t size)
+{
+	vcpu->run->exit_reason = KVM_EXIT_ARM_NOTAG_ACCESS;
+	vcpu->run->notag_access.flags = 0;
+	vcpu->run->notag_access.gpa = gpa;
+	vcpu->run->notag_access.size = size;
+}
+
 /**
  * kvm_handle_guest_abort - handles all 2nd stage aborts
  * @vcpu:	the VCPU pointer
@@ -1833,6 +1840,14 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	gfn = ipa >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+
+	if (kvm_vcpu_trap_is_tagaccess(vcpu)) {
+		/* exit to host and handle the error */
+		kvm_prepare_notagaccess_exit(vcpu, gfn << PAGE_SHIFT, PAGE_SIZE);
+		ret = 0;
+		goto out;
+	}
+
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
@@ -2145,7 +2160,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (!vma)
 			break;
 
-		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
+		if (kvm_has_mte(kvm) && !system_supports_notagaccess() &&
+		    !kvm_vma_mte_allowed(vma)) {
 			ret = -EINVAL;
 			break;
 		}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..a8268a164c4d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -178,6 +178,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_ARM_NOTAG_ACCESS 40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -446,6 +447,12 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_ARM_NOTAG_ACCESS */
+		struct {
+			__u64 flags;
+			__u64 gpa;
+			__u64 size;
+		} notag_access;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.43.0

