Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEC13590B0
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 11:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762861117; cv=none; b=ZQRIJQM8vXRdWtOc8ZHjMT/WyFAdZfDZ8sNI6fLzxOA3YytZNN+mcAn6gaF5d8Cqa9D2+SmZcbnstbhURmTecmxe3T99EiqVJ9/pXLq3qtrMTyVKVmRblTB2LjCLSCbCDoX2cpS8BY7Vh5w/54wi7NheB6IlU7r9mbkTeAiinqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762861117; c=relaxed/simple;
	bh=wuWGqKWZZ/BTt5fqv81cBQwVikNNCsOKo8cdQBD/rvs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eV06s6RsHz2LtH3/6AYBJFW8COBhh56xadKnG+PqiamD4GqQ0VOx91VUcpeT764lyHho5LG71b0gl4yrI51H10PPaKOdNwKW/1IWTHWDiKBRl/84q/sdgSvj1g2J0udJGKZFXAvIoanqiH44bu/knB2xDYfBWKliFaKFQ8nPEJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jCZVHwvf; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jCZVHwvf"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b32a5494dso1181058f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 03:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762861112; x=1763465912; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gwCuT4qpbf858s5dq2pagCIko/kgMzJ+Cwp9chp+q6I=;
        b=jCZVHwvfvBGxuCh2UC6i/LbbUmbSlCTwrpI0ppxBw1PW76NY+GcOTJR1AKjzGeKQY5
         9qwQdgpV/Ks81rdQXfo28J4pr+CwIVjXt83uQ2WWcq+qJAIEnV4gQreKaYIAloSmo4aw
         jTcIzNVaaC/qbgiDyiQuaka5TN/HKaASPnr23mGLxOm1ByfkYAou6KENX/raG4d2jHVb
         Ke4u3TwvP2zTufEtHQTqfr3fJS6MsBq+KeAXISdMKbEDLGiGAoDQLiP/Q3EHBUit1M03
         hlrnhWod3u7SuB3RUyDCZ2w+WfN0VbMmyZX6ys9sH1o2jdIB0GIHDmkeWrss5j/eOEtt
         23Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762861112; x=1763465912;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gwCuT4qpbf858s5dq2pagCIko/kgMzJ+Cwp9chp+q6I=;
        b=AehS06Zkx4KlbDuuMkoz25BBbRJpI5IvAt6sV9dyoehQpuCn7AKZTjtMFN6GAF5/61
         Ki0QvdkQOgCn5t9//mwoj3puNtPiTHscaBSusJDEcFd0yk5hJSxNhAPNgjBw/jhk+wLN
         xpthh2hr0FqePiLlHlS4hK1AdQiYdNAYeJhmeGyjfWJqaPulzHXnzagFY9fBBE9FP3QK
         9yiApfyuTK3H3s5yUsnGQbM+7Q7vN7Yc7EWgrcRS51Itakgx+q6SDOEV2FvHtOy1Rn+B
         bX7bRuK/PSXyKLmsti2EKDUt+0dQ6QBhT+s3mHpzOoDV+ZBRhY/mEhkNXqWpMaUbDbk6
         is0g==
X-Forwarded-Encrypted: i=1; AJvYcCXNjn9jIK9btBFQerYJNN7k9Z2EL7uXZ3H0M94+s8nUbuQiwjjfLCfV5Zh+Ge7UoI/828WsW2g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzvzqmreNgRhKp3bAbXWnkPhUu13T56LnlVK2tvruKGPLvOyyq
	treAsI8iAQZiWGx5MKds9F1t8bSKI2F9vyeHRhEb5KYXExUXmH4yRuaVa01OpLk23Rk=
