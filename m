Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793313456;
	b=U88lRafVHgy/9mhHe46TWFXzvMTZ14Vsfah22IeCoDZPDHuk0eRvLlefQslpu0EFsZ++
	 a4ObKc3oTHQD71Wz8FtvL9N3vgReXMElJReG7191NkHjafm9LzwIri9gxKsRqZYpzAT/J
	 e4CMWQsgEqzI9NztCoKXqhHUPLVp5yV/JkQ4pa8uz1ZWUGRtcATWMYnis0ILijDQBbbN7
	 KkIcLbUH3cVfpDpW66nMLJWakSUX/oxnA7N9K6bypASCU/b7Ud9ihyQJ1a8joz+e/K2z5
	 waLLBgRqyH0mM8sdDEcG8CnbHM2/bxYaikHA7IrhOnNjNEfd2q5JUrDMVVm6qi2aVCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793313456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7uWpbUXnLRh5frYocV9lH6F6FtTXizhgGkJx6V/tifM=;
	b=bhV2mSTdVkXfy+Jr9TEue/k2YdXI/OtK4WoXH4XB4XFq9BDJxxFVNh/KATU2Js7nFMCO
	 pt/EHjn5Tzax9VFBiwjuYMAAfbIHu+njcnKX71+5VVrT5sZq2QDJSj50PU1F0PQjwkke5
	 Rq2fE+t2qcywecKfI3aKRJlK7aKYhLRPSRdtmg5DPhZinlpbmBLE7j6K9IyUP5tKNteYF
	 ds+aBjTJFAttpgReNdZp59eoja8vfZxPbBsHP4WoioM0Bal+4arvFHaex1o64uaVxbKG2
	 7JX69KtBQHKxtEpSpHedQV+Bi7oz381LjKY09aDojrxgwQu9h4C09XH6WoOi7RFpUYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlXdMtJO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95E7606A330
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 22:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlXdMtJO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBC31F031EF;
	Thu, 29 Oct 2026 22:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793313455;
	bh=7uWpbUXnLRh5frYocV9lH6F6FtTXizhgGkJx6V/tifM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlXdMtJOlsxjh9H04IQtb5Xzn1UjKCgpvaXiVDgYCI2K2cS2bsBQRpN8IgqN4wm6d
	 8qJvyCpokYMh5g/wK12NF2aginIWkmkWB4Hjp1T6szjayyPBRqMPqr1pEfXJy3q+6S
	 mMTPbF37eYxJTqskts7vOZQzc8VOW4qFW5lnyOmzXN18hZH8a/m3bPzn/qEmtUl+n+
	 HnfKn7CIXZN315jHU3BiSTf5gcISEBb3gpB6sAPiP/ooI15PfyhniSb+N1oEjlMMS7
	 63J/Ks1CzO+su0LQ88bA/VEXsSdn6QCDq8fwV8Ruvp7VAtjfZQWamAW0fWmULWRCaN
	 Vx9oe3DZn4E7g==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 2/5] arm64: sysreg: Add TCR_EL2 to sysreg infrastructure
Date: Thu, 29 Oct 2026 15:37:29 -0700
Message-ID: <20261029223732.103785-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029223732.103785-1-oupton@kernel.org>
References: <20261029223732.103785-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wei-Lin Chang <weilin.chang@arm.com>

Convert TCR_EL2 to the sysreg infrastructure with data extracted from
Registers.json of the BSD licenced AARCHMRS
(AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).

There are two formats of TCR_EL2 based on whether the effective value of
HCR_EL2.E2H is 0 or 1. For the E2H == 1 case, prefix the macros with
"VHE_". For the E2H == 0 case, the macros are left unprefixed.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h |  13 ----
 arch/arm64/include/asm/sysreg.h  |   1 -
 arch/arm64/tools/sysreg          | 125 +++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index ba0062849be9..3e1c9e31028e 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -45,19 +45,6 @@
 #define MPAMHCR_HOST_FLAGS	0
 
 /* TCR_EL2 Registers bits */
