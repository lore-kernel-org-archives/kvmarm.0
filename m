Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2F72309D6
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 10:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407878; cv=none; b=DjTcwJk50YsCEjbdzpGdQZUQpZN72lBGf46M8850lD43tBIaqAt4tebXAGmXKn5Oub9DhUmO7cdT9qyppB24LhlpIBAGwRbGW9TC1D21gGIK0JzgaVJFdE2FrgYr6J2moA5mxkFQf4N+6gFEKOCxRXhaAMO4FBA0Vt6vBwYUkX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407878; c=relaxed/simple;
	bh=t6i8BpWjvHYC+LyV191L2DoLLnAHyCYZJLzH4xlBclg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h+QNMAyR9TuidtWpUufS5/JjrsCafeuUficAdMyG1Lmg6KaLvJtlnTDs/xcBSXI883dRBEf8yjQvk8/4GtWlsJm0SOaHZwKoXfdsLub2m16PqvfBFZVvw05K+CLKoci5o45m/9Iu7SalcFHfYoPEN3CcLvQ0nvENUb2dgo8AcLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kUH3MOg6; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kUH3MOg6"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4315df7b43fso47647005e9.0
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 02:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731407873; x=1732012673; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUBQf8hA2fpU+kmR16EcISA5nfxhUZdSES5iWO7fp+4=;
        b=kUH3MOg6XJJovqxty9G9sG+kU1rsVWya0JH5ErIsOdM9AjCgFAES1qtc7IG9dPczIj
         bNscH8UJWYDUP6dblZXQFZnTNnVKCtcLCmNU9uIqaAgEYEhvny3qpD2a6U5mpNTswaIr
         gfq72cyxwlKvJ+qFDBgdn8ej33vqt+lZV23KKGtEolaeJemkLXqwJtykytQXie5NtojH
         r1PWcyuiP0zfZ0HnbyCsyodzwpu6+euR+qogt8JeEbyLCLFEAkb3Iiv806D+UjwOTc/Z
         gaOa4XW0fl4Vqrdl7PowFiMMJrJYqs5i08/rA/ehOdKVvJA54R41GcV9V9NHsYTra0x3
         389g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731407873; x=1732012673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rUBQf8hA2fpU+kmR16EcISA5nfxhUZdSES5iWO7fp+4=;
        b=wMQyK8SDcQb7m7EBsCIR1PFFdCH6pA1sjJoSnBSMpZsVc3RLrRb0M1ygyfKyQ+x7eC
         XSQhOTm9WfzfbhOZgs6E+M/ohnfSc1L+S8ktBsCfI7vLMDmPZyyDcCFEakzXxhcf3Fv/
         9WXq0ETiwI1p1l2fUOPYTvdDeO++qrSvWRBrC6w5xO67NoGuBGNb0O2RoG1VmV0nyNPd
         hSGP1hGuANz1SI/c6HjbeRBeqm0nYLJcETlIDrGezidElbwg63WeokYpqTS+iCU6GTLE
         2RdtTIlmANwtXHokg3bInCDX6rtRm8GU6nNeUC3q+O5USzfP/rtDmIraEG3PvqHShJUO
         lILA==
X-Forwarded-Encrypted: i=1; AJvYcCU4Tvdf7Qi2rVLZAWDoaMmjNL3rTxOQ3rUmb/RX2bRX+Jy1UYYL+oS3ac96SzFr6ZqwJTQyxkU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBlDNkdFNK7MfjlHL7gIiNSoD1NkW1netGY8/uTTRItAbDsa9k
	9co+Yvo9QF3cZ0qdCJumRUzFDaoy6fVVp3nk2Vf8GTwEZ1hmk6NPLe1zZkSrVBw=
X-Google-Smtp-Source: AGHT+IGEJl+Jco8dYWeX7p5xX2ZqQ1FJqfj/h/+GHbI4ME8cH4NEto1wKbqbA+SxHv+BKuc1PuLyIg==
X-Received: by 2002:a05:600c:4f04:b0:42e:d4a2:ce67 with SMTP id 5b1f17b1804b1-432b7505d19mr149731975e9.17.1731407873250;
        Tue, 12 Nov 2024 02:37:53 -0800 (PST)
