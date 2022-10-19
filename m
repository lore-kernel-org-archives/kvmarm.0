Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9739C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 19:11:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82F504B8D0;
	Wed, 19 Oct 2022 15:11:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rlx1-fu3d6Eb; Wed, 19 Oct 2022 15:11:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E45D4B92F;
	Wed, 19 Oct 2022 15:11:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99C054B926
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 15:11:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bZmruud4y2Y9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Oct 2022 15:11:33 -0400 (EDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com
 [209.85.167.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3F1F4B93E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 15:11:31 -0400 (EDT)
Received: by mail-oi1-f178.google.com with SMTP id w74so20401964oie.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 12:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
 :mime-version:subject:date:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=ZBd+XTJESJNOGYoq8Sf5QKUv5aLEk2PWt2aI7lcJy1Q=;
 b=DzM9UmDQpDl8R5UHWKhV/bAPbYY0XpirKNQIxW/UzB65L82syCOE6g451QDKwsP+uW
 itxgMWyHH5HqiyNijWoLd4T3KjjVgzP/MqCp1ICuca/Eb9GgJ9efVDVetbIa0mZmeRG6
 3LKWdeFhgesnTgP9sTEx8eKU6Q7MTQELP6v2m+KyuwCUj5iNJLQm1/48/EXtq5Tr2sBL
 iJk2yblatZPMzoBWc97tXIzdg85dIuqzgAq1NQOoSEPjZOD2lPQDQD9d35cedrGe5iwS
 ONIhesNXA7KMDASjFl7d7e5E+BLRGvYlUBRBI8RLCs15lQWOfKnaH6lZeWCaPrM6KWsh
 8R7A==
X-Gm-Message-State: ACrzQf2+JIA2d62ioXibBZWyMs04yOPvZSZdqSoRyQMhr6JDRzKM3Bh9
 EXpBNv0ElX853m1odofpaA==
X-Google-Smtp-Source: AMsMyM53HC4eCK4NKlfS5OabG/2idCaE/8R5DmuO7iXth8yDJHlcBsw0Hkxwf9ZW/H1vTGzH8KmBcw==
X-Received: by 2002:a05:6808:1510:b0:354:566c:78e5 with SMTP id
 u16-20020a056808151000b00354566c78e5mr19239918oiw.188.1666206691599; 
 Wed, 19 Oct 2022 12:11:31 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net.
 [66.90.144.107]) by smtp.gmail.com with ESMTPSA id
 q78-20020a4a3351000000b00480db116926sm2048754ooq.27.2022.10.19.12.11.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Oct 2022 12:11:31 -0700 (PDT)
Received: (nullmailer pid 3420906 invoked by uid 1000);
 Wed, 19 Oct 2022 19:11:25 -0000
From: Rob Herring <robh@kernel.org>
Date: Wed, 19 Oct 2022 14:11:28 -0500
Subject: [PATCH v2 5/7] perf: arm_spe: Support new SPEv1.2/v8.7 'not taken'
 event
MIME-Version: 1.0
Message-Id: <20220825-arm-spe-v8-7-v2-5-e37322d68ac0@kernel.org>
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
