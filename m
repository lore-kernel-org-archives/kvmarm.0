Return-Path: <SRS0=coVF=A7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A1CC433E3
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jul 2020 18:26:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 84C43208E4
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jul 2020 18:26:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SRV3gLWL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84C43208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E212F4B1E1;
	Mon, 20 Jul 2020 14:26:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4dE-Ji5JNjCo; Mon, 20 Jul 2020 14:26:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D27284B1C9;
	Mon, 20 Jul 2020 14:26:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 430434B1C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 14:26:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t4dlafdv2pfC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jul 2020 14:26:11 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 246C44B1BC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 14:26:11 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id b6so18788152wrs.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 11:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=lj9ZknVcrD3MA4t8QmNQ12rpsDUhjiYrWHP/I1wz74s=;
 b=SRV3gLWLaFDivOniTKfXDlRqb5BR+1ORl45h0alrybpcGwh7MwzAnhjDYScrdQqAqG
 lOq7WpXbxUWnuOLBbnG9RFx479KHXJndGnOfGK324YKDf6WK0tAWyhclNcP0Sz9BXvL0
 h05LUSwfwEF9cS4s1p9XCgHvN9qskodgaabbClsTwme6/gsZsOE1/dwmzrIyFEgiXOJj
 hZSXFqFkwLAxF0jIQZhLz6lI5u9UTUUX7Fph6uS/tHMANVbjYFezP1ll6SOsKeidsNqB
 d6GwRwLDsJkqxky3JbTiVVK8aAXHZ9PwIk4SwUBjDuHaKT3aEY3xRIug92j1IxYnM4GG
 /3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=lj9ZknVcrD3MA4t8QmNQ12rpsDUhjiYrWHP/I1wz74s=;
 b=az2b3HhabokusRiUp2/nnHUiI3nRwyaRPzgisfaLbJKYF6h47NiPUZ8ma8pHlHL8FH
 pfTwy27PVE+1aKScJO1DOohZNfFek17pch8l5HkYSzDa/XOVES3dQ4+6Ptf3D7zwtxo3
 mJQMB5lLFV1ANUd0cjMm+Y2bvccObLsKucvJAA8sen+2PeGlRIcfv7vvMwWSaWjetwpi
 Kd0+zc+gUCfPJW91dF71klHoS4pOpLn6W82clfFHe/OBxl/sgyziZbxlVPOY20kw/Zmb
 IujQW3Xyf1/3N8eSSYSYhNUWJ2hwmjUm8mG+FGSIrA/iZ634QISWLJBoeU4GBd5HP0O7
 bKjw==
X-Gm-Message-State: AOAM532tW4CLYqda28qMuBq2OC6wtRsIWqslOM40Bq5ZFBK8bRLoxJ86
 Y/Jx3CfscmjwZS/NDI0FQ4U=
X-Google-Smtp-Source: ABdhPJzTmHsYloYlnQp0ihbIybRCflF9ZffwP80u0Ay5lylmf7xqW8rfqcqRdHMBm/3lVw2qdPpZvQ==
X-Received: by 2002:adf:d08d:: with SMTP id y13mr3145410wrh.313.1595269570059; 
 Mon, 20 Jul 2020 11:26:10 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id v11sm699363wmb.3.2020.07.20.11.26.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jul 2020 11:26:09 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH stable 4.19.y] arm64: entry: Place an SB sequence following an
 ERET instruction
Date: Mon, 20 Jul 2020 11:25:37 -0700
Message-Id: <20200720182538.13304-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Cc: Sasha Levin <sashal@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, will@kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT AARCH64 ARCHITECTURE"
 <linux-arm-kernel@lists.infradead.org>
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
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm64/kernel/entry.S      | 2 ++
 arch/arm64/kvm/hyp/entry.S     | 1 +
 arch/arm64/kvm/hyp/hyp-entry.S | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 5f800384cb9a..49f80b5627fa 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -363,6 +363,7 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	.else
 	eret
 	.endif
+	sb
 	.endm
 
 	.macro	irq_stack_entry
@@ -994,6 +995,7 @@ alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 	mrs	x30, far_el1
 	.endif
 	eret
+	sb
 	.endm
 
 	.align	11
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index fad1e164fe48..675fdc186e3b 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,7 @@ ENTRY(__guest_enter)
 
 	// Do not touch any register after this!
 	eret
+	sb
 ENDPROC(__guest_enter)
 
 ENTRY(__guest_exit)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 24b4fbafe3e4..e35abf84eb96 100644
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
@@ -185,6 +187,7 @@ el2_error:
 	b.ne	__hyp_panic
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
+	sb
 
 ENTRY(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
@@ -193,6 +196,7 @@ ENTRY(__hyp_do_panic)
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
