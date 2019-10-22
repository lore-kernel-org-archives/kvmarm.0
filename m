Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED56CA9EB7
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 00:35:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCB5E214B2
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 00:35:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCB5E214B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7867E4AA07;
	Mon, 21 Oct 2019 20:35:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UI-rFMPRPPxU; Mon, 21 Oct 2019 20:35:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 781BF4AC24;
	Mon, 21 Oct 2019 20:35:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F8CE4A9D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 20:35:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w-7gqBtJ+uDR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 20:35:43 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 586D24A9DA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 20:35:42 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 21 Oct 2019 17:35:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; d="scan'208";a="348897220"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
 by orsmga004.jf.intel.com with ESMTP; 21 Oct 2019 17:35:39 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v2 08/15] KVM: Move setting of memslot into helper routine
Date: Mon, 21 Oct 2019 17:35:30 -0700
Message-Id: <20191022003537.13013-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022003537.13013-1-sean.j.christopherson@intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Split out the core functionality of setting a memslot into a separate
helper in preparation for moving memslot deletion into its own routine.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 106 ++++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 43 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 40e27ffaf29a..b534865754b6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -908,6 +908,66 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	return old_memslots;
 }
 
+static int kvm_set_memslot(struct kvm *kvm,
+			   const struct kvm_userspace_memory_region *mem,
+			   const struct kvm_memory_slot *old,
+			   struct kvm_memory_slot *new, int as_id,
+			   enum kvm_mr_change change)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	int r;
+
+	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
+	if (!slots)
+		return -ENOMEM;
+	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
+
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+		/*
+		 * Note, the INVALID flag needs to be in the appropriate entry
+		 * in the freshly allocated memslots, not in @old or @new.
+		 */
+		slot = id_to_memslot(slots, old->id);
+		slot->flags |= KVM_MEMSLOT_INVALID;
+
+		/*
+		 * We can re-use the old memslots, the only difference from the
+		 * newly installed memslots is the invalid flag, which will get
+		 * dropped by update_memslots anyway.  We'll also revert to the
+		 * old memslots if preparing the new memory region fails.
+		 */
+		slots = install_new_memslots(kvm, as_id, slots);
+
+		/* From this point no new shadow pages pointing to a deleted,
+		 * or moved, memslot will be created.
+		 *
+		 * validation of sp->gfn happens in:
+		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
+		 *	- kvm_is_visible_gfn (mmu_check_roots)
+		 */
+		kvm_arch_flush_shadow_memslot(kvm, slot);
+	}
+
+	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
+	if (r)
+		goto out_slots;
+
+	update_memslots(slots, new, change);
+	slots = install_new_memslots(kvm, as_id, slots);
+
+	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
+
+	kvfree(slots);
+	return 0;
+
+out_slots:
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+		slots = install_new_memslots(kvm, as_id, slots);
+	kvfree(slots);
+	return r;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -924,7 +984,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	unsigned long npages;
 	struct kvm_memory_slot *slot;
 	struct kvm_memory_slot old, new;
-	struct kvm_memslots *slots;
 	int as_id, id;
 	enum kvm_mr_change change;
 
@@ -1011,58 +1070,19 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			return r;
 	}
 
-	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
-	if (!slots) {
-		r = -ENOMEM;
-		goto out_bitmap;
-	}
-	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
-
-	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
-		slot = id_to_memslot(slots, id);
-		slot->flags |= KVM_MEMSLOT_INVALID;
-
-		/*
-		 * We can re-use the old memslots, the only difference from the
-		 * newly installed memslots is the invalid flag, which will get
-		 * dropped by update_memslots anyway.  We'll also revert to the
-		 * old memslots if preparing the new memory region fails.
-		 */
-		slots = install_new_memslots(kvm, as_id, slots);
-
-		/* From this point no new shadow pages pointing to a deleted,
-		 * or moved, memslot will be created.
-		 *
-		 * validation of sp->gfn happens in:
-		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
-		 *	- kvm_is_visible_gfn (mmu_check_roots)
-		 */
-		kvm_arch_flush_shadow_memslot(kvm, slot);
-	}
-
-	r = kvm_arch_prepare_memory_region(kvm, &new, mem, change);
-	if (r)
-		goto out_slots;
-
 	/* actual memory is freed via old in kvm_free_memslot below */
 	if (change == KVM_MR_DELETE) {
 		new.dirty_bitmap = NULL;
 		memset(&new.arch, 0, sizeof(new.arch));
 	}
 
-	update_memslots(slots, &new, change);
-	slots = install_new_memslots(kvm, as_id, slots);
-
-	kvm_arch_commit_memory_region(kvm, mem, &old, &new, change);
+	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
+	if (r)
+		goto out_bitmap;
 
 	kvm_free_memslot(kvm, &old, &new);
-	kvfree(slots);
 	return 0;
 
-out_slots:
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
-		slots = install_new_memslots(kvm, as_id, slots);
-	kvfree(slots);
 out_bitmap:
 	if (new.dirty_bitmap && !old.dirty_bitmap)
 		kvm_destroy_dirty_bitmap(&new);
-- 
2.22.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
