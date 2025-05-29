Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B5728EBE0
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 11:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518396; cv=none; b=jtmNsJIVwY3QFCyyHiPThVfW3QK4HMGyikCWado8qLzkIVFVus5RlsVDHH16XeLB51v8LeE7Bl8qbqpWyZxSrTdy2NdXSLHzIYkHKoKGJMM28w7JPwXWReOYMhxKfYMTK70S78i+uKASyiZJjwNV36LXkv65rrctrVSi5JKYEeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518396; c=relaxed/simple;
	bh=bhT/vBdY445hdiJGnxyUjZuj2JipKZSpecA8eMwMkO0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qQ8NUMl4N5NBxlPRUWaAxoNCSvehUNJfve68uQfVyz7uSyH1pOe3vJhKdGa/IXrTGnSPM2pjWxQyErn9HMkstpACIOFhDPZQmeDRJV8zOkKwnPumNCXhgzuok5jzgR1CI92lj/1Db7JdZtZMsMoyIP/43ZCIIHrWbmtU+HY7snM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lG+/JlJ0; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lG+/JlJ0"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so5850345e9.1
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 04:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748518393; x=1749123193; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YBh51vvyiyhareusQPjv3Jd+V2PWdf2x4DOb/Anfvgk=;
        b=lG+/JlJ0FcqM0rErvfWa+TsnGv6BMzhw2dO6RLSbDB4rNbc1JNSsbAj7MGY1MF1jTj
         0axEzB5zMe/efHfBpq9HZRwsnPRmGzy4FGrLVw9KTD/uC8a9/J5NIsFcjkYwq8zOHwb8
         usYpbqFcbot0k05n7VxMgyg5sR8cu3qPgTG+MWskkcfWbGsnuiErz+i8NgG5u5qllr5a
         Ix/adPL4Sp5+gEhRi5dEsJZGvU0jtcqJWLw/9S0qFoGQBbovPt+qLsaLBaY3eHzuGx+7
         nm9xeavRsjyiH11IkEpJeBCS74Qi32VBuY19WLgmydDGO3CkEjdR99mNlAwdLx8AfbQi
         cR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748518393; x=1749123193;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBh51vvyiyhareusQPjv3Jd+V2PWdf2x4DOb/Anfvgk=;
        b=EFUP0G66s7CwwSzu17EIhPhfPM/njAntpq7FMtXhqMXkIe/HRjxJBdMcvdMl3aVRog
         Cs6V3X+UlGM/OeIWUKKj3nuKsdnl5k7w7YlVp+2KwcJEaJvsmc0QRPyuawhbHp4OQJkG
         7WYCZFBLD5uQ0w6rVKOzzaeOdqeWFtpi9UVhANLtQ0kXbfE4GU5UebaJ5DE5kiWkiSMG
         j50lxU6bD13TEGVcIzB9HyPFTp1UQx0OcbdS0lxeGws96jzi+KU7k4g5KJNqoUvUGg9e
         F7KyBS2v3nufe8fYXN93HQB4PyA3I+x7LaEI5ABArU1hipLR4cwKPYPihoUOIQCXWdk0
         eBog==
X-Forwarded-Encrypted: i=1; AJvYcCXGpBroOH7zkAEhhKrRPCmfJqtCAiaki/y+NFJ5w5agND9EVs8+oZPeVNdRJ5ULh7ucd74tTQY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzblVk3mJr+OWVQdcPq25MAgpS/ck46qfGU6LstPcF0dkkeTFoq
	P8ipmW71oZ24+gMrAv4GUsN2Y7oD4vqesphbBbb6eLHQ+XxknMRjmKdHbGrmVIAfpXM=
