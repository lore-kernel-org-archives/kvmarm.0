Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030D24A1A
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120607; cv=none; b=qK/RNnX/SC6G+4LY3QJGnqPs6BvsM1Yy++Vmgo/clyoKsc08wIJQX87knMOZfIFGJwBuFCSGWTxQDcP3A2sqiYJAJiSwqAdx8uXpkYrFB5zqhIpDwIRh/XSK0zxm8UQ45Zql0Y6QsxuQUZACks/oKPHToa2Oiz1fkt9jwGqPt3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120607; c=relaxed/simple;
	bh=NVy82iJ/QLGDAl8W6Sh4eSwnTCJwtHJ0GXadcsGR9Xc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=RWDJwqui2fHxya2CvCKGdNZbxzqwfCunYfEoo4Nh3cJ7/20nlOgpEZQfgggrW/RRLjvX0kFeTmjzcwrRjl3g0ztO4SKs6phc6AKYs3djysmx0+gg5zobDpJdPoS229cIV8Gd8xS3rixgrpHxXG4E07WPrCJrSsj9SNWuyMZ256o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nksVwUz5; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nksVwUz5"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-3a51481a598so474874f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749120602; x=1749725402; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MOtEpU/QTXhqeOr4QGO8o+Hgp7yMZJ+Usq43ricq8a4=;
        b=nksVwUz5aOCuboA+FWIS7zADuonlUs6/u63ptSAxfIiFwrspWy08g831l8Su67MGQH
         dY7s4j2X9T2DVI8huB0oAXXcdZxiE5w658Uyz/Z4Q5BIB3HMdXzOWbQ12DB37/ZZOTcz
         WsmkoCgk04BoctJ5zbQadWm+FAFcmKa8lJIU+5TX8QUubKyqkwZ3JDmw2fj+yRHKGbts
         RVmbKv3fFpVCOKD0MAPRhdDqI2y1pt+EtzYyiiZ/AxDE0GxxUe8/sc6Eg9LKgN8C8SAi
         zEKGYBfppUxrsLVfGNTiQ65Ys5v6pLZmZ7P5ENhiBFVhWgsCjLg/556ZyLIXOwDRenYg
         8i8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749120602; x=1749725402;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MOtEpU/QTXhqeOr4QGO8o+Hgp7yMZJ+Usq43ricq8a4=;
        b=SvqUFj6Vbb6fCVGEOx6YbkkY65zj3iT+mYOPxwK8TAr1J2bLPSqzTpT4uYGPFdnLTA
         tmOdcP9MDw3bTpdVlKTrPOLC+XNLi7+JVqvMhVsvX+nFG8Z2gE1UoeUoQrHxxJasAWda
         v4f+Iy/ZHgKPgyCX3vcXBFSTDWO1u3mIxzwDEGLPOx+zdDFU3KWMaIBOvCHUfCd8KXte
         frB4FHcU8gA/7K2N2viV97EpLobkWFJm/+15fAMDm8A0RFRIWSB8vc+UFgY8Fro4I1mi
         +geq++IP9knNIP3BblLtWZvDQCCyM3lZ2iwJCQ6UnYldRyQx9Dk1mjUDrUf2lF3KkB6c
         ttDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTPmkRgjG/Vim3gt3vujYiCCGRszedm9zZ9gDkF/htkGAwcoUwp95JiZ5zD2qzGSZEAiTKFdw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+aeHO+LeA+aDf7x6/8Mr1X0BU/I9+Ct5VINXIHuBK5J7kHZ1w
	fBwMWypoxd1fmNKzyXoaGNts9AsL3iL9ZtnHZ8TBxDZAepn35/+5fWt/Mf0I7tDtzlg=
X-Gm-Gg: ASbGnctQR2+o8xEnaFtyMWLnfxQaPbQh6H20UG82pcSRSWS+OrooFWlUqpysMquuBjC
	uDjzzm0gh9rQn5UbM8aGYEFAz30+nQWsdj9VGzEZa43atS1T3LYQ2yPzWMFjOQpamRcr8+vq8qv
	JP+TG3Lz1EWEB8a+4vQensZipHRPkRjrR0c5/uC5Lon6v3y8564E01bXNEuK0q/UsX7XXuZL1PI
	1oN22rLMQ/HmpccIlP92wy5odMZMx8pxqUYpfVs7ucw2gOngthvSTy1UCnw9uDjR+/JPCaPDzNL
	B1y386IvpnEj7x1arTZ/VtxIbRYxVEQkZecdiuC6kpyTxAbD2WFV29eHq0MW
