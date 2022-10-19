Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2DA5C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 19:11:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53B2C4B946;
	Wed, 19 Oct 2022 15:11:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SgXN35pR0Xry; Wed, 19 Oct 2022 15:11:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 045F94B92C;
	Wed, 19 Oct 2022 15:11:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 552E14B91E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 15:11:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l0Rs+TSg+9Qj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Oct 2022 15:11:29 -0400 (EDT)
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com
 [209.85.161.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 192F34B8F0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 15:11:28 -0400 (EDT)
Received: by mail-oo1-f54.google.com with SMTP id
 k11-20020a4ab28b000000b0047659ccfc28so3659270ooo.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 12:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
 :mime-version:subject:date:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=mQp/SgU2k3oDYw9yCnKZ2Ab4A7I/j7N7D9SRUWxHwOE=;
 b=ct05/3HJuj6zWrcVjGYFopqP4fTJs2oCK2+Inu4sklJgZ5K/xCyoVmtLZkX0lOl6Yq
 VIjYrHsf6Na94pM4GCdlfGA62u2wF7caVxjBzOZToCIgpKCd/JqaO8l+zY9d3rK3RAmc
 8xjvbQDs2zTTf0ePKSSUGSKiINUQsGQ7cu2HW1tDYDN0vmT6+pGRyVTKTi1oFJYI1sc9
 tg/eurTBNuI8d4z16fuk+z7DpC6FXzBcf4Oxs3YsISvFoFC7hxmHk7a/gfgLaF/rH3HZ
 Iodq+XrY5aJRlM/eMCNJ7nQkPlUBqIj0JsEA3tSBOAdRF2ZWImPr1apXeHyZhEGp8TgJ
 B2VA==
X-Gm-Message-State: ACrzQf1frosU9qFOwIZyaOdNvvtFd1xmpmdAPmXLn8k4zuj4hgkA90uC
 p4rDetc5g97mnX3x9XYkBw==
X-Google-Smtp-Source: AMsMyM7xeAxAQDKquPXRoYWcYdaVemGqSxwr1fGt4SxvyE1uvAcCzVc/l/1vUquX+d6B00OgXjqHPA==
X-Received: by 2002:a4a:ee0f:0:b0:47f:649d:52da with SMTP id
 bd15-20020a4aee0f000000b0047f649d52damr4365517oob.18.1666206687393; 
 Wed, 19 Oct 2022 12:11:27 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net.
 [66.90.144.107]) by smtp.gmail.com with ESMTPSA id
 h7-20020a9d61c7000000b00661c3846b4csm7429899otk.27.2022.10.19.12.11.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Oct 2022 12:11:26 -0700 (PDT)
Received: (nullmailer pid 3420902 invoked by uid 1000);
 Wed, 19 Oct 2022 19:11:25 -0000
From: Rob Herring <robh@kernel.org>
Date: Wed, 19 Oct 2022 14:11:26 -0500
Subject: [PATCH v2 3/7] arm64/sysreg: Convert SPE registers to automatic
 generation
MIME-Version: 1.0
Message-Id: <20220825-arm-spe-v8-7-v2-3-e37322d68ac0@kernel.org>
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>,
 Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Oliver Upton <oliver.upton@linux.dev>, Jiri Olsa <jolsa@kernel.org>
X-Mailer: b4 0.11.0-dev
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Convert all the SPE register defines to automatic generation. No
functional changes.

New registers and fields for SPEv1.2 are added with the conversion.

Some of the PMBSR MSS field defines are kept as the automatic generation
has no way to create multiple names for the same register bits. The
meaning of the MSS field depends on other bits.

Signed-off-by: Rob Herring <robh@kernel.org>
---
v2:
 - New patch
---
 arch/arm64/include/asm/sysreg.h |  91 ++-----------------------------
 arch/arm64/tools/sysreg         | 116 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 86 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 8df8a0a51273..d002dd00e53e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -237,99 +237,18 @@
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
index 384757a7eda9..2fbfe625dacc 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -854,6 +854,111 @@ Sysreg	FAR_EL1	3	0	6	0	0
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
+Field	19:16	COUNTSIZE
+Field	15:12	MAXSIZE
+Field	11:8	INTERVAL
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
+	0b0000	STOP_IRQ
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
+Field	11:8	EA
+Res0	7:6
+Field	5	F
+Field	4	P
+Field	3:0	ALIGN
+EndSysreg
+
 SysregFields	CONTEXTIDR_ELx
 Res0	63:32
 Field	31:0	PROCID
@@ -1008,6 +1113,17 @@ Sysreg	FAR_EL2	3	4	6	0	0
 Field	63:0	ADDR
 EndSysreg
 
+Sysreg	PMSCR_EL2	3	4	9	9	0
+Res0	63:8
+Field	7:6	PCT
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
b4 0.11.0-dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
