Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5359713D251
	for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 10:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732701741; cv=none; b=bTs6JyFaEnEu3z0kCaRP38duuUOFfqjk2GQotlRKkT8j+fRhelDxrJCRTEC7klFzvcsCOont3Zjm1G+1OfA3EcmAj7mwwdtk88HBH6OWvAdsR0yMsOs5GhFG8VXPCwOIoQN+FPxN2d2AvRZDHVhqX45cuTTNiXMgGVQQ0D5qmWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732701741; c=relaxed/simple;
	bh=t6i8BpWjvHYC+LyV191L2DoLLnAHyCYZJLzH4xlBclg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KhU6bYzDhz3n02ghutBCtBWEiAZa6jGwAyjZ0nvkjjJS2mcJlmpKDADJD6AsBi9doRIkTPIrjJf3Vwe5Xy8tCSuRfS00UV1rMKwCI5CZlzxkmRBzILU0M15CJpsqLFiQ+hGUKu5v1eym/qoTAzLhfhKlDXAYrtaVemNhsJ4AaUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mtLcnQP8; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mtLcnQP8"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5cf6f804233so7637176a12.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 02:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732701738; x=1733306538; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUBQf8hA2fpU+kmR16EcISA5nfxhUZdSES5iWO7fp+4=;
        b=mtLcnQP8BcnM4KwYxIOeTri0y7FmDy0hDqoPkRYXZUd3lwpGHdR5DGlZBix/vNxQrC
         6rvFX1ystX/l+uIpzQdCv1PEWEhm2UZW5UFk5/EwhLOKvMP/hm8mEs+t5TvWryek6JSV
         ObihaXUwtCh994o33vdfd8FAlB2JOMHXcLadxp/DZAhws/zbR86EtIsIv9iLmeje6UD0
         uYZ8BM7hgfLFuI5D0e/1MB8sbnZ8wf5LBPs+0vUBO3+JmaKax0XDSF5uMGVsH9eJSsY9
         YrKm6po7oV7rvOEopqE9zJwZY7rkRaYCaLs9QRTrxd7oc4byXiC9QshBqE9irAQ199CC
         Mt5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732701738; x=1733306538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rUBQf8hA2fpU+kmR16EcISA5nfxhUZdSES5iWO7fp+4=;
        b=AuwYEtis3pGjqm2vIFwwStnsN/kA3QTrgfnP2CvOGWdrtgnyvVLJxwF4IiCLqOGexT
         GZiG7gFpQUZlm+WiHU147HZ3a4Aop7p9DQSkMxDqN3SZC30m32Nd9SrTZo3je+ml9JG9
         V4aLdbibxDjqO9mJfZsCFG38aOpnt/962+wUPujoBRJRbyDuZfTiTptKxB/6mta0PvGm
         /ypwDPtgxFojFoS+12gQ79qAGhEceRky/itXsJFWQ8Q/mK0cR+qyHm3ap/iau7RIOaN5
         WmP0jeJ3r3MmeNWmXDAza0Ez+vsN7fAZvIf+RUL2OumjXuPNvBXXUXX8G+CP36IILJFc
         8ahQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSNJliGPVy8KhF4tRTIS6YNmlhlyL2hvs2i/jW0lmXvVfOYnH0MP0Tx81woZerYECA2zT+R4Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlMqOYx6PW/IUgdkTPkXDz787oAqwiEQUpnKRhOZasvaNVFWPa
	Cw/MRtdJfaEmc1nkUukJItJcgSge4/9hueRiFjQfJvzKyfAF5HZLmKcCeKgBJ6g=
X-Gm-Gg: ASbGncuj6KzAy8yY1E9gaYS867RIK5D+rBAJhE0KwUgyITkFS24vhHEhGXRTONTd+Z1
	h0L1kC7x6tRPEyOpT9E4lMtrwpojpo6FBg/JeQEVieqjhBylFzV9xXQvucm+DaMi8OjOqbqYCcF
	OiqtzLtWzuGUabc+0aQd67oSutARraEM6nXC/6rcLiRFHucyk3GLYzlozCOt+1tO9q7ABDjN6w8
	pPXJht+hjRyHgHwbbWdga4FN9URCG482TE8sMox3+ooRQfqoQ==
X-Google-Smtp-Source: AGHT+IECaX60QuAonYO0bJYi2tY+HH+x36ibKnOK0IapIsrV15QT17FWq7bCGXEU4iCd0ieDFErr3A==
X-Received: by 2002:a17:906:23ea:b0:a9a:10c9:f4b8 with SMTP id a640c23a62f3a-aa58109dc28mr150069966b.61.1732701737692;
        Wed, 27 Nov 2024 02:02:17 -0800 (PST)
Received: from pop-os.. ([145.224.90.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa547ffb152sm421887466b.62.2024.11.27.02.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 02:02:17 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	coresight@lists.linaro.org
Cc: James Clark <james.clark@arm.com>,
	Mark Brown <broonie@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 5/8] arm64/sysreg/tools: Move TRFCR definitions to sysreg
Date: Wed, 27 Nov 2024 10:01:22 +0000
Message-Id: <20241127100130.1162639-6-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241127100130.1162639-1-james.clark@linaro.org>
References: <20241127100130.1162639-1-james.clark@linaro.org>
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

