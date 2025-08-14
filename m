Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490E52EA469
	for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 09:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755163561; cv=none; b=sWnBeqPyr2wz+DW8luMhBPmBxEJVMw2nN6UerJVBeQLhZS8Ol6/H8M8FpQvc8zISNVsrjkrUYpbDYJzdcElTo+rDv9IVu0oREZzHWkNM4pT5rB5OOouoknjJ/2sTHvh/N2A6mEkOwcIE2L9BGqchLFMhphUYNRFBaS6zi4LGPa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755163561; c=relaxed/simple;
	bh=51vdVVrDG2YLBYS3Pf8NCD6LBuxxPOs+8V116Ol8P34=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NEa22gPp5azqcs9RoIbyPouAlE/VOsIlUTV8N1sxcwmjPQBSU71tzD34HRQVIh6rP5AQVBdLzYoUsFYxBuRhbIGyEn9Xv/dLoB4qsyoHcG7LykwYChN0q5b/dWKiSKBH7NggHAlTcsxdbAguPWUOtNbk3VRkgST9FPv4Gk/6LPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dEkMxIxZ; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dEkMxIxZ"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a1b00f187so3142235e9.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 02:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755163559; x=1755768359; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CE9jiANI0cz/l/cDSr25IEHnZ3OQaeUcRCYLlwFZaDU=;
        b=dEkMxIxZJvxak/fBP/Wg3Q0dtD9ipsnPtmfEisdq0OTpBO625y4xvSc3DRR+m1KPI+
         81c52GU88fxrm844a+gEhNkc4Az0GTunGNFrNeeisfP111M4b7VNt/VjN5ltQEGPPymw
         +h37KcGqszK9Bf40nPfcpgczYA9pQT5m/vODC0+0hVpyyDvI6Nj65PRD08lX7QjoylIF
         O3MQki1Pp5lPOJAM22atCyaQ2O5uut+HcKtVUj8L9lOID0vM/+XIgtQA7UzqN/69NOCX
         kkVvt1zDtudmcUhBZP1XEBpPwUPU0MTgtoLoe6Ya1JrHgn+T39gxGpASmREQo4KZDNsZ
         721w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163559; x=1755768359;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CE9jiANI0cz/l/cDSr25IEHnZ3OQaeUcRCYLlwFZaDU=;
        b=CxhIofhSX2J/zvuK1xNERiN4E2VdZxsWSLcTV3lXv6LvYwtRCLbnFNFAzK3EyAKxri
         8JR23QodPFCjqJ3fIHYPz4h0Gqbp3Cg3qZBwxQW9KlsCWYaISIZ254UNaplBQqeK14tL
         HPCEl24BJHHv/My9C7Z3PryA19MW/KPCuku2QjdHM2ct8tJIn2APWKa3ylPcseSNXdwB
         cFYwJ1MRgfwwDkdSqSNTOB/PcdIgSd7NJR+iVlHP7cfYZ/wmI2MCm8o+TRMgW9RMJeFP
         9hJ/XNoMm1rGWCqymsFa3C0CVnZLvwvaCk3+3il3/ews8JPgJhe3Lz8QRKopFzZmIqx8
         3feA==
X-Forwarded-Encrypted: i=1; AJvYcCUgU45zr5hAv4Q8YVzEIbEuZC2mh/bOL9iUdOqROvTZkI0qVdKX53jwjXLtKCZQywOAQ4hou6Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YySy8X3iEYLPUouTXOoTvcAsK2lp2vc5dWhw+hRtQzQrklVHegc
	pT5u8tlgOZ98XKXZ4TEXOmIiD9zfZuZ7l18vALbKzvsuOwYajvyQomMH2HtmC5lpXKKTkvSJNIZ
	bC/xj
X-Gm-Gg: ASbGncs9xvlSk80ozjChRRHpHgcnh1zlyky4IOjdp7evBhVcNzLHvcFj9VvVYlt8RE/
	AkL3EeUvwXfymfyNzSQWZjlcWtTx/2LZy/nHOv/DOyaJVRhabJErBjrE5buXV/Wm2DyV220PsNm
	0k3ImSRJ8yjF4t033d41j8yvcgAoEVGXKrUki8MYvePu/XRR3/BaGZ8G6QiVwPH9GLYZUDva8P4
	ZGmbkWB1k4CMvMUQNQt/SVG9EPhonkHGt0qABgyWwitdGDpWABw0bdonhdbIqtSwqIwL+I1bAqf
	7w1mUT0ycgv7LKiBHVmsrCV/80SNRIrXxNRQsgia1n3S1+8twRFa8/gqIPTLVH3vjELzrFUXDgw
	wDXQPtMmWUcM/4oENPIaST1SkMl2UPhA=
X-Google-Smtp-Source: AGHT+IH3aH4s+NYnAVYfqbXpSrP1ix9p1QHXe6mSxBCrVv3jDGybUKX6JctDT3xmTAkJSTP0/FwOIA==
X-Received: by 2002:a05:600c:450e:b0:456:496:2100 with SMTP id 5b1f17b1804b1-45a1b6753a2mr19666565e9.31.1755163558609;
        Thu, 14 Aug 2025 02:25:58 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c76e9basm14536775e9.21.2025.08.14.02.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:25:58 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 14 Aug 2025 10:25:23 +0100
Subject: [PATCH v7 01/12] arm64: sysreg: Add new PMSFCR_EL1 fields and
 PMSDSFR_EL1 register
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-james-perf-feat_spe_eft-v7-1-6a743f7fa259@linaro.org>
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

Add new fields and register that are introduced for the features
FEAT_SPE_EFT (extended filtering) and FEAT_SPE_FDS (data source
filtering).

Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/tools/sysreg | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 696ab1f32a67..b743fc8ffe5d 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2994,11 +2994,20 @@ Field	0	RND
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

-- 
2.34.1

