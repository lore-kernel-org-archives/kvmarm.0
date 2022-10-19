Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D03453A4
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 19:11:32 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id n130so20345032oia.6
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 12:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZBd+XTJESJNOGYoq8Sf5QKUv5aLEk2PWt2aI7lcJy1Q=;
        b=nreDXZiVCCm7oDLdP4C7UNCLlFmvoUxSOMd6uxfJ1o64lrtZYSnAq2NMgywo2e5Yc0
         zVynxX7qOnNOrYnDswkUeMK6waKNDvcxVmcvXyZlfYzyWoOPEnTfes6JB2cEw5hYo14F
         L3Ytdv5rX5rOXrX5GQKUC/29a3DvLU9SszOXeKGGlHvcjds7zGqbr7MeKy6+3fDhDvwZ
         sePYXaEI4+HKXc4igs7TdPVRgPxfzcAZaJoASMl8ZLe/V9whUVZuPr3+jxQfLOMZISsK
         C8Xr9T3x6I2fbhQJqtsUIT+j5QJYXZS+KT4Q8fqavm1Lr1wtoG2YEDWCdoBqKNnK7FJT
         k5xQ==
X-Gm-Message-State: ACrzQf3QDPfZrWZ73HC+HvI7UW0Q+H3fguPwHF9etpczPfQfQyN9z4zQ
	9fziEKPBF1c8Avz48zKH9g==
X-Google-Smtp-Source: AMsMyM53HC4eCK4NKlfS5OabG/2idCaE/8R5DmuO7iXth8yDJHlcBsw0Hkxwf9ZW/H1vTGzH8KmBcw==
X-Received: by 2002:a05:6808:1510:b0:354:566c:78e5 with SMTP id u16-20020a056808151000b00354566c78e5mr19239918oiw.188.1666206691599;
        Wed, 19 Oct 2022 12:11:31 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q78-20020a4a3351000000b00480db116926sm2048754ooq.27.2022.10.19.12.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 12:11:31 -0700 (PDT)
Received: (nullmailer pid 3420906 invoked by uid 1000);
	Wed, 19 Oct 2022 19:11:25 -0000
From: Rob Herring <robh@kernel.org>
Date: Wed, 19 Oct 2022 14:11:28 -0500
Subject: [PATCH v2 5/7] perf: arm_spe: Support new SPEv1.2/v8.7 'not taken' event
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20220825-arm-spe-v8-7-v2-5-e37322d68ac0@kernel.org>
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>, Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, Jiri Olsa <jolsa@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.11.0-dev
Message-ID: <20221019191128.NJ3wrpps_3yrPJfOpdetaA_x7tFsj2Ox4NhoSxCbmWo@z>

Arm SPEv1.2 (Armv8.7/v9.2) adds a new event, 'not taken', in bit 6 of
the PMSEVFR_EL1 register. Update arm_spe_pmsevfr_res0() to support the
additional event.

Signed-off-by: Rob Herring <robh@kernel.org>
---
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
index 9b4bd72087ea..0b9b847919d0 100644
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
