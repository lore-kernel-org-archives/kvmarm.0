Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735A928F523
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 12:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753102457; cv=none; b=UjelIlTdMpX8yZ/6VY7SkGujTzryDFCE0e16IM6/gPqMwxGOCLmjB4sOvdHNzIWsZdn0bFnQFo5B3ScBTmjg6wdzNqv8oc+V/2XJshFTZEmeGVt872Db1YyllrhV78zQZfRY8361IdgIqO4xgj5fdAQxFQaldF67ByXyLEYlU4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753102457; c=relaxed/simple;
	bh=ioJvhXZDfjEQt2ziDmXFW0nCeOZA32fi0+BXFuZXXMc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bovUPvlcn2yMZDD+/I3tSuWa5qArnDFFOXQfl/hw0sIzLsXPSZ9it8ICO/IkJc4IBUuq+cPxg3GVZl2auEIpbCvsczunb1hNCXwDD3XOt3cb0yE1uex4VbxVHruJo5SOUQUSDEdouNTzflZoU2nBHgBAkbq2kUdh+DBO5kfepaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=t4kOGD03; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t4kOGD03"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a4ef2c2ef3so3207543f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 05:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753102454; x=1753707254; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55PgdiB+GN4B/bQE+c0k9cxCNgbWScuraMcZpMP7YeE=;
        b=t4kOGD03NtaNm6fTtj20p8ZXf916p7/c17INNiB0G4FrTrSqdxbkXVZNm9520C0zkz
         MtGmbL7j2ymIgAAYrRVQgRJLyYx6uxSMNIY3oO3BR3yNNM/cf2OH3LyX2VZ7ICI6QqC7
         gWeHNwO1dfija/rMbC14Rs9v4MhZ8YB0K672tM+mj3KU+G10fXJytMN5r0pa6EOnWHgA
         ycLJK7IJdww1O856KVilNrahILpqGCnmKzQGtYbIABeGWh6jCdFEGDbAfjw6ehAqnP67
         q0S+do+FGVHqqd3ZmG4/9IQ5b+0joPyBA9OexXtf8yUja8q21kpE7CZyTlSxlOEA1CWh
         OXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753102454; x=1753707254;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=55PgdiB+GN4B/bQE+c0k9cxCNgbWScuraMcZpMP7YeE=;
        b=uJZ+7E8stKa9+SFyt1cOQ84cGQQsZcqLCoM2NxDyZpsXXfpAK4h+GvGPIcxf/RVoGZ
         KdHZckCEOYpZqpgUWF5B9E7yo0rRx+ftt6Gm07lwfFZixRhk8/Q5MSet3BDaRFL89Mzf
         LyViAWc3drRg36q/NGQsRH6e10RNdH7w1k6WFhDfCfRH6ODlAHxsqChvyCBVshoOH7AW
         72Ap6t4nSDiz3S4PF/RMh1maJfLtx1a4PChBi/6oZLqqsMavvhymiFa2npTySanip+RT
         psOaQvP/dS25srp3rYF7l2CsNDrNQXAVCdwafxb3CX/W9Wl7RDVJMkL5nA/0osDJtrNh
         VSZw==
X-Forwarded-Encrypted: i=1; AJvYcCWYVP1mDYoFgRDaZbdMpGdUQP1alLTpt2/TDKeCVoGi9X12tuFsFGlmKnjr2WHFMWshzYICmsY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzI9jzQch0Iez4+WbsKY0IXVQA/7AgkZUosPaxf/vFY+ZMMYnFX
	pyQDVSD1/djDTh+VjEj6I8iZBkVhLHoFwMLIqklMJ4ZkOMHNWVO0xlDEIRrcmCHCIKw=
X-Gm-Gg: ASbGncvr6pH6QJZqgnsqQVOrbGQFau9+k1XUwEDIZwi8GCji7p6I6tapUbzDoP0IW4J
	EiNs+GwQPpZ4opO2biLn0wz/zCyIleR7+WS03w3VbIMovjLmyMjMt+EPaewgopZF68hHVSiRb/p
	A2H5/XPQIgFZ0MvNPKtFJhjGqD2jDyl6ypOETsYbfYWtwECVkipYxG1ft2/XLSOYGSFXpA3LZFf
	BOtUSYCqlG41zE5jnwKTbxz2DbvwFdkJTKLujCCwwHo5Q+xtXa31z5r+ewiM8igwmFRHNvzooNj
	b0oFJ2EMwIUF0/6GBSz29VaNkO8mGm1S5hTLAnKHRMtPn3iNtrsGQUKtn8CzYBxgUiUUIoG9D9k
	K+4vgVnkQEfibo86bSMWIkbLvDAAlWv0=
X-Google-Smtp-Source: AGHT+IEL8PHgJ4SopjgITysCZQMBksfX7qBSxWXMtzthfbfPyv1+5wLWmZAb1M4QE19p4pJCh7/Zmg==
X-Received: by 2002:a05:6000:402a:b0:3a5:27ba:47c7 with SMTP id ffacd0b85a97d-3b60e50ff6amr16938260f8f.48.1753102453767;
        Mon, 21 Jul 2025 05:54:13 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75de26sm98995225e9.33.2025.07.21.05.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 05:54:13 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 13:53:34 +0100
Subject: [PATCH v4 03/12] perf: arm_spe: Expose event filter
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v4-3-0a527410f8fd@linaro.org>
References: <20250721-james-perf-feat_spe_eft-v4-0-0a527410f8fd@linaro.org>
In-Reply-To: <20250721-james-perf-feat_spe_eft-v4-0-0a527410f8fd@linaro.org>
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

From: Leo Yan <leo.yan@arm.com>

Expose an "event_filter" entry in the caps folder to inform user space
about which events can be filtered.

Change the return type of arm_spe_pmu_cap_get() from u32 to u64 to
accommodate the added event filter entry.

Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 drivers/perf/arm_spe_pmu.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 051ec885318d..3e9221a22a61 100644
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

