Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83C4C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D7C4611C7
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7D7C4611C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC744B119;
	Wed,  3 Nov 2021 20:26:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fsq+JkHrO6tg; Wed,  3 Nov 2021 20:26:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04F334B0DB;
	Wed,  3 Nov 2021 20:26:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C90D4B1A4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PMu42K0-bfiD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:47 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DC5F4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:46 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 m17-20020a170902db1100b001421cb34857so1662037plx.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=WFKHlikOkpZJpdiLsH4aJihxblDmBHivJrGM8NlUt9c=;
 b=CRXCwBEqUdB8xBBWvbn9rvEyj5xPoJz0Yiq4O9bYP8Cnw9QN2e+/rU9Z5zno6u5DVK
 hNycH7Nu/XPtuVsGfPUbSSTGueoe3SJ6D/+uQvX8yXVdBR6JZwONNcY2XuE+tNblfPrg
 DzYe3VWSE9iz+kLrReWCKtPXc8mvDFxOyEZwsrJmqEqT2dddKgFB7DSFo4206QBqUe3l
 k94nG8IGw8Qk397gTW+mXweZuq2D9/OlhQu3qaAukGk74Ifow4G0x6SSEWRb7kyDOXHM
 mtFt8FUjKSwLn45cNEc6CmGXWE+Jks8EonoUKThzOIBSyaz6+hVlcyMpoJKcO82sckqF
 5Fzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=WFKHlikOkpZJpdiLsH4aJihxblDmBHivJrGM8NlUt9c=;
 b=vx5TeeDghd8l8fiGKKxKpWdQtwY84+fW5GED05A5GkwdfJy8L2U8j44G6NeSmWBtrw
 U8GTxXOP9oGQiMYh0dAGeFmuvJPCW66xyJTp0cegdCboYn6f7O0ITq2/m3t+q8U2339z
 LsMu2iyhV8eDoAja9ZUkOfkkEWYWIsb4wfrE17f7ws67uazR/yZ6PF7O4vtNWW7gpo6U
 BKpzQbUGwK7ZkTdOEdpXwI07TEPO8MuU71p6+y7USltwnfT8zsS0mcGIAMfi1uvRK7/y
 iYF0czT8sxlniLlbmku/MQFGJe9zjBJIFyY4T5TH0RYS1e+3OqPk5Kgmx92QocBJilMO
 AGpw==
X-Gm-Message-State: AOAM531UW5tAfRCjc4gur0xW/Mwkvz2wkBFHR+BplA3bnaYbmAFMcdTR
 CXh09RDzyixUWcm6PuEhsgt9Gke9FUA=
X-Google-Smtp-Source: ABdhPJxoDZvqdkusy2MitxT+1dAwOu5YXFxH0crl6GBFlwKLx55yi8xQIaLV4Wu5oujGScgLca++ESEBh4I=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1994:b0:47e:64e5:a1b3
 with SMTP id
 d20-20020a056a00199400b0047e64e5a1b3mr42939171pfl.64.1635985605387; Wed, 03
 Nov 2021 17:26:45 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:28 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-28-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 27/30] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-riscv@lists.infradead.org,
 Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Introduce a memslots gfn upper bound operation and use it to optimize
kvm_zap_gfn_range().
This way this handler can do a quick lookup for intersecting gfns and won't
have to do a linear scan of the whole memslot set.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 11 +++++--
 include/linux/kvm_host.h | 69 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 09ff0ccaa203..14e41278c069 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5714,16 +5714,20 @@ static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	const struct kvm_memory_slot *memslot;
 	struct kvm_memslots *slots;
+	struct rb_node *node;
 	bool flush = false;
 	gfn_t start, end;
-	int i, bkt;
+	int i, idx;
 
 	if (!kvm_memslots_have_rmaps(kvm))
 		return flush;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(memslot, bkt, slots) {
+		idx = slots->node_idx;
+
+		kvm_for_each_memslot_in_gfn_range(node, slots, gfn_start, gfn_end) {
+			memslot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
 			start = max(gfn_start, memslot->base_gfn);
 			end = min(gfn_end, memslot->base_gfn + memslot->npages);
 			if (start >= end)
@@ -5747,6 +5751,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	bool flush;
 	int i;
 
+	if (WARN_ON_ONCE(gfn_end <= gfn_start))
+		return;
+
 	write_lock(&kvm->mmu_lock);
 
 	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6888f3c2e04b..810a5b958697 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -832,6 +832,75 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 	return NULL;
 }
 
+static inline
+struct rb_node *kvm_memslots_gfn_upper_bound(struct kvm_memslots *slots, gfn_t gfn)
+{
+	int idx = slots->node_idx;
+	struct rb_node *node, *result = NULL;
+
+	for (node = slots->gfn_tree.rb_node; node; ) {
+		struct kvm_memory_slot *slot;
+
+		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
+		if (gfn < slot->base_gfn) {
+			result = node;
+			node = node->rb_left;
+		} else
+			node = node->rb_right;
+	}
+
+	return result;
+}
+
+static inline
+struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t start)
+{
+	struct rb_node *node;
+
+	/*
+	 * Find the slot with the lowest gfn that can possibly intersect with
+	 * the range, so we'll ideally have slot start <= range start
+	 */
+	node = kvm_memslots_gfn_upper_bound(slots, start);
+	if (node) {
+		struct rb_node *pnode;
+
+		/*
+		 * A NULL previous node means that the very first slot
+		 * already has a higher start gfn.
+		 * In this case slot start > range start.
+		 */
+		pnode = rb_prev(node);
+		if (pnode)
+			node = pnode;
+	} else {
+		/* a NULL node below means no slots */
+		node = rb_last(&slots->gfn_tree);
+	}
+
+	return node;
+}
+
+static inline
+bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *node, gfn_t end)
+{
+	struct kvm_memory_slot *memslot;
+
+	memslot = container_of(node, struct kvm_memory_slot, gfn_node[slots->node_idx]);
+
+	/*
+	 * If this slot starts beyond or at the end of the range so does
+	 * every next one
+	 */
+	return memslot->base_gfn >= end;
+}
+
+/* Iterate over each memslot *possibly* intersecting [start, end) range */
+#define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
+	for (node = kvm_for_each_in_gfn_first(slots, start);		\
+	     node && !kvm_for_each_in_gfn_no_more(slots, node, end);	\
+	     node = rb_next(node))					\
+
 /*
  * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
  * - create a new memory slot
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
