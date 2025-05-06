Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDADA27B4F8
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 11:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746531759; cv=none; b=p5zvytmUCJO2w6DX9mN4bCaDxP2jOtywjx0Cg46PFjSbS1Ylmq6m+a2OYvEhoYZXIlPGSL2OW/3+9FpCpSUXVzW8zy71+Oy1k+1yUKJ/tHbbqPwKu/YriOIkxEGbCW7ezLTnULTQDYmGotuJ3aAtptqDm/TMkZz8OPnOjmmLu7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746531759; c=relaxed/simple;
	bh=ypJv34hSI/cyQpZHsVl/I2dLtP+yiW11q72mGd7TSV0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FqIYrQqYbcsOvYBXLPAPbigBWT3zILlpQF8IrfzwPO8b1i8FtLY++AZciOgdG5GQKA7QUdcHxC/OmWS3kK3uqGa14PgPbf2IrASGacY7TDBD4fCXDpSdRAimA9hf5PP3Kgje4EBUV/IzYei9O8uE2BAU4vCB6ssXd8tFolPJKRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ghHC8PEi; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ghHC8PEi"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39ac8e7688aso3980688f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 04:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746531755; x=1747136555; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tr/eVzoQ45Dz9ymRgXeR+QCkRn1x7wE6DVCL1MblI/0=;
        b=ghHC8PEiFN4N904zTnA2yj4P9Sq32jrgJbTRMuASc1oSWLVjwRdvikKKJscia99RG3
         A98bpZVQSAshneVpQP+AarEJPy31r50xsI8j1Q9T8PY7Yl+oA7Zteixj52Ss7YNNUodQ
         UOac8RVBd6Lz/blTQn0NQoAH2BRt2wM6MHk4aUztH5i6Rczqi9b8rinAAn58TzKt6Y/L
         7gdtqhdwJ+2iqqw0BU01q009fvtNIBTcPyRbBACznD5UVLFJFRNDm5Vynt6Pj2nuJqnJ
         pRkvlxKx71k+ajsGIXGP4FTdIqvAQaZjEg2FWrGeXhnwyZ0E6QCoee6LIfrEMLo41QHn
         zC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746531755; x=1747136555;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tr/eVzoQ45Dz9ymRgXeR+QCkRn1x7wE6DVCL1MblI/0=;
        b=B8lWtjrNuJsWzltqqz8Jev+IQFzDK3uD5tSJ9Hrsws9zwevUbo47zuEuH+jl+v0k9D
         NRhzWDJglj7wTMs364tOKSSRiZmy8ZyjDl5KOvrnAbS5wO2YNElZHI+6bX+UNTjrYD8j
         TlC+ewe2nXSxP9Z6qU/U0D3S4Ue3nDlA1QuZsFOIDnRgrY71QFiq+knxUXs/Gff+Y35T
         KXtmjRaunONLki9rxRuZQBlUczS1V4GTH/DwkAcz/ZTH6txrEU5kHG4SKWX0MvHGGYi2
         nEbj9heNcS2nBhZP7LewQdgYnMKuj/nmQvYnsSJ4VLyyZHjnpArfvfAzTNKMHBowoJ4t
         6N2g==
X-Forwarded-Encrypted: i=1; AJvYcCWb2Ond3qAdIcZTLp5jf1BAfQi1AAjgCCpE0/UpXz4tMjykeVdUBoXiJJumgAkaWVQe3qMa1GQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4f9HJK+2EAxLD+8Fs7aGKhjZWrSzQbvbsdvC6+30ANvrGttK9
	Q6KP+tAwp5yxoEERIYwEUy3reluX/eViL/Qib21ypNTFQzr0sTpHwB9l/pmZh0k=
