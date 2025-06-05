Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB8D248F62
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120616; cv=none; b=Tnw4yNT8UduTAd3pYhPBRhmIUv9xRtkMx1Fxd1ygBpCxUaDNr2lDIX0jxW+v1FtA2P/j5B/OYD5HbQUdqYhK5Iu8fwEwzF6odBscRt7Vd71elSKxyS8nu3rotyvXW4R5cwBJ9oFKBm4txAJTyXPf90POS6EPu7OctaxWvz/de0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120616; c=relaxed/simple;
	bh=KCuaBrpctJvVyuO7lqsXVmFOYYJR2IE7xgkIFt7pAtM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pFoNd0UvUm/m7/8hLExDDKKyYnJSZLKCCegd9Y0KdckEMreA46sksfwdTmKrptUtxQtEBUEfK6pu4E2nTG2FQGnzIWNGvKQEvf05Q1njE367gc1NUI6PHa4hekt6feX/Og74vheYHVCUZobUET8U6P5nJE7SC3WVyizci9GNAPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mDRjoRhT; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mDRjoRhT"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so6602815e9.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749120612; x=1749725412; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0KLZ2ZCTkHcHktyLYkkFUXE6vwjX72niSxA55rUHHU=;
        b=mDRjoRhTw2FKWNIuKeiJ+NFa5+wGQ9ZhKY9xXEKIpHWWBYjCj98LSogLdrk5lu3YaQ
         pkNrdlZIinlHze4IU8iqD0wgGC4Gzr4G4g059kD0OWgq10cWExG29nPVUopwvLweOmf4
         kV0tzpCaljh0e4rvElYNScKuduQPg9YvfS9DAFxCZCKtpdczVs9+pnshvDJbsfuO5bOX
         CrgJe5+ofQRzEqBXkrxZoERlvSYaeigIrdYe57aM5pHNoEVznCWwq2ciosTxpeSkx+f0
         +NmFZal7tW1U+QHcqxi9UeZ7Z8PjgrpKBQQMrZ3f4Z1pzSQ41HAP8A6ECefhJItb4Jj/
         Pv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749120612; x=1749725412;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0KLZ2ZCTkHcHktyLYkkFUXE6vwjX72niSxA55rUHHU=;
        b=T4FY/M2horEEsqbbTHVjT1skdQEzAnk3ueGmVb8q9eVWgK03dGe50korpCO68ES5Bf
         C6BOtXTL2iSiyplJqd37SguerAGq0+lGIzDWlQ/zOh4cdaJ9svyTFWbgq3rcNEcTSI0A
         uhk5KfPLkpcHh+y8TbqO3GimtfIlC3n4nuYWkO0V/gRbBLtiotgRoqURDZ8XNcCIDRt7
         7pn8aHVAF+k4bpQMs8XuGdrB6G2RQBJ1z/mBSH6AETDUqCxbhT/9pnAfw4oWYHMdmaQi
         lFTKlSwrnkB/iGLsenRbSe2hZ3wK+5UbE/yYUGQVlNSKPbOoeF8vj1pv+h+vn5YLJM8y
         2MRA==
X-Forwarded-Encrypted: i=1; AJvYcCUU4AV736wql99R/FMx877TgqozUCS2EeRJkylDlpiF3M8LFiLiMbo5qPACbNOn4esHNgTABTQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHPF7fPya5tgFKGN2P7tzjsRyzANmFtSwIcb/RZGfaltdxCLS/
	tVlzLRn1cFQYdHhpWx7kc7mbJ+/97SG2IiPSZOLnXDEdttGoQcqKb2++sZJlW5FsGog=
X-Gm-Gg: ASbGncu3+KJnFrf+DU7rIuxjdFR4nqqlaQ37ZYMjWT6sgpeshpEtx7WghP222YbNAJ3
	Eknn2ZJIMccPyD2nzwz+hDqzC45GxNX1gP9wN0iIgynJKepIuCLLlYi5XM87vRFYiamkpdAG+lk
	R+ceTx2apjx+uWggP+4yD7AqXUZ/XEZuG7nG8+xPxJ1RuohNVMsbxgKgInTLztLNbnmNECc0fP3
	2w3W/97KBaJnI8NmNUGGnDZVeAmUwS16JPT7P1S1tfbDlYlKuQRtq1yBLKMUmnzfCh0g/F/oT5C
	42ezJGDCBYz+ZzlnmS/XZPWhzk30/EE86YgJ7T4wvaiiyWwMcsuMI2kRbLqL
X-Google-Smtp-Source: AGHT+IGbcO/a1eXK3R6X6dBhodfAwBOpm98OebpBQCErhJ5FZL5kwhqpZKRhnlTn8gwmnZUGlYp8jg==
X-Received: by 2002:a05:600c:b96:b0:441:d43d:4f68 with SMTP id 5b1f17b1804b1-451f0f4f1c5mr58624695e9.15.1749120611973;
        Thu, 05 Jun 2025 03:50:11 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f990cfe3sm20629965e9.23.2025.06.05.03.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:50:11 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Jun 2025 11:49:05 +0100
Subject: [PATCH v3 07/10] perf: arm_spe: Add support for filtering on data
 source
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250605-james-perf-feat_spe_eft-v3-7-71b0c9f98093@linaro.org>
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

