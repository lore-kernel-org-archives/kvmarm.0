Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795574708;
	b=0W481fcZGGX28Fy2v+sExa77CyRUzt2fnWBbTSN/lXMQcxoXoJQLxOV3dGOblSOccxRY
	 n7uNG1WwwyI2tB5ezPaXk9tazIQbtY9XwlD9MNtwOHj7wn8CIfeV0Agy9vwhGcCCjZoCP
	 12uwpyCUqOaVclhX6WH3Eeh4ndcXdjlI6Y6mHp4XD/yVwarUrnvyB13r7Xn4dxyvTr1AU
	 yaDv+GKIJ+EcFOo4c/ZakK03bSPAhtVrBdLLQSmpOof25KS4zi3ucM5UZMkXezhi7P+9S
	 4tBMXEAbXe1vQackdE6dSU6cye8v3GV3vtrmWK/HPz7PkWvSZy3v0P1I7nHt2+VjYew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795574708;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MGGGZ4IBRju42kUAwpsf2sShlkQK4dVsJQLNokXw6Zo=;
	b=iqfRdUyRvtBCkBiggX2NcNHyAhgff0HnSDAKdh1Ol55UWx4iovkLzfWNsePu/KnffUal
	 cPWG+r+wr2/EldBBW45HaEtEIxVqE5zrIV0p+6dam2Iq4CQ6DcbLXIMAYEFV6A6n7tmLZ
	 9LvlmfNtrZFRGd/1nmVDa6fRP4PKtTHYBlqUGh9iAtgw/2TA8h+rqCF09Z5HtuKx6I/hU
	 OVhbAjOYSQOAuJOCZ8xZVF5pBpeYdy1lOtRrIRfPZpxPyglKN+DFrqB7AAbsdy55XHQmV
	 QeGTpoKMeh/5g/zA1MxB2/By53mZoEfVdXQtYEEa8HIc/ZLyy43/d6QUGkFJCvoKgmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dP5taiko;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4484606A326
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 02:45:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4484606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dP5taiko
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4952319F6;
	Tue, 24 Nov 2026 18:45:04 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 854EF3F86C;
	Tue, 24 Nov 2026 18:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795574707; bh=wDi1M7Q4l7A6y/F3a3AdAoPjlBOQwxkfI2YdxM9FiAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dP5taiko/LdgDe3i3r765mJKZl/r3gbqlGTj7ISSOucPizURiZfIV6ujmpbPwEofU
	 J24rw1Y9yj4pQstz0raNSQPO8wuVsgV7EX1fBLCQVhv5yVDb52XR38EWZLlZK8gWPF
	 pokQvhapFt73sAhLz9w6kIjbHLttBkYA3ConWnvg=
From: Jia He <justin.he@arm.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH v2 3/3] KVM: arm64: nv: Allow the L1 VNCR page in cacheable PFNMAP memory
Date: Wed, 25 Nov 2026 02:44:26 +0000
Message-Id: <20261125024426.3464050-4-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125024426.3464050-1-justin.he@arm.com>
References: <20261125024426.3464050-1-justin.he@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_translate_vncr() refuses any PFN that isn't memory and injects an
SEA into the guest hypervisor. That is stricter than what the stage-2
fault path allows (kvm_s2_fault_pin_pfn()): a VM_PFNMAP or VM_MIXEDMAP
VMA whose host stage-1 attributes are cacheable is mapped cacheable at
stage-2 when FWB and DIC are present, and the guest can use such memory
as RAM (e.g. device memory that it onlines as a NUMA node). If the guest
then picks a page of that memory as the VNCR page of one of its own
guests, it takes an SEA as soon as it enters that guest.

