Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08C2C43217
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D534C491;
	Wed, 23 Feb 2022 06:02:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id glSziY6jQTJ4; Wed, 23 Feb 2022 06:02:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7211B4C499;
	Wed, 23 Feb 2022 06:02:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1DC4404B2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:58:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ySbszhyclRfa for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 11:58:27 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2243449E46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:58:27 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2d7b96d74f8so10202767b3.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 08:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=LdOkseL/SVBmCmTgjcnNq9QzVzqqoPlVFVsUav/JFK0=;
 b=FNoLI1ytq66gPDfA9ohgBGXwe3ZXAMfQPU+vmETuazTxn1eRt4sfndjKQl5vNg1s6N
 aKsNQ+NyKz9hsu+jiKv0znYXLeJd3n/+di/bVx097otwKJ+Pm8qhNs67V2lcMqwTVhI1
 wW9Xhb5tkIIU2yAp/NzXxghYQ+kMzgy+o2wG8PnfZAZIib9of+6+4qFBo+n7HfiKcBUT
 zgEVEI8Bx5lOplWa+VY0r+2kHSy9Bk1YC2Ipw+jivWuz7/saxNwcRLetDoqydMzCZ/+o
 DlsgOQQ986VSJnpFZSHCEQu861DTK2XF2rz2ttpajHfiMXQ90DWFxCmT05fG0qHlS8Nr
 E9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=LdOkseL/SVBmCmTgjcnNq9QzVzqqoPlVFVsUav/JFK0=;
 b=3N27nRt84P0EgREq662Oqv7wBAI616tzKAVPXnMFxcPOrJ90OOJVuMYIByEviUfk3f
 fLwVWuqDcjPK7BrUA7aaGgi17LZjZLfaHi/1elmrxBAj3JfOq7YeMOyP5Zip19IGbVe3
 WvM+sJp8KCKATU53Xb1X0NQDTbYbbg3i9MhDUFgKQjLiu0xTj6SHPNcoe8Xuk/amGOvG
 pE/8K4wOtMpUBV5dqNgu5EJw28FNryfwODIfd77Gj6c8c5OHuv7QtwsZQ1MilKl9iWFA
 Tg3eoT530tsPoqXiq4BZexEBvrdLUytOFYv678WWvYqOsGh8rTeMbomwHYgoinuBsoJr
 YLgQ==
X-Gm-Message-State: AOAM532xBuVsfntGJ9DpmRom2ZX5Hbr7GZ2cfa6ZhDiRfc106O7XLWDQ
 hQd3Fd7OfSVL3nusyT5ejfvPAtXrmz+UI8E7DQ==
X-Google-Smtp-Source: ABdhPJxTMt4EP42XEzXDEACbHfSQnsjw9YnBj/jsWJgMJWkojIR6N0I/bKfbgjEHFp9OFaaN7ZlREpz8dxBvYs+xsg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5db7:1235:b3dd:cfcb])
 (user=kaleshsingh job=sendgmr) by 2002:a81:b11:0:b0:2d7:3775:1eb9 with SMTP
 id 17-20020a810b11000000b002d737751eb9mr10900452ywl.99.1645549106468; Tue, 22
 Feb 2022 08:58:26 -0800 (PST)
Date: Tue, 22 Feb 2022 08:51:06 -0800
In-Reply-To: <20220222165212.2005066-1-kaleshsingh@google.com>
Message-Id: <20220222165212.2005066-6-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220222165212.2005066-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v2 5/9] arm64: asm: Introduce test_sp_overflow macro
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Kalesh Singh <kaleshsingh@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, surenb@google.com,
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

From: Quentin Perret <qperret@google.com>

The asm entry code in the kernel uses a trick to check if VMAP'd stacks
have overflowed by aligning them at THREAD_SHIFT * 2 granularity and
checking the SP's THREAD_SHIFT bit.

Protected KVM will soon make use of a similar trick to detect stack
overflows, so factor out the asm code in a re-usable macro.

Signed-off-by: Quentin Perret <qperret@google.com>
[Kalesh - Resolve minor conflicts]
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/assembler.h | 11 +++++++++++
 arch/arm64/kernel/entry.S          |  7 +------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index e8bd0af0141c..ad40eb0eee83 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -850,4 +850,15 @@ alternative_endif
 
 #endif /* GNU_PROPERTY_AARCH64_FEATURE_1_DEFAULT */
 
+/*
+ * Test whether the SP has overflowed, without corrupting a GPR.
+ */
+.macro test_sp_overflow shift, label
+	add	sp, sp, x0			// sp' = sp + x0
+	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
+	tbnz	x0, #\shift, \label
+	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
+	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
+.endm
+
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 772ec2ecf488..ce99ee30c77e 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -53,15 +53,10 @@ alternative_else_nop_endif
 	sub	sp, sp, #PT_REGS_SIZE
 #ifdef CONFIG_VMAP_STACK
 	/*
-	 * Test whether the SP has overflowed, without corrupting a GPR.
 	 * Task and IRQ stacks are aligned so that SP & (1 << THREAD_SHIFT)
 	 * should always be zero.
 	 */
-	add	sp, sp, x0			// sp' = sp + x0
-	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
-	tbnz	x0, #THREAD_SHIFT, 0f
-	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
-	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
+	test_sp_overflow THREAD_SHIFT, 0f
 	b	el\el\ht\()_\regsize\()_\label
 
 0:
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
