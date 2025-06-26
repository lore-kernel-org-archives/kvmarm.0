Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD142F004F
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968354; cv=none; b=H0j783nqPOB2LIVtIoMhi8VF59E9WJ2vC5lab/a5LqVfrK9sX+If9yeokDUWdNTjzMKidZyeT0+dO1xcZknPw96m93zuKbhbhnOAW+Qm39K9//FASScl37ZhEGyFQ1x+1V+WQ1YM/mN2xSVGFNc7D2cNhEJGgEaV34a9nsT5sD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968354; c=relaxed/simple;
	bh=Eks9aCTcXYvbdNVmdIGtwvOLNkf6fFcYgMML3qNUFtA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Cmp1GsSzUVftXsXARASpQ4Xc2lEyTC/Hdnpvu/ydi9fa/8kS6pyXa5B6AkErpr+ZcB9u5sFdo574DNY+svFIDzA5rl0282zx66udAkirKhCgFGMBLyAoJUGu1XM54J0Z/X2F+/gCisA/DK7FAuW3chhgvQVu3OY96wTmoHUEsIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PWXmvWEQ; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PWXmvWEQ"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3ddd03db21cso19202355ab.1
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968351; x=1751573151; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bfd4g4oyzgO9BbMd8TfR5LoagbwDLdjqmGt8yskowpw=;
        b=PWXmvWEQeP7nA9yWB2/R0nUp7F3VViRtShm7hgG4RQ94D+NCM80BgxPe5osOBwLm/j
         VVLGsN3K1NdDe61Fu0SB2jg1lebDydPKLAxeehgziDfAYqbvUbkxrC9HFsg5LfpPn1MK
         FkVsTuHLPoZE3g3Oi6FPchipUK6UD0lv9pHpxNhDEQ4N8eFe+8JjYm1bB08dTvOn+jAm
         mzKTXfyCOpsREPu108p97FAwmFe7vzqYO05rFjGAj+jct43Sjn1Oc+8A26OZGyq1QUk6
         y3r+TmzW9HODqPwoyH/u0tLMytOHwPg0AvEEv07biRZPmZjtyqng7gr2XpxeBVzNWb9P
         hDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968351; x=1751573151;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bfd4g4oyzgO9BbMd8TfR5LoagbwDLdjqmGt8yskowpw=;
        b=YVI41e3jtCU9fcHVqZvJyydINcwZEZWY8BNLuLF2sGVaSVKRVk+NUP/B3dujwqTWEf
         Av/HIcihtazlZHkBId66P0cZ1C7h7eZ0Fexqqc0njMRNYSui5kx+l9gMCV5c8S+WNlB2
         W6YZIYj0xkff5Cy2Cv29t41k++DnfUz7JI48G93RgaySKt9ZaRiRi5pxHjgQcKJRkaVf
         97t4tUJ62t+pcQo0Bxwyz9/z6XxXRxeOs7krfE8SR11qH8JiFX/UmXC5Z1EYM/aYmwGc
         ZVfV7dpZoIqkhe2INOn5VZ6YtWrrIRh3Sm/19mNC0RX5iQu7ozywcKxJmqoo9jUPePcK
         UYpA==
X-Forwarded-Encrypted: i=1; AJvYcCWpj+8CN/nRIkEuHnN39+Nnc7HInnL70lIoupxKWcAS9fJ/BrO2CuJ/nY6Z2gI48V7ZD6CWcYs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8uChEZmvyUD7o1wSLr5HP7MCi6pQiSayF3luaIu7/rnUCIimS
	Erev5GG4Mjn1FAqNXOfakShrfcFHnreE+Fz2piizz4TLzWr1F+sGBMcbMEC56fgmJXHru+X4KPr
	kEIkcAHm4qjkkxjLTaknBhr1sBg==
X-Google-Smtp-Source: AGHT+IG6G2rFRPWkpOW41Pi9fBc/Fkgk+vgjVkKLSP9f2QAlLB5ktW9y9VyZ03BDZAOiaFnbG271ZNfhQM9Y4i+b9Q==
X-Received: from ilbed13.prod.google.com ([2002:a05:6e02:480d:b0:3dd:a3df:9d57])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:174f:b0:3dd:c04e:49af with SMTP id e9e14a558f8ab-3df4ab4eec8mr12720745ab.3.1750968351198;
 Thu, 26 Jun 2025 13:05:51 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:36 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-1-coltonlewis@google.com>
