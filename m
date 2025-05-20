Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B7525F995;
	Tue, 20 May 2025 22:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747780087; cv=none; b=E6DRx+pxeUm8bigfw/qpxw5K5ZTQJk0KEYZ0vMZ5LZ+pec4Ml5eZfSG2yM7oVGEZac3ErReA4A5JF7WaKeNW0TFEenZHFtC4EnPMx1Xm6fJsNRyrfjUFhAjNmNWbHW1OHQzPeDaR+3JHhHR1rOwcBp9q9cBBUPclcwfbsfgr46w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747780087; c=relaxed/simple;
	bh=o5JT6INm1YJt6H3uhHPe/BzPtiJx888IL/BjMdypQas=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q0rCXrqpMDHNO4+Mqnaun0lHBQhxkRW0qX1dlpt0TbnK+kASP5O5EBNifW+AI6w6rO9AXxmAyeAZ6h2xO25syfZ8r3ALhkendlrw26Df9oOT9bKXaS1FfEKY03H5KnOBEKl8kEW1RLjwaIH9YV4W9RpbfmTu5eG6yt5SkDY/ZYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmaTrA1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmaTrA1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53E0C4CEED;
	Tue, 20 May 2025 22:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747780087;
	bh=o5JT6INm1YJt6H3uhHPe/BzPtiJx888IL/BjMdypQas=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FmaTrA1WV3rqX3ad+OsCOFjU9NuCG2uzgie3yo1i9qD02Z/Rotr/paa3AEqHjB/bQ
	 COoEyszvRjhPmwe3ct3VP5Vpem6GjLd1oFTnDVkB4atXNo321w+OJyJd1OiHbSbiM0
	 7MD3CzcpIYS/CC6Ubavg/oI4SbXGIztitQaU6k9SZ5YAPyM2VVSu7wCJG+zIRVCN81
	 QnYaH3GEZ3RTRJywNIUR/mhnbPhDr8D6Zhk3LB3g5jWVneMSjDVBLxpF2LncWzBQ3D
	 ZAbtdfvJj7YxrtpmdXvyq1mcWnaQgybwIgtjHRVzxpKTckDn2kw8XZnLR6x7/dgfZj
	 vvEV6vuyYlpvg==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 20 May 2025 17:27:36 -0500
Subject: [PATCH v22 1/5] arm64/sysreg: Add BRBE registers and fields
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250520-arm-brbe-v19-v22-1-c1ddde38e7f8@kernel.org>
References: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
In-Reply-To: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev

From: Anshuman Khandual <anshuman.khandual@arm.com>

This patch adds definitions related to the Branch Record Buffer Extension
(BRBE) as per ARM DDI 0487K.a. These will be used by KVM and a BRBE driver
in subsequent patches.

Some existing BRBE definitions in asm/sysreg.h are replaced with equivalent
generated definitions.

Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: James Clark <james.clark@linaro.org>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
---
v19:
- split BRBINF.CC field into mantissa and exponent
---
 arch/arm64/include/asm/sysreg.h |  17 ++----
 arch/arm64/tools/sysreg         | 132 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2639d3633073..67e96494749e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -198,16 +198,8 @@
 #define SYS_DBGVCR32_EL2		sys_reg(2, 4, 0, 7, 0)
 
 #define SYS_BRBINF_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 0))
-#define SYS_BRBINFINJ_EL1		sys_reg(2, 1, 9, 1, 0)
 #define SYS_BRBSRC_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 1))
-#define SYS_BRBSRCINJ_EL1		sys_reg(2, 1, 9, 1, 1)
 #define SYS_BRBTGT_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 2))
-#define SYS_BRBTGTINJ_EL1		sys_reg(2, 1, 9, 1, 2)
-#define SYS_BRBTS_EL1			sys_reg(2, 1, 9, 0, 2)
-
-#define SYS_BRBCR_EL1			sys_reg(2, 1, 9, 0, 0)
-#define SYS_BRBFCR_EL1			sys_reg(2, 1, 9, 0, 1)
-#define SYS_BRBIDR0_EL1			sys_reg(2, 1, 9, 2, 0)
 
 #define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
 #define SYS_TRCACATR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (2 | (m >> 3)))
@@ -273,8 +265,6 @@
 /* ETM */
 #define SYS_TRCOSLAR			sys_reg(2, 1, 1, 0, 4)
 
-#define SYS_BRBCR_EL2			sys_reg(2, 4, 9, 0, 0)
-
 #define SYS_MIDR_EL1			sys_reg(3, 0, 0, 0, 0)
 #define SYS_MPIDR_EL1			sys_reg(3, 0, 0, 0, 5)
 #define SYS_REVIDR_EL1			sys_reg(3, 0, 0, 0, 6)
@@ -607,7 +597,6 @@
 #define SYS_CNTHV_CVAL_EL2		sys_reg(3, 4, 14, 3, 2)
 
 /* VHE encodings for architectural EL0/1 system registers */
-#define SYS_BRBCR_EL12			sys_reg(2, 5, 9, 0, 0)
 #define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
 #define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
 #define SYS_SCTLR2_EL12			sys_reg(3, 5, 1, 0, 3)
