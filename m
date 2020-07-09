Return-Path: <SRS0=7isg=AU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB780C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jul 2020 19:51:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2ACAD20720
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jul 2020 19:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AznY960+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2ACAD20720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A49F4B15A;
	Thu,  9 Jul 2020 15:51:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ePZoSd8sXkIJ; Thu,  9 Jul 2020 15:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D284B15F;
	Thu,  9 Jul 2020 15:51:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66AF44B15A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2020 15:51:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d2hqto-8KBEl for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2020 15:51:01 -0400 (EDT)
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com
 [209.85.214.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 587D84B14D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2020 15:51:01 -0400 (EDT)
Received: by mail-pl1-f193.google.com with SMTP id x9so1254750plr.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2020 12:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=RwIQJPyP7UHlF/ZGGKtcnGZyKRkZA3pCBcfEq7K/2Ho=;
 b=AznY960+pK6TOErT6DuUqz4G4vZlBkddYOl5d2OHe7pG00Y0HIPRjgSEb5zEauhq3u
 RKM6boUHn3SMWeCJDchdIobej2f1kSt+RZnspd8DsOp/HbooshTkDo+M00AmnvDD6yXH
 07OtQgi8r6ZPSJ0Eky6PU/dhvo8seV9KaGEOORqVmXVD95zxKP5jR5wAtjB3sN2Ew/hy
 194wpp1EWZyhMIKvI8Zcwi+hxgj5t/ag+Ch9C2Q9Lsq4+u6xoosUVdcMXrVlxNwX4KnF
 b4SSBTNB108RFRlXcVo67ObtTCVjwrxgMaYcHYZ4WSWCa1aEhdNOPddPq475+qFl6uyO
 X/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=RwIQJPyP7UHlF/ZGGKtcnGZyKRkZA3pCBcfEq7K/2Ho=;
 b=J8/sUwlo38GS7sPa5NB197OihlK6b09zAcFfGFA1YvDK3Lr/e0JaDateYhON5JTSzb
 xFDudssKYCcjTZdVh5/IG9/OJb0ksf59aSuk1KLfUYt623YPOY6NzktTtWUl3NawkCu4
 s6DbJjZ0d6nR0184NfM4uI7GDsc+sNVSdy3stLZzWM+C/y0yPLXkBBsH/CTc608VIytH
 aO0i68eRvV3FfruYtizFaAKt50yB7mQLLQOvKROWS8nifOpTcSungv+hhZSAnJn8I/si
 KY9peoBlwSKLFIobfQyv61qYNfepl/chjc788flL8bSDqTKZ0GaESefxEvmGRNsFT08h
 NJrQ==
X-Gm-Message-State: AOAM532T8VoV7tWyXtsosi8ukNRw6zrOkolyIHZgtQdmDkEVElifs5qL
 HL1b3CSWZuHxqkBUIX0fBYQ=
X-Google-Smtp-Source: ABdhPJwDJxkzz3kgTcJCu9/JCf8HhRsvChMEW+U2cgrMgNAOBN45sP1bW6XPDT8vS97J11EP5enArQ==
X-Received: by 2002:a17:902:820a:: with SMTP id
 x10mr4938403pln.135.1594324260334; 
 Thu, 09 Jul 2020 12:51:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:67:5b9:5dec:e971:4cde:a128])
 by smtp.gmail.com with ESMTPSA id f2sm3694941pfb.184.2020.07.09.12.50.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Jul 2020 12:50:59 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence following
 an ERET instruction
Date: Thu,  9 Jul 2020 12:50:23 -0700
Message-Id: <20200709195034.15185-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Cc: Nick Desaulniers <ndesaulniers@google.com>,
 Florian Fainelli <f.fainelli@gmail.com>, Fangrui Song <maskray@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
 <kvmarm@lists.cs.columbia.edu>, Mark Brown <broonie@kernel.org>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Sami Tolvanen <samitolvanen@google.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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
[florian: Adjust hyp-entry.S to account for the label
 added change to hyp/entry.S]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- added missing hunk in hyp/entry.S per Will's feedback

 arch/arm64/kernel/entry.S      | 2 ++
 arch/arm64/kvm/hyp/entry.S     | 2 ++
 arch/arm64/kvm/hyp/hyp-entry.S | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index ca978d7d98eb..3408c782702c 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -255,6 +255,7 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	.else
 	eret
 	.endif
+	sb
 	.endm
 
 	.macro	get_thread_info, rd
@@ -945,6 +946,7 @@ __ni_sys_trace:
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
index bf4988f9dae8..3675e7f0ab72 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -97,6 +97,7 @@ el1_sync:				// Guest trapped into EL2
 	do_el2_call
 
 2:	eret
+	sb
 
 el1_hvc_guest:
 	/*
@@ -147,6 +148,7 @@ wa_epilogue:
 	mov	x0, xzr
 	add	sp, sp, #16
 	eret
+	sb
 
 el1_trap:
 	get_vcpu_ptr	x1, x0
@@ -198,6 +200,7 @@ el2_error:
 	b.ne	__hyp_panic
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
+	sb
 
 ENTRY(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
@@ -206,6 +209,7 @@ ENTRY(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 	eret
+	sb
 ENDPROC(__hyp_do_panic)
 
 ENTRY(__hyp_panic)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
