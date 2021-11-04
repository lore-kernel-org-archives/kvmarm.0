Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DCDAC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5230C611CA
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5230C611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01B054B1E0;
	Wed,  3 Nov 2021 20:26:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yitjtbb+yN+j; Wed,  3 Nov 2021 20:26:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 546884B0E2;
	Wed,  3 Nov 2021 20:26:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC54A4B14C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8rEVkjqigXzr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:36 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB6FD4B13D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:35 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 y13-20020a1709029b8d00b0013dc7c668e2so1918406plp.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=FUEi7KfqPphzymRQTGTbfOx/MaI4KzNKcipjuT8FVdY=;
 b=dFLgxm0c72Sa9o7RZRhGakedthtd0rFQ9fxpUH7hzUonvUmaEHzTEnr9Z7QKN+CMp/
 UnHWs+AkXOLJwNuZqSXK1TbkIXte514NBf/fueQC3NI4aiWd2h85ZQ55FxOM3E6EZZr8
 49Ow/tJTyTy5Xhf5TSJTHjUY9Vrt2JWRXIpRq3jtBZ24fzBy9ywvoMoucypPleHtz7Bt
 nyGl9zsi/YAZTSoy9L2rlvKnLcaek2cAGwNHMKjOBf2K1E/oRLqh2gz69UfhBmUXR2vR
 bqL0iE5lPgi5OSkY6KeTt/6FnfFKdVm554W2sAwUPzX0qvPyOIEUQT5iY+zRVA9g6jW8
 c+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=FUEi7KfqPphzymRQTGTbfOx/MaI4KzNKcipjuT8FVdY=;
 b=FLXmLCoUgRr3qPJwZ0ockhIB9lRDwtvN0U85o2ZoWz931TDCRm67a1ZHARmB9XbGk6
 YwqxUQgtlPrqVAsLpKvflEli2XhM28UDuphs2SicVYCS229bhgNA3Z/nrxFhuB8EhxNf
 WQsCdM8GwBRgO9N1FfjV4vECzMDSH61di6bDQDWNfPrXRvxsroHz3a55/ctdVQHcw6aK
 PoA4Qdyb+J6MmHQQLJovlnD4mckCl3414nV465OuR7+WJ8IWHa+CDPuIabYGac6lU8bf
 Y6BWznJHlN+MIBYy+rC0g/XoByNhyyUTgf6KYDkT0zUqbTtwsBehu3K8fJTHyGDMlBKK
 9L2w==
X-Gm-Message-State: AOAM530mf0E4p0iRcxyeo2YG80ekXMRaMLxDTTmzyQBU++XWyRSJVCfy
 Dg/fnGrNrRJ2+F2UGY1ITxaS9+ZC48o=
X-Google-Smtp-Source: ABdhPJzI7wXfhmzIb07WZ6IKVyEUUmbTY3InZMh88rZP6YElu9I5y2TlNvxIb1UtjdEBVBmnF7+gpU4SBUM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c3:: with SMTP id
 v3mr252447pjd.0.1635985594374; Wed, 03 Nov 2021 17:26:34 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:22 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-22-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 21/30] KVM: Integrate gfn_to_memslot_approx() into
 search_memslots()
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

s390 arch has gfn_to_memslot_approx() which is almost identical to
search_memslots(), differing only in that in case the gfn falls in a hole
one of the memslots bordering the hole is returned.

Add this lookup mode as an option to search_memslots() so we don't have two
almost identical functions for looking up a memslot by its gfn.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
[sean: tweaked helper names to keep gfn_to_memslot_approx() in s390]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c | 45 +++++++---------------------------------
 include/linux/kvm_host.h | 35 ++++++++++++++++++++++++-------
 virt/kvm/kvm_main.c      |  2 +-
 3 files changed, 36 insertions(+), 46 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c4d0ed5f3400..4e032e176216 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1941,41 +1941,6 @@ static long kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 /* for consistency */
 #define KVM_S390_CMMA_SIZE_MAX ((u32)KVM_S390_SKEYS_MAX)
 
