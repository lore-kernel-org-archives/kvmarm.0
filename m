Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268912797AA
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 11:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746531757; cv=none; b=ZeNMJm9kpMQk3IQb/kDoPkIDTGaGm6eMDnJHL3fWUyBMBCul5e+jAWLEBEPodmd3bO2EKxOaCFSOO6vQ1vAbSAnA7F6Q8iyLIf6jUX7rRQ4o79PchkQmaPEk0Yq6+h4ax/3e4fRTXehhsiPJWyMtf9d2cq/Va11gZt+zPkSRLlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746531757; c=relaxed/simple;
	bh=53o0sYJ2SFYzmVWDlseNZHgWWvafm3wu94/O9xTHfuU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Bv3jgbicR53UKIb5zUtzCEZ4sb+0s68r1bjYFzMhChVrR2Eta4+pOaEXddDHpzl0GbaWLFdc2F5nfo53aqgA0KRaqDG0vzSnJi1rJdOAcAf0cJI/g18Wskl1wMdyTBEW1R+UM+ohhp4SAuJCC+a9FvMHVBl+pIZM2bRKj5kvKYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z8r9eZtI; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z8r9eZtI"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39c1ee0fd43so5808062f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 04:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746531752; x=1747136552; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nn7zwwW1+OwGIV0wfJqgAgTa7HI6crOwjPKwSXJSzwc=;
        b=Z8r9eZtIfY3y40KZ+iPVDzrLcvg8PskmcD3HBHtPfutqxMr/+hVwbETPnEKB4gdT0p
         fAkctfy32I4VVlEFgz6jvR/gtvR31FTSV046pGs+8+RMRSJO8gKkRtxe4vXHegBKDQn7
         6285l49/WHrh7LNWH4diK94fZqqu0kiyuRgSRlGzk0hatVshwGw7L1r6NmSA/JU0T+i5
         BDI5UHycczaMXfQEyMQgOluhS0mG1RoExB6jU04Kb4zuojYePc6tE5HzAjzKcV7EJ4vj
         JtTf+uo1mbyB7fr6zzJq+6yej619v5ZfaxBTdSMTrCihNdCF3m4FNK+bnWV19G/l2cU2
         qpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746531752; x=1747136552;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nn7zwwW1+OwGIV0wfJqgAgTa7HI6crOwjPKwSXJSzwc=;
        b=JUImhP9J9cL3j1zYI2ONThWUBazXiUvQhcofg/YLhkEXRUxMvYEMq5JjWjQpf+CGc0
         gKBprWtR+6Q7X1v7HCdq5I5tMdm4hOUG9k8YJjUg61HAz6S0SYjnhXuKeHUTLTkrhGdx
         OVcJPI05vH1+pyNILcLQ39jAVVaWSOXrJgaug2u2B4DlL2pHXR11iylY1nj6tmJ2FFe5
         WPKHpPNSFAphuBcfznrKQgLiUodW1WfbXRUejlbC7HRC95X0x6aIorX0uEWSeo1Jw0IA
         tu5j6iLoMjsrLCfxoXytP4pSNv4c3p/yphCl2T2Zrq6xcYBaJi2/kj5dCeA1txOb0d4P
         TNig==
X-Forwarded-Encrypted: i=1; AJvYcCUKP4VosZmn6y/DtUvGtSHeBzjnHTsXG3NorPAmqEQxA+QoaheQ46jy7MYSVld/ywDUdHTy9m4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIfFWOoCyW4CvePREstN7TiZ6xWqR3AdxGLm5Ndm7ioPoaKPUt
	Q1bPogUIfNGDs5H39o75g34PwmoeFis0UeY2Ksh0e3quTqtVoLbJOzWhBAuoffw=
