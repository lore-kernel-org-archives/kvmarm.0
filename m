Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4532F7445
	for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 09:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755163574; cv=none; b=sSReph9mogJAhLeJ6aFO2iOHqzPQolXvSuS7232FaRfn166H7cIP9AdSaFvbUQHZ2fVK3YIdvXmrfly6LL9Z6sa6T72RBEgKh7kz9XifjADUG8WfX1grMaH8UuhHz7DPMlndayl4hElIZh88P5ed725fkGIIiacExES5Tly5moQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755163574; c=relaxed/simple;
	bh=0Sysn8K7QxBSXhh4+yVi+5eX8XDZpR4uCpq/1GrIYWU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fhDR0rB3TQWCmjTKuX2228sTLEd+TjOUk15UT5ywDN4yhh+UhmZCszg4KV7KIh6C/mnoABVJ02V/RaRulbo46hq4DU/H5H4mftHUi8szq+GQbinLF4gO/nSUDkZR5vD8+raiBghpjEh0QapMJMVff2J0acwdbZqDHiE0Ydb7Dws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=onj02SUY; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="onj02SUY"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45a1b0990b2so4594805e9.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 02:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755163570; x=1755768370; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kU3pVBhaBY5D1ADCXJFCOl8E+cDESMwoM3MT+w6qdBg=;
        b=onj02SUYToOSElo8hYBke43S6tZ/eFQwjWIOKni1TnisCX5zgkzbG8C11KromvZYZw
         7KYpr6gEE5HEqCbvIXSA5Ug8lVeOnA8hcFf/6czpb75cJQUMcGu37p1DG2KUX4bC+WE/
         COF10zpJSfAkm2tAbHdi0o+yaoo7GYLw2crIAQ8OY89vdK86avzD0G3t4oQDqNNSppdR
         kAZUc7MDk9KnNT/vXmUxO+/nRhrELF+Lu4IOnS8ve6dPRFtsGldtUpgaSoMR4eO+VIT5
         pcBBaP85kVrP4xYCWqWNphnyx1Sl0roFQ+NF4SFssiuPtdTD4WBqlsGMwzusRLwfIaak
         gbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163570; x=1755768370;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kU3pVBhaBY5D1ADCXJFCOl8E+cDESMwoM3MT+w6qdBg=;
        b=jnEpEJsJVLIJJ6qmHDYRkC+rDyU1i40E3JDXRMYkGqfnYzD/jTKWAfJzs8MVzM2+nN
         Oouut9BCru0dYZ4d+m2Y6Rp8PqkeanDuqBqQiGt/qZvZbz97NgvFv6vjXsstRNzZ54gF
         +hN7b0NlhsPIKfUErRbKtm+L5Aov8x4lsu5oBEL4GSILO9iMGTqYlPFhZH6TyhlF+mid
         8agUjOOF47QfgbWK8b8K8TS1EAfioe19NBgHVJK71vqQhcboVejEJ2CMo+wPCiJ3RXav
         VKf/tlx2F/WiuMPMsUrFDGlLd9AHvIm170V6CYInkNq2Xbz1410ETeegeMH8Hu+TEjtt
         locA==
X-Forwarded-Encrypted: i=1; AJvYcCWCKextRxsm3zXZTAwFwi0LoB48TO+C/z1BeAIKq+2JVgeSYwwln7V5i80nSJXdEQ7IghFpwjU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5xY6F3sfifLC7TfAwLx7BXugplIUVQIyUCUCp3yx22jwtcfqa
	MrVt0Qg2fxgR4G48O/Pps7OeN7SFXlpV3aEGFTqdVWWqNXr0zoXgQvUctO7U9JtFqYA7MAvgASQ
	OvXdK
X-Gm-Gg: ASbGnctTyPpK3Y6TInmIaSJ/iZ+1dFaDcFGsjoHGwpMiXjdXSBHJyXJqXulQm8MdtJ6
	dLp+nPxEbB/VmVjGJjnvGsIYSv8jVJ4aesFrPXfm/lvR+hZUFJu1+Sf0rbcWmUTevs2hWVuwpmD
	hK7vvWfm+4WUpGvA7bYgsuewdwjm2RcPo2TgA+iQ47RS5kwmuuZkj7qoGHMeG5COMnEnmn+OcS6
	ipf6dqaSki6m900uEihVF4d2QEkxSZCOfqP/RIvIjW/WXRljz72qAkUTCnkfsrQKbZ9uYZ9QtyM
	wBjRXBYCk/P0JbDInQhJ+QxH/zx8KqMHUpJOnxqiI1NcfstI2a8li60ynqA/v66X0EGrk9JCAN0
	Z+95jmUG2hdm5pZRMnHwy034RvAtgUnI=
X-Google-Smtp-Source: AGHT+IG7VtJU6yEctLHSbbPHQRJt83DmrEVIyD4UvM5HiNPb8kIWkjAaSB91zdHiKQMYUKW7kzxcGA==
X-Received: by 2002:a05:600c:5486:b0:456:25aa:e9b0 with SMTP id 5b1f17b1804b1-45a1b646a96mr22322175e9.16.1755163569549;
        Thu, 14 Aug 2025 02:26:09 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c76e9basm14536775e9.21.2025.08.14.02.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:26:09 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 14 Aug 2025 10:25:31 +0100
