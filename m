Return-Path: <SRS0=E7bu=XG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E652FC49ED6
	for <kvmarm@archiver.kernel.org>; Wed, 11 Sep 2019 18:50:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF95820578
	for <kvmarm@archiver.kernel.org>; Wed, 11 Sep 2019 18:50:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF95820578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 671294A65B;
	Wed, 11 Sep 2019 14:50:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Um-YPobMei+H; Wed, 11 Sep 2019 14:50:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E360A4A67F;
	Wed, 11 Sep 2019 14:50:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E23904A653
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Sep 2019 14:50:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dbc+onAno-Sh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Sep 2019 14:50:45 -0400 (EDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9729E4A609
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Sep 2019 14:50:44 -0400 (EDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 11 Sep 2019 11:50:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; d="scan'208";a="196980903"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
 by orsmga002.jf.intel.com with ESMTP; 11 Sep 2019 11:50:41 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 13/13] KVM: Dynamically size memslot array based on number of
 used slots
Date: Wed, 11 Sep 2019 11:50:38 -0700
Message-Id: <20190911185038.24341-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190911185038.24341-1-sean.j.christopherson@intel.com>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-arm-kernel@lists.infradead.org,
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

Now that the memslot logic doesn't assume memslots are always non-NULL,
dynamically size the array of memslots instead of unconditionally
allocating memory for the maximum number of memslots.

Note, because a to-be-deleted memslot must first be invalidated, the
array size cannot be immediately reduced when deleting a memslot.
However, consecutive deletions will realize the memory savings, i.e.
a second deletion will trim the entry.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 include/linux/kvm_host.h |  5 ++++-
 virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 40ea5df50faa..8feb61bfbd1a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -433,11 +433,14 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
  */
 struct kvm_memslots {
 	u64 generation;
-	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
 	/* The mapping table from slot id to the index in memslots[]. */
 	short id_to_index[KVM_MEM_SLOTS_NUM];
 	atomic_t lru_slot;
 	int used_slots;
+	struct kvm_memory_slot memslots[];
+	/*
+	 * WARNING: 'memslots' is dynamically-sized.  It *MUST* be at the end.
+	 */
 };
 
 struct kvm {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e2571a9ccfc4..f952a0bec67a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -535,7 +535,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
 		return NULL;
 
 	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		slots->id_to_index[i] = slots->memslots[i].id = -1;
+		slots->id_to_index[i] = -1;
 
 	return slots;
 }
@@ -933,6 +933,32 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	return old_memslots;
 }
 
+/*
+ * Note, at a minimum, the current number of used slots must be allocated, even
+ * when deleting a memslot, as we need a complete duplicate of the memslots for
+ * use when invalidating a memslot prior to deleting/moving the memslot.
+ */
+static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
+					     enum kvm_mr_change change)
+{
+	struct kvm_memslots *slots;
+	size_t old_size, new_size;
+
+	old_size = sizeof(struct kvm_memslots) +
+		   (sizeof(struct kvm_memory_slot) * old->used_slots);
+
+	if (change == KVM_MR_CREATE)
+		new_size = old_size + sizeof(struct kvm_memory_slot);
+	else
+		new_size = old_size;
+
+	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
+	if (likely(slots))
+		memcpy(slots, old, old_size);
+
+	return slots;
+}
+
 static int kvm_set_memslot(struct kvm *kvm,
 			   const struct kvm_userspace_memory_region *mem,
 			   const struct kvm_memory_slot *old,
@@ -943,10 +969,9 @@ static int kvm_set_memslot(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	int r;
 
-	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
+	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
 	if (!slots)
 		return -ENOMEM;
-	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
 
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
 		/*
-- 
2.22.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
