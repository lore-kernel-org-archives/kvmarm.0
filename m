Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB97AC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8125C61263
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8125C61263
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37DFA4B115;
	Thu, 23 Sep 2021 15:16:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UuFfMOieRMTy; Thu, 23 Sep 2021 15:16:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B23A4B125;
	Thu, 23 Sep 2021 15:16:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC9FB4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZxpCIdStTQDC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:19 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19E554B0F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:19 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 l15-20020a92700f000000b0024a1248ff32so6429625ilc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wuhjwc3cWbjk5tU/NeZeTgW/a/HXaQKuoN5QMNZMGeo=;
 b=NW8v62EkiXXa/7jVpmzPJkblutKY6sFQQtlrPHUh/urfKOecQh+LY5D8kM6u7PPiWK
 0oly2o5b/4LbqN+NIplDvevj7Cn/th27ZuwZgEi10MtixmOenyMM05kj0nrSpUes04bw
 PO7kEWOWJCJZri+aNKHQk6SxmvMsNxOcvAgqk+00DbZfsyzbeEIf/7YXhOTlO8kTeuiZ
 pq15LOw3gPdO6YKDTMwsdTYROADLZhHQBhYN7It3etPcpx1ASAmzXpG+1q2IN4u2fpR+
 /MmDb4XK28dvfXRL+evkK+1tr6W+pyL+tfA8StOQQbxdOUwOZ2Y6u924RyVvgx1KXmHK
 Bq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wuhjwc3cWbjk5tU/NeZeTgW/a/HXaQKuoN5QMNZMGeo=;
 b=1bJbn1NvDqLmP1cKtPB81IZwhVtsgLqcb4EKF/89r6xQn0/tOCPwREccjhTAwr2B43
 5/lL7mma3RL0AssldgGmwrm/qaRuR5YU+nim90RtTsLWgqi0/urAMJB6/oAMm9611Iew
 j5l412GtsrzVTGpJ+Sh9ongZWM7YBw9MCNW55S6VD6+iOlRBYCYNPBwesIQBZQk8vJ3e
 e34Di/1TtZKgvL+iYHQcvdedEyGOo/h1/hthfGCmL4aDf0f39OFudjsBGB3gqLw3NCWb
 LsjMu7OKCbaQPjTy69bYi1Me1f9fxQniCCuEMJxlMXC7skYd8in6JQHWCnpdQpcidBdP
 knOA==
X-Gm-Message-State: AOAM532jpnaVeFjMEq5/gT2aHVxWd63HwNxo3+C45qbvQvuXb6U2+qzC
 7nktxt8FmpyDH4rSzDOGjP52eCOBpc7pASQVWeITQ1lcac8x1Gyg/jMBugJGnNaK/qP5nAqXjZl
 Ig55XDjNG9784RHDfipKmwSNIaDJ2kM78M+kAgcMmyZWogewAjsusUJWW+3IQMO15fYTfDg==
X-Google-Smtp-Source: ABdhPJzwGEX23UIo4CYuNKmMK206kckBCE8dVTHHtaVtRij6igKpJLs0Yao5aVSEMfyGpu3eSFezGo0/Qb0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:7710:: with SMTP id
 n16mr5290999iom.101.1632424578398; 
 Thu, 23 Sep 2021 12:16:18 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:16:01 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-3-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 02/11] KVM: arm64: Clean up SMC64 PSCI filtering for
 AArch32 guests
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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

The only valid calling SMC calling convention from an AArch32 state is
SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
when called from AArch32 rather than comparing against known SMC64 PSCI
functions.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index d46842f45b0a..310b9cb2b32b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -208,15 +208,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 
 static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
 {
-	switch(fn) {
-	case PSCI_0_2_FN64_CPU_SUSPEND:
-	case PSCI_0_2_FN64_CPU_ON:
-	case PSCI_0_2_FN64_AFFINITY_INFO:
-		/* Disallow these functions for 32bit guests */
-		if (vcpu_mode_is_32bit(vcpu))
-			return PSCI_RET_NOT_SUPPORTED;
-		break;
-	}
+	/*
+	 * Prevent 32 bit guests from calling 64 bit PSCI functions.
+	 */
+	if ((fn & PSCI_0_2_64BIT) && vcpu_mode_is_32bit(vcpu))
+		return PSCI_RET_NOT_SUPPORTED;
 
 	return 0;
 }
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