SPE_FEAT_FDS adds the ability to filter on the data source of packets.
Like the other existing filters, enable filtering with PMSFCR_EL1.FDS
when any of the filter bits are set.

Each bit maps to data sources 0-63 described by bits[0:5] in the data
source packet (although the full range of data source is 16 bits so
higher value data sources can't be filtered on). The filter is an OR of
all the bits, so for example setting bits 0 and 3 filters packets from
data sources 0 OR 3.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 drivers/perf/arm_spe_pmu.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 9309b846f642..d04318411f77 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -87,6 +87,7 @@ struct arm_spe_pmu {
 #define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
 #define SPE_PMU_FEAT_DISCARD			(1UL << 7)
 #define SPE_PMU_FEAT_EFT			(1UL << 8)
+#define SPE_PMU_FEAT_FDS			(1UL << 9)
 #define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
 	u64					features;
 
@@ -232,6 +233,10 @@ static const struct attribute_group arm_spe_pmu_cap_group = {
 #define ATTR_CFG_FLD_inv_event_filter_LO	0
 #define ATTR_CFG_FLD_inv_event_filter_HI	63
 
+#define ATTR_CFG_FLD_data_src_filter_CFG	config4	/* PMSDSFR_EL1 */
+#define ATTR_CFG_FLD_data_src_filter_LO	0
+#define ATTR_CFG_FLD_data_src_filter_HI	63
+
 GEN_PMU_FORMAT_ATTR(ts_enable);
 GEN_PMU_FORMAT_ATTR(pa_enable);
 GEN_PMU_FORMAT_ATTR(pct_enable);
@@ -248,6 +253,7 @@ GEN_PMU_FORMAT_ATTR(float_filter);
 GEN_PMU_FORMAT_ATTR(float_filter_mask);
 GEN_PMU_FORMAT_ATTR(event_filter);
 GEN_PMU_FORMAT_ATTR(inv_event_filter);
+GEN_PMU_FORMAT_ATTR(data_src_filter);
 GEN_PMU_FORMAT_ATTR(min_latency);
 GEN_PMU_FORMAT_ATTR(discard);
 
@@ -268,6 +274,7 @@ static struct attribute *arm_spe_pmu_formats_attr[] = {
 	&format_attr_float_filter_mask.attr,
 	&format_attr_event_filter.attr,
 	&format_attr_inv_event_filter.attr,
+	&format_attr_data_src_filter.attr,
 	&format_attr_min_latency.attr,
 	&format_attr_discard.attr,
 	NULL,
@@ -286,6 +293,9 @@ static umode_t arm_spe_pmu_format_attr_is_visible(struct kobject *kobj,
 	if (attr == &format_attr_inv_event_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT))
 		return 0;
 
+	if (attr == &format_attr_data_src_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_FDS))
+		return 0;
+
 	if ((attr == &format_attr_branch_filter_mask.attr ||
 	     attr == &format_attr_load_filter_mask.attr ||
 	     attr == &format_attr_store_filter_mask.attr ||
@@ -406,6 +416,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
 	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
 		reg |= PMSFCR_EL1_FnE;
 
+	if (ATTR_CFG_GET_FLD(attr, data_src_filter))
+		reg |= PMSFCR_EL1_FDS;
+
 	if (ATTR_CFG_GET_FLD(attr, min_latency))
 		reg |= PMSFCR_EL1_FL;
 
@@ -430,6 +443,12 @@ static u64 arm_spe_event_to_pmslatfr(struct perf_event *event)
 	return FIELD_PREP(PMSLATFR_EL1_MINLAT, ATTR_CFG_GET_FLD(attr, min_latency));
 }
 
+static u64 arm_spe_event_to_pmsdsfr(struct perf_event *event)
+{
+	struct perf_event_attr *attr = &event->attr;
+	return ATTR_CFG_GET_FLD(attr, data_src_filter);
+}
+
 static void arm_spe_pmu_pad_buf(struct perf_output_handle *handle, int len)
 {
 	struct arm_spe_pmu_buf *buf = perf_get_aux(handle);
@@ -788,6 +807,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	if (arm_spe_event_to_pmsnevfr(event) & arm_spe_pmsevfr_res0(spe_pmu->pmsver))
 		return -EOPNOTSUPP;
 
+	if (arm_spe_event_to_pmsdsfr(event) &&
+	    !(spe_pmu->features & SPE_PMU_FEAT_FDS))
+		return -EOPNOTSUPP;
+
 	if (attr->exclude_idle)
 		return -EOPNOTSUPP;
 
@@ -857,6 +880,11 @@ static void arm_spe_pmu_start(struct perf_event *event, int flags)
 		write_sysreg_s(reg, SYS_PMSNEVFR_EL1);
 	}
 
+	if (spe_pmu->features & SPE_PMU_FEAT_FDS) {
+		reg = arm_spe_event_to_pmsdsfr(event);
+		write_sysreg_s(reg, SYS_PMSDSFR_EL1);
+	}
+
 	reg = arm_spe_event_to_pmslatfr(event);
 	write_sysreg_s(reg, SYS_PMSLATFR_EL1);
 
@@ -1116,6 +1144,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
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