-#define TCR_EL2_DS		(1UL << 32)
-#define TCR_EL2_RES1		((1U << 31) | (1 << 23))
-#define TCR_EL2_HPD		(1 << 24)
-#define TCR_EL2_HA		(1 << 21)
-#define TCR_EL2_TBI		(1 << 20)
-#define TCR_EL2_PS_SHIFT	16
-#define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
-#define TCR_EL2_PS_40B		(2 << TCR_EL2_PS_SHIFT)
-#define TCR_EL2_TG0_MASK	TCR_TG0_MASK
-#define TCR_EL2_SH0_MASK	TCR_SH0_MASK
-#define TCR_EL2_ORGN0_MASK	TCR_ORGN0_MASK
-#define TCR_EL2_IRGN0_MASK	TCR_IRGN0_MASK
-#define TCR_EL2_T0SZ_MASK	0x3f
 #define TCR_EL2_MASK	(TCR_EL2_TG0_MASK | TCR_EL2_SH0_MASK | \
 			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index aa65603455a2..fee89cd667d9 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -519,7 +519,6 @@
 
 #define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
 #define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
-#define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 893b5f9df575..bbe32dee55f9 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -5612,6 +5612,131 @@ Res0    6
 Field   5:0     T0SZ
 EndSysreg
 
+Sysreg	TCR_EL2		3	4	2	0	2
+Prefix	VHE
+Res0	63:62
+Field	61	MTX1
+Field	60	MTX0
+Field	59	DS
+Field	58	TCMA1
+Field	57	TCMA0
+Field	56	E0PD1
+Field	55	E0PD0
+Field	54	NFD1
+Field	53	NFD0
+Field	52	TBID1
+Field	51	TBID0
+Field	50	HWU162
+Field	49	HWU161
+Field	48	HWU160
+Field	47	HWU159
+Field	46	HWU062
+Field	45	HWU061
+Field	44	HWU060
+Field	43	HWU059
+Field	42	HPD1
+Field	41	HPD0
+Field	40	HD
+Field	39	HA
+Field	38	TBI1
+Field	37	TBI0
+Field	36	AS
+Res0	35
+Field	34:32	IPS
+Enum	31:30	TG1
+	0b01	16K
+	0b10	4K
+	0b11	64K
+EndEnum
+Enum	29:28	SH1
+	0b00	NONE
+	0b10	OUTER
+	0b11	INNER
+EndEnum
+Enum	27:26	ORGN1
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+Enum	25:24	IRGN1
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+Field	23	EPD1
+Field	22	A1
+Field	21:16	T1SZ
+Enum	15:14	TG0
+	0b00	4K
+	0b01	64K
+	0b10	16K
+EndEnum
+Enum	13:12	SH0
+	0b00	NONE
+	0b10	OUTER
+	0b11	INNER
+EndEnum
+Enum	11:10	ORGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+Enum	9:8	IRGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+Field	7	EPD0
+Res0	6
+Field	5:0	T0SZ
+EndPrefix
+Res0	63:34
+Field	33	MTX
+Field	32	DS
+Res1	31
+Field	30	TCMA
+Field	29	TBID
+Field	28	HWU62
+Field	27	HWU61
+Field	26	HWU60
+Field	25	HWU59
+Field	24	HPD
+Res1	23
+Field	22	HD
+Field	21	HA
+Field	20	TBI
+Res0	19
+Field	18:16	PS
+Enum	15:14	TG0
+	0b00	4K
+	0b01	64K
+	0b10	16K
+EndEnum
+Enum	13:12	SH0
+	0b00	NONE
+	0b10	OUTER
+	0b11	INNER
+EndEnum
+Enum	11:10	ORGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+Enum	9:8	IRGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+Res0	7:6
+Field	5:0	T0SZ
+EndSysreg
+
 Sysreg	TCR_EL12        3	5	2	0	2
 Mapping	TCR_EL1
 EndSysreg
-- 
2.47.3

