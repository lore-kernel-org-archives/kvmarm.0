Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F7BEDA
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 10:38:07 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id z2-20020a1709060be200b0088b579825f9so4514690ejg.18
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 02:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K0HqL97JwBrjBXTVTitohvXvgoY0lt+wZC5NHuty9hs=;
        b=F1IZEKRs3mKSdDu2GkUO3JAx8xog6bGbY5YEQdnkELQ+JYavswPHRCFgSSDntxzr3z
         1ueatA5A8Nd6ttFz8/7DGcnIgGIA7eriaQMhruHktvtlty43CtfRH/TqUON4d1PizEz4
         5pnXmqT5cDiTgFLZlGg3H5F7dFNcbrF0Rv0q/6/FWivipIr+E0nIGgy0MMby9nkNO+Jn
         0aJNuSO5zg3GuJodOaC0PpLm9ZvpsjR5waMWtPTydTn5b8teWS2HMMazQhXcMPdEAIbM
         rPcujNRHKq5fLArt7vH/HRRYlBO+M3SqbEBc1se50v6BVmy7F4DyBKMn1cP9vjuoMnTq
         5kAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K0HqL97JwBrjBXTVTitohvXvgoY0lt+wZC5NHuty9hs=;
        b=TpUlTqBtANW+naLAvyf/JWWQxZpaf1zCDjhzFIlO/5TVV+dFwpO771snakawO+gxfk
         TbqaLrDH6OKQ6/C1dGz0V2VwVpVQoSD35c/ah+0JKtUA9i1J4+u4pVHYkHIjJTJO+eQg
         vXpGU/uN9DeDUYGsnhF4Ssj7xSBbEoV4CkHDi660llSLJQumhHcUVFXctJizM7Q9saDO
         1j5Rvjv4+DMXh+YT6ruIKtKOgOjDNvlaetwI7pJJNMRjrYEX46ztnIeXFtFThJDECuyP
         IQnGTyNhc4AJixfX7f5xyMBFqVmNyuOr/1ks64tSDD7g2Ac8r+dgUb6T+afEzt6yc5WX
         1PAA==
X-Gm-Message-State: AO0yUKWMY0K1c1H2noX7cgorO9NJrsElBAV09OLyr5nHyctNdCJJRa0j
	xHB3EYk8Yh6nK2lEttE+0A+wABc7bu+s
X-Google-Smtp-Source: AK7set+sTpw/Mpdd613/Euhkdxc/bF7dUv+Wu8UjWoay1R8WXhYp3L5dRr06+SA/iTlYnzS3X5WLEMdWGBw9
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:907:2154:b0:88e:16e2:3b7f with SMTP id
 rk20-20020a170907215400b0088e16e23b7fmr275893ejb.300.1675247885947; Wed, 01
 Feb 2023 02:38:05 -0800 (PST)
Date: Wed,  1 Feb 2023 10:37:52 +0000
In-Reply-To: <20230201103755.1398086-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230201103755.1398086-1-qperret@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201103755.1398086-3-qperret@google.com>
Subject: [PATCH 2/4] KVM: arm64: Introduce finalise_el2_state macro
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kernel-team@android.com, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Factor out the first half of the finalise_el2 function into a macro to
allow its reuse from the nVHE PSCI relay code. While at it, make the
register allocation parametric for the check_override macros as they are
now more widely exposed.

No functional changes intended.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/el2_setup.h | 78 +++++++++++++++++++++++++++++
 arch/arm64/kernel/hyp-stub.S       | 79 +-----------------------------
 2 files changed, 80 insertions(+), 77 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 668569adf4d3..fb7d04b81033 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -196,4 +196,82 @@
 	__init_el2_nvhe_prepare_eret
 .endm
 
