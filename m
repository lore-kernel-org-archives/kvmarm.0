Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D32F326D65
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756730517; cv=none; b=LRuLj1FfL2X8V/m5np/Zsc8YLQbhN7D4SxlfOOLqW/0dAdMvYmf7lf8FW9jFg1DMi71m9JR1VhT5A9y80c8s3kwwSd9o35FGiei777s2SL9nISChBLkq1rheBcwDhTTGlu66whDcGnX7eI06kfe1acremPUb1mLbFHy0Uz0jQWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756730517; c=relaxed/simple;
	bh=1dn2TsDH9c3qn851HU6KhoRjFDuyNupOzJtkpyRLaL0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CB4bqt4tfUxWhF2xW/zra5VaVoAPlp0H0CiSn70fb2e6CvQUcnL8TBmz7xq6eWxW585AllFahlbjGSX51VC1mPBnGpZd5bTU+Oj8a+cVm7k+lXdIfJQOZT+vxTubvY64JKrAoHagiG5iRnY4rHDpCrPLJNT7dGlSk9lJn+8bhuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KdPOEP7G; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KdPOEP7G"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45b87bc67a4so10584435e9.3
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756730513; x=1757335313; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2rccDGxo7Zi/+ePrAmZStYRWWCBeSec1uJGq7oyHErE=;
        b=KdPOEP7GNLIBBfGNeKIFxaA0cVc/+nqH75eTyTfADHpPmI1lwfJREdjsEDuBLDVV5g
         gIoR/6pbDeFf1aCgJNxldDc0FV4YPxlrQLQMx4IT4TKfYZqMiZw7YUXePL5UG8LF7v4E
         yL9sEQZS2ozkAT5IAFoJ0pz9kn3BSELwFcyglW3FpIxzhX9UqgyC3Iuw/qEoS9u1WJ33
         hXQKXkNx8wECqbogYlq3kApkLQt+Tp13NQ5ocMvucnKgqfeur1IauNpbMejWgOHkuKPk
         y0ZhWh0l4MAfhIKl0ZmxaxZXRhWNKIPEosB6JP6rRQhVl2JM7fsvSmtStM7d+qRP4vYR
         nPDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756730513; x=1757335313;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2rccDGxo7Zi/+ePrAmZStYRWWCBeSec1uJGq7oyHErE=;
        b=U3kehNfyDYCcm4pvp4ZD+EFxV42JxLfNBgDnJGRp8q5yaHLuztL5k8aW7KroJeMIcf
         3Q8cKEahD/qutOI7XdFVN4excG7oQ4yfVOSzIAywCm+wcgUYZpgDdHpkPr84AA+RABUS
         osa4mXWo8SwosFiq9KonhvIzN0S3q+h5TXWmf1yUrYQFLTPYq/zHR3FVFOPrajbUDtw6
         d2K/sEuTKecWPPPOl9n4kWSm5/blMHB/mMdH42EVQS9pOi9oBhbr1G2o01Oj0Bf0b7VP
         0wyf6+ATWJzvUTPGhh/3zkj301wXzT1xhusbagEILBTJjkdj2OvAC1QgD0xzdgr0qbdv
         demg==
X-Forwarded-Encrypted: i=1; AJvYcCXbXGmD7jbMst4wtR+yTkNJYn8zaixL/BA4XmTkKoUhsqxIA2p0BXlmhE6O6vdRzsrhP4ZhrA4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXqGBnKab05UIn0SkFJ/02EAtTmPuasGnRfFT8/2Noi0AS457e
	Uo6Yr3CmsQXi0624/smP+3cxt1pXKn4MRb81HazEZ9ANdoXRK5ZyxUOQLKLrTAdafto=
X-Gm-Gg: ASbGncv3VbtASkX6MTC+JLwIncL4mwICrc7++8ylewNnw6gULlGtedByi8PtgrB/B+6
	mfdPnv3UFB2NWzsc1y1HRaEg7Kolt8aqjach10/0lidFwwHuulJBdrli1oQ6n9wyZxQi/s5vVst
	a9cifxfgC4TEB1bUFS/rWitnPxJOQEWWYBv5VQY06F6ACJBl524izAJbpurkgW4FRkbdaVIc1KX
	O9GoOCZdWYjveHCxB0q+isMDqhCgaXBMe/b+tqz9R4lb+s5lY+mR4iW3FXblIpv9cs2ub407sIE
	Dj2yb4gFs3V/wfchAo26e4nyg7lJzYbq7MFaQjeYnDR0hzWXzlFNIOM+FfZOXtKx+ESOlz4+Ean
	XtvHs7PKhvv5AEZGX2wCS8sLk/XMnxcg=
