Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6BC275861
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 11:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652237; cv=none; b=JY9NBXgaX6ayXnpdPcH6BsidsAcgyV8LucG1DRKc6NQUzxYV5noVjsfO7kkmKCqgega8uyLOsn2GhH1xdMebeczS/vrJP8hcruWcyEf48FTy+TCLBqXYfh2aGLNW1/NCvjG01f64Gbv0Zm/cb7SmnGnq0dlTa65zz4Jiz74cAUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652237; c=relaxed/simple;
	bh=+2GYlOZHwCZ0lRFJU17Kz/6XYFxNBVKE33Il+Q5Ltpo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CHrDBrc3b0+4B2MHGyyyuNNtruZYBj4rUERtfqeycMsnMbwy7Oet3uzTr5avKvj4Opb2pll3OI0YhAmWXSu2zwvAqzcrEOSppTOzi2tSan2eBeTlo5qU5h8uGlCqcLPz5a1sn+x99f7416sXXI35EshzQpKvnt5UipnOXTpPGIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JL0hoLlx; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JL0hoLlx"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b794a013bcso1528819f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 08 Aug 2025 04:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754652234; x=1755257034; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tCkPGBMU9cuxNuxHQvLapYjmFGObKhPk55g8w7OjRxY=;
        b=JL0hoLlxHqgZeGxKre9cbFGkg+Mtpiebk2nEU4QJ5yoHUYMSLj4iWICkjhXwa8OXOl
         vr3WaOqtLPWOz3LralEBlr62IMTXSoFSe+zrZFUR8DZTZJdXG1q5AJtVIzyE38evz8Yc
         fKDPJCKfhabwyDH1Yes3tsxR+nM5S3jLrLg2sTi5W8SJeDtzMqdb7Yq8pe+rGWZDfpeb
         XhUektGGGnp/LOslL8S8LTuLLUVGCsPCqGznTfMS+uJ42xQGHWjfnhhPUrsEqMAbfHCp
         AXlHp+cRm+yUbHBO7F5+8bbf6G40RrCNu7QtVa4Y/WKHtidI7+OlQZ7CWIsgdxmi4r6y
         eLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652234; x=1755257034;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tCkPGBMU9cuxNuxHQvLapYjmFGObKhPk55g8w7OjRxY=;
        b=N0ulHkzSkaniBAzK0BNWXGOH7piciOOmwxyJCvcErDhC0s03EOCeQGyXIlLusVGGZn
         HKBKa6y97MOj4eivQoW/ehpqkzjKM27o2VGyi43i1NJW7wfPsuTUJ+PyWkCU3F+kedTL
         c6v++7MkmAhfdbVg4Xs2aYmNA1kAA7iBYDV1nvI5Gvooq8AsA+SCeeBGSjZ0pGvc30ZY
         8whF6Wo61VMxfCXSlQg51YayssTMCN4oL5cXVpNJvicYeShhJOLT5BrLQPHdJ5EwgOYW
         Wf+J+hP/gdjs2+04kw0N7+kkZfgLYOY7s1tNi/f1hS0F0m1Ryh9XwVRcylGVwvfVJ8se
         0wZA==
X-Forwarded-Encrypted: i=1; AJvYcCWnmTJ9fVnL5lSb4h7MdiO+fZOKC14dEXM5xYajU2DPOpt9P2t5dTGYm7iDijhG5jdet7aGKPU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUuwaQ+ErmIaWrT3A7py1pcZJwfQ+fnAiZjCwp+SQkYn/9Ogp5
	ZSbJtiQgSbiqyuPo1ssdVPOrhfOJW0sZ+6obQ0bQelFaLPDaxIfXe7qfk9pzmCtT9Ns=
X-Gm-Gg: ASbGncvP3nu4B62eW9u3/lOCP/hO5pqJFQKApm+QqjO9xHXH2fpW1Sxz7r8YK+M7qsw
	ry/tdWl2xt2SBtf8RYyn50X5RJQnIlG+OG7+ft5tGtbPFofkff842V3JXi/Q39UZbIIGlgkhw0M
	mE2+V398RHL+rm5IhRN93zXorvauv8zUmuEYSKv9K9c3ImZ0FfiRDi/e3sO06K0HuBBIz0V5PwF
	z2SH6Ikm2DpsMQXPVrPSFJF/HdwziZrH+Dx8gWGcHCcV3yrfalv4yqjWqnbvZPZ+aQlurvecrb/
	bwrHuWR6rfwb8A8TicM8pS1YAOtToNE/67GJ+lOWN1jBI1R2tR/Lhx9KVDFnjUeHN4JnX67CObe
	f4APPx1bMwVWCX+52VyDqZtID3/1isVQ=
X-Google-Smtp-Source: AGHT+IHbD1rxZ+hael7UI+V4nWIH1JBGIhGROdLFUhD8+vK/+XpzNrjCzw2lcwqBQ5oIfEeaFLVqCQ==
X-Received: by 2002:a05:6000:288b:b0:3b5:f0aa:b1e5 with SMTP id ffacd0b85a97d-3b900b4dac6mr1921081f8f.19.1754652233967;
        Fri, 08 Aug 2025 04:23:53 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45923c34af8sm233482635e9.24.2025.08.08.04.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:23:53 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Fri, 08 Aug 2025 12:23:04 +0100
Subject: [PATCH v6 07/12] KVM: arm64: Add trap configs for PMSDSFR_EL1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-james-perf-feat_spe_eft-v6-7-6daf498578c8@linaro.org>
References: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
In-Reply-To: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
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

SPE data source filtering (SPE_FEAT_FDS) adds a new register
PMSDSFR_EL1, add the trap configs for it. PMSNEVFR_EL1 was also missing
its VNCR offset so add it along with PMSDSFR_EL1.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/vncr_mapping.h | 2 ++
 arch/arm64/kvm/emulate-nested.c       | 1 +
 arch/arm64/kvm/sys_regs.c             | 1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index f6ec500ad3fa..c2485a862e69 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -94,6 +94,8 @@
 #define VNCR_PMSICR_EL1         0x838
 #define VNCR_PMSIRR_EL1         0x840
 #define VNCR_PMSLATFR_EL1       0x848
+#define VNCR_PMSNEVFR_EL1       0x850
+#define VNCR_PMSDSFR_EL1        0x858
 #define VNCR_TRFCR_EL1          0x880
 #define VNCR_MPAM1_EL1          0x900
 #define VNCR_MPAMHCR_EL2        0x930
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 90cb4b7ae0ff..aeaba7813275 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1185,6 +1185,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_PMSIRR_EL1,		CGT_MDCR_TPMS),
 	SR_TRAP(SYS_PMSLATFR_EL1,	CGT_MDCR_TPMS),
 	SR_TRAP(SYS_PMSNEVFR_EL1,	CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSDSFR_EL1,	CGT_MDCR_TPMS),
 	SR_TRAP(SYS_TRFCR_EL1,		CGT_MDCR_TTRF),
 	SR_TRAP(SYS_TRBBASER_EL1,	CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBLIMITR_EL1,	CGT_MDCR_E2TB),
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82ffb3b3b3cf..d1a55cf589b7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3083,6 +3083,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMBLIMITR_EL1), undef_access },
 	{ SYS_DESC(SYS_PMBPTR_EL1), undef_access },
 	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSDSFR_EL1), undef_access },
 	/* PMBIDR_EL1 is not trapped */
 
 	{ PMU_SYS_REG(PMINTENSET_EL1),

-- 
2.34.1

