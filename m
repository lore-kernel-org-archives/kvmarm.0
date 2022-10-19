Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA38C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 19:11:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACA2D4B917;
	Wed, 19 Oct 2022 15:11:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 80-b2JTRZgzI; Wed, 19 Oct 2022 15:11:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FEC14B933;
	Wed, 19 Oct 2022 15:11:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1820D4B91F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 15:11:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lOZf3aJ1AjBw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Oct 2022 15:11:30 -0400 (EDT)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com
 [209.85.210.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E243E4B90E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 15:11:30 -0400 (EDT)
Received: by mail-ot1-f53.google.com with SMTP id
 101-20020a9d0bee000000b00661b54d945fso10070990oth.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 12:11:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
 :mime-version:subject:date:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=43IaqXn32YycCBd3/SGJ6Da4qva/kGDXqjobO4DMXeA=;
 b=4HY6ccFmR0gFVGJJL49oMWNbA49tLjKX8e9cidf2PjExDTDgs4yZ7M1R6X+vfQ5yPf
 uXg06nVBlhUZHS827JXCvrbW4Iy4YdRnHi0+5BfSNSL+AwAg2ipLxg/MiI/m42Ebh5ZB
 wn1t4S7sEMGwtkwKsn0sL3PJTR/2JbQBuyRsAe46xdqxnJKV19z+GoMIZda7SaOv7gZB
 w/L7TzxtdRseCwjbaaD4JLIkrjRm38hHPZ6Y9h2yX1ECQ2+cSqOQWg6KHZ0cW3ifozCX
 PQa2AwFR0ndWqLhnT+1KAfV4rtxrdul0w5tkIsbBjh9HnvEHmZDc28XMFiC5TwlqH8vv
 FqZw==
X-Gm-Message-State: ACrzQf2u3nI9eAYUbh8J6Zu6KxiHqh5eDH0ecvEobrfFCM6tyYimEBvI
 0FZfDoQGXBYoetNoOU2x/w==
X-Google-Smtp-Source: AMsMyM52ccM2SuB4fJVuNR6xyd3GwViwYeYnmewRYJ6qofqTylHkTtpXjuHE/sY2iyCkl53jTYlNfw==
X-Received: by 2002:a9d:6948:0:b0:661:a43c:77a3 with SMTP id
 p8-20020a9d6948000000b00661a43c77a3mr4934314oto.222.1666206690183; 
 Wed, 19 Oct 2022 12:11:30 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net.
 [66.90.144.107]) by smtp.gmail.com with ESMTPSA id
 q7-20020a4aac47000000b0047f8ceca22bsm6816526oon.15.2022.10.19.12.11.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Oct 2022 12:11:29 -0700 (PDT)
Received: (nullmailer pid 3420910 invoked by uid 1000);
 Wed, 19 Oct 2022 19:11:25 -0000
From: Rob Herring <robh@kernel.org>
Date: Wed, 19 Oct 2022 14:11:30 -0500
Subject: [PATCH v2 7/7] perf: arm_spe: Add support for SPEv1.2 inverted event
 filtering
MIME-Version: 1.0
Message-Id: <20220825-arm-spe-v8-7-v2-7-e37322d68ac0@kernel.org>
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>,
 Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Oliver Upton <oliver.upton@linux.dev>, Jiri Olsa <jolsa@kernel.org>
X-Mailer: b4 0.11.0-dev
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Arm SPEv1.2 (Arm v8.7/v9.2) adds a new feature called Inverted Event
Filter which excludes samples matching the event filter. The feature
mirrors the existing event filter in PMSEVFR_EL1 adding a new register,
PMSNEVFR_EL1, which has the same event bit assignments.

Signed-off-by: Rob Herring <robh@kernel.org>
---
v2:
 - Update for auto generated register defines
 - Avoid accessing SYS_PMSNEVFR_EL1 on < v8.7