Received: from pop-os.. ([145.224.90.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432bbf436ffsm142270955e9.44.2024.11.12.02.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:37:52 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	coresight@lists.linaro.org,
	kvmarm@lists.linux.dev
Cc: James Clark <james.clark@arm.com>,
	Mark Brown <broonie@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	James Morse <james.morse@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 03/12] arm64/sysreg/tools: Move TRFCR definitions to sysreg
Date: Tue, 12 Nov 2024 10:37:02 +0000
Message-Id: <20241112103717.589952-4-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241112103717.589952-1-james.clark@linaro.org>
References: <20241112103717.589952-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@arm.com>

Convert TRFCR to automatic generation. Add separate definitions for ELx
and EL2 as TRFCR_EL1 doesn't have CX. This also mirrors the previous
definition so no code change is required.

Also add TRFCR_EL12 which will start to be used in a later commit.

Unfortunately, to avoid breaking the Perf build with duplicate
definition errors, the tools copy of the sysreg.h header needs to be
updated at the same time rather than the usual second commit. This is
because the generated version of sysreg
(arch/arm64/include/generated/asm/sysreg-defs.h), is currently shared
and tools/ does not have its own copy.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/sysreg.h       | 12 ---------
 arch/arm64/tools/sysreg               | 36 +++++++++++++++++++++++++++
 tools/arch/arm64/include/asm/sysreg.h | 12 ---------
 3 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 345e81e0d2b3..150416682e2c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -283,8 +283,6 @@
 #define SYS_RGSR_EL1			sys_reg(3, 0, 1, 0, 5)
 #define SYS_GCR_EL1			sys_reg(3, 0, 1, 0, 6)
 
-#define SYS_TRFCR_EL1			sys_reg(3, 0, 1, 2, 1)
-
 #define SYS_TCR_EL1			sys_reg(3, 0, 2, 0, 2)
 
 #define SYS_APIAKEYLO_EL1		sys_reg(3, 0, 2, 1, 0)
@@ -519,7 +517,6 @@
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
-#define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
 #define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
@@ -983,15 +980,6 @@
 /* Safe value for MPIDR_EL1: Bit31:RES1, Bit30:U:0, Bit24:MT:0 */
 #define SYS_MPIDR_SAFE_VAL	(BIT(31))
 
-#define TRFCR_ELx_TS_SHIFT		5
-#define TRFCR_ELx_TS_MASK		((0x3UL) << TRFCR_ELx_TS_SHIFT)
-#define TRFCR_ELx_TS_VIRTUAL		((0x1UL) << TRFCR_ELx_TS_SHIFT)
-#define TRFCR_ELx_TS_GUEST_PHYSICAL	((0x2UL) << TRFCR_ELx_TS_SHIFT)
-#define TRFCR_ELx_TS_PHYSICAL		((0x3UL) << TRFCR_ELx_TS_SHIFT)
-#define TRFCR_EL2_CX			BIT(3)
-#define TRFCR_ELx_ExTRE			BIT(1)
-#define TRFCR_ELx_E0TRE			BIT(0)
-
 /* GIC Hypervisor interface registers */
 /* ICH_MISR_EL2 bit definitions */
 #define ICH_MISR_EOI		(1 << 0)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a26c0da0c42d..27a7afd5329a 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1994,6 +1994,22 @@ Sysreg	CPACR_EL1	3	0	1	0	2
 Fields	CPACR_ELx
 EndSysreg
 
+SysregFields TRFCR_ELx
+Res0	63:7
+UnsignedEnum	6:5	TS
+	0b0001	VIRTUAL
+	0b0010	GUEST_PHYSICAL
+	0b0011	PHYSICAL
+EndEnum
+Res0	4:2
+Field	1	ExTRE
+Field	0	E0TRE
+EndSysregFields
+
+Sysreg	TRFCR_EL1	3	0	1	2	1
+Fields	TRFCR_ELx
+EndSysreg
+
 Sysreg	SMPRI_EL1	3	0	1	2	4
 Res0	63:4
 Field	3:0	PRIORITY
@@ -2536,6 +2552,22 @@ Field	1	ICIALLU
 Field	0	ICIALLUIS
 EndSysreg
 
+Sysreg TRFCR_EL2	3	4	1	2	1
+Res0	63:7
+UnsignedEnum	6:5	TS
+	0b0000	USE_TRFCR_EL1_TS
+	0b0001	VIRTUAL
+	0b0010	GUEST_PHYSICAL
+	0b0011	PHYSICAL
+EndEnum
+Res0	4
+Field	3	CX
+Res0	2
+Field	1	E2TRE
+Field	0	E0HTRE
+EndSysreg
+
+
 Sysreg HDFGRTR_EL2	3	4	3	1	4
 Field	63	PMBIDR_EL1
 Field	62	nPMSNEVFR_EL1
@@ -2946,6 +2978,10 @@ Sysreg	ZCR_EL12	3	5	1	2	0
 Fields	ZCR_ELx
 EndSysreg
 
+Sysreg	TRFCR_EL12	3	5	1	2	1
+Fields	TRFCR_ELx
+EndSysreg
+
 Sysreg	SMCR_EL12	3	5	1	2	6
 Fields	SMCR_ELx
 EndSysreg
diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index 345e81e0d2b3..150416682e2c 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -283,8 +283,6 @@
 #define SYS_RGSR_EL1			sys_reg(3, 0, 1, 0, 5)
 #define SYS_GCR_EL1			sys_reg(3, 0, 1, 0, 6)
 
-#define SYS_TRFCR_EL1			sys_reg(3, 0, 1, 2, 1)
-
 #define SYS_TCR_EL1			sys_reg(3, 0, 2, 0, 2)
 
 #define SYS_APIAKEYLO_EL1		sys_reg(3, 0, 2, 1, 0)
@@ -519,7 +517,6 @@
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
-#define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
 #define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
@@ -983,15 +980,6 @@
 /* Safe value for MPIDR_EL1: Bit31:RES1, Bit30:U:0, Bit24:MT:0 */
 #define SYS_MPIDR_SAFE_VAL	(BIT(31))
 
-#define TRFCR_ELx_TS_SHIFT		5
-#define TRFCR_ELx_TS_MASK		((0x3UL) << TRFCR_ELx_TS_SHIFT)
-#define TRFCR_ELx_TS_VIRTUAL		((0x1UL) << TRFCR_ELx_TS_SHIFT)
-#define TRFCR_ELx_TS_GUEST_PHYSICAL	((0x2UL) << TRFCR_ELx_TS_SHIFT)
-#define TRFCR_ELx_TS_PHYSICAL		((0x3UL) << TRFCR_ELx_TS_SHIFT)
-#define TRFCR_EL2_CX			BIT(3)
-#define TRFCR_ELx_ExTRE			BIT(1)
-#define TRFCR_ELx_E0TRE			BIT(0)
-
 /* GIC Hypervisor interface registers */
 /* ICH_MISR_EL2 bit definitions */
 #define ICH_MISR_EOI		(1 << 0)
-- 
2.34.1

