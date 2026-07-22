Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C9B3BF694
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 09:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784711059; cv=none; b=Uh84znOqan+dvY9R6LruNCdRxlU+CmDXWLtSZogOI1Dk2lQQLeT5oYx620Op7N4dVklBDFd18/amKUa+h5Kai8lP5+8XrVGUzEHm3l0TN9QYTH/lAFhm6cRGq/RRAX+Ij1tHx/F0OinI22gRmo4JIcbEhhQVWsilRfylAlgqboM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784711059; c=relaxed/simple;
	bh=Uy08OORctNYlnzgl0dsDXziNd6DInQRYFzqtacEn7L8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l7S9DnUufNGwybdxM7yl1/UNOEi41ykpNH8EwWbnxcuObUf12LqAT4D40tVzXXVZIdB8ewCfxk3Q06XgYcWw3hCT+MDAn5Cqg2lHVwb692UIQAorYhETJJ3zrEslevvSKG7sI2Zhbo9ZH9IHIofIr0iPWZBE/015BnMYLvR5Npk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=E/qgmAoz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="E/qgmAoz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E8D41595;
	Wed, 22 Jul 2026 02:04:12 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A33BF3F86F;
	Wed, 22 Jul 2026 02:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784711056; bh=Uy08OORctNYlnzgl0dsDXziNd6DInQRYFzqtacEn7L8=;
	h=From:To:Cc:Subject:Date:From;
	b=E/qgmAozHkMq3Ywwistu37+/zUddgE929GJtnoSOaUIk2X4IzugM1Ug+gW0kSXdmk
	 YmEQH3I7tUSa+BJfRr/22bjgaWkCVuobRrtOS9uPALNgo5uiZ9QXF1+ipXR5qBnh4K
	 Y+qO+G20HRIjtp8y/dQk4JunzzFjuKgw3zwo61+Q=
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
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v4] KVM: arm64: Reject guest_memfd memslots when the VM has MTE
Date: Wed, 22 Jul 2026 10:03:54 +0100
Message-ID: <20260722090354.94245-1-alexandru.elisei@arm.com>
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

However, the documentation for KVM_SET_USER_MEMORY_REGION2 explicitly
states that the only condition for userspace_addr is for it to be a legal
userspace address, but the mapping is not required to be valid nor
populated at memslot creation.

If userspace sets userspace_addr to an address that hasn't been mapped, or
if userspace_addr belongs to a VMA that isn't backed by the guest_memfd
file, or if the VMA doesn't intersect the memslot, memslot creation is
successful and KVM ends up with a VM with MTE and guest_memfd-backed
memslots.

The same happens if the order is reversed: when userspace enables MTE, KVM
does not check if memslots backed by guest_memfd are already present.

Fix both issues by rejecting guest_memfd-backed memslots when MTE is
enabled, and by rejecting MTE when guest_memfd-backed memslots are already
present.

Fixes: 32e200bd6e44 ("KVM: arm64: Enable support for guest_memfd backed memory")
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

v3 can be found at [1].

Changes in v4:

* Fixed the wording in docs (Fuad)
* Added Reviewed-by from Fuad (thanks!)

[1] https://lore.kernel.org/kvmarm/20260721100654.476582-1-alexandru.elisei@arm.com/

 Documentation/virt/kvm/api.rst |  6 ++++++
 arch/arm64/kvm/arm.c           | 25 +++++++++++++++++++------
 arch/arm64/kvm/mmu.c           |  4 ++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a5f9ee92f43e..e3003a241d5b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8414,6 +8414,12 @@ When this capability is enabled all memory in memslots must be mapped as
 attempts to create a memslot with an invalid mmap will result in an
 -EINVAL return.
 
+``guest_memfd``, even though it is an anonymous file, is not supported with MTE.
+Attempting to create a memslot backed by ``guest_memfd`` when the MTE capability
+is enabled, or attempting to enable the MTE capability after
+``guest_memfd``-backed memslots have been created, will result in an -EINVAL
+return.
+
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..9a6c72a18672 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -149,14 +149,27 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			&kvm->arch.flags);
 		break;
-	case KVM_CAP_ARM_MTE:
-		mutex_lock(&kvm->lock);
-		if (system_supports_mte() && !kvm->created_vcpus) {
-			r = 0;
-			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
+	case KVM_CAP_ARM_MTE: {
+		struct kvm_memory_slot *memslot;
+		int bkt;
+
+		guard(mutex)(&kvm->lock);
+		if (!system_supports_mte() || kvm->created_vcpus)
+			break;
+
+		r = 0;
+		guard(mutex)(&kvm->slots_lock);
+		kvm_for_each_memslot(memslot, bkt, kvm_memslots(kvm)) {
+			if (kvm_slot_has_gmem(memslot)) {
+				r = -EINVAL;
+				break;
+			}
 		}
-		mutex_unlock(&kvm->lock);
+		if (r == 0)
+			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
 		break;
+
+	}
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..2d95203386ba 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2652,6 +2652,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
 		return -EINVAL;
 
+	/* guest_memfd is incompatible with MTE. */
+	if (kvm_slot_has_gmem(new) && kvm_has_mte(kvm))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 

base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
2.55.0

