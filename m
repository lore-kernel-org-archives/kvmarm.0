Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68E22F60AF
	for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 09:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755163570; cv=none; b=jaGydp5eYH/xrsCIzfJvJ5glCmZd2E1D+ObX8J4viKz86biTT53CzHVb1R/8e+R3ZNWUxZyfOljjdYK3fNs8yOTXmxLJ2PMoyBPORdCsNCIEXTt016PJK91jNUvKuD9lfuVyW4HZFKPYy7bvp2wqYAt72VycmNDNeU9Gaud7jTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755163570; c=relaxed/simple;
	bh=UsFp0sErRCl0MxQtdMcp7ORp6c6Qv9zuPqmFhcaNxF8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R46bvNT0OCuljOewC/r2ejW7ga/c4344NNbreYttosb7Yw1KXxXuZs4QemEjRGOJbTILlrHJ/Ag4P6V/yrkhPpt1QXZwz5+VD5VTSyYtwVHTwnTcC/nSHm6KliUfM626IjtCjd+10MKnIuR4wrxGSiXbB7ikd8wiNNBhIlpTFT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XFTBuLU1; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XFTBuLU1"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45a1b05a59fso4808425e9.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 02:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755163567; x=1755768367; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NGZcvUVCZS8QsvENr66yrxXLduHaz342cTv3n2jzGu0=;
        b=XFTBuLU1aQHjxsh6biE7ns78vhPCcx+prXD5THyK+byC3KiDQjYKfb/J6GsVB3A4B+
         MeGysmPo9ZoSGFAaR4YrzH0FkuyNLPibZoj/akMortCNxZCFhZ+R4iWmpBvi1591pDji
         N0DvdSWu4Q5qbVsAHnxGKWax+cCoOvRruUhFDUnirgWQEZR9l29/0AtEiosLemnTHEpK
         gY1n17yco32V+qz1Zyb46UrZRWkQIdzGlQw8+GNp3rf1WRxs8d0HgQXAHWvl7jAeOu30
         OXgRN+VmcGRdHmbwb+mj1BujubFXGIGXeO+zInmyEZy+SP8oN2wnzurigEBRO0DyzBFg
         wp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163567; x=1755768367;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NGZcvUVCZS8QsvENr66yrxXLduHaz342cTv3n2jzGu0=;
        b=gctqAPpT1euD6kYXFW5FB8av+VEqUWFkXda2pdosOUu8yKA1ZLEYf2SdS7FvB24Jp5
         JwmpqDfNgROVrDlj9iTVFLFsSkwJm3fT/ziRrddGvoNnOR+xoBrP3QI5R91OMjQogtuE
         kdj196xHjTFIeEl9qFF4HVtgOAhr/XqTF/jWN41axvhx6eIurjXQxbjQGIu/C/3d8lhn
         enU6IqSzVruKpw+lyB/g8oSHINOukEoVxDL+v9OYMGoDgKGiqMmd4KU8nwnAyig/pGp2
         Fam63PhOmDNjIJALLYeikIZnpy8b4xPenM6Zd4RhmWO8e0HyVGcJ8WXmQcKLIYm5+0BZ
         GLqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsUfmjI6PBjuIqHWeQ7VTc69nwmz1ZSPKL0Zg9t+FLmy9HhquOgEO8ncco9qzbhvg30DlKyiA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwyOEyCav9XVcZSVawm/AxOTl1AmlpBHc2FlViNV4h+ecIyJoBi
	NXqX6mGuL89XFs6R/S8Ud0CRX3qFGW0EHW/PERbXD8Zk6rLL7aw3PVXHY8RpTI7sk/XTNRKyWXf
	ygikw
X-Gm-Gg: ASbGnct17lcp+P6i3Q6VPUbmAaZsVxNMcMV43VxYwHMhDdr9cFt5EvpoBBEMCGTTnGo
	3/w0YnQ+zTMUUOFl0vD3GDU2VvoCV4nskqB2sYKoG2ke+kUMQQEkEEePWwm2lyIF9fotPDk2cT5
	rXlyYC2G4Tq08E22NJWFYsq3vNDyypaTRSGP0hPvFDY/QAjMIewwTR51oIiTS3dTpIhKOv/QauM
	uRbEndiOCBoahW5h8JoACozFPWoSSVsqPikkCH/e0uAVG66ITZ4vKrGvSfH2O/8ZlNpGOX9rYyh
	V4wYovjP9/iFCgks7mNcUB1uRRIxDF/s8+ktuWIcfpBOs3m8i+RCV1YQcYa+uvR7CG6UQ4txd1q
	+wuE3/67skmPpjozRpu5RhhVJurId+JU=
X-Google-Smtp-Source: AGHT+IEOkVLtv4LKb277h/Y6u80yjiTAO7bDjmFHcIn9yFqBWPJOT++6KQmTGEGyq1SqLmRRRDPzJA==
X-Received: by 2002:a05:600c:470d:b0:456:214f:f78d with SMTP id 5b1f17b1804b1-45a1b65f96cmr14249085e9.22.1755163566832;
        Thu, 14 Aug 2025 02:26:06 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c76e9basm14536775e9.21.2025.08.14.02.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:26:06 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 14 Aug 2025 10:25:29 +0100
Subject: [PATCH v7 07/12] KVM: arm64: Add trap configs for PMSDSFR_EL1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-james-perf-feat_spe_eft-v7-7-6a743f7fa259@linaro.org>
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

