Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40E1C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F72064FB9
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F72064FB9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28CC74B673;
	Wed, 10 Mar 2021 12:58:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 26yEnMdHMRIb; Wed, 10 Mar 2021 12:58:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 041BC4B651;
	Wed, 10 Mar 2021 12:58:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87C674B3E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pfAAImYZCxyt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:27 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 379FE4B657
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:27 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id l16so1707491wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7ThSG/RVLlh/DBRky56NDH1ajIaqy925wlZsTYsbYqw=;
 b=JEuYpJoMd4eciXRQGFuNKzbOmm8jGRXPcoKh/AeoZEfNeJ8pnd2yQE6JjHaW0xAyCa
 pitaJDGhocf+iS6Ix5s83gf0SdJs18Bt+3rQeBC1COJjUlE/pWqLmZGpYl4Y3Q008Xxz
 +KdxiZRuiY9IFxXtfadfJLEllXYm2dMSI1zsnCLjKK//Z68dcq7eoQguhGhmu8QBcbSo
 zzqFqyy0UmFXIphK/sSFENn1hVHMx3C6eW9CGE2mWa11W4GEHDVuzldvjqZ4ksKH3Gay
 m69aD9AQuVq3EYAST0FylU3iVNlhbgm1upS9OevLd1cZJCy4YWWktRZC6J9ZOco8M96R
 DPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7ThSG/RVLlh/DBRky56NDH1ajIaqy925wlZsTYsbYqw=;
 b=QpXCBvVIVMEBHe95WuajnkSjDyon65N72Wv99VR1EQDGJ50zYAPBlraHz8AI0SMfE7
 6xMKmM0oIH1E11gWdJHwH5F5UgcFeNdQp1kFn2efm65GTZKoFcz4toyIhHdbLkmnfltG
 yEg1AGOgmEZp+ZnJBgC0vHdRrcxGtCIPSt6gdJ3m/gxVRzzXvXXlnYO9ctY91OHRf+NV
 t7A/P//zXfy86zwpvFKFMg7MlHEg/i7gxU9MvuwswLSGCYMDC07iDuqE4vmn3s22EXhU
 KNsyHfJnYLNIg0zGMgr4HvY60lOiiash5R/KlQiWZLgIfscQib++1JpEPvgIVOmJ+Zyw
 /bTQ==
X-Gm-Message-State: AOAM5321J9XSt0CSVbozHhCfNrYFSZWV2e1eIKWdsVaiRoTauXV9NW9+
 KKVmgPRAf8dVvQx5K1Cic2haEwhECMLM
X-Google-Smtp-Source: ABdhPJyE9VwVGP/miD0PZ3GZDCYZcaB5M6aMqWesnLSzh0vu9I8m1MWCHPX7MchrOCygw+09qd4prsL24INh
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:214d:: with SMTP id
 v13mr4574201wml.7.1615399106500; Wed, 10 Mar 2021 09:58:26 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:32 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-16-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 15/34] arm64: asm: Provide set_sctlr_el2 macro
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
