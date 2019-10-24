Return-Path: <SRS0=tvNx=YR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF192CA9EAF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 23:07:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8FA23222BE
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 23:07:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FA23222BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DE4E4A883;
	Thu, 24 Oct 2019 19:07:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GhwygqnF1qwB; Thu, 24 Oct 2019 19:07:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC2A24A847;
	Thu, 24 Oct 2019 19:07:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D61E14A57B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 19:07:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rWBCMZJY6arH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 19:07:48 -0400 (EDT)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 818B04A59D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 19:07:48 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
 by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 24 Oct 2019 16:07:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; d="scan'208";a="202445831"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
 by orsmga006.jf.intel.com with ESMTP; 24 Oct 2019 16:07:45 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v3 01/15] KVM: Reinstall old memslots if arch preparation fails
Date: Thu, 24 Oct 2019 16:07:30 -0700
Message-Id: <20191024230744.14543-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191024230744.14543-1-sean.j.christopherson@intel.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
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

Reinstall the old memslots if preparing the new memory region fails
after invalidating a to-be-{re}moved memslot.

Remove the superfluous 'old_memslots' variable so that it's somewhat
clear that the error handling path needs to free the unused memslots,
not simply the 'old' memslots.

Fixes: bc6678a33d9b9 ("KVM: introduce kvm->srcu and convert kvm_set_memory_region to SRCU update")
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b8534c6b8cf6..52deb5621501 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -936,7 +936,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	unsigned long npages;
 	struct kvm_memory_slot *slot;
 	struct kvm_memory_slot old, new;
-	struct kvm_memslots *slots = NULL, *old_memslots;
+	struct kvm_memslots *slots;
 	int as_id, id;
 	enum kvm_mr_change change;
 
@@ -1044,7 +1044,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		slot = id_to_memslot(slots, id);
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
-		old_memslots = install_new_memslots(kvm, as_id, slots);
+		/*
+		 * We can re-use the old memslots, the only difference from the
+		 * newly installed memslots is the invalid flag, which will get
+		 * dropped by update_memslots anyway.  We'll also revert to the
+		 * old memslots if preparing the new memory region fails.
+		 */
+		slots = install_new_memslots(kvm, as_id, slots);
 
 		/* From this point no new shadow pages pointing to a deleted,
 		 * or moved, memslot will be created.
@@ -1054,13 +1060,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		 *	- kvm_is_visible_gfn (mmu_check_roots)
 		 */
 		kvm_arch_flush_shadow_memslot(kvm, slot);
-
-		/*
-		 * We can re-use the old_memslots from above, the only difference
-		 * from the currently installed memslots is the invalid flag.  This
-		 * will get overwritten by update_memslots anyway.
-		 */
-		slots = old_memslots;
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, &new, mem, change);
@@ -1074,15 +1073,17 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	update_memslots(slots, &new, change);
-	old_memslots = install_new_memslots(kvm, as_id, slots);
+	slots = install_new_memslots(kvm, as_id, slots);
 
 	kvm_arch_commit_memory_region(kvm, mem, &old, &new, change);
 
 	kvm_free_memslot(kvm, &old, &new);
-	kvfree(old_memslots);
+	kvfree(slots);
 	return 0;
 
 out_slots:
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+		slots = install_new_memslots(kvm, as_id, slots);
 	kvfree(slots);
 out_free:
 	kvm_free_memslot(kvm, &new, &old);
-- 
2.22.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
