Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5911F1E1A25
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249731; cv=none; b=E7TSHF9N+P2aAEfen+ykV9Dz8Rc+dmHum8uvd5ewoSTTZ2r9EB3/1TWbZtZoVLvPCoEKvBhMy3+zmClaHrXioAnBHX99CMtESIVXuePxuOaw7YUF0MRfkSnnRc31Rot/xO1c6+CH1rMM5ZBr0C1S4nZrC6FPEVpuXjmifSuvo3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249731; c=relaxed/simple;
	bh=CPIQBfuEyrb/RFbkN7gxRqH/FsCDuiKTV0q6WzsLc6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gEAqsBV4YG3PmfJHJt1Rf9SPxqRL5JPfpLwkqNuvSrzmRwug7wEM8f65/ORxkkq+CVAgC5q1I11+P0as3ERoBHbp5C9AP7qk3koTr7V1YfsgLYsqhmq64+3twn/HAHEjoB3x396HwbYOtyExe31aehQZLbSfjSE3LR9K8jyNrCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=z08gdP4j; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z08gdP4j"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3863703258fso9568885f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736249726; x=1736854526; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w4FURCINKr7NX33Z60V+IaJr5vxjm1rQB4e+HJZrgWs=;
        b=z08gdP4jxGT5UWceA3quwm0PRWRYnNdfBXHpSaWJauwA6dyMEzxRAwVYJyX3RzJTAV
         AcxT3DRTgOGKqXmshCW2qi5r7/xAiVd6glOqp7WMlzQEGcgHo56AzNBUCb1K89W+pknL
         dPIE5iCXSlDBkKNma29Yq9t1l3on6YvhJCf+7y7S08gYtODSxoxo3+8EoGQPQGufoE+f
         cVufIKi4rcnh1ids+9V6Ch2pwZUdO2UXhUl2JtNH0E1WrfQsutCTVu+VeiPLFazws+ir
         yL3IcGTFYSUu808oTcXzh5SZv4ouNY517klmcuezPCDqLkfWSPtBMAWpvwmJSGOrqKlF
         dmUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249726; x=1736854526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w4FURCINKr7NX33Z60V+IaJr5vxjm1rQB4e+HJZrgWs=;
        b=OP1eKvzBtbyoRN79zcxC0Xgfe3JSKPFEW7VLzfhQ4GGrsgKe8hs8iqKdEsckzrMiuA
         8Pbgl7wtWxgHoPBElcMI4gHs66JdWP13B1/rCbiLtc7AdSV3B3EemoRUX+PQSKURopHX
         4XLWtiMofLrNlG4erSVacFVvEMMGPAQFHBos8hpx4o+ltY1EAwVFDoUwxkGg07ZpQBrv
         GAF0k4a2dSRDMlNSuEDjsrFty2XYXNHdGjIzGpyB7r1Sk5sHZ3eW5/BTiFneCIwvHjaZ
         RZCKoQHtsJ7iThb4ZRHcp+nEML20VhJghILgyLlWSPKKUictozbkp4ERa7eUWUw0jQBf
         OIiA==
X-Forwarded-Encrypted: i=1; AJvYcCWrHVpVUPbxFcs0ZWblaX6bN8XImpaymkeTsJhUuiqGkrLLgAfgvgj/iMhzx1izkaOmnIsS7Fg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy5zGvubzMEbj/H7sqiVbYRNxwZbaM1oKV0KapkqDMFUqZqKvR
	z4KF/CkN+zpEmFbMHAMtw2re418CkO2gVU551oyH4DCbJy+nSYhFa8cyxIJPlpYUg0B0YNeyQCs
	+
X-Gm-Gg: ASbGncsMyymUYHZpUobBtvbiMpqX11B2mTk/daX0MiYCNxvwctVnLrPaEhrYfAFzVhJ
	PgF//2+rfQM8CbZV2OtoZiYcZPtB4lziADQerkLf1AiHImic3YguWAHjpdJjW8kmfWxNRMaEPvn
	EtT4wazFHW74j9bIxmvU5AbkFh8OcUFCIg5GKzeee6JZ4/Y500YWiQQIGJBKzmnkPdDd4Af5UJ9
	IaEKDJ9Z/QQaRVG282/8iFbLgGMZVjQsvdEEhoSIgCDFmn4bihhiakS
X-Google-Smtp-Source: AGHT+IEH29RMdYlOmIr/teZDq42S20d3YAI2pbz+RQf7IWI1JVotICYgQnNFDbF65Xs29g0Y40tGeg==
X-Received: by 2002:a05:6000:402b:b0:385:faf5:ebb8 with SMTP id ffacd0b85a97d-38a7913498cmr2345876f8f.7.1736249726462;
        Tue, 07 Jan 2025 03:35:26 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e1acsm50299218f8f.68.2025.01.07.03.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 03:35:26 -0800 (PST)
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
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 10/10] coresight: Pass guest TRFCR value to KVM
Date: Tue,  7 Jan 2025 11:32:47 +0000
Message-Id: <20250107113252.260631-11-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250107113252.260631-1-james.clark@linaro.org>
References: <20250107113252.260631-1-james.clark@linaro.org>
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

