Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D274628ECE6
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 11:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518398; cv=none; b=laKO0nVhjjC+BCttkMLN564pqgYaV2fT8KaBhzp+gF1Dzq570GcV4AwLk7xXLSot+or2rCfFtfeVmjd/rV/R9xaRmhJ9ottmcOen8HNjb7cqpQEZzJOlNMpg/dFLDNDBSqbEc4fttinPAa0n2dGL3NrXcgHRvutO/K9RrvdUZAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518398; c=relaxed/simple;
	bh=JLw1SbFI9hf2HJHhhd0RjbsrbancA+Y8QFfWRVSOicI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JnzBvesy/urBmL5in2IncNPdjtXCDyEEs3LhKwqtsSVwKk4kKUvqYbRn9YYUI/uMWYqJngRbYxOO8+40iJMYjMuCwsbJXVC19OBQ2M2kU35psaeGXicjS0vmKOVCVJslbNkKfPFQzPnzoLzdfKfKAs0SXG+cqTzliPq4Y7OUbFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cWIKQTkg; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cWIKQTkg"
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-43cf680d351so12632465e9.0
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 04:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748518394; x=1749123194; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfKDbgxKd2ROJeUv6l7PkfuDFl5ROKG8g8tB4U0lR18=;
        b=cWIKQTkgReO/fnGjnL2yOMQW3lM1mYjrMZLCzXWzyaswYHg70Ew808BLjKR7LERlD3
         UjgGoYH/Vu4fAsAyE0cuHH2TT5EeMYO/mba0GnGFHHZHYs0IhESW11I0ijLLqFdNk7Nl
         NVFmGKDkLyADOLoc8Q+5/UsB7XNQsOhsWVqL14xQNFbL7FM+BZW8YY7VOy17bDxXE+vN
         9IjhEC8EZjQU+kzyEHYanTUeVnRVarz/4xgFIpBGB/3zhOZokRqZOL9uwq02Fz60v7Qh
         Iei33XbAV7L7bwvOvWps6XBwUI0eNSibqAXdzlsQrQNTk/Q1uH6/5d3a18USnGjG/4jh
         5fqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748518394; x=1749123194;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfKDbgxKd2ROJeUv6l7PkfuDFl5ROKG8g8tB4U0lR18=;
        b=rEaDuS6V6CoDUimKQ55gO9iiybJIAog2x8WFrw6vX2ymtxK62OS7+zLEiY76L6bZ+p
         k+aifHz3ipcVdwK288HoCdnUlRH1QQJq8Fy3JF1o0DNgCdWzxR94EykyvqYDYq2PG3Sn
         n1sNIvwgNAEE4ckI0l7Tz2K45oYbGmUbVhfxa1CLRu11Hgjt+zoYmNiEBMxFFZHWlycc
         HR1d8i6js4HNuxqbx5nRt+uxtELtbY+3rS78Ho62sjouv8/TVIrKpDrt9ZflDZ6vqGcv
         fagdgAV5lWQOnqluqwy8mx7I5497d9QgQLquxKF0ArsxZYX+oQUzwGKIbe6T8AF0VD4f
         uk5A==
X-Forwarded-Encrypted: i=1; AJvYcCWWgq9dA22C65Jtt5DD2OYokcsdfr7T3/twiqwAQ6KhJw4j6/YIPKYtFz2cAjKee9vfUysDhFQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxzylc2QvWFDD/7oTnUWDdsXUVtzJ2tmJtZWiDh7eM1eTxaUMAM
	yKqjDzQaSHxjLxbFJ+yAqpRQB5K13zQ0eHe3TJSU52d3ro11y64lw53Om2qPIIVkUdI=
X-Gm-Gg: ASbGncsQcnR0nx8SYYFoHf/8ugWdgt1DMi0OL8oEG4OQaN/kKbck5KlfhGN4rjnBuM6
	E7m4vGVbZOzd8qqdqsm4bLq7KdM/dZ3TwP47xXijbsO4ZugXH8XfI6z4pmJColhUOYnaraJaFAY
	lF9e1b+I+1e86CbB9OjuNOSvZAAjC2K1LejzLv5TYrlLdeHbPMoaMhOeIKuPHhHnIEmTDY3tikv
	O2MLJDwkcD5sNWzMAsQN9s7OO38Kliuy4BksrGtwBnHf1+Hlfmezt3ETSoKbYZD7M51jPpDSslS
	EksFHp0AAhle0WMWl1f8JynxIAz+/YUvjt9Rij+tUHNwQ6Ps428TXljOV5MA
X-Google-Smtp-Source: AGHT+IHSPmk4fOgPDFLIZtWqcVjzQhEo6i8WE5FJ9ZlisuotXu0mllwIX71So8rjCmQxGTK63Cn0Dw==
X-Received: by 2002:a05:600c:4649:b0:43c:ec72:3daf with SMTP id 5b1f17b1804b1-450ce88aa5dmr21155125e9.14.1748518394056;
        Thu, 29 May 2025 04:33:14 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450cfc3785bsm17443945e9.40.2025.05.29.04.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 04:33:13 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 29 May 2025 12:30:25 +0100
