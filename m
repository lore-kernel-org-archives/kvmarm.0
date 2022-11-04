Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457FB8469
	for <kvmarm@lists.linux.dev>; Fri,  4 Nov 2022 15:55:29 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id n83so5574606oif.11
        for <kvmarm@lists.linux.dev>; Fri, 04 Nov 2022 08:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YXxvA5Cmwe9nSMxNL2yH3Amn9qhEZ+Ppqa0CVXQahDM=;
        b=kfX4yOTYm1GvgWAx94XsZ3HDippX/Ex8wrhI3z++5rpyNwCbJexJ3zAoQK0eDl9jmX
         MwoSeeCEmHUtraUVdCIJpdC+XfCwoqKglNvp4ORHUHiIdCFzwVSz68oyG0hNXkAgBB+4
         aWbAfnfr8OmnMDy8XTDZOQTVn+iFIsG3tAqVRVzBVHBXc3Jl6KlLiIA0Z64SHt04nPdP
         kAU6CNLhuDqgYDXxhhC+NNdYbAH4LUL1uvk0xEUGSnMgaSOKbJJ78oVjDmayk+d/xutI
         gdDzyUt701BPY5z8E2GGImLsH86QT84Vjw2BbNl/73/Jw7Ag9D6So0h6z+/XhTZkFsKX
         WVJQ==
X-Gm-Message-State: ACrzQf0e8IcnsuDW9Zm0Dqoyx/dNBKNKPc4y61flgeXi2hLLDot83GvI
	ubsjt9WdXCQAG9kSrjh3zw==
X-Google-Smtp-Source: AMsMyM7j75hsQAjfZIMDag+E+uxVO086sbySFKGpZQmxBHGiFVlWgpE6vfapy3lhNwjdU+847kbdBg==
X-Received: by 2002:a05:6808:2023:b0:359:c826:8085 with SMTP id q35-20020a056808202300b00359c8268085mr19906327oiw.156.1667577328221;
        Fri, 04 Nov 2022 08:55:28 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id h4-20020a9d2f04000000b00661a3f4113bsm1532860otb.64.2022.11.04.08.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:55:27 -0700 (PDT)
Received: (nullmailer pid 1880418 invoked by uid 1000);
	Fri, 04 Nov 2022 15:55:18 -0000
From: Rob Herring <robh@kernel.org>
Date: Fri, 04 Nov 2022 10:55:05 -0500
Subject: [PATCH v3 5/8] perf: arm_spe: Use new PMSIDR_EL1 register enums
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20220825-arm-spe-v8-7-v3-5-87682f78caac@kernel.org>
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Ingo Molnar <mingo@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, James Clark <james.clark@arm.com>, Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-Mailer: b4 0.11.0-dev
Message-ID: <20221104155505.aNuLnguSWfNbgxXdAt6YXN4DPCxNOGfgKa7qMshCzyI@z>

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