X-Gm-Gg: ASbGncuRPH7Jc4azkdx7mxTmh5ktVuknuKHTd6zGv0u6qv/uTF49t1c6uUYQmqvrNoT
	FYv2ncmACyNQZioajHznYcPTVM2WA73zPAeIpsKtftxdFYQmVqJUzDUHFJvCk1qXOEttfRWQnqE
	bM3n7OfoHsmpxUTUQEJXcM3IFRPyJmQ+RIfUkOC391Jc4CqKcIXfrVr2acrm7Df+Q5Y+R2Lf1bV
	SUHX3Ixj2eJP+AZQ3+f6itLMQrr5PDwmRbL84fOlvD0Hn0EYqvSafOhirpPiVBxmwIupAPRrPQt
	fxuqVjnInOtAHaqUS4MnHpQitKBUtVWJWe4Q+7igb587rqGEXLfRxc6m07k28J7Fzn5vSpZ3JN/
	7r0pH0upPpLsuzSuzmMmYK56lJOLyLpYyYw9fZ4fqaGdcYJ/3byTJIiODO8uXdeiNEZqEPUMOTA
	PJSCfondnclQ==
X-Google-Smtp-Source: AGHT+IHoaAdyno4PCEkIfLITG0AGBI1bC/mX+D1DG/Yst4Q/794Wn0/d79DNOynMvzJ3hrqergaE6g==
X-Received: by 2002:a5d:588a:0:b0:42b:3e20:f1b4 with SMTP id ffacd0b85a97d-42b3e20f5bdmr5248092f8f.5.1762861111797;
        Tue, 11 Nov 2025 03:38:31 -0800 (PST)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675cd25sm28133486f8f.22.2025.11.11.03.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 03:38:31 -0800 (PST)
From: James Clark <james.clark@linaro.org>
Date: Tue, 11 Nov 2025 11:37:56 +0000
Subject: [PATCH v10 2/5] perf: arm_spe: Add support for filtering on data
 source
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-james-perf-feat_spe_eft-v10-2-1e1b5bf2cd05@linaro.org>
References: <20251111-james-perf-feat_spe_eft-v10-0-1e1b5bf2cd05@linaro.org>
In-Reply-To: <20251111-james-perf-feat_spe_eft-v10-0-1e1b5bf2cd05@linaro.org>
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

SPE_FEAT_FDS adds the ability to filter on the data source of packets.
Like the other existing filters, enable filtering with PMSFCR_EL1.FDS
when any of the filter bits are set.

Each bit position of the 64 bit filter maps to numerical data sources
0-63 described by bits[0:5] in the data source packet (although the full
range of data source is 16 bits so higher value data sources can't be
filtered on). The filter is an OR of all the filter bits, so for example
clearing filter bits 0 and 3 only includes packets from data sources 0
OR 3.

