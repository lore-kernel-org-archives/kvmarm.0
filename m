Return-Path: <SRS0=1o63=IY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF1CC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A42B961A21
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 13:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A42B961A21
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55D934B46C;
	Fri, 26 Mar 2021 09:54:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V3ZqcPZj9xnS; Fri, 26 Mar 2021 09:54:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2459B4B4E7;
	Fri, 26 Mar 2021 09:54:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1E714B1F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bKPB2CdbeyBx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 22:20:50 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C5924B1F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 22:20:50 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id v186so316518ybe.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 19:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=0E8BZ2STvuQIfso3dI+9aBVCstinNIkBYfQ3J4yTTGQ=;
 b=Sztl/h9sZx/7ZaVx5hMPtB6lSzMSX4Gb28dHAMSquYqz7s8WUCP4uEoziz/kmtJK81
 nfHzKFWV1WxfgApX8gx58e7JjhfWPaIW2HaXmQD7uuslC9BLVCHh4zkCoObl+QZ1dwPn
 M+RVORS2wr6AeKLyKhtXnmkQmsacfxPFnoUqFW8APJAZRs8ZHxHOdTP5b/rKvbWd8T08
 yeKRG0ZDrzCkkFO0+/kQKjyEP3OG8uUow+HKiNA9869LBY07Rkk4cdhbCro3XK38sXPM
 CCkn5lXwZLRr5xUwqO5ob7s5/KEANR2XTByUOGreIF+7GYhUmFMMjzPbXWIu1eQORSa3
 d2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=0E8BZ2STvuQIfso3dI+9aBVCstinNIkBYfQ3J4yTTGQ=;
 b=pRsdi8C08X7uGelXIMdytFY57QetuSH2ZxYy9v5dDrAeP0F7CVnbKpaD73Cqjm7U3y
 sIQLeaNLoytz7P1HSyxI6R4TGA96y1NsWL3pXLWXPCgJB8FDkqYoRCdhVlt1dr2lkd5E
 h5nOQMTORkfoBhUEMYdLpah9uk6mBdbYU1wCyJMBaVRR2hf6qVozn2WmtzJxgGfZYLeB
 5r7XehToOHiJD5iIImPmjhMPEhgnI0gsTmHfuVP2sbMPaDKenThB/TvqTlV7eCHeMCua
 lst8r4nNePHnl3Bq13dLJPEb3XrWLFhKztBsR/Yu4s+aQk05vwu9vSaMPo1YRGYo5PtZ
 FTZA==
X-Gm-Message-State: AOAM530q1dn0cg3Nqf42Wn1QU/eiagpy+uomjblp+DVdSrMdhte5GcRm
 iw4GfzsE+0oG+bW9ygc/d4LZZY7Owc8=
X-Google-Smtp-Source: ABdhPJzjEvSTUhG+uwIMtVfAPxRaQx8jIsDxAh63UurjJl6mHiAwbP0z55eNCAdH4rIDehEW/UWXRCNq+K0=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:be8d:: with SMTP id
 i13mr16186788ybk.320.1616725249585; 
 Thu, 25 Mar 2021 19:20:49 -0700 (PDT)
Date: Thu, 25 Mar 2021 19:19:56 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-18-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 17/18] KVM: x86/mmu: Allow yielding during MMU notifier
 unmap/zap, if possible
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

Let the TDP MMU yield when unmapping a range in response to a MMU
notification, if yielding is allowed by said notification.  There is no
reason to disallow yielding in this case, and in theory the range being
invalidated could be quite large.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f6a82230baa5..21bb8b68a553 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -885,7 +885,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
 		flush |= zap_gfn_range(kvm, root, range->start, range->end,
-				       false, flush);
+				       range->may_block, flush);
 
 	return flush;
 }
@@ -903,6 +903,10 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 
 	rcu_read_lock();
 
+	/*
+	 * Don't support rescheduling, none of the MMU notifiers that funnel
+	 * into this helper allow blocking; it'd be dead, wasteful code.
+	 */
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
 		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
 			ret |= handler(kvm, &iter, range);
-- 
2.31.0.291.g576ba9dcdaf-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
