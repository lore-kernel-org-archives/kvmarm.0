Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AEA6485953
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 22:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992438; cv=none; b=OnbJLxK4IhdCSJDnVRGJ5V1TipT4JJM/5U7Wx9zNT1vc2TajeTbU3cZkuT1+WqCvOy/owqUKn092+THR33u2N9Ej5W5QmlDH9PmVc0YcRJhlg7IIt3RzbtKDFx/ww9SCbzXWHbPUYrEjrML31FguX7ba13sbQo4mC41xScJupTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992438; c=relaxed/simple;
	bh=qnAoJ45T08036wvpX/WkfEJH+QYHYhUDdjJ6HbWI1s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+TSFLDYcDaokZZiJUzeQs4AsL03Wia7ovP+JJtgMWl15UBLjrDCEQz8AJencyvGoHP1MwETM4o4bkE6s+zNMuczjbYTeI5e8eJrlMtgeODxg1mU8raz2hUO4b3szbBG/4BBEEjrcDIwkGoZ7+Cf1b3IIT7m4ih53yiUbTMqqbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tjwKCZOd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tjwKCZOd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6F51169C;
	Wed,  9 Sep 2026 15:20:32 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DD4D3F7D8;
	Wed,  9 Sep 2026 15:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788992436; bh=qnAoJ45T08036wvpX/WkfEJH+QYHYhUDdjJ6HbWI1s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjwKCZOdoLo5AyBtHdhlAaQXe1F1jYJkOapBkzGgpkDFUTezCrN8D6jr0djz2qShE
	 caoUJdLBT73B6ZF9a/5VVuCdHO/6lEvvl+IWbrjEwTMDTuETKRJUkUS5BHHJUPw48b
	 1OuNfpPEvhJRRnCJ0/5wDQScBaWky/PF3X5+Z+Iw=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v1 2/3] arm64: sysreg: Add TCR_EL2 to sysreg infrastructure
Date: Wed,  9 Sep 2026 23:20:14 +0100
Message-ID: <20260909222015.3046432-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260909222015.3046432-1-weilin.chang@arm.com>
References: <20260909222015.3046432-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert TCR_EL2 to the sysreg infrastructure with data extracted from
Registers.json of the BSD licenced AARCHMRS
(AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).

There are two formats of TCR_EL2 based on whether the effective value of
HCR_EL2.E2H is 0 or 1. For the E2H == 1 case, prefix the macros with
"VHE_". For the E2H == 0 case, the macros are left unprefixed.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |  13 ----
 arch/arm64/include/asm/sysreg.h  |   1 -
 arch/arm64/tools/sysreg          | 125 +++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4bfbd827c5aa..690c13d0b068 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -108,19 +108,6 @@
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
index 7aa08d59d494..3499e5fab39e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -514,7 +514,6 @@
 
 #define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
 #define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
-#define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 94bf065c8ac7..8d89f34580ba 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -5559,6 +5559,131 @@ Res0    6
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
2.43.0

