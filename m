Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693FA225409
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120611; cv=none; b=VYOBbk1pHbHP3uNZxIXZ5Lh6Nd4TaYx/wX7H860fblbaLPl5F21ArqlBi8G3ViQfOIPsMBB6tiksc55jcOKE7sK5OUrDP5owYLaUjMitazuMg6AwfAER3Go6lfiAoaz85K/0xNnQF3LgKPgu07JwchSmQ1Lvd27Ly5M13s0sqNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120611; c=relaxed/simple;
	bh=CKBEUr6SC13uP2S5QCdv0ukBF1r0tcgRjgd1QCcKUYw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IHM6I6syxKRa98KCN/xUypDulwCRhVGppgZ4zdQYEUXHULPH5+DDvxZkRVi/vy5YGQM5o2gs9CRPL+2mSGOTeWuBQFbufx2FzpY/5Oo+zRhCzKz3HZFSvAb7X7hC4jZDB2eRxUY23TrFXrq9aJOQ7CJqZxS7CNoFHnEetUwpg6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r0YSTm0W; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r0YSTm0W"
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-450cf214200so6970205e9.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749120607; x=1749725407; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vYJpx3LicQfrZuxpetLws2KYn5BR4OxivH6XdK5rDwQ=;
        b=r0YSTm0WtvHfk6NzXbGYl09+/El6bOxkqfneuZGRGHbaW99Leo1YxzqRTHl1bGSfte
         +RO1wOSlgxjQHqbwTzQVFPZG1l8P7/5DHX9AJW6tYtq3hJYUFt4TT1mMHo+lS87YvJ8N
         HNIivBYLgSCTVdwaO71jcUFwzUQ+4Qh/xBTqFJxpGjcEZoVlDh/T0wc845hivGqiTUA7
         +Xbn7nrxYWqs29zGRxi3lBqFZIoObnEsW4EGuJJL7GONZzLPn8+NzWpctGltT4OUuNU9
         E/KT/5Nxj0YAVn1DpUATJ41140lO7+wPGrXdeF+8eZI8ONw9L/dN62x6t+Txidsu/o6T
         CN5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749120607; x=1749725407;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vYJpx3LicQfrZuxpetLws2KYn5BR4OxivH6XdK5rDwQ=;
        b=sdOBo6GWqoFYoZX2/xbYDC0rFdWiXDafrdBcmwE41Ko4YXxizbyOIV9uRzBjUZYTkl
         R19Lv5PoFi2G7qNksr2KjwqIi0hInG9g2yz3pG26pjB/8tpsXjpFBXJFQ/6uVVOR/5Nz
         J33VXiEd4NyrMmJmGiIOXqy5mEW+TZ2zK129MplaJfZJfsIJ8c+qGQf4V98EovDZnIpZ
         ibISbE1e67CJaL3XTn+0LksopmF0j8LLSamdPRIZwleYT3r+7CU5ZxBuZ6vAse9vsF7r
         13JpmpY4NnEfYriWGZWVEunfwbyfQIxOycIqnmx66dZYGbYrM+6lb0tQdd7XaKZJdOnQ
         6QZw==
X-Forwarded-Encrypted: i=1; AJvYcCWT1MOnEzpb0cGg3EUkEXSBJRtsPXOlmNs3WpF0DjtkkKper6+ocratVoVJEVOLumzSwk4FILY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxK8BxbOhbK8PzjowYg4P8QPN3rkyWIGqPtpaDeWMDF5arM6muo
	42uTjEb6TOSaO3VZLL7UNv3rBTVmq0SZXYAFr9291rBUbL0Ee8oVcSYLl9ZYKJZ45Ng=
X-Gm-Gg: ASbGnctCeBC/olpd7mpyHmlkgbQki/XPwwljSe3NAAWyMCCbHAil4bJ9d8FGHZqlUkC
	7ZiwDC2hLzr+flzDdSwU74ocER0kW9P3cTrPhUppETWGtzXSjSBQ28JsLgaC5IL3Ay54IgcbZdK
	LjMfS4Vz7clE4yAR4DRBbHeCHjrMhsBUTRbH+IgGmqEoPsQzVGwjkvMEz9UPmDbySVIDrD2G8O5
	+00LuCdvD0sgFZwgHHJG25Ibul62RZYBj58DmkMWySi1pjonvDLQxYfP2Jwufjy3B9709cXhwst
	M/CLaDRhlL0HFGrJOMPfDtK5kLmMeMzzg9Bc/UiNtZ2SNXVnoW90zrOT0Owmv7qhaX7SDOI=
X-Google-Smtp-Source: AGHT+IFX7yK6w08sV90HFESCN1t5m1rJIwCRGYCvSe2SuD4M9EhAswqLVLd52j//hVFUDskJ/RtCrg==
X-Received: by 2002:a05:600c:8b25:b0:442:ffb1:b58 with SMTP id 5b1f17b1804b1-451f0a77006mr68239325e9.12.1749120606588;
        Thu, 05 Jun 2025 03:50:06 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f990cfe3sm20629965e9.23.2025.06.05.03.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:50:06 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Jun 2025 11:49:01 +0100
Subject: [PATCH v3 03/10] perf: arm_spe: Add support for FEAT_SPE_EFT
 extended filtering
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250605-james-perf-feat_spe_eft-v3-3-71b0c9f98093@linaro.org>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
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
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
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
Tested-by: Leo Yan <leo.yan@arm.com>
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

