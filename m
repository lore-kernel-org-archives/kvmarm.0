Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2108C19
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 19:26:40 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id m6-20020a9d7e86000000b0066ec505ae93so5724605otp.9
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 11:26:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rz2iRPDu/kU47mL2nLBk7PH3KxdS0ijqRPpZ+NAWlPg=;
        b=oXtsrotgQxbLSUh9QlrDqQC9kx/u4quK51Wp3ULqN+dXZYOSemA7dzekCxdN3lfzBn
         v/NxlN8c62Il1rTeq0Bz/v6xOdBeuk00i4b4zuo9/1eg79vNL4CeyprtBVy4MhwdVkl7
         SeT+WBWmA8EruAwOZRGh+d9iSNDkI3IYb2K83S/2OWIBGLkGV1UPPiK51m8tbO3JqTMU
         4EaRaoxbzu4rHss493MXvXuq6+Vo3bjVmV6G3gh7KvV/7RSAkUTm2M0gYcFcRnC/tcFS
         QeOD17S+b14CpXnTu3lCJrT5NVHpeIIP+svjhequqhe7uCroFuECEdYPe36oU2y5a4MU
         JI8A==
X-Gm-Message-State: AFqh2kqIZkss3uGQ7+YtmsCz9UvlW+MC8bqnAv9q5RuEHI953+SSnuNQ
	pxgsj+Dfi+lufngMYJLvPA==
X-Google-Smtp-Source: AMrXdXt4N7Ek74CSUz+QdNJ6wzP3Y+qPWTWggKjMsGeJbMO9BW55S1U852857myfgsKuKnTaNqEb5g==
X-Received: by 2002:a05:6830:1e2f:b0:67a:1598:de18 with SMTP id t15-20020a0568301e2f00b0067a1598de18mr30855508otr.6.1673292400179;
        Mon, 09 Jan 2023 11:26:40 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s14-20020a05683004ce00b0066c34486aa7sm4940362otd.73.2023.01.09.11.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 11:26:39 -0800 (PST)
Received: (nullmailer pid 1483610 invoked by uid 1000);
	Mon, 09 Jan 2023 19:26:31 -0000
From: Rob Herring <robh@kernel.org>
Date: Mon, 09 Jan 2023 13:26:19 -0600
Subject:
 [PATCH v4 3/8] arm64/sysreg: Convert SPE registers to automatic generation
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20220825-arm-spe-v8-7-v4-3-327f860daf28@kernel.org>
References: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, James Clark <james.clark@arm.com>
X-Mailer: b4 0.12-dev

Convert all the SPE register defines to automatic generation. No
functional changes.

New registers and fields for SPEv1.2 are added with the conversion.

Some of the PMBSR MSS field defines are kept as the automatic generation
has no way to create multiple names for the same register bits. The
meaning of the MSS field depends on other bits.

Tested-by: James Clark <james.clark@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v4:
 - Rebase on v6.2-rc1
v3:
 - Make some fields enums and add some missing fields
v2:
 - New patch
---
 arch/arm64/include/asm/sysreg.h |  91 ++------------------------
 arch/arm64/tools/sysreg         | 139 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 86 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index dbb0e8e22cf4..db269eda7c1c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -216,99 +216,18 @@
 #define SYS_PAR_EL1_FST			GENMASK(6, 1)
 
 /*** Statistical Profiling Extension ***/