Subject: [PATCH v2 04/11] perf: arm_spe: Add support for FEAT_SPE_EFT
 extended filtering
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250529-james-perf-feat_spe_eft-v2-4-a01a9baad06a@linaro.org>
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

FEAT_SPE_EFT (optional from Armv9.4) adds mask bits for the existing
load, store and branch filters. It also adds two new filter bits for
SIMD and floating point with their own associated mask bits. The current
filters only allow OR filtering on samples that are load OR store etc,
and the new mask bits allow setting part of the filter to an AND, for
example filtering samples that are store AND SIMD. With mask bits set to
0, the OR behavior is preserved, so the unless any masks are explicitly
set old filters will behave the same.

Add them all and make them behave the same way as existing format bits,
hidden and return EOPNOTSUPP if set when the feature doesn't exist.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 drivers/perf/arm_spe_pmu.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index d9f6d229dce8..9309b846f642 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -86,6 +86,7 @@ struct arm_spe_pmu {
 #define SPE_PMU_FEAT_ERND			(1UL << 5)
 #define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
 #define SPE_PMU_FEAT_DISCARD			(1UL << 7)
+#define SPE_PMU_FEAT_EFT			(1UL << 8)
 #define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
 	u64					features;
 
@@ -197,6 +198,27 @@ static const struct attribute_group arm_spe_pmu_cap_group = {
 #define ATTR_CFG_FLD_discard_CFG		config	/* PMBLIMITR_EL1.FM = DISCARD */
 #define ATTR_CFG_FLD_discard_LO			35
 #define ATTR_CFG_FLD_discard_HI			35
+#define ATTR_CFG_FLD_branch_filter_mask_CFG	config	/* PMSFCR_EL1.Bm */
+#define ATTR_CFG_FLD_branch_filter_mask_LO	36
+#define ATTR_CFG_FLD_branch_filter_mask_HI	36
+#define ATTR_CFG_FLD_load_filter_mask_CFG	config	/* PMSFCR_EL1.LDm */
+#define ATTR_CFG_FLD_load_filter_mask_LO	37
+#define ATTR_CFG_FLD_load_filter_mask_HI	37
+#define ATTR_CFG_FLD_store_filter_mask_CFG	config	/* PMSFCR_EL1.STm */
+#define ATTR_CFG_FLD_store_filter_mask_LO	38
+#define ATTR_CFG_FLD_store_filter_mask_HI	38
+#define ATTR_CFG_FLD_simd_filter_CFG		config	/* PMSFCR_EL1.SIMD */
+#define ATTR_CFG_FLD_simd_filter_LO		39
+#define ATTR_CFG_FLD_simd_filter_HI		39
+#define ATTR_CFG_FLD_simd_filter_mask_CFG	config	/* PMSFCR_EL1.SIMDm */
+#define ATTR_CFG_FLD_simd_filter_mask_LO	40
+#define ATTR_CFG_FLD_simd_filter_mask_HI	40
+#define ATTR_CFG_FLD_float_filter_CFG		config	/* PMSFCR_EL1.FP */
+#define ATTR_CFG_FLD_float_filter_LO		41
+#define ATTR_CFG_FLD_float_filter_HI		41
+#define ATTR_CFG_FLD_float_filter_mask_CFG	config	/* PMSFCR_EL1.FPm */
+#define ATTR_CFG_FLD_float_filter_mask_LO	42
+#define ATTR_CFG_FLD_float_filter_mask_HI	42
 
 #define ATTR_CFG_FLD_event_filter_CFG		config1	/* PMSEVFR_EL1 */
 #define ATTR_CFG_FLD_event_filter_LO		0
@@ -215,8 +237,15 @@ GEN_PMU_FORMAT_ATTR(pa_enable);
 GEN_PMU_FORMAT_ATTR(pct_enable);
 GEN_PMU_FORMAT_ATTR(jitter);
 GEN_PMU_FORMAT_ATTR(branch_filter);
+GEN_PMU_FORMAT_ATTR(branch_filter_mask);
 GEN_PMU_FORMAT_ATTR(load_filter);
+GEN_PMU_FORMAT_ATTR(load_filter_mask);
 GEN_PMU_FORMAT_ATTR(store_filter);
+GEN_PMU_FORMAT_ATTR(store_filter_mask);
+GEN_PMU_FORMAT_ATTR(simd_filter);
+GEN_PMU_FORMAT_ATTR(simd_filter_mask);
+GEN_PMU_FORMAT_ATTR(float_filter);
+GEN_PMU_FORMAT_ATTR(float_filter_mask);
 GEN_PMU_FORMAT_ATTR(event_filter);
 GEN_PMU_FORMAT_ATTR(inv_event_filter);
 GEN_PMU_FORMAT_ATTR(min_latency);
@@ -228,8 +257,15 @@ static struct attribute *arm_spe_pmu_formats_attr[] = {
 	&format_attr_pct_enable.attr,
 	&format_attr_jitter.attr,
 	&format_attr_branch_filter.attr,
+	&format_attr_branch_filter_mask.attr,
 	&format_attr_load_filter.attr,
+	&format_attr_load_filter_mask.attr,
 	&format_attr_store_filter.attr,
+	&format_attr_store_filter_mask.attr,
+	&format_attr_simd_filter.attr,
+	&format_attr_simd_filter_mask.attr,
+	&format_attr_float_filter.attr,
+	&format_attr_float_filter_mask.attr,
 	&format_attr_event_filter.attr,
 	&format_attr_inv_event_filter.attr,
 	&format_attr_min_latency.attr,
@@ -250,6 +286,16 @@ static umode_t arm_spe_pmu_format_attr_is_visible(struct kobject *kobj,
 	if (attr == &format_attr_inv_event_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT))
 		return 0;
 
+	if ((attr == &format_attr_branch_filter_mask.attr ||
+	     attr == &format_attr_load_filter_mask.attr ||
+	     attr == &format_attr_store_filter_mask.attr ||
+	     attr == &format_attr_simd_filter.attr ||
+	     attr == &format_attr_simd_filter_mask.attr ||
+	     attr == &format_attr_float_filter.attr ||
+	     attr == &format_attr_float_filter_mask.attr) &&
+	     !(spe_pmu->features & SPE_PMU_FEAT_EFT))
+		return 0;
+
 	return attr->mode;
 }
 
@@ -341,8 +387,15 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
 	u64 reg = 0;
 
 	reg |= FIELD_PREP(PMSFCR_EL1_LD, ATTR_CFG_GET_FLD(attr, load_filter));
+	reg |= FIELD_PREP(PMSFCR_EL1_LDm, ATTR_CFG_GET_FLD(attr, load_filter_mask));
 	reg |= FIELD_PREP(PMSFCR_EL1_ST, ATTR_CFG_GET_FLD(attr, store_filter));
+	reg |= FIELD_PREP(PMSFCR_EL1_STm, ATTR_CFG_GET_FLD(attr, store_filter_mask));
 	reg |= FIELD_PREP(PMSFCR_EL1_B, ATTR_CFG_GET_FLD(attr, branch_filter));
+	reg |= FIELD_PREP(PMSFCR_EL1_Bm, ATTR_CFG_GET_FLD(attr, branch_filter_mask));
+	reg |= FIELD_PREP(PMSFCR_EL1_SIMD, ATTR_CFG_GET_FLD(attr, simd_filter));
+	reg |= FIELD_PREP(PMSFCR_EL1_SIMDm, ATTR_CFG_GET_FLD(attr, simd_filter_mask));
+	reg |= FIELD_PREP(PMSFCR_EL1_FP, ATTR_CFG_GET_FLD(attr, float_filter));
+	reg |= FIELD_PREP(PMSFCR_EL1_FPm, ATTR_CFG_GET_FLD(attr, float_filter_mask));
 
 	if (reg)
 		reg |= PMSFCR_EL1_FT;
@@ -716,6 +769,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	u64 reg;
 	struct perf_event_attr *attr = &event->attr;
 	struct arm_spe_pmu *spe_pmu = to_spe_pmu(event->pmu);
+	const u64 feat_spe_eft_bits = PMSFCR_EL1_LDm | PMSFCR_EL1_STm |
+				      PMSFCR_EL1_Bm | PMSFCR_EL1_SIMD |
+				      PMSFCR_EL1_SIMDm | PMSFCR_EL1_FP |
+				      PMSFCR_EL1_FPm;
 
 	/* This is, of course, deeply driver-specific */
 	if (attr->type != event->pmu->type)
@@ -761,6 +818,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	    !(spe_pmu->features & SPE_PMU_FEAT_FILT_LAT))
 		return -EOPNOTSUPP;
 
+	if ((reg & feat_spe_eft_bits) &&
+	    !(spe_pmu->features & SPE_PMU_FEAT_EFT))
+		return -EOPNOTSUPP;
+
 	if (ATTR_CFG_GET_FLD(&event->attr, discard) &&
 	    !(spe_pmu->features & SPE_PMU_FEAT_DISCARD))
 		return -EOPNOTSUPP;
@@ -1052,6 +1113,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
 	if (spe_pmu->pmsver >= ID_AA64DFR0_EL1_PMSVer_V1P2)
 		spe_pmu->features |= SPE_PMU_FEAT_DISCARD;
 
+	if (FIELD_GET(PMSIDR_EL1_EFT, reg))
+		spe_pmu->features |= SPE_PMU_FEAT_EFT;
+
 	/* This field has a spaced out encoding, so just use a look-up */
 	fld = FIELD_GET(PMSIDR_EL1_INTERVAL, reg);
 	switch (fld) {

-- 
2.34.1

