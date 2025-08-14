Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2922F39BA
	for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 09:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755163568; cv=none; b=Hiefu3+xiDaq/n1vsIso1NLemeaCFbx4Bqj7UNQ3ibedHqRjRs2oewtccqlCjCbf7BRMIiPrEvZXUIsN5X5q4eCRLDG8SCzTnycYoXdhgd0iCZd5mbfPFPju9qYwIyjXILuXFex76jnUKwEbX3CH6dgG7UGZe0zV9d289+3iQXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755163568; c=relaxed/simple;
	bh=o5hoKk8PVrb3Jz138QI9+seK1sxidrzo/A/lviEOL3Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Co4f5nLrLK+81ExF5q78NLR4dEvn2IXd1W9GjLt6zqFAkuZ/fsK8vLKPV4OrwSM25gqr2y59EmznhLIROY1/3LAldmmL9dj8gFhqqgLRXAijoNtgIfBuL/JVhU5lBwpKCaupBhUtZXwAiQM8zjX5K1MApkY1thhfgFFQTO7flJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ic0AXtxH; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ic0AXtxH"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45a1abf5466so4565485e9.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 02:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755163564; x=1755768364; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CHd8HPOm/LFAxhlOS9e+lKUAamxvrPZUbEjnXUTZJIA=;
        b=Ic0AXtxH7k9an1j6B/LrHfrE/NLCpKE0kKYRrleFD8utCcPgLdDkzMnFc9+p1Dbxl/
         rv336YB1pmyYtqCNq2Rrla+TSZ/kDLVcTHn7sFDkKP9IK7ImjfjQUDiJPLqzd8pft1te
         2czJqZELUdNPaOq1MLKS4NG0yHO1qSZ60c05QRTWNwGwfWYAL7fkUYICkn6g06Oc/+39
         x/4E9OxBBfSLvJmIWgbGXNmcTzlTQSFueHPlHvdJmIvyKLBJagoE+BW4JD1Z2wk3mi5J
         19Lg0PP8iRwqMas1k5KBo7qS4MZ0/c03Fio0yJnY0yM5eGAeBm18WUS24ZNefeb7cyFe
         nZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163564; x=1755768364;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CHd8HPOm/LFAxhlOS9e+lKUAamxvrPZUbEjnXUTZJIA=;
        b=ecsPJDiiKPxbz1OSBenZkm3R9uj8LdpTYFpqNMXvo2z71mAeCxCt/RmKR01Mchvf9c
         5kML1oiCEqkQotGbCQOJrrqmEM31UoWPCKLa8c0QbZeRLg3+Qzcz3DBWMkEaljHoLzPM
         neJphg5MoO2xIcNOImk75o8kc9kkc3YhYtLEvC5U7Sc5AIlJuPWPOJn1ElNpWxqUfq4/
         RTQU+q7yUOKr5U2ayJSJD4GFin9cd/rvRwV8y0x9FtJY2Ho4iythdeVxWL+cYWz1dGd4
         KIEpn5iiiH+BpoFvzvozRGNyaJwsUBve6aMegQSVo7OLDtIIl/5UpgwdoBPOGlOX4MXM
         GwMg==
X-Forwarded-Encrypted: i=1; AJvYcCUH2kfN9/uPwwBzbj/wwK72sROgRKo4P3m0ksGY7cHz1cg2UeqJNETRyqNK2+ahELyI5pejZtM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVKtLOl+Zv+7y5wji5Dvar5HkBi/vVQNIdh1yrqku786JN7yVe
	DK5j0dBuzbir3Oz2szgk7P0vlS/fX5qOWgMGbvlBqS9RFY+L6fSnm5LdMmQde+r9xMBwZWQlQGZ
	sqCL0
X-Gm-Gg: ASbGnctMudoZjByLZCgWXJFtrni5ECof37O49yGinuJMMLJBXDiQzsNJhCnKQi6+6xq
	uUF/sVALYSCsfrmZExm1PLU+wGBb+X1AmEJwQnuVmsD+xqBo7lAqpG6vBDcvAsA1uyL102CjqTl
	4gGghkJy9cMZZ2X3O07FLiTlqt04eDam5G4f8Z4uiqBYPyLLHh5A8qqAwsg4RV7E3bBhrCh5ZvG
	b7wPPDXrLQWPIuLrglpSb6VtA1qdpVNEjFwOZX0U4GqwtKSQIHP6Y6wWh/vnkqBiba8NnEhdYhB
	skC6cdovgORTjwOKGaei0IS+isq4nekEpZUhvrHSrVXUiScHEu9EJqveQA98yU8zerekn6cb/oj
	kdV5sAI4aGwu8jhqQBLvxfzTiituzhu8=
X-Google-Smtp-Source: AGHT+IHVbFNevY/X+5Fk3dLFGyCp8s96euJO8o8AaVBD0HLHGypEL/usVLk1GhbMm0uoIXFS5XgajQ==
X-Received: by 2002:a05:600c:458a:b0:459:e39e:e5a5 with SMTP id 5b1f17b1804b1-45a1b791232mr17035875e9.5.1755163564130;
        Thu, 14 Aug 2025 02:26:04 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c76e9basm14536775e9.21.2025.08.14.02.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:26:03 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 14 Aug 2025 10:25:27 +0100
Subject: [PATCH v7 05/12] arm64/boot: Factor out a macro to check SPE
 version
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-james-perf-feat_spe_eft-v7-5-6a743f7fa259@linaro.org>
References: <20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org>
In-Reply-To: <20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Leo Yan <leo.yan@arm.com>, 
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

We check the version of SPE twice, and we'll add one more check in the
next commit so factor out a macro to do this. Change the #3 magic number
to the actual SPE version define (V1p2) to make it more readable.

No functional changes intended.

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/el2_setup.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 46033027510c..3a4ca7f9acfb 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -103,8 +103,7 @@
 	csel	x2, xzr, x0, eq			// all PMU counters from EL1
 
 	/* Statistical profiling */
-	ubfx	x0, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
-	cbz	x0, .Lskip_spe_\@		// Skip if SPE not present
+	__spe_vers_imp .Lskip_spe_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x0 // Skip if SPE not present
 
 	mrs_s	x0, SYS_PMBIDR_EL1              // If SPE available at EL2,
 	and	x0, x0, #(1 << PMBIDR_EL1_P_SHIFT)
@@ -255,6 +254,14 @@
 .Lskip_brbe_\@:
 .endm
 
+/* Branch to skip_label if SPE version is less than given version */
+.macro __spe_vers_imp skip_label, version, tmp
+    mrs    \tmp, id_aa64dfr0_el1
+    ubfx   \tmp, \tmp, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
+    cmp    \tmp, \version
+    b.lt   \skip_label
+.endm
+
 /* Disable any fine grained traps */
 .macro __init_el2_fgt
 	mrs	x1, id_aa64mmfr0_el1
@@ -263,10 +270,8 @@
 
 	mov	x0, xzr
 	mov	x2, xzr
-	mrs	x1, id_aa64dfr0_el1
-	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
-	cmp	x1, #3
-	b.lt	.Lskip_spe_fgt_\@
+	/* If SPEv1p2 is implemented, */
+	__spe_vers_imp .Lskip_spe_fgt_\@, #ID_AA64DFR0_EL1_PMSVer_V1P2, x1
 	/* Disable PMSNEVFR_EL1 read and write traps */
 	orr	x0, x0, #HDFGRTR_EL2_nPMSNEVFR_EL1_MASK
 	orr	x2, x2, #HDFGWTR_EL2_nPMSNEVFR_EL1_MASK

-- 
2.34.1

