Return-Path: <SRS0=YqI3=NO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09064C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 22:39:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F60261374
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 22:39:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6F60261374
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDFDB4B162;
	Mon, 23 Aug 2021 18:39:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6g9k2VEwN11G; Mon, 23 Aug 2021 18:39:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1B1C4B1B6;
	Mon, 23 Aug 2021 18:39:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F03CF4B165
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 18:39:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jgelfnV+vf6E for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 18:39:50 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E52EE4B162
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 18:39:49 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 q22-20020a63e956000000b002524787adb1so11012768pgj.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 15:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=ZlrjGTozy+/BVVtSpbg+B9Oe1UkUPbISjCvvFGrqXlg=;
 b=i32J3rbMQ0H5p2G8SzukcQI43bhJ5ntJGGf9D1umNfUcjm8W8qmAUff5q99knxxmhM
 cOrfyLMTACMwCnr6/JTNAYsZOB+Z6zMT+JI7rp4n4CFLa96AaRVdRaM1hSOxh/QEA7vV
 TaB7c92L+cqN71A0+ry5+uV+4wwINpFXM60CyBmcu002rbGSDfSD4ue8iDsutymBWUa4
 lKHK7r+J5l4ypKAL7ngZ8TxdJuow7jMseZYFdQ7R6px8OHRVbrA57nnxDuwLaNLpdGaM
 92/7NEYOVBRIXntdNFYGN+oo4DC1jHue7z544/aAFko6812mFMK7Ot5FwbU1PmbPrkLd
 oYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=ZlrjGTozy+/BVVtSpbg+B9Oe1UkUPbISjCvvFGrqXlg=;
 b=mMOtCIOjteKaPsDhD6/18EPdNXbKLf9ct4/SqFBj8MzPN1F664nFoeKGoWd2i/EiqJ
 oXqQh8YlBsBuQ8aHejLwS3gMvA17m8iJnFHpy1GCOZDvwPYyHa9DJ8WzobyH/CQqkYS4
 WFScCz3gX15SPE3UmqQBU23Fvn1kndlli7gpJ15UUm640OLUIYwylNiCPiGKQywLxngu
 x78MI0Ak/dpHu0A34x9wq+zoZOreeJ0Gw3Q034JtyQVfEAXYG083lLt9FqqJDg6rXQBs
 WHLfZ7F3ned/G4T9KqWC20Jy1JiYhdhOvC4/lPlgHqbcKmg6ocQRFyMIM8BVHGce8y4E
 zpXw==
X-Gm-Message-State: AOAM531lX+5/HgwHDV6CACmcR1BFjgyPZSqAEIsirv0sF5GB6gEaLqRt
 9hv2Xq7C5G1fm+ts2m/wxl7Jt5yX7B3C
X-Google-Smtp-Source: ABdhPJxASietCIf57TllHwMPHW6IS8WL5h/EM1B0OToCNPzrClc7aA47+ufW1g4K95UEciNGRGi3rYMtLrzn
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:f10:: with SMTP id
 16mr867207pjy.80.1629758388829; Mon, 23 Aug 2021 15:39:48 -0700 (PDT)
Date: Mon, 23 Aug 2021 22:39:40 +0000
Message-Id: <20210823223940.1878930-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH] KVM: arm64: Trim guest debug exception handling
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The switch-case for handling guest debug exception covers
all the debug exception classes, but functionally, doesn't
do anything with them other than ESR_ELx_EC_WATCHPT_LOW.
Moreover, even though handled well, the 'default' case
could be confusing from a security point of view, stating
that the guests' actions can potentially flood the syslog.
But in reality, the code is unreachable.

Hence, trim down the function to only handle the case with
ESR_ELx_EC_WATCHPT_LOW with a simple 'if' check.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/handle_exit.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 04ebab299aa4..275a27368a04 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -113,34 +113,20 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
  * guest and host are using the same debug facilities it will be up to
  * userspace to re-inject the correct exception for guest delivery.
  *
- * @return: 0 (while setting vcpu->run->exit_reason), -1 for error
+ * @return: 0 (while setting vcpu->run->exit_reason)
  */
 static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	u32 esr = kvm_vcpu_get_esr(vcpu);
-	int ret = 0;
 
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = esr;
 
-	switch (ESR_ELx_EC(esr)) {
-	case ESR_ELx_EC_WATCHPT_LOW:
+	if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
-		fallthrough;
-	case ESR_ELx_EC_SOFTSTP_LOW:
-	case ESR_ELx_EC_BREAKPT_LOW:
-	case ESR_ELx_EC_BKPT32:
-	case ESR_ELx_EC_BRK64:
-		break;
-	default:
-		kvm_err("%s: un-handled case esr: %#08x\n",
-			__func__, (unsigned int) esr);
-		ret = -1;
-		break;
-	}
 
-	return ret;
+	return 0;
 }
 
 static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
-- 
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
