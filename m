Return-Path: <SRS0=xBPq=CG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B17C433E2
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 13:53:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 111E820776
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 13:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6+iYFm3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 111E820776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90E0E4C23E;
	Fri, 28 Aug 2020 09:53:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o5NdIuyGNMzJ; Fri, 28 Aug 2020 09:53:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E2FE4C26A;
	Fri, 28 Aug 2020 09:53:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EDAF4C1EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 09:40:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rTnvmGSVSZmT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Aug 2020 09:40:17 -0400 (EDT)
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com
 [209.85.215.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE9D14C1EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 09:40:17 -0400 (EDT)
Received: by mail-pg1-f196.google.com with SMTP id w186so466984pgb.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 06:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=mgrYv7djjcwPKBcwSuPRa9gDCJlsOXVcLbni56sIc20=;
 b=c6+iYFm39iM5ehnXHgohQOtvPP4Actfi+8FwijsEJLKpNxIw+zaMTTRVW5QuiVMSyK
 +uHvjVMeImm8j1nkGFFvBhdeq+mW57UR0mDt+TMCi9o1VA33Bazp32lsPKVyzGtFRgvU
 obaOn8bzO3sK6syphhgOp58IARzEs3BuHEOFKzvUJAiqUP1hzu9/W/LVB3XtKuVQRAmj
 SiSzWpgz0qVL4WxIFzNdUcaHUpYVzd5lp54gbDLZYbhovS7Bw9bEMWgT7xuWksJGMlTZ
 Om/ECbEvIuuQT/FFgjmIprCoeVjXm42xu3A44N/doEYtETaYrh66S2KBE98cOd48GXJu
 Dbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=mgrYv7djjcwPKBcwSuPRa9gDCJlsOXVcLbni56sIc20=;
 b=mqyTZ87DvLzU/y2iEeFFDkyLcS85i936C35eQn0EKZE0a811gYQXey61zfEA+5PSS7
 bV0/WYPKePC63tRdKbiyiTZX8Bjao6Xym1t4HusAXhfAFUO3q2U4syCKm7ujbJ5dkJar
 ZCthkzCp67LQKY2+FY+2UWt+am4aJlq5sxh0JbSScC7O2MsvNBIK+48ud/DBpsTBqJOK
 /wqT1Vzw76sqjKcLFNAqiRGCaoRmEhZD/1THfJhYZ+kDvrLFvGPAUIX+wYZ9XdobXHb3
 Qv7+aqX6xgH8Crhv4FjrqTvb38arpyakAI2EJHCPD+UtjHbZ29a6cOZZssUxhn+UQ/tg
 H9wA==
X-Gm-Message-State: AOAM531KrYFCCfZX6ky2L4AtNJbXjA/G/+oHVtsHG5Iz13hygwry64G1
 h3eYgTbFj9vBoLorvjhI5Q==
X-Google-Smtp-Source: ABdhPJwZ8ssnw7ayyRREkP1u9OCgsSNGyNfGZJQAc104tTnsMqU4PSmyX9pjBVp3Bj3pBJbEhvD1Kg==
X-Received: by 2002:a63:1d07:: with SMTP id d7mr1349038pgd.106.1598622016873; 
 Fri, 28 Aug 2020 06:40:16 -0700 (PDT)
Received: from mylaptop.redhat.com ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id k1sm1806559pfp.86.2020.08.28.06.40.12
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 28 Aug 2020 06:40:16 -0700 (PDT)
From: Pingfan Liu <kernelfans@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 1/2] arm64/relocate_kernel: remove redundant code
Date: Fri, 28 Aug 2020 21:39:57 +0800
Message-Id: <1598621998-20563-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 2.7.5
X-Mailman-Approved-At: Fri, 28 Aug 2020 09:53:13 -0400
Cc: Kees Cook <keescook@chromium.org>, Geoff Levand <geoff@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Remi Denis-Courmont <remi.denis.courmont@huawei.com>,
 Pingfan Liu <kernelfans@gmail.com>, kvmarm@lists.cs.columbia.edu,
 Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
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

Kernel startup entry point requires disabling MMU and D-cache.

As for kexec-reboot, taking a close look at "msr sctlr_el1, x12" in
__cpu_soft_restart as the following:

-1. booted at EL1
The instruction is enough to disable MMU and I/D cache for
EL1 regime.

-2. booted at EL2, using VHE
Access to SCTLR_EL1 is redirected to SCTLR_EL2 in EL2.  So the instruction
is enough to disable MMU and clear I+C bits for EL2 regime.

-3. booted at EL2, not using VHE
The instruction itself can not affect EL2 regime. But The hyp-stub doesn't
enable the MMU and I/D cache for EL2 regime. And KVM also disable them for EL2
regime when its unloaded, or execute a HVC_SOFT_RESTART call. So when
kexec-reboot, the code in KVM has prepare the requirement.

As a conclusion, disabling MMU and clearing I+C bits in
SYM_CODE_START(arm64_relocate_new_kernel) is redundant, and can be removed

Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Cc: James Morse <james.morse@arm.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Remi Denis-Courmont <remi.denis.courmont@huawei.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/kernel/cpu-reset.S       |  4 ++++
 arch/arm64/kernel/relocate_kernel.S | 12 ------------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/cpu-reset.S b/arch/arm64/kernel/cpu-reset.S
index 4a18055..37721eb 100644
--- a/arch/arm64/kernel/cpu-reset.S
+++ b/arch/arm64/kernel/cpu-reset.S
@@ -35,6 +35,10 @@ SYM_CODE_START(__cpu_soft_restart)
 	mov_q	x13, SCTLR_ELx_FLAGS
 	bic	x12, x12, x13
 	pre_disable_mmu_workaround
+	/*
+	 * either disable EL1&0 translation regime or disable EL2&0 translation
+	 * regime if HCR_EL2.E2H == 1
+	 */
 	msr	sctlr_el1, x12
 	isb
 
diff --git a/arch/arm64/kernel/relocate_kernel.S b/arch/arm64/kernel/relocate_kernel.S
index 542d6ed..84eec95 100644
--- a/arch/arm64/kernel/relocate_kernel.S
+++ b/arch/arm64/kernel/relocate_kernel.S
@@ -36,18 +36,6 @@ SYM_CODE_START(arm64_relocate_new_kernel)
 	mov	x14, xzr			/* x14 = entry ptr */
 	mov	x13, xzr			/* x13 = copy dest */
 
-	/* Clear the sctlr_el2 flags. */
-	mrs	x0, CurrentEL
-	cmp	x0, #CurrentEL_EL2
-	b.ne	1f
-	mrs	x0, sctlr_el2
-	mov_q	x1, SCTLR_ELx_FLAGS
-	bic	x0, x0, x1
-	pre_disable_mmu_workaround
-	msr	sctlr_el2, x0
-	isb
-1:
-
 	/* Check if the new image needs relocation. */
 	tbnz	x16, IND_DONE_BIT, .Ldone
 
-- 
2.7.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
