Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429442571B8
	for <kvmarm@lists.linux.dev>; Thu, 25 Jun 2026 13:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392962; cv=none; b=XwgGhjSsJBxYW9xHOIAmBpgAl6pO0FpHOkT9624hNxgrweHKLEhNCFkp91/x7U7vbtw2SSUqcfqQWzw9YoEsYksB8cnSo1J8Zh0FHpNtYKb3UOKn6A5iiDTFouA8wT6ldU/VruVaFmjV8NHpbsyAcb0rXVgB2JBUnL2zRPB2dSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392962; c=relaxed/simple;
	bh=W1Pk/Aig6XQAQUmneVlul/0sh19poM1E5RZ9IEe7iNA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=em4hsIUw69p1aH6IAPzGlEViIkKmqwk4UeBLqD3e9trTkSYyeYcOcnK3Wn8yyzfj2G0Zp6uJXBr9IO9li2tX2brVm0dSJ/I4rvPMw1vLd4zyhVDFRFj0VS9lL17sm+lKLlpFADU3/ovwsV1/U2qZuUAbaiII3g/UEWi3hZw7B3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G6MKINYb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G6MKINYb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AB923297;
	Thu, 25 Jun 2026 06:09:16 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C3B93F62B;
	Thu, 25 Jun 2026 06:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782392960; bh=W1Pk/Aig6XQAQUmneVlul/0sh19poM1E5RZ9IEe7iNA=;
	h=From:To:Subject:Date:From;
	b=G6MKINYbpZk+0KBQ1sq+RTQZfHSlWXg1EMU4ckBHmOqrKJkum+JvnRu5RnAgfXEfl
	 ue0SlVcZdaRHriEuz3Uwpw+1nM8xNWCO2FjVXia6R0ghey12qqMVzV7xiWPkhoSYnP
	 UfFOYJKv57122qemPJYUBlBaRujReptrSdSHFJ14=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	seanjc@google.com,
	david.hildenbrand@arm.com,
	mark.rutland@arm.com,
	ackerleytng@google.com
Subject: [PATCH v1] KVM: Ignore MMU notifiers for guest_memfd-only memslots
Date: Thu, 25 Jun 2026 14:09:02 +0100
Message-ID: <20260625130902.258331-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For guest_memfd-only memslots (kvm_memslot_is_gmem_only() is true), the
memory provider for the virtual machine is the guest_memfd file, not the
userspace mapping. Mappings in the secondary MMU are established by
obtaining folios from guest_memfd directly, not by looking the folios up
through the page tables through GUP. Consequently, there is no relationship
between the page tables and the secondary MMU: MMU notifiers do not apply.

Despite this, KVM's MMU notifiers still modify the secondary MMU page
tables, only for the same memory to be remapped the next time a guest
accesses it. Make the disconnect between the user mapping and the secondary
MMU page tables explicit by ignoring the MMU notifiers for guest_memfd-only
memslots.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
RFC can be found here [1].

The only theoretical instance where the MMU notifiers are invoked for the
userspace mapping of a guest_memfd-only memslot that I was able to find was
automatic NUMA balancing with a non-NULL NUMA policy for the guest_memfd
file. I wasn't able to test it in practice. Ackerley Tng also mentioned
that this change would fix double unmap on a shared to private in-place
conversion of the guest_memfd memory [2].

When and if it happens, having memory unmapped from the seconday MMU in the
case of a guest_memfd-only memslot is at most a performance issue (it
causes unnecessary guest faults), but having memory that stays mapped at
stage 2 (unless userspace explicitly unmaps it from the VM) is needed for a
Arm feature (called SPE, Statistical Profiling Extension) that I'm working
to upstream. This patch aims to provide the guarantee that memory won't be
unmapped from the secondary MMU without the VMM explicitely triggering it
(by punching a hole or closing the guest_memfd file).

Ran a basic test by hacking KVM_PRE_FAULT_MEMORY for arm64, and modifying
kvmtool to apply it on the entire VM memory, then munmap the same memory
from its page tables. Also hacked guest_memfd + GUEST_MEMFD_FLAG_MMAP
support in kvmtool. Put traces in the arm64 fault handling code and printfs
in kvm_mmu_unmap_gfn_range(). When running a guest, KVM doesn't unmap the
memory from the secondary MMU when kvmtool munmaps it; all the faults
triggered by the guest on the guest_memfd backed memslots are instruction
faults; and KVM unmaps the guest memory from the secondary MMU when the
guest_memfd file is closed by userspace. Looks correct to me.

