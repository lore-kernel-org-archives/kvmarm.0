Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6E92DC356
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103125; cv=none; b=P7op1+KuxvMlQxa5e8wC8Cn71KG69UAPqA3KTIirtaS4kKtoPydLp/T0vQkeap/p8jfZe5Iv1q2K6YxZPBgyn4s7/oGhfmb5kWq8rpl5ebl71dH+/VhASOpTtb9lI8gMIsn6Y6dosc+gADvN7t1v9dI0NTEH/AXNCD7bcu12n9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103125; c=relaxed/simple;
	bh=Gadj83wy4unursiBjFtgA2eyEqAMFePNrTi88fqMsXQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S/2zXR45RIAW6LMESgtzd6ZcAnPU7TL4hZLhvKSITxIBa2BJNYcM3s6LvJUUIUOwWI7Mz7NnEjNI3TYarAhlGoJ0JbYmW7icnJbynw9kRSMXljSfFNgQkHy56O1/2UOFMMt0v2gF8UDT8I54pVOU10GWPQfDBgRYZFfaJSOPY7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UN2y3Oet; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UN2y3Oet"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a54700a463so2408568f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753103122; x=1753707922; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lWHuVE1EgR5wLSuZVPObZK1oCh3b9sh0cLYRdc3oQUo=;
        b=UN2y3OethqiqxIs99pJx3wuGezU53Kt8pz2tZgLDo6Y1qPkbHcQsVugt3gCstQqKT0
         0Mf5qxv3p8E6Fis/kHT91s3ZCy7DCznAYkfqkApncXOOfLXVXXTnarydzQ2PwqaclQ8T
         fzSqzD0Rl0I18j9noruyz7IpSSkxcwXt8n2RLqP3LtzV7HuONKqc6q7dAWR3A+tHxYzH
         elkOlwdt75cNnPlcOBhIegQ2EFwG8IwI0G/5JUsSdMmjg/lQvnhLVyApZuYDY1eglMDP
         cYt96LVaomyk9W9i2DDrrkaW4JPA8yCFHZr4D4TbvBtNsmwBquJOlW7pBBiw6byWlLOK
         elag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103122; x=1753707922;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lWHuVE1EgR5wLSuZVPObZK1oCh3b9sh0cLYRdc3oQUo=;
        b=q+GIImU41ToFJeGc6YHvBJW1kgSMLfA/VDk8r4WMVfVOoNi4qVXUpiTAC9NjJ4uXYv
         ma/c9GkE4CM7hJQabexoAboI/Fr/16pkBAiAdiQBs4VejzmoFnlexRGC/+ywUPG3FK8Z
         M/UzsqNDQeywV3bd/cu3UAtZk713ky263Key+5XwB+qbv84z5w6AYlFr9pALSJVdVjPc
         n6b0wnVygfpaMngdXVT09DfSUwnxksq0fjztgvQQ244GuXjZeI3pOQnGjICj4CunYVsU
         BCkvzSG7YPcX3V82JSSEsMoPDoXMQPRvy9GkKkcP8oEiYEh0VMcJ9RQlPGIht0QYfwCJ
         Phzg==
X-Forwarded-Encrypted: i=1; AJvYcCVzRbJBQBSB+WKGDsVRwfHKns+TjwKXBP26rSt1nTBFQWY/gpxxhwRCwtOeDOqtUjZXXVyWmi0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrXB2ekSFnqKEz0L9WsmVrMXmFbAP/XXK6/qAVzhsdxlPSNWVF
	ZFticmO5gnjAU7j9EAoxws6a8oeJd0nK1dvAt1rKgPAv5an+Y0r+RVNFIrnKWdjatMY=
X-Gm-Gg: ASbGncv+LliZSjuoZXH1Wh4IemSaNpThpv8jyFuh0BFnwe5/jTZ53gMp/O8CbiVQZZY
	Ir10uuY2XK79WzVexSf4qVdCMBj5SUxDmGn7dIpCg10NefuDx9x8pUL3EbS6aPCWHsQ45M2JerU
	sWZsdzvaZKUvkSeDXByC1JrsrnQcNKna3e3mGI2HhJ8sZI8W1W2Vv0vuIR/9AaOb+/a19oSOD5l
	LJhdGUsFR9F28uVFGPetbAdUkQ2SB0RqvcqGMzqOQxAozVbexVa4d3J10GEP8qTyEBFg3X6ztH/
	lbdVVXq3Z9+CAW4galqC741zdW//4q+pbH3cJpSeEAABWsPj9a3U1onUE3nGI6OSSoOG4HXFucQ
	H+u5KWC/lMIc9Vhc3xkXksEogHjjev9fI/9xaelM7Zw==
X-Google-Smtp-Source: AGHT+IENuZ8sJTZYDX4FPNTpsJ3T0y3YydlBHbyO5i6H0FPLw38B5Bhq3yc1kar5ictPycy0p5ZNpw==
X-Received: by 2002:a05:6000:438a:b0:3a3:7117:1bba with SMTP id ffacd0b85a97d-3b613ad5ec1mr14410276f8f.24.1753103121601;
        Mon, 21 Jul 2025 06:05:21 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c632sm10485077f8f.80.2025.07.21.06.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:05:21 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 14:05:03 +0100
Subject: [PATCH v5 09/12] perf: arm_spe: Add support for filtering on data
 source
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v5-9-a7bc533485a1@linaro.org>
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

Signed-off-by: James Clark <james.clark@linaro.org>
---
 drivers/perf/arm_spe_pmu.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index e69a0d170702..5729be9e5952 100644
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
@@ -425,6 +436,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
 	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
 		reg |= PMSFCR_EL1_FnE;
 
+	if (ATTR_CFG_GET_FLD(attr, inv_data_src_filter))
+		reg |= PMSFCR_EL1_FDS;
+
 	if (ATTR_CFG_GET_FLD(attr, min_latency))
 		reg |= PMSFCR_EL1_FL;
 
@@ -449,6 +463,17 @@ static u64 arm_spe_event_to_pmslatfr(struct perf_event *event)
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
@@ -786,6 +811,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	if (arm_spe_event_to_pmsnevfr(event) & spe_pmu->pmsevfr_res0)
 		return -EOPNOTSUPP;
 
+	if (arm_spe_event_to_pmsdsfr(event) != U64_MAX &&
+	    !(spe_pmu->features & SPE_PMU_FEAT_FDS))
+		return -EOPNOTSUPP;
+
 	if (attr->exclude_idle)
 		return -EOPNOTSUPP;
 
@@ -861,6 +890,11 @@ static void arm_spe_pmu_start(struct perf_event *event, int flags)
 		write_sysreg_s(reg, SYS_PMSNEVFR_EL1);
 	}
 
+	if (spe_pmu->features & SPE_PMU_FEAT_FDS) {
+		reg = arm_spe_event_to_pmsdsfr(event);
+		write_sysreg_s(reg, SYS_PMSDSFR_EL1);
+	}
+
 	reg = arm_spe_event_to_pmslatfr(event);
 	write_sysreg_s(reg, SYS_PMSLATFR_EL1);
 
@@ -1120,6 +1154,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
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

