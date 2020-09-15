Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F479C43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D422206DB
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="BR0wA96A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D422206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7034B32A;
	Tue, 15 Sep 2020 06:47:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yOzsLpyCZQ-a; Tue, 15 Sep 2020 06:47:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23D7D4B345;
	Tue, 15 Sep 2020 06:47:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 534894B20F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JCpJeb8KQWQu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:47:04 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C70E4B345
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:04 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id y2so1903805qvs.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=Po+wZRTuKANKLTS58/LM8kKLRKZCbVKIB2pLYts5mK0=;
 b=BR0wA96AJwTKeBnilG3UFR16c/70GIr3wumgpyk13wvWak5PM4pFvRohcsFrvrIc8n
 QYs8cda2WMomNv5nXMnPLRM4eDxjCqsqkKgaxAIkw+2AxB0zgMAU937h4RhW0Ul4jWdH
 M0rpEqhPeKUXbcvGzsNqTGu8HizpEYSRveDWv4nZea+hwEgUbJXDcEx1j3hiDvNw/ppf
 WtaNF9aZ2WwVq5ft85QGu3IMKu1xIGRIrcnuwUJPhL03ip36Hl721+FIWnDflOuVfkmT
 n29hIqEg7W9Ok5YF5L0LfYLAceh9VQp9p2OC7H2JWUjNYEfcKW5g96lNbDhFGX3Qx/+E
 2bfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Po+wZRTuKANKLTS58/LM8kKLRKZCbVKIB2pLYts5mK0=;
 b=emWCVj+Lw5Ghb30EZ/WsmC2cdifOn6+O+0xXuA0RzdAIBa3gUiDfhH636l5Wbva8+p
 doR3rXsPRLvBiPvQg9t+TJy2TUSVOdR48sWdufIWvkb15kNCCCy6CoodPWB/uGj8iULl
 pVDIkgiPIKN+Yo3gGSmRCdEei11fRmKRC584iLYzlv5nViGrsgzCcIkNwuo1sn3ZWDo5
 XHfgtFXOfeeJa9Wl1yVWuDTkTOzuqMvPT+10xYwUIXamb8OWyJA7clZIxm7zw6Pv4Q4D
 Imgmx3d8KACOsNGL6MDBuW8JBuQ11HgWc3WFEmGVR/RejhdtsTPq4v5YoXtTmMaieoR/
 hxLA==
X-Gm-Message-State: AOAM5328VOUMUpq6MoYR1Djjjok1RlAw6VUKLQoON5eQxxeD3qk9diwn
 y2S8gpARUUreD00DwHOw4nQDYuY9pzCRJ84mJY5Q7j+FmCYUKQaZT6Q+bv4dvATf+LMxkdiFeXE
 wUUjNNRj/ZKtSJc503wvEOme5p4S8MS8AyM3ehgEj8IPt9rRqyvzbubH3ztJthYdVVFq0TA==
X-Google-Smtp-Source: ABdhPJyk+qo1IWq4RwKq+M14b8Jl4v+fz5ZHo09dFG0qc7AlS0GZMtT0cSyfEDGhRW0gRIflrPcIfh2Dpsk=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a05:6214:a11:: with SMTP id
 dw17mr1007655qvb.62.1600166823797; Tue, 15 Sep 2020 03:47:03 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:31 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-8-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 07/19] KVM: arm64: nVHE: Don't consume host SErrors with ESB
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

The ESB at the start of the host vector may cause SErrors to be consumed
to DISR_EL1. However, this is not checked for the host so the SError
could go unhandled.

Remove the ESB so that SErrors are not consumed but are instead left
pending for the host to consume. __guest_enter already defers entry into
a guest if there are any SErrors pending.

Cc: James Morse <james.morse@arm.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 128af58d342d..da21fddcef75 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -25,7 +25,6 @@ SYM_FUNC_END(__hyp_do_panic)
 .macro host_el1_sync_vect
 	.align 7
 .L__vect_start\@:
-	esb
 	stp	x0, x1, [sp, #-16]!
 	mrs	x0, esr_el2
 	lsr	x0, x0, #ESR_ELx_EC_SHIFT
@@ -80,6 +79,11 @@ SYM_FUNC_END(__hyp_do_panic)
 .endm
 
 /*
+ * The host vector does not use an ESB instruction in order to avoid consuming
+ * SErrors that should only be consumed by the host. Guest entry is deferred by
+ * __guest_enter if there are any pending asynchronous exceptions so hyp will
+ * always return to the host without having consumerd host SErrors.
+ *
  * CONFIG_KVM_INDIRECT_VECTORS is not applied to the host vectors because the
  * host knows about the EL2 vectors already, and there is no point in hiding
  * them.
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
