Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D7113B284
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756730512; cv=none; b=NtfvBn5DYJLZnr2KBOx4Bxif28kCJiTfKTn5iLoYpgLhHypkUiVmg7xGL5S88xCv2z/tUA8iNCgDn3HK9kBXyNNxJ1mbFVlsg5240ASR3YXg9keuCuOlEp+FUSUi2YjaTSkqKD0lS450u5eD8zlvhPJ9z64ylwQz94aYDCjLPEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756730512; c=relaxed/simple;
	bh=72cPEa05J0fuz0fgw8EPUodMaUEV6d/ZMHGvKp2alTk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=i/8qBplMM7dO7hmcgyXJ3kmDa9ZQUgtpcxEvTsv7VKSvCOACCMOqnKF5uKmXwruwNgx/Z6uL4VMePWUZ5HKotCxKXOje+HA0vaQdY00hJFdrWkWxtctPO06/qImdedSFNqtitYz1HzqnqcwCIma849eAwdXa6kzl8ExqUp3jJvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WuFRkmD9; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WuFRkmD9"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b627ea685so36798415e9.1
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756730508; x=1757335308; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cW1RMJBgq8+Ixb2ud74sehWUJPMSoTNgKWq1D39aVBM=;
        b=WuFRkmD9OkrxMMiD46QXlCUBC0InFRGpKPTK80yllx4pxoJT+Lk6JD+nspOUuBtSxX
         ttdrviPpTk9h2IUoAOqVeI6bv44GwT6+v0UPUaMx2nkqOLiS1wV/ujnulwZ9AQRnbVwe
         gnbkYuX/mePt8GFsOJb+ECBrUPCiYcaJ5wDYXdp/h2OcfOJCedxJeoe0Th4yiE5EK/Iu
         ZsAakTZfYAgr7fEOEr0mHD9/gEoMU/+6ldYJFEwacwEK5V0mmzvCUrzFZvlhN5sJmR9A
         0zpw1BRn1GxGQZuUjw+hzsjskmITnLux2o4gcmWfw7hP/la3++BAehuMiHu3zK9qXLuV
         wZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756730508; x=1757335308;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cW1RMJBgq8+Ixb2ud74sehWUJPMSoTNgKWq1D39aVBM=;
        b=QOcKoizs+gf5LuPWzi3ugiA/NxgPOQbVvCNDeFzmaJT4nwNKHoQ846r2pKALYEE8V3
         VoLjX/cfiCti155Wh5FxsrerMXXba+XGtkG01+mdVxKLu82U97jt79w5Fz8ntUCwtSGI
         MLBmqMn7j53GwFU1dJZLSd9oP9Gm+AcqyeSTWhtjTI3adb54laIHunaBhpjntKrkTxNq
         vO26SZwnzBNfIWLMk2+1YmOUXwdZ4bILH8ZpNpS3XyspT5unwcZnXhtQiw8DOU7T6lJV
         IScy/oRlWcSMTnWSOHyy73Rfrs0BmeFbqhZJQh+tftMN+QsBCPDNGvLgXwcIkcKq/W4n
         lrUg==
X-Forwarded-Encrypted: i=1; AJvYcCUi47OfsSSBJH/MKWRGgr8QJ9IN0c4tt9236GZytSmFnXPTdqFWgVeK3xavJshmHXNMQdkLUUw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYRiEHjLX5+QQB36atQGhvv/+wQH1ETHRgIc9665twFgqwUCEQ
	WBLU+oK7S2ZrjbCuMt3Khim08m7VZgxlhjKY1khCx6b28k7uamlJzbqIvfXj4TqlbzQ=
X-Gm-Gg: ASbGncuW6swb8UIaV1b+7bIcxnFHbB2fajjiGZeCU2/6n8pjFKFbH87+dZy0TwoAm2/
	2gEDnsk4IM7tYlusLzcvO7GV/8bstJPXPcDHjGim+gn13SIwi+Mt9PgTtMylWkWubNUndeiHhUG
	GQ1DQJW0XwCo5sdXr5VtgoRf5cbO6BqHc9wGRUEsIGJo25P21mgtp27FjKeaKFLNGFHIxpyBDlP
	v6J2zLJ0h63vk22iz8FV4wB8ewegce5AQXjcnaB2a0y8DADKl2IRJN58A94BTrIE1csZt8d1bU+
	HLiIxTSaEvxuFckvKanma76g3mXyEIsEO7APyN5qWPl1Tgy0p3eOSk3AuML/hPlnUho3FSdv9O4
	hharWkt9WOzlv1xdJIN3ggiOcyQSYyEM=
