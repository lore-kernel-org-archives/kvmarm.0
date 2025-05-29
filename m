Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE5D28F94A
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518400; cv=none; b=ntCeV4brKaDma+wVT/HIDcTDNtZNg7VvaYW6CvaXY5fJWE2NPSCw++en0oYPr8xQj13nLY87RupboPY0jKLA6U3XxzvxAuJwaA1/PTUFg/O9zcowLYtdzjLagvYxal5Oe+LgA6ln4LmHf6xWvnSSI/KWmxfub0JrSShKyDKgXOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518400; c=relaxed/simple;
	bh=3Nke7IrlZt1dIQrrtJZ35wZYJcBpZtgeyy0gHEfYDMk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ojilvbmegevuNEgJsJc9ZgmEB8iMkBBd1RdiXzonewcsL3hZaIqecIL9HG4YpiRWty11IG9cynktRi5JmLIvcd+Q0dxePn8ssJDjbk8jXWBQ7friDA9UliEW4e1zEieg01PwfS/dlRSMQ7lucJOk6rm5MA58AblrhY/fTUr5vKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ncFV9MRe; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ncFV9MRe"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-450ce671a08so5204645e9.3
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 04:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748518397; x=1749123197; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Nc8ucW60XE4Jn3cBqaPeV8SZm/My/nwOffHN5F4rVM=;
        b=ncFV9MRe6Zx01LRyC7qBYKlrRR2AcT3cNAv2WHPM+FRGQfcgxjMqDYXQy7nLesBQR0
         QQ2Ztcpl2g1KWIeI3dWubrbt9NQaTz7/tUnfhSOqtRK4VF/2XHli5pJuNdZ38/hLLRq6
         ny6UWfvh4/cEuSzBEUC/MFH1ZXty9+nVn5VLWSRG5T1+kjPYapl8qmwexdPhI4XIWCS0
         dZ8ZcHvbvhoB+42G2SXr8ALAjt3lWJYSFYQblWF8RClV9ufA+FKzWE7IIR4qVu+L4y2H
         CwhpC2c6tf1/Bjq8ddctsp29MJa9nWypotXkISojssukZp3Scg2PE3PSvlyyhgWdtvYs
         nJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748518397; x=1749123197;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Nc8ucW60XE4Jn3cBqaPeV8SZm/My/nwOffHN5F4rVM=;
        b=UzrsEhO/QXJNipFuMYvYG64s3VPVQnHgc20AJY98rDLYUrSBBxQQmcOuI/oGxVQCis
         8SD3MErLIl6unsu028rW9pIpjF69yJtjqyPSTBOrAJ0O9hywL/twNY7zWIeRWhNQbIrt
         GU591rZmEhwzO9ZHs80cs1VceM0DOFeq+Qq5m+vQcN/9jM7PMdFAK9cyE0c+U+iQxx58
         uHJ+//hVJThOV0mYkMaVtI84XWjJiCIskl8wR73voSUhOssIyvS+PITJeyKbS/lB9vLn
         9eJX51AtWfac9Fibk2INgC5ePsUPqG0JTqwkCyGsBte84tt+H3uBkM6287LxspQpk0Fs
         /XqA==
X-Forwarded-Encrypted: i=1; AJvYcCXsUEuquS5E4Y2khY71ANowcVvNOLwYxfYK1Xsw0mlYMyW0LfCUNQBFMhbnvZ8+zonbK4ki90g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFg3vY+pJxgbwzcBguwb1X8FSSlN3UcMzaYlb2TrpSx0FMFwYb
	aNOOo+uwtGbdk5AKmZeuF27/9/Oq8ipOtyd6G9gPQ/K1vWTWwpDqUxiUguW8AwGiuEk=
X-Gm-Gg: ASbGncs7V97sEd/mMl95TJXBYxBbQaqZTShCnEakfji28IVC4rWOzbbvEG30HvKlVn3
	zXbf91HECv9yFvxSylgaytegp4lzszcbX4a/rjIMilw6Q3qIvSPtBhp/tt3cgMireSyu4wENzph
	Z8jX0gCj4T2AiL8XsRofTM9hkx7Pl0IGuhB/Q+siQfKP1aBiTq6IAp8c2o8Hy8u9RXYGlIhZhnV
	2O5NWEMN/K9e0JqwdcCfngD2oSOJSJ2fo3AnamowtEqQ+dcTp/k8GCTsM+T7O3HCJxhl0iRS5As
	LexCU5x4VXH4LmEzOAwssFhcCQyjM0aS6NPjT76bi0fOuMbFB5rRakhWDSWr
X-Google-Smtp-Source: AGHT+IEKUlq+VjysuU7OFlzmN9WWwVOAQRlwZk1C8MZ05ufCqPWjkB/S4hXmEcNWVtw0X6JufGjbcw==
X-Received: by 2002:a05:600c:621b:b0:43c:fffc:786c with SMTP id 5b1f17b1804b1-44fafbf883dmr95464645e9.19.1748518396915;
        Thu, 29 May 2025 04:33:16 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450cfc3785bsm17443945e9.40.2025.05.29.04.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 04:33:16 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 29 May 2025 12:30:27 +0100
Subject: [PATCH v2 06/11] KVM: arm64: Add trap configs for PMSDSFR_EL1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250529-james-perf-feat_spe_eft-v2-6-a01a9baad06a@linaro.org>
References: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
In-Reply-To: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
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
 Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

SPE data source filtering (SPE_FEAT_FDS) adds a new register
PMSDSFR_EL1, add the trap configs for it.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/kvm/emulate-nested.c | 1 +
 arch/arm64/kvm/sys_regs.c       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 0fcfcc0478f9..05d3e6b93ae9 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1169,6 +1169,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_PMSIRR_EL1,		CGT_MDCR_TPMS),
 	SR_TRAP(SYS_PMSLATFR_EL1,	CGT_MDCR_TPMS),
 	SR_TRAP(SYS_PMSNEVFR_EL1,	CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSDSFR_EL1,	CGT_MDCR_TPMS),
 	SR_TRAP(SYS_TRFCR_EL1,		CGT_MDCR_TTRF),
 	SR_TRAP(SYS_TRBBASER_EL1,	CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBLIMITR_EL1,	CGT_MDCR_E2TB),
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5dde9285afc8..9f544ac7b5a6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2956,6 +2956,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMBLIMITR_EL1), undef_access },
 	{ SYS_DESC(SYS_PMBPTR_EL1), undef_access },
 	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSDSFR_EL1), undef_access },
 	/* PMBIDR_EL1 is not trapped */
 
 	{ PMU_SYS_REG(PMINTENSET_EL1),

-- 
2.34.1

