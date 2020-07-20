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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAB6C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jul 2020 18:30:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77A77208E4
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jul 2020 18:30:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sDanTDz9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77A77208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E46BD4B1BC;
	Mon, 20 Jul 2020 14:30:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LWZrRmoCTYUM; Mon, 20 Jul 2020 14:30:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D59BD4B1F8;
	Mon, 20 Jul 2020 14:30:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 577034B1BC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 14:30:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pQaABQnmlPQL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jul 2020 14:30:00 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 368D84B1AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 14:30:00 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id o11so18812360wrv.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 11:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=D95gU7RsNuUebcW/DXQQNWzRuFfBAwdF1di0SQ6P2nw=;
 b=sDanTDz9hQdQObRogJlHwmOHojVMQOpAxSiTkEanBT0XY9l3Gpd0ajVJ39dh28KnZ1
 5WVKz547vQqodfPVaymCAI1W15ib7JdeC/iXEtH0vt92s9EvfoPPBmKbrBUeKZFa/vam
 6Mn2576MlwaWKATO4KYwr6c4l+BIS0n+PMG9gmiz0pU4U2IHOHdIhqgximQmuAmo0dI/
 F9I/YvZ90hvtqeyeCzC04Gg844jbh5ZtqwqVrfoqkQfY5j1r5ltoOdZ61drE6LA8z5V9
 8kXX1s0QZSseZl4+ErzFEWNoZHGQpV5MWkiCQIA5nQWtrEepgnPUGY5ct9mxdyb45VfB
 ai+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=D95gU7RsNuUebcW/DXQQNWzRuFfBAwdF1di0SQ6P2nw=;
 b=Sl3B8VJtBLzB0mOdHAkU5LmrP9Yz/b9+qGLvUykHsXt+LqLG+KpIF+a2vh3L2CCImh
 36IJjyI6wUHbDiJ2RwIatVgGi7up7PvCVQdv91TPsbdLIRHK5SxhfPa2DcpENt61xKZt
 ECSJYAyTMazelCD/ZwJvwnTrKTfPVyX+j5Xo7Q967uA8ORJGZlH9KI4UNctbbtPF21DF
 /zuoT5LsxokWTs6Y4/cyhoQhkSXMSyyz1q4a/EKf6arOaC8PF1Fk06eIIaBMWPJDoJIn
 xPAyFphUmwnbHFDytyvB1E9SohGiXKCmnx0OIo3bYOTaU+EFZG0Kfia2jINrAcykqXlY
 Fo1w==
X-Gm-Message-State: AOAM5324WJtoro8nLbGb6fIscMlb4a9Za9MzMjNYdPTQizBGEtYZlc4b
 rJqgwiJ7kt/N9PaXhCnkgio=
X-Google-Smtp-Source: ABdhPJz4JeI1ahtujTSu2VCDPPbOIBBdqG4fNC2Gz8FXvh7yofmruG+BZqPQ9YB/fWEZCzxa10YD9g==
X-Received: by 2002:a5d:6603:: with SMTP id n3mr24164764wru.142.1595269799106; 
 Mon, 20 Jul 2020 11:29:59 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id t15sm477825wmj.14.2020.07.20.11.29.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jul 2020 11:29:58 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH stable 4.14.y] arm64: entry: Place an SB sequence following an
 ERET instruction
Date: Mon, 20 Jul 2020 11:29:36 -0700
Message-Id: <20200720182937.14099-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Cc: "moderated list:ARM64 PORT AARCH64 ARCHITECTURE"
 <linux-arm-kernel@lists.infradead.org>,
 Florian Fainelli <f.fainelli@gmail.com>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org,
 Shanker Donthineni <shankerd@codeaurora.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, will@kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
 <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>
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
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
