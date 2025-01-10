Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6889420C476;
	Fri, 10 Jan 2025 11:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736506858; cv=none; b=TB3Xa+irra5yHsqjMg2g1GLLpv66BUrXRQTDyVW3ia6YZ2rJAJ+wTq9BuBMXLtAFbYcQssz9wppYXvIKorOY/2b+4Cmqd4Z/nwuPHgvAHaLoxM0wMKIxfKawQMpcrnN+85MwKrBJxcjTTQDCygQEVxIwrWDA4S6BqBFuOanwVkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736506858; c=relaxed/simple;
	bh=9TRUXlBD9cnMC5DbsHqNqQnojwDs/LFT/n1O8JicJ8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iek05l6ERUOzyNAhyPJ3CVNC/2QKEB8sNP2QjZePzjuWP07PmHOqihO/4NA0ALTzHE0qPOS+EX6fRZR0h2ulTzgEm6k/SS/bV4CuIEAt+PCv7Bgd8RIJalnHTfVHutKAdot2W2CgryLQ2tx/1A+xVRMkI0LUUSuT8qhxKE8RFTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=forSODSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="forSODSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BF9C4CED6;
	Fri, 10 Jan 2025 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736506858;
	bh=9TRUXlBD9cnMC5DbsHqNqQnojwDs/LFT/n1O8JicJ8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=forSODSfA5wvDsad6NgM9MiLxYKOq6M8GDI68srPidmKv7oTJb2PAHUauu7I2ZqQY
	 XPSmKzbVYufufRIM12advoubbPsvl8dp95bcKzcGfsAcuNoe/58hTPHzJ2Dh3azeuO
	 w0WxFL/Wvf5lhhVl3GMIIUB1/QIna7pyBs90iQ8BzSBtF0+L9qpLWaN2OOo3WZSl7S
	 K0dulV+Edoo4ecmXF0cQB325pRJ7s6t+0TKN7oY+/wpZylt3fCaTQyTmDgbW1D2Aip
	 Bubrdcj6roBNw+1V8zpuwdntLDwNSlvE9Wmy1wD7piOK9BzQYlUGn0+t4KHRxKYYr8
	 5Bz4MeUYeTuzw==
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
Subject: [PATCH v2 5/7] KVM: arm64: MTE: Use stage-2 NoTagAccess memory attribute if supported
Date: Fri, 10 Jan 2025 16:30:21 +0530
Message-ID: <20250110110023.2963795-6-aneesh.kumar@kernel.org>
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

Currently, the kernel won't start a guest if the MTE feature is enabled
and the guest RAM is backed by memory which doesn't support access tags.
Update this such that the kernel uses the NoTagAccess memory attribute
while mapping pages from VMAs for which MTE is not allowed. The fault
from accessing the access tags with such pages is forwarded to VMM so
that VMM can decide to kill the guest or take any corrective actions

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst       |  3 +++
 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/include/asm/kvm_pgtable.h |  1 +
 arch/arm64/kvm/hyp/pgtable.c         | 16 +++++++++++++---
 arch/arm64/kvm/mmu.c                 | 17 ++++++++++++++---
 include/linux/kvm_host.h             | 10 ++++++++++
 include/uapi/linux/kvm.h             |  1 +
 7 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e954fca76c27..3b357f9b76d6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7115,6 +7115,9 @@ describes properties of the faulting access that are likely pertinent:
  - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
    on a private memory access.  When clear, indicates the fault occurred on a
    shared access.
+ - KVM_MEMORY_EXIT_FLAG_NOTAGACCESS - When set, indicates the memory fault
+   occurred due to allocation tag access on a memory region that doesn't support
+   allocation tags.
 
 Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that it
 accompanies a return code of '-1', not '0'!  errno will always be set to EFAULT
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index cf811009a33c..609ed6a5ffce 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -378,6 +378,11 @@ static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
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
index aab04097b505..0daf4ffedc99 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -252,6 +252,7 @@ enum kvm_pgtable_prot {
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
 	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
+	KVM_PGTABLE_PROT_NORMAL_NOTAGACCESS	= BIT(5),
 
 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 40bd55966540..4eb6e9345c12 100644
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
index eb8220a409e1..3610bea7607d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1660,9 +1660,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (mte_allowed) {
+		if (mte_allowed)
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
-		} else {
+		else if (kvm_has_mte_perm(kvm))
+			prot |= KVM_PGTABLE_PROT_NORMAL_NOTAGACCESS;
+		else {
 			ret = -EFAULT;
 			goto out_unlock;
 		}
@@ -1840,6 +1842,14 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
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
@@ -2152,7 +2162,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (!vma)
 			break;
 
-		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
+		if (kvm_has_mte(kvm) &&
+		    !kvm_has_mte_perm(kvm) && !kvm_vma_mte_allowed(vma)) {
 			ret = -EINVAL;
 			break;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 401439bb21e3..8a270f658f36 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2471,6 +2471,16 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline void kvm_prepare_notagaccess_exit(struct kvm_vcpu *vcpu,
+						 gpa_t gpa, gpa_t size)
+{
+	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
+	vcpu->run->memory_fault.flags = KVM_MEMORY_EXIT_FLAG_NOTAGACCESS;
+	vcpu->run->memory_fault.gpa = gpa;
+	vcpu->run->memory_fault.size = size;
+}
+
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4900ff577819..7136d28eb307 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -442,6 +442,7 @@ struct kvm_run {
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_FLAG_NOTAGACCESS (1ULL << 4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
-- 
2.43.0

