Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E2C24290C
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120614; cv=none; b=hnhsZ0Ty1p5/LAt5C4lDo3xqu/fekS+lQoejI0tf6wZ1Z3SBF2LlQ+LVisG5Kb4pwzzIKTXlkzDJ3fhKgaaFNpEkBKEAPovKzDVsvFjdDtg3JVydFqOxx+kuTPT7tkRndHZB3GUE7LogMkHyIWiwe607Q9jQOlqpcGDKwkbzZ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120614; c=relaxed/simple;
	bh=D3a8CHQrVLegzkacJWeUjX0eoOkZvAqwfNoehax7vUs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qTmSpZMPo3OqccN2/gYjCUqzR3//ygMHMku3dxJJIFU/DN1I18yAuUyqLLO9gIoH1l+FhuMuXMOvA6Lwey8GL2Qwg8xTLNlWgZRxvKSUQg4g4BJrfGqToWysKGnwRXD1tKR5EOt21KWunPOdcQHOcLViWMH0/veRGE5V0cD71x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eKqBxAQS; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eKqBxAQS"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so9299585e9.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749120609; x=1749725409; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0DK6uM4OCMEufJaM16uRm6cXGr0jOYtB1myNeR7Sl5w=;
        b=eKqBxAQSG0HxKvhI+LAzEaumfDxnvVRjqHk/Bx7MBvZ4UC+s6vLdDZ937zyr+Z7SpJ
         GcwwXE2KW3qluqsvEixHffmmDl38iLv/xM/Zn6AKRwlJril/PNcII8dTck+2ynY+iUPs
         12zg3qkTmSPTlx6WdJebEn3VeKr5OB1tSMfDqYUjkxRoIAz8mrqkmb/0SKW18L/hDT5P
         SC9tvUuPXaW0RcyI6p0vwAlmmepMyGBqkVnqYGEo36mYe6F8WFTeZgtg9PJgLBk/tyEm
         Dq9N1Utc6ER6DMSmzgtPAkyT3PRW/BlHmZq4441Zrm9GB0H7RtIwXWopCVt2AKEAK38E
         vM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749120609; x=1749725409;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0DK6uM4OCMEufJaM16uRm6cXGr0jOYtB1myNeR7Sl5w=;
        b=ASVp4oR2PeyVCE0MlW/jb3d8zmVmkPHFN1iWbZIqz3Q+vQgC+1YWSO6CG0gTb34DXI
         QSY6l0VkjPaKkVbIs+LT6lKdBofpbRKWBxKvVM8RkRkbqn3yXt8NSxFW5MGIuCqdExSv
         Q8Rwo6zLM1rciR23bgNvUjK9oBMHB2q6OCCFLV8yP+orOTXirK5E0JeGlZIQ0iUMfteG
         4bKxz8DLtV1LndSF1uMdxYrxFP55XnORfJ7eGGDqGYRzbjRnZbTwUrXbDTNkzzUrglIZ
         c+v6ZVp9SfJxFqYQHyIlD4rvDgBXbFcL0YIedZmkgJkzQ/vfDl59baXbKFsHmG3JKkIY
         BurA==
X-Forwarded-Encrypted: i=1; AJvYcCXXTWK90r6YYIwlzcMniEa+iB6T3pEHNGrVn2r9R1G/JvGsDMwTgaGuTjYzXVchN3eiX9GlStY=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywl4dX/XbYdS1u1yXvOIXzpodbcQaxgakfSBhRtbL2KHDAUqNTe
	hXF1LlWlKCxYOZkftkh2mK6ijjQFSqL92kR2V8OcCnBOrRMJqInWgHQFwaQlLg1XaNQ=
X-Gm-Gg: ASbGncuHvINybXhNZAdTN7qeRqP8PRzTmO0dcnScUN75w9ClsHyYF4DD8EIq6d4rri8
	YSmHt6PSLTAM87zKyBKllYG5T4k1QSGHLBid+zHkbKTXLw9s9O8YIKRihoq8rNPcq0q09BNBLDM
	gy+FzG81uEGO3s0UXYtmb2p1V7bp1XxcaDa5gMF/pUrJOdEgaGjhVKH7UKYuObZk5R2lONuM1YQ
	o1GVX6Fy/AeH+gqCSsiAKgGVs2PIlxceOiYtMT+svs+fiF2RXUKFA2wicAOaEaJCy57Hbr8inag
	DOKQaRt90POkwH5aOb3/hNCjL9dlWoOenA5J2C+/sQtDXsNtH9nQbtv9KoNb0y5Y8+FC9qs=
X-Google-Smtp-Source: AGHT+IHW1X+WENRurUa43xQ9bej2IvG2qfN9i4ZVKvWxfljVS3ufqAHPvcXy1cLSRDDK8lgBUz9YNg==
X-Received: by 2002:a05:600c:a089:b0:43d:45a:8fbb with SMTP id 5b1f17b1804b1-451f0b0c598mr53918705e9.22.1749120609367;
        Thu, 05 Jun 2025 03:50:09 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f990cfe3sm20629965e9.23.2025.06.05.03.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:50:08 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Jun 2025 11:49:03 +0100
Subject: [PATCH v3 05/10] KVM: arm64: Add trap configs for PMSDSFR_EL1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250605-james-perf-feat_spe_eft-v3-5-71b0c9f98093@linaro.org>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
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
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

SPE data source filtering (SPE_FEAT_FDS) adds a new register
PMSDSFR_EL1, add the trap configs for it. PMSNEVFR_EL1 was also missing
its VNCR offset so add it along with PMSDSFR_EL1.

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/vncr_mapping.h | 2 ++
 arch/arm64/kvm/emulate-nested.c       | 1 +
 arch/arm64/kvm/sys_regs.c             | 1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index 6f556e993644..dba0e58a5fac 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -92,6 +92,8 @@
 #define VNCR_PMSICR_EL1         0x838
 #define VNCR_PMSIRR_EL1         0x840
 #define VNCR_PMSLATFR_EL1       0x848
+#define VNCR_PMSNEVFR_EL1       0x850
+#define VNCR_PMSDSFR_EL1        0x858
 #define VNCR_TRFCR_EL1          0x880
 #define VNCR_MPAM1_EL1          0x900
 #define VNCR_MPAMHCR_EL2        0x930
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 3a384e9660b8..60bd8b7f0e5b 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1174,6 +1174,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_PMSIRR_EL1,		CGT_MDCR_TPMS),
 	SR_TRAP(SYS_PMSLATFR_EL1,	CGT_MDCR_TPMS),
 	SR_TRAP(SYS_PMSNEVFR_EL1,	CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSDSFR_EL1,	CGT_MDCR_TPMS),
 	SR_TRAP(SYS_TRFCR_EL1,		CGT_MDCR_TTRF),
 	SR_TRAP(SYS_TRBBASER_EL1,	CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBLIMITR_EL1,	CGT_MDCR_E2TB),
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a6cf2888d150..4a88ba15c7df 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3008,6 +3008,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMBLIMITR_EL1), undef_access },
 	{ SYS_DESC(SYS_PMBPTR_EL1), undef_access },
 	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSDSFR_EL1), undef_access },
 	/* PMBIDR_EL1 is not trapped */
 
 	{ PMU_SYS_REG(PMINTENSET_EL1),

-- 
2.34.1

