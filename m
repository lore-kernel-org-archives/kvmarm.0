Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BDA2749D6
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 11:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652233; cv=none; b=gT96M5AvmvmwMcDGOtzY9WvIeUHaih7yqaf3nC2zsEPvn8KH8DlIITtgtkoG1iu3OAPZxZ1/2m7IW4Nd0YrZV7L6OHNrB83zVXAcV81y6lzIg6pGJzeij+HzNsb9fDg0ec1yR2XyTaTSCg5ZS4jPolIlLuc87cE5D9MBR5csB8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652233; c=relaxed/simple;
	bh=amxfcIwk9CPU6fVzRnT+1Y2WxFhNVG4dD8O25j9WGOo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Nxggv1ki3NhsA8iON0hR3L98geBc5A7ryr1NEPpkXOKF22VPraUqE2abwgjr5fn9vNBjVGyAclQnyZNekjq6e1lnzlEPqrf5B3FOQNwU6bL/s8dOrDHQf8XaXohaiMOYBRccs2ICqvCaCTXFBVAKH03UAyhVN8qWl0pXA9jN6e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x/Q4Wjmv; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x/Q4Wjmv"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-458baf449cbso19137585e9.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Aug 2025 04:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754652230; x=1755257030; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bqDXfRMF96Zx+Uai2DOOReiNYXmUoTa9f4yVdbBVPio=;
        b=x/Q4Wjmv+pdVEl+VehU2U3IUuaii0Ov562BnMWk+3RYV2fo/4aBvw3sOeKP3VUvqxC
         z67bYVd+mfzk6509bG+NHuobdwaOMcn2Biw4Y8MZggXn8772Mz9NhhVQU8GPPuUJDNjD
         Vh7l0B4jIGgIeonckPDh6pUIfMeJ2o/rCGc/Cqv+pLgWqJ7BttRAokjGipJpb0rTKiXV
         ZQ6l2cBpZJrnUabFAQouM5mjsBHKjAyVtxZ9bSRyjFBQf40gj/Ra67vG/mDMeqoTsjyP
         Y93iFtNJA0y5humTE4u83RqRpdHQEEZlH6cOtrN0902kdVPY1ug/78LlrNpFF3LDZcmq
         tRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652230; x=1755257030;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqDXfRMF96Zx+Uai2DOOReiNYXmUoTa9f4yVdbBVPio=;
        b=P1BehxSgIriopxPGT0lSn/BNhWBRDQuGkTSEdKY5hDGiRY8h9F1Z8H/vtEbkUbtlng
         oa5EhbdHtOlTgf5iZgcMeVUyOQI1FR8brrQbv1KzIeiQlhTbXVMm5eDBxczOXijChlHd
         zHF4FAua/URFtJNcuH84FoLMViGrGLQ79aB2kH62f4GWEeZAU2WlS3cU5ml5Jgo85Lbf
         Kfl9ridlpClP+2VTFvAG9IeaRnk0wvhjJ9Ye9EsEp/Cr1byW4YrPELI1/tB67jxd4mJP
         e5+UBu2Er6nu2TSS7cvfWptQd6+NTPkbSbBrlYYADHDy0AlWeAHFwzg+7KqkoSu6xY/f
         /n1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/QqRZwL1WEyUy9hk8ep38f/DIj1Gj/rItMLMccebLYBgwWXm3QfPdTd8WeavmQ/ugzzFnbiE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzvPlcYiAJb8ZJtmzEB//cv1Ql21AQwg1zy6Z77eCjMTMawMqQx
	D0N42wZAxMoi2qr1UQOi0HbaMwOay5kWy1cP56kVZiv1zl+6RsRBtPai+4Vj1tNUtGo=
X-Gm-Gg: ASbGncuV1ZI4N+hlx9x79R1VM9Pncpwo7oIeejjGgEAyhYd5L/Ltz477vaFXkwjGJGK
	AbghRpS/hQ0USVGC0r13IRzdDtILIlvvVhKX+HXVQFygZATr8RqY0MFC5fPwQ0q7wSM4gJVUGNN
	9+U6+0Xcd0OtXLkMKWQsgKyZZ1f1DC2qpW1DgfL/YnOa2wWUdoVvjIO3dPPyYuBW6uiUd2x/U0Q
	vu14WNYlNFF3q0gnFi7i+EJ8xNeHzI+uAkSfDUB8dRARXAeSSlI7/z9Pn9r0GQpeOnq/H9Qp4Mm
	iLeEwF8iFptZt1Az8pPOqCQUbOnnboyFzpBU86U551qcBZcufsXkx0aAXsI+g5GUb/PJm+/V8lz
	pEG9GFl9Gjw4Cr08y/KQiCRnhYpPUVTE=
X-Google-Smtp-Source: AGHT+IHowdxZHjgH6bK7OIH/nXQ5aiavdpvaNKG8jnVSTD7lTm87fiBZ7lvMLO6xgDiJMSCjDqL77A==
X-Received: by 2002:a05:600c:1c0e:b0:459:d9a2:e927 with SMTP id 5b1f17b1804b1-459f4f3ced4mr22526035e9.5.1754652229721;
        Fri, 08 Aug 2025 04:23:49 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45923c34af8sm233482635e9.24.2025.08.08.04.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:23:49 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Fri, 08 Aug 2025 12:23:01 +0100
Subject: [PATCH v6 04/12] perf: arm_spe: Add support for FEAT_SPE_EFT
 extended filtering
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-james-perf-feat_spe_eft-v6-4-6daf498578c8@linaro.org>
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
 drivers/perf/arm_spe_pmu.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index ba55bc3db708..591f72fa0327 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -86,6 +86,7 @@ struct arm_spe_pmu {
 #define SPE_PMU_FEAT_ERND			(1UL << 5)
 #define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
 #define SPE_PMU_FEAT_DISCARD			(1UL << 7)
+#define SPE_PMU_FEAT_EFT			(1UL << 8)
 #define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
 	u64					features;
 
@@ -216,6 +217,27 @@ static const struct attribute_group arm_spe_pmu_cap_group = {
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
@@ -234,8 +256,15 @@ GEN_PMU_FORMAT_ATTR(pa_enable);
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
@@ -247,8 +276,15 @@ static struct attribute *arm_spe_pmu_formats_attr[] = {
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
@@ -269,6 +305,16 @@ static umode_t arm_spe_pmu_format_attr_is_visible(struct kobject *kobj,
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
 
@@ -364,8 +410,15 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
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
@@ -767,6 +820,16 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	    !(spe_pmu->features & SPE_PMU_FEAT_FILT_LAT))
 		return -EOPNOTSUPP;
 
+	if ((FIELD_GET(PMSFCR_EL1_LDm, reg) ||
+	     FIELD_GET(PMSFCR_EL1_STm, reg) ||
+	     FIELD_GET(PMSFCR_EL1_Bm, reg) ||
+	     FIELD_GET(PMSFCR_EL1_SIMD, reg) ||
+	     FIELD_GET(PMSFCR_EL1_SIMDm, reg) ||
+	     FIELD_GET(PMSFCR_EL1_FP, reg) ||
+	     FIELD_GET(PMSFCR_EL1_FPm, reg)) &&
+	    !(spe_pmu->features & SPE_PMU_FEAT_EFT))
+		return -EOPNOTSUPP;
+
 	if (ATTR_CFG_GET_FLD(&event->attr, discard) &&
 	    !(spe_pmu->features & SPE_PMU_FEAT_DISCARD))
 		return -EOPNOTSUPP;
@@ -1058,6 +1121,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
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