+// This will clobber tmp1 and tmp2, and expect tmp1 to contain
+// the id register value as read from the HW
+.macro __check_override idreg, fld, width, pass, fail, tmp1, tmp2
+	ubfx	\tmp1, \tmp1, #\fld, #\width
+	cbz	\tmp1, \fail
+
+	adr_l	\tmp1, \idreg\()_override
+	ldr	\tmp2, [\tmp1, FTR_OVR_VAL_OFFSET]
+	ldr	\tmp1, [\tmp1, FTR_OVR_MASK_OFFSET]
+	ubfx	\tmp2, \tmp2, #\fld, #\width
+	ubfx	\tmp1, \tmp1, #\fld, #\width
+	cmp	\tmp1, xzr
+	and	\tmp2, \tmp2, \tmp1
+	csinv	\tmp2, \tmp2, xzr, ne
+	cbnz	\tmp2, \pass
+	b	\fail
+.endm
+
+// This will clobber tmp1 and tmp2
+.macro check_override idreg, fld, pass, fail, tmp1, tmp2
+	mrs	\tmp1, \idreg\()_el1
+	__check_override \idreg \fld 4 \pass \fail \tmp1 \tmp2
+.endm
+
+.macro finalise_el2_state
+	check_override id_aa64pfr0, ID_AA64PFR0_EL1_SVE_SHIFT, .Linit_sve_\@, .Lskip_sve_\@, x1, x2
+
+.Linit_sve_\@:	/* SVE register access */
+	mrs	x0, cptr_el2			// Disable SVE traps
+	bic	x0, x0, #CPTR_EL2_TZ
+	msr	cptr_el2, x0
+	isb
+	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
+	msr_s	SYS_ZCR_EL2, x1			// length for EL1.
+
+.Lskip_sve_\@:
+	check_override id_aa64pfr1, ID_AA64PFR1_EL1_SME_SHIFT, .Linit_sme_\@, .Lskip_sme_\@, x1, x2
+
+.Linit_sme_\@:	/* SME register access and priority mapping */
+	mrs	x0, cptr_el2			// Disable SME traps
+	bic	x0, x0, #CPTR_EL2_TSM
+	msr	cptr_el2, x0
+	isb
+
+	mrs	x1, sctlr_el2
+	orr	x1, x1, #SCTLR_ELx_ENTP2	// Disable TPIDR2 traps
+	msr	sctlr_el2, x1
+	isb
+
+	mov	x0, #0				// SMCR controls
+
+	// Full FP in SM?
+	mrs_s	x1, SYS_ID_AA64SMFR0_EL1
+	__check_override id_aa64smfr0, ID_AA64SMFR0_EL1_FA64_SHIFT, 1, .Linit_sme_fa64_\@, .Lskip_sme_fa64_\@, x1, x2
+
+.Linit_sme_fa64_\@:
+	orr	x0, x0, SMCR_ELx_FA64_MASK
+.Lskip_sme_fa64_\@:
+
+	orr	x0, x0, #SMCR_ELx_LEN_MASK	// Enable full SME vector
+	msr_s	SYS_SMCR_EL2, x0		// length for EL1.
+
+	mrs_s	x1, SYS_SMIDR_EL1		// Priority mapping supported?
+	ubfx    x1, x1, #SMIDR_EL1_SMPS_SHIFT, #1
+	cbz     x1, .Lskip_sme_\@
+
+	msr_s	SYS_SMPRIMAP_EL2, xzr		// Make all priorities equal
+
+	mrs	x1, id_aa64mmfr1_el1		// HCRX_EL2 present?
+	ubfx	x1, x1, #ID_AA64MMFR1_EL1_HCX_SHIFT, #4
+	cbz	x1, .Lskip_sme_\@
+
+	mrs_s	x1, SYS_HCRX_EL2
+	orr	x1, x1, #HCRX_EL2_SMPME_MASK	// Enable priority mapping
+	msr_s	SYS_HCRX_EL2, x1
+.Lskip_sme_\@:
+.endm
+
 #endif /* __ARM_KVM_INIT_H__ */
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 2ee18c860f2a..9439240c3fcf 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -16,30 +16,6 @@
 #include <asm/ptrace.h>
 #include <asm/virt.h>
 
