Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78494C3404B
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 21:08:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E6ED2176D
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 21:08:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E6ED2176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC5634AF9C;
	Tue, 18 Feb 2020 16:08:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hAtPJWzv4sAA; Tue, 18 Feb 2020 16:08:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8387D4AFB2;
	Tue, 18 Feb 2020 16:07:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D7624AF18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 16:07:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bUJUQic-f8It for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 16:07:53 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3166F4AF75
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 16:07:48 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Feb 2020 13:07:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; d="scan'208";a="253856443"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga002.jf.intel.com with ESMTP; 18 Feb 2020 13:07:46 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v6 14/22] KVM: Clean up local variable usage in
 __kvm_set_memory_region()
Date: Tue, 18 Feb 2020 13:07:28 -0800
Message-Id: <20200218210736.16432-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218210736.16432-1-sean.j.christopherson@intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

Clean up __kvm_set_memory_region() to achieve several goals:

  - Remove local variables that serve no real purpose
  - Improve the readability of the code
  - Better show the relationship between the 'old' and 'new' memslot
  - Prepare for dynamically sizing memslots
  - Document subtle gotchas (via comments)

Note, using 'tmp' to hold the initial memslot is not strictly necessary
at this juncture, e.g. 'old' could be directly copied from
id_to_memslot(), but keep the pointer usage as id_to_memslot() will be
able to return a NULL pointer once memslots are dynamically sized.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 50 +++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1ef5e04f7b93..00ece4a5cdbb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1071,13 +1071,11 @@ static int kvm_delete_memslot(struct kvm *kvm,
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem)
 {
-	int r;
-	gfn_t base_gfn;
-	unsigned long npages;
-	struct kvm_memory_slot *slot;
 	struct kvm_memory_slot old, new;
-	int as_id, id;
+	struct kvm_memory_slot *tmp;
 	enum kvm_mr_change change;
+	int as_id, id;
+	int r;
 
 	r = check_memory_region_flags(mem);
 	if (r)
@@ -1102,54 +1100,58 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		return -EINVAL;
 
-	slot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
-	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
-	npages = mem->memory_size >> PAGE_SHIFT;
-
-	if (npages > KVM_MEM_MAX_NR_PAGES)
-		return -EINVAL;
-
 	/*
 	 * Make a full copy of the old memslot, the pointer will become stale
 	 * when the memslots are re-sorted by update_memslots(), and the old
 	 * memslot needs to be referenced after calling update_memslots(), e.g.
-	 * to free its resources and for arch specific behavior.
+	 * to free its resources and for arch specific behavior.  Kill @tmp
+	 * after making a copy to deter potentially dangerous usage.
 	 */
-	old = *slot;
+	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
+	old = *tmp;
+	tmp = NULL;
+
 	if (!mem->memory_size)
 		return kvm_delete_memslot(kvm, mem, &old, as_id);
 
-	new = old;
-
 	new.id = id;
-	new.base_gfn = base_gfn;
-	new.npages = npages;
+	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
+	new.npages = mem->memory_size >> PAGE_SHIFT;
 	new.flags = mem->flags;
 	new.userspace_addr = mem->userspace_addr;
 
+	if (new.npages > KVM_MEM_MAX_NR_PAGES)
+		return -EINVAL;
+
 	if (!old.npages) {
 		change = KVM_MR_CREATE;
+		new.dirty_bitmap = NULL;
+		memset(&new.arch, 0, sizeof(new.arch));
 	} else { /* Modify an existing slot. */
 		if ((new.userspace_addr != old.userspace_addr) ||
-		    (npages != old.npages) ||
+		    (new.npages != old.npages) ||
 		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
-		if (base_gfn != old.base_gfn)
+		if (new.base_gfn != old.base_gfn)
 			change = KVM_MR_MOVE;
 		else if (new.flags != old.flags)
 			change = KVM_MR_FLAGS_ONLY;
 		else /* Nothing to change. */
 			return 0;
+
+		/* Copy dirty_bitmap and arch from the current memslot. */
+		new.dirty_bitmap = old.dirty_bitmap;
+		memcpy(&new.arch, &old.arch, sizeof(new.arch));
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
 		/* Check for overlaps */
-		kvm_for_each_memslot(slot, __kvm_memslots(kvm, as_id)) {
-			if (slot->id == id)
+		kvm_for_each_memslot(tmp, __kvm_memslots(kvm, as_id)) {
+			if (tmp->id == id)
 				continue;
-			if (!((base_gfn + npages <= slot->base_gfn) ||
-			      (base_gfn >= slot->base_gfn + slot->npages)))
+			if (!((new.base_gfn + new.npages <= tmp->base_gfn) ||
+			      (new.base_gfn >= tmp->base_gfn + tmp->npages)))
 				return -EEXIST;
 		}
 	}
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
