Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2947C314A8E
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756730515; cv=none; b=q9rseI4oTJ8wWRTs0PwPaW40yzba/v7G/KLDg42DKVj92bhgs1QP6+IosDQyc1uu+v3RXWX99Tcw+PFTHSKjgMNSf2GKQwNWMi4EoewbNCnOJpnAAP4VoH/qahhpQzFOpYu4yjAl76/41ZGw0ls0fwnjgAAMSsXRkbdA2AoLaAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756730515; c=relaxed/simple;
	bh=u8t6+Ai5818q2OqeuPRlI3lTIu6X9MGrpK8W6uKLv4M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aaw9H8I3YyOw7Tqi1Vk3JH9mltmov5XVgiUCIHQ2pZ/AYUjVp2TQfU35pIa0aoKpaa426uYxCKFAsLG7zFxWiQ9MCML0e4K1DSpMyHP1i5iRzResQGAyja6U1cZnp6N8Pc6Ta0nNWlpc8+zCnwZzmJx7nm3T45cKcFbhssmQls0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DgUOyiBz; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DgUOyiBz"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ceb830dd58so2298057f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756730511; x=1757335311; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GZZgvWpkzzBr+nwBCDJ3J4f7oxmGZr0r5wi9QRbWfI8=;
        b=DgUOyiBzLQN3jy7x3JrEEOaf9RwWhC2iS5yDzxm4RPfoo0qS7aY385T+6Wm6IS5X59
         f8hVcAU6GcwWSqM9CUJ2H5mhrvUzvaVvJ9ujScy0kUKi6UGQsSJPmZPymaZ0H9eVC/sH
         lISBGNsuCNMMwPM5DteIPrOf5XUvoCaadnw2Hyl3rGPj0/BaG9YBkWvU7VT0LS1c++HA
         t6I4WR2vyyceRQ7In2c1muBCCqQpX3hxdqc5krHpSjLb4ujwFZhkT/9sbcrtCkcGOAKZ
         mqLn5VgrzHcqiGHVjPx38F6CRPZm1c9D/O5QQVVOcvOLgPXI869e8LLL6Q+TZ4I4gAPa
         ipdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756730511; x=1757335311;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GZZgvWpkzzBr+nwBCDJ3J4f7oxmGZr0r5wi9QRbWfI8=;
        b=YIAjU8Q6NdX4c23+WO2Toldx1jVCu6D5a+mpP6IUGuppGIqpzm6tjy7e6AuQLcvCfi
         s0junqwr+KKwGgg+85PpBMoEyInSgMWsVxG/GHtyuOQWHrfpGMIwwV/EwZx5sBrbh2wH
         nO8LruowA3TIyoGbfPTI93Mb4U5nQlUITxoVgxF/gF2kmiE0e5BjSHU2zi/TxV8e48KN
         q/0ay5hIDc0eeW977hmq7zIBpZ76B53coCgCO37mZhzVleIDj7FsziSfyI190I5+TFp2
         pSlZJOIssySw8FSck3Xd4IjEoxYS4yDN5Bbb7Yf3LY0+rg8j4k9iR1YPzDuRjMulSd1w
         585Q==
X-Forwarded-Encrypted: i=1; AJvYcCUt2oqUIo+yRuiFs8tKVDCUWhp+nxpKaKdb30sJtWLgpbLji8X7rGLEf9dFpZCEE0vvzhsWeLw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzezo24fIUULyLei2t6Xpb4QkmFEsyr4icfxKw9kttJKuPh6vnw
	qacRQIdGHRzdrpXu+JTst99u8Aar/dK8RbHs/SRfzBgLoqkB5vUmQ6zcYH0TNm/npWg=
X-Gm-Gg: ASbGncvadItdW9mUH6WQeyEeEBRtOKesfLg7NyeDlwYjtg6kmw79gFnfv/oW4wlmprc
	9DXuPTvCOuXYb7kr656F6BSyHLghhc5aIt0Al24moJExSIihASEC12xagzRre65jTfCBWo7Mby1
	Ncgrbyp/fTrM1gP5v5GP5hVvlJmPQtsxHqyYBYr1lINVmKPoSqri38zoBZg3Eh6zF1kIEhwHXO4
	DN/0vzymT0O7ULc8zRwTfvxyPQIkqO38jprxN0LF7OGIES0wnnucwsiZZVSkwesjxLHwN7lbPxB
	b9llQ/f2n/PfIxT7EQSCBidiyVWbZ77+/b0uJecbNRFbLNK6mYY6P8neIeyuSgBgTtF8x0FJzmF
	lwwpbN5wj5A/UsyFwYe4w+jDWnhqyKFc=
X-Google-Smtp-Source: AGHT+IHOmsUvkIOzZdpZGUdJ8+tog1LZQ1DvZke4oaEKX68EXOiUCozD6kPp0FykYmEdPI7ixAJleQ==
X-Received: by 2002:a5d:5d0d:0:b0:3ce:5696:39f1 with SMTP id ffacd0b85a97d-3d1b1af1fc2mr5785396f8f.22.1756730511229;
        Mon, 01 Sep 2025 05:41:51 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm154946315e9.19.2025.09.01.05.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:41:50 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 01 Sep 2025 13:40:31 +0100
Subject: [PATCH v8 02/12] perf: arm_spe: Support FEAT_SPEv1p4 filters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-james-perf-feat_spe_eft-v8-2-2e2738f24559@linaro.org>
References: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
In-Reply-To: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
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
index 6604fd6f33f4..2cf7f30b0d4f 100644
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