-// Warning, hardcoded register allocation
-// This will clobber x1 and x2, and expect x1 to contain
-// the id register value as read from the HW
-.macro __check_override idreg, fld, width, pass, fail
-	ubfx	x1, x1, #\fld, #\width
-	cbz	x1, \fail
-
-	adr_l	x1, \idreg\()_override
-	ldr	x2, [x1, FTR_OVR_VAL_OFFSET]
-	ldr	x1, [x1, FTR_OVR_MASK_OFFSET]
-	ubfx	x2, x2, #\fld, #\width
-	ubfx	x1, x1, #\fld, #\width
-	cmp	x1, xzr
-	and	x2, x2, x1
-	csinv	x2, x2, xzr, ne
-	cbnz	x2, \pass
-	b	\fail
-.endm
-
-.macro check_override idreg, fld, pass, fail
-	mrs	x1, \idreg\()_el1
-	__check_override \idreg \fld 4 \pass \fail
-.endm
-
 	.text
 	.pushsection	.hyp.text, "ax"
 
@@ -98,58 +74,7 @@ SYM_CODE_START_LOCAL(elx_sync)
 SYM_CODE_END(elx_sync)
 
 SYM_CODE_START_LOCAL(__finalise_el2)
-	check_override id_aa64pfr0 ID_AA64PFR0_EL1_SVE_SHIFT .Linit_sve .Lskip_sve
-
-.Linit_sve:	/* SVE register access */
-	mrs	x0, cptr_el2			// Disable SVE traps
-	bic	x0, x0, #CPTR_EL2_TZ
-	msr	cptr_el2, x0
-	isb
-	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
-	msr_s	SYS_ZCR_EL2, x1			// length for EL1.
-
-.Lskip_sve:
-	check_override id_aa64pfr1 ID_AA64PFR1_EL1_SME_SHIFT .Linit_sme .Lskip_sme
-
-.Linit_sme:	/* SME register access and priority mapping */
-	mrs	x0, cptr_el2			// Disable SME traps
-	bic	x0, x0, #CPTR_EL2_TSM
-	msr	cptr_el2, x0
-	isb
-
-	mrs	x1, sctlr_el2
-	orr	x1, x1, #SCTLR_ELx_ENTP2	// Disable TPIDR2 traps
-	msr	sctlr_el2, x1
-	isb
-
-	mov	x0, #0				// SMCR controls
-
-	// Full FP in SM?
-	mrs_s	x1, SYS_ID_AA64SMFR0_EL1
-	__check_override id_aa64smfr0 ID_AA64SMFR0_EL1_FA64_SHIFT 1 .Linit_sme_fa64 .Lskip_sme_fa64
-
-.Linit_sme_fa64:
-	orr	x0, x0, SMCR_ELx_FA64_MASK
-.Lskip_sme_fa64:
-
-	orr	x0, x0, #SMCR_ELx_LEN_MASK	// Enable full SME vector
-	msr_s	SYS_SMCR_EL2, x0		// length for EL1.
-
-	mrs_s	x1, SYS_SMIDR_EL1		// Priority mapping supported?
-	ubfx    x1, x1, #SMIDR_EL1_SMPS_SHIFT, #1
-	cbz     x1, .Lskip_sme
-
-	msr_s	SYS_SMPRIMAP_EL2, xzr		// Make all priorities equal
-
-	mrs	x1, id_aa64mmfr1_el1		// HCRX_EL2 present?
-	ubfx	x1, x1, #ID_AA64MMFR1_EL1_HCX_SHIFT, #4
-	cbz	x1, .Lskip_sme
-
-	mrs_s	x1, SYS_HCRX_EL2
-	orr	x1, x1, #HCRX_EL2_SMPME_MASK	// Enable priority mapping
-	msr_s	SYS_HCRX_EL2, x1
-
-.Lskip_sme:
+	finalise_el2_state
 
 	// nVHE? No way! Give me the real thing!
 	// Sanity check: MMU *must* be off
@@ -157,7 +82,7 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 	tbnz	x1, #0, 1f
 
 	// Needs to be VHE capable, obviously
-	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 2f 1f
+	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 2f 1f x1 x2
 
 1:	mov_q	x0, HVC_STUB_ERR
 	eret
-- 
2.39.1.456.gfc5497dd1b-goog

