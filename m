Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E75A274FF5
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 11:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652237; cv=none; b=GNtd+1QQUN+iQFpj5o4LOxmvBTS232cJe9NrUj+0px6nTFRPA6Jma3dLdPGDbpBHytwVQgZwpgMjg4RUc4ik8ZerbCXPxBEqdCxHw+z9xwY0YMQc5aXwOkan8SvozaVLaDmssAZd6FnSu91tjglcS3skxI9/W16CsyWk+EK57l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652237; c=relaxed/simple;
	bh=+jA3Ncis4HX5+y5SYS2TqC8tE0E6O8ym2X0vV73LTxM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Apy9rKvhTD1zLbFHZ0rKOmBN6Olb5Qhw5s1CzR9cG21glViaZBkYFyZZSoSQHJaa+S2cdx/KphsIxgzBQgFTlCJ9KTPeIYufe9gXLKUb7wmAVkSNmRdOEF81+gaf0+SiyKgb3SKv6fOLC56nHfLVW7MUPUb2ByOi5LMxL9ysXoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wtBMa1uL; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wtBMa1uL"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3b788feab29so1175947f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 08 Aug 2025 04:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754652233; x=1755257033; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XzFFhgGYuB4xjedzO7rx53MXxPvJ8n/ZLwqm/7UkgOI=;
        b=wtBMa1uLBV+LxLmNjobsNEJ1qZPIA46W5QPhw7F06AwFVj2eX1Oa1jpCn75YsXFtwG
         QY+Sa4lmkaZ7u21CKWhwuNgfEXA3O4Vl2ugtcHWLG/Ng2mNgpSvLScblXU8s/Kk5U+II
         +77Ofox5sG56xEZu+omiUGaCEmd6o0cQQOUMJjDfGJVBIo9dARug1HI1Iq2auKew02He
         gd2I8vcE7b6dsWGcjm/16RaZQkzmyvtMP0Um1hkjaoNTE+7F7PCtzWmU72EnXXtBKTqN
         LCPodKi/tEE8qk6UwMCBLPYmC8ja4ZI8HBeLE3B51fxUj96A27jzpjjPxYeDJ6i6zWYH
         qaqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652233; x=1755257033;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XzFFhgGYuB4xjedzO7rx53MXxPvJ8n/ZLwqm/7UkgOI=;
        b=nkbEGpJ2LOz4LCjBc8S9HdN41Zkcoow0xmBb7lI9959MPTA0yTFV2mLOH2YokjEzZ8
         VQTRd20/mAecVMU0ODjDQaDF2NOClvTbSXpOf6+KiQ4urTDxGQ86SgritdYs8V67Kvet
         y+eYJxqoSWpB6tRcWnNQzjHGe5F36cRy1TAfz3lQqGl7YHcETc7Kmbo5M+LOlHcfCCkl
         3W7n12cBwLSQSC/Zr295z5S0bU41VqCwuLMm17IlSXuIGdXQnUDpTlfCU7DIOxk4C3gr
         V3voWkUVNle/N/929Jd9KLmTbhuNpHTS5X9Y1TF+6cg66m1/TAn7N9+aqUGwPzKV25zA
         /IiA==
X-Forwarded-Encrypted: i=1; AJvYcCVmh45b08AzPTujtlv8imRm4sAsOuDnxJvdcIfjQJtTfy1QWzC4+v8dFsSKvcOhEMz0V8wSEqw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNEd5WK6Wa/ph6TUAIidZ8amLHF7o1n913xaATNg+SvvLHOuuo
	AAWQbRc1sFx5UYiRztoPZf3t/z+2ykMzWkqtU+IspA+yjd7zOc2SzBhfIBuxo7k7n18=
X-Gm-Gg: ASbGncu9Qa52GxX4kFgiWoAYUi8QKh9jusuzVrXPE1fx9Etg8YPR/ZvZXGOjVza0sVU
	1eH2SLvcvgvEubifVl3s9PQlpoPkRX4mXPWD6HUuuNnS4MsYXG1L1letBIQBJfiSCOGuDG9lCaO
	g5onZOf7SEH48hxU2NRcYZRG9X6cq1fSb9RRMQdoQC+pDngA/Sl6iHWPc1Df+31+JrKPI5YUen1
	eEjsrgvDuMMUoaZ0pK7CtB0jC2ShXS6kCQfPWF7E+REMnE9yUk8PDsImPF40/VI0T/KqJ9us868
	GU/AlHk7QBnG7HJATNvBUaOGEiwzqt1Ytkg7llxDU8YJF4EoU8f2M7KqHUvSZUNZcaQ8iSbimMP
	Opf1FkZAG37Xx3siRXLznheOLebjVjX9dq8LS4f86NA==
X-Google-Smtp-Source: AGHT+IFA08gaH/PE8BI7LMp8YziJ1EgstGveIjmcsXTetOJTEOPbmTHS6Iwam90twv6fI5T7D1HpPA==
X-Received: by 2002:a5d:64c3:0:b0:3b8:d337:cc33 with SMTP id ffacd0b85a97d-3b900b5026dmr2094550f8f.28.1754652232546;
        Fri, 08 Aug 2025 04:23:52 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45923c34af8sm233482635e9.24.2025.08.08.04.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:23:52 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Fri, 08 Aug 2025 12:23:03 +0100
Subject: [PATCH v6 06/12] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-james-perf-feat_spe_eft-v6-6-6daf498578c8@linaro.org>
References: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
In-Reply-To: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
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
index 3a4ca7f9acfb..a0361ddcdca4 100644
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
+	/* disable traps to PMSDSFR. */
+	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
+
+.Lskip_spefds_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
 	msr_s   SYS_HDFGWTR2_EL2, x0
 	msr_s   SYS_HFGRTR2_EL2, xzr

-- 
2.34.1

