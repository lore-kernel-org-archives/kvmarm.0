Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C9D279902
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 11:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746531758; cv=none; b=Uyy9y0Q75PYzstEgjUqZBd81i3K6PSLSi4exqR9HpN5xfE2ym1VsZ0sdZOzEYpFhipCuayLolkPJrjLaCAoivpG7s7ZF9MSByOnk46Zn8Rl2+2YXFODNhv6g/lAxwJ20hxYAekdSvn5/r6ozpeIhNo+lFOclanV/j2n1ck65J8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746531758; c=relaxed/simple;
	bh=gsVA8ADxmNU5sFAxcN6FUauD6AhKeHsJ1+2Sh2Sunl8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gqWIE9hy77CB2xz95Cv8sSC654ZqrHJtf5NWTmnlG3S9hx1Az8HOhb+8QoUP8iW4ekD9zyM2zgEFzkgmNRURdLkl5W9FKJ1v68Scc8hIiDcvBq1HOb+hZKod6p3vqCwFp2HAsc1P/+9drWF70gmKgi4Kg7Xbv4qGK+ZFfrS+8Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VgBZXeNA; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VgBZXeNA"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3995ff6b066so2627197f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 04:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746531753; x=1747136553; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=61Iqgtu46/FNdhFy61CVblGgsvlOmM6sXXaQm3S4mzk=;
        b=VgBZXeNAcjvdhegKi+DPdiIRfzbD0Yj16ZvQipY7vUUDtg9nuOEE/ol3tYWgIgdEQc
         GGAMGWWzkDnicltuWq/tIWvtBUw+mpyWEh4tteWCAOAUWhgtREP7PqLvqdK1hNPEFO6r
         yOahro8VdJ0FyMQzPmaP3mRJ80DCMxEEbQRiTWlLlbm+uzZt2HpqeIUfhDVYbsBkSb7T
         sIp8o0q8Q4SdUAyrSJW42uV/ZQ2nVG6ikiSdqACHms0cI3TYIvlBcuYymwO1brdauiwn
         VTkTHdU4I/N38isdYhyG0bLmAuCL5lVrGXqyq06hnKsnQe5DuyA/c6fTfMGom0pTzfkS
         2jVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746531753; x=1747136553;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61Iqgtu46/FNdhFy61CVblGgsvlOmM6sXXaQm3S4mzk=;
        b=wkPnw6tpfKoMzRXXGbqzJbDpkAUCPymFlUDyKUwKtIKZbOX8NyMGvyw/4pUcowvhZ2
         M4V/TYCM5qWWDGs11AFXs8G7RnT7w+5aGXdkZt6aC7P/hh9+m89El0U/SunPm9Nv+w8+
         h/1YIiA18MnAvpA0228JbwMzFa/jCzokwhi90Zke+nWLfcgqVW2Uu4CJ82Z2PRi/t7x6
         zzy3G4KQBDhyw43mzv2CJKlJmvIz17cPZqY6m/Rf6PDAwLPfyA7ICa552/4jXpOsWw8K
         38Foay/5jWLkzbEk6EpwmbwzS/zZ4YEA/lpfgVSSL5FlHCYF4T1U+JnNqodmU686uFfU
         Ir5w==
X-Forwarded-Encrypted: i=1; AJvYcCWvzOHNLeFiBlcbwhDaE8nfZfd5Gv2xoSJUu+JSlmCP3wcL/gwQjF7yn/oDPcOJhc0yp9NJuCE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUaPNbHerKJMObtLxkfTiWeO1UBRhqMDdKOcOmbno5gROlVYJc
	RgV38HSkALEJEyD9o/k/DjL6AO0Wak0hLHO1UIFVy3gCggEriksUQYKEP4BBfPU=
X-Gm-Gg: ASbGncvoOtM0QTOA7b0h67/lWNIrZLkgxIutIpgW3hDILn05nxrVF7P+m8y8ZirotMj
	IdYs3Hl1aJeJOYTU8cw2uj0dZgQxKKvZ4kTLVo1pWi+Pk1BIBa7An1YiPqLSfH+Epvl8kiuMUNZ
	tobcFqRyoag0s0CmoAB4Koe+IML4hxNUzgOef2EvRc9CMouGn+aCyiE3fSoYK6VSUkR+DhQ6qU+
	A98ntnqzDHtfMbH3gFyfslgevL9fXLLdQBYu14W7fpuk/3IgWaTg3Ul4dxGIFnEJwGVvcrU8fc2
	rbDIUKL8UhVjVrwbCnZRbeOTcTyNerMWWwBthoUVQMxqWIc=
X-Google-Smtp-Source: AGHT+IGOdg/E7hDqzaYj4d5eAC+LYCA9Y7Nh4kV6qn5WCG2sjJC4tu8qT06CrXeaclDgMwZbgMGuJw==
X-Received: by 2002:a05:6000:402b:b0:39c:2692:4259 with SMTP id ffacd0b85a97d-3a09fd7a2d5mr9000895f8f.21.1746531753539;
        Tue, 06 May 2025 04:42:33 -0700 (PDT)
Received: from ho-tower-lan.lan ([77.81.75.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae344esm13198473f8f.25.2025.05.06.04.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 04:42:33 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Tue, 06 May 2025 12:41:33 +0100
Subject: [PATCH 01/10] arm64: sysreg: Add new PMSIDR_EL1 and PMSFCR_EL1
 fields
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250506-james-perf-feat_spe_eft-v1-1-dd480e8e4851@linaro.org>
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
In-Reply-To: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, James Clark <james.clark@linaro.org>, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14.0

Add new fields and registers that are introduced for the features
FEAT_SPE_CRR (call return records), FEAT_SPE_EFT (extended filtering),
FEAT_SPE_FPF (floating point flag), FEAT_SPE_FDS (data source
filtering), FEAT_SPE_ALTCLK and FEAT_SPE_SME.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/tools/sysreg | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index bdf044c5d11b..80d57c83a5f5 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2205,11 +2205,20 @@ Field	0	RND
 EndSysreg
 
 Sysreg	PMSFCR_EL1	3	0	9	9	4
-Res0	63:19
+Res0	63:53
+Field	52	SIMDm
+Field	51	FPm
+Field	50	STm
+Field	49	LDm
+Field	48	Bm
+Res0	47:21
+Field	20	SIMD
+Field	19	FP
 Field	18	ST
 Field	17	LD
 Field	16	B
-Res0	15:4
+Res0	15:5
+Field	4	FDS
 Field	3	FnE
 Field	2	FL
 Field	1	FT
@@ -2226,7 +2235,12 @@ Field	15:0	MINLAT
 EndSysreg
 
 Sysreg	PMSIDR_EL1	3	0	9	9	7
-Res0	63:25
+Res0	63:33
+Field	32	SME
+Field	31:28	ALTCLK
+Field	27	FPF
+Field	26	EFT
+Field	25	CRR
 Field	24	PBT
 Field	23:20	FORMAT
 Enum	19:16	COUNTSIZE
@@ -2244,7 +2258,7 @@ Enum	11:8	INTERVAL
 	0b0111	3072
 	0b1000	4096
 EndEnum
-Res0	7
+Field	7	FDS
 Field	6	FnE
 Field	5	ERND
 Field	4	LDS
@@ -2287,6 +2301,10 @@ Field	16	COLL
 Field	15:0	MSS
 EndSysreg
 
+Sysreg	PMSDSFR_EL1	3	0	9	10	4
+Field	63:0	S
+EndSysreg
+
 Sysreg	PMBIDR_EL1	3	0	9	10	7
 Res0	63:12
 Enum	11:8	EA

-- 
2.34.1

