Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2499CC433E8
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D40E12076C
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="LVDh6uMq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D40E12076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CD6E4B349;
	Wed, 15 Jul 2020 14:45:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tvOKQUbzWWLf; Wed, 15 Jul 2020 14:45:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F0E94B3A5;
	Wed, 15 Jul 2020 14:45:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC98D4B349
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:44:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hUbuLm5kypRB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:44:58 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0F7B4B3C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:44:57 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id c6so1954989wru.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SyxRkKLKWcXOuT2LUxaUcFPGnHrRaKpVY9uzbh96ffA=;
 b=LVDh6uMqpr+JiL0cdPI7HctGHH8Fe3x00MJpT0tfzIeMjmLdLQjPzHe2QJfFF1xiBr
 ZZ5S1k0HZ3tW1n+3EMW6EYMThGccPzxDILEl54luRI/2aYuYDNfOElrIEPFVBAcr2Nqm
 2ltBq2cY/ehPPxfVLk9/LVU/+APylK8cpSrfg4M2BXU4oN8R4KICwBkyd1GD8Jz7as11
 io/qF5zE0C6tMMJkfrmut5cum7NM9K1T45m8ahg9U41zfKtqZQZJOH0cmQ0BXSOx1M4D
 Zq8/yKqpRk3+4rirEVrurZrvky85NgI0ObFq5ecVoBlzkrA5WOJkjmc6Dn0r2gpP/v47
 dFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SyxRkKLKWcXOuT2LUxaUcFPGnHrRaKpVY9uzbh96ffA=;
 b=NyPGrtbBvIpX8N6+kRJwBZAq8JWKmKB5e866A+j2K9hXQArVUGddxLf9N/Syb8TFxc
 muzWp64sZnfW55GyYSGtzXo7CcTML2jiavbjK5I05xbvNNvM8Lp6wZgkaVOxJC6geT9E
 0l/kxlie11jOvxUDczXPqpMP6ejxhQKBJE3JxKXYMPh3CzMk7xIjuGiGhXA1XOF7zWg1
 5iju0Abvv45uYf552K7bB4ujAnSSQTTHW0Lo06vxOO9kt09vgmyOF422XnDXJUVft2Bs
 IFrh0xccfrIUrUUsE3o/LTsCfNwIWTIeziD9jBDIx5a6S5plfnf8H1Hx4sZPadphHe6z
 ON1w==
X-Gm-Message-State: AOAM532HxGoWYYcCl9d5dh8RB9VWmPdSCKJhCyIQYPTl5EzGH9P1r+hl
 EHBnAs1Nf0f5Rb6sRSpvBRhiQZhJCHOIqDHHkC4FCO6QALEVfQ02jD+XxK8pYbPdcDwQWwo8Q69
 s5NQXqWcE0W4QdMIG2gcHnO4rKsV/bBZk/+wPKIZgOSvaXmyF6BYxDUENM6WYZQwMriIBAw==
X-Google-Smtp-Source: ABdhPJy6Q4HVs7j7fPq8iP4gr2bwTHKT1UL5MS1P9x4s2b+UrCi49QDL9pl6QsxKWhpSUY7aX/41hmK+kps=
X-Received: by 2002:a1c:a557:: with SMTP id o84mr782435wme.42.1594838696814;
 Wed, 15 Jul 2020 11:44:56 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:05 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-5-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 04/37] KVM: arm64: nVHE: Pass pointers consistently to hyp-init
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

Rather than some being kernel pointer and others being hyp pointers,
standardize on all pointers being hyp pointers.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/arm.c               | 1 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94f4481e5637..bf662c0dd409 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1275,6 +1275,7 @@ static void cpu_init_hyp_mode(void)
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
+	hyp_stack_ptr = kern_hyp_va(hyp_stack_ptr);
 	vector_ptr = (unsigned long)kvm_get_hyp_vector();
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 1587d146726a..f80f169a8442 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -113,7 +113,6 @@ alternative_else_nop_endif
 	isb
 
 	/* Set the stack and new vectors */
-	kern_hyp_va	x1
 	mov	sp, x1
 	msr	vbar_el2, x2
 
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