X-Gm-Gg: ASbGncuM1ig/eONncWk1ZPq9+Jh1emKnFUTGVQVO3xZsoa22mZzVBMhM6xvdcl3t3eS
	bXE14A9yVQlGRRf4G9PZYaL9Yl5lr7xiqo8S83UDBB4XalNAHhi22LVGEIqms1bMdpsoY5K96+m
	YFkhFg9LI0B2kW21iRAve47RnLcCqMF3fd9/dUM0jAOFXHYHGMaYvCUANAKbGw9ep1PkuuL7Yl5
	CNgBl10gMsTRHoFP5s4F+C8cBd8xus87kbSNmBSqmWhS6e9K23DDgZFKVEYvclf741IQWsSkhNb
	RZUk+SV++reu+P7YsmIrVLFIE8UiCjfff1njtazzeTNt2GRnBiq3BAp1dQ==
X-Google-Smtp-Source: AGHT+IFOFC/HYp+b/sLqshfj6fUDhVXxkvGd1k4jKO8z9uXGvrvvByGxLJkY/vukR63GyNj7W/KV9Q==
X-Received: by 2002:a05:6000:2405:b0:3a0:80b2:eedc with SMTP id ffacd0b85a97d-3a0ac3eb337mr2198218f8f.52.1746531752133;
        Tue, 06 May 2025 04:42:32 -0700 (PDT)
Received: from ho-tower-lan.lan ([77.81.75.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae344esm13198473f8f.25.2025.05.06.04.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 04:42:31 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Subject: [PATCH 00/10] perf: arm_spe: Armv8.8 SPE features
Date: Tue, 06 May 2025 12:41:32 +0100
Message-Id: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGz1GWgC/3WNQQ6CMBBFr0Jm7Zi2IIIr72EIadop1GhLpoRoC
 He3krh0+V7y318hEXtKcClWYFp88jFkkIcCzKjDQOhtZlBCnUQpFd71kxJOxA4d6blPE/XkZqx
 rY11lG0dtC3k9MTn/2su3LvPo0xz5vR8t8mt/zfJvc5EoUGmjhK3E2Zjm+vBBczxGHqDbtu0D0
 veHVL8AAAA=
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

Support 3 new SPE features: FEAT_SPEv1p4 filters, FEAT_SPE_EFT extended
filtering, and SPE_FEAT_FDS data source filtering. The features are
independent can be applied separately:

  * Prerequisite sysreg changes - patch 1
  * FEAT_SPEv1p4 - patch 2
  * FEAT_SPE_EFT - patch 3
  * FEAT_SPE_FDS - patches 4 - 7
  * FEAT_SPE_FDS Perf tool changes - patches 8 - 10

The first two features will work with old Perfs but a Perf change to
parse the new config4 is required for the last feature.

Signed-off-by: James Clark <james.clark@linaro.org>
---
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
To: Jonathan Corbet <corbet@lwn.net>
To: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Zenghui Yu <yuzenghui@huawei.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Jiri Olsa <jolsa@kernel.org>
To: Ian Rogers <irogers@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
To: Liang, Kan <kan.liang@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: kvmarm@lists.linux.dev

---
James Clark (10):
      arm64: sysreg: Add new PMSIDR_EL1 and PMSFCR_EL1 fields
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
 arch/arm64/kvm/emulate-nested.c           |   1 +
 arch/arm64/kvm/sys_regs.c                 |   1 +
 arch/arm64/tools/sysreg                   |  26 ++++++--
 drivers/perf/arm_spe_pmu.c                | 100 +++++++++++++++++++++++++++++-
 include/uapi/linux/perf_event.h           |   2 +
 tools/include/uapi/linux/perf_event.h     |   2 +
 tools/perf/Documentation/perf-arm-spe.txt |  86 ++++++++++++++++++++++---
 tools/perf/tests/parse-events.c           |  14 ++++-
 tools/perf/util/parse-events.c            |  11 ++++
 tools/perf/util/parse-events.h            |   1 +
 tools/perf/util/parse-events.l            |   1 +
 tools/perf/util/pmu.c                     |   8 +++
 tools/perf/util/pmu.h                     |   1 +
 16 files changed, 272 insertions(+), 14 deletions(-)
---
base-commit: 01f95500a162fca88cefab9ed64ceded5afabc12
change-id: 20250312-james-perf-feat_spe_eft-66cdf4d8fe99

Best regards,
-- 
James Clark <james.clark@linaro.org>

