Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9642922EE41
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 10:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407954; cv=none; b=ori63hC3BakS4dItdadLfSPYPgWCCKKLBsxpfJu4Quz/k3LSOud9bAU4LjfTrnSCOGauMSdZqEJdwqSGdk8LuohrkEwLDnNcr8Qt2W0gLVhyhPrlEF9g7KiWYr0du4cietw2yGmcvyDDR7+28/0Zo84XUe5VBL7MS7PNd0TEq8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407954; c=relaxed/simple;
	bh=pMtsPPkR/TZ2GwbF+ikIZ8cONXgj2KQRbInBexTV9Hg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lsB3G+vX3NmyM/kxbQffVqEv4XBWl53rpsYDk84bvb5FGDAkTSaAAHEUYgQQKZAkQ4OD0Eofy2tV1+lBkHPyAbyQKEwyodPG+RRusAxxwlvwU44B03aZe+T0RRo4vfpIEUdgS6hMrkgh1YShTcpDOjGf4+rU/FgL3JdcwqyaKnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TSNEmnB3; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TSNEmnB3"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539ebb5a20aso5987000e87.2
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 02:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731407950; x=1732012750; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ypieNLjv9hoDv5n/xchGDgtSOzf0gFSsJH7dIkvwXY=;
        b=TSNEmnB3MbZXtBLwPmNV1ZZX26FEaXALgOTMLjLTFS6coZAcKOd4jB8D0wgjQ6MwdE
         PeuT30re2Aci69e797zT2Z2frYUbAKn1BYcxjBxVGw7vl5Qi55GsW0xbFPHLHvZynVJO
         Rrna/IKrj0Z1wMhUSF74MnUkobY/qhGPQyxJMWsKnvVo5vWzoOfqHY1woY1lREvV1xU5
         bHVV8fCzo4xPznUeIpIAJfW2bLUpctFXOHg8mO4sHYkLBnPofv8KjwN+qAuHg71OATmq
         lShjJtECbxoKjxPV4iU9qCa5zwI28YC3u/TbpFniLaokKUmZ+OxXZrtEtlDNDqmiynUI
         /GYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731407950; x=1732012750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ypieNLjv9hoDv5n/xchGDgtSOzf0gFSsJH7dIkvwXY=;
        b=pEzasGPgDIoR6/k13N33Lrx4vZ6Okz02LBC0nvtRCTFDbCeNOB17ULxr3nBalLE8MH
         nwakZtzkvQnAOjiU1v2zVe1EMz9EXHPwJEgY0S8c/V3ryXNOmHZT29rEhcvrv19sjgG8
         LTDqRfMhrHDOArZQUfLsX97jIBQqlven5HbTZdBMWJnYl8BfrbOsFHUzQjTt7Lm+5FRy
         1IefPAV7M9nxxqnBITI0WwU/WhztDi/bTZIw7j6qvoZYbmwd3U7XjZCDdiL7K5YO7880
         9zz8qEh456anLXJfFORyiOAnzu5FpBVtCXNhjKs2cIshe0To1WTOv27PDeaiqA2LdzCr
         8ZXg==
X-Forwarded-Encrypted: i=1; AJvYcCURJFjqW8GyHp7Bt6fvmp/N5H5jsznff/W6EdsIleL2vGDsF6UM77iNCIQMYABEvj0siObaVqM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyp+RMJYyQd6Msw9OCFqFD6Loe/r0b56mz3sFUR+mhxPkAoUmAY
	mrXR4K6q6MhU/5aPC0qFYJVHJgnWMiRhV6TwdO3oE9wTSM40n/O5p/G3mfpP/ZE=
X-Google-Smtp-Source: AGHT+IHSYTMPa2/VMqq86Adc2dUVIbc8G1yKZTl0omP+kqjQjHeg+DHnbhm+3rJYolYmdWgjyHudRg==
X-Received: by 2002:a05:6512:1395:b0:539:959e:f0e8 with SMTP id 2adb3069b0e04-53d862d3f7dmr8300391e87.21.1731407950470;
        Tue, 12 Nov 2024 02:39:10 -0800 (PST)
Received: from pop-os.. ([145.224.90.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432bbf436ffsm142270955e9.44.2024.11.12.02.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:39:10 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	coresight@lists.linaro.org,
	kvmarm@lists.linux.dev
Cc: James Clark <james.clark@arm.com>,
	James Clark <james.clark@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 12/12] coresight: Pass guest TRFCR value to KVM
Date: Tue, 12 Nov 2024 10:37:11 +0000
Message-Id: <20241112103717.589952-13-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241112103717.589952-1-james.clark@linaro.org>
References: <20241112103717.589952-1-james.clark@linaro.org>
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

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 .../coresight/coresight-etm4x-core.c          | 43 ++++++++++++++++---
 drivers/hwtracing/coresight/coresight-etm4x.h |  2 +-
 drivers/hwtracing/coresight/coresight-priv.h  |  3 ++
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 66d44a404ad0..347dea49a996 100644
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
@@ -271,9 +272,23 @@ static void etm4x_prohibit_trace(struct etmv4_drvdata *drvdata)
 	/* If the CPU doesn't support FEAT_TRF, nothing to do */
 	if (!drvdata->trfcr)
 		return;
+
+	kvm_set_trfcr(0, 0);
 	cpu_prohibit_trace();
 }
 
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
+}
+
 /*
  * etm4x_allow_trace - Allow CPU tracing in the respective ELs,
  * as configured by the drvdata->config.mode for the current
@@ -286,18 +301,28 @@ static void etm4x_prohibit_trace(struct etmv4_drvdata *drvdata)
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
+	kvm_set_trfcr(trfcr, guest_trfcr);
 }
 
 #ifdef CONFIG_ETM4X_IMPDEF_FEATURE
@@ -655,6 +680,12 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
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
-- 
2.34.1