For VM_PFNMAP and VM_MIXEDMAP VMAs, relax the check to match the stage-2
fault path, and remove the FIXME added by commit 4bd7dbe0b224 ("KVM:
arm64: nv: Inject SEA if guest VNCR isn't normal memory"). Look up the
VMA, and allow the PFN if the VMA is a cacheable VM_PFNMAP or
VM_MIXEDMAP one and the system supports cacheable PFNMAP at stage-2. No
linear mapping is required, because VNCR accesses use the EL2 fixmap and
require no cache maintenance.

Get the HVA with gfn_to_hva_memslot_prot(), as kvm_handle_guest_abort()
does. gfn_to_hva_memslot() returns KVM_HVA_ERR_RO_BAD for a read-only
memslot, and the VMA lookup would then fail. A VNCR page in a read-only
memslot is valid and is mapped read-only since commit 2684e02bac41
("KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR").

mmu_invalidate_seq is sampled before the PFN is faulted in, so a VMA
change after the lookup is caught by the mmu_invalidate_retry() check
that follows, as for the PFN itself.

Tested on a host with FEAT_FGT, FWB and DIC, with an L1 whose whole RAM
is a cacheable PFNMAP (host RAM withheld with mem= and handed to the VMM
by a test driver with remap_pfn_range()) starting an L2 guest
hypervisor. Without the patch, L2 repeatedly takes an SEA at the same PC
and fails to boot. With the patch, L2 boots successfully.

The read-only case was tested on a Neoverse-N2 host. The guest
hypervisor's VNCR page is in a cacheable PFNMAP registered as a
read-only memslot, and a nested context reads VTTBR_EL2. When the HVA
is looked up with gfn_to_hva_memslot(), the guest hypervisor takes an
SEA. With this patch, the read returns the contents of the VNCR page.

Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  2 ++
 arch/arm64/kvm/mmu.c             |  2 +-
 arch/arm64/kvm/nested.c          | 38 +++++++++++++++++++++++++++-----
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 32392abf2e21..e59c6603b137 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -385,6 +385,8 @@ static inline void kvm_fault_unlock(struct kvm *kvm)
 		read_unlock(&kvm->mmu_lock);
 }
 
+bool kvm_vma_is_cacheable(struct vm_area_struct *vma);
+
 /*
  * ARM64 KVM relies on a simple conversion from physaddr to a kernel
  * virtual address (KVA) when it does cache maintenance as the CMO
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db7..cbd563ba4dd9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1639,7 +1639,7 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
-static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
+bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
 {
 	switch (FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(vma->vm_page_prot))) {
 	case MT_NORMAL_NC:
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 59d82a29ec01..7412f026e1f3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1553,6 +1553,37 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
 }
 
+/*
+ * Allow a non-memory PFN only if it comes from a cacheable VM_PFNMAP or
+ * VM_MIXEDMAP VMA and the system supports cacheable PFNMAP at stage-2. The
+ * VMA is looked up after the PFN has been faulted in: the caller must check
+ * mmu_invalidate_retry() against a sequence count sampled before the
+ * fault-in.
+ */
+static bool vncr_pfn_is_cacheable(struct kvm_memory_slot *memslot, gfn_t gfn,
+				  kvm_pfn_t pfn)
+{
+	struct vm_area_struct *vma;
+	unsigned long hva;
+	bool ret = false;
+
+	if (pfn_is_map_memory(pfn))
+		return true;
+
+	if (!kvm_supports_cacheable_pfnmap())
+		return false;
+
+	hva = gfn_to_hva_memslot_prot(memslot, gfn, NULL);
+
+	mmap_read_lock(current->mm);
+	vma = vma_lookup(current->mm, hva);
+	if (vma && (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+		ret = kvm_vma_is_cacheable(vma);
+	mmap_read_unlock(current->mm);
+
+	return ret;
+}
+
 static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 {
 	struct kvm_memory_slot *memslot;
@@ -1625,12 +1656,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 		writable = !(memslot->flags & KVM_MEM_READONLY);
 	}
 
-	/*
-	 * FIXME: This check is too restrictive as KVM allows cacheable memory
-	 * attributes for PFNMAP VMAs that have cacheable attributes in host
-	 * stage-1.
-	 */
-	if (!pfn_is_map_memory(pfn)) {
+	if (!vncr_pfn_is_cacheable(memslot, gfn, pfn)) {
 		kvm_release_faultin_page(vcpu->kvm, page, true, false);
 		fail_s1_walk(&vt->wr, ESR_ELx_FSC_EXTABT, false);
 		return -EINVAL;
-- 
2.34.1

