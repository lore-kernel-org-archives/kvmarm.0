Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A133C433E6
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 17:38:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A6D0D64E12
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 17:38:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6D0D64E12
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 031094B178;
	Thu, 28 Jan 2021 12:38:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KgfRs2FlRJVW; Thu, 28 Jan 2021 12:38:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D085C4B1A2;
	Thu, 28 Jan 2021 12:38:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EAA44B17D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 12:38:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yz9TWhqRQfSy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 12:38:55 -0500 (EST)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30E9E4B178
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 12:38:55 -0500 (EST)
Received: by mail-ed1-f73.google.com with SMTP id o8so3551724edh.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 09:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=TrahohdnGnkFNIlzsxT0lt2fKHMsEEWPsWhwzs4awt8=;
 b=uukTJK9rp794K+uk3CI4kYPX+Mu1VkRgFU3Nkz0UD6J51DW9OqWQHkIlADcKrO8NDC
 PfYfKMwHHla4Yxj07UL1oI5BN32BuvvgAslyhCF0Ky+oDyYXLefeZ5zckX6jiYHKGM8C
 lY+jXTTQGzTjfd5qAnfeiE4ueO4TjhSY69iOz7yHDZBv1tF+1ketzX8IWxCt/WDO5EW8
 5r1sOEUl+wYEsmXlC0Rvj+Fj3++dhKjrCXvWBszTSxRJm8Omqb62yoLDX1v6R1Ws66OQ
 /GmOQ7B5A5q4BqFu9EsVM82Hi1nVhuKY7oupMhhaMVCKL/IrtcUcWxauxqna7xkVy4Gy
 qSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=TrahohdnGnkFNIlzsxT0lt2fKHMsEEWPsWhwzs4awt8=;
 b=SA8FkQgNripor3axGi1O48hRmfdzfT+jKQGJWEfc9e3ZOHoJ4zaL1P/+F691wBq6O6
 7eF/yMuiqYHE8M2aUUaozuMZ4Lsh6G1KYOHZWnYbDFDDBxLs7IoR0VRdfTtYrH2HcUR+
 GQtutMlehGZiL2RDcFxTSrSRhYHtKGMhbk2TzeZoaHfyeKQUAZs5eaBMFAiVjevj8bd0
 aeraDMxKK0VQ90amQwkEI5blDozvAP/DHlfm7/WWfnavAY6mlgUYNl5R1Gmuls8T6Eg1
 XgwhqFi1Bb/AnrS1ijj09sbarzkeOq3Ts/0LkCrQ8GQSwhCM3wm+Pf4W/qBEcFsCa4ul
 vOHQ==
X-Gm-Message-State: AOAM532wT9t0TlCsvCDOAheryQfgyC5FaJmBeEDVOKrHKzTxF9sL8qz2
 HmNjv61mnKy6KB/r40r1XMRHfCW0s0rX
X-Google-Smtp-Source: ABdhPJxEhKi749Qbu8TbBAghdDiR8ZIeAEhUG60Tu9mrTIiKptvwvEbelYwTE1zdZE7ACRqs/3KXL+gvnUFV
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a17:906:3685:: with SMTP id
 a5mr496672ejc.544.1611855533828; Thu, 28 Jan 2021 09:38:53 -0800 (PST)
Date: Thu, 28 Jan 2021 17:38:50 +0000
Message-Id: <20210128173850.2478161-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH] KVM: arm64: Move __hyp_set_vectors out of .hyp.text
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

The .hyp.text section is supposed to be reserved for the nVHE EL2 code.
However, there is currently one occurrence of EL1 executing code located
in .hyp.text when calling __hyp_{re}set_vectors(), which happen to sit
next to the EL2 stub vectors. While not a problem yet, such patterns
will cause issues when removing the host kernel from the TCB, so a
cleaner split would be preferable.

Fix this by delimiting the end of the .hyp.text section in hyp-stub.S.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kernel/hyp-stub.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 160f5881a0b7..8a60f9c586bb 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -85,6 +85,8 @@ SYM_CODE_END(\label)
 	invalid_vector	el1_fiq_invalid
 	invalid_vector	el1_error_invalid
 
+	.popsection
+
 /*
  * __hyp_set_vectors: Call this after boot to set the initial hypervisor
  * vectors as part of hypervisor installation.  On an SMP system, this should
-- 
2.30.0.280.ga3ce27912f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