X-Google-Smtp-Source: AGHT+IFE6fow3O8KM0rkY3i62xaP7WMDS4u/5CNiqOy4n0CRCf5rIl/7BP/8REZUAe6hCUgpCinnrQ==
X-Received: by 2002:a05:600c:4f8f:b0:458:b01c:8f with SMTP id 5b1f17b1804b1-45b85550a68mr69628025e9.8.1756730508401;
        Mon, 01 Sep 2025 05:41:48 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm154946315e9.19.2025.09.01.05.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:41:47 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Subject: [PATCH v8 00/12] perf: arm_spe: Armv8.8 SPE features
Date: Mon, 01 Sep 2025 13:40:29 +0100
Message-Id: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD6UtWgC/43RS2rDMBAG4KsEr6syektd9R6lhIk0SlSaOMjGt
 ATfvbKhOMG4dPkL5puHbk1HJVPXvOxuTaEhd7m91OCedk044eVILMeaGwFCg+SCfeCZOnalklg
 i7PfdlfaUemZMiElFl8j7plZfC6X8Nctv7zWfcte35XtuNPDp9deUm+bAGTCBQUBUYENwr5/5g
 qV9bstx6jEDGszfQIzKATlSTvN7YJpqEMskWvhtSFQIgaM/IEYwuILkAhnQ25CskOUHCD55B16
 uILVAVvBtSFUIUAurOCSX4grS/4T0tJo9BC1lPRGub2QWyIHbhkyFTMSkvNPWPf7WDNk7iKtty
 E4QWiWTTSi0f4DGcfwB/4UI2rYCAAA=
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

Support 3 new SPE features: FEAT_SPEv1p4 filters, FEAT_SPE_EFT extended
filtering, and SPE_FEAT_FDS data source filtering. The features are
independent can be applied separately:

  * Prerequisite sysreg changes - patch 1
  * FEAT_SPEv1p4 - patches 2 - 3
  * FEAT_SPE_EFT - patch 4
  * FEAT_SPE_FDS - patches 5 - 9
  * FEAT_SPE_FDS Perf tool changes - patches 10 - 12

The first two features will work with old Perfs but a Perf change to
parse the new config4 is required for the last feature.

---
Changes in v8:
- Define __spe_vers_imp before it's used
- "disable traps to PMSDSFR" -> "disable traps of PMSDSFR to EL2"
- Link to v7: https://lore.kernel.org/r/20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org

Changes in v7:
- Fix typo in docs: s/data_src_filter/inv_data_src_filter
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
James Clark (11):
      arm64: sysreg: Add new PMSFCR_EL1 fields and PMSDSFR_EL1 register
      perf: arm_spe: Support FEAT_SPEv1p4 filters
      perf: arm_spe: Add support for FEAT_SPE_EFT extended filtering
      arm64/boot: Factor out a macro to check SPE version
      arm64/boot: Enable EL2 requirements for SPE_FEAT_FDS
      KVM: arm64: Add trap configs for PMSDSFR_EL1
      perf: Add perf_event_attr::config4
      perf: arm_spe: Add support for filtering on data source
      tools headers UAPI: Sync linux/perf_event.h with the kernel sources
      perf tools: Add support for perf_event_attr::config4
      perf docs: arm-spe: Document new SPE filtering features

Leo Yan (1):
      perf: arm_spe: Expose event filter

 Documentation/arch/arm64/booting.rst      |  11 +++
 arch/arm64/include/asm/el2_setup.h        |  28 ++++--
 arch/arm64/include/asm/sysreg.h           |   9 --
 arch/arm64/include/asm/vncr_mapping.h     |   2 +
 arch/arm64/kvm/emulate-nested.c           |   1 +
 arch/arm64/kvm/sys_regs.c                 |   1 +
 arch/arm64/tools/sysreg                   |  13 ++-
 drivers/perf/arm_spe_pmu.c                | 148 ++++++++++++++++++++++++++----
 include/uapi/linux/perf_event.h           |   2 +
 tools/include/uapi/linux/perf_event.h     |   2 +
 tools/perf/Documentation/perf-arm-spe.txt | 104 +++++++++++++++++++--
 tools/perf/tests/parse-events.c           |  14 ++-
 tools/perf/util/parse-events.c            |  11 +++
 tools/perf/util/parse-events.h            |   1 +
 tools/perf/util/parse-events.l            |   1 +
 tools/perf/util/pmu.c                     |   8 ++
 tools/perf/util/pmu.h                     |   1 +
 17 files changed, 312 insertions(+), 45 deletions(-)
---
base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
change-id: 20250312-james-perf-feat_spe_eft-66cdf4d8fe99

Best regards,
-- 
James Clark <james.clark@linaro.org>

