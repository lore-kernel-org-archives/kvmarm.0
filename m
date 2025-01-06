Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFB51DEFFD
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 14:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736173543; cv=none; b=VvQHT07SJGFCVfHZGk5xgfed2Ee1tqrfbSW/vPvcRBl2W/in1O9qZWSKmqjqSdNP/ZuuFWyAapzlJ2kwKkhMKuO795TVXse7wC2Rcay1nTg7Uu9t3rmHZMu9IAknQ17Wct0lNsvNEGgGgGxuGv4ZxVDZtf+X5madAJ/WJRqZeYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736173543; c=relaxed/simple;
	bh=CPIQBfuEyrb/RFbkN7gxRqH/FsCDuiKTV0q6WzsLc6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gYeheJsUjPNS17+X7KoWk0XbKiPRsAm7RKSURuCyOtXoYkLFsjTfOd2QFHfEPuvXnFuATc3oK3mWwGP+pC0OlJ2s58dNtUPdjCjvtqeZA6yz4yeAZn6+t/xUscgRGRl1RCm6Q+NaLWDYDprBY61Z2nFh50X4jyZaEMKhUsyeJIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a4KA/Cal; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a4KA/Cal"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3863494591bso7430514f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jan 2025 06:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736173539; x=1736778339; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w4FURCINKr7NX33Z60V+IaJr5vxjm1rQB4e+HJZrgWs=;
        b=a4KA/CalfxTfFKAAO9DXhQUt+YMyUbH+HU+DD6cO4JyIu1buh61Z58s7H9jtkY8sFW
         gCm4BKMgZcBSRL6wn/Z5VaNhF3yUB7CbOw/QPdYvSKvJUKLB0hH9sep4vyHtPJNhabfi
         PJX++Ek3XUlSr10XHIksMe1DI70NLMQ485wvFmqDCBBNavqWpU88+dFoElOta1zDDAAB
         ZBW02Uy42EyfQckCYlQMmh3ojrPHVo3bqE0HX//xThWr+o9jUYA1gw8MWHBUZYRSmWo+
         ysihDlWEeXW11yaNQamvMyw9QvxAQetaKfvHLRMjUXMHhSTo/9uJLi4ycdC07cN1MzjA
         DabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736173539; x=1736778339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w4FURCINKr7NX33Z60V+IaJr5vxjm1rQB4e+HJZrgWs=;
        b=SEYTSiQRxVzEAGo/dXzuJe+yzKOkpMjhqgBTQmoqiZwD/NxISuh1hKZozBIJ5QThAk
         f7fMXDQfSGTC9vfcyTnQlsKoe41hcB4AcaeKrAxM4qTZQ8D3J28STqCkFK1CJwtJJR1j
         sqLk/D8hKU0TKa0oeg54540uzKLvuYG3tE6Bx/VqgENYLfDxshOkquEwUMZqJhXUm45S
         n3wajCJHZJQv7oKUuq6Vlwtlhgl3MInDaB7Mqmvg9sOhLlTPERfxA8egQRggmalg9VHD
         CkgrceiuMA3vm3GxJ4RniDap3Up+az4Z4gOo7E2EESHtu2l1dib+QLgyiq81v4PJnl3t
         PysA==
X-Forwarded-Encrypted: i=1; AJvYcCW1gr0K7UQtK5y6fN1XGxPX/E2Dv38O+c6Wr967j37HiPh5U0dVsQX4oHECThPr/Jo+i/iHzZc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwE0HkQGhRKZISbcMRVlanUby/U9cHqLOXGoO9+5DbW6Jy5LTMa
	KE79ts5wZ2AkY/d8A9rgz4GsW0RZxfuXE6I19ckoTQPlFtFHik5Ql9zF5aZsTUE=
X-Gm-Gg: ASbGncvG+2XZzkdbvhAdmC1vhZJ9wKk543G4A721BUo00oTo89AxpC0PM+NXb+T4jg0
	EDzhOohKhkTPiZV9E8Q/W4IWBCz8+CdQDPdUw3gpJkE2olAHfciQcCnriXzOpHQtkMmnGFVXxe0
	V3c51WvrU9kBXvDdtAMNj67TuL67qQEtyANWelvFPlNnlRuQsCburfaNPjPRHNiUVswx9PVlu1L
	zJYFRnCZJNvqx4x0KVIXdDUVd5A5DPVBLZzuDc7xRfJDVLDWEQn5Zu4
