Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B753A4
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 19:11:33 +0000 (UTC)
Received: by mail-ot1-f52.google.com with SMTP id cb2-20020a056830618200b00661b6e5dcd8so10078411otb.8
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 12:11:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JxlkIVs552Ejp+aX9wrJgo7YCeTd9sG0ZHnn6ZfglP4=;
        b=wL3Dbm/7xj1oBXlyGtUv+wFz4SzNT87xM49pHPBxlZi6l4x+q2M0IJFStGg7vMauKs
         0kyxvBvjMRYlkA3BdvKKr4b/q7ske2B54LN5M3GINvDGzXulu8bdw43BWc9ZFurwVNSq
         AHVIT6Pr1iBhvUvYX3HSrlWC/E1JHp2uH4LngGbyeALvfUsu/nAowepm0Fvu8FldLMNA
         Or0ORSLfzh5JwUiwTKqeEofRE14jhzUN63dLzfLWbLLkk9GMvZfjoKT8hoiw5ntLRIa0
         qz0UJcGthAr4Q143m4IhYA3zg0w9iE15iP6Njz6h9jkxxdygbXR+/VqycODg+HVNhW6k
         sm8g==
X-Gm-Message-State: ACrzQf0uMZV5MipBy48/vaAz6/jTIbvjlXcvUhhZCxfbs3JUFHiGlID+
	ZEUxJzxjdOtcbpbXUaB7rw==
X-Google-Smtp-Source: AMsMyM4c6mVzFUrkq81v9/CA7Mnv6GIXWQ7zeNYDSSDTWnk1r6iqqax4wHful0HevpS2dD/tJHkWSg==
X-Received: by 2002:a05:6830:25c3:b0:661:c7e4:e785 with SMTP id d3-20020a05683025c300b00661c7e4e785mr4817162otu.134.1666206692965;
        Wed, 19 Oct 2022 12:11:32 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id f17-20020a4ae611000000b00480b7efd5d9sm5922591oot.6.2022.10.19.12.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 12:11:32 -0700 (PDT)
Received: (nullmailer pid 3420898 invoked by uid 1000);
	Wed, 19 Oct 2022 19:11:25 -0000
From: Rob Herring <robh@kernel.org>
Date: Wed, 19 Oct 2022 14:11:24 -0500
Subject: [PATCH v2 1/7] perf: arm_spe: Use feature numbering for PMSEVFR_EL1 defines
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20220825-arm-spe-v8-7-v2-1-e37322d68ac0@kernel.org>
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>, Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, Jiri Olsa <jolsa@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.11.0-dev
Message-ID: <20221019191124.fdY2UnB4mtbRUzxopYrdka15AHD5qSfXXaysqTdOBT4@z>

Similar to commit 121a8fc088f1 ("arm64/sysreg: Use feature numbering for
PMU and SPE revisions") use feature numbering instead of architecture
versions for the PMSEVFR_EL1 Res0 defines.

Signed-off-by: Rob Herring <robh@kernel.org>
---
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
