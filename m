Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8D9274B29
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 11:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652232; cv=none; b=acu66fM7p8PMaJarsq+39W05KOhJSy+hU9sSdj3cU+Jpd9dhZt0uCz8NgH+lpRNlQjZldVU5OsvMjyxZM4dd8ybndTDRRXxIJdbXMdL99+mHgKSkBVhQhyeKtP2aGoI4QTVKf4VT6XhGqllLwMmfeqMBPbIIL2XAmLGlPCBx/y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652232; c=relaxed/simple;
	bh=6LM6jJAX7/wRjLu63PFJ21YibPN4QtHqwn0zElm0y7w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tGhPqv5BTeBZ+QsZMZgl76RJJQHYcFHSs+bNMUWMQSh6ng3DFt8ekdSMUyk5llrk92SWXLwkKQMpGlHMXuSmDVGem2/Ih538icaJl6ON4hVbFH6lsSjBsr0sbQpd5C95mc5hLf15LhH6419bBVzchGKkvyt7jkgwjdE0N53cAnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UPcgrLNa; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UPcgrLNa"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3b7910123a0so1778500f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 08 Aug 2025 04:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754652228; x=1755257028; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xMesWcHoEa33KjF/J2eeIl0BbZ+P5s/S1CfPVNJYZ2s=;
        b=UPcgrLNaL8amdz3ViL3wzo6sJtG9kWfpCyjwJPu8Hi8tKumlo3j6XRG77mqOlNmrEd
         U6/4GgMiYYt7xAmBjUiKlMs9n0ERO8xqApSVlTcBYPZAolYixSByRKeLP3SD8LyOJysy
         /++cxjoIwW2XyLMsPRbrD9V/Vh3xckQYtfTD3vA4VBxPAXLnbSCvyih6+LVapDWckJPv
         kEmCnl0Qcoe8+u6S2Ua3zvuUpUx+2NuM8f00tI0ROIkOm5goUiX71dn2zLTRnT+ayThG
         SF9IB4JD/nkw/RwQuJj2v4xEfnerI6LiM5SoePx1yMCOfNWzaojhBekSeiUG6Sl4tq41
         Q80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652228; x=1755257028;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xMesWcHoEa33KjF/J2eeIl0BbZ+P5s/S1CfPVNJYZ2s=;
        b=LaaHEj8U5bYxjdnhPhOcEGTx16SYWWskWFrIyLKLCID088yMXIcb95j7/BzlvQX6Fr
         812WYo+HIHbEdvzjhanKfOtvSsysNwGh1LJfjZyAKJtlI/G3IryNwOU71spdR3ackZXg
         +P0sO46W3Ol1qSEnpWTEMs6q+aIg/p3wkEJmRzNoSERuEFw6JECVUjuziZGx3OsCwy6g
         DWgBIKGDRUivkAlGr97JGm9rzW65bf+zaN3MogIufeC+Rc/zSXPypXQpoBUg8ouQJMSP
         pPygx1YHWV3YXyPXIbfTGksxbPJ/05a3Z8WutknMfOavO0gmYtnlEPbbnrA2ar3RfUnQ
         C/GA==
X-Forwarded-Encrypted: i=1; AJvYcCX2jlmh1OLR+ErvaxKHBd6haPd/Yy+94fgAGGBWkf6rUJJKXNvk+H0E+xcvpmbqzxveJ75n2Uc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyn/Z/mckEfii2y93Z31QlcRYk8TCetwZhliIkXFVZNGQiKWKmw
	ggy5j1pahasV9VuqPjjyIhPeoADsCRUsSEPuF8RR2+E1TIEBAz8diFB1wrq3DBpUMPI=
X-Gm-Gg: ASbGncsnWP5elSXZFhgrvgOH53x3eqWEnZId3nF3GgRo8+vvY2+o9Jns814XBjBsH/7
	6iO2W6kOC1AyOXmmsNKTGMINPlqtUM2bMvf/91Yf5O/PDhNLBbb81oA5kaz5pwMPSUbkeAa+96Z
	3VWUeL1o1EKabKDsYKNnlmUeNmX7Egp+jg5+yJb96FIPBZi1vOAP25LnlNGbLs6p2nwiHXckLFE
	113HuwxcLZrQ0TXCYunTPTDbSJQVeceuQVyilPTp22UUHba7OUtawCIPMPhr1J6Cl12TXl7f3jt
	ekeBhwtzcBkfse3XVCjw5fn+WqDxFBiAhIAPVaIxP8/1SKVRK77L0qj042rsL9aIRnU74CPMebR
	GGjjcWIXmU7Rmyl+chMLJ1+iKjHNGtw8=
X-Google-Smtp-Source: AGHT+IG3KhpqmqY9mPCdYHy2kQ4dmK3mleBKR4K9YT1Bk9x07Zhf4VDQvqcJSmZgyy16+lcV/chGew==
X-Received: by 2002:a05:6000:2483:b0:3b7:8146:463c with SMTP id ffacd0b85a97d-3b900b8bde2mr2125187f8f.59.1754652228218;
        Fri, 08 Aug 2025 04:23:48 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45923c34af8sm233482635e9.24.2025.08.08.04.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:23:47 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Fri, 08 Aug 2025 12:23:00 +0100
Subject: [PATCH v6 03/12] perf: arm_spe: Expose event filter
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-james-perf-feat_spe_eft-v6-3-6daf498578c8@linaro.org>
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