Invert the filter given by userspace so that the default value of 0 is
equivalent to including all values (no filtering). This allows us to
skip adding a new format bit to enable filtering and still support
excluding all data sources which would have been a filter value of 0 if
not for the inversion.

Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 drivers/perf/arm_spe_pmu.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index fa50645fedda..617f8a98dd63 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -87,6 +87,7 @@ struct arm_spe_pmu {
 #define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
 #define SPE_PMU_FEAT_DISCARD			(1UL << 7)
 #define SPE_PMU_FEAT_EFT			(1UL << 8)
+#define SPE_PMU_FEAT_FDS			(1UL << 9)
 #define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
 	u64					features;
 
@@ -252,6 +253,10 @@ static const struct attribute_group arm_spe_pmu_cap_group = {
 #define ATTR_CFG_FLD_inv_event_filter_LO	0
 #define ATTR_CFG_FLD_inv_event_filter_HI	63
 
+#define ATTR_CFG_FLD_inv_data_src_filter_CFG	config4	/* inverse of PMSDSFR_EL1 */
+#define ATTR_CFG_FLD_inv_data_src_filter_LO	0
+#define ATTR_CFG_FLD_inv_data_src_filter_HI	63
+
 GEN_PMU_FORMAT_ATTR(ts_enable);
 GEN_PMU_FORMAT_ATTR(pa_enable);
 GEN_PMU_FORMAT_ATTR(pct_enable);
@@ -268,6 +273,7 @@ GEN_PMU_FORMAT_ATTR(float_filter);
 GEN_PMU_FORMAT_ATTR(float_filter_mask);
 GEN_PMU_FORMAT_ATTR(event_filter);
 GEN_PMU_FORMAT_ATTR(inv_event_filter);
+GEN_PMU_FORMAT_ATTR(inv_data_src_filter);
 GEN_PMU_FORMAT_ATTR(min_latency);
 GEN_PMU_FORMAT_ATTR(discard);
 
@@ -288,6 +294,7 @@ static struct attribute *arm_spe_pmu_formats_attr[] = {
 	&format_attr_float_filter_mask.attr,
 	&format_attr_event_filter.attr,
 	&format_attr_inv_event_filter.attr,
+	&format_attr_inv_data_src_filter.attr,
 	&format_attr_min_latency.attr,
 	&format_attr_discard.attr,
 	NULL,
@@ -306,6 +313,10 @@ static umode_t arm_spe_pmu_format_attr_is_visible(struct kobject *kobj,
 	if (attr == &format_attr_inv_event_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT))
 		return 0;
 
+	if (attr == &format_attr_inv_data_src_filter.attr &&
+	    !(spe_pmu->features & SPE_PMU_FEAT_FDS))
+		return 0;
+
 	if ((attr == &format_attr_branch_filter_mask.attr ||
 	     attr == &format_attr_load_filter_mask.attr ||
 	     attr == &format_attr_store_filter_mask.attr ||
@@ -430,6 +441,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
 	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
 		reg |= PMSFCR_EL1_FnE;
 
+	if (ATTR_CFG_GET_FLD(attr, inv_data_src_filter))
+		reg |= PMSFCR_EL1_FDS;
+
 	if (ATTR_CFG_GET_FLD(attr, min_latency))
 		reg |= PMSFCR_EL1_FL;
 
@@ -454,6 +468,17 @@ static u64 arm_spe_event_to_pmslatfr(struct perf_event *event)
 	return FIELD_PREP(PMSLATFR_EL1_MINLAT, ATTR_CFG_GET_FLD(attr, min_latency));
 }
 
+static u64 arm_spe_event_to_pmsdsfr(struct perf_event *event)
+{
+	struct perf_event_attr *attr = &event->attr;
+
+	/*
+	 * Data src filter is inverted so that the default value of 0 is
+	 * equivalent to no filtering.
+	 */
+	return ~ATTR_CFG_GET_FLD(attr, inv_data_src_filter);
+}
+
 static void arm_spe_pmu_pad_buf(struct perf_output_handle *handle, int len)
 {
 	struct arm_spe_pmu_buf *buf = perf_get_aux(handle);
@@ -791,6 +816,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	if (arm_spe_event_to_pmsnevfr(event) & spe_pmu->pmsevfr_res0)
 		return -EOPNOTSUPP;
 
+	if (arm_spe_event_to_pmsdsfr(event) != U64_MAX &&
+	    !(spe_pmu->features & SPE_PMU_FEAT_FDS))
+		return -EOPNOTSUPP;
+
 	if (attr->exclude_idle)
 		return -EOPNOTSUPP;
 
@@ -866,6 +895,11 @@ static void arm_spe_pmu_start(struct perf_event *event, int flags)
 		write_sysreg_s(reg, SYS_PMSNEVFR_EL1);
 	}
 
+	if (spe_pmu->features & SPE_PMU_FEAT_FDS) {
+		reg = arm_spe_event_to_pmsdsfr(event);
+		write_sysreg_s(reg, SYS_PMSDSFR_EL1);
+	}
+
 	reg = arm_spe_event_to_pmslatfr(event);
 	write_sysreg_s(reg, SYS_PMSLATFR_EL1);
 
@@ -1125,6 +1159,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
 	if (FIELD_GET(PMSIDR_EL1_EFT, reg))
 		spe_pmu->features |= SPE_PMU_FEAT_EFT;
 
+	if (FIELD_GET(PMSIDR_EL1_FDS, reg))
+		spe_pmu->features |= SPE_PMU_FEAT_FDS;
+
 	/* This field has a spaced out encoding, so just use a look-up */
 	fld = FIELD_GET(PMSIDR_EL1_INTERVAL, reg);
 	switch (fld) {

-- 
2.34.1

