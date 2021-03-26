Return-Path: <SRS0=1o63=IY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BEFC433E1
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 804A261A1D
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 804A261A1D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31A8F4B45B;
	Fri, 26 Mar 2021 09:54:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IhT5dBNHfbOP; Fri, 26 Mar 2021 09:54:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC3564B4A9;
	Fri, 26 Mar 2021 09:54:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CB3C4B466
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pqZl7qOoZtkG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 22:20:20 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 723EB4B477
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:20 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id dz17so4793097qvb.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 19:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=VHU0N9D6gGMpxInyb7jHcZ3k9rh6QrJlzBumSAqwO8c=;
 b=KYqLsSM1DKlBrG0n9fQu+QMpt6MzQ+SF1jMhC3bYjxbl9xg4rj1BheBGS3DzK7UmeZ
 lEiUMH+TeBdSLBPrIvxR3WM8v0OjxY1qKJaVm29X0psiCjFVMfGvfr9a6gzWD5VEwqyZ
 PTrYiDzsZw/v2/D39aFUEmHMnVwwN61npU9LP0PYtwpLM4aTVEN8sgSgy2zcL1SLjU+s
 cNlLWLnvWQOuO9HWx+Er8e6OJdhijecdyBbriyZu1Is1pGK2S2+5wuqQOFlxCFoM/xsU
 eQR71XOtqIazbUL52wALyTWqjz+bTXi58NvjtGUL28QVGyfYAPq06SdoWnsvNDwuuaFo
 szxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=VHU0N9D6gGMpxInyb7jHcZ3k9rh6QrJlzBumSAqwO8c=;
 b=F0I+lJK78hPTaco589MDD7Bg+O5nHZLtVyHdiPPrzkjjh6MdJXalG532Gf1n6Rr5A7
 GiR4Y7CDNQnhvhxay9mnhkwlvhh0Wo1NlD9ARMNqOVxx61lvYj4VgWhMTQw9mTPgKz72
 Of8C2tzrmZ8qnIiW5BYm8BAi5IxMFbG5VnQ/mnRL1IxC5i8uBLgBR06pJJyShP4oK868
 YawKFrsFnDw4Ov+E6Ru+FO11ooaXOoUDVBXt+X1gGV5vBKabTXkQy8AR0E2m0fg86V/3
 SslWVJbLoGctiSsSaYkC5HFly6+l+DztfsKYLjGcdhBjem+GMgwq517l/Ubk6pJinEnS
 +FuA==
X-Gm-Message-State: AOAM530Cx2O1FI0Mwf1rMHwnFqyRnNbOUUluHisNfV1+SHxotfUnCxBl
 ODlP4Vr7jQ1ksce/BROS3g4SHDgBmVk=
X-Google-Smtp-Source: ABdhPJy0HL2v9roIhKh4ewViQpaZol5eRjI0NnfVDZGOKQXEnK2GcjlR+0ZiLbksT/yFSNKZXmeXIxYd4GQ=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a05:6214:176e:: with SMTP id
 et14mr11147707qvb.35.1616725219917; Thu, 25 Mar 2021 19:20:19 -0700 (PDT)
Date: Thu, 25 Mar 2021 19:19:43 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 04/18] KVM: x86/mmu: Coalesce TLB flushes across address
 spaces for gfn range zap
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 26 Mar 2021 09:54:23 -0400
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

Gather pending TLB flushes across both address spaces when zapping a
given gfn range.  This requires feeding "flush" back into subsequent
calls, but on the plus side sets the stage for further batching
between the legacy MMU and TDP MMU.  It also allows refactoring the
address space iteration to cover the legacy and TDP MMUs without
introducing truly ugly code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 37e2432c78ca..e6e02360ef67 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5227,10 +5227,10 @@ typedef bool (*slot_level_handler) (struct kvm *kvm, struct kvm_rmap_head *rmap_
 static __always_inline bool
 slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			slot_level_handler fn, int start_level, int end_level,
-			gfn_t start_gfn, gfn_t end_gfn, bool flush_on_yield)
+			gfn_t start_gfn, gfn_t end_gfn, bool flush_on_yield,
+			bool flush)
 {
 	struct slot_rmap_walk_iterator iterator;
-	bool flush = false;
 
 	for_each_slot_rmap_range(memslot, start_level, end_level, start_gfn,
 			end_gfn, &iterator) {
@@ -5259,7 +5259,7 @@ slot_handle_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	return slot_handle_level_range(kvm, memslot, fn, start_level,
 			end_level, memslot->base_gfn,
 			memslot->base_gfn + memslot->npages - 1,
-			flush_on_yield);
+			flush_on_yield, false);
 }
 
 static __always_inline bool
@@ -5490,7 +5490,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	int i;
-	bool flush;
+	bool flush = false;
 
 	write_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
@@ -5506,14 +5506,13 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
 							PG_LEVEL_4K,
 							KVM_MAX_HUGEPAGE_LEVEL,
-							start, end - 1, true);
-
-			if (flush)
-				kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-								   gfn_end);
+							start, end - 1, true, flush);
 		}
 	}
 
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
+
 	if (is_tdp_mmu_enabled(kvm)) {
 		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
 		if (flush)
-- 
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
