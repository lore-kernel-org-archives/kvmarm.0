Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40DBC433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C7E721D80
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="i7eptY7r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C7E721D80
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 321F14B283;
	Tue, 15 Sep 2020 06:47:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WaEf9US0H+cY; Tue, 15 Sep 2020 06:47:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD8A4B24F;
	Tue, 15 Sep 2020 06:47:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5CA64B1FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c6COuXfPGkBW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:47:23 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 670BF4B36A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:21 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id w7so1084789wrp.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=WKgOSDUYFOb+eJkVxGRKW9bVuNnxPXprClF7pwLCXS8=;
 b=i7eptY7rhVtgm9AV0JoR4VmOxw1r+oeBdnk5HqzhjpiQcviDhcs0nVqDUXP+zvQfnT
 ClG0GH7mVRjpNVHqotD59O2EAC1c3OsslIop9/dqW5hLOJSy2ovXlxy1w6RTzq+kAZHq
 FNlthgFEjh6EpzpfxNy+J+9ev7/5ku4danbVQp9gyH7oo8Gbs2fxwv1JBzarUPBG9qhc
 AJRMdXne7Ef98lbviuYeGo3F09/BntmCU3SqxeR1Rvs/9kjLrnlSRqi6iY3ayfUVJ4NG
 v36RU9JwEjjni3o5LjoyA1WzpftWNSG/2I6LHrbUCCDKliTIDiA2836cz88svlMIh5PC
 mzHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=WKgOSDUYFOb+eJkVxGRKW9bVuNnxPXprClF7pwLCXS8=;
 b=SlqxsnRk6Xw+DfF8Fx5m7Pb3RsE5JI+7Hszb4Y+UMBRG1x4eEV105MS+2y+lckf+Lq
 q798TbYJ4p7W9DDsP7cBDgjn9prIfOj2hhLM/VMsgplC1xYI4B9h1cQfW45dJWAI8s0A
 4gj1vwZD4TZ/gALFb12+SELRXD8XSv9eUUOWUJPdxkPG/w3xF0Efe7RiE9PLiXupCwgp
 cfeObfqPblPK6HUPl/1G6lfc18MhmvAJ73cM9VZVlKBW7II0UMZNOEGCb60iOAvjTPvC
 W4KefgTsZIfTf94NBI4wYhFRopiqgQvAj6BAUSyqOO2MkWawTD/dPYAUTTJSIw3Y+oLp
 O7Cw==
X-Gm-Message-State: AOAM530DRKQRzxsbbWcpFqjz3GSDEdPP9NS/dWwdqrjg/WBlnLX+1Dho
 /Xa0F9n9Lq5QK2/tLZQzxdjBnMGQIAcYplUPcV+3k7bRsk3LiB0jJPEkAbKpw2Tz2Y1NNhnJV2L
 OK4cQReAk9G668DQevlwNkRD8gXd3A4b2dkk+Atazptt3Y+Xw1SGyduSwXNhZuxLiDD0/wA==
X-Google-Smtp-Source: ABdhPJyMC7oTGqBQzTGN39DyKULVolR1w+A+piT6pirZQBCz8TCQ6ZtKjxnjV1vO9/cmKvNmPAsWUKqFuEY=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a7b:c14f:: with SMTP id
 z15mr472005wmi.1.1600166839909; 
 Tue, 15 Sep 2020 03:47:19 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:38 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-15-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 14/19] KVM: arm64: nVHE: Pass pointers consistently to
 hyp-init
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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
index ae4b34f91e94..6b7180072c8d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1278,6 +1278,7 @@ static void cpu_init_hyp_mode(void)
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
+	hyp_stack_ptr = kern_hyp_va(hyp_stack_ptr);
 	vector_ptr = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index d9434e90c06d..abe885e26fe2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -114,7 +114,6 @@ alternative_else_nop_endif
 	isb
 
 	/* Set the stack and new vectors */
-	kern_hyp_va	x1
 	mov	sp, x1
 	msr	vbar_el2, x2
 
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
