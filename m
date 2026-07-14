Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54DD04A33FD
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784045065; cv=none; b=l9LnUbzYdG+tfxVttJQI+WBSMy3xkkijXap1QBo0dMqg5ZzZxi7l6UfT8nO6Kzjc3ZSAc2TDMN+r2Sqdah4xuPkGbtP0rde2c4l+nuPyGZsTofMhVbN2thIFY5m1pr2OxBAPnMizHf29tVBf+RtIItPQ9aa3/gvSEgenIRdHhOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784045065; c=relaxed/simple;
	bh=t2KYfj/agvlS18IATNMk9iCfEZE6pPzvSrr+EZU4WmA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=E3xG+o8qA0NEKC5ckrQq7IP2AACEZrGmsGI/8s+JsawxNP18dwc2KYcklc4JsB/LQHhg3OS5juAQm8sJ1BNTG9TZmF75hoDNIH8IBh+RezzUsdkRNkG3ZOxp5ZWji4g9OTEY0tDDLnIddgvNPEKfPf7hLwXrGaOUQpDLbZNSe/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cj+ccMvx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cj+ccMvx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C436339;
	Tue, 14 Jul 2026 09:04:18 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 009BD3F7B4;
	Tue, 14 Jul 2026 09:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784045062; bh=t2KYfj/agvlS18IATNMk9iCfEZE6pPzvSrr+EZU4WmA=;
	h=From:To:Subject:Date:From;
	b=cj+ccMvxR7Gp0S6Df60GrepTnSACTST8Nvb6CfEG2XojadhD4TYl0Til1+IELdFyI
	 1xuBXBpas50TFEvHjni8AHUWyYyoIhRku6BYo0rgrSHBUXA/vTovvp9lgyaMcucGNs
	 pmupE1IXyIS0bNsCSGdpOs7Eww+2W140P0I904rs=
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
Subject: [PATCH v2] KVM: Ignore MMU notifiers for guest_memfd-only memslots
Date: Tue, 14 Jul 2026 17:04:11 +0100
Message-ID: <20260714160411.302386-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.55.0
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
v1 can be found here [1].

Same testing as in v1: on arm64, mapped guest_memfd in kvmtool's address
space, used KVM_PRE_FAULT_MEMORY to map the entire stage 2, then unmapped
guest_memfd from kvmtool's address space. The memory remained mapped at
stage 2.

Changes in v2:

* Rebased on top of v7.2-rc3.

Changes in v1:

* Dropped the RFC tag.
* Fix unbalanced invalidation reported by sashiko by implementing Sean's
  approach; I've expanded it to page ageing.
* Modified the commit message as per DavidH comment.

[1] https://lore.kernel.org/kvm/20260625130902.258331-1-alexandru.elisei@arm.com/

 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 50 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab8cfaec82d3..ecf5c0cbf0f0 100644
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
index e44c20c04961..bd469395f176 100644
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

base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.55.0

