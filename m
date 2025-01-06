Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB4138F9C
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 14:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736173500; cv=none; b=aCzsbvX3/augsDywPTq4j3cb2gjejmi4xLY8TwltbLsz8pti7mYY2QLFqVOY+himM5GDEH7ZDsFzTKkAGKgjPgpDU04O0IrFsxL0hbCw2wSOOHMWGWVllCR/i60SCKLGqTuNlDmPoLoSLoy+mM85KGrVFBBKkNf58WFxVUxnoQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736173500; c=relaxed/simple;
	bh=cNuHF0yfiGKrZX1jXPVe34A6zR8Uvch3yQ9oUlagvN8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qp25WyfCQwHyefNCKY0DAaj93AC4KXbPLD4KiUxQtVjUQpSXdGKttiqsNokT33gvEP2S77fW5qfvZ2DpTDE9cFoswFc/mfWEKnabNKlIAc9Zfjski1UPNcQQGIchjJF1hPA2NB3wXFRJia0UKNlHjmC2rUPGNt2VVI+GjPmfu/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yu0hJ9u9; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yu0hJ9u9"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3863703258fso9002512f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jan 2025 06:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736173496; x=1736778296; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NjhZg1PhxZESUuVf6EemJQRzcvFYBW2UtJGnBs1wxAA=;
        b=yu0hJ9u9qF/Tu0hKMRUxAkq+ri6E4OG8z08kEAAtj4z2+OUsl7YdvqX4G63Q1it9bj
         zAWHNr+heLdsDbCuIhosDgYw2sE3huVHAy+9avm4ewGZjWfdlEaVia47YQRubLKe18cc
         sTPPOsviuMobj5TfdPjJoeIPEJYVgvGt6ljvRB1HH4P6UPbhrO1RlwUtrXMI85GAHtI3
         JzvlKq3Y9kSQs19ItPqJWKeDqqShtnRlyohlGV3t/ztHc0tAWI6QxLcqIzy7/ffxJza8
         jAYxGcewnwc7yoKvzJGOfhcjSlKnAFVpcewAc8/ZjP+CTf19cleebtZFhx3ys9ZJK9hD
         K9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736173496; x=1736778296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NjhZg1PhxZESUuVf6EemJQRzcvFYBW2UtJGnBs1wxAA=;
        b=wuvpDZZD/oPTtjAUKbfaLtOfiS0wHYiUtt395NNnzu5h/HosJhdVtA6goczCjHHzSU
         oGelyF6lugwEEbXl4WqjHzHjjYQBX2sVnPVobKE/SOfKMOaFcJpVMfmZG+GWl3x9NdzW
         +NhvLAI9LFYylvcC45rpR31SmFNNxPJV+E6JTtX68+chXq207MeuGih8ExWGfbCOxr67
         Ms8dAt05UoLbFgfGZ4j5DaVaHG7IcUu1nS1gaQyMwfbA3bfCZTsQAcjZMiSyJ1m9RfSW
         aN86aUvgexNipE076Qa7xqtrYDV0czQIYknuI1aa8Zj42xcyDjj7qCDdXpie/Q7ZREtF
         IymQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUMF99mO6aaWKT5UCJWcVtkwZY9WND4P9DGmtzUHfrr7V1MF1xNLCZow1SIC2PMZtKuMLmi8Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZ9229h7vAxyaGQxkM56shRHbHiMYg6iFnKO7wubLqNBoZT7Oi
	GKy6VB5SbalbFSPrTDcCZNJ/QYcXEhInPK4U8xx/GPynL6eT3InA+IZ5lhmDBUg=
X-Gm-Gg: ASbGncsmdqAmccu2KT8BGa+47e8rCxPyUiXmEnOgvnlXId5WG3kV0jOwS+411DezfcJ
	MQS6ho7dzphfEcZ8BW4/i4J7fhBxIo1P9kkmgKqsPr+bF72Tw32u68vkyEiqfk2A+F3wvcoR2kw
	A6rTyR3PVd3lKYaHtzXQp3xjcKA2LlECa6pBQWKgx7RyqPQWBw+1ZfbNy2DpcbGU64c7NjO6rRM
	PUfU0USGEyV1Mv7s20zd9K1yByou8Fhx0af8MmqDZ5KIB/CV17TTSOq