Subject: [PATCH v3 00/22] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This series creates a new PMU scheme on ARM, a partitioned PMU that
allows reserving a subset of counters for more direct guest access,
significantly reducing overhead. More details, including performance
benchmarks, can be read in the v1 cover letter linked below.

v3:

* Return to using one kernel command line parameter for reserved host
  counters, but set the default value meaning no partitioning to -1 so
  0 isn't ambiguous. Adjust checks for partitioning accordingly.

* Move the function kvm_pmu_partition_supported() back out of the
  driver to avoid subbing has_vhe in 32-bit ARM code.

* Fix the kernel test robot build failures, one with KVM and no PMU,
  and one with PMU and no KVM.

* Scan entire series to remove vestigial changes and update comments.

v2:
https://lore.kernel.org/kvm/20250620221326.1261128-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20250602192702.2125115-1-coltonlewis@google.com/

Colton Lewis (21):
  arm64: cpufeature: Add cpucap for HPMN0
  arm64: Generate sign macro for sysreg Enums
  KVM: arm64: Define PMI{CNTR,FILTR}_EL0 as undef_access
  KVM: arm64: Reorganize PMU functions
  perf: arm_pmuv3: Introduce method to partition the PMU
  perf: arm_pmuv3: Generalize counter bitmasks
  perf: arm_pmuv3: Keep out of guest counter partition
  KVM: arm64: Correct kvm_arm_pmu_get_max_counters()
  KVM: arm64: Set up FGT for Partitioned PMU
  KVM: arm64: Writethrough trapped PMEVTYPER register
  KVM: arm64: Use physical PMSELR for PMXEVTYPER if partitioned
  KVM: arm64: Writethrough trapped PMOVS register
  KVM: arm64: Write fast path PMU register handlers
  KVM: arm64: Setup MDCR_EL2 to handle a partitioned PMU
  KVM: arm64: Account for partitioning in PMCR_EL0 access
  KVM: arm64: Context swap Partitioned PMU guest registers
  KVM: arm64: Enforce PMU event filter at vcpu_load()
  perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters
  KVM: arm64: Inject recorded guest interrupts
  KVM: arm64: Add ioctl to partition the PMU when supported
  KVM: arm64: selftests: Add test case for partitioned PMU

Marc Zyngier (1):
  KVM: arm64: Cleanup PMU includes

 Documentation/virt/kvm/api.rst                |  21 +
 arch/arm/include/asm/arm_pmuv3.h              |  38 +
 arch/arm64/include/asm/arm_pmuv3.h            |  61 +-
 arch/arm64/include/asm/kvm_host.h             |  18 +-
 arch/arm64/include/asm/kvm_pmu.h              | 100 +++
 arch/arm64/kernel/cpufeature.c                |   8 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |  22 +
 arch/arm64/kvm/debug.c                        |  24 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 233 ++++++
 arch/arm64/kvm/pmu-emul.c                     | 674 +----------------
 arch/arm64/kvm/pmu-part.c                     | 378 ++++++++++
 arch/arm64/kvm/pmu.c                          | 702 ++++++++++++++++++
 arch/arm64/kvm/sys_regs.c                     |  79 +-
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/gen-sysreg.awk               |   1 +
 arch/arm64/tools/sysreg                       |   6 +-
 drivers/perf/arm_pmuv3.c                      | 123 ++-
 include/linux/perf/arm_pmu.h                  |   6 +
 include/linux/perf/arm_pmuv3.h                |  14 +-
 include/uapi/linux/kvm.h                      |   4 +
 tools/include/uapi/linux/kvm.h                |   2 +
 .../selftests/kvm/arm64/vpmu_counter_access.c |  62 +-
 virt/kvm/kvm_main.c                           |   1 +
 24 files changed, 1828 insertions(+), 752 deletions(-)
 create mode 100644 arch/arm64/kvm/pmu-part.c


base-commit: 79150772457f4d45e38b842d786240c36bb1f97f
--
2.50.0.727.gbf7dc18ff4-goog
