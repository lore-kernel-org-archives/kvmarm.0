Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A5CC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 15:55:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CB4A49F3B;
	Fri,  4 Nov 2022 11:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jo2XJp+fVGpV; Fri,  4 Nov 2022 11:55:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA0D549EC2;
	Fri,  4 Nov 2022 11:55:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66A5F4106C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:55:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SI1c9IEJXQ2y for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 11:55:25 -0400 (EDT)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com
 [209.85.167.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 448D640FD3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:55:25 -0400 (EDT)
Received: by mail-oi1-f169.google.com with SMTP id n186so5590130oih.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 08:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
 :mime-version:subject:date:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=nbh4kYtAszd2WFH06dmd+kkJjoRcl20JJM5emroag08=;
 b=grCMYUU9I3fr/fayZNLg4gqmLqLFLn0vr6WRE5Ns1bKr2rRLCcTHBcZkCZt78VX46g
 B86lSb+1WgVyTfOq1mCqpIVfVKz2+gyFNe0LpfKqzGiBtLIYsHzJzOV8DO+DMHEULzTp
 jOLDMsbYzJu1EcRk+PMuP1+23c8zUJ2esHXQQ0k1p9t05w2/kTga8nXXei6k6milK+Qd
 kiyqr/32NRDN4xZcQzGAJx3TgkALODfSY4nnPUPes9wiiKjH2GMJ7txhGBnDaRWfizf/
 jFzZ2mPyAYMsHuXL/qcHZgJrOYep01bqEktlZ4mQRXO7y3Ele6Tww0KT7Q1Cy2SwoTCw
 I/Bw==
X-Gm-Message-State: ACrzQf0t2FW5XTyejHWRnCEkcOTiy2ACZZujEuSAWcLoW6qQ5+5Rgn0r
 5EqoNXqSwNnXYAbR9e1BLg==
X-Google-Smtp-Source: AMsMyM6XCGOxDkWp/KDtlfrAH+Z735zS9ydDsev6tHg8eM+cXyEV7Ga+K7IZqgQFpv3gP3gCDvvgow==
X-Received: by 2002:a05:6808:11c1:b0:353:f1a5:207a with SMTP id
 p1-20020a05680811c100b00353f1a5207amr27451988oiv.183.1667577324586; 
 Fri, 04 Nov 2022 08:55:24 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net.
 [66.90.144.107]) by smtp.gmail.com with ESMTPSA id
 cg27-20020a056830631b00b00661b019accbsm1588176otb.3.2022.11.04.08.55.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 08:55:24 -0700 (PDT)
Received: (nullmailer pid 1880410 invoked by uid 1000);
 Fri, 04 Nov 2022 15:55:18 -0000
From: Rob Herring <robh@kernel.org>
Date: Fri, 04 Nov 2022 10:55:01 -0500
Subject: [PATCH v3 1/8] perf: arm_spe: Use feature numbering for PMSEVFR_EL1
 defines
MIME-Version: 1.0
Message-Id: <20220825-arm-spe-v8-7-v3-1-87682f78caac@kernel.org>
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

Similar to commit 121a8fc088f1 ("arm64/sysreg: Use feature numbering for
PMU and SPE revisions") use feature numbering instead of architecture
versions for the PMSEVFR_EL1 Res0 defines.

Tested-by: James Clark <james.clark@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v3:
 - No change
v2:
 - New patch
---
 arch/arm64/include/asm/sysreg.h | 6 +++---
 drivers/perf/arm_spe_pmu.c      | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7d301700d1a9..9a4cf12e3e16 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -294,11 +294,11 @@
 #define SYS_PMSFCR_EL1_ST_SHIFT		18
 
 #define SYS_PMSEVFR_EL1			sys_reg(3, 0, 9, 9, 5)
-#define SYS_PMSEVFR_EL1_RES0_8_2	\
+#define PMSEVFR_EL1_RES0_IMP	\
 	(GENMASK_ULL(47, 32) | GENMASK_ULL(23, 16) | GENMASK_ULL(11, 8) |\
 	 BIT_ULL(6) | BIT_ULL(4) | BIT_ULL(2) | BIT_ULL(0))
-#define SYS_PMSEVFR_EL1_RES0_8_3	\
-	(SYS_PMSEVFR_EL1_RES0_8_2 & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
+#define PMSEVFR_EL1_RES0_V1P1	\
+	(PMSEVFR_EL1_RES0_IMP & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
 
 #define SYS_PMSLATFR_EL1		sys_reg(3, 0, 9, 9, 6)
 #define SYS_PMSLATFR_EL1_MINLAT_SHIFT	0
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 00e3a637f7b6..65cf93dcc8ee 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -677,11 +677,11 @@ static u64 arm_spe_pmsevfr_res0(u16 pmsver)
 {
 	switch (pmsver) {
 	case ID_AA64DFR0_EL1_PMSVer_IMP:
-		return SYS_PMSEVFR_EL1_RES0_8_2;
+		return PMSEVFR_EL1_RES0_IMP;
 	case ID_AA64DFR0_EL1_PMSVer_V1P1:
 	/* Return the highest version we support in default */
 	default:
-		return SYS_PMSEVFR_EL1_RES0_8_3;
+		return PMSEVFR_EL1_RES0_V1P1;
 	}
 }
 

-- 
b4 0.11.0-dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