X-Google-Smtp-Source: AGHT+IEh1Do/i1iABB/mNn5JaLC7AFOlndna+lHvNyNlHNlKy+PSWotPToba8F3QDc1zsrtaS+Kuzg==
X-Received: by 2002:adf:9bd8:0:b0:38a:4df5:a08 with SMTP id ffacd0b85a97d-38a4df50a1fmr20150696f8f.22.1736173496095;
        Mon, 06 Jan 2025 06:24:56 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4365d116d8fsm577295045e9.17.2025.01.06.06.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 06:24:55 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	coresight@lists.linaro.org
Cc: James Clark <james.clark@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	Mark Brown <broonie@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 0/7] kvm/coresight: Support exclude guest and exclude host
Date: Mon,  6 Jan 2025 14:24:35 +0000
Message-Id: <20250106142446.628923-1-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FEAT_TRF is a Coresight feature that allows trace capture to be
completely filtered at different exception levels, unlike the existing
TRCVICTLR controls which may still emit target addresses of branches,
even if the following trace is filtered.

Without FEAT_TRF, it was possible to start a trace session on a host and
also collect trace from the guest as TRCVICTLR was never programmed to
exclude guests (and it could still emit target addresses even if it
was).

With FEAT_TRF, the current behavior of trace in guests exists depends on
whether nVHE or VHE are being used. Both of the examples below are from
the host's point of view, as Coresight isn't accessible from guests.
This patchset is only relevant to when FEAT_TRF exists, otherwise there
is no change.

Current behavior:

  nVHE/pKVM:

  Because the host and the guest are both using TRFCR_EL1, trace will be
  generated in guests depending on the same filter rules the host is
  using. For example if the host is tracing userspace only, then guest
  userspace trace will also be collected.

  (This is further limited by whether TRBE is used because an issue
  with TRBE means that it's completely disabled in nVHE guests, but it's
  possible to have other tracing components.)

  VHE:

  With VHE, the host filters will be in TRFCR_EL2, but the filters in
  TRFCR_EL1 will be active when the guest is running. Because we don't
  write to TRFCR_EL1, guest trace will be completely disabled.

New behavior:

The guest filtering rules from the Perf session are now honored for both
nVHE and VHE modes. This is done by either writing to TRFCR_EL12 at the
start of the Perf session and doing nothing else further, or caching the
guest value and writing it at guest switch for nVHE. In pKVM, trace is
now be disabled for both protected and unprotected guests.

There is also an optimization where the Coresight drivers pass their
enabled state to KVM. This means in the common case KVM doesn't have to
touch any sysregs when the feature isn't in use.

Applies to kvmarm/next (00163be8bb59).

---

Changes since V8 [8]:
  * Rename guest_trfcr_el1 -> trfcr_while_in_guest
  * Rename GUEST_FILTER -> EL1_TRACING_CONFIGURED
  * Rename kvm_set_trfcr() -> kvm_tracing_set_el1_configuration()
  * #include ordering
  * Reorder Coresight driver to remove need for preempt_disable()
    to avoid the warning
  * Force EL1_TRACING_CONFIGURED on for pKVM which drops an additional
    special case but still disables trace
  * Change set/clear trfcr to a single function that disables swapping
    if it has the same value as the host
  * Make the drain condition a bit clearer with __trace_needs_drain()
    instead of host trfcr != 0 (Or checking individual E*TRE bits)
  * Drain is only really required on switch to guest so move it there
  * Only for pKVM, restore the original behavior for draining whenever
    trbe is enabled. This prevents hypothetical case where a host has
    the filters disabled but hasn't drained yet which we had by only
    looking at host trfcr != 0

Changes since V7 [6]:
  * Drop SPE changes
  * Change the interface to be based on intent, i.e kvm_enable_trbe()
    rather than passing the raw register value
  * Drop change to re-use vcpu_flags mechanism in favour of [7]
  * Simplify by using the same switch function to and from guest

Changes since V6 [5]:
  * Implement a better "do nothing" case where both the SPE and Coresight
    drivers give the enabled state to KVM, allowing some register
    reads to be dropped.
  * Move the state and feature flags out of the vCPU into the per-CPU
    host_debug_state.
  * Simplify the switch logic by adding a new flag HOST_STATE_SWAP_TRFCR
    and only storing a single TRFCR value.
  * Rename vcpu flag macros to a more generic kvm_flag...

Changes since V5 [4]:
  * Sort new sysreg entries by encoding
  * Add a comment about sorting arch/arm64/tools/sysreg
  * Warn on preemptible() before calling smp_processor_id()
  * Pickup tags
  * Change TRFCR_EL2 from SysregFields to Sysreg because it was only
    used once

