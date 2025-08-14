Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AD72EAB9F
	for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755163564; cv=none; b=mP4Pl3e7SQEY0pIePUTmGbqevgMYIUZ+Kmg5/mf5xwAiZG30EcqDtlftSu2XTjr6j6AEeT8iIQFtifka4UAO039Grq5B5XR+61xKXiVdoh7dCBs7YcMEc5bYCdbRcI7FDU6kwceuz94GK8ImwmaJjP5jiws2HUQyUbfNk480NOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755163564; c=relaxed/simple;
	bh=MJ4HAF1ujEaX4WWG33h1bzdaHdgxbBRIaAA8EKMlhq0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=r2UuHTdipdk2mqoasQE4mdh+LBIC/w57nIdBDPyHXgu5st/QLM+/UEpm7F3gMnO5f8BdBFob0bIcmftuoPzbzlOloT1WihOfm6M2tWVkl1mMepKV9UZAEPb3b2xRGX3tIHMvlm6d41PAZvk5Jozrdg2ScE1t1F1Emu3CGKk0uhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NxEwTqdh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NxEwTqdh"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45a1b065d58so4589765e9.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 02:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755163560; x=1755768360; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wBCwCeMPq8Yt3PwfMa3l8mtDD8QogBIfg4uFSkaUtvA=;
        b=NxEwTqdhTcgVri3u2cfxjydX8x1v0LuD4K0lWa7O91Mx3SRQ3ILjsQk+xON4Ggmhl4
         rMArndKvC8Z84IgKMS4mtvZDpTd1G+KacVOSwBL8CVEw7dOYuVmVzaPi418nIDe2Jzda
         J8wescGmLq1d/AdYbhZGXrO9IAA3GsJogJjBq/LlJCFE/agIwmR2Jreb3ssu2EnJU/K8
         t5APPYLix2KNzUxHljnisZOLScS1/1hzGInF6BLuorEBCn5fx0iGZIQIDapUbauex/Dm
         rLpcxuhdWNqKb07hJcE0e259x2+KK6ubB/FNWz/s2E8/saSJ0M+I5ZnvDV+AbeO9xlzz
         aZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163560; x=1755768360;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wBCwCeMPq8Yt3PwfMa3l8mtDD8QogBIfg4uFSkaUtvA=;
        b=c5DKtHCLVkezQkLxd5LMJmax+u0cRBleQ78Fso8AecQzR28dYjfPpT0VfcZJh56cBt
         WibLEnaYDAAaoCNtRbxWzbrWU8FHkpFWMIgiFDCfb1w44ixmIeIl420gtDGPkh8MATul
         22FY8M4YIBjxLLkudLiR+CfeGceRz0ao4am1e1nqCOgwgWVuWOFUHHE0y/u7qUvFnEHE
         HxMxqPKWAOAIL4novYQxixERnvmV00dXn4+hj5aPUry2OOX9Q03RULy8joB1AKADMzQE
         2WwmS3grxoMBa965loBO1vkd/9BeDp6WJsjVq7pEK/3GlzSSRqcbBGrGc6igvzWFIJpC
         xMmg==
X-Forwarded-Encrypted: i=1; AJvYcCUJTlon0sNfn1t7APuZZa8azJljMC5wZkLA3qk3aim9+8Q9NyjncYA4SMWBFiyrz3Q6d0wmcl4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgkiK4h0iIvUHKHL/Ar1gSOKlPsEliNN/bB0OZjNZQMnulydVI
	BMnAHRtHSR5l/2LUQVf//7BBwRlun0kyvLNEml5w4rXmTSiM1t867zAN5sGWdaIyPmzFfcaY6hl
	NPQKJ
X-Gm-Gg: ASbGncuVMwyFYdEtXO/mveMjxNgB5Kb/qdacymaqb+DaSNsnmnamqyZp85uxqEdwaYC
	OCBaqSS9R0OaJdSv+W+hvv7HeDQD4dLUafp9Y+lCjI+jtoqxsTplCzBlWyHK1cwZcjmYw6yB2m1
	W4f0+wKDhX5CaTQxFLcpzJJ7R3I2fw14puWpearRCG6mCFrs95UjYAgxOr5Y+bTW7xyKWhup/i6
	3WafRD3rggjlGiHs2yIXoHs4asWm4m0KYo6xiUnCBkEIf3k79qw1wEEAdLF+daW+Oq2RH+t4+Jc
	hKmjFkSKh+uituwrt+fEqjxIz5PbfRBwczqZqfvpKo2WnHYMWDEtZ4RNGI2dv0H5y1zrgeIa7nt
	EdmShijXNPWtCRnlpWs9+Qx4giHGeSlo=
X-Google-Smtp-Source: AGHT+IEY/vBBsMat/zDRtGVwETN+EInUSQGpLUXfrAhbT2usXhxgsQh4b8EMvcN2GhmxPcLHpgwORw==
X-Received: by 2002:a05:600c:3b8e:b0:43c:fc04:6d35 with SMTP id 5b1f17b1804b1-45a1b605866mr20364335e9.4.1755163560021;
        Thu, 14 Aug 2025 02:26:00 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c76e9basm14536775e9.21.2025.08.14.02.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:25:59 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 14 Aug 2025 10:25:24 +0100
Subject: [PATCH v7 02/12] perf: arm_spe: Support FEAT_SPEv1p4 filters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-james-perf-feat_spe_eft-v7-2-6a743f7fa259@linaro.org>
References: <20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org>
In-Reply-To: <20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Leo Yan <leo.yan@arm.com>, 
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

