Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF9A269B1C
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 04:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493102; cv=none; b=AosWfRh42rGHKqfbHaj57BdJtivVkq6W8FdPsmgKKkm+CTwdjdtpvVW5aLlaf5fb0XqrDzhGbpuYKB3AIJzhsYIyYiJIM3ma97IEu3549gCUFNrSEvpJsHV90bo2mY+QCZ58raRjaTdPzbbU3oocKXLEigPb329gYjSyHoHZvY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493102; c=relaxed/simple;
	bh=ZKEYCR0gDkrKbo3AZPVkiwGPIxrdNv31xbNb+X9KSok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g0X+K3i1lUurdUDvR40JvLykLO14Nupj/Ah4Q2U6RjnUh/1fnHScmnf+xRbxAiI7MDYTEewVlmCYKP81PWsANn9tVGHZQImbx8sTFtmZ4ahlM7YC3X4Sf6Rpo/Rl4EQitj3hO5oiUVKUmUkEgo3CwcmtExWa4tTesGa0bOmoBMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E755D1762;
	Sun, 17 Aug 2025 21:58:11 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 45EDE3F58B;
	Sun, 17 Aug 2025 21:58:17 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] arm64/sysreg: Add TCR_EL2 register
Date: Mon, 18 Aug 2025 10:27:58 +0530
Message-Id: <20250818045759.672408-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250818045759.672408-1-anshuman.khandual@arm.com>
References: <20250818045759.672408-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add TCR_EL2 register fields as per the latest ARM ARM DDI 0487 7.B in tools
sysreg format and drop all the existing redundant macros from the header
(arch/arm64/include/asm/kvm_arm.h). While here also drop an explicit sysreg
definction SYS_TCR_EL2 from sysreg.h header.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 13 ----------
 arch/arm64/include/asm/sysreg.h  |  1 -
 arch/arm64/tools/sysreg          | 44 ++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 560d9cb63413..8994cddef182 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -107,19 +107,6 @@
 
 #define MPAMHCR_HOST_FLAGS	0
 
-/* TCR_EL2 Registers bits */
-#define TCR_EL2_DS		(1UL << 32)
-#define TCR_EL2_RES1		((1U << 31) | (1 << 23))
-#define TCR_EL2_HPD		(1 << 24)
-#define TCR_EL2_TBI		(1 << 20)
-#define TCR_EL2_PS_SHIFT	16
-#define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
-#define TCR_EL2_PS_40B		(2 << TCR_EL2_PS_SHIFT)
-#define TCR_EL2_TG0_MASK	TCR_EL1_TG0_MASK
-#define TCR_EL2_SH0_MASK	TCR_EL1_SH0_MASK
-#define TCR_EL2_ORGN0_MASK	TCR_EL1_ORGN0_MASK
-#define TCR_EL2_IRGN0_MASK	TCR_EL1_IRGN0_MASK
-#define TCR_EL2_T0SZ_MASK	0x3f
 #define TCR_EL2_MASK	(TCR_EL2_TG0_MASK | TCR_EL2_SH0_MASK | \
 			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ad5c901af229..112d5d0acb50 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -523,7 +523,6 @@
 
 #define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
 #define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
-#define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 4bdae8bb11dc..d2b40105eb41 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4812,6 +4812,50 @@ Sysreg	TCR_EL12        3	5	2	0	2
 Mapping	TCR_EL1
 EndSysreg
 
+Sysreg	TCR_EL2        3	4	2	0	2
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
+Field   18:16	PS
+UnsignedEnum	15:14	TG0
+	0b00	4K
+	0b01	64K
+	0b10	16K
+EndEnum
+UnsignedEnum	13:12	SH0
+	0b00	NONE
+	0b10	OUTER
+	0b11	INNER
+EndEnum
+UnsignedEnum	11:10	ORGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+UnsignedEnum	9:8	IRGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+Res0    7:6
+Field   5:0	T0SZ
+EndSysreg
+
 Sysreg	TCRALIAS_EL1    3	0	2	7	6
 Mapping	TCR_EL1
 EndSysreg
-- 
2.25.1

