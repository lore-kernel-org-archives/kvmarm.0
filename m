Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1603358D17
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 11:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762861114; cv=none; b=crN63Pt893Q2ae5KevEPcOf07of1jEEykhWb7Op+Pg9Q5ZgiTslhJAj+h1XlBfr9ZVYDr/VZxj8+eQzr+6POmu5xhC31PPlCrPjypYmSJj4A+3WvRbL7NYXA7euWhawzpAW02qoS2BmCX7him4nFdhNBUFWVx1nBjKWrL4OIKBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762861114; c=relaxed/simple;
	bh=p+vt2lL3S9xP4IyWscwu6QjVeXIhxG41ki0RXYh2bYM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=MEQDmoggtgyLCvSQK3FTVH7W0oDGVMKa/1GJ7MVryZlR9pz5eyc3rhg0Oe9zmJqg5m6QKJI6JNlUo3+kpvlf8gqtIL9JwR3PBNrHECjbfo8kKc0xAp+vwoLz1sAcuvUW2ApAPDYvZb8MXWEUGHGOina+29WIXSg0FkjOEEthrHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xdcVhjeg; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xdcVhjeg"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47774d3536dso6221375e9.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 03:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762861109; x=1763465909; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ApNFjpZHiOUYvgtaOudntt1C1VCpeRhzgKLy7o9FKa0=;
        b=xdcVhjegg2vBVK0D9N4b4jDiI/N60MrIhPNJTaP5N8wwoJ5RE2YFi2aINq4nfBaAlk
         2OE/iZMoEtVDevT7nE9hpZhZKslCybTUbT/HPV//yKewfRiE9IyZVU4Pn+w6V3IybAld
         fs0KS3Ktk1LVnXjjAQhykQQQHLmIP/3WGAmn+q6oa6bovqt4F6Pi3/BPb3OpwUexFPAx
         coWhplTNmA0wUcafjCWk1mTXsFesvmJDxzSdf6gsNkHhRMqke8brkrt5GZMH+Nyu9p6X
         y10622NSo85+4+eMJu5pKxebB+Q3jeXMtBFWMatnVMEhS+hCXkSKB7IBJgARxh9dkHQj
         RxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762861109; x=1763465909;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ApNFjpZHiOUYvgtaOudntt1C1VCpeRhzgKLy7o9FKa0=;
        b=bAUq25ExV1RtcusT97maxVP9F0BAMtFsB/Hca2CuakjIE4gGuMUXQItXcCANMyVRMa
         LHpySYGG9ZivXp/8pzqyNCxjNGoi5dU4x0RX0VvGtB2XIuNdzXjY9G5qNpiz7Y8AB+py
         e/NyT+u3WxKKCEUDR317bu4T4CswqYw9Z/Z+auycalNcLUfMLEkdDvr0/5//3y44B1Xh
         0rfQpxdk7QpYeg2p0azY5sPfn18ei/2RfbZu9Lve2/kBmlgto0wcnFBClcSA1TmUq+J/
         vKgU0fi4exI+2Ud3DAZWJlHfxbFsJcu1srr/KDoRLSJz6GneG1b3Cjwe7fBoQnmVaKFd
         SdFA==
X-Forwarded-Encrypted: i=1; AJvYcCXb4wOPHb3ZhSS9zrUh92S9lvgnD2zsBujn4Sj0yVmEJi2A7qhy5a18Stp/ECtwEbh+l9YhcI8=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywmo9Jz2GAHfnTBRZb/PKKKcEcDEwAAr0wJNa0Cdp9M7rzkR7Yz
	5ZWOQQqYsUZhIRcC49VpgmjUHE2Kxdgrz2dVOErp/lh736DDhEox/P4Cglwvs7XYk0w=
X-Gm-Gg: ASbGnct+RXli8LBYY1p7FonECW14LBc8YDirseNyzKuEGGsWf4wbFWX07gHGPGrwCyO
	pxWG1ZX+UYarGLoWnAnEw3lPeU7IgUB95FRlSUi3gcy/sxbhgOGSVif2BrQXkAM8FnOnF5S6aGQ
	ffYNg1+Yes3MJkyhYVjIHzF73VjmBgAmrrLVskdjkp6dtxq4HWsdKFIQhoI7o08w+2I5UCXEbK9
	yrW2Xk6TQ+pKNSe/+ZtgT8mnjQeE0hLNNdTaDceI2Q6oBzapoRA9/QEnP/t919QoayiIZh045gH
	27wqRUdoawOLSIsRk3v6PV9EGvOfAzOMaU3sAnwRk4a1ryVfXzwOSvDUdcaXv46ch0yjaMWw1fi
	QyijIsTDxzR3479ev9ppEDi16KCSxPQEzi08ktXPHDlxl7YDxm82LgzA4TRb/kWQw9M6RVZZTNk
	th0qWGVfvmp6oHA9kzK8Rl
