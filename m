Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC76DC43611
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3E6AA61153
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E6AA61153
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB5BD4B216;
	Fri,  2 Apr 2021 05:20:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KNIu4dmZzWTx; Fri,  2 Apr 2021 05:20:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 268CA4B2F9;
	Fri,  2 Apr 2021 05:20:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ABF84B707
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qcc77J4CB6fd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 20:57:19 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35E314B6D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:19 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id 125so4618597ybd.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Apr 2021 17:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=0/ecd8NmYTmeaiIYnkr6nuUXDKg3hRMT4+OQ0nyX4DE=;
 b=oYFGYSyo5B35UKJnfDl/ptvTjCVW8KNCbB5+juLbSKFFyhdI1o15HSF2gl9NbqxKmR
 WTeg8loXzFmw7sYPBcDz9SnE1ep/TQ8R11Jo0v6/+BXHFnVXD5GetugNTwD0b5Bqt1L/
 mx+Wv2fDdgWFKAi4FQThRwTMjWA7vs3uA/I3KI9C+xT2UVJEymjeiJxY9WdDCMtNY1Gh
 GqU4Bg7UboHpTTQPVmttgw2eCvKNRYVbBfciANMUqXXzeQ8x+WKQOPRt9i/fgo0c9Wxl
 r3IbL0WnEuE8LcmbAeXvX6nCRCfN/9RtrNuT+vA3q5p7oxMFeV4Y6S1fLZYoQC3OglWL
 5a1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=0/ecd8NmYTmeaiIYnkr6nuUXDKg3hRMT4+OQ0nyX4DE=;
 b=HeUP2X8Y+phefmDaCZOUecBxAf4aUfOQ+G0Wi/Nhabv7BQr3+nHpoe9Myv9Z3QDb90
 P3z+tOi2rvEaJsGLF0cWX2sKBdCQgzNyPUeTu+n0FmRnkBiLV/eYTl0qmZcbceVQuVWO
 G5NXPTFVOkTckLdthiYKKmNAkaQWPA7yb/E2HBFPg2Kw36MCiP8pPSLQ9dfvpOE74Aa4
 MtECvZ6Kn9pEE7w9KO8l9qmR76ZWlNNa5iL4VotEveIxe/lWb0tolxLNTtWYouGBlfL1
 oUqktyO66jBjDIA1sBdRAe+p8SOlYNsgUxosJ3bAmqAXi2DUXxcv/z1ni1+B/3jGrEvZ
 Dszg==
X-Gm-Message-State: AOAM532sSVpNYlmLO8tae7T+whpcy/iigtsZgQ3F1+a/H8UUhyNgwoaJ
 bLglDRbX0fDlOD4ZiiSdHYGPc+2BVjk=
X-Google-Smtp-Source: ABdhPJzt4o9P3PY2HrRiNrmz7rdm15sQ6vGfWjEexZR+eCJ9LN9XguP8ZdUR1MsXg+JiybkoEf+aAjrbxig=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:74d2:: with SMTP id
 p201mr16375842ybc.406.1617325038741; 
 Thu, 01 Apr 2021 17:57:18 -0700 (PDT)
Date: Thu,  1 Apr 2021 17:56:56 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 08/10] KVM: Take mmu_lock when handling MMU notifier iff
 the hva hits a memslot
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 02 Apr 2021 05:20:36 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Defer acquiring mmu_lock in the MMU notifier paths until a "hit" has been
detected in the memslots, i.e. don't take the lock for notifications that
don't affect the guest.

For small VMs, spurious locking is a minor annoyance.  And for "volatile"
setups where the majority of notifications _are_ relevant, this barely
qualifies as an optimization.

But, for large VMs (hundreds of threads) with static setups, e.g. no
page migration, no swapping, etc..., the vast majority of MMU notifier
callbacks will be unrelated to the guest, e.g. will often be in response
to the userspace VMM adjusting its own virtual address space.  In such
large VMs, acquiring mmu_lock can be painful as it blocks vCPUs from
handling page faults.  In some scenarios it can even be "fatal" in the
sense that it causes unacceptable brownouts, e.g. when rebuilding huge
pages after live migration, a significant percentage of vCPUs will be
attempting to handle page faults.

x86's TDP MMU implementation is especially susceptible to spurious
locking due it taking mmu_lock for read when handling page faults.
Because rwlock is fair, a single writer will stall future readers, while
the writer is itself stalled waiting for in-progress readers to complete.
This is exacerbated by the MMU notifiers often firing multiple times in
quick succession, e.g. moving a page will (always?) invoke three separate
notifiers: .invalidate_range_start(), invalidate_range_end(), and
.change_pte().  Unnecessarily taking mmu_lock each time means even a
single spurious sequence can be problematic.

Note, this optimizes only the unpaired callbacks.  Optimizing the
.invalidate_range_{start,end}() pairs is more complex and will be done in
a future patch.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25ecb5235e17..f6697ad741ed 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -482,10 +482,10 @@ static void kvm_null_fn(void)
 static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 						  const struct kvm_hva_range *range)
 {
+	bool ret = false, locked = false;
 	struct kvm_gfn_range gfn_range;
 	struct kvm_memory_slot *slot;
 	struct kvm_memslots *slots;
-	bool ret = false;
 	int i, idx;
 
 	/* A null handler is allowed if and only if on_lock() is provided. */
@@ -493,11 +493,13 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			 IS_KVM_NULL_FN(range->handler)))
 		return 0;
 
-	KVM_MMU_LOCK(kvm);
-
 	idx = srcu_read_lock(&kvm->srcu);
 
+	/* The on_lock() path does not yet support lock elision. */
 	if (!IS_KVM_NULL_FN(range->on_lock)) {
+		locked = true;
+		KVM_MMU_LOCK(kvm);
+
 		range->on_lock(kvm, range->start, range->end);
 
 		if (IS_KVM_NULL_FN(range->handler))
@@ -532,6 +534,10 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
 
+			if (!locked) {
+				locked = true;
+				KVM_MMU_LOCK(kvm);
+			}
 			ret |= range->handler(kvm, &gfn_range);
 		}
 	}
@@ -540,7 +546,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs(kvm);
 
 out_unlock:
-	KVM_MMU_UNLOCK(kvm);
+	if (locked)
+		KVM_MMU_UNLOCK(kvm);
 
 	srcu_read_unlock(&kvm->srcu, idx);
 
-- 
2.31.0.208.g409f899ff0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
