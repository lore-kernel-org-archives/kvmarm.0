Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5354BC433E6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F286F64F45
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F286F64F45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A678A4B686;
	Fri, 19 Mar 2021 06:02:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CY6SRJLjUNyO; Fri, 19 Mar 2021 06:02:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7B4E4B6F0;
	Fri, 19 Mar 2021 06:02:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F7414B685
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GVAnoTddRgGM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:24 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3066E4B667
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:24 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id bt20so22809836qvb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4ECUgkoGREkKZOm9t4R+RTCdTGWy+OUrTPPjtPvrKJ0=;
 b=Kj+I8XUSYAKjeGpLxIgkzojVoc6Q8aAjQUqoardRlMXHKkE1x3Hp6aM8/W0NWM3wS6
 x07KjsT3mubuXhnLmeMXsPrp95J27xOrKgqQaicqp04hJjOUrQbl4wZ1d3l2EuE97uNA
 KFdgzB6H1vfbT0rsB22AEOJFCzusxBM9LzoPnaWfcjUp3azDpVTiPRIxfaOg1PKXBhaH
 bYUn792zhUYnV0jBul2s5F4ZYllrirEigoIZnTFRQCrRyv492wSQXt/AYK5VB5/4OyuC
 x/WjFtLj0nEM7wDemTUmCdSj2rgipSR0u85xE4dOQwbcN0r87clqymHWiUiL4b06S1qy
 UjWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4ECUgkoGREkKZOm9t4R+RTCdTGWy+OUrTPPjtPvrKJ0=;
 b=D99kd+t7NLZos+X20KU8irhtc7EoOAtZq0NZDSnVWeUxX2YyeG7Sr4T/5lTdYjEn/L
 yOSBHATSRbrrT89LusKCAxl7wLpcJaPti1wYfszEO2YarB0UMfiHTJoh3B+2E1IwoPDJ
 nPYKK8WblajpefE4a5DPQbP/lUR2ZUgqnFCAhzMCLE3+upFin4ze5QFsyzZmFh6LGk1V
 q+0sm8bIW2dzO5gK2j7Ta3tYVcdmOkiRZPyh91zCUEZy/G00Kks6MrL6fisb14pyy7VB
 HFKcFEJIIF6rtgryxTSFLYHK6ueHkLhxCz0Z/UlA45srJXhKo4hjBu9Dl8mT+HpNLU4S
 1kiw==
X-Gm-Message-State: AOAM532DB0JAtaMdsKcYEMYDVMFfkYF6ZAtfI/qeaZV51IIP7BDXGgBU
 SuQA8bMIWgi8C9fa8gXLtJalMSKR72Ss
X-Google-Smtp-Source: ABdhPJwN/h3k2TuK4CzLkm34ikKDRS783RduDg48Qy26uhc+DzE4q7IWFs4e3z0EnUvFZoGZQ4HMayCWmea/
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:d7d2:: with SMTP id
 g18mr8356263qvj.42.1616148143759; Fri, 19 Mar 2021 03:02:23 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:24 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-17-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 16/38] arm64: asm: Provide set_sctlr_el2 macro
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

We will soon need to turn the EL2 stage 1 MMU on and off in nVHE
protected mode, so refactor the set_sctlr_el1 macro to make it usable
for that purpose.

Acked-by: Will Deacon <will@kernel.org>
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/assembler.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index ca31594d3d6c..fb651c1f26e9 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -676,11 +676,11 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 	.endm
 
 /*
- * Set SCTLR_EL1 to the passed value, and invalidate the local icache
+ * Set SCTLR_ELx to the @reg value, and invalidate the local icache
  * in the process. This is called when setting the MMU on.
  */
-.macro set_sctlr_el1, reg
-	msr	sctlr_el1, \reg
+.macro set_sctlr, sreg, reg
+	msr	\sreg, \reg
 	isb
 	/*
 	 * Invalidate the local I-cache so that any instructions fetched
@@ -692,6 +692,14 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 	isb
 .endm
 
+.macro set_sctlr_el1, reg
+	set_sctlr sctlr_el1, \reg
+.endm
+
+.macro set_sctlr_el2, reg
+	set_sctlr sctlr_el2, \reg
+.endm
+
 /*
  * Check whether to yield to another runnable task from kernel mode NEON code
  * (which runs with preemption disabled).
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
