Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6A2364DE
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jKaGNBOp"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3335df64539so6584163f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548149; x=1703152949; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xiH9cCOHpECfluleYwHnu/Lcc0lTQuy3GE63dgctBzU=;
        b=jKaGNBOpz686pKKiULC+cL8rV3kObDFFiMMd4kcsdC5oSGaO20yylhUmjQiaPh5zZX
         ya0cauWeFvR3MwOMeXQbYpGm9VFRd3Us9BYWHQvSjMQZTH5/C6PygzFgqRnH3lJaTnFl
         Z1/HTH2nmtariGnYGna7kH8eNq1KaPVyL2meqhdjgFRNqCkUomOmaPMSg8hvR/ygbavy
         p/lr5Tn9DYn+Ptyny/M+biHScm2AUDrj+B6xW0nAveo86ZpLklsIy4goL6NbdzMH1+ZL
         1DAMuRCWgo3jr2EiXsdrzuVf/YPyu1meHFjU8vYRPMu5lUFcwrXpszPh8Tkmg93W0xsL
         U8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548149; x=1703152949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xiH9cCOHpECfluleYwHnu/Lcc0lTQuy3GE63dgctBzU=;
        b=WHF7h3hg9RzfSdRk96ZvNMO/+y/qPvGSBvKsGHQTRzmB4i+ZyyL0JWFKyB9ampGG4F
         UO2Mp9tWfoWXu92DvXgG4pL+f2N+mdq/SSowz4+dGWVnoz/suIG+5uae5TFAxzUYcOnh
         GKq1Lr8DG5+bUPkBoV9Zl+dPfZBCm5RHgbTbQnz/IUbtjIweZ6WRwAI+I5UwLqmiz3YT
         4y5atjXT19brInq3F6XNsguPmvh8jsW4WSm0iV6YDablLAr+oroPu3PHJOVRk1Wms0CX
         KNYJis7/8Gy1yEVoXhFABpbPRr+fW99hu7oCu1HfRjbElBrEH625D7hhZ47t7mem/wNl
         zT+Q==
X-Gm-Message-State: AOJu0Yygzb/mWbVSyJIIPteiP9aHRuq/U8JmcABErKBl3PJWIwExD8qs
	qT3RrxSg8fc/SusoqKehu06M1E4PX8YAVELiy5+3muccujruBONfAJXPUandFQitZAVILCSIDDY
	Ecte1mRErck1cj0UOzmJ5I2cOBl5a3lmsFdwZSlimDFe8Ozjgld+gKBFTcWk=
X-Google-Smtp-Source: AGHT+IHX75xTL+XE/RnHwJsq2XGhisxwaOMfWGYxWgvAlywICs0euh4HZY2sx82xHWV+xO1t1Aiaso36uw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4246:0:b0:336:4ad5:60eb with SMTP id
 s6-20020a5d4246000000b003364ad560ebmr1093wrr.7.1702548149458; Thu, 14 Dec
 2023 02:02:29 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:53 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-14-tabba@google.com>
Subject: [PATCH v3 13/17] KVM: arm64: Define FGT nMASK bits relative to other fields
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Now that RES0 and MASK have full coverage, no speed to manually
encode nMASK. Calculate it relative to the other fields.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index bd20d27f1b33..b7a9fe36bb59 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -346,7 +346,7 @@
  */
 #define __HFGRTR_EL2_RES0	HFGxTR_EL2_RES0
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
-#define __HFGRTR_EL2_nMASK	(GENMASK(63, 52) | BIT(50))
+#define __HFGRTR_EL2_nMASK	~(__HFGRTR_EL2_RES0 | __HFGRTR_EL2_MASK)
 
 /*
  * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss any
@@ -357,17 +357,17 @@
 				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
 #define __HFGWTR_EL2_RES0	(__HFGRTR_EL2_RES0 | __HFGRTR_ONLY_MASK)
 #define __HFGWTR_EL2_MASK	(__HFGRTR_EL2_MASK & ~__HFGRTR_ONLY_MASK)
-#define __HFGWTR_EL2_nMASK	(__HFGRTR_EL2_nMASK & ~__HFGRTR_ONLY_MASK)
+#define __HFGWTR_EL2_nMASK	~(__HFGWTR_EL2_RES0 | __HFGWTR_EL2_MASK)
 
 #define __HFGITR_EL2_RES0	HFGITR_EL2_RES0
 #define __HFGITR_EL2_MASK	(BIT(62) | BIT(60) | GENMASK(54, 0))
-#define __HFGITR_EL2_nMASK	GENMASK(59, 55)
+#define __HFGITR_EL2_nMASK	~(__HFGITR_EL2_RES0 | __HFGITR_EL2_MASK)
 
 #define __HDFGRTR_EL2_RES0	HDFGRTR_EL2_RES0
 #define __HDFGRTR_EL2_MASK	(BIT(63) | GENMASK(58, 50) | GENMASK(48, 43) | \
 				 GENMASK(41, 40) | GENMASK(37, 22) | \
 				 GENMASK(19, 9) | GENMASK(7, 0))
-#define __HDFGRTR_EL2_nMASK	GENMASK(62, 59)
+#define __HDFGRTR_EL2_nMASK	~(__HDFGRTR_EL2_RES0 | __HDFGRTR_EL2_MASK)
 
 #define __HDFGWTR_EL2_RES0	HDFGWTR_EL2_RES0
 #define __HDFGWTR_EL2_MASK	(GENMASK(57, 52) | GENMASK(50, 48) | \
@@ -375,16 +375,16 @@
 				 GENMASK(37, 35) | GENMASK(33, 31) | \
 				 GENMASK(29, 23) | GENMASK(21, 10) | \
 				 GENMASK(8, 7) | GENMASK(5, 0))
-#define __HDFGWTR_EL2_nMASK	GENMASK(62, 60)
+#define __HDFGWTR_EL2_nMASK	~(__HDFGWTR_EL2_RES0 | __HDFGWTR_EL2_MASK)
 
 #define __HAFGRTR_EL2_RES0	HAFGRTR_EL2_RES0
 #define __HAFGRTR_EL2_MASK	(GENMASK(49, 17) | GENMASK(4, 0))
-#define __HAFGRTR_EL2_nMASK	0UL
+#define __HAFGRTR_EL2_nMASK	~(__HAFGRTR_EL2_RES0 | __HAFGRTR_EL2_MASK)
 
 /* Similar definitions for HCRX_EL2 */
 #define __HCRX_EL2_RES0         HCRX_EL2_RES0
 #define __HCRX_EL2_MASK		(BIT(6))
-#define __HCRX_EL2_nMASK	(GENMASK(24, 14) | GENMASK(11, 7) | GENMASK(5, 0))
+#define __HCRX_EL2_nMASK	~(__HCRX_EL2_RES0 | __HCRX_EL2_MASK)
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
-- 
2.43.0.472.g3155946c3a-goog