@@ -818,6 +807,12 @@
 #define OP_COSP_RCTX			sys_insn(1, 3, 7, 3, 6)
 #define OP_CPP_RCTX			sys_insn(1, 3, 7, 3, 7)
 
+/*
+ * BRBE Instructions
+ */
+#define BRB_IALL_INSN	__emit_inst(0xd5000000 | OP_BRB_IALL | (0x1f))
+#define BRB_INJ_INSN	__emit_inst(0xd5000000 | OP_BRB_INJ  | (0x1f))
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_ENTP2	(BIT(60))
 #define SCTLR_ELx_DSSBS	(BIT(44))
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index f9476848a2ed..ec74419dc1ae 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1038,6 +1038,138 @@ UnsignedEnum	3:0	MTEPERM
 EndEnum
 EndSysreg
 
+
+SysregFields BRBINFx_EL1
+Res0	63:47
+Field	46	CCU
+Field	45:40	CC_EXP
+Field	39:32	CC_MANT
+Res0	31:18
+Field	17	LASTFAILED
+Field	16	T
+Res0	15:14
+Enum	13:8		TYPE
+	0b000000	DIRECT_UNCOND
+	0b000001	INDIRECT
+	0b000010	DIRECT_LINK
+	0b000011	INDIRECT_LINK
+	0b000101	RET
+	0b000111	ERET
+	0b001000	DIRECT_COND
+	0b100001	DEBUG_HALT
+	0b100010	CALL
+	0b100011	TRAP
+	0b100100	SERROR
+	0b100110	INSN_DEBUG
+	0b100111	DATA_DEBUG
+	0b101010	ALIGN_FAULT
+	0b101011	INSN_FAULT
+	0b101100	DATA_FAULT
+	0b101110	IRQ
+	0b101111	FIQ
+	0b110000	IMPDEF_TRAP_EL3
+	0b111001	DEBUG_EXIT
+EndEnum
+Enum	7:6	EL
+	0b00	EL0
+	0b01	EL1
+	0b10	EL2
+	0b11	EL3
+EndEnum
+Field	5	MPRED
+Res0	4:2
+Enum	1:0	VALID
+	0b00	NONE
+	0b01	TARGET
+	0b10	SOURCE
+	0b11	FULL
+EndEnum
+EndSysregFields
+
+SysregFields	BRBCR_ELx
+Res0	63:24
+Field	23 	EXCEPTION
+Field	22 	ERTN
+Res0	21:10
+Field	9	FZPSS
+Field	8 	FZP
+Res0	7
+Enum	6:5	TS
+	0b01	VIRTUAL
+	0b10	GUEST_PHYSICAL
+	0b11	PHYSICAL
+EndEnum
+Field	4	MPRED
+Field	3	CC
+Res0	2
+Field	1	ExBRE
+Field	0	E0BRE
+EndSysregFields
+
+Sysreg	BRBCR_EL1	2	1	9	0	0
+Fields	BRBCR_ELx
+EndSysreg
+
+Sysreg	BRBFCR_EL1	2	1	9	0	1
+Res0	63:30
+Enum	29:28	BANK
+	0b00	BANK_0
+	0b01	BANK_1
+EndEnum
+Res0	27:23
+Field	22	CONDDIR
+Field	21	DIRCALL
+Field	20	INDCALL
+Field	19	RTN
+Field	18	INDIRECT
+Field	17	DIRECT
+Field	16	EnI
+Res0	15:8
+Field	7	PAUSED
+Field	6	LASTFAILED
+Res0	5:0
+EndSysreg
+
+Sysreg	BRBTS_EL1	2	1	9	0	2
+Field	63:0	TS
+EndSysreg
+
+Sysreg	BRBINFINJ_EL1	2	1	9	1	0
+Fields BRBINFx_EL1
+EndSysreg
+
+Sysreg	BRBSRCINJ_EL1	2	1	9	1	1
+Field	63:0 ADDRESS
+EndSysreg
+
+Sysreg	BRBTGTINJ_EL1	2	1	9	1	2
+Field	63:0 ADDRESS
+EndSysreg
+
+Sysreg	BRBIDR0_EL1	2	1	9	2	0
+Res0	63:16
+Enum	15:12	CC
+	0b0101	20_BIT
+EndEnum
+Enum	11:8	FORMAT
+	0b0000	FORMAT_0
+EndEnum
+Enum	7:0		NUMREC
+	0b00001000	8
+	0b00010000	16
+	0b00100000	32
+	0b01000000	64
+EndEnum
+EndSysreg
+
+Sysreg	BRBCR_EL2	2	4	9	0	0
+Fields	BRBCR_ELx
+EndSysreg
+
+Sysreg	BRBCR_EL12	2	5	9	0	0
+Fields	BRBCR_ELx
+EndSysreg
+
 Sysreg	ID_AA64ZFR0_EL1	3	0	0	4	4
 Res0	63:60
 UnsignedEnum	59:56	F64MM

-- 
2.47.2