X-Google-Smtp-Source: AGHT+IEiJacQeJIhAlVFIVb4gBUFN/ZD4+BtNn08VuvIydbSJk4ZmQ+RW5QdnGmgopAeFlemw8drNw==
X-Received: by 2002:a05:600c:4fcd:b0:459:db71:74d7 with SMTP id 5b1f17b1804b1-45b8557c8d1mr55430795e9.27.1756730512680;
        Mon, 01 Sep 2025 05:41:52 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm154946315e9.19.2025.09.01.05.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:41:52 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 01 Sep 2025 13:40:32 +0100
Subject: [PATCH v8 03/12] perf: arm_spe: Expose event filter
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-james-perf-feat_spe_eft-v8-3-2e2738f24559@linaro.org>
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

From: Leo Yan <leo.yan@arm.com>

Expose an "event_filter" entry in the caps folder to inform user space
about which events can be filtered.

Change the return type of arm_spe_pmu_cap_get() from u32 to u64 to
accommodate the added event filter entry.

Signed-off-by: Leo Yan <leo.yan@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 drivers/perf/arm_spe_pmu.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 86c9948ab5a0..ba55bc3db708 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -116,6 +116,7 @@ enum arm_spe_pmu_capabilities {
 	SPE_PMU_CAP_FEAT_MAX,
 	SPE_PMU_CAP_CNT_SZ = SPE_PMU_CAP_FEAT_MAX,
 	SPE_PMU_CAP_MIN_IVAL,
+	SPE_PMU_CAP_EVENT_FILTER,
 };
 
 static int arm_spe_pmu_feat_caps[SPE_PMU_CAP_FEAT_MAX] = {
@@ -123,7 +124,7 @@ static int arm_spe_pmu_feat_caps[SPE_PMU_CAP_FEAT_MAX] = {
 	[SPE_PMU_CAP_ERND]	= SPE_PMU_FEAT_ERND,
 };
 
-static u32 arm_spe_pmu_cap_get(struct arm_spe_pmu *spe_pmu, int cap)
+static u64 arm_spe_pmu_cap_get(struct arm_spe_pmu *spe_pmu, int cap)
 {
 	if (cap < SPE_PMU_CAP_FEAT_MAX)
 		return !!(spe_pmu->features & arm_spe_pmu_feat_caps[cap]);
@@ -133,6 +134,8 @@ static u32 arm_spe_pmu_cap_get(struct arm_spe_pmu *spe_pmu, int cap)
 		return spe_pmu->counter_sz;
 	case SPE_PMU_CAP_MIN_IVAL:
 		return spe_pmu->min_period;
+	case SPE_PMU_CAP_EVENT_FILTER:
+		return ~spe_pmu->pmsevfr_res0;
 	default:
 		WARN(1, "unknown cap %d\n", cap);
 	}
@@ -149,7 +152,19 @@ static ssize_t arm_spe_pmu_cap_show(struct device *dev,
 		container_of(attr, struct dev_ext_attribute, attr);
 	int cap = (long)ea->var;
 
-	return sysfs_emit(buf, "%u\n", arm_spe_pmu_cap_get(spe_pmu, cap));
+	return sysfs_emit(buf, "%llu\n", arm_spe_pmu_cap_get(spe_pmu, cap));
+}
+
+static ssize_t arm_spe_pmu_cap_show_hex(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct arm_spe_pmu *spe_pmu = dev_get_drvdata(dev);
+	struct dev_ext_attribute *ea =
+		container_of(attr, struct dev_ext_attribute, attr);
+	int cap = (long)ea->var;
+
+	return sysfs_emit(buf, "0x%llx\n", arm_spe_pmu_cap_get(spe_pmu, cap));
 }
 
 #define SPE_EXT_ATTR_ENTRY(_name, _func, _var)				\
@@ -159,12 +174,15 @@ static ssize_t arm_spe_pmu_cap_show(struct device *dev,
 
 #define SPE_CAP_EXT_ATTR_ENTRY(_name, _var)				\
 	SPE_EXT_ATTR_ENTRY(_name, arm_spe_pmu_cap_show, _var)
+#define SPE_CAP_EXT_ATTR_ENTRY_HEX(_name, _var)				\
+	SPE_EXT_ATTR_ENTRY(_name, arm_spe_pmu_cap_show_hex, _var)
 
 static struct attribute *arm_spe_pmu_cap_attr[] = {
 	SPE_CAP_EXT_ATTR_ENTRY(arch_inst, SPE_PMU_CAP_ARCH_INST),
 	SPE_CAP_EXT_ATTR_ENTRY(ernd, SPE_PMU_CAP_ERND),
 	SPE_CAP_EXT_ATTR_ENTRY(count_size, SPE_PMU_CAP_CNT_SZ),
 	SPE_CAP_EXT_ATTR_ENTRY(min_interval, SPE_PMU_CAP_MIN_IVAL),
+	SPE_CAP_EXT_ATTR_ENTRY_HEX(event_filter, SPE_PMU_CAP_EVENT_FILTER),
 	NULL,
 };
 

-- 
2.34.1

