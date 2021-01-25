Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4709C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 14:54:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82A142151B
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 14:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82A142151B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 006204B5DD;
	Mon, 25 Jan 2021 09:54:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wzqHPYdtT7mq; Mon, 25 Jan 2021 09:54:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEB8C4B5E8;
	Mon, 25 Jan 2021 09:54:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA89B4B5E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 09:54:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oAsdg6eqIOXy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 09:54:39 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 434544B5DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 09:54:39 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id d26so7383235qtr.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 06:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=xdgEE80RPz34v1LBcX4APi8IV17OUln4QZHT4U/Mk7U=;
 b=auVNMo+5Z/Oydj6tt259lFcFwueyYWNZr0RZWZyifFChaGax5zUXwWwonBwcih5VuQ
 2Qg+whQ7oNUWIgBndkNaFYh4TXdfvHwD8dMfhYXlIjPvlUs44fCrAq3pzEI0uk+7wlez
 C+xM5TEbY3HZ4/rj9xDRwWiGSLtWggw/Tkqxt0foGC2J77+z1JxLsWGZ0cDM1BdiyfY7
 mN5T5cEsiG4DF5hAqxncdGiGtR0fwgAjZzn2zMoHu7NJCehSjuKoDtOJWJAhok3+8EM1
 Q5xWNhaOIiZtG2oovs6BeCG8WIhyTgFDQTsiU0bC9PXlPGF0ChqxzQ4KjGkTOKB+DI2u
 kz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xdgEE80RPz34v1LBcX4APi8IV17OUln4QZHT4U/Mk7U=;
 b=PBwFu6EjG4YKFTVgFnVzdN6+bRwcVlZ9FtUw5fHlLORaF46FEYeU2kHnDoLeVk6bla
 IHCF4vnZnilUASqDUGZHsIFBTfwrXpJH55LktJzl+MhalMCuGyHOqRpQj4Cm+HVNqyiB
 2qBI8SonvvCl8gs9iRZt1rnABzMg/DLV622SRAJP3vaVuahKHqx5yFMRKO84HQ8ITMei
 iGWygyGF6U0qmImDCjtoPl3fPYlCiapI+++j+ZcBSTD59X7VgEFyhl3Kp4gCfF+OgImQ
 +YlOK6LLI4l4TaQPQmXF5l9bOXc4PgSPsxi3Uz4iey7rq50DG4LRQC8JSmqsYK5T9KN7
 /KmQ==
X-Gm-Message-State: AOAM531HEk6z2fz9iljCFYqaVJfjl0IdY4N+Q6CGWAkIFUhia5iOBqxK
 9VByJy98QL17QJX4TshCel3QWsj1nWlqwb27ZSXUnFZfXGvwpsreT1HC9t7EkWpmEMgXLx4na6i
 nlbPvMqITjKVjw/YOhUulo6ppJDeeF1w553pqDmBiYj3pq0kaVqhiO7UjmG6ipOUrC7vvBg==
X-Google-Smtp-Source: ABdhPJyZcA0+GAnYaQMKQmzK29CIWPT7FQiRK7tZ8aDpb5Fk5uTD4Zf7eQAZ/UWfxmvLmOW8GVOTRg8ivyc=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a0c:f64c:: with SMTP id
 s12mr1113995qvm.2.1611586478790; 
 Mon, 25 Jan 2021 06:54:38 -0800 (PST)
Date: Mon, 25 Jan 2021 14:54:14 +0000
In-Reply-To: <20210125145415.122439-1-ascull@google.com>
Message-Id: <20210125145415.122439-2-ascull@google.com>
Mime-Version: 1.0
References: <20210125145415.122439-1-ascull@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH 1/2] KVM: arm64: Simplify __kvm_hyp_init HVC detection
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Cc: maz@kernel.org
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

The arguments for __do_hyp_init are now passed with a pointer to a
struct which means there are scratch registers available for use. Thanks
to this, we no longer need to use clever, but hard to read, tricks that
avoid the need for scratch registers when checking for the
__kvm_hyp_init HVC.

Tested-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 31b060a44045..b3915ccb23b0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -55,17 +55,10 @@ __do_hyp_init:
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.lo	__kvm_handle_stub_hvc
 
-	// We only actively check bits [24:31], and everything
-	// else has to be zero, which we check at build time.
-#if (KVM_HOST_SMCCC_FUNC(__kvm_hyp_init) & 0xFFFFFFFF00FFFFFF)
-#error Unexpected __KVM_HOST_SMCCC_FUNC___kvm_hyp_init value
-#endif
-
-	ror	x0, x0, #24
-	eor	x0, x0, #((KVM_HOST_SMCCC_FUNC(__kvm_hyp_init) >> 24) & 0xF)
-	ror	x0, x0, #4
-	eor	x0, x0, #((KVM_HOST_SMCCC_FUNC(__kvm_hyp_init) >> 28) & 0xF)
-	cbz	x0, 1f
+	mov	x3, #KVM_HOST_SMCCC_FUNC(__kvm_hyp_init)
+	cmp	x0, x3
+	b.eq	1f
+
 	mov	x0, #SMCCC_RET_NOT_SUPPORTED
 	eret
 
-- 
2.30.0.280.ga3ce27912f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
