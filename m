Return-Path: <SRS0=phmX=MT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D42CC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 10:33:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF49160F46
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 10:33:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EF49160F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6977D4A531;
	Tue, 27 Jul 2021 06:33:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9m69xGBblnGH; Tue, 27 Jul 2021 06:32:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58DB74A193;
	Tue, 27 Jul 2021 06:32:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1BEA49F6C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 06:32:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vP1kFUPNzIQ7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Jul 2021 06:32:56 -0400 (EDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com
 [209.85.208.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE00F49E8C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 06:32:56 -0400 (EDT)
Received: by mail-ed1-f51.google.com with SMTP id z26so14727639edr.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 03:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=jnFmiiCARwRXURV87SUoI4OAHXmTW3lr0hJaEC8D8Qo=;
 b=t5/8OCiV65LjtymFAaIrJfaSLZnhAwBIp4orIX/0Z1v2iy1a6amOxkKFI69uy0S14q
 VzeM8IvLh4y36jG3aVxfAZs0TMweAVVWwlFoLTPJPmIkwmD3FBxA03ABTrmZUU1gM1fR
 fZ1Viz0+VHQT6fnAzY6kr2TTNtJ3FoWLklbrOd3X5kSn49K/+E3EgRLkwos/ewcrJhA+
 KQkiS+2K+2ALVEnQe+9ARSCiIAbjCKtg41e6Wjz1AKmDvAy/ZhssNgyfC2HSpxX5OdeY
 gNoOyPnc8tm9+4qU59BAE2P8vp0JjeVpjLEMIYbhJZ6XYS5Cn8jghBtzA5TArnoUCGRQ
 DlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
 :mime-version:content-transfer-encoding;
 bh=jnFmiiCARwRXURV87SUoI4OAHXmTW3lr0hJaEC8D8Qo=;
 b=m1KfnC0ySooHg7vAAu6fMtb7JPAyKgn/9XcCr9L7ItYXuYVeMUngwUOF7Ym8qEnW5w
 za2H6cySH61cS/Xv/+JPxgVF3si8jZsvT3DZypyEsgM5m8q0twVkptU7Jn4NQ8ehn7o3
 ONi9s5RPp2do7T6bNzOcmsQkInRFIXpikxrbaaW/3+3ZblkOw/SqJWv1D1WdyiMeBCBi
 Cd/t5CNHzjcnmQFbPmgn2TrfMTmFxQ4aJo4H0AD6P6gs64DoYZF4cfIZPo9RaYKQ7GfB
 F/spx4A9mSlRUmr4w/UuUp3gf6J9iWf/CCxjNyg/qEuzWsKXo/98IoChsh6qBoIUGkTK
 RiOg==
X-Gm-Message-State: AOAM530URyX0JgxKgHNgHKkb+XlobKyRs+GnoyTl/8k76s56H++hRUZV
 u8jBOaCDX9DtN3RbhnSJSho=
X-Google-Smtp-Source: ABdhPJwVzbWCsmg6tp3vU13MkpOZeZpi6hJPrU/wtF3E5a4blQzAdpGohkBz9ys4/iB3AFYxRb59+A==
X-Received: by 2002:a05:6402:3489:: with SMTP id
 v9mr27339068edc.124.1627381975605; 
 Tue, 27 Jul 2021 03:32:55 -0700 (PDT)
Received: from avogadro.. (93-33-132-114.ip44.fastwebnet.it. [93.33.132.114])
 by smtp.gmail.com with ESMTPSA id
 la23sm742030ejc.63.2021.07.27.03.32.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Jul 2021 03:32:54 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: ARM: count remote TLB flushes
Date: Tue, 27 Jul 2021 12:32:51 +0200
Message-Id: <20210727103251.16561-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

KVM/ARM has an architecture-specific implementation of
kvm_flush_remote_tlbs; however, unlike the generic one,
it does not count the flushes in kvm->stat.remote_tlb_flush,
so that it inexorably remained stuck to zero.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c10207fed2f3..6cf16b43bfcc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -81,6 +81,7 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
+	++kvm->stat.generic.remote_tlb_flush;
 }
 
 static bool kvm_is_device_pfn(unsigned long pfn)
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