X-Google-Smtp-Source: AGHT+IHNLnyVmlKkbLfI/PDeuk5rdMd8f/IeyvUgQFVnOZ9/TBhF1qyUczOTkIZZk0UX9aboKEWy9A==
X-Received: by 2002:a05:6000:1f88:b0:386:4034:f9a0 with SMTP id ffacd0b85a97d-38a22408cbemr45911323f8f.52.1736173539166;
        Mon, 06 Jan 2025 06:25:39 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4365d116d8fsm577295045e9.17.2025.01.06.06.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 06:25:38 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	coresight@lists.linaro.org
Cc: James Clark <james.clark@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Brown <broonie@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	James Morse <james.morse@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 7/7] coresight: Pass guest TRFCR value to KVM
Date: Mon,  6 Jan 2025 14:24:42 +0000
Message-Id: <20250106142446.628923-8-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106142446.628923-1-james.clark@linaro.org>
References: <20250106142446.628923-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@arm.com>

Currently the userspace and kernel filters for guests are never set, so
no trace will be generated for them. Add support for tracing guests by
passing the desired TRFCR value to KVM so it can be applied to the
guest.

By writing either E1TRE or E0TRE, filtering on either guest kernel or
guest userspace is also supported. And if both E1TRE and E0TRE are
cleared when exclude_guest is set, that option is supported too. This
change also brings exclude_host support which is difficult to add as a
separate commit without excess churn and resulting in no trace at all.

cpu_prohibit_trace() gets moved to TRBE because the ETM driver doesn't
need the read, it already has the base TRFCR value. TRBE only needs
the read to disable it and then restore.

Testing
=======

The addresses were counted with the following:

  $ perf report -D | grep -Eo 'EL2|EL1|EL0' | sort | uniq -c

Guest kernel only:

  $ perf record -e cs_etm//Gk -a -- true
    535 EL1
      1 EL2

Guest user only (only 5 addresses because the guest runs slowly in the
model):

  $ perf record -e cs_etm//Gu -a -- true
    5 EL0

Host kernel only:

  $  perf record -e cs_etm//Hk -a -- true
   3501 EL2

Host userspace only:

  $  perf record -e cs_etm//Hu -a -- true
    408 EL0
      1 EL2

Signed-off-by: James Clark <james.clark@arm.com>
---
 .../coresight/coresight-etm4x-core.c          | 49 ++++++++++++++++---
 drivers/hwtracing/coresight/coresight-etm4x.h |  2 +-
 drivers/hwtracing/coresight/coresight-priv.h  |  3 ++
 .../coresight/coresight-self-hosted-trace.h   |  9 ----
 drivers/hwtracing/coresight/coresight-trbe.c  | 10 ++++
 5 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index dd8c74f893db..fbc4aa378527 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -6,6 +6,7 @@
 #include <linux/acpi.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
+#include <linux/kvm_host.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -268,10 +269,28 @@ struct etm4_enable_arg {
  */
 static void etm4x_prohibit_trace(struct etmv4_drvdata *drvdata)
 {
+	u64 trfcr;
+
 	/* If the CPU doesn't support FEAT_TRF, nothing to do */
 	if (!drvdata->trfcr)
 		return;
-	cpu_prohibit_trace();
+
+	trfcr = drvdata->trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE);
+
+	write_trfcr(trfcr);
+	kvm_tracing_set_el1_configuration(trfcr);
+}
+
+static u64 etm4x_get_kern_user_filter(struct etmv4_drvdata *drvdata)
+{
+	u64 trfcr = drvdata->trfcr;
+
+	if (drvdata->config.mode & ETM_MODE_EXCL_KERN)
+		trfcr &= ~TRFCR_ELx_ExTRE;
+	if (drvdata->config.mode & ETM_MODE_EXCL_USER)
+		trfcr &= ~TRFCR_ELx_E0TRE;
+
+	return trfcr;
 }
 
 /*
@@ -286,18 +305,28 @@ static void etm4x_prohibit_trace(struct etmv4_drvdata *drvdata)
  */
 static void etm4x_allow_trace(struct etmv4_drvdata *drvdata)
 {
-	u64 trfcr = drvdata->trfcr;
+	u64 trfcr, guest_trfcr;
 
 	/* If the CPU doesn't support FEAT_TRF, nothing to do */
-	if (!trfcr)
+	if (!drvdata->trfcr)
 		return;
 
-	if (drvdata->config.mode & ETM_MODE_EXCL_KERN)
-		trfcr &= ~TRFCR_ELx_ExTRE;
-	if (drvdata->config.mode & ETM_MODE_EXCL_USER)
-		trfcr &= ~TRFCR_ELx_E0TRE;
+	if (drvdata->config.mode & ETM_MODE_EXCL_HOST)
+		trfcr = drvdata->trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE);
+	else
+		trfcr = etm4x_get_kern_user_filter(drvdata);
 
 	write_trfcr(trfcr);