-/*
- * Similar to gfn_to_memslot, but returns the index of a memslot also when the
- * address falls in a hole. In that case the index of one of the memslots
- * bordering the hole is returned.
- */
-static int gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn)
-{
-	int start = 0, end = slots->used_slots;
-	int slot = atomic_read(&slots->last_used_slot);
-	struct kvm_memory_slot *memslots = slots->memslots;
-
-	if (gfn >= memslots[slot].base_gfn &&
-	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
-		return slot;
-
-	while (start < end) {
-		slot = start + (end - start) / 2;
-
-		if (gfn >= memslots[slot].base_gfn)
-			end = slot;
-		else
-			start = slot + 1;
-	}
-
-	if (start >= slots->used_slots)
-		return slots->used_slots - 1;
-
-	if (gfn >= memslots[start].base_gfn &&
-	    gfn < memslots[start].base_gfn + memslots[start].npages) {
-		atomic_set(&slots->last_used_slot, start);
-	}
-
-	return start;
-}
-
 static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 			      u8 *res, unsigned long bufsize)
 {
@@ -1999,11 +1964,17 @@ static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 	return 0;
 }
 
+static struct kvm_memory_slot *gfn_to_memslot_approx(struct kvm_memslots *slots,
+						     gfn_t gfn)
+{
+	return ____gfn_to_memslot(slots, gfn, true);
+}
+
 static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
 					      unsigned long cur_gfn)
 {
-	int slotidx = gfn_to_memslot_approx(slots, cur_gfn);
-	struct kvm_memory_slot *ms = slots->memslots + slotidx;
+	struct kvm_memory_slot *ms = gfn_to_memslot_approx(slots, cur_gfn);
+	int slotidx = ms - slots->memslots;
 	unsigned long ofs = cur_gfn - ms->base_gfn;
 
 	if (ms->base_gfn + ms->npages <= cur_gfn) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2ef946e94a73..9d46937a3a4e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1230,10 +1230,14 @@ try_get_memslot(struct kvm_memslots *slots, int slot_index, gfn_t gfn)
  * Returns a pointer to the memslot that contains gfn and records the index of
  * the slot in index. Otherwise returns NULL.
  *
+ * With "approx" set returns the memslot also when the address falls
+ * in a hole. In that case one of the memslots bordering the hole is
+ * returned.
+ *
  * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
  */
 static inline struct kvm_memory_slot *
-search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
+search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index, bool approx)
 {
 	int start = 0, end = slots->used_slots;
 	struct kvm_memory_slot *memslots = slots->memslots;
@@ -1251,22 +1255,26 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
 			start = slot + 1;
 	}
 
+	if (approx && start >= slots->used_slots) {
+		*index = slots->used_slots - 1;
+		return &memslots[slots->used_slots - 1];
+	}
+
 	slot = try_get_memslot(slots, start, gfn);
 	if (slot) {
 		*index = start;
 		return slot;
 	}
+	if (approx) {
+		*index = start;
+		return &memslots[start];
+	}
 
 	return NULL;
 }
 
-/*
- * __gfn_to_memslot() and its descendants are here because it is called from
- * non-modular code in arch/powerpc/kvm/book3s_64_vio{,_hv}.c. gfn_to_memslot()
- * itself isn't here as an inline because that would bloat other code too much.
- */
 static inline struct kvm_memory_slot *
-__gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
+____gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 {
 	struct kvm_memory_slot *slot;
 	int slot_index = atomic_read(&slots->last_used_slot);
@@ -1275,7 +1283,7 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 	if (slot)
 		return slot;
 
-	slot = search_memslots(slots, gfn, &slot_index);
+	slot = search_memslots(slots, gfn, &slot_index, approx);
 	if (slot) {
 		atomic_set(&slots->last_used_slot, slot_index);
 		return slot;
@@ -1284,6 +1292,17 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 	return NULL;
 }
 
+/*
+ * __gfn_to_memslot() and its descendants are here to allow arch code to inline
+ * the lookups in hot paths.  gfn_to_memslot() itself isn't here as an inline
+ * because that would bloat other code too much.
+ */
+static inline struct kvm_memory_slot *
+__gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
+{
+	return ____gfn_to_memslot(slots, gfn, false);
+}
+
 static inline unsigned long
 __gfn_to_hva_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bbaa01afac43..a2d51ce957e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2126,7 +2126,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 	 * search_memslots() instead of __gfn_to_memslot() to avoid
 	 * thrashing the VM-wide last_used_index in kvm_memslots.
 	 */
-	slot = search_memslots(slots, gfn, &slot_index);
+	slot = search_memslots(slots, gfn, &slot_index, false);
 	if (slot) {
 		vcpu->last_used_slot = slot_index;
 		return slot;
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
