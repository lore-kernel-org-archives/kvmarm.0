Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D5B537C93F
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 11:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784027299; cv=none; b=U4FasagPaNm7AbsDeJWtBy8K2ZDJMLlT4272lc99bxQXGQyuCAEB8PxkihIISV6ltpj7gcg0und6fxNuxH3KX90WedwA9DvcksQaAqauIRkocEGYG/emJDbqiu2TuUegCjDTP+0ZhL2qVA6siqVP75E4rWEYr4ZgSCm0krDZaC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784027299; c=relaxed/simple;
	bh=DlRcimcuxgtdW+sYVApiQq5gJS7p9R0UTH5EnebwlcI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HU18SDZQNPfA09FX7Uv0vpoWXn2fC1Ku8KLhYGjVv1NHJJrtAh01H5xKXfseHD8mrJPmAhqgkSHIzyipvLOToOi+mIErQMZE03qBxjsydJvESTk3gGETXdbHouXDTAKGYL2fR0v6tPxM+fOzflolygISPGCOim+DSexwaHjbquM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KQXahb6Q; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KQXahb6Q"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4BF7497;
	Tue, 14 Jul 2026 04:08:11 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C5B13F93E;
	Tue, 14 Jul 2026 04:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784027296; bh=DlRcimcuxgtdW+sYVApiQq5gJS7p9R0UTH5EnebwlcI=;
	h=From:To:Cc:Subject:Date:From;
	b=KQXahb6Q+cc5EkzbyuKbTIN4Kwomg1k+tIHXgK3nfRasLrWegAxFb/fX28oBlj7nV
	 w7izbxIkYhsSoUhQx1UdVE7vM202P1Z0YdendmQJIQyjhxzEeIAohkFuyjwVyXlo9h
	 8uOMDWD3hVVnZqQAQpn8sRl2VGCpdN3IzZHIPfRE=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: steven.price@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH] KVM: arm64: Reject guest_memfd memslots when the VM has MTE
Date: Tue, 14 Jul 2026 12:07:56 +0100
Message-ID: <20260714110756.116950-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The user cannot use MTE on VMAs created by mapping a guest_memfd file,
as arch_calc_vm_flag_bits() does not set VM_MTE_ALLOWED.

When creating a guest_memfd backed memslot,
kvm_arch_prepare_memory_region() rejects the memslot if MTE is enabled for
the VM and if guest_memfd has been mapped in a VMA that intersects the
memslot.

However, the documentation for KVM_SET_USER_MEMORY_REGION2 explicitely
states that the only condition for userspace_addr is for it to be a legal
userspace address, but the mapping is not required to be valid nor
populated at memslot creation.

If userspace sets userspace_addr to an address that hasn't been mapped, or
if userspace_addr belongs to a VMA that isn't backed by the guest_memfd
file, or if the VMA doesn't intersect the memslot, memslot creation is
successful and KVM ends up with a VM with MTE and guest_memfd-backed
memslots.

Forbid guest_memfd memslots unconditionally when the VM has MTE to prevent
this from happening.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Tested by using Fuad's patches to add guest_memfd support for kvmtool at [1],
with the following changes to arm64/kvm.c:

@@ -125,10 +125,12 @@ static void kvm__arch_enable_mte(struct kvm *kvm)
                return;
        }
 
+       /*
        if (kvm->cfg.arch.guest_memfd) {
                pr_debug("MTE is incompatible with guest_memfd");
                return;
        }
+       */
 
        if (kvm->cfg.arch.mte_disabled) {
                pr_debug("MTE disabled by user");

and kvm.c:

@@ -332,8 +332,15 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
                                .guest_memfd_offset     = guest_memfd_offset,
                        };
 
+                       if (munmap(userspace_addr, size) < 0)
+                               die_perror("munmap hack");
+
                        ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2,
                                    &mem2);
+
+                       if (mmap(userspace_addr, size, PROT_RW, MAP_SHARED | MAP_FIXED,
+                           guest_memfd, guest_memfd_offset) == MAP_FAILED)
+                               die_perror("mmap hack");
                } else {
                        struct kvm_userspace_memory_region mem = {
                                .slot                   = slot,

(not pasting the full diff because last time I did, git got confused and
considered the snippet part of the actual patch).

Without this patch, I was able to create a VM with MTE and guest_memfd
backed ram (the guest reported MTE as enabled, but I didn't test that it
actually worked).

With this patch, creating a VM with MTE is rejected.

[1] https://lore.kernel.org/kvmarm/20260712142536.1391557-1-fuad.tabba@linux.dev/

 arch/arm64/kvm/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..30c2ea235fa5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2648,8 +2648,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	/*
 	 * Only support guest_memfd backed memslots with mappable memory, since
 	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 *
+	 * MTE is also not supported with guest_memfd.
 	 */
-	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
+	if (kvm_slot_has_gmem(new) &&
+	    (kvm_has_mte(kvm) || !kvm_memslot_is_gmem_only(new)))
 		return -EINVAL;
 
 	hva = new->userspace_addr;

base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.55.0

