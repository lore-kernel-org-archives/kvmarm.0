Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC3628EA4D
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 11:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518394; cv=none; b=NaUgGi3K8Z8XWQBYWO6rTgFJSMRiuGAHBa8+X80kAJ6t/vjkNgAd8Yv48sP0/Pq+fTFMPa0/pQzRejyAkwUUrLSCivxMSSAhFDcecFwuJaz1oodCydburqqtaxDIBqa1lmBvYKQgJLGhXmfnpOfCMjjcYl17SYm427+pr1gAZpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518394; c=relaxed/simple;
	bh=FgznNT9Brk72b5Sn5qJ9KzEFbrY6vz/wN6krkmPDC2U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ipfw1SCa55uYnMRx10PGh9zdW7Ktcai5C2IbLw73yEzppy5+eQmJDAcWJYNWjYq/osCYfz+3o+h3Hhm4Ui5X2kDxpB93K4l19vmr3nP1j6jBueiFn5QwCyLtt+ySz7y7Oqpkb6AC43XrfsaCFPAm22uXyk18KM+pcB1vnvoX8Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lDPZrrX3; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lDPZrrX3"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a4c9024117so618015f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 04:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748518391; x=1749123191; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Ao7OlEh12lpRfhENXnzwKUwXbWabkHGccxknuUI7tI=;
        b=lDPZrrX38yV+H58yjbApk4cjUIBZUd1ece+a5le2xf87jKYy5xG6inON56bVd4QBJO
         duexFeYJgEp4O78aluzvMM/lef3bxJGkvfx3oqqSRMnFm+zwM1wWKWdtj98C0cDSOwYd
         WWi01JKSZVrlYqGIFP38lDz6ET5JXTZgjLv9D2qKPNF8uQCkPQqcmNRBo/+EfbdmIVjR
         waJWZWT1P1NXdVPre0dBHsKEv1Qj3NYcGw1WyW0yI0pibDKSH5oeQmKeb1ntZ+dJMu9m
         tmxtup7+/RHvZEMnubJXNOSFynedGt079CRULaajK5xNKILktpJ9QRNNJNqBAxRsy8+y
         m+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748518391; x=1749123191;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Ao7OlEh12lpRfhENXnzwKUwXbWabkHGccxknuUI7tI=;
        b=b8ZdxUbX7hb/UvS47VCfYtkmQ59SgigcQDUVgew5PgB/miYANoMa8jD67wHUMjm11N
         g5D2vskKnc5ZdUh+9ScUa9UoxL/4+j2v2afS7XpJ4OFW83zlxi+NMzSzNQaj7QAbLnkv
         P2foWgPpJHS0S8ESkHTQf3GVr6bS34QAhZ915KAa8MvcEqW1xbSvLWIlpSwv+Om+V3x/
         LzobRqC0OkLENfTEIG2m/HxFge9TgSeTfYFWyxu4p1vN2dFA3C0JjwclJ2CM/E445LOx
         ez2oorSFNnywxydhhk6dVSeiiv/pTsgEVW4Zdlg0ndTlhIPchT1fayQZ25wCD3k5b2ID
         7UZg==
X-Forwarded-Encrypted: i=1; AJvYcCVdyuqMQ3H7drxvyWbDT4WrA4HIkHfoBaP+LmUzmtDth2ev1MBPTyNqGe7ty7tlmPtbH2kAvQo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWeW8jvxl00izU/WY6UB0gEoEGrvetYXCS0GY341eWkWdtqMG9
	v0PK18TQSOPBdb+8y59UIgNAvuRPW/NtO9cFZnh1iUevUkWfqvk/v7bcoqbtIu+keUA=
X-Gm-Gg: ASbGncvX2igJ/p5Qy5wyHKjSNVf90OTOk5wIxz/Hm/FZ04Qh4DP1QEktMnkGQbyZDde
	h90iDKa0n5PNuBxO6V+U4frTUrGQWpl0Nmk3EHwyDy2UX6ot7hZbukKPLBf2xYQqwRZUQ6QRgVd
	cpmb4dXHcoOAnqAeOe/PNa8UuvH4pjW7dVkyLLeA3HFwxUEn+95N2zK/1vUi/SwsUhdTni9AFY3
	uWOc/gUTPRZKM0lybyrdwWKTCWTHp3377DyRSTG86JI1Yue7lxSbHgu4VqNbdP8aLwyYYoIjLka
	sM0WmcArS4tmP0jTyYj2UX1Q/HCQdg0Jy6IE7JpikN07AdlcSor3adk3i1hm
X-Google-Smtp-Source: AGHT+IGCVcVUkYf0t9hJfA1IEOCLHRWCcVLSmCqfshXf0Ly5nAMyifnx2BqS+BSK2ezf753KYr0JOA==
X-Received: by 2002:a05:6000:2dc5:b0:3a4:db4a:3004 with SMTP id ffacd0b85a97d-3a4eedb8ab6mr2607351f8f.22.1748518391182;
        Thu, 29 May 2025 04:33:11 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450cfc3785bsm17443945e9.40.2025.05.29.04.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 04:33:10 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 29 May 2025 12:30:23 +0100
Subject: [PATCH v2 02/11] arm64: sysreg: Add new PMSFCR_EL1 fields and
 PMSDSFR_EL1 register
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250529-james-perf-feat_spe_eft-v2-2-a01a9baad06a@linaro.org>
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
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

Add new fields and register that are introduced for the features
FEAT_SPE_EFT (extended filtering) and FEAT_SPE_FDS (data source
filtering).

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/tools/sysreg | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index e7a8423500f7..e2cadf224f7e 100644
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
@@ -2311,6 +2320,10 @@ Field	16	COLL
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

