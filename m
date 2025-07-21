Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467EB2DA743
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103121; cv=none; b=reP1g3pLmsxtizhN5V7dtb19jFYIRsaz4SdBlknHpN6T6CmP3jhfLU/PQ5coPiD7SzfBp8LzRVkcaAh0wnZBWrAUv3V7eEaLFIpHaKS+VYtcg7Jtv9hHY8ybZOXnAdWERQEmEH0XO7RpqGsiQhoLgNyP5VkzC4s8C+Ed6znpqUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103121; c=relaxed/simple;
	bh=nJUr8QBs1Bj7YhbHeTnMBeiABjZ7mfBR47rSyL99+v4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oNUnz03VLMh2GbbaFFSvTLTqkVRVRKvXsmGj2RYjZZTVKIDR5kmTSH+wbqqkiX4/GaUY7/pMIXGJEvTmyxx+sUtYHh8ZPKMcgUAC8KQsn0kkIAgbCXA75NqMfprzPth4OqtxMyeYgkSGh30i50B+BA231X/cS9DoGFC+HDshwyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eB/VTryH; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eB/VTryH"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45618ddd62fso44560895e9.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753103118; x=1753707918; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tni0DswMrCD5TnIk9k/V3+/ZJa/XagFEwHSR8GX4s6s=;
        b=eB/VTryHuTXAQExE7xbSHcUxvTfbwxY4FUVGSMzPEkS0rNXlFdtfI9txrQT63S5ZGY
         nF8ryKeiQsZWqQ+WkLAkYwobucGZEoWkrppmP8c5nGIibHd2XYmmjXb3V7AKgV28SAOp
         eMmfHBkUwnyRVhnGwNuzBuf1RTCIGY0CE/tUiCzOW/+TR7QSZ3F1P9aecqdVXC2Gc7WP
         Tess/a7a9b+8A7GG75cN4Z1M+PsWM5CrFuD70hSEumypX3EOeBLKz1AWqTTpdt0OxPmY
         fxn2XpbocXdec27adcearQ+ibWPg7EnpOFzpqK0KOrFvaCukv2GgTCKHRV2WY+478VWW
         VEwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103118; x=1753707918;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tni0DswMrCD5TnIk9k/V3+/ZJa/XagFEwHSR8GX4s6s=;
        b=S1ELMqbbqY9jbFCT1PZd24Qy8rBhgw689dURD6lnHSKtYLwEJ3rEAhmBYSX6KYoq8G
         HpjqwLkMLzNXQ44RO0nnX/3Rrt7bPv18gbNm5wORfQL5f09qo7s32noTUzjwgaIJak1m
         WEX29qXlVgzd/Uh3dVarhpeuP1nq8nc/oxzsJ+Rsd/qatneisvldeBrOJbmnO44G+CSY
         ERc+FGn7ZZ6v64Cd5Fd9APd9uibWTGEMdzaZpiKz4HFX92uOs3x7MkwqDgq7S3uDCRyJ
         OfSJNco/d7gfKZAmnMmRaE/tNPGxecz5e+5/K9Pi6MTvi2Pz2hh3YhLGYiKZPjwBFWsh
         J/kw==
X-Forwarded-Encrypted: i=1; AJvYcCU2QBmBGeNODgYRJHl7z4/6qY2RAa62xTV2NlIX9HPYj985uwjjFhD//zfR8Y5mA2BCOD2SfUc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8XXCHSaZPHOhH9Dp0OsbH6VzTrw+FB5yPvArUSSLcKrtGnnRy
	jbazfeFRC1lXVWhUPF7WByvhI50WKE3xf4Hq7if/W0uokDxBEvtl5oT+cHjkQ+Zvfoc=
X-Gm-Gg: ASbGnctB2pUFaoleSdEUG9Vn5D02Flm3zJDpjUjZ2vjMoyDjOICSrsZwc9H01FS127D
	PPavsVCkYvE3vg6bZZpfapwh5aqqSB9xzqjyyhu4tO/ipcq+y4U9ss3b0HfwPvuLJr4o06k6W+x
	8R6ZG0lsAVUDjqbQeyJlmVTKL4qa7Vz3BsdnF6YmOQtAcEhh7JpWXE+u/Rj1uTuELwGHb7yuCxn
	OXR1tULP4jalZwGN+xSp78MVWLxqxY4Q8CR8Y1ZX0UWtoaQUAPD5dNuvgEJ7r8xNl0B8tDazyBH
	NoaOLRsBeWppCbl1SwOjoLJkN3OOKXAIYOnvV5E/Y+p1wTZJpswCuMBlhBy6U5IDMonn935VoiK
	prDaDakncYaOmKObCLf/Uzan/szk0BXW4L2xXP3V4LA==
X-Google-Smtp-Source: AGHT+IEbTWNhdSsCoye5ChJxrRKNCcL1bytD0ny/gbd0G1tPqNJCslwd6wNxX0L6BGInIzH8XxTY9A==
X-Received: by 2002:a05:600c:5298:b0:456:15c7:ce90 with SMTP id 5b1f17b1804b1-4562e38a72fmr200645775e9.12.1753103117481;
        Mon, 21 Jul 2025 06:05:17 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c632sm10485077f8f.80.2025.07.21.06.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:05:17 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 14:05:00 +0100
Subject: [PATCH v5 06/12] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v5-6-a7bc533485a1@linaro.org>
References: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
In-Reply-To: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
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

SPE data source filtering (optional from Armv8.8) requires that traps to
the filter register PMSDSFR be disabled. Document the requirements and
disable the traps if the feature is present.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 Documentation/arch/arm64/booting.rst | 11 +++++++++++
 arch/arm64/include/asm/el2_setup.h   | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index ee9b790c0d72..b4f6d487a322 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -404,6 +404,17 @@ Before jumping into the kernel, the following conditions must be met:
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
index 2bb0d28952e4..7c89e0d6e739 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -284,6 +284,17 @@
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
+	/* disable traps to PMSDSFR. */
+	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
+
+.Lskip_spefds_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
 	msr_s   SYS_HDFGWTR2_EL2, x0
 	msr_s   SYS_HFGRTR2_EL2, xzr

-- 
2.34.1