X-Gm-Gg: ASbGnct9LQB/C/duezdacR6/plTelRLXazYF3dsUV4qObiFVFgSDVLUCPDSBSQTxYKp
	hMcB54iin1xhfnVHusHFad0CWDglMMvMOxn40ylfn9KhrIMcaALDw61Slz8kK942O0PU1AxDZiG
	C7MnSTqQZTfBybW7GlSbk3mpSSr2UO7Bcyg2ABQDGn2xYF0LbB5HQtmXSzlZKhCJ9EOdZ5/doph
	+gO7boIvbxN32kZVY1NB1vzLAKWEqE9RjrjgGv2TygwsTfnV0vQxdpUuv+NDKgxK3QEH4S0NLK7
	uTIZIAG6Jl4KB5kZn2SRSVfRbl9hFh3R2DgHopulE9YmxCM=
X-Google-Smtp-Source: AGHT+IEH2+KTPzukEfAEMWWhxbAHT6NzJ/G9YGCnXDbFPk9R2A+Wr+4SDydWQzAME6RiQhm5jVhrhw==
X-Received: by 2002:a05:6000:1787:b0:39e:cbe3:881 with SMTP id ffacd0b85a97d-3a0ac0cb3afmr1864277f8f.12.1746531755089;
        Tue, 06 May 2025 04:42:35 -0700 (PDT)
Received: from ho-tower-lan.lan ([77.81.75.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae344esm13198473f8f.25.2025.05.06.04.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 04:42:34 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Tue, 06 May 2025 12:41:34 +0100
Subject: [PATCH 02/10] perf: arm_spe: Support FEAT_SPEv1p4 filters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250506-james-perf-feat_spe_eft-v1-2-dd480e8e4851@linaro.org>
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
In-Reply-To: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, James Clark <james.clark@linaro.org>, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14.0

FEAT_SPEv1p4 (optional from Armv8.8) adds some new filter bits, so
remove them from the previous version's RES0 bits using
PMSEVFR_EL1_RES0_V1P4_EXCL. It also makes some previously available bits
unavailable again, so add those back using PMSEVFR_EL1_RES0_V1P4_INCL.
E.g:

  E[30], bit [30]
  When FEAT_SPEv1p4 is _not_ implemented ...

FEAT_SPE_V1P3 has the same filters as V1P2 so explicitly add it to the
switch.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 drivers/perf/arm_spe_pmu.c      | 5 ++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2639d3633073..e24042e914a4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -354,6 +354,13 @@
 	(PMSEVFR_EL1_RES0_IMP & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
 #define PMSEVFR_EL1_RES0_V1P2	\
 	(PMSEVFR_EL1_RES0_V1P1 & ~BIT_ULL(6))
+#define PMSEVFR_EL1_RES0_V1P4_EXCL \
+	(BIT_ULL(2) | BIT_ULL(4) | GENMASK_ULL(10, 8) | GENMASK_ULL(23, 19))
+#define PMSEVFR_EL1_RES0_V1P4_INCL \
+	(GENMASK_ULL(31, 26))
+#define PMSEVFR_EL1_RES0_V1P4	\
+	(PMSEVFR_EL1_RES0_V1P4_INCL | \
+	(PMSEVFR_EL1_RES0_V1P2 & ~PMSEVFR_EL1_RES0_V1P4_EXCL))
 
 /* Buffer error reporting */
 #define PMBSR_EL1_FAULT_FSC_SHIFT	PMBSR_EL1_MSS_SHIFT
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 3efed8839a4e..d9f6d229dce8 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -701,9 +701,12 @@ static u64 arm_spe_pmsevfr_res0(u16 pmsver)
 	case ID_AA64DFR0_EL1_PMSVer_V1P1:
 		return PMSEVFR_EL1_RES0_V1P1;
 	case ID_AA64DFR0_EL1_PMSVer_V1P2:
+	case ID_AA64DFR0_EL1_PMSVer_V1P3:
+		return PMSEVFR_EL1_RES0_V1P2;
+	case ID_AA64DFR0_EL1_PMSVer_V1P4:
 	/* Return the highest version we support in default */
 	default:
-		return PMSEVFR_EL1_RES0_V1P2;
+		return PMSEVFR_EL1_RES0_V1P4;
 	}
 }
 

-- 
2.34.1

