Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C9A846B
	for <kvmarm@lists.linux.dev>; Fri,  4 Nov 2022 15:55:25 +0000 (UTC)
Received: by mail-oi1-f172.google.com with SMTP id y67so5619807oiy.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Nov 2022 08:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nbh4kYtAszd2WFH06dmd+kkJjoRcl20JJM5emroag08=;
        b=c+9pZwRwqhgZ6VtwNR+we8DTc0kITrMCYSeeR4iCNk3HBCbC/rJVwWTP0shmINk8ib
         gDvkIWwyyEsRBaT4O3gy/CYcPt+dvvBkJydMdcUytVMUAad3ZONM/R0aG6Bz8hDf21P+
         9KKonr7Ud4XHfINQf2/BZYJMf+G+kHHPTB6gjXwYiJRrK4WjHVJSCp9RWWBeybakig8S
         YAv6/scGfBmYT1kWIedviVIh45N+sq9YF9h7EJVZ3jgJzdIQUm0JRnMToIVBek8gjyZq
         3vByOhju1RVw2qGLQZIw1NADb729LW6TJuIiBVEC34Cn+SFjlpjR6aEOT7jcp67zJjsU
         3kng==
X-Gm-Message-State: ACrzQf1nsBE2ATBXwHCqSaCAr93knZJQC7BXTtP56FW+elG7QoC/OwWt
	t+F/qUdGu3471sqlc89KiQ==
X-Google-Smtp-Source: AMsMyM6XCGOxDkWp/KDtlfrAH+Z735zS9ydDsev6tHg8eM+cXyEV7Ga+K7IZqgQFpv3gP3gCDvvgow==
X-Received: by 2002:a05:6808:11c1:b0:353:f1a5:207a with SMTP id p1-20020a05680811c100b00353f1a5207amr27451988oiv.183.1667577324586;
        Fri, 04 Nov 2022 08:55:24 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id cg27-20020a056830631b00b00661b019accbsm1588176otb.3.2022.11.04.08.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:55:24 -0700 (PDT)
Received: (nullmailer pid 1880410 invoked by uid 1000);
	Fri, 04 Nov 2022 15:55:18 -0000
From: Rob Herring <robh@kernel.org>
Date: Fri, 04 Nov 2022 10:55:01 -0500
Subject: [PATCH v3 1/8] perf: arm_spe: Use feature numbering for PMSEVFR_EL1 defines
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20220825-arm-spe-v8-7-v3-1-87682f78caac@kernel.org>
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Ingo Molnar <mingo@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, James Clark <james.clark@arm.com>, Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-Mailer: b4 0.11.0-dev
Message-ID: <20221104155501.PzNh-StzEPZXxoDdAQ-rlHAEYX4HahDTo4-60K44-Po@z>

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