---
 drivers/perf/arm_spe_pmu.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 0b9b847919d0..ab5fcf02a4ca 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -85,6 +85,7 @@ struct arm_spe_pmu {
 #define SPE_PMU_FEAT_ARCH_INST			(1UL << 3)
 #define SPE_PMU_FEAT_LDS			(1UL << 4)
 #define SPE_PMU_FEAT_ERND			(1UL << 5)
+#define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
 #define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
 	u64					features;
 
@@ -202,6 +203,10 @@ static const struct attribute_group arm_spe_pmu_cap_group = {
 #define ATTR_CFG_FLD_min_latency_LO		0
 #define ATTR_CFG_FLD_min_latency_HI		11
 
+#define ATTR_CFG_FLD_inv_event_filter_CFG	config3	/* PMSNEVFR_EL1 */
+#define ATTR_CFG_FLD_inv_event_filter_LO	0
+#define ATTR_CFG_FLD_inv_event_filter_HI	63
+
 /* Why does everything I do descend into this? */
 #define __GEN_PMU_FORMAT_ATTR(cfg, lo, hi)				\
 	(lo) == (hi) ? #cfg ":" #lo "\n" : #cfg ":" #lo "-" #hi
@@ -232,6 +237,7 @@ GEN_PMU_FORMAT_ATTR(branch_filter);
 GEN_PMU_FORMAT_ATTR(load_filter);
 GEN_PMU_FORMAT_ATTR(store_filter);
 GEN_PMU_FORMAT_ATTR(event_filter);
+GEN_PMU_FORMAT_ATTR(inv_event_filter);
 GEN_PMU_FORMAT_ATTR(min_latency);
 
 static struct attribute *arm_spe_pmu_formats_attr[] = {
@@ -243,12 +249,27 @@ static struct attribute *arm_spe_pmu_formats_attr[] = {
 	&format_attr_load_filter.attr,
 	&format_attr_store_filter.attr,
 	&format_attr_event_filter.attr,
+	&format_attr_inv_event_filter.attr,
 	&format_attr_min_latency.attr,
 	NULL,
 };
 
+static umode_t arm_spe_pmu_format_attr_is_visible(struct kobject *kobj,
+						  struct attribute *attr,
+						  int unused)
+	{
+	struct device *dev = kobj_to_dev(kobj);
+	struct arm_spe_pmu *spe_pmu = dev_get_drvdata(dev);
+
+	if (attr == &format_attr_inv_event_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT))
+		return 0;
+
+	return attr->mode;
+}
+
 static const struct attribute_group arm_spe_pmu_format_group = {
 	.name	= "format",
+	.is_visible = arm_spe_pmu_format_attr_is_visible,
 	.attrs	= arm_spe_pmu_formats_attr,
 };
 
@@ -343,6 +364,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
 	if (ATTR_CFG_GET_FLD(attr, event_filter))
 		reg |= PMSFCR_EL1_FE;
 
+	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
+		reg |= PMSFCR_EL1_FnE;
+
 	if (ATTR_CFG_GET_FLD(attr, min_latency))
 		reg |= PMSFCR_EL1_FL;
 
@@ -355,6 +379,12 @@ static u64 arm_spe_event_to_pmsevfr(struct perf_event *event)
 	return ATTR_CFG_GET_FLD(attr, event_filter);
 }
 
+static u64 arm_spe_event_to_pmsnevfr(struct perf_event *event)
+{
+	struct perf_event_attr *attr = &event->attr;
+	return ATTR_CFG_GET_FLD(attr, inv_event_filter);
+}
+
 static u64 arm_spe_event_to_pmslatfr(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
@@ -703,6 +733,9 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	if (arm_spe_event_to_pmsevfr(event) & arm_spe_pmsevfr_res0(spe_pmu->pmsver))
 		return -EOPNOTSUPP;
 
+	if (arm_spe_event_to_pmsnevfr(event) & arm_spe_pmsevfr_res0(spe_pmu->pmsver))
+		return -EOPNOTSUPP;
+
 	if (attr->exclude_idle)
 		return -EOPNOTSUPP;
 
@@ -721,6 +754,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	    !(spe_pmu->features & SPE_PMU_FEAT_FILT_EVT))
 		return -EOPNOTSUPP;
 
+	if ((FIELD_GET(PMSFCR_EL1_FnE, reg)) &&
+	    !(spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT))
+		return -EOPNOTSUPP;
+
 	if ((FIELD_GET(PMSFCR_EL1_FT, reg)) &&
 	    !(spe_pmu->features & SPE_PMU_FEAT_FILT_TYP))
 		return -EOPNOTSUPP;
@@ -756,6 +793,11 @@ static void arm_spe_pmu_start(struct perf_event *event, int flags)
 	reg = arm_spe_event_to_pmsevfr(event);
 	write_sysreg_s(reg, SYS_PMSEVFR_EL1);
 
+	if (spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT) {
+		reg = arm_spe_event_to_pmsnevfr(event);
+		write_sysreg_s(reg, SYS_PMSNEVFR_EL1);
+	}
+
 	reg = arm_spe_event_to_pmslatfr(event);
 	write_sysreg_s(reg, SYS_PMSLATFR_EL1);
 
@@ -990,6 +1032,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
 	if (FIELD_GET(PMSIDR_EL1_FE, reg))
 		spe_pmu->features |= SPE_PMU_FEAT_FILT_EVT;
 
+	if (FIELD_GET(PMSIDR_EL1_FnE, reg))
+		spe_pmu->features |= SPE_PMU_FEAT_INV_FILT_EVT;
+
 	if (FIELD_GET(PMSIDR_EL1_FT, reg))
 		spe_pmu->features |= SPE_PMU_FEAT_FILT_TYP;
 

-- 
b4 0.11.0-dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