+
+	/* Set filters for guests and pass to KVM */
+	if (drvdata->config.mode & ETM_MODE_EXCL_GUEST)
+		guest_trfcr = drvdata->trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE);
+	else
+		guest_trfcr = etm4x_get_kern_user_filter(drvdata);
+
+	/* TRFCR_EL1 doesn't have CX so mask it out. */
+	guest_trfcr &= ~TRFCR_EL2_CX;
+	kvm_tracing_set_el1_configuration(guest_trfcr);
 }
 
 #ifdef CONFIG_ETM4X_IMPDEF_FEATURE
@@ -655,6 +684,12 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
 	if (attr->exclude_user)
 		config->mode = ETM_MODE_EXCL_USER;
 
+	if (attr->exclude_host)
+		config->mode |= ETM_MODE_EXCL_HOST;
+
+	if (attr->exclude_guest)
+		config->mode |= ETM_MODE_EXCL_GUEST;
+
 	/* Always start from the default config */
 	etm4_set_default_config(config);
 
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 9e9165f62e81..1119762b5cec 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -817,7 +817,7 @@ enum etm_impdef_type {
  * @s_ex_level: Secure ELs where tracing is supported.
  */
 struct etmv4_config {
-	u32				mode;
+	u64				mode;
 	u32				pe_sel;
 	u32				cfg;
 	u32				eventctrl0;
diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
index 05f891ca6b5c..76403530f33e 100644
--- a/drivers/hwtracing/coresight/coresight-priv.h
+++ b/drivers/hwtracing/coresight/coresight-priv.h
@@ -42,6 +42,9 @@ extern const struct device_type coresight_dev_type[];
 
 #define ETM_MODE_EXCL_KERN	BIT(30)
 #define ETM_MODE_EXCL_USER	BIT(31)
+#define ETM_MODE_EXCL_HOST	BIT(32)
+#define ETM_MODE_EXCL_GUEST	BIT(33)
+
 struct cs_pair_attribute {
 	struct device_attribute attr;
 	u32 lo_off;
diff --git a/drivers/hwtracing/coresight/coresight-self-hosted-trace.h b/drivers/hwtracing/coresight/coresight-self-hosted-trace.h
index 53840a2c41f2..303d71911870 100644
--- a/drivers/hwtracing/coresight/coresight-self-hosted-trace.h
+++ b/drivers/hwtracing/coresight/coresight-self-hosted-trace.h
@@ -21,13 +21,4 @@ static inline void write_trfcr(u64 val)
 	isb();
 }
 
-static inline u64 cpu_prohibit_trace(void)
-{
-	u64 trfcr = read_trfcr();
-
-	/* Prohibit tracing at EL0 & the kernel EL */
-	write_trfcr(trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE));
-	/* Return the original value of the TRFCR */
-	return trfcr;
-}
 #endif /*  __CORESIGHT_SELF_HOSTED_TRACE_H */
diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index a728802d2206..d6eb0d525a4d 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -1113,6 +1113,16 @@ static bool is_perf_trbe(struct perf_output_handle *handle)
 	return true;
 }
 
+static u64 cpu_prohibit_trace(void)
+{
+	u64 trfcr = read_trfcr();
+
+	/* Prohibit tracing at EL0 & the kernel EL */
+	write_trfcr(trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE));
+	/* Return the original value of the TRFCR */
+	return trfcr;
+}
+
 static irqreturn_t arm_trbe_irq_handler(int irq, void *dev)
 {
 	struct perf_output_handle **handle_ptr = dev;
-- 
2.34.1

