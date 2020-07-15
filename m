Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B540C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 284C320672
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Pvg8JidE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 284C320672
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7ECB4B3D4;
	Wed, 15 Jul 2020 14:45:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A-qQL7K-vlQl; Wed, 15 Jul 2020 14:45:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E861A4B1CC;
	Wed, 15 Jul 2020 14:45:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27FFE4B170
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MG9Aewo8d78N for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:03 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F2BE4B3AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:02 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id u186so2099227qka.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BlRmMyTPIZgZe3Qeld0d1Einv0prT8I9aNc0UH58IMU=;
 b=Pvg8JidE4vyEIjkDuaNN58mJlS9Orpz/N/WVlqkd4w1Kc+rEiYajvkRtASx9Alt77Q
 CuKh7GnExblR2PC0d2Tiwvfg0pZx1iZmxLHj0MdBIwrsmHb6aqq02P+Cf+QNuNk4XcVm
 7UbcIMOWXuLvb0h1KSHqlp6LQTVT7vgkpoSA7kzx9EScO86YqsDSZlVGn6jgqa70IQvf
 F60njGNdmJKPKK233tUMrW5KfCpzAXVy06DsrbxYEnh0VTdwJRkqDb8qz7YNc78T7WRm
 rqEzNc9D3045+PSTj/Lc0PIoBnKd/fNac7jn6TGba9KAxgrk9ZgPTgSqBtQa5bw+qVFV
 0uPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BlRmMyTPIZgZe3Qeld0d1Einv0prT8I9aNc0UH58IMU=;
 b=AbDNa7aJqusHi4pYIsCnH1ryLEMulXdbBKiPOz2Po+nJKQBhqa1pHizdmhU8H9QaKk
 RYtuAPLEhRiJY0ONMHfbsuXhlxYrNaMkf36jtrV+3Ep/XydJo0Z49r3n5HNleULtiLc4
 OEPVjZ45vhrIO/qFukjjFPVFHj7FQVuw1Z452tzPHXFGjQ5U3PKT4CTbJ42AXZthUCSP
 mnn4OBmVOP9V3hMaZPkywj1tJNz4di5AZsLjcUTrNBOSPSwjJLuGeZFtkZzdhV1QCqvV
 MGNt9AUcFt8lGv6mQM+X2BEzO2gV6mQB4D23N+8FOgELnCcQbf24F8Q7DX/JgtG+amzf
 rDUw==
X-Gm-Message-State: AOAM5330SYkOzwITcY6Gh5PYd6bdAXtaCmBH6+YRGTXmu+Qa8T3Jt+aZ
 FrzxrhRaJcS2fVlUP1+vnb6u4dwNaltoiJKXoFuPXaOOPS81UambaKYiHBXgKiiTgMk2Ms+SwI5
 nYUhtv0G2HC6P/7v029KS3sM2yL6fLQUyflJY4p1puDHMhJKDZ3iMql48GBY8QRtRXePV2w==
X-Google-Smtp-Source: ABdhPJz5XACgYsgbQjjqYUTiI20q8JUvEdMX3iHjZFcxlfZdmene/KBv258Vcs5/J0NQFDH2kDVJVRru70s=
X-Received: by 2002:a0c:ed2b:: with SMTP id u11mr699870qvq.45.1594838701491;
 Wed, 15 Jul 2020 11:45:01 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:07 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-7-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 06/37] KVM: arm64: Only check pending interrupts if it would
 trap
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

Allow entry to a vcpu that can handle interrupts if there is an
interrupts pending. Entry will still be aborted if the vcpu cannot
handle interrupts.

This allows use of __guest_enter to enter into the host.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/entry.S | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index ee32a7743389..6a641fcff4f7 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -73,13 +73,17 @@ SYM_FUNC_START(__guest_enter)
 	save_sp_el0	x1, x2
 
 	// Now the host state is stored if we have a pending RAS SError it must
-	// affect the host. If any asynchronous exception is pending we defer
-	// the guest entry. The DSB isn't necessary before v8.2 as any SError
-	// would be fatal.
+	// affect the host. If physical IRQ interrupts are going to be trapped
+	// and there are already asynchronous exceptions pending then we defer
+	// the entry. The DSB isn't necessary before v8.2 as any SError would
+	// be fatal.
 alternative_if ARM64_HAS_RAS_EXTN
 	dsb	nshst
 	isb
 alternative_else_nop_endif
+	mrs	x1, hcr_el2
+	and	x1, x1, #HCR_IMO
+	cbz	x1, 1f
 	mrs	x1, isr_el1
 	cbz	x1,  1f
 	mov	x0, #ARM_EXCEPTION_IRQ
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
