Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824C180BFF
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249702; cv=none; b=fWCU3sejR15zzt+yLEk7oIO8RF1KuX0YeSpKZ3yt7Rha0Oevo98nahxNOu7X6kV4PjF+rubzkynDCSI5+mYfNwS5IxmGT+4rAQHE4YFw+Vmg8biT49bojHnNFxrsKDJ095p3EtQqR7CxqKIyT0p/ZyQKt1G+2Ke3jdFHNsOGzsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249702; c=relaxed/simple;
	bh=drMaQb3MdyN7tqXWFwHoVuRjxKHh4z/QTt8Iidr2SCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RVbMm4tgpxMjQvgYzTWF/x4LwLaalhVUcWI9aeKL9a7gmPjEwAjti/zh26qxO9/nigUwBVHcXWhvNNK/KkZXd/JA7eTO3GoHKNmZFDuRD42E7Z91P5bin21vLXVtM+7jo79wtF6W0qolxhUYMqPwYJTx44T7CfmUkvwkl3D3ddQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xmx3SO5r; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xmx3SO5r"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-38637614567so7019537f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736249698; x=1736854498; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BppzZqICDIuXzcoVaHw/k3QGylTLzE7ExLc+N8DKJB4=;
        b=xmx3SO5rLbollI6fU+xGrTh+C1K/pw4qOErB4hZ3bYaHtQnBMY+E0d5Psun7mdNFH9
         1eEhZ1X3yonUsZBA7xA+G9anWi5OvUhVPs5EDY0xGh4HLlAol9eUg0sDjb2/J1JqJYfj
         2UoAceS7MqrxUHAIe/vNVJecPYYdtK9QojbDUVqY7Lhua46VlDUKnewy6CSeV/DGLk4e
         yXD3Pc99v0OVNfI6M1A9b0GqONHRZuvA6xLxv/byDLO8ZsDIYX2ARh/ktcIEgH9nQJzf
         AsGqJxW9mGFon7LA3KrZiUOAy2AtKfQ8KTQHRTbOU4zlcFj1PPqnlL4OIba3RGG9j+yp
         sI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249698; x=1736854498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BppzZqICDIuXzcoVaHw/k3QGylTLzE7ExLc+N8DKJB4=;
        b=UUkIGfqeqHoGg9tzMV4r+dKAFxy0aGtA+MoxBLBcvtTHU1sCJqHnmfcBvv34Xjixhm
         +o6T4I4UfiEpEBOyv4loiR8F/eido3H4cNI9fGFKGcYedkA7+3N7YlBFn2h+pctYKNqe
         n53ISiCcMWRYrI8asmjzuFoxAj2PoKXoLq1ZBvwweSspsjHlZjRc1aFAdggCoFP/Dl18
         Nai4/ij1dwtzyW9b4gMOgvznuVnT1gCE73JjD4R7OnSvQgwuY0vCJXW9mEH3ZEGNmLnu
         8EcHTuxOf8gZHhX/CTUR6VmCka7tNLz3e1gsXdM9zEAz0tKomQEKUTEDWguoJZL0tcnv
         rcag==
X-Forwarded-Encrypted: i=1; AJvYcCXYBNZj7YiJif6OOYPOTNtvYubJPEkZeqJi9xhfublF/OVpNm65L2B88hhS2dJTtgpcyis0hqU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAw8WGUUhdwShA5qzzcp4R8WU0TIUIVnxtoOzxZYG0uWthdVg3
	viIntLfK1o3NsU9IB9WXKodTsOz2NJGIfkVxTx2DPhnwijzJ/CVSEvAeFpR7mWo=
X-Gm-Gg: ASbGncsj9gzzlDa8aSctKqVx06tIpNk0CRa+T2TbnPmT2WlqxnF5YGXsSMl61UIHB9A
	Hc0UWBSS6Nv/utyW6fM4OBm+HvDI/VkYSJpKgTHuGLJx/QBctqduxPsjMhcWasZrTObdpOmrTKr
	1Nsr6JowSDa1PZifRxYjqXzmBo8KHV7SBwf/qHEO+5IWqgOEgJf9tkz+SDJj7wY26cn8XHD9S+5
	LJn9MswulmtaQsEf7vr2rmEApRVTbLLs3fQBr/ofIi0lAGFhPTTue4j
X-Google-Smtp-Source: AGHT+IHbbqMsVouH91OdV8KnMQ8MWBA16k416qmoq9omp3TMxv8sl0fEiUNFYol+SJHdemxMmyVdqA==
X-Received: by 2002:a5d:47c9:0:b0:38a:615c:8223 with SMTP id ffacd0b85a97d-38a615c82bemr20141492f8f.10.1736249697667;
        Tue, 07 Jan 2025 03:34:57 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e1acsm50299218f8f.68.2025.01.07.03.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 03:34:57 -0800 (PST)
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
	Mark Rutland <mark.rutland@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Fuad Tabba <tabba@google.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 06/10] arm64/sysreg/tools: Move TRFCR definitions to sysreg
Date: Tue,  7 Jan 2025 11:32:43 +0000
Message-Id: <20250107113252.260631-7-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250107113252.260631-1-james.clark@linaro.org>
References: <20250107113252.260631-1-james.clark@linaro.org>
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
index b8303a83c0bf..808f65818b91 100644
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
index 4ba167089e2a..ef8a06e180b3 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1997,6 +1997,22 @@ Sysreg	CPACR_EL1	3	0	1	0	2
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
@@ -2546,6 +2562,22 @@ Field	1	ICIALLU
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
@@ -2956,6 +2988,10 @@ Sysreg	ZCR_EL12	3	5	1	2	0
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

