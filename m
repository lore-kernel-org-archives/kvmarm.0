Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF74CC4332F
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6335B611ED
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6335B611ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08AAB4B1A3;
	Wed,  3 Nov 2021 20:26:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qshJSZrZ7o2D; Wed,  3 Nov 2021 20:26:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 930354B159;
	Wed,  3 Nov 2021 20:26:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A6FD4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id upGMeDZFC6Jy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:27 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF3644B13E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:26 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 k9-20020a170902ba8900b00141f601d5c8so1957238pls.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=Rh/p9dCBzSE6gfhoLM6qA42nAbGkMHfvz+ihOHus8Bw=;
 b=a0LysDSixF+SvGFoYJAn+9lReuNdeuojzCYwE/5S80HnosejUJ/GB5lSTi0I0B6etw
 PCesr77PK5UoG4qbBnDDmbOplfKjJvN0RSVwwsJ9A6TMfI9nydou7MxD9T7lOeaglEHG
 XNiJ9e6EtswDVfj8NbPNGs3K4UVClUfWt61l+WfszqPbkc9k/eRztWPGJiIa05+786xW
 gJ3qi2D5CO9qdvRG06/gp2Sn2Z2tyJIgyiWYmMzoSHEsDwT7XcmXrmm49tOMjj1utuxC
 5Wr/o1J29XTmPql9v7HTGvlM7g8HATHgYxp+e4CAJr75tfOZ82uzZSP74HenxJ6CsJu8
 wJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=Rh/p9dCBzSE6gfhoLM6qA42nAbGkMHfvz+ihOHus8Bw=;
 b=tXecGc79qjdWrBSGOHm1pJy0EcRD4A2uPzRXrcNOe4q/AfB8rZWYI526skWwM1v+FG
 jgN8cyG7w03kpiRTIXmJVxxmFLiFBZ+ngzv3Q3f5xTSRNbRPaUsjA49sXyQHX3GVauqe
 wAClfP9Xy2VAywMTl83mf+s6tBcG5lebMkej64QV3nV+vXyZJfDIyZb2NL+bbJJSWMFb
 9Qbq53V122naU5q9jztow3u2haVFXSy4zLuzI0qIYPXAePvH44awhC+AiC4jy2OX+BbF
 KOQaKcIHT3gavC5udB4DMB9O2FBsbnvoatw84kANMQNcX3EPJkkpHawI6lShtoi1LEEH
 wE6w==
X-Gm-Message-State: AOAM532myTj1VO+TB08HIx6uXbOGZIBfrGMbF96n8GqSl22Kqfqm/wv9
 icjpV90+YPFxFx9bUTc7ubzRLFvPS28=
X-Google-Smtp-Source: ABdhPJyOWq98exFdSMvxgt0VGjIuS13MnOJ47QLgbIC6Hkpi6D0S+Boi55mGWksr+QgQdfajOLURjR0xq4c=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e8d1:b0:141:de15:f596
 with SMTP id
 v17-20020a170902e8d100b00141de15f596mr25033911plg.67.1635985585858; Wed, 03
 Nov 2021 17:26:25 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:17 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-17-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 16/30] KVM: x86: Don't assume old/new memslots are
 non-NULL at memslot commit
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

Play nice with a NULL @old or @new when handling memslot updates so that
common KVM can pass NULL for one or the other in CREATE and DELETE cases
instead of having to synthesize a dummy memslot.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 80e726f73dd7..80183f7eadeb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11762,13 +11762,15 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     const struct kvm_memory_slot *new,
 				     enum kvm_mr_change change)
 {
-	bool log_dirty_pages = new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 old_flags = old ? old->flags : 0;
+	u32 new_flags = new ? new->flags : 0;
+	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
 
 	/*
 	 * Update CPU dirty logging if dirty logging is being toggled.  This
 	 * applies to all operations.
 	 */
-	if ((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)
+	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)
 		kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
 
 	/*
@@ -11786,7 +11788,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * MOVE/DELETE: The old mappings will already have been cleaned up by
 	 *		kvm_arch_flush_shadow_memslot().
 	 */
-	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
+	if ((change != KVM_MR_FLAGS_ONLY) || (new_flags & KVM_MEM_READONLY))
 		return;
 
 	/*
@@ -11794,7 +11796,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
 	 * logging isn't being toggled on or off.
 	 */
-	if (WARN_ON_ONCE(!((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)))
+	if (WARN_ON_ONCE(!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)))
 		return;
 
 	if (!log_dirty_pages) {
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
