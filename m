Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64EB413247
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 13:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555451; cv=none; b=Dep84BaT6a8GeDv7++v8sHLaZqWcjPaUXH3ie63wAMn56UXNOHCwh3+cOs824fdCP8kpkaf8qThww/ITlgxb0jbtz30sEE1NBIi5FzuHpoV9Q9tTyGYMGF7RE2gHvG2EUQB980qfC4/ylTpftk4NclEV8TIZl05gexKhEXN5uMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555451; c=relaxed/simple;
	bh=tQL3fqiLMsmztWBDjtrNObpqhCigVhOEjUfSXQJGAkE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IWaeszFLQuD4dazvYuFB/Sl7OFjsy8636pGntOxrarxtLbboXtomXtYN31ux8eO9SK4/K4oScIJ0tBecfO6P70mmY+aV4zJp5SD/jFI6TFKsYLoU6DqvgJ4KdmDl8GOIzrG2TPpQ/ABUtI4q4tgEvak8oF+vk34Cky1jwZOghwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LqevOcyg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LqevOcyg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADC361AED;
	Thu, 30 Apr 2026 06:24:03 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 229D53F7B4;
	Thu, 30 Apr 2026 06:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777555449; bh=tQL3fqiLMsmztWBDjtrNObpqhCigVhOEjUfSXQJGAkE=;
	h=From:To:Cc:Subject:Date:From;
	b=LqevOcygKlIOkcNc7je+oj65sTA5Yyblv8SN9nHge2edOhj4JWH+BkMBlkm4zxdZI
	 LfTI9lZ+5Eezxd/AgevHwVJYESRDwG6JRgvCnb7oUmywsZEyOfkhtteod5aIU+c8Ue
	 3gOzUn+he2VILqZRPs8vjE0dam/J/cR1FbAkpQTU=
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
Subject: [PATCH] KVM: arm64: Handle permission faults with guest_memfd
Date: Thu, 30 Apr 2026 14:23:51 +0100
Message-ID: <20260430132351.280766-1-alexandru.elisei@arm.com>
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

Lightly tested on an Orion O6 board, without pkvm, and without nested
virtualisation.

Doesn't apply cleanly on top of a7b57e099592, I can send a patch for that if
needed.

 arch/arm64/kvm/mmu.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d089c107d9b7..dff58de7703b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1576,6 +1576,7 @@ struct kvm_s2_fault_desc {
 static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool write_fault, exec_fault;
+	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
@@ -1587,10 +1588,12 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
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
@@ -1631,9 +1634,16 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		goto out_unlock;
 	}
 
-	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
-						 __pfn_to_phys(pfn), prot,
-						 memcache, flags);
+	if (perm_fault) {
+		/* Preserve the software bits from the existing table entry. */
+		prot &= ~KVM_NV_GUEST_MAP_SZ;
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms(pgt, s2fd->fault_ipa,
+								prot, flags));
+	} else {
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
+							 __pfn_to_phys(pfn), prot,
+							 memcache, flags);
+	}
 
 out_unlock:
 	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.54.0

