Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8822BD10
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 08:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571541; cv=none; b=om51ZVWj2t0uJEEFsn+HM4J2xSDSG88bygEI3vRYnUYHchbFNMPBSYPEvdVp8wBgMMnHohs7dX2cUmBUkVsSTMWGzEoMWW7KjTzpbNrFTmYU8c7jMpvQWjBxyCDSz45tzNx4zAo40rbj0ZBgcbTcaFHn9sVxsQdPL9MXDepHX30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571541; c=relaxed/simple;
	bh=3+3RAwViEqsWkdP0MdfPJrDpU36Pp/mqkxlq6zwpUP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S4ufodb7haPC9A+W2X9NOLkRTViJ1Ysjc55mY3zmMo7OkiVLPk56HC1L2NxFoYsZY9OKuCUuLpTdFLQvHDRMLoiu+KE8Bgy1IWM4FupwX4Q3shMteHelYSelUNYaujeFj2G9yOwemZhjYwS3No+VY1cGHpFfRE4Yjq0N48Vov4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5977C1476;
	Mon,  3 Feb 2025 00:32:43 -0800 (PST)
Received: from [10.162.16.79] (unknown [10.162.16.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEA233F63F;
	Mon,  3 Feb 2025 00:32:13 -0800 (PST)
Message-ID: <a68b37ac-4f2e-4267-bc23-58136be26271@arm.com>
Date: Mon, 3 Feb 2025 14:02:11 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 08/11] arm64/sysreg: Add BRBE registers and fields
To: "Rob Herring (Arm)" <robh@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-8-1c1300802385@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250202-arm-brbe-v19-v19-8-1c1300802385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/3/25 06:13, Rob Herring (Arm) wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> This patch adds definitions related to the Branch Record Buffer Extension
> (BRBE) as per ARM DDI 0487K.a. These will be used by KVM and a BRBE driver
> in subsequent patches.
> 
> Some existing BRBE definitions in asm/sysreg.h are replaced with equivalent
> generated definitions.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> v19:
> - split BRBINF.CC field into mantissa and exponent
> ---
>  arch/arm64/include/asm/sysreg.h |  17 ++----
>  arch/arm64/tools/sysreg         | 132 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 138 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 05ea5223d2d5..a8257e13f8f1 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -198,16 +198,8 @@
>  #define SYS_DBGVCR32_EL2		sys_reg(2, 4, 0, 7, 0)
>  
>  #define SYS_BRBINF_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 0))
> -#define SYS_BRBINFINJ_EL1		sys_reg(2, 1, 9, 1, 0)
>  #define SYS_BRBSRC_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 1))
> -#define SYS_BRBSRCINJ_EL1		sys_reg(2, 1, 9, 1, 1)
>  #define SYS_BRBTGT_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 2))
> -#define SYS_BRBTGTINJ_EL1		sys_reg(2, 1, 9, 1, 2)
> -#define SYS_BRBTS_EL1			sys_reg(2, 1, 9, 0, 2)
> -
> -#define SYS_BRBCR_EL1			sys_reg(2, 1, 9, 0, 0)
> -#define SYS_BRBFCR_EL1			sys_reg(2, 1, 9, 0, 1)
> -#define SYS_BRBIDR0_EL1			sys_reg(2, 1, 9, 2, 0)
>  
>  #define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
>  #define SYS_TRCACATR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (2 | (m >> 3)))
> @@ -273,8 +265,6 @@
>  /* ETM */
>  #define SYS_TRCOSLAR			sys_reg(2, 1, 1, 0, 4)
>  
> -#define SYS_BRBCR_EL2			sys_reg(2, 4, 9, 0, 0)
> -
>  #define SYS_MIDR_EL1			sys_reg(3, 0, 0, 0, 0)
>  #define SYS_MPIDR_EL1			sys_reg(3, 0, 0, 0, 5)
>  #define SYS_REVIDR_EL1			sys_reg(3, 0, 0, 0, 6)
> @@ -610,7 +600,6 @@
>  #define SYS_CNTHV_CVAL_EL2		sys_reg(3, 4, 14, 3, 2)
>  
>  /* VHE encodings for architectural EL0/1 system registers */
> -#define SYS_BRBCR_EL12			sys_reg(2, 5, 9, 0, 0)
>  #define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
>  #define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
>  #define SYS_SCTLR2_EL12			sys_reg(3, 5, 1, 0, 3)
> @@ -821,6 +810,12 @@
>  #define OP_COSP_RCTX			sys_insn(1, 3, 7, 3, 6)
>  #define OP_CPP_RCTX			sys_insn(1, 3, 7, 3, 7)
>  
> +/*
> + * BRBE Instructions
> + */
> +#define BRB_IALL_INSN	__emit_inst(0xd5000000 | OP_BRB_IALL | (0x1f))
> +#define BRB_INJ_INSN	__emit_inst(0xd5000000 | OP_BRB_INJ  | (0x1f))
> +
>  /* Common SCTLR_ELx flags. */
>  #define SCTLR_ELx_ENTP2	(BIT(60))
>  #define SCTLR_ELx_DSSBS	(BIT(44))
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 762ee084b37c..c0943579977a 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1038,6 +1038,138 @@ UnsignedEnum	3:0	MTEPERM
>  EndEnum
>  EndSysreg
>  
> +
> +SysregFields BRBINFx_EL1
> +Res0	63:47
> +Field	46	CCU
> +Field	45:40	CC_EXP
> +Field	39:32	CC_MANT
> +Res0	31:18
> +Field	17	LASTFAILED
> +Field	16	T
> +Res0	15:14
> +Enum	13:8		TYPE
> +	0b000000	DIRECT_UNCOND
> +	0b000001	INDIRECT
> +	0b000010	DIRECT_LINK
> +	0b000011	INDIRECT_LINK
> +	0b000101	RET
> +	0b000111	ERET
> +	0b001000	DIRECT_COND
> +	0b100001	DEBUG_HALT
> +	0b100010	CALL
> +	0b100011	TRAP
> +	0b100100	SERROR
> +	0b100110	INSN_DEBUG
> +	0b100111	DATA_DEBUG
> +	0b101010	ALIGN_FAULT
> +	0b101011	INSN_FAULT
> +	0b101100	DATA_FAULT
> +	0b101110	IRQ
> +	0b101111	FIQ
> +	0b110000	IMPDEF_TRAP_EL3
> +	0b111001	DEBUG_EXIT
> +EndEnum
> +Enum	7:6	EL
> +	0b00	EL0
> +	0b01	EL1
> +	0b10	EL2
> +	0b11	EL3
> +EndEnum
> +Field	5	MPRED
> +Res0	4:2
> +Enum	1:0	VALID
> +	0b00	NONE
> +	0b01	TARGET
> +	0b10	SOURCE
> +	0b11	FULL
> +EndEnum
> +EndSysregFields
> +
> +SysregFields	BRBCR_ELx
> +Res0	63:24
> +Field	23 	EXCEPTION
> +Field	22 	ERTN
> +Res0	21:10
> +Field	9	FZPSS
> +Field	8 	FZP
> +Res0	7
> +Enum	6:5	TS
> +	0b01	VIRTUAL
> +	0b10	GUEST_PHYSICAL
> +	0b11	PHYSICAL
> +EndEnum
> +Field	4	MPRED
> +Field	3	CC
> +Res0	2
> +Field	1	ExBRE
> +Field	0	E0BRE
> +EndSysregFields
> +
> +Sysreg	BRBCR_EL1	2	1	9	0	0
> +Fields	BRBCR_ELx
> +EndSysreg
> +
> +Sysreg	BRBFCR_EL1	2	1	9	0	1
> +Res0	63:30
> +Enum	29:28	BANK
> +	0b00	BANK_0
> +	0b01	BANK_1
> +EndEnum
> +Res0	27:23
> +Field	22	CONDDIR
> +Field	21	DIRCALL
> +Field	20	INDCALL
> +Field	19	RTN
> +Field	18	INDIRECT
> +Field	17	DIRECT
> +Field	16	EnI
> +Res0	15:8
> +Field	7	PAUSED
> +Field	6	LASTFAILED
> +Res0	5:0
> +EndSysreg
> +
> +Sysreg	BRBTS_EL1	2	1	9	0	2
> +Field	63:0	TS
> +EndSysreg
> +
> +Sysreg	BRBINFINJ_EL1	2	1	9	1	0
> +Fields BRBINFx_EL1
> +EndSysreg
> +
> +Sysreg	BRBSRCINJ_EL1	2	1	9	1	1
> +Field	63:0 ADDRESS
> +EndSysreg
> +
> +Sysreg	BRBTGTINJ_EL1	2	1	9	1	2
> +Field	63:0 ADDRESS
> +EndSysreg
> +
> +Sysreg	BRBIDR0_EL1	2	1	9	2	0
> +Res0	63:16
> +Enum	15:12	CC
> +	0b0101	20_BIT
> +EndEnum
> +Enum	11:8	FORMAT
> +	0b0000	FORMAT_0
> +EndEnum
> +Enum	7:0		NUMREC
> +	0b00001000	8
> +	0b00010000	16
> +	0b00100000	32
> +	0b01000000	64
> +EndEnum
> +EndSysreg
> +
> +Sysreg	BRBCR_EL2	2	4	9	0	0
> +Fields	BRBCR_ELx
> +EndSysreg
> +
> +Sysreg	BRBCR_EL12	2	5	9	0	0
> +Fields	BRBCR_ELx
> +EndSysreg
> +
>  Sysreg	ID_AA64ZFR0_EL1	3	0	0	4	4
>  Res0	63:60
>  UnsignedEnum	59:56	F64MM
> 

LGTM.

The only thing that changed from V18 - BRBINF_EL1's CC[45:32] field has been
split into CC_EXP[45:40] and CC_MANT[39:32].
