Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CF127C16F
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 11:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746531762; cv=none; b=sjmRf488je13pWk8Y4YFaoVWFvDb7ql/IZ/NmjK9Seht+zyGW+8SdewcwpvgzXjokLaWu3t3KvcNS/kOb40jAldAtk//W1MYZPFnkB8X4mjHLlrymCPVx54vgaDFYgp5aZtj6RfPc92LQo1tzPbbAlU9/d7O/UJEywcT5gwG00I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746531762; c=relaxed/simple;
	bh=f5noS+6MFnNZ5/918HPeH3J2Z+Rlodkc5p0XHS41WVw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R+vWxL/iP8xRyUfQGk7Mj3WH0X1KtpPXZ80zDPzpsNx3jqC/LLgpouZZmICRyljmZyNNl13px1l9V4rJiR0V45nUwa8steipmEHtmrYkAisUUb3zfvpHIYDN61xH+J9PTU/qRVngO3bGFCX6JIIgsHD5KVHPAbVET6BX3IDYmYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X98i268N; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X98i268N"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39ac8e7688aso3980759f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 04:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746531759; x=1747136559; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gMCZkyRZidUrNwX5Cx9PhWIRQc02z6irI9+xxc34niE=;
        b=X98i268NAmJdN5eJbIgD7bKL+++MfNGvpViMXNvJoZmw5ysYdd6NLyDDnPdMaywz3a
         9MaREd4uturzopyL6DcOd9C/kPNeOrUHMYrBQ9CAKyTp1PRm0smfEOfeOhrbSxQABJYB
         Iuigd7xeCUciDR0uJPDhXDpbsY9SSRkmxjPaAFqR8WbljljMUI0eP4t0YoW18wE99fwV
         NzVLxlkgHfWt2gvHTDxeYnneuyw+eR+Gn2eNu15Cb6JrbuNExrmjngvAorfvYgasf/rU
         UALZ+tp6Zsh5mr8Y70aF9Z0krMK4ElwOB9pD00oLZ2mgu+kBxPpn2cuVYu4NJQWmvlXs
         j4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746531759; x=1747136559;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gMCZkyRZidUrNwX5Cx9PhWIRQc02z6irI9+xxc34niE=;
        b=UNGkmiThNhjSwCglphDfW2KdDbI37L0mC0sJZvsLt2qWOUsqKFyB3DT56eP1xgkwo+
         Zo5+RmuYTRMJ7bdcDFMZO07x2VG8iDBqcBUy18kENIKkWm1OzShngsvXF9U2eOtKgfuv
         oiMGpHK8+RM4fhz3UM+Hsh4+stwAqHBuzr/KfNGqTFGYNADvyJUcg9SLUaj/7PtA2zLD
         KGG0LrurVKwRI8WizID95aQM1Z+Ia55KimH9oX+c192dBav+rrxjkDIbzq/GrItDfK7M
         /eLD3a6BzXveUgZ3o0i2D8OHhFguHwjgJF7Scsh912N4GKFmDqbvEgVLnbKj48CmBS2b
         L5eA==
X-Forwarded-Encrypted: i=1; AJvYcCW42PUkVcI/s1CKvmzfFJ0DlXcZ0wB5EPa1WfzUihY7ru1bxESTwzdB2TbgcUyXdR8t125fF20=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqtGsrycSX0EaoaBEx2o2xuHBvVbYxijawMS3Jia6cwZGX31t6
	YACjJGh3P/KEtgU4dLvepTpgH3c3Y+/us/N1YkiWogagp9krY/crAm034pbaO00=
X-Gm-Gg: ASbGnct1lm78nwOgJNrAU+e7YHtudEEit6oogYyRX2xGPcfgGgmAzYwjgRi+yO9MAKY
	c1HJTk+W6VdNyYXwZjxbdmLUHC4Rd5e/h2yWfdCE0C73OoI7h5jMPPULl19QCtkfIewBVnywtx6
	Cz7p/tNMN9zMheyCKXVVOVn2mbpn3X9Tb3tnXDGEKh/fa0VbAHKuRsaRV5Cb6Foel2khxLL1URC
	dNafvIPSTZVlpVB7Oa1pPfXRkz9+B/gEhcoh4LSiDToDREjWlyPh7EBN58tZAs8yZdIFZtMXeaW
	4EzkUxdkuKgfRrr3XsVpygsHyfecYLA6qZcAlQ7N/MPUnkg=
X-Google-Smtp-Source: AGHT+IEqsmZ/YIUi8UcU8BFnJER1OGJ/WDZQZct9hbwqvalINWwYx3zLaSDOzEHLPrVfQzLWtlkByQ==
X-Received: by 2002:a05:6000:1787:b0:39e:cbe3:881 with SMTP id ffacd0b85a97d-3a0ac0cb3afmr1864442f8f.12.1746531759068;
        Tue, 06 May 2025 04:42:39 -0700 (PDT)
Received: from ho-tower-lan.lan ([77.81.75.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae344esm13198473f8f.25.2025.05.06.04.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 04:42:38 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Tue, 06 May 2025 12:41:37 +0100
Subject: [PATCH 05/10] KVM: arm64: Add trap configs for PMSDSFR_EL1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250506-james-perf-feat_spe_eft-v1-5-dd480e8e4851@linaro.org>
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
index 005ad28f7306..bda6195d7586 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2950,6 +2950,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMBLIMITR_EL1), undef_access },
 	{ SYS_DESC(SYS_PMBPTR_EL1), undef_access },
 	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSDSFR_EL1), undef_access },
 	/* PMBIDR_EL1 is not trapped */
 
 	{ PMU_SYS_REG(PMINTENSET_EL1),

-- 
2.34.1