Changes since V4 [3]:
  * Remove all V3 changes that made it work in pKVM and just disable
    trace there instead
  * Restore PMU host/hyp state sharing back to how it was
    (kvm_pmu_update_vcpu_events())
  * Simplify some of the duplication in the comments and function docs
  * Add a WARN_ON_ONCE() if kvm_etm_set_guest_trfcr() is called when
    the trace filtering feature doesn't exist.
  * Split sysreg change into a tools update followed by the new register
    addition

Changes since V3:
  * Create a new shared area to store the host state instead of copying
    it before each VCPU run
  * Drop commit that moved SPE and trace registers from host_debug_state
    into the kvm sysregs array because the guest values were never used
  * Document kvm_etm_set_guest_trfcr()
  * Guard kvm_etm_set_guest_trfcr() with a feature check
  * Drop Mark B and Suzuki's review tags on the sysreg patch because it
    turned out that broke the Perf build and needed some unconventional
    changes to fix it (as in: to update the tools copy of the headers in
    the same commit as the kernel changes)

Changes since V2:

  * Add a new iflag to signify presence of FEAT_TRF and keep the
    existing TRBE iflag. This fixes the issue where TRBLIMITR_EL1 was
    being accessed even if TRBE didn't exist
  * Reword a commit message

Changes since V1:

  * Squashed all the arm64/tools/sysreg changes into the first commit
  * Add a new commit to move SPE and TRBE regs into the kvm sysreg array
  * Add a comment above the TRFCR global that it's per host CPU rather
    than vcpu

Changes since nVHE RFC [1]:

 * Re-write just in terms of the register value to be written for the
   host and the guest. This removes some logic from the hyp code and
   a value of kvm_vcpu_arch:trfcr_el1 = 0 no longer means "don't
   restore".
 * Remove all the conditional compilation and new files.
 * Change the kvm_etm_update_vcpu_events macro to a function.
 * Re-use DEBUG_STATE_SAVE_TRFCR so iflags don't need to be expanded
   anymore.
 * Expand the cover letter.

Changes since VHE v3 [2]:

 * Use the same interface as nVHE mode so TRFCR_EL12 is now written by
   kvm.

[1]: https://lore.kernel.org/kvmarm/20230804101317.460697-1-james.clark@arm.com/
[2]: https://lore.kernel.org/kvmarm/20230905102117.2011094-1-james.clark@arm.com/
[3]: https://lore.kernel.org/linux-arm-kernel/20240104162714.1062610-1-james.clark@arm.com/
[4]: https://lore.kernel.org/all/20240220100924.2761706-1-james.clark@arm.com/
[5]: https://lore.kernel.org/linux-arm-kernel/20240226113044.228403-1-james.clark@arm.com/
[6]: https://lore.kernel.org/kvmarm/20241112103717.589952-1-james.clark@linaro.org/T/#t
[7]: https://lore.kernel.org/kvmarm/20241115224924.2132364-4-oliver.upton@linux.dev/
[8]: https://lore.kernel.org/linux-arm-kernel/20241127100130.1162639-1-james.clark@linaro.org/

James Clark (7):
  arm64/sysreg: Add a comment that the sysreg file should be sorted
  tools: arm64: Update sysreg.h header files
  arm64/sysreg/tools: Move TRFCR definitions to sysreg
  coresight: trbe: Remove redundant disable call
  KVM: arm64: coresight: Give TRBE enabled state to KVM
  KVM: arm64: Support trace filtering for guests
  coresight: Pass guest TRFCR value to KVM

 arch/arm64/include/asm/kvm_host.h             |  11 +
 arch/arm64/include/asm/sysreg.h               |  12 -
 arch/arm64/kvm/debug.c                        |  50 ++-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c            |  63 +--
 arch/arm64/tools/sysreg                       |  38 ++
 .../coresight/coresight-etm4x-core.c          |  49 ++-
 drivers/hwtracing/coresight/coresight-etm4x.h |   2 +-
 drivers/hwtracing/coresight/coresight-priv.h  |   3 +
 .../coresight/coresight-self-hosted-trace.h   |   9 -
 drivers/hwtracing/coresight/coresight-trbe.c  |  15 +-
 tools/arch/arm64/include/asm/sysreg.h         | 410 +++++++++++++++++-
 tools/include/linux/kasan-tags.h              |  15 +
 12 files changed, 599 insertions(+), 78 deletions(-)
 create mode 100644 tools/include/linux/kasan-tags.h

-- 
2.34.1

