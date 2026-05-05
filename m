Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F241F507
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 09:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974568; cv=none; b=V4rVjdYy16EIVbNppxH5skF2lE93aXR/QE3oXP/OmbyInRVn9P2M8v92YecgdiCDiF8O0mgtlyDmymsEASFeqZm3k2nWeh1AlDq8Nh2ljNkKTKzc/OKNeR/erYoFnV7JR1+X5Fag6LzUxxOmw0R4Bxgs9dL8mTEp12r4/1l/u4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974568; c=relaxed/simple;
	bh=aqm/uVvLu0DWgsxmTnZocXFueY6Lf/rU5yzfpqC6n3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=keWaUKnw57PbEXuD5AtxR3hXXP6FcfM8JSaThRGJWnJfbZ/XUQPkRjCGidyF8N7r3ShpZX7Offay2kjGAM2Jpo3thIVUyHz7G6p2WrgVgH2Tfy8OZw5O5+ux1/eYL/40aXDsBR/DF1pEA0r805jfwp2ctlhOTV1cw/K59SoEUmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qwIMQKGr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qwIMQKGr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09335293B;
	Tue,  5 May 2026 02:49:21 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AFDD23F836;
	Tue,  5 May 2026 02:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777974566; bh=aqm/uVvLu0DWgsxmTnZocXFueY6Lf/rU5yzfpqC6n3A=;
	h=From:To:Cc:Subject:Date:From;
	b=qwIMQKGrdP67REy19yNT+t5KV0G8VpMpEWaUlM8zhUwjBhI5mfpV1KwNZMMhJfJlx
	 LFwsZ14s4FpIMoOMYzjoWAe+6YHBdL0fuMpwDsgWxwyWAkuEdpuZMZdffFY+2M3erp
	 GD6H3sz2i2Oa5u1uDrfcF40RFyRELGzVOmE/wjYM=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	tabba@google.com
Cc: mark.rutland@arm.com
Subject: [PATCH v2] KVM: arm64: Handle permission faults with guest_memfd
Date: Tue,  5 May 2026 10:49:13 +0100
Message-ID: <20260505094913.75317-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

gmem_abort() calls kvm_pgtable_stage2_map() to make changes to stage 2. It
does this for both relaxing permissions on an existing mapping and to
install a missing mapping.

kvm_pgtable_stage2_map() doesn't make changes to stage 2 if there is an
existing, valid entry and the new entry modifies only the permissions.
This is checked in:

kvm_pgtable_stage2_map()
  stage2_map_walk_leaf()
     stage2_map_walker_try_leaf()
       stage2_pte_needs_update()

and if only the permissions differ, kvm_pgtable_stage2_map() returns
-EAGAIN and KVM returns to the guest to replay the instruction. The
assumption is that a concurrent fault on a different VCPU already mapped
the faulting IPA, and replaying the instruction will either succeed, or
cause a permission fault, which should be handled with
kvm_pgtable_stage2_relax_perms().

gmem_abort(), on a read or write fault on a system without DIC (instruction
cache invalidation required for data to instruction coherence), installs a
valid entry with read and write permissions, but without executable
permissions. On an execution fault on the same page, gmem_abort() attempts
to relax the permissions to allow execution, but calls
kvm_pgtable_stage2_map() to change the existing, valid, entry.
kvm_pgtable_stage2_map() returns -EAGAIN and KVM resumes execution from the
faulting instruction, which leads to an infinite loop of permission faults
on the same instruction.

Allow the guest to make progress by using kvm_pgtable_stage2_relax_perms()
to relax permissions.

Fixes: a7b57e099592 ("KVM: arm64: Handle guest_memfd-backed guest page faults")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

v1: https://lore.kernel.org/kvmarm/20260430132351.280766-1-alexandru.elisei@arm.com/

Changes from v1:
- Rebased on top of v7.1-rc2.
- Initialised memcache to NULL (Fuad).
- Copied kvm_pgtable_stage2_relax_perms() comment from kvm_s2_fault_map()
  (Fuad).
- Fixed KVM_PGT_FN() macro invocation (Fuad).

Same as before, tested booting a linux VM on Orion O6, no pkvm, no nested virt.

 arch/arm64/kvm/mmu.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d089c107d9b7..4da9281312eb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1576,21 +1576,24 @@ struct kvm_s2_fault_desc {
 static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool write_fault, exec_fault;
+	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
 	unsigned long mmu_seq;
 	struct page *page;
 	struct kvm *kvm = s2fd->vcpu->kvm;
-	void *memcache;
+	void *memcache = NULL;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
 	int ret;
 
-	memcache = get_mmu_memcache(s2fd->vcpu);
-	ret = topup_mmu_memcache(s2fd->vcpu, memcache);
-	if (ret)
-		return ret;
+	if (!perm_fault) {
+		memcache = get_mmu_memcache(s2fd->vcpu);
+		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
+		if (ret)
+			return ret;
+	}
 
 	if (s2fd->nested)
 		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
@@ -1631,9 +1634,19 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		goto out_unlock;
 	}
 
-	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
-						 __pfn_to_phys(pfn), prot,
-						 memcache, flags);
+	if (perm_fault) {
+		/*
+		 * Drop the SW bits in favour of those stored in the
+		 * PTE, which will be preserved.
+		 */
+		prot &= ~KVM_NV_GUEST_MAP_SZ;
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
+								 prot, flags);
+	} else {
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
+							 __pfn_to_phys(pfn), prot,
+							 memcache, flags);
+	}
 
 out_unlock:
 	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);

base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
2.54.0

