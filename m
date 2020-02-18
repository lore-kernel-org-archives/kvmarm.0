Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3AEC34049
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 21:08:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2338224125
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 21:08:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2338224125
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B39E74AF86;
	Tue, 18 Feb 2020 16:08:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bzcjZ8MzZSGT; Tue, 18 Feb 2020 16:08:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A4034AF8F;
	Tue, 18 Feb 2020 16:07:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D6684AF18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 16:07:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oXLLwsEN-Ghe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 16:07:48 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A94514AF48
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 16:07:48 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Feb 2020 13:07:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; d="scan'208";a="253856435"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga002.jf.intel.com with ESMTP; 18 Feb 2020 13:07:45 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v6 12/22] KVM: Move memslot deletion to helper function
Date: Tue, 18 Feb 2020 13:07:26 -0800
Message-Id: <20200218210736.16432-13-sean.j.christopherson@intel.com>
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

Move memslot deletion into its own routine so that the success path for
other memslot updates does not need to use kvm_free_memslot(), i.e. can
explicitly destroy the dirty bitmap when necessary.  This paves the way
for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
NULL for @dont.

Add a comment above the code to make a copy of the existing memslot
prior to deletion, it is not at all obvious that the pointer will become
stale during sorting and/or installation of new memslots.

Note, kvm_arch_commit_memory_region() allows an architecture to free
resources when moving a memslot or changing its flags, e.g. x86 frees
its arch specific memslot metadata during commit_memory_region().

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Tested-by: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 75 +++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f84bb0442a1b..1f56a0d042a0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1043,6 +1043,27 @@ static int kvm_set_memslot(struct kvm *kvm,
 	return r;
 }
 
+static int kvm_delete_memslot(struct kvm *kvm,
+			      const struct kvm_userspace_memory_region *mem,
+			      struct kvm_memory_slot *old, int as_id)
+{
+	struct kvm_memory_slot new;
+	int r;
+
+	if (!old->npages)
+		return -EINVAL;
+
+	memset(&new, 0, sizeof(new));
+	new.id = old->id;
+
+	r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
+	if (r)
+		return r;
+
+	kvm_free_memslot(kvm, old, NULL);
+	return 0;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -1092,7 +1113,17 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (npages > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
 
-	new = old = *slot;
+	/*
+	 * Make a full copy of the old memslot, the pointer will become stale
+	 * when the memslots are re-sorted by update_memslots(), and the old
+	 * memslot needs to be referenced after calling update_memslots(), e.g.
+	 * to free its resources and for arch specific behavior.
+	 */
+	old = *slot;
+	if (!mem->memory_size)
+		return kvm_delete_memslot(kvm, mem, &old, as_id);
+
+	new = old;
 
 	new.id = id;
 	new.base_gfn = base_gfn;
@@ -1100,29 +1131,20 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new.flags = mem->flags;
 	new.userspace_addr = mem->userspace_addr;
 
-	if (npages) {
-		if (!old.npages)
-			change = KVM_MR_CREATE;
-		else { /* Modify an existing slot. */
-			if ((new.userspace_addr != old.userspace_addr) ||
-			    (npages != old.npages) ||
-			    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
-				return -EINVAL;
-
-			if (base_gfn != old.base_gfn)
-				change = KVM_MR_MOVE;
-			else if (new.flags != old.flags)
-				change = KVM_MR_FLAGS_ONLY;
-			else /* Nothing to change. */
-				return 0;
-		}
-	} else {
-		if (!old.npages)
+	if (!old.npages) {
+		change = KVM_MR_CREATE;
+	} else { /* Modify an existing slot. */
+		if ((new.userspace_addr != old.userspace_addr) ||
+		    (npages != old.npages) ||
+		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
-		change = KVM_MR_DELETE;
-		new.base_gfn = 0;
-		new.flags = 0;
+		if (base_gfn != old.base_gfn)
+			change = KVM_MR_MOVE;
+		else if (new.flags != old.flags)
+			change = KVM_MR_FLAGS_ONLY;
+		else /* Nothing to change. */
+			return 0;
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
@@ -1145,17 +1167,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			return r;
 	}
 
-	/* actual memory is freed via old in kvm_free_memslot below */
-	if (change == KVM_MR_DELETE) {
-		new.dirty_bitmap = NULL;
-		memset(&new.arch, 0, sizeof(new.arch));
-	}
-
 	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
 	if (r)
 		goto out_bitmap;
 
-	kvm_free_memslot(kvm, &old, &new);
+	if (old.dirty_bitmap && !new.dirty_bitmap)
+		kvm_destroy_dirty_bitmap(&old);
 	return 0;
 
 out_bitmap:
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
