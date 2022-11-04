Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9620DC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 15:55:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4021D41075;
	Fri,  4 Nov 2022 11:55:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rG-F-MBV1oHb; Fri,  4 Nov 2022 11:55:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 682F241278;
	Fri,  4 Nov 2022 11:55:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A13FD40FAC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:55:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s5j3xufo6R1h for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 11:55:23 -0400 (EDT)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com
 [209.85.167.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4721440F60
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:55:23 -0400 (EDT)
Received: by mail-oi1-f169.google.com with SMTP id t62so5562759oib.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 08:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
 :mime-version:subject:date:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=1LuRWZ+uGAhH28zFK+adTPuM2Aq0aZSCcYB6eJqAff0=;
 b=DGwGkn6VY1b3x9Jxdkufnm5fj5QzT6JBGeM1qTUn68td+uxklt0srCrpjOVHPQ49c9
 mOMkZhgehPBqsdtIwiFCOH66rJOFIjbkmT+HKZ731jNeYe8qlNhq20S2gmj/EOd1NxKO
 igdtz8CaTLssSobItKxSPuFijHURfE0S3PHz1h+EoSjS1mhUTm8UFFZj51bZDNjWWNy+
 yn8qqjFnXKHnFzGiNSDrUkyTlMIJxTKyAaI6mgygtKtyPhb60OlgQX0L4B/wLQWtqNzF
 VTemqLjwe7ejEO7AdNqixUu7fU9C/YyNs6BaecSKpQySPD8slfMNWS/1EO8CeWsDdBT7
 562A==
X-Gm-Message-State: ACrzQf3KqS/o17X+LzmaI5nl82ehAjaHmsr/bzEuNz4gCDTiOkDHg15V
 +qB5lNvh6RuotmHPZ8YHsg==
X-Google-Smtp-Source: AMsMyM4d6TDw2T7GbRam3QWG/Wa4RT72PM5DQk1E8uYmT91uYVnx3slmlmbYjUyO46tJ6RiQPcimSQ==
X-Received: by 2002:a05:6808:1492:b0:353:f28f:6fb with SMTP id
 e18-20020a056808149200b00353f28f06fbmr258038oiw.246.1667577322632; 
 Fri, 04 Nov 2022 08:55:22 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net.
 [66.90.144.107]) by smtp.gmail.com with ESMTPSA id
 z15-20020a056870e30f00b00136a0143de8sm1876818oad.40.2022.11.04.08.55.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 08:55:22 -0700 (PDT)
Received: (nullmailer pid 1880420 invoked by uid 1000);
 Fri, 04 Nov 2022 15:55:18 -0000
From: Rob Herring <robh@kernel.org>
Date: Fri, 04 Nov 2022 10:55:06 -0500
Subject: [PATCH v3 6/8] perf: arm_spe: Support new SPEv1.2/v8.7 'not taken'
 event
MIME-Version: 1.0
Message-Id: <20220825-arm-spe-v8-7-v3-6-87682f78caac@kernel.org>
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

Arm SPEv1.2 (Armv8.7/v9.2) adds a new event, 'not taken', in bit 6 of
the PMSEVFR_EL1 register. Update arm_spe_pmsevfr_res0() to support the
additional event.

Tested-by: James Clark <james.clark@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v3:
 - No change
v2:
 - Update for v6.1 sysreg generated header changes
---
 arch/arm64/include/asm/sysreg.h | 2 ++
 drivers/perf/arm_spe_pmu.c      | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d002dd00e53e..06231e896832 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -242,6 +242,8 @@
 	 BIT_ULL(6) | BIT_ULL(4) | BIT_ULL(2) | BIT_ULL(0))
 #define PMSEVFR_EL1_RES0_V1P1	\
 	(PMSEVFR_EL1_RES0_IMP & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
+#define PMSEVFR_EL1_RES0_V1P2	\
+	(PMSEVFR_EL1_RES0_V1P1 & ~BIT_ULL(6))
 
 /* Buffer error reporting */
 #define PMBSR_EL1_FAULT_FSC_SHIFT	PMBSR_EL1_MSS_SHIFT
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index af6d3867c3e7..82f67e941bc4 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -677,9 +677,11 @@ static u64 arm_spe_pmsevfr_res0(u16 pmsver)
 	case ID_AA64DFR0_EL1_PMSVer_IMP:
 		return PMSEVFR_EL1_RES0_IMP;
 	case ID_AA64DFR0_EL1_PMSVer_V1P1:
+		return PMSEVFR_EL1_RES0_V1P1;
+	case ID_AA64DFR0_EL1_PMSVer_V1P2:
 	/* Return the highest version we support in default */
 	default:
-		return PMSEVFR_EL1_RES0_V1P1;
+		return PMSEVFR_EL1_RES0_V1P2;
 	}
 }
 

-- 
b4 0.11.0-dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
