Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61764C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 09:28:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 069524A1B0;
	Fri, 11 Feb 2022 04:28:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O0eGXTyFUWBm; Fri, 11 Feb 2022 04:28:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2B844A7FD;
	Fri, 11 Feb 2022 04:28:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D52A349F53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:44:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DPkJzmAI9yXD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 17:44:45 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B85D649EEA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:44:45 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 3-20020a250103000000b0061d99b7d0b8so15082064ybb.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=2dZOYBOmJua4dYugoiMtuQUhFU9vmd43xxG8qEJDkFQ=;
 b=ep6/TNGFOJe8CMFzZYZTp3879NvaY6+muWoz075exQAtJ+Dtv/XxFOgo1TvFvY76YC
 XOB/EOtVDQ935brIbXoSTuX/PaYdWJC8dHLpt6DXVeYIdx05KvPgXyX9s2r4wBITC+yr
 AiLe4qiBik1TW8/yYKyz/i9tgLFNDvabJBTvtv17doe7xkkBUVgcvImDEydYuurvMduH
 wbTib7UbkW1wLjMaJazhGbz3ZRn3P6dDOBYxBoKnsfjlvq1oDKICPU7DpepOHn7PWInc
 6NuG3/TMjtT91dnM2QUaLSFBNYRxG6DVDul48ADGrixxtXdibO2kEXGlX1gPRU0hafh+
 ZcpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=2dZOYBOmJua4dYugoiMtuQUhFU9vmd43xxG8qEJDkFQ=;
 b=rz18qS1MxxItMhcn8MhanhhkyyrRujzM9NCapErc6GIO+ZI2ZaHsssFCo7+gVP+cn5
 eLeo4Olepd8KUwCxwKwGxHlk+7NtaQTQtpIjYm5Yo2b2vJrUyDio4SskcLVVg5lVvRbP
 PS68pe1CQdFG4DjF+/auqTJhITcT83/g/Wg4/JX4y3/LEjKhzv9MJ21XyCQQvLQ3Ujq7
 Ta1z+ckU0cSYhtsQpE/8QDjD8fcT5pN3/s+GQrve4kBHvbLiBnG7ZlZT/CkQWTeatAKA
 23jZ7itIiCHOOyeTMJZ8hFJYE7exuo2XCCWVIKwp21njrWlI2qxc5V9P94VSufa2XwNB
 VCjw==
X-Gm-Message-State: AOAM532CW78ePArncd6ZMDvwBdx7DjC6LL6fCQWIoLaqS9PYrOG//XfW
 Wt3YSVluQ6jhRik3cQVbOEgfkuInyV2DIDVrGg==
X-Google-Smtp-Source: ABdhPJzhHuVVpX5/8wSgs7kQYW10C9SFtD8VH8eIEn4uDIMdbuJGadpvTqkiYBtfns2EGA0KUtz+LKt9roCBW8sc/A==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:8f02:232:ad86:2ab2])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:548:: with SMTP id
 r8mr9416027ybp.717.1644533085249; Thu, 10 Feb 2022 14:44:45 -0800 (PST)
Date: Thu, 10 Feb 2022 14:41:44 -0800
In-Reply-To: <20220210224220.4076151-1-kaleshsingh@google.com>
Message-Id: <20220210224220.4076151-4-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220210224220.4076151-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH 3/7] arm64: asm: Introduce test_sp_overflow macro
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 11 Feb 2022 04:28:10 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, surenb@google.com,
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
 arch/arm64/kernel/entry.S          |  9 ++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

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
index 772ec2ecf488..2632bc47b348 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -53,16 +53,11 @@ alternative_else_nop_endif
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
-	b	el\el\ht\()_\regsize\()_\label
+	test_sp_overflow THREAD_SHIFT, 0f
+	b       el\el\ht\()_\regsize\()_\label
 
 0:
 	/*
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
