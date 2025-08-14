Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F912ECE9A
	for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 09:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755163564; cv=none; b=U8by0A2SNsRpL0AXLiy0+BvLWtrnOnCNw/HrQP3UgyeGCxMc4q1XZmLL5ro+v/uzLq6mrRuSmnWhiciJ/NhEe6v7hxhLiMgHkhwG2L3OZWgB7XMiw7g/DoOWozGCjhP3mbOFdNj4X2u50l3ZFK0cAwJMBSHCZMKkTfsMEBKC5XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755163564; c=relaxed/simple;
	bh=1dn2TsDH9c3qn851HU6KhoRjFDuyNupOzJtkpyRLaL0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=thnIbZb9GA5quELjjI+xCSOuHk3x/RDLXelNCBIbVMVNFAH1y9Q898JbcJQYmSg/Ud6/VwN94DK7X7m9RuCETzEPRvVTpAKQ5tdOgakOPKNc8tzFV5VlAWddzHAcPFRDPkJ+zYubqTHnbA+fNBTJXpqPhuRJgk10mggvtIil/rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zBz2UYLm; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zBz2UYLm"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b005a3bso3357525e9.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 02:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755163561; x=1755768361; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2rccDGxo7Zi/+ePrAmZStYRWWCBeSec1uJGq7oyHErE=;
        b=zBz2UYLmeqFU+XA5KBW4CiSicB9fNLo1ppnYS79lJBhNB/A4Y1EDwS7uB7yqM0Byks
         t1OBl+ylKu8Ffj6uXGb+jPFgJEo4Z2EKPS6ZbXjAld3Km4sJeigQDkR+J82kExJta4CF
         i+v3P7aZFtRKsFWhNKe2ooWtgNCWAFJNyAyOSJc3q8wFw76cfCt8hQ4SYyecCXnNDlYI
         p8l5Za9nv+cgVnydm8NVIWg/JTy5b1PJigfTCcgzlC9/vut/KlKOLn4UToluoGk+9dCA
         dS/nxKkT7/04FJn0buL/EHJmEFoAfaLntilZEYZXkWFNjsHe8y6KKviqBNp3NfC9Us8G
         huEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163561; x=1755768361;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2rccDGxo7Zi/+ePrAmZStYRWWCBeSec1uJGq7oyHErE=;
        b=AfJa9sOl/G+O0DGlV7sjA452CQ/V6haiNr6EdSJePJ1sLEvKWgAERd4FCxc5wUAoqR
         AVzH2sURRoxjqXl/PjiDjQP0oQwDtK9RQb5/0ktZ1r0ak6PgoaxXeFcnuLgB8T8jZ67r
         i+GEHDWC0Irq3MkzCdGK24ZCmfay0Yssv7IYKH8IG+BoptbntZYo4oLAwTWeVXd+/txA
         93YD2OJkiP9lAIt7WGTEFF6qHaYvZWiottKv4pWNKyqAkkXJK726wyA2TeqZkjDG2Cqr
         WDxCXDTgBlkdS0pA4fHZ6vQMsKP3PLNrFOroyKTksBSYVqvoR6PhMUzeCFBLiFu12m62
         xjuw==
X-Forwarded-Encrypted: i=1; AJvYcCUuqZ4Z3KB+EN9Sa4+1QlX4BVo91P/XA5k2701aysJEnFpqMZITdy1eCfVvJU2FU3mKfG5Ze70=@lists.linux.dev
X-Gm-Message-State: AOJu0YxD3foiayil2kkFWLIQ0eFVVGlmWmOWNzxuzJIMFdAL05qeUT9i
	yUkvlWGxduv16KO1ZoFnw0O/51wj7+TttDeLOrEB62bIeA+XqfhxWIiaZvlz5eSKGSF5W1Pn5LP
	r0Zbz
X-Gm-Gg: ASbGncuKsFLFl7maxNKnolwOsWpLNwq3p1bK3zFH1prUxrD57g2+14Z5dNZm+9J3AEg
	XxkoaDpAPjGgomCO5eBWhHAo25/NWNZYJUyvCoekTvdD/Jbvy3UIk5mXsfYKaAuil34souUeNgj
	D/2QjgXC41S5EczgplpTCoArt8hNW/NdueeqtRULrLJPozIfR6mVTYXJs9xHj83sHcCUYVZqYcj
	sGNpqq4NW5Ji0Q929PeuL3F/xMQ2K5j1bCDVdZep2wE0v/MnXOVB4iRzWrhNIsn0Rdmj1vum3xi
	Cb++HoAkyr+xMTFHN5/+YFo0Lo8Z3DwYnxsnqf5QuQQWKP2n9qLMmJTwrvan04DCUc591aBs0ci
	Zb0PSkKWqQusVAMewgV/BwRM58+jM5x0=
X-Google-Smtp-Source: AGHT+IF3mN9YM+z59LW2L2RCIJP1151F1ryrxu3DBo1bIpBosGzWHxhnT9S0+1q8xFvPjiRKK5C0xQ==
X-Received: by 2002:a05:600c:4705:b0:458:bd31:2c27 with SMTP id 5b1f17b1804b1-45a1b6535bemr16452535e9.23.1755163561367;
        Thu, 14 Aug 2025 02:26:01 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c76e9basm14536775e9.21.2025.08.14.02.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:26:01 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 14 Aug 2025 10:25:25 +0100
Subject: [PATCH v7 03/12] perf: arm_spe: Expose event filter
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-james-perf-feat_spe_eft-v7-3-6a743f7fa259@linaro.org>
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