X-Google-Smtp-Source: AGHT+IHEHlUutl0pFeJ6Y+KwuVxOVrcZ87z0GEdb/YT/7CGKNgzL11KQ5qkLQpD/1daWqDjU8+9Wsg==
X-Received: by 2002:a05:600c:820e:b0:45d:e775:d8b8 with SMTP id 5b1f17b1804b1-47781418886mr28948915e9.1.1762861109025;
        Tue, 11 Nov 2025 03:38:29 -0800 (PST)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675cd25sm28133486f8f.22.2025.11.11.03.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 03:38:28 -0800 (PST)
From: James Clark <james.clark@linaro.org>
Subject: [PATCH v10 0/5] perf: arm_spe: Armv8.8 SPE features
Date: Tue, 11 Nov 2025 11:37:54 +0000
Message-Id: <20251111-james-perf-feat_spe_eft-v10-0-1e1b5bf2cd05@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABIgE2kC/43S20rDQBAA0F8peXZldvbuk/8hUiZ7aVe0KUkJS
 um/uxvQtMQUH2dgz9z23Ayxz3Fonjbnpo9jHnJ3KAGHh03j93TYRZZDSTQIqEBwZG/0EQd2jH1
 iKdJpOxzjNqYT09qHJINN0bmmvD72MeXPiX55LfE+D6eu/5oqjbxmf0yxao6cAUPyCEGC8d4+v
 +cD9d1j1+9qjQlQoO8DIUgL0UZpFb8Galcjzp0odOsQFoiAk2uJAmhaQGKGNKh1SBTI8Ba8S86
 CEwtIzpBBvg7JAgEpNJJDsiksIPVPSNXRTOuVEGVFtNyRniELdh3SBdKBknRWGXt7rQkyVxCX6
 5CpEBkpkkmEyi0gO0MO7oxm6/+JaIRNKNUfkPuFONw7v6v/CFEJ3TqfnLyBLpfLNz3FEttJAwA
 A
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

Support SPE_FEAT_FDS data source filtering.

---
Changes in v10:
- Pick up Peter's ack
- Slightly clarify commit message regarding the difference between the
  data source filter and the data source
- Link to v9: https://lore.kernel.org/r/20251029-james-perf-feat_spe_eft-v9-0-d22536b9cf94@linaro.org

Changes in v9:
- Fix another typo in docs: s/data_src_filter/inv_data_src_filter/g
- Drop already applied patches for other features. Only the data source
  filtering patches remain.
- Rebase on latest perf-tools-next
- Link to v8: https://lore.kernel.org/r/20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org

Changes in v8:
- Define __spe_vers_imp before it's used
- "disable traps to PMSDSFR" -> "disable traps of PMSDSFR to EL2"
- Link to v7: https://lore.kernel.org/r/20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org

Changes in v7:
- Fix typo in docs: s/data_src_filter/inv_data_src_filter/g
- Pickup trailers
- Link to v6: https://lore.kernel.org/r/20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org

Changes in v6:
- Rebase to resolve conflict with BRBE changes in el2_setup.h
- Link to v5: https://lore.kernel.org/r/20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org

Changes in v5:
- Forgot to pickup tags from v4
- Forgot to drop test and review tags on v4 patches that were
  significantly modified
- Update commit message for data source filtering to mention inversion
- Link to v4: https://lore.kernel.org/r/20250721-james-perf-feat_spe_eft-v4-0-0a527410f8fd@linaro.org

Changes in v4:
- Rewrite "const u64 feat_spe_eft_bits" inline
- Invert data source filter so that it's possible to exclude all data
  sources without adding an additional 'enable filter' flag
- Add a macro in el2_setup.h to check for an SPE version
- Probe valid filter bits instead of hardcoding them
- Take in Leo's commit to expose the filter bits as it depends on the
  new filter probing
- Link to v3: https://lore.kernel.org/r/20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org

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
James Clark (5):
      perf: Add perf_event_attr::config4
      perf: arm_spe: Add support for filtering on data source
      tools headers UAPI: Sync linux/perf_event.h with the kernel sources
      perf tools: Add support for perf_event_attr::config4
      perf docs: arm-spe: Document new SPE filtering features

 drivers/perf/arm_spe_pmu.c                |  37 +++++++++++
 include/uapi/linux/perf_event.h           |   2 +
 tools/include/uapi/linux/perf_event.h     |   2 +
 tools/perf/Documentation/perf-arm-spe.txt | 104 +++++++++++++++++++++++++++---
 tools/perf/tests/parse-events.c           |  13 +++-
 tools/perf/util/parse-events.c            |  11 ++++
 tools/perf/util/parse-events.h            |   1 +
 tools/perf/util/parse-events.l            |   1 +
 tools/perf/util/pmu.c                     |   8 +++
 tools/perf/util/pmu.h                     |   1 +
 10 files changed, 170 insertions(+), 10 deletions(-)
---
base-commit: 081006b7c8e19406dc6674c6b6d086764d415b5c
change-id: 20250312-james-perf-feat_spe_eft-66cdf4d8fe99

Best regards,
-- 
James Clark <james.clark@linaro.org>

