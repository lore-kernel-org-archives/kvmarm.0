Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2282C3314B7
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756730521; cv=none; b=GltsCSTK3dvtsM/snrluWE3mdnqimf2hNnaTtQXbHgGErTDCoHbf+IBt5iEzLX+kbhpU0fmnj4yWo7H0SdbOMWxYuUrDpodpFeLKBPy9S8dWe411Kh6qiEjzUy/lgMj88TDwcYUvHKAUhmz4+4Vx23i+LCVwnD8N80F8O57UOTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756730521; c=relaxed/simple;
	bh=hHJpIJlIFEz6CSYyOaizP0+u4TVXaro/PALZLQfLUyE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LL+Eg8UpW6N+0yNym49dDYuYn2E4OpGCex3HRM1e8qH7APcgRETjc9dGFrIEL4JS+pXJ8A7NJjcIz2c5+x5FtLlhA8U/Mnxfkn+41xkYsbhgc9IW59iF0RXoxJMs9jCyVwu0ytIVUwxwP8O77Mt3bSQwNZsVr61NV8bUuNMQNBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HHlqGsG5; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HHlqGsG5"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45b7d87b90fso27015085e9.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756730517; x=1757335317; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OSNn3QEar0+QuKyDmtURSQ4BVOB8JOPxQiblvR548LM=;
        b=HHlqGsG5EDNsG/HLzYyIbqLUbb2YgjSkL4qUsKrCCw/4UMcqMbH9Wx53ZrlCnxhA3X
         1NfRuZY4YQAZrUB4sdjeFCQyzbGD2OqTEYBsMsD5zTCXVM8WmHLVT5QdjmFNWE1M+1GP
         dDTot1wMZi2Ty2mht1mSq8E1jfqTNlqnyazmlnBk/fRz/qeAtJRzQ6627RtxzwMYYcgn
         qIJxnPJeiHDIb7TZ6UIwp83Lb6mVRcb/FHOG4ttRxFwIMKGNowFYgrw25Y10Zv5ScxM7
         XcbjzYNNwwwIrLbaevAvh3cfh8ycBaGcVvw5hKWoNtuzzyRo/KU+WLKcG2OlRIZ/Fh2a
         vT4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756730517; x=1757335317;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OSNn3QEar0+QuKyDmtURSQ4BVOB8JOPxQiblvR548LM=;
        b=HqyffWIXi63+a3NOkIpwrJPtT/kg3vVEJ7Q6fNv4gDs6l2A5mzC4jlyaGjPXLm3qjW
         o/qPwmchD16uwEVQpbzDoOIv49gxx7ga+QF6O8ecdYIpTFidYiVia9cTK8ghcIYCfwaP
         pc7er9zHWqKrYP1PXnIJyRxpd3z0QwuttqcUpr0MLC4hDl4k+lM1TTajnY/JviWCHHZH
         Sks9wGO3oLbzHWTG+kyaB4lFHs3k3z41vpeczYz1tEtU7ep2zgWZMZ8GwMuoNzuWJn9M
         PPb3KW8Z3UXm6wmORm41+KY7oD9esUrO4B/NEownBgCS+NWqmI+uPfojDgHQwcxoXZHV
         ZtzA==
X-Forwarded-Encrypted: i=1; AJvYcCXsJjZ3mzzYlcrNdWcGoz/UR97ofkT3wbfRZWNcQu6DRPwxSnEQgoyCgAJSE6q2lcyfuDVXiDw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7ToDGZy5uHU3U16Hqnq4ruaI7pFPBPxGALzYot7fZEsCcSzhA
	D4uTIcOmCP8CPf3rAxZJG7D9f0j4DQUeJnBI820y46xCV0RhJE6kGzLJ8xaPWq6cQbg=
X-Gm-Gg: ASbGncu8SwYojPtofru7ZeIy+J8y0XYvQd5X/DKhwhb+9g0CglYm6jHbfnGYL+Ipz8R
	y576SIA5Xwm1C4UyrnL/JlHV4m8CdjYpc3OX5g2jHjZ9vd6Z7b6XwTbvHtU4HvtR9bI8K0tsI+4
	8h24I6SiJeoM/g+oeWrd2e3s2MVULAG5op4DV4gZV4/VH335czgaxREe5AiQBtDLzssDrF7zWlR
	yg2aUUwYykqsZDADgShfC4GI3cnuJair6Xa8GNC7liNejF05ERq6LZuA8mpfV3pEmVoyHKytJgY
	UHe9576xNS2iiYm802kyZf4JHlCoIjen6/Mpygevtc4CILR1RAouVCZ/vd2ckgqWAECk6mxBUIQ
	JIn/kB9NwZDdFATPPYGjPoa0JwDRgGWyqdsRl39o8ZjLlYAdEpmcw
X-Google-Smtp-Source: AGHT+IFhQWkNlLbN+/KIksY266G8T+wNBjSFtPM3Dq8DGWiTprcVcLD3OEdLOpKY4eMNn6tRYHKpVg==
X-Received: by 2002:a05:600c:810c:b0:45b:92a6:63e3 with SMTP id 5b1f17b1804b1-45b92a665f4mr3191135e9.9.1756730517057;
        Mon, 01 Sep 2025 05:41:57 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm154946315e9.19.2025.09.01.05.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:41:56 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 01 Sep 2025 13:40:35 +0100
Subject: [PATCH v8 06/12] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-james-perf-feat_spe_eft-v8-6-2e2738f24559@linaro.org>
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

SPE data source filtering (optional from Armv8.8) requires that traps to
the filter register PMSDSFR be disabled. Document the requirements and
disable the traps if the feature is present.

Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 Documentation/arch/arm64/booting.rst | 11 +++++++++++
 arch/arm64/include/asm/el2_setup.h   | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index 2f666a7c303c..e4f953839f71 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -466,6 +466,17 @@ Before jumping into the kernel, the following conditions must be met:
     - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
     - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
 
+  For CPUs with SPE data source filtering (FEAT_SPE_FDS):
+
+  - If EL3 is present:
+
+    - MDCR_EL3.EnPMS3 (bit 42) must be initialised to 0b1.
+
+  - If the kernel is entered at EL1 and EL2 is present:
+
+    - HDFGRTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
+
   For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
 
   - If the kernel is entered at EL1 and EL2 is present:
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index a305386eb2e3..b37da3ee8529 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -392,6 +392,17 @@
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
 .Lskip_pmuv3p9_\@:
+	/* If SPE is implemented, */
+	__spe_vers_imp .Lskip_spefds_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x1
+	/* we can read PMSIDR and */
+	mrs_s	x1, SYS_PMSIDR_EL1
+	and	x1, x1,  #PMSIDR_EL1_FDS
+	/* if FEAT_SPE_FDS is implemented, */
+	cbz	x1, .Lskip_spefds_\@
+	/* disable traps of PMSDSFR to EL2. */
+	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
+
+.Lskip_spefds_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
 	msr_s   SYS_HDFGWTR2_EL2, x0
 	msr_s   SYS_HFGRTR2_EL2, xzr

-- 
2.34.1

