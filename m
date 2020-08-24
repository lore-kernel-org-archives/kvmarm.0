Return-Path: <SRS0=9KKW=CC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C4EC433E1
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 18:36:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CEFD2075B
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 18:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jUJ9df3y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CEFD2075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAF0B4CC90;
	Mon, 24 Aug 2020 14:36:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YdKcUN8eEFzl; Mon, 24 Aug 2020 14:36:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4281B4CC91;
	Mon, 24 Aug 2020 14:36:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E42F54CB32
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 14:36:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7QmITh8CMZQf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Aug 2020 14:36:18 -0400 (EDT)
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
 [209.85.210.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F42C4CC81
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 14:36:17 -0400 (EDT)
Received: by mail-pf1-f196.google.com with SMTP id t9so1128441pfq.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 11:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=obhG8AJIVazsG1yWtHmg5cIFCtDuigRomXYssQ4Do2E=;
 b=jUJ9df3yj+pkvI1hq/HzPB7Bofb8F5DooHsNgSB8DGuKkqYlbXuvJhczfiw0LPcO5C
 XGCcOpS4QvB2EwjJwbRQ/TtRnzeXfW5IWH5JZue+YORh6OJF0xvJV4FTQ5Y1LoD57zLO
 d0DAVaggGwH5MPwzJNKBI/kuqC4EV5uR17VwIu2sUSSPO5kBjD0bG2oTKsJUUL0ncwJe
 hJPwD+dbMfOLb1ChQOhbLIRjRLptbjstQrcJ6lzp6BGCwkHKa9jWWltQ+YY/95nhtJbR
 e57v/mpiBl62YBgAjxWjnB+IOy/jYe5f9W3pw5Dcly63+MUAEjxnO0icywPteM4uh22L
 NreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=obhG8AJIVazsG1yWtHmg5cIFCtDuigRomXYssQ4Do2E=;
 b=rWiInZytCyJeXWxDdFsL55YH6u9v4fJkAkQwtnGu+WXNGlIU4rf8TKiXj04t3EOUl9
 2xKfQXyeClHO9pWs++tmQKcIX2Khvvz8+R6micjv1swqqxYr8gI2DgMurmXv8YpjtzWb
 rtslLkwfiQ3in998/FFfc1hcQ2HSggNMt4Yo0FEQKFuiy8mDC+AOIDeanYtRljxahJMx
 TikN7FLNZiZ65egFPB/RYSTaljY4E4tgz0kpu8TJWpW+W0Hu7QB5tbMMIKtPAlb8N875
 PWoAQ7q6mnEfzdiYMK+RWLJ7sF8pk5MDyPKaCGrTdOeXdPJjXGLZdulwezpbei2TstLv
 syuQ==
X-Gm-Message-State: AOAM530daveWtT7XMZ7BD7honhwrQsBKH2Cz2DQWMpWm2nD3VkQhnErn
 t9sZbgnPQ6BNhZpg92n6njE=
X-Google-Smtp-Source: ABdhPJw8UONw9SN2fq4ejwCcRr7xE74Tffx3QRdwXbcYFaiLe0qYtap+qKfXwjFXiJrChkElB9kUNA==
X-Received: by 2002:a17:902:cb91:: with SMTP id
 d17mr4496547ply.223.1598294176863; 
 Mon, 24 Aug 2020 11:36:16 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id n5sm10523099pgt.24.2020.08.24.11.36.15
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 24 Aug 2020 11:36:16 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH stable 4.14 v2 2/2] arm64: entry: Place an SB sequence
 following an ERET instruction
Date: Mon, 24 Aug 2020 11:36:10 -0700
Message-Id: <1598294170-24345-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598294170-24345-1-git-send-email-f.fainelli@gmail.com>
References: <1598294170-24345-1-git-send-email-f.fainelli@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 Fangrui Song <maskray@google.com>, Nick Desaulniers <ndesaulniers@google.com>,
 Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>,
 open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Mark Brown <broonie@kernel.org>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Sami Tolvanen <samitolvanen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Will Deacon <will.deacon@arm.com>

commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream

Some CPUs can speculate past an ERET instruction and potentially perform
speculative accesses to memory before processing the exception return.
Since the register state is often controlled by a lower privilege level
at the point of an ERET, this could potentially be used as part of a
side-channel attack.

This patch emits an SB sequence after each ERET so that speculation is
held up on exception return.

Signed-off-by: Will Deacon <will.deacon@arm.com>
[florian: update arch/arm64/kvm/entry.S::__fpsimd_guest_restore]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm64/kernel/entry.S      | 2 ++
 arch/arm64/kvm/hyp/entry.S     | 2 ++
 arch/arm64/kvm/hyp/hyp-entry.S | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c1ffa95c0ad2..f70e0893ba51 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -367,6 +367,7 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	.else
 	eret
 	.endif
+	sb
 	.endm
 
 	.macro	irq_stack_entry
@@ -1046,6 +1047,7 @@ alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 	mrs	x30, far_el1
 	.endif
 	eret
+	sb
 	.endm
 
 	.align	11
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index a360ac6e89e9..93704e6894d2 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,7 @@ ENTRY(__guest_enter)
 
 	// Do not touch any register after this!
 	eret
+	sb
 ENDPROC(__guest_enter)
 
 ENTRY(__guest_exit)
@@ -195,4 +196,5 @@ alternative_endif
 	ldp	x0, x1, [sp], #16
 
 	eret
+	sb
 ENDPROC(__fpsimd_guest_restore)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 3c283fd8c8f5..b4d6a6c6c6ce 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -96,6 +96,7 @@ el1_sync:				// Guest trapped into EL2
 	do_el2_call
 
 	eret
+	sb
 
 el1_hvc_guest:
 	/*
@@ -146,6 +147,7 @@ wa_epilogue:
 	mov	x0, xzr
 	add	sp, sp, #16
 	eret
+	sb
 
 el1_trap:
 	get_vcpu_ptr	x1, x0
@@ -204,6 +206,7 @@ el2_error:
 	b.ne	__hyp_panic
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
+	sb
 
 ENTRY(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
@@ -212,6 +215,7 @@ ENTRY(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 	eret
+	sb
 ENDPROC(__hyp_do_panic)
 
 ENTRY(__hyp_panic)
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
