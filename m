Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0002C4167B
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 15:55:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2E54A1D9;
	Fri,  4 Nov 2022 11:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cpzLrHDBqmQd; Fri,  4 Nov 2022 11:55:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B827F41278;
	Fri,  4 Nov 2022 11:55:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EA6943C8C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:55:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S40o8YM0dFX3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 11:55:29 -0400 (EDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com
 [209.85.167.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E99C241016
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:55:28 -0400 (EDT)
Received: by mail-oi1-f170.google.com with SMTP id p127so5574103oih.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 08:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
 :mime-version:subject:date:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=YXxvA5Cmwe9nSMxNL2yH3Amn9qhEZ+Ppqa0CVXQahDM=;
 b=DljyexvSXsr9Mg833225aLFkgDwyEELxoYX+j96GcQ4Z8WztS9xNd3k/zTiDtuJrNA
 fsNCsU0w0JMooYY3Ib9bLEvTgOqkkbl1123BSGDIaxvfJB8PcCWj1IArXCn2/MyajQct
 uvBviQR3gwZElrxQfoX9SLIX/2rz7DUejY3kidfwsfiCW47x6KiYncyZaXwXdRBtHh/h
 0twcF4+Iq/TpL6GXB51UMHMYZomz5O82CG66bt8THpIKoLZVhPAD46e2rprcZtpvX84H
 4pMtRmQ/NS/8tXSG4uptwE9rqUr90Cjk82V3X3QYDdMLrgDzeK+ZSAG/5/HrSao/qRn6
 zwww==
X-Gm-Message-State: ACrzQf2wA+LfJ9H1JRz4zIsYsKmwluV3o3tXiHdVlJoRKozrNdihiLs8
 qPaIpcUPhFtNc43w4ffDhA==
X-Google-Smtp-Source: AMsMyM7j75hsQAjfZIMDag+E+uxVO086sbySFKGpZQmxBHGiFVlWgpE6vfapy3lhNwjdU+847kbdBg==
X-Received: by 2002:a05:6808:2023:b0:359:c826:8085 with SMTP id
 q35-20020a056808202300b00359c8268085mr19906327oiw.156.1667577328221; 
 Fri, 04 Nov 2022 08:55:28 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net.
 [66.90.144.107]) by smtp.gmail.com with ESMTPSA id
 h4-20020a9d2f04000000b00661a3f4113bsm1532860otb.64.2022.11.04.08.55.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 08:55:27 -0700 (PDT)
Received: (nullmailer pid 1880418 invoked by uid 1000);
 Fri, 04 Nov 2022 15:55:18 -0000
From: Rob Herring <robh@kernel.org>
Date: Fri, 04 Nov 2022 10:55:05 -0500
Subject: [PATCH v3 5/8] perf: arm_spe: Use new PMSIDR_EL1 register enums
MIME-Version: 1.0
Message-Id: <20220825-arm-spe-v8-7-v3-5-87682f78caac@kernel.org>
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, Will Deacon <will@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Ingo Molnar <mingo@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>
X-Mailer: b4 0.11.0-dev
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, James Clark <james.clark@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Now that the SPE register definitions include enums for some PMSIDR_EL1
fields, use them in the driver in place of magic values.

Signed-off-by: Rob Herring <robh@kernel.org>
---
v3: New patch
---
 drivers/perf/arm_spe_pmu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 9b4bd72087ea..af6d3867c3e7 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -1006,32 +1006,32 @@ static void __arm_spe_pmu_dev_probe(void *info)
 	/* This field has a spaced out encoding, so just use a look-up */
 	fld = FIELD_GET(PMSIDR_EL1_INTERVAL, reg);
 	switch (fld) {
-	case 0:
+	case PMSIDR_EL1_INTERVAL_256:
 		spe_pmu->min_period = 256;
 		break;
-	case 2:
+	case PMSIDR_EL1_INTERVAL_512:
 		spe_pmu->min_period = 512;
 		break;
-	case 3:
+	case PMSIDR_EL1_INTERVAL_768:
 		spe_pmu->min_period = 768;
 		break;
-	case 4:
+	case PMSIDR_EL1_INTERVAL_1024:
 		spe_pmu->min_period = 1024;
 		break;
-	case 5:
+	case PMSIDR_EL1_INTERVAL_1536:
 		spe_pmu->min_period = 1536;
 		break;
-	case 6:
+	case PMSIDR_EL1_INTERVAL_2048:
 		spe_pmu->min_period = 2048;
 		break;
-	case 7:
+	case PMSIDR_EL1_INTERVAL_3072:
 		spe_pmu->min_period = 3072;
 		break;
 	default:
 		dev_warn(dev, "unknown PMSIDR_EL1.Interval [%d]; assuming 8\n",
 			 fld);
 		fallthrough;
-	case 8:
+	case PMSIDR_EL1_INTERVAL_4096:
 		spe_pmu->min_period = 4096;
 	}
 
@@ -1050,10 +1050,10 @@ static void __arm_spe_pmu_dev_probe(void *info)
 		dev_warn(dev, "unknown PMSIDR_EL1.CountSize [%d]; assuming 2\n",
 			 fld);
 		fallthrough;
-	case 2:
+	case PMSIDR_EL1_COUNTSIZE_12_BIT_SAT:
 		spe_pmu->counter_sz = 12;
 		break;
-	case 3:
+	case PMSIDR_EL1_COUNTSIZE_16_BIT_SAT:
 		spe_pmu->counter_sz = 16;
 	}
 

-- 
b4 0.11.0-dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