-/* ID registers */
-#define SYS_PMSIDR_EL1			sys_reg(3, 0, 9, 9, 7)
-#define PMSIDR_EL1_FE_SHIFT		0
-#define PMSIDR_EL1_FT_SHIFT		1
-#define PMSIDR_EL1_FL_SHIFT		2
-#define PMSIDR_EL1_ARCHINST_SHIFT	3
-#define PMSIDR_EL1_LDS_SHIFT	4
-#define PMSIDR_EL1_ERND_SHIFT	5
-#define PMSIDR_EL1_INTERVAL_SHIFT	8
-#define PMSIDR_EL1_INTERVAL_MASK	GENMASK_ULL(11, 8)
-#define PMSIDR_EL1_MAXSIZE_SHIFT	12
-#define PMSIDR_EL1_MAXSIZE_MASK		GENMASK_ULL(15, 12)
-#define PMSIDR_EL1_COUNTSIZE_SHIFT	16
-#define PMSIDR_EL1_COUNTSIZE_MASK	GENMASK_ULL(19, 16)
-
-#define SYS_PMBIDR_EL1			sys_reg(3, 0, 9, 10, 7)
-#define PMBIDR_EL1_ALIGN_SHIFT		0
-#define PMBIDR_EL1_ALIGN_MASK		0xfU
-#define PMBIDR_EL1_P_SHIFT		4
-#define PMBIDR_EL1_F_SHIFT		5
-
-/* Sampling controls */
-#define SYS_PMSCR_EL1			sys_reg(3, 0, 9, 9, 0)
-#define PMSCR_EL1_E0SPE_SHIFT		0
-#define PMSCR_EL1_E1SPE_SHIFT		1
-#define PMSCR_EL1_CX_SHIFT		3
-#define PMSCR_EL1_PA_SHIFT		4
-#define PMSCR_EL1_TS_SHIFT		5
-#define PMSCR_EL1_PCT_SHIFT		6
-
-#define SYS_PMSCR_EL2			sys_reg(3, 4, 9, 9, 0)
-#define PMSCR_EL2_E0HSPE_SHIFT		0
-#define PMSCR_EL2_E2SPE_SHIFT		1
-#define PMSCR_EL2_CX_SHIFT		3
-#define PMSCR_EL2_PA_SHIFT		4
-#define PMSCR_EL2_TS_SHIFT		5
-#define PMSCR_EL2_PCT_SHIFT		6
-
-#define SYS_PMSICR_EL1			sys_reg(3, 0, 9, 9, 2)
-
-#define SYS_PMSIRR_EL1			sys_reg(3, 0, 9, 9, 3)
-#define PMSIRR_EL1_RND_SHIFT		0
-#define PMSIRR_EL1_INTERVAL_SHIFT	8
-#define PMSIRR_EL1_INTERVAL_MASK	GENMASK_ULL(31, 8)
-
-/* Filtering controls */
-#define SYS_PMSNEVFR_EL1		sys_reg(3, 0, 9, 9, 1)
-
-#define SYS_PMSFCR_EL1			sys_reg(3, 0, 9, 9, 4)
-#define PMSFCR_EL1_FE_SHIFT		0
-#define PMSFCR_EL1_FT_SHIFT		1
-#define PMSFCR_EL1_FL_SHIFT		2
-#define PMSFCR_EL1_B_SHIFT		16
-#define PMSFCR_EL1_LD_SHIFT		17
-#define PMSFCR_EL1_ST_SHIFT		18
-
-#define SYS_PMSEVFR_EL1			sys_reg(3, 0, 9, 9, 5)
 #define PMSEVFR_EL1_RES0_IMP	\
 	(GENMASK_ULL(47, 32) | GENMASK_ULL(23, 16) | GENMASK_ULL(11, 8) |\
 	 BIT_ULL(6) | BIT_ULL(4) | BIT_ULL(2) | BIT_ULL(0))
 #define PMSEVFR_EL1_RES0_V1P1	\
 	(PMSEVFR_EL1_RES0_IMP & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
 
-#define SYS_PMSLATFR_EL1		sys_reg(3, 0, 9, 9, 6)
-#define PMSLATFR_EL1_MINLAT_SHIFT	0
-
-/* Buffer controls */
-#define SYS_PMBLIMITR_EL1		sys_reg(3, 0, 9, 10, 0)
-#define PMBLIMITR_EL1_E_SHIFT		0
-#define PMBLIMITR_EL1_FM_SHIFT		1
-#define PMBLIMITR_EL1_FM_MASK	GENMASK_ULL(2, 1)
-#define PMBLIMITR_EL1_FM_STOP_IRQ	0
-
-#define SYS_PMBPTR_EL1			sys_reg(3, 0, 9, 10, 1)
-
 /* Buffer error reporting */
-#define SYS_PMBSR_EL1			sys_reg(3, 0, 9, 10, 3)
-#define PMBSR_EL1_COLL_SHIFT		16
-#define PMBSR_EL1_S_SHIFT		17
-#define PMBSR_EL1_EA_SHIFT		18
-#define PMBSR_EL1_DL_SHIFT		19
-#define PMBSR_EL1_EC_SHIFT		26
-#define PMBSR_EL1_EC_MASK		GENMASK_ULL(31, 26)
-
-#define PMBSR_EL1_EC_BUF		0x0UL
-#define PMBSR_EL1_EC_FAULT_S1		0x24UL
-#define PMBSR_EL1_EC_FAULT_S2		0x25UL
-
-#define PMBSR_EL1_FAULT_FSC_SHIFT	0
-#define PMBSR_EL1_FAULT_FSC_MASK	0x3fUL
-
-#define PMBSR_EL1_BUF_BSC_SHIFT		0
-#define PMBSR_EL1_BUF_BSC_MASK		0x3fUL
+#define PMBSR_EL1_FAULT_FSC_SHIFT	PMBSR_EL1_MSS_SHIFT
+#define PMBSR_EL1_FAULT_FSC_MASK	PMBSR_EL1_MSS_MASK
+
+#define PMBSR_EL1_BUF_BSC_SHIFT		PMBSR_EL1_MSS_SHIFT
+#define PMBSR_EL1_BUF_BSC_MASK		PMBSR_EL1_MSS_MASK
 
 #define PMBSR_EL1_BUF_BSC_FULL		0x1UL
 
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 184e58fd5631..c323833cf235 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1618,6 +1618,130 @@ Sysreg	FAR_EL1	3	0	6	0	0
 Field	63:0	ADDR
 EndSysreg
 
+Sysreg	PMSCR_EL1	3	0	9	9	0
+Res0	63:8
+Field	7:6	PCT
+Field	5	TS
+Field	4	PA
+Field	3	CX
+Res0	2
+Field	1	E1SPE
+Field	0	E0SPE
+EndSysreg
+
+Sysreg	PMSNEVFR_EL1	3	0	9	9	1
+Field	63:0	E
+EndSysreg
+
+Sysreg	PMSICR_EL1	3	0	9	9	2
+Field	63:56	ECOUNT
+Res0	55:32
+Field	31:0	COUNT
+EndSysreg
+
+Sysreg	PMSIRR_EL1	3	0	9	9	3
+Res0	63:32
+Field	31:8	INTERVAL
+Res0	7:1
+Field	0	RND
+EndSysreg
+
+Sysreg	PMSFCR_EL1	3	0	9	9	4
+Res0	63:19
+Field	18	ST
+Field	17	LD
+Field	16	B
+Res0	15:4
+Field	3	FnE
+Field	2	FL
+Field	1	FT
+Field	0	FE
+EndSysreg
+
+Sysreg	PMSEVFR_EL1	3	0	9	9	5
+Field	63:0	E
+EndSysreg
+
+Sysreg	PMSLATFR_EL1	3	0	9	9	6
+Res0	63:16
+Field	15:0	MINLAT
+EndSysreg
+
+Sysreg	PMSIDR_EL1	3	0	9	9	7
+Res0	63:25
+Field	24	PBT
+Field	23:20	FORMAT
+Enum	19:16	COUNTSIZE
+	0b0010	12_BIT_SAT
+	0b0011	16_BIT_SAT
+EndEnum
+Field	15:12	MAXSIZE
+Enum	11:8	INTERVAL
+	0b0000	256
+	0b0010	512
+	0b0011	768
+	0b0100	1024
+	0b0101	1536
+	0b0110	2048
+	0b0111	3072
+	0b1000	4096
+EndEnum
+Res0	7
+Field	6	FnE
+Field	5	ERND
+Field	4	LDS
+Field	3	ARCHINST
+Field	2	FL
+Field	1	FT
+Field	0	FE
+EndSysreg
+
+Sysreg	PMBLIMITR_EL1	3	0	9	10	0
+Field	63:12	LIMIT
+Res0	11:6
+Field	5	PMFZ
+Res0	4:3
+Enum	2:1	FM
+	0b00	FILL
+	0b10	DISCARD
+EndEnum
+Field	0	E
+EndSysreg
+
+Sysreg	PMBPTR_EL1	3	0	9	10	1
+Field	63:0	PTR
+EndSysreg
+
+Sysreg	PMBSR_EL1	3	0	9	10	3
+Res0	63:32
+Enum	31:26	EC
+	0b000000	BUF
+	0b100100	FAULT_S1
+	0b100101	FAULT_S2
+	0b011110	FAULT_GPC
+	0b011111	IMP_DEF
+EndEnum
+Res0	25:20
+Field	19	DL
+Field	18	EA
+Field	17	S
+Field	16	COLL
+Field	15:0	MSS
+EndSysreg
+
+Sysreg	PMBIDR_EL1	3	0	9	10	7
+Res0	63:12
+Enum	11:8	EA
+	0b0000	NotDescribed
+	0b0001	Ignored
+	0b0010	SError
+EndEnum
+Res0	7:6
+Field	5	F
+Field	4	P
+Field	3:0	ALIGN
+EndSysreg
+
 SysregFields	CONTEXTIDR_ELx
 Res0	63:32
 Field	31:0	PROCID
@@ -1772,6 +1896,21 @@ Sysreg	FAR_EL2	3	4	6	0	0
 Field	63:0	ADDR
 EndSysreg
 
+Sysreg	PMSCR_EL2	3	4	9	9	0
+Res0	63:8
+Enum	7:6	PCT
+	0b00	VIRT
+	0b01	PHYS
+	0b11	GUEST
+EndEnum
+Field	5	TS
+Field	4	PA
+Field	3	CX
+Res0	2
+Field	1	E2SPE
+Field	0	E0HSPE
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg

-- 
2.39.0