FEAT_SPEv1p4 (optional from Armv8.8) adds some new filter bits and also
makes some previously available bits unavailable again e.g:

  E[30], bit [30]
  When FEAT_SPEv1p4 is _not_ implemented ...

Continuing to hard code the valid filter bits for each version isn't
scalable, and it also doesn't work for filter bits that aren't related
to SPE version. For example most bits have a further condition:

  E[15], bit [15]
  When ... and filtering on event 15 is supported:

Whether "filtering on event 15" is implemented or not is only
discoverable from the TRM of that specific CPU or by probing
PMSEVFR_EL1.

Instead of hard coding them, write all 1s to the PMSEVFR_EL1 register
and read it back to discover the RES0 bits. Unsupported bits are RAZ/WI
so should read as 0s.

For any hardware that doesn't strictly follow RAZ/WI for unsupported
filters: Any bits that should have been supported in a specific SPE
version but now incorrectly appear to be RES0 wouldn't have worked
anyway, so it's better to fail to open events that request them rather
than behaving unexpectedly. Bits that aren't implemented but also aren't
RAZ/WI will be incorrectly reported as supported, but allowing them to
be used is harmless.

Testing on N1SDP shows the probed RES0 bits to be the same as the hard
coded ones. The FVP with SPEv1p4 shows only additional new RES0 bits,
i.e. no previously hard coded RES0 bits are missing.

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/sysreg.h |  9 ---------
 drivers/perf/arm_spe_pmu.c      | 23 +++++++----------------
 2 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d5b5f2ae1afa..20cbd9860c8f 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -344,15 +344,6 @@
 #define SYS_PAR_EL1_ATTR		GENMASK_ULL(63, 56)
 #define SYS_PAR_EL1_F0_RES0		(GENMASK_ULL(6, 1) | GENMASK_ULL(55, 52))
 
-/*** Statistical Profiling Extension ***/
-#define PMSEVFR_EL1_RES0_IMP	\
-	(GENMASK_ULL(47, 32) | GENMASK_ULL(23, 16) | GENMASK_ULL(11, 8) |\
-	 BIT_ULL(6) | BIT_ULL(4) | BIT_ULL(2) | BIT_ULL(0))
-#define PMSEVFR_EL1_RES0_V1P1	\
-	(PMSEVFR_EL1_RES0_IMP & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
-#define PMSEVFR_EL1_RES0_V1P2	\
-	(PMSEVFR_EL1_RES0_V1P1 & ~BIT_ULL(6))
-
 /* Buffer error reporting */
 #define PMBSR_EL1_FAULT_FSC_SHIFT	PMBSR_EL1_MSS_SHIFT
 #define PMBSR_EL1_FAULT_FSC_MASK	PMBSR_EL1_MSS_MASK
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 369e77ad5f13..86c9948ab5a0 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -89,6 +89,7 @@ struct arm_spe_pmu {
 #define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
 	u64					features;
 
+	u64					pmsevfr_res0;
 	u16					max_record_sz;
 	u16					align;
 	struct perf_output_handle __percpu	*handle;
@@ -697,20 +698,6 @@ static irqreturn_t arm_spe_pmu_irq_handler(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static u64 arm_spe_pmsevfr_res0(u16 pmsver)
-{
-	switch (pmsver) {
-	case ID_AA64DFR0_EL1_PMSVer_IMP:
-		return PMSEVFR_EL1_RES0_IMP;
-	case ID_AA64DFR0_EL1_PMSVer_V1P1:
-		return PMSEVFR_EL1_RES0_V1P1;
-	case ID_AA64DFR0_EL1_PMSVer_V1P2:
-	/* Return the highest version we support in default */
-	default:
-		return PMSEVFR_EL1_RES0_V1P2;
-	}
-}
-
 /* Perf callbacks */
 static int arm_spe_pmu_event_init(struct perf_event *event)
 {
@@ -726,10 +713,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	    !cpumask_test_cpu(event->cpu, &spe_pmu->supported_cpus))
 		return -ENOENT;
 
-	if (arm_spe_event_to_pmsevfr(event) & arm_spe_pmsevfr_res0(spe_pmu->pmsver))
+	if (arm_spe_event_to_pmsevfr(event) & spe_pmu->pmsevfr_res0)
 		return -EOPNOTSUPP;
 
-	if (arm_spe_event_to_pmsnevfr(event) & arm_spe_pmsevfr_res0(spe_pmu->pmsver))
+	if (arm_spe_event_to_pmsnevfr(event) & spe_pmu->pmsevfr_res0)
 		return -EOPNOTSUPP;
 
 	if (attr->exclude_idle)
@@ -1107,6 +1094,10 @@ static void __arm_spe_pmu_dev_probe(void *info)
 		spe_pmu->counter_sz = 16;
 	}
 
+	/* Write all 1s and then read back. Unsupported filter bits are RAZ/WI. */
+	write_sysreg_s(U64_MAX, SYS_PMSEVFR_EL1);
+	spe_pmu->pmsevfr_res0 = ~read_sysreg_s(SYS_PMSEVFR_EL1);
+
 	dev_info(dev,
 		 "probed SPEv1.%d for CPUs %*pbl [max_record_sz %u, align %u, features 0x%llx]\n",
 		 spe_pmu->pmsver - 1, cpumask_pr_args(&spe_pmu->supported_cpus),

-- 
2.34.1

