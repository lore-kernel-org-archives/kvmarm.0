Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C808A2D8DC4
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103116; cv=none; b=IGe34cwdIBUVcu7KRL4GAtNki53ClRv1USojGvOXK0bjfYrWZCbI06RQaMebEP+DtdrDQz5t3mZnyX+2jP8aMaoVhuBCC1sPTz6Z4rZULgwKmi20jrgf4Heftk47dEwiGZFrVhLIX3EDDu/xDvOAWRPDiTHVkrGhu555Hzlxk2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103116; c=relaxed/simple;
	bh=ioJvhXZDfjEQt2ziDmXFW0nCeOZA32fi0+BXFuZXXMc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IxQrR8RfL2VY37J9XopLiE1eV62BOY88y2e/dYWCXUcA1L3rafXOndpNXuoxNvw4Aa964SpuOgR2nZ9OqOOPUQf2Yg2c2UwdXUuaNZEX1AzldbcgJ2D47rqmtd4sgKYCVSXuImbJZi9OBpD8JiXkhDkViPSC3PPih6ID2K4f0cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o6/78GWR; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o6/78GWR"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b49ffbb31bso2692986f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753103113; x=1753707913; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55PgdiB+GN4B/bQE+c0k9cxCNgbWScuraMcZpMP7YeE=;
        b=o6/78GWR8fr3ojPmNC5sNsHg7Gj+izbA8OEfUQ28Sy8osKLvu2SPAT+dnocQ/HYZLm
         obOsuLJ5f9QfzdE9zpWIOUgmoDDA7klhMyMNMgCMwZ9gDzfMfwhqpU9Zla+xKflEvM80
         MGmw1e+ydbJCHx7Twog+hs4gc0nti4PtmZseUgyKnWAkLzXtXNc/GBMrqlHSEm0tF045
         KhPzz3WZ+VdMG8IK87B5r+Q4lv66+it9tsb0xfukCIlrRX23KKq2eWE8hok3uZeichHY
         B/xmxez7UERNKsxNro9Wl4vioe8Ls3r+DlY4FadyrhsK//Gl8GusnJZqryqKBCB7KS6J
         3SCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103113; x=1753707913;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=55PgdiB+GN4B/bQE+c0k9cxCNgbWScuraMcZpMP7YeE=;
        b=q5Zf/+12uSZ/6Mme3gk2xGo0j+RFRWBeAFwzaBb7z3Xe1HVjYow7qiorExRrpkKLmK
         HiGrOrTOGWOtZBLK8zG2ST2pIUKyceFqLi5YjscYvcAg1NUS+lElZniD97rXMX861XEP
         AzOZy7od3Oh3XS7mZUfl7FfQZU1BgcFg4oixmEakQWB31tt6iN5G8z7VeKCFf76Q8Mqc
         QJLy4gId5tbaefz7UYu9M4yhvbHO3DOVcFI7Ska0TbDb8kzVxQK/bRpZ/8BwOYHvml3n
         sXYFfAUpateb6edpGmlfJowQ/Z47MHQqYdIWc2/+5SRrp8QfMVP+K3QWI4zqc3QMUbgk
         VWng==
X-Forwarded-Encrypted: i=1; AJvYcCUbWfQXsFLXjxrViCGzZItZP1j2m6Mt+AoYmHoL2RMfLuuMZMJ1cfYvcGPIytODQS2tNMLyQzo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIcbd5GkDk22VJbFoM8E64m/Mw1ILLpakFeQojIoJeo215zXXd
	LUoCTblxdufXCbZDsikZV7GwHhe8MO2xjVlkx1jh8oV8wAfCfuCN0/zOzOBNSPqvFbI=
X-Gm-Gg: ASbGnctJI2iBEQYfmF/SCiHmJ4I1X3BugoNc1XUQ6ZV/WYVBwv7+O2T/GA/c3QFiWZp
	P+DTte2FN1EgLNdqBa1kI/f6MCH3WPKM9fF5tFwNpd5gtwM/2XYqXzNVsR0yVuW9ZButr1JK1da
	iMQDP90xMdz1fK6TuiKbiaXjgjkXoxECfKwMNZBgfUH7V+t/ror4wrOfxSMmzLyw0UnCs/txwu1
	5ezcsGHmW2wdql7prgprkp2Q5XIbjxc6pON+rIT6UBEmqjritXk7PGiMzqa5tJ6hw+jmHo9A0gb
	6imCT3jimC/+WlwK8nl8nj/kMG+o3oOTRA6eJ7F6fRLgVoocLFQ54m+FcPMyoI0bl75lgZcewb2
	mZ20ErS9Ns2sAUIvdV4LqGzhJ5UtmoI4=
X-Google-Smtp-Source: AGHT+IGWq4jzpIhEdv6123LGkJS3kcsTALE6uCDdvRzPU6u7cW14a0/tv2JQi8/2wxRmO1WYzyv6ew==
X-Received: by 2002:a05:6000:430c:b0:3a4:d939:62f8 with SMTP id ffacd0b85a97d-3b613e984ccmr12134458f8f.32.1753103112960;
        Mon, 21 Jul 2025 06:05:12 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c632sm10485077f8f.80.2025.07.21.06.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:05:12 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 14:04:57 +0100
Subject: [PATCH v5 03/12] perf: arm_spe: Expose event filter
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v5-3-a7bc533485a1@linaro.org>
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

