Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0B3C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 90892611CA
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 90892611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EA9D4B08F;
	Wed,  3 Nov 2021 20:26:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9t8HsfuKgU3C; Wed,  3 Nov 2021 20:26:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FF014B0B3;
	Wed,  3 Nov 2021 20:26:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 192C14A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vGVQzaUsqx-A for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:01 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53DA24B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:01 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 x25-20020aa79199000000b0044caf0d1ba8so2365625pfa.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=+lV0XpIZU6tw19BsegMK11Am0XrNm95tEDZ+cjWdUrM=;
 b=jbtShP55MKCx20McDFEhvtwsoRH1khB6gzD/3j56rgiZ3zt1jHh02awL7RkCEzV3OS
 juVR4kJgynHQLk53v8qOxVTOjp/cr1Axpeb38StAvaM6K/Esi65OU9b5Xxj4BlHERFw/
 20Ros746PIesTfL4lqUBcYH1DmBdILCibzAzE0JyxJqshteAL/za33QXIkiltJhs6fgG
 bVtI7QJVCXpF8HJS0rKZ95KbFtPX72tTwq3ga0tOCYx8FS5o3uLhWSoZiizq/DCYGBRC
 nP9YYyqmezSHN3kgANHiJKtWGLbMgy/F9P8mC6PT1O/nqJH2RcSpIBmpTyxPG6DF1Hbi
 bVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=+lV0XpIZU6tw19BsegMK11Am0XrNm95tEDZ+cjWdUrM=;
 b=fvyeLPyfoIF1U+k3ZMjiXRP5dvbDIJ+RUjXYKBdyRvjznzHltLDyZx4XkS6uDhpYmf
 zU43ITj68hYFZdSurFfzgV8bCxdGGs/v/c0xdvbnAChyoUXAD4H+nOMsD9aqwvt27DPm
 dmXiXbWAATanDbRahIFbPqkb0L90ZBqztOsp9Y7dF8XpQkBbNAIeHDMOOSyBWBGEuUoM
 RO1QsdIKFByQ4i225qIIZElOgq5eW+JbS0teiA0tbsfnlgRslkGeKJR/nyxgzNu0EPuC
 qAYGnfEbN2/zmQtSvnkvjWJMLHv1IG4Tkm8u8WKdMRd/ttHegzXVmzsCwf028xtZVpvn
 sqUw==
X-Gm-Message-State: AOAM531Qre0cdDyKlxjZZ1GYLMC21rMlmtgsgF9KCSs6lQDICcmo+e7q
 dJgUk23EXcJZG2dy2Wx7ESRFQk1bfDc=
X-Google-Smtp-Source: ABdhPJxPA9GZBaEM5Ul3kt/1JljrZJu3YLRnIzyzQ/7OAn8VgQo/7agz4e2n8dYIb/fDnOKKBTJDQWAH1V8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c3:: with SMTP id
 v3mr252263pjd.0.1635985559868; Wed, 03 Nov 2021 17:25:59 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:02 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 01/30] KVM: Ensure local memslot copies operate on
 up-to-date arch-specific data
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

When modifying memslots, snapshot the "old" memslot and copy it to the
"new" memslot's arch data after (re)acquiring slots_arch_lock.  x86 can
change a memslot's arch data while memslot updates are in-progress so
long as it holds slots_arch_lock, thus snapshotting a memslot without
holding the lock can result in the consumption of stale data.

Fixes: b10a038e84d1 ("KVM: mmu: Add slots_arch_lock for memslot arch fields")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 47 ++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..99e69375c4c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1531,11 +1531,10 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 
 static int kvm_set_memslot(struct kvm *kvm,
 			   const struct kvm_userspace_memory_region *mem,
-			   struct kvm_memory_slot *old,
 			   struct kvm_memory_slot *new, int as_id,
 			   enum kvm_mr_change change)
 {
-	struct kvm_memory_slot *slot;
+	struct kvm_memory_slot *slot, old;
 	struct kvm_memslots *slots;
 	int r;
 
@@ -1566,7 +1565,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 * Note, the INVALID flag needs to be in the appropriate entry
 		 * in the freshly allocated memslots, not in @old or @new.
 		 */
-		slot = id_to_memslot(slots, old->id);
+		slot = id_to_memslot(slots, new->id);
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
 		/*
@@ -1597,6 +1596,26 @@ static int kvm_set_memslot(struct kvm *kvm,
 		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
 	}
 
+	/*
+	 * Make a full copy of the old memslot, the pointer will become stale
+	 * when the memslots are re-sorted by update_memslots(), and the old
+	 * memslot needs to be referenced after calling update_memslots(), e.g.
+	 * to free its resources and for arch specific behavior.  This needs to
+	 * happen *after* (re)acquiring slots_arch_lock.
+	 */
+	slot = id_to_memslot(slots, new->id);
+	if (slot) {
+		old = *slot;
+	} else {
+		WARN_ON_ONCE(change != KVM_MR_CREATE);
+		memset(&old, 0, sizeof(old));
+		old.id = new->id;
+		old.as_id = as_id;
+	}
+
+	/* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
+	memcpy(&new->arch, &old.arch, sizeof(old.arch));
+
 	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
 	if (r)
 		goto out_slots;
@@ -1604,14 +1623,18 @@ static int kvm_set_memslot(struct kvm *kvm,
 	update_memslots(slots, new, change);
 	slots = install_new_memslots(kvm, as_id, slots);
 
-	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
+	kvm_arch_commit_memory_region(kvm, mem, &old, new, change);
+
+	/* Free the old memslot's metadata.  Note, this is the full copy!!! */
+	if (change == KVM_MR_DELETE)
+		kvm_free_memslot(kvm, &old);
 
 	kvfree(slots);
 	return 0;
 
 out_slots:
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-		slot = id_to_memslot(slots, old->id);
+		slot = id_to_memslot(slots, new->id);
 		slot->flags &= ~KVM_MEMSLOT_INVALID;
 		slots = install_new_memslots(kvm, as_id, slots);
 	} else {
@@ -1626,7 +1649,6 @@ static int kvm_delete_memslot(struct kvm *kvm,
 			      struct kvm_memory_slot *old, int as_id)
 {
 	struct kvm_memory_slot new;
-	int r;
 
 	if (!old->npages)
 		return -EINVAL;
@@ -1639,12 +1661,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	 */
 	new.as_id = as_id;
 
-	r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
-	if (r)
-		return r;
-
-	kvm_free_memslot(kvm, old);
-	return 0;
+	return kvm_set_memslot(kvm, mem, &new, as_id, KVM_MR_DELETE);
 }
 
 /*
@@ -1718,7 +1735,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!old.npages) {
 		change = KVM_MR_CREATE;
 		new.dirty_bitmap = NULL;
-		memset(&new.arch, 0, sizeof(new.arch));
 	} else { /* Modify an existing slot. */
 		if ((new.userspace_addr != old.userspace_addr) ||
 		    (new.npages != old.npages) ||
@@ -1732,9 +1748,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		else /* Nothing to change. */
 			return 0;
 
-		/* Copy dirty_bitmap and arch from the current memslot. */
+		/* Copy dirty_bitmap from the current memslot. */
 		new.dirty_bitmap = old.dirty_bitmap;
-		memcpy(&new.arch, &old.arch, sizeof(new.arch));
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
@@ -1760,7 +1775,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			bitmap_set(new.dirty_bitmap, 0, new.npages);
 	}
 
-	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
+	r = kvm_set_memslot(kvm, mem, &new, as_id, change);
 	if (r)
 		goto out_bitmap;
 
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