Subject: [PATCH v7 09/12] perf: arm_spe: Add support for filtering on data
 source
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-james-perf-feat_spe_eft-v7-9-6a743f7fa259@linaro.org>
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

SPE_FEAT_FDS adds the ability to filter on the data source of packets.
Like the other existing filters, enable filtering with PMSFCR_EL1.FDS
when any of the filter bits are set.

Each bit maps to data sources 0-63 described by bits[0:5] in the data
source packet (although the full range of data source is 16 bits so
higher value data sources can't be filtered on). The filter is an OR of
all the bits, so for example clearing bits 0 and 3 only includes packets
from data sources 0 OR 3.

Invert the filter given by userspace so that the default value of 0 is
equivalent to including all values (no filtering). This allows us to
skip adding a new format bit to enable filtering and still support
excluding all data sources which would have been a filter value of 0 if
not for the inversion.

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 drivers/perf/arm_spe_pmu.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 591f72fa0327..e5b36ab90786 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -87,6 +87,7 @@ struct arm_spe_pmu {
 #define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
 #define SPE_PMU_FEAT_DISCARD			(1UL << 7)
 #define SPE_PMU_FEAT_EFT			(1UL << 8)
+#define SPE_PMU_FEAT_FDS			(1UL << 9)
 #define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
 	u64					features;
 
@@ -251,6 +252,10 @@ static const struct attribute_group arm_spe_pmu_cap_group = {
 #define ATTR_CFG_FLD_inv_event_filter_LO	0
 #define ATTR_CFG_FLD_inv_event_filter_HI	63
 
+#define ATTR_CFG_FLD_inv_data_src_filter_CFG	config4	/* inverse of PMSDSFR_EL1 */
+#define ATTR_CFG_FLD_inv_data_src_filter_LO	0
+#define ATTR_CFG_FLD_inv_data_src_filter_HI	63
+
 GEN_PMU_FORMAT_ATTR(ts_enable);
 GEN_PMU_FORMAT_ATTR(pa_enable);
 GEN_PMU_FORMAT_ATTR(pct_enable);
@@ -267,6 +272,7 @@ GEN_PMU_FORMAT_ATTR(float_filter);
 GEN_PMU_FORMAT_ATTR(float_filter_mask);
 GEN_PMU_FORMAT_ATTR(event_filter);
 GEN_PMU_FORMAT_ATTR(inv_event_filter);
+GEN_PMU_FORMAT_ATTR(inv_data_src_filter);
 GEN_PMU_FORMAT_ATTR(min_latency);
 GEN_PMU_FORMAT_ATTR(discard);
 
@@ -287,6 +293,7 @@ static struct attribute *arm_spe_pmu_formats_attr[] = {
 	&format_attr_float_filter_mask.attr,
 	&format_attr_event_filter.attr,
 	&format_attr_inv_event_filter.attr,
+	&format_attr_inv_data_src_filter.attr,
 	&format_attr_min_latency.attr,
 	&format_attr_discard.attr,
 	NULL,
@@ -305,6 +312,10 @@ static umode_t arm_spe_pmu_format_attr_is_visible(struct kobject *kobj,
 	if (attr == &format_attr_inv_event_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT))
 		return 0;
 
+	if (attr == &format_attr_inv_data_src_filter.attr &&
+	    !(spe_pmu->features & SPE_PMU_FEAT_FDS))
+		return 0;
+
 	if ((attr == &format_attr_branch_filter_mask.attr ||
 	     attr == &format_attr_load_filter_mask.attr ||
 	     attr == &format_attr_store_filter_mask.attr ||
@@ -429,6 +440,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
 	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
 		reg |= PMSFCR_EL1_FnE;
 
+	if (ATTR_CFG_GET_FLD(attr, inv_data_src_filter))
+		reg |= PMSFCR_EL1_FDS;
+
 	if (ATTR_CFG_GET_FLD(attr, min_latency))
 		reg |= PMSFCR_EL1_FL;
 
@@ -453,6 +467,17 @@ static u64 arm_spe_event_to_pmslatfr(struct perf_event *event)
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
@@ -790,6 +815,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	if (arm_spe_event_to_pmsnevfr(event) & spe_pmu->pmsevfr_res0)
 		return -EOPNOTSUPP;
 
+	if (arm_spe_event_to_pmsdsfr(event) != U64_MAX &&
+	    !(spe_pmu->features & SPE_PMU_FEAT_FDS))
+		return -EOPNOTSUPP;
+
 	if (attr->exclude_idle)
 		return -EOPNOTSUPP;
 
@@ -865,6 +894,11 @@ static void arm_spe_pmu_start(struct perf_event *event, int flags)
 		write_sysreg_s(reg, SYS_PMSNEVFR_EL1);
 	}
 
+	if (spe_pmu->features & SPE_PMU_FEAT_FDS) {
+		reg = arm_spe_event_to_pmsdsfr(event);
+		write_sysreg_s(reg, SYS_PMSDSFR_EL1);
+	}
+
 	reg = arm_spe_event_to_pmslatfr(event);
 	write_sysreg_s(reg, SYS_PMSLATFR_EL1);
 
@@ -1124,6 +1158,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
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

