Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1544A28DB5B
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 11:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518393; cv=none; b=GxnmLa6osyOFNaFffa4vj0EHlCt/nzzwTctJJAoXWCjBQLygHSza2iNW5bQ0XnQUOZlXisOq/8Y9TQU2uWh9xfCShAEOfC/CyYQCaAsyM843ZVmo8uiJkyEdiE4/kqUHg/GNdasQI+8KMhm23+6Vg0qGtnUEbvGydloG217WdHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518393; c=relaxed/simple;
	bh=bh4MgnxAaRyek2UdQKghPpoTWMGgrTm8WvxljGcyuvo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=jJzY0IxCtoDMNKRQ30OpSZ4Y+ZOJQhO5Mu+d+kn7pwlDLwiPHVQe4yZsenY7D++JSbF+sJik/xfDpRhdt0tR7Re0iOcP6Ixnvw4ZW92+xMQLmfO8uZhV8CVGbLiAfd/FrhmhNn2Qrnb9cPhcSfMFjQbomdQ1Lsk1qAiYIQprsFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L0fjgY0H; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L0fjgY0H"
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-441ab63a415so9350135e9.3
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 04:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748518388; x=1749123188; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9RGEjbS+3C/e9OMoWBvhsdf9eFJydSpRbxivnh7opTI=;
        b=L0fjgY0HKl1y3GUh1F/jZ8PaX1ZAf7Ugol3hIuVg9UtVgaM95QLAvE87Ltu0d3lkJn
         yS/qej6BhGZkKR9rPsg+pLRQvfz0hXis2o0sH+jJCGSkls4WxaOs+sjoydFdusN1H6SJ
         TJmEGcqtabxVbN/G9nk2YAKOXOTLS5ciXxwIr1UJ3YudA8GPjh6NVFUY+p8kSO2dWhuc
         DJu5LQPc2IqYmjT2oj/9O42i6APYHs0Oehaky4DgVtfaGdA5YSOdhHdg45wMu4hVvz3V
         8nCicHSIurA0yLSUIbW7CHXwTHFZ5Yn25HJ3kNYvgdblO8lVs8h0fNx+g36mh1vyDMLU
         UYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748518388; x=1749123188;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9RGEjbS+3C/e9OMoWBvhsdf9eFJydSpRbxivnh7opTI=;
        b=lwVYjpUC9XeqBeCy1GVp1Jvr35lqJy7bMnvdxTX8Qd77lUalkaKifu2Y62nk0Wes5D
         +asJIigVVV4LjYLyOVg98gSryRbdD4ceaS6kmx+d40itcQV7bq1vl2EMc87p10EyNTVJ
         tjbZHDTasPqvnS5/KWFB/n52kTWp5SrWC+EiZ0mNKmEhnGcHTAkw1bVZZTxpRi0KKw2Y
         6/XKjdDG92Jv/Zs9s9lbi/nMjNYJgNW+8PPHFYaKYC73nkHMfW363o+HrO3QsTmQEdR9
         pYiYVOFm+Sr0OVlPGVGGfbStXvBEKmWQHJzO/SPbqS2aTwogwIcX6nNpr9LLyztiC+TP
         ULWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMmFdDJAnDoYjwI3P9DOoKHlZkupTuHBpaw7nEe+XL2TS7QaQw1nrwu3H03SnmXh6En+j/MuY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfDW8jOLrG05mMwo9DQbKkBCGRdpsHd5V0ixWVS1FgfKvV2vJp
	7VFKHX7SlqRXm18SAZNK+Pe+4K2uctmsbUaLXoIZTeuAfD+R1tfSTXJwq+6AXK2eUL0=
X-Gm-Gg: ASbGncsY8tkrdWH+BUhe5vDiKHaKv98IoLjB4e1UC0KUifQWaiVrNW0yGe17IpbzIt6
	exjw+T1RsBusF/u1a7migdnR8wQHOYv9QnbvAtOwZx4CI4JfdMqJAGXlOdZ74Q1N5+EloELKvn4
	K1regvzjpQtYNQke3R9bMfyOsLBrwQWNQDCMRPd0iiDHhDAeQl9qwzQkY6lMvI0Syia1bpW1jZ7
	2XGSdWODa+fjzTUWK8VPXBlF4CVUbkbQpm/3XvKM9wNZkn/NjF520q0wumFlKQrVsMDhzZ62Atj
	gjjU2YBr5vJXKfj/x17V2xV5eJWV3OKQldhoowFXFd5NwAjjqTx3DfXhfy1W
X-Google-Smtp-Source: AGHT+IFDz2Nzk5rV8H17aE5jP5Yo1dXjiKY7Wt+ZcHiSvBCRbRuqUmfh+W28PJ1soWP3lufeYbHSmw==
X-Received: by 2002:a05:600c:3482:b0:441:b00d:e9d1 with SMTP id 5b1f17b1804b1-450d055ba9fmr18892675e9.2.1748518388273;
        Thu, 29 May 2025 04:33:08 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450cfc3785bsm17443945e9.40.2025.05.29.04.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 04:33:07 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Subject: [PATCH v2 00/11] perf: arm_spe: Armv8.8 SPE features
Date: Thu, 29 May 2025 12:30:21 +0100
Message-Id: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAE1FOGgC/33N0QqDIBTG8VcJr+c4mjXb1d5jRIgey7FpaMRG9
 O6zYLCb7fJ/4Py+hSSMDhM5FwuJOLvkgs/BDwXRg/I9UmdyEw68gpJxelMPTHTEaKlFNXVpxA7
 tROtaGyuMtNg0JH+PEa177vK1zT24NIX42odmtl0/ZvnTnBkFypXmYASctJaXu/MqhmOI/baxA
 xXU/wFjhASUKGTFvoF2Xdc3cIeZJgABAAA=
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
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>, 
 Leo Yan <leo.yan@arm.com>
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

---
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

Marc Zyngier (1):
      arm64: sysreg: Update PMSIDR_EL1 description

 Documentation/arch/arm64/booting.rst      |  11 ++++
 arch/arm64/include/asm/el2_setup.h        |  14 +++++
 arch/arm64/include/asm/sysreg.h           |   7 +++
 arch/arm64/kvm/emulate-nested.c           |   1 +
 arch/arm64/kvm/sys_regs.c                 |   1 +
 arch/arm64/tools/sysreg                   |  45 ++++++++++++--
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
 16 files changed, 301 insertions(+), 15 deletions(-)
---
base-commit: 90b83efa6701656e02c86e7df2cb1765ea602d07
change-id: 20250312-james-perf-feat_spe_eft-66cdf4d8fe99

Best regards,
-- 
James Clark <james.clark@linaro.org>

