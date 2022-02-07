Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557AAC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 15:23:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA0249E32;
	Mon,  7 Feb 2022 10:23:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HxCrKncmjyFE; Mon,  7 Feb 2022 10:23:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D2EA49EB5;
	Mon,  7 Feb 2022 10:23:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 018B849EC1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:23:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vq7Qnew8JQ-G for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 10:23:44 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2DC449ECC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:23:44 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D9CD7B815A6;
 Mon,  7 Feb 2022 15:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35851C340F4;
 Mon,  7 Feb 2022 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644247422;
 bh=AWzaL5c8DPTrwsTCJ36oC2PZV7XOSQ8peibKL+aPCWM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=gFYfcDy8VxyheMpvMfRipyxEpHc1T1fa5rroVyOSf3XY2UvFEMNhyXeCUqEGo2snE
 8ob+e35+VtPWnksZY8CfFFsd9IRIC30mE+ChPrgORa4OmTEuiln0daQBh7INvGnUeL
 R209v7e9NjLPwXyYcUVRNTxtEXw0voamilcWQBgc7h329LlFglt+4Qz8EzArndZHwd
 8LGE9dpRlwS88XlqGvdagLso4asjrCQ3Zetk2TLUENuchcZFsyCSOFmqwHacZj3cLJ
 Kj7zX7zfyXSzuiKphMFxtOLSiFMCgjq+l/pn1j1NIjYjdMJPCpbg9OybJF2Mq2o4Bk
 Po25U18nsgQPQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v11 09/40] arm64/sme: Early CPU setup for SME
Date: Mon,  7 Feb 2022 15:20:38 +0000
Message-Id: <20220207152109.197566-10-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3314; h=from:subject;
 bh=AWzaL5c8DPTrwsTCJ36oC2PZV7XOSQ8peibKL+aPCWM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiATjMqDuewMaQ7evrpewaZgROdkgtfGtwQQOcqNY9
 4t+rWRqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYgE4zAAKCRAk1otyXVSH0POJB/
 9mtuR1t7dG4CUltjXkNhZXYxPoMQrWYb2s++elRYo+vGJlGSr5+7WGVqLur1LaV0R/Y1wpsftQs3Dx
 Mx+DioBaQeynew4D++WrbxReMnhEXc9AU+1SHw4gOPU6iWVm7yXmGxdCbIpwltacVGrY9/CS69v2p/
 hBBpxqV8KS2/x0ymqpmWOO9VFuK5/PL9AGd49xcImzQYZtOJgrCeX+xQqozUgkzVQsjWksAZp1ZxYA
 Y50GaQ+zHU1BVYe5L9EqFs+NKSfpnh42jHU6UqgU+zCKNEJYktkjWjQ3g4n/vv2JTqSQVP6UWulsUB
 6pIuZTJw24R0CNu3YuA/GLfssMqHeN
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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

SME requires similar setup to that for SVE: disable traps to EL2 and
make sure that the maximum vector length is available to EL1, for SME we
have two traps - one for SME itself and one for TPIDR2.

In addition since we currently make no active use of priority control
for SCMUs we map all SME priorities lower ELs may configure to 0, the
architecture specified minimum priority, to ensure that nothing we
manage is able to configure itself to consume excessive resources.  This
will need to be revisited should there be a need to manage SME
priorities at runtime.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 64 ++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 3198acb2aad8..31f1a69c9dd2 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -143,6 +143,50 @@
 .Lskip_sve_\@:
 .endm
 
+/* SME register access and priority mapping */
+.macro __init_el2_nvhe_sme
+	mrs	x1, id_aa64pfr1_el1
+	ubfx	x1, x1, #ID_AA64PFR1_SME_SHIFT, #4
+	cbz	x1, .Lskip_sme_\@
+
+	bic	x0, x0, #CPTR_EL2_TSM		// Also disable SME traps
+	msr	cptr_el2, x0			// Disable copro. traps to EL2
+	isb
+
+	mrs	x1, sctlr_el2
+	orr	x1, x1, #SCTLR_ELx_ENTP2	// Disable TPIDR2 traps
+	msr	sctlr_el2, x1
+	isb
+
+	mov	x1, #0				// SMCR controls
+
+	mrs_s	x2, SYS_ID_AA64SMFR0_EL1
+	ubfx	x2, x2, #ID_AA64SMFR0_FA64_SHIFT, #1 // Full FP in SM?
+	cbz	x2, .Lskip_sme_fa64_\@
+
+	orr	x1, x1, SMCR_ELx_FA64_MASK
+.Lskip_sme_fa64_\@:
+
+	orr	x1, x1, #SMCR_ELx_LEN_MASK	// Enable full SME vector
+	msr_s	SYS_SMCR_EL2, x1		// length for EL1.
+
+	mrs_s	x1, SYS_SMIDR_EL1		// Priority mapping supported?
+	ubfx    x1, x1, #SYS_SMIDR_EL1_SMPS_SHIFT, #1
+	cbz     x1, .Lskip_sme_\@
+
+	msr_s	SYS_SMPRIMAP_EL2, xzr		// Make all priorities equal
+
+	mrs	x1, id_aa64mmfr1_el1		// HCRX_EL2 present?
+	ubfx	x1, x1, #ID_AA64MMFR1_HCX_SHIFT, #4
+	cbz	x1, .Lskip_sme_\@
+
+	mrs_s	x1, SYS_HCRX_EL2
+	orr	x1, x1, #HCRX_EL2_SMPME_MASK	// Enable priority mapping
+	msr_s	SYS_HCRX_EL2, x1
+
+.Lskip_sme_\@:
+.endm
+
 /* Disable any fine grained traps */
 .macro __init_el2_fgt
 	mrs	x1, id_aa64mmfr0_el1
@@ -153,15 +197,26 @@
 	mrs	x1, id_aa64dfr0_el1
 	ubfx	x1, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
 	cmp	x1, #3
-	b.lt	.Lset_fgt_\@
+	b.lt	.Lset_debug_fgt_\@
 	/* Disable PMSNEVFR_EL1 read and write traps */
 	orr	x0, x0, #(1 << 62)
 
-.Lset_fgt_\@:
+.Lset_debug_fgt_\@:
 	msr_s	SYS_HDFGRTR_EL2, x0
 	msr_s	SYS_HDFGWTR_EL2, x0
-	msr_s	SYS_HFGRTR_EL2, xzr
-	msr_s	SYS_HFGWTR_EL2, xzr
+
+	mov	x0, xzr
+	mrs	x1, id_aa64pfr1_el1
+	ubfx	x1, x1, #ID_AA64PFR1_SME_SHIFT, #4
+	cbz	x1, .Lset_fgt_\@
+
+	/* Disable nVHE traps of TPIDR2 and SMPRI */
+	orr	x0, x0, #HFGxTR_EL2_nSMPRI_EL1_MASK
+	orr	x0, x0, #HFGxTR_EL2_nTPIDR2_EL0_MASK
+
+.Lset_fgt_\@:
+	msr_s	SYS_HFGRTR_EL2, x0
+	msr_s	SYS_HFGWTR_EL2, x0
 	msr_s	SYS_HFGITR_EL2, xzr
 
 	mrs	x1, id_aa64pfr0_el1		// AMU traps UNDEF without AMU
@@ -196,6 +251,7 @@
 	__init_el2_nvhe_idregs
 	__init_el2_nvhe_cptr
 	__init_el2_nvhe_sve
+	__init_el2_nvhe_sme
 	__init_el2_fgt
 	__init_el2_nvhe_prepare_eret
 .endm
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