Changes in RFC -> v1:

* Dropped the RFC tag.
* Fix unbalanced invalidation reported by sashiko by implementing Sean's
  approach; I've expanded it to page ageing.
* Modified the commit message as per DavidH comment.

[1] https://lore.kernel.org/kvm/20260615155244.183044-1-alexandru.elisei@arm.com/
[2] https://lore.kernel.org/kvm/CAEvNRgE9cLfjDbXuR5wq3fEWZyHxYPxdExxNjXUFO1nT5m==1A@mail.gmail.com/

 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 50 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4c14aee1fb06..483ad9fe8fb7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -260,6 +260,7 @@ union kvm_mmu_notifier_arg {
 enum kvm_gfn_range_filter {
 	KVM_FILTER_SHARED		= BIT(0),
 	KVM_FILTER_PRIVATE		= BIT(1),
+	KVM_FILTER_USERSPACE_MAPPINGS	= BIT(2),
 };
 
 struct kvm_gfn_range {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 881f92d7a469..204e7faa325a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -607,8 +607,13 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 			/*
 			 * HVA-based notifications aren't relevant to private
 			 * mappings as they don't have a userspace mapping.
+			 *
+			 * Memslots where guest_memfd is the only memory
+			 * provider can also safely ignore changes to the
+			 * userspace mapping.
 			 */
-			gfn_range.attr_filter = KVM_FILTER_SHARED;
+			gfn_range.attr_filter = KVM_FILTER_SHARED |
+						KVM_FILTER_USERSPACE_MAPPINGS;
 
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -715,6 +720,21 @@ void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end)
 bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
+
+	/*
+	 * When reacting to changes in userspace mappings, don't unmap memslots
+	 * that are guest_memfd-only, in which case KVM's MMU mappings are
+	 * pulled directly from guest_memfd, i.e. don't depend on the userspace
+	 * mappings.
+	 *
+	 * TODO: Skip gmem-only memslots on mmu_notifier events entirely, once
+	 * gfn_to_pfn_cache is also wired up to directly pull from guest_memfd.
+	 */
+	if (range->attr_filter & KVM_FILTER_USERSPACE_MAPPINGS &&
+	    kvm_slot_has_gmem(range->slot) &&
+	    kvm_memslot_is_gmem_only(range->slot))
+		return false;
+
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
@@ -825,12 +845,23 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
 }
 
+static bool kvm_mmu_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	/* See comment in kvm_mmu_unmap_gfn_range() */
+	if (range->attr_filter & KVM_FILTER_USERSPACE_MAPPINGS &&
+	    kvm_slot_has_gmem(range->slot) &&
+	    kvm_memslot_is_gmem_only(range->slot))
+		return false;
+
+	return kvm_age_gfn(kvm, range);
+}
+
 static bool kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 		struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	trace_kvm_age_hva(start, end);
 
-	return kvm_age_hva_range(mn, start, end, kvm_age_gfn,
+	return kvm_age_hva_range(mn, start, end, kvm_mmu_age_gfn,
 				 !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG));
 }
 
@@ -852,7 +883,18 @@ static bool kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-	return kvm_age_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+	return kvm_age_hva_range_no_flush(mn, start, end, kvm_mmu_age_gfn);
+}
+
+static bool kvm_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	/* See comment in kvm_mmu_unmap_gfn_range() */
+	if (range->attr_filter & KVM_FILTER_USERSPACE_MAPPINGS &&
+	    kvm_slot_has_gmem(range->slot) &&
+	    kvm_memslot_is_gmem_only(range->slot))
+		return false;
+
+	return kvm_test_age_gfn(kvm, range);
 }
 
 static bool kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -861,7 +903,7 @@ static bool kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	trace_kvm_test_age_hva(address);
 
 	return kvm_age_hva_range_no_flush(mn, address, address + 1,
-					  kvm_test_age_gfn);
+					  kvm_mmu_test_age_gfn);
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,

base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
2.54.0

