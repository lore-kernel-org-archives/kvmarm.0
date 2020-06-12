Return-Path: <SRS0=cdyA=7Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CCFC433DF
	for <kvmarm@archiver.kernel.org>; Fri, 12 Jun 2020 04:42:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C577D207F7
	for <kvmarm@archiver.kernel.org>; Fri, 12 Jun 2020 04:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p2J2k390"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C577D207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 303054B164;
	Fri, 12 Jun 2020 00:42:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oHf2iPHeVW53; Fri, 12 Jun 2020 00:42:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25CA94B18C;
	Fri, 12 Jun 2020 00:42:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 958714B164
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jun 2020 00:42:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mc4zvmHdB3RD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jun 2020 00:42:34 -0400 (EDT)
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com
 [209.85.216.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 727434B137
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jun 2020 00:42:34 -0400 (EDT)
Received: by mail-pj1-f67.google.com with SMTP id ne5so3146988pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 21:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=tnkNvIy4NyhOcfhzdkEEgf5Q0aBBdpOiKM99Ch2kRHo=;
 b=p2J2k390abBAM4NCbA9yAEM/LrDNElIECJSQNv3Nr8adiQVAS5SzbFY95WgXXxsQIh
 WJkHweRSLgzRw+GhG7AdtIsCCWhBM8XJSKuStAPyg5GzWrP6UfZokkvvSDuCia7LKDe8
 71ujb6m40rMGRbwrRU+cN48oUNWf6r0I2VKCdk3XFkhd7SI1mBjeH2MYM00dZWC5qOCP
 FHXiJVbAQiG/K5Obfn+8x9PhykJbXAlXcTajBOJKJlM1Wemqs6OzfESWAa5E+VfI9uFY
 0/YzlC1zdTftffN4s1iJyIMA8CW79XvwgF/CZ2Um4s/Uxf3elaXGjlbcz4Tn9Hlj3jV0
 d2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=tnkNvIy4NyhOcfhzdkEEgf5Q0aBBdpOiKM99Ch2kRHo=;
 b=kvX9Eyo6Og58UpMq8wLhHKx5ZOfHlet68te3E2Ujj2a+52fU3fivPluBAk3IoFsZg0
 lHZyJEFcOPIlaEGOSut1VxyErDy0gTYWAZNQr64BeqmrtuZ3G7uL/Ntab1yjCBGiuOVo
 188oqQcm9YvgiKxTaxtgP1BclFa+ij+tSwMoTwYO/AlKn9hVp1/hmMS15Qg9g00bJqi8
 Dd65fYRO9sbKQzEQs6Y1c9Yk6By0KRqWlBZDwb7A0Tbzbpiu+IV7992AYpKBmMxJSoij
 dGb61/fNT3uTcHuS4P1cl1J+WtmDhjEB2YT/rDpSKdXn2W0c4UGU5o3rz4YhA4AVUdsS
 te0Q==
X-Gm-Message-State: AOAM5300YCEFPMYjfSTT34OndIZNKk71p2CkAPcNPGxv88Y2rho9cu47
 AwTJF7vxP5iTd/A/wFzTMO4=
X-Google-Smtp-Source: ABdhPJwVfVwWuvBqsmyJQUwzIkKhTVDfAOSa0G75EXUmTNsmKXeQmrkCijvdn4svfC9O7GaAMKn6pA==
X-Received: by 2002:a17:902:c30c:: with SMTP id
 k12mr10389411plx.130.1591936953486; 
 Thu, 11 Jun 2020 21:42:33 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id s9sm4084239pgo.22.2020.06.11.21.42.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Jun 2020 21:42:32 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH stable 4.9] arm64: entry: Place an SB sequence following an
 ERET instruction
Date: Thu, 11 Jun 2020 21:42:18 -0700
Message-Id: <20200612044219.31606-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Cc: Florian Fainelli <f.fainelli@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE KVM" <kvm@vger.kernel.org>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, will@kernel.org,
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
[florian: Adjust hyp-entry.S to account for the label]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Will,

Can you confirm that for 4.9 these are the only places that require
patching? Thank you!

 arch/arm64/kernel/entry.S      | 2 ++
 arch/arm64/kvm/hyp/entry.S     | 1 +
 arch/arm64/kvm/hyp/hyp-entry.S | 4 ++++
 3 files changed, 7 insertions(+)

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
index a360ac6e89e9..bc5c6cdb8538 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,7 @@ ENTRY(__guest_enter)
 
 	// Do not touch any register after this!
 	eret
+	sb
 ENDPROC(__guest_enter)
 
 ENTRY(__guest_exit)
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
