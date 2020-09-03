Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F707C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16882208C7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="a57VKu3d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16882208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2C244B2DF;
	Thu,  3 Sep 2020 09:53:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id biZe-5NB+N3a; Thu,  3 Sep 2020 09:53:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4FD94B2C4;
	Thu,  3 Sep 2020 09:53:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E5C74B16C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FkxEsalhTiGS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:28 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 478BA4B179
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:28 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id 33so1122280wre.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=m88A2XuNwMqKS/A5OTbXILtJDJGHHDQ7M1ytLL+HaFE=;
 b=a57VKu3d8f7YGU3eZEhfudZeLt+GdeXwu+I55kMo74gb4vQxXbVd5paqLtjkIPpROl
 u70wigQah1kJi7USgtlAKd6G1CwioTnLrTW9avprWqHZDNyGqBmJGB2shELbcl7w+JIc
 TOvAcLDRIRC1+mtTyg7gK18PIQwAx9KNp+TkrcYvJ7lTkj4PAkEphx39uLnuVlKRd8zg
 SCwsFNpP7mqSQEkuRHdHeEFdqdgq4MuJktCa+NBxGYmL2hcyUzLQkvwCV7xJ+7uZYy/0
 4O0RAFuehcbwsGZc6XD9fucQwrvNoiueJVJCvCsckuL51gG4g7gTM5S0PT0Vst7C9Tbg
 B70A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=m88A2XuNwMqKS/A5OTbXILtJDJGHHDQ7M1ytLL+HaFE=;
 b=doqRblY8+3bQA7NHGjIvdBJVpDFOB5l/jdg1lu99TkOyUSmnEJiOE3VicAWBroMiUW
 awjtM3Y6IDRdwN0gjPYtoD2hDQhxY31DCwddkMZEIaBoi/j90nBuvfzdUyYhhSCrt3gu
 dG2qVerqbYUWJmaXgkR6MoyPpxryUZchHgykmA9BXihXvK6F/2D1CHh+rHyFNFPTWfBO
 LwXVPhyqZn7Mr8Vh27TSZvUzhmvA64jI7hLM1BwOTmk0E0APP8h8PKKTsOFX8hYF8Oxq
 v2TZKt78Srci9UpJu/JxBaZtNYfOT5zaWtgoFN8xmjAEnwQaxREGhKjN7HE4bsfhJJP8
 Eitg==
X-Gm-Message-State: AOAM533d6I4Iu47FUxZ3x/okjoOnptkEPRcauxFe9wRoQFEKRjgmDnnM
 ROBagsRLxqlaYy+Me3hGffcqXU/e7hEBaEwgFbV1pd8OEU7HzADz8/qrrPbBKsFq8eIIhsOQcQu
 PDYY8ILGo9q1tEpntTJqHTFg6DtURkag0voDplJ37yCV2MRypo9buYH4j8occ+u1tj9K97g==
X-Google-Smtp-Source: ABdhPJzz/AyE5gxTbwTnqT54ZWV6iqg0ZGGspa3mL/skGF0KeoJc9Ohz89U2PYNeXcB7yShIkypJhdeyarc=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a1c:7c14:: with SMTP id
 x20mr287186wmc.72.1599141207351; 
 Thu, 03 Sep 2020 06:53:27 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:52:56 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-8-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 07/18] KVM: arm64: nVHE: Don't consume host SErrors with ESB
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

Fixes: 0e5b9c085dce ("KVM: arm64: Consume pending SError as early as possible")
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 9c96b9a3b71d..5a7380c342c8 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -24,7 +24,6 @@ SYM_FUNC_END(__hyp_do_panic)
 
 .macro valid_host_el1_sync_vect
 	.align 7
-	esb
 	stp	x0, x1, [sp, #-16]!
 
 	mrs	x0, esr_el2
@@ -77,6 +76,11 @@ SYM_FUNC_END(__hyp_do_panic)
 .endm
 
 /*
+ * The host vector does not use an ESB instruction in order to avoid consuming
+ * SErrors that should only be consumed by the host. Guest entry is deferred by
+ * __guest_enter if there are any pending asynchronous exceptions so hyp will
+ * always return to the host without having consumerd host SErrors.
+ *
  * CONFIG_KVM_INDIRECT_VECTORS is not applied to the host vector because the
  * host already knows the address of hyp by virtue of loading it there.
  */
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
