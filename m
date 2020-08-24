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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A729C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 18:36:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 104F820FC3
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 18:36:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DXXQnvZp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 104F820FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7714CC8D;
	Mon, 24 Aug 2020 14:36:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4a7m-UAMhRhi; Mon, 24 Aug 2020 14:36:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD8154CCA4;
	Mon, 24 Aug 2020 14:36:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23DDA4CC23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 14:36:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id we4zJuCpHF5m for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Aug 2020 14:36:30 -0400 (EDT)
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0515D4CC0B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 14:36:30 -0400 (EDT)
Received: by mail-pg1-f195.google.com with SMTP id m34so4973451pgl.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 11:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=3q7TgN3lxewyLqAIBfP9LryeeItLVKAQXHJvLwyIaWM=;
 b=DXXQnvZpQdBxWWuTfbWVY5FLOwytb0aSgYz9mPH9jwhVJ/ogBB2JP13Gr4jK7HM73T
 pc/bkX58u16w83O633eIk/waD+bT8E/aoCcgOOg01+1vouzqLJH0+zGQjpzQJFyg0FZM
 mauzJky23s4DKNw2+aNYSjn1sV7zZZvHGKo4/0BHmr5FKsNRLRZXrAxTyrW6tvy3xhDC
 /27GPtZ1Tm5+yzrDJZcaCnxIN0oRlJybvVM6DWCbdS2+r7BgXNLnHHCtzQ1epJHThmTq
 nuiTZWKKuwFHf58c5DAoL1PXrjj4dXftqHFIRq8jatyM8kSLLpJJ4ZP+WD0NdXeYZWYa
 7m1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=3q7TgN3lxewyLqAIBfP9LryeeItLVKAQXHJvLwyIaWM=;
 b=gNipoynqD9MktE+jdw1gZlqGWSJTjgDdhVjvMGU8Y20wnhAjeXoobQVwAdfFaSoDw1
 VK9SCbAt0+jvx3Jf7OHolgdIpairlb0kTTtM5EGwPcGu5N5c/x+E+k8AWNBpVH9Cp4lX
 Qd8FtTyPWFMhM7FCioCWE+m9E0YtVzetPpJGjjYKrnxdKt8++bLXLfUFqd7dX/CcFA7+
 llXwguUF9N8fgj6VEc17fl+XTNcm5JvSPsKU613vEC8ZSgFTEiTH5Hf2Wnb+vBltD/NS
 OyLylj6xkR4Ga7xh146uasg+Lx4lmq0Oe5zunqD31TDixDj2d5ttIFul9rGxFSOuAFp1
 7dMA==
X-Gm-Message-State: AOAM532TFJ0uJ6ZzfzdOad+W1DK9ggb7jrG+99sdYBO+0/dTnicwPB1N
 uEYPw0bEZMIXNVidVRSrNZM=
X-Google-Smtp-Source: ABdhPJySaZYGlENv2qyFf9K7SCA9acModoq5qtLXOSnFpr5ZYYJUffRqri+Bu8C1bsjf+rWbXYMz0A==
X-Received: by 2002:a17:902:8690:: with SMTP id
 g16mr2883173plo.257.1598294189292; 
 Mon, 24 Aug 2020 11:36:29 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id u191sm10235065pgu.56.2020.08.24.11.36.27
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 24 Aug 2020 11:36:28 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH stable 4.9 v3 2/2] arm64: entry: Place an SB sequence
 following an ERET instruction
Date: Mon, 24 Aug 2020 11:36:22 -0700
Message-Id: <1598294182-34012-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598294182-34012-1-git-send-email-f.fainelli@gmail.com>
References: <1598294182-34012-1-git-send-email-f.fainelli@gmail.com>
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
[florian: Adjust hyp-entry.S to account for the label
 added change to hyp/entry.S]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
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
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