X-Gm-Gg: ASbGncsn5nHR5kxxmqdakNvXRx15eKB/94ZoOI5gvwFtw3XGl/9uCG9MBm6LISpc5qP
	d9SgaFhyyg0xMR30tSYTY90NsxqyvzSE3OhwTFBaiBqT5eHWYW+D0IpFyRg4gTEvNU1B24M/jQm
	2WJsW9Hw0Bvo1e4NIvGyIwCeJXkjbgVMBiNxxfWg3fI9Y9noQ9qOEnvSnfLoO6Ub9KtGaRLfIXh
	GyrDTVUGAdmK5moKcck7Okv1CUETXVJPo5HUpulsch0CALZiPdIxb1N3cEC71wW6/OTBZJEXw5P
	LJM7ekL3Cq+QdMYnPYoz6SX/NvMAjOH599ClqUn3WU5HHuK/u8HwWRPYmoKQ
X-Google-Smtp-Source: AGHT+IEtrMK0+qCLgw3Q1exhgAhuym8fUYhFgSSn+IhOQ2msA1tWH3EQ6muEHr0G05oi7CZJdKSgdw==
X-Received: by 2002:a05:600c:4f0e:b0:442:f861:3536 with SMTP id 5b1f17b1804b1-450ce83c85bmr27386615e9.7.1748518392610;
        Thu, 29 May 2025 04:33:12 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450cfc3785bsm17443945e9.40.2025.05.29.04.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 04:33:12 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 29 May 2025 12:30:24 +0100
Subject: [PATCH v2 03/11] perf: arm_spe: Support FEAT_SPEv1p4 filters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250529-james-perf-feat_spe_eft-v2-3-a01a9baad06a@linaro.org>
References: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
In-Reply-To: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
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
 Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, Leo Yan <leo.yan@arm.com>, 
 James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

FEAT_SPEv1p4 (optional from Armv8.8) adds some new filter bits, so
remove them from the previous version's RES0 bits using
PMSEVFR_EL1_RES0_V1P4_EXCL. It also makes some previously available bits
unavailable again, so add those back using PMSEVFR_EL1_RES0_V1P4_INCL.
E.g:

  E[30], bit [30]
  When FEAT_SPEv1p4 is _not_ implemented ...

FEAT_SPE_V1P3 has the same filters as V1P2 so explicitly add it to the
switch.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 drivers/perf/arm_spe_pmu.c      | 5 ++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2639d3633073..e24042e914a4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -354,6 +354,13 @@
 	(PMSEVFR_EL1_RES0_IMP & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
 #define PMSEVFR_EL1_RES0_V1P2	\
 	(PMSEVFR_EL1_RES0_V1P1 & ~BIT_ULL(6))
+#define PMSEVFR_EL1_RES0_V1P4_EXCL \
+	(BIT_ULL(2) | BIT_ULL(4) | GENMASK_ULL(10, 8) | GENMASK_ULL(23, 19))
+#define PMSEVFR_EL1_RES0_V1P4_INCL \
+	(GENMASK_ULL(31, 26))
+#define PMSEVFR_EL1_RES0_V1P4	\
+	(PMSEVFR_EL1_RES0_V1P4_INCL | \
+	(PMSEVFR_EL1_RES0_V1P2 & ~PMSEVFR_EL1_RES0_V1P4_EXCL))
 
 /* Buffer error reporting */
 #define PMBSR_EL1_FAULT_FSC_SHIFT	PMBSR_EL1_MSS_SHIFT
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 3efed8839a4e..d9f6d229dce8 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -701,9 +701,12 @@ static u64 arm_spe_pmsevfr_res0(u16 pmsver)
 	case ID_AA64DFR0_EL1_PMSVer_V1P1:
 		return PMSEVFR_EL1_RES0_V1P1;
 	case ID_AA64DFR0_EL1_PMSVer_V1P2:
+	case ID_AA64DFR0_EL1_PMSVer_V1P3:
+		return PMSEVFR_EL1_RES0_V1P2;
+	case ID_AA64DFR0_EL1_PMSVer_V1P4:
 	/* Return the highest version we support in default */
 	default:
-		return PMSEVFR_EL1_RES0_V1P2;
+		return PMSEVFR_EL1_RES0_V1P4;
 	}
 }
 

-- 
2.34.1

