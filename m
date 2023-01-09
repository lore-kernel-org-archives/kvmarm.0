Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2720F8C09
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 19:26:46 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id o66so8051518oia.6
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 11:26:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jYXNYZPoEZW+cpasaK2qS1x4BldwPdfg2ohHEnkw8tk=;
        b=r3rnQv1WOAcZvSgLDe+wi5Sl6OgPhzdvw23gf+2TXHryZr6ZdVogK88+pjehOXQFWe
         kPv9EEQEOe+0aC+FghgL7sf12llehpXf6CrLaSJGSk84yA6MqLuI+ii1qqdEvvFDdtHG
         M96vdoPlq2HBmTF9GwMgbSLUmGoEYQAqNY17To30hqf86TM66iX9UX7iNTOFxTHra+20
         LvwCI3/bFnKuELsYk8hWOVJxJc/UQKWjL7hqGn59R6mPPFJjz7pjG1wAM99WRI2JR3ze
         y6Gfxo84542chZkwMxK4qh3bySALR/IXhcB7Q4zys5Swdt3lcafX+MhIwxBsLoMBZ9je
         P5nQ==
X-Gm-Message-State: AFqh2kra25Qp8j9K+lAG0cvUrbcCbsqI4cqMUghDNsYKXrf8mi8VyU/L
	O66auiY2Nc29+99m+lr1TcFfnBQsPQ==
X-Google-Smtp-Source: AMrXdXuWN6s2Ip6alGnEK9Y77CLyDy7KYWq7dZYuDLZi9RmEcarrAkz9gBXHZpKxv9AwTjYuASRn7g==
X-Received: by 2002:a05:6808:190e:b0:35c:b79:8cf8 with SMTP id bf14-20020a056808190e00b0035c0b798cf8mr38989203oib.6.1673292405102;
        Mon, 09 Jan 2023 11:26:45 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id bg31-20020a056808179f00b00363b5a6bc9esm4343635oib.12.2023.01.09.11.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 11:26:44 -0800 (PST)
Received: (nullmailer pid 1483616 invoked by uid 1000);
	Mon, 09 Jan 2023 19:26:31 -0000
From: Rob Herring <robh@kernel.org>
Date: Mon, 09 Jan 2023 13:26:22 -0600
Subject:
 [PATCH v4 6/8] perf: arm_spe: Support new SPEv1.2/v8.7 'not taken' event
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20220825-arm-spe-v8-7-v4-6-327f860daf28@kernel.org>
References: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, James Clark <james.clark@arm.com>
X-Mailer: b4 0.12-dev

Arm SPEv1.2 (Armv8.7/v9.2) adds a new event, 'not taken', in bit 6 of
the PMSEVFR_EL1 register. Update arm_spe_pmsevfr_res0() to support the
additional event.

Tested-by: James Clark <james.clark@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v4:
 - Rebase on v6.2-rc1
v3:
 - No change
v2:
 - Update for v6.1 sysreg generated header changes
---
 arch/arm64/include/asm/sysreg.h | 2 ++
 drivers/perf/arm_spe_pmu.c      | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index db269eda7c1c..fc8787727792 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -221,6 +221,8 @@
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
2.39.0