X-Google-Smtp-Source: AGHT+IFIuwqPu0X5eoCscdhdRejVlPb11XtHePijaNQ8MuQwLUyBUWJS/pTWuyRwgt/m/n/fycau1w==
X-Received: by 2002:a05:6000:4009:b0:3a4:febd:39f2 with SMTP id ffacd0b85a97d-3a51d9661b7mr4769796f8f.37.1749120602299;
        Thu, 05 Jun 2025 03:50:02 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f990cfe3sm20629965e9.23.2025.06.05.03.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:50:00 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Subject: [PATCH v3 00/10] perf: arm_spe: Armv8.8 SPE features
Date: Thu, 05 Jun 2025 11:48:58 +0100
Message-Id: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABp2QWgC/33OTQrCMBAF4KtI1kYm6Y+pK+8hUsZk0ka0LUkpS
 undTQuiLuryDcz33sgCeUeBHTYj8zS44NomhmS7YbrGpiLuTMxMgswgEZJf8U6Bd+Qtt4R9GTo
 qyfY8z7WxqVGWioLF786TdY9FPp1jrl3oW/9cigYxX99msmoOggOXqCWYFPZaq+PNNejbXeuru
 WMBMsj/A8akCkhRqjLxDcyrBvlZksliHZIRQhBYXBAN5PgDTdP0AtFtJ35JAQAA
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

Support 3 new SPE features: FEAT_SPEv1p4 filters, FEAT_SPE_EFT extended
filtering, and SPE_FEAT_FDS data source filtering. The features are
independent can be applied separately:

  * Prerequisite sysreg changes - patches 1 - 2
  * FEAT_SPEv1p4 - patch 3
  * FEAT_SPE_EFT - patch 4
  * FEAT_SPE_FDS - patches 5 - 8
  * FEAT_SPE_FDS Perf tool changes - patches 9 - 11

The first two features will work with old Perfs but a Perf change to
parse the new config4 is required for the last feature.

To: 

---
Changes in v3:
- Use PMSIDR_EL1_FDS instead of 1 << PMSIDR_EL1_FDS_SHIFT
- Add VNCR offsets
- Link to v2: https://lore.kernel.org/r/20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org

Changes in v2:
- Fix detection of FEAT_SPE_FDS in el2_setup.h
- Pickup Marc Z's sysreg change instead which matches the json
- Restructure and expand docs changes
- Link to v1: https://lore.kernel.org/r/20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org

---
James Clark (10):
      arm64: sysreg: Add new PMSFCR_EL1 fields and PMSDSFR_EL1 register
      perf: arm_spe: Support FEAT_SPEv1p4 filters
      perf: arm_spe: Add support for FEAT_SPE_EFT extended filtering
      arm64/boot: Enable EL2 requirements for SPE_FEAT_FDS
      KVM: arm64: Add trap configs for PMSDSFR_EL1
      perf: Add perf_event_attr::config4
      perf: arm_spe: Add support for filtering on data source
      tools headers UAPI: Sync linux/perf_event.h with the kernel sources
      perf tools: Add support for perf_event_attr::config4
      perf docs: arm-spe: Document new SPE filtering features

 Documentation/arch/arm64/booting.rst      |  11 ++++
 arch/arm64/include/asm/el2_setup.h        |  14 +++++
 arch/arm64/include/asm/sysreg.h           |   7 +++
 arch/arm64/include/asm/vncr_mapping.h     |   2 +
 arch/arm64/kvm/emulate-nested.c           |   1 +
 arch/arm64/kvm/sys_regs.c                 |   1 +
 arch/arm64/tools/sysreg                   |  13 +++-
 drivers/perf/arm_spe_pmu.c                | 100 +++++++++++++++++++++++++++++-
 include/uapi/linux/perf_event.h           |   2 +
 tools/include/uapi/linux/perf_event.h     |   2 +
 tools/perf/Documentation/perf-arm-spe.txt |  97 ++++++++++++++++++++++++++---
 tools/perf/tests/parse-events.c           |  14 ++++-
 tools/perf/util/parse-events.c            |  11 ++++
 tools/perf/util/parse-events.h            |   1 +
 tools/perf/util/parse-events.l            |   1 +
 tools/perf/util/pmu.c                     |   8 +++
 tools/perf/util/pmu.h                     |   1 +
 17 files changed, 273 insertions(+), 13 deletions(-)
---
base-commit: ec7714e4947909190ffb3041a03311a975350fe0
change-id: 20250312-james-perf-feat_spe_eft-66cdf4d8fe99

Best regards,
-- 
James Clark <james.clark@linaro.org>

