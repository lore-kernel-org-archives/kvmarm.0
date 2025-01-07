Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29D580BFF
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249654; cv=none; b=Pgsrjk40SVdNriEU0Ud4r6U8a3epgoqQ5EqNzRCp5mOM56wO9X170av2mmxetUGQJz3y2zLcSlu8iflj5ax9Y4qMl4KvyeW6JhyOeBPoopktKRIVxkXqA7S2gmq9uUhv6a0xhI25B06twgMzehf3aj7erv2Cw/GFWcrYyWbx/M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249654; c=relaxed/simple;
	bh=BqBJvaOGlhTt0QNXY2X9hDEmBV0K3J79hXiflyajx+8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WI3ZvRX0vhF4PrJ3Jf/s3UTMsYWUBx2o9UZWe742XJiYd08U5WAW7Hys/R6hICn6N4FZslqigvvbClhH78s754JgfUc3m9y14Rv1Gnk+I5l72efSvhoZcnje986q7ez3DbMCSbfxvRDRnpJ2/qCHXD6UF8kK1hVACNeC/SeysI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XqZ3Vwd6; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XqZ3Vwd6"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-385d7b4da2bso13082394f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736249651; x=1736854451; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QjoW7nPeQ1gQB5Sat/OF0zaLoESe++zQXRiDsGpHPNI=;
        b=XqZ3Vwd6mWRReVP806c3LU830+mr5vxKHkbyz0AB7glDGU/yK79PUtXYYJ6omwOmtW
         RYd8+KXKZ2xdeSRs0oPpWzyL6YYY38xNgDliDMdq3yCYXKTlqEuCj9GSYM4eOF6yeCpl
         +9H2MIFSZbTUQTYxnt2EA04/7i9cl1lvO79RmyAfvnGTzaOvuSx5Az4RMd2PtstKY6QQ
         hzXxcctLTqg9RurAQFuRHwbbNsugmdF87WsrIqF/JGzQw51x+9lWOMlWEz5v7tp1Ho9W
         Y5BqvJ8Lo9lO1f055tzLogYftZsodr4xsfqI04GZ4v7AxaOSd6/yQ8ScVpZ9svj0tDnd
         Y/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249651; x=1736854451;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QjoW7nPeQ1gQB5Sat/OF0zaLoESe++zQXRiDsGpHPNI=;
        b=iZkGwbj0g9N0LXvK3oqQXL5KVlx/slTkgJlkJNj87h3a4tQmIfEKCt5yNovewzDOwo
         UbmV3KNY9/840YlSupfV6iWnih7g/orMgDv/6j42reYT7BtSXFPcprKtQlaS8HuRFCDY
         oVUeMhv0dphlI7A2MyxFWfM+HKJ37tenUeyNIcfsI0JRoTt2LsF6v0d5gG75Fz/zSxw2
         mCfjmoP2inwEOl5fhRxmABYXegmO0FSPdU1x5dS8BIx1r0eF6VbqZcSGWVNHftFJ7ZCi
         ifdG89d/xDGdAvY/0NbT3fngsTNKWX1rN8j2VW0xaFcj4XlhEFNr5fDwtvTpnkaRQrYU
         A95Q==
X-Forwarded-Encrypted: i=1; AJvYcCVD2OLdPZ90X2+lIW0mRuMcEZ8VH1ys8IQTlplFgLf8/yx/3feaIfeXkM6kEFDzKswih8XN3ns=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDI8HJ+MpzoX3P3r55KuWz28IHe7iPqByLXjjGv44zyZnHsqb4
	snE3SN/dzQSe/RK6j4O7WoCMz6klzJ00n8R7gzusoen7V5JkhnLRskXdJDywE2M=
X-Gm-Gg: ASbGncsoTxlYE6/6BHNEl0WS+BXDdaV3l5iyUhZZL8JljedFe0mzkVdsdDOV+fjS9iK
	XzJnqdDoLT2d1usxoLzBOxbzsyIkvdq3fGkPS16sfZmsuYL+Yo+HUlxcLqpJ3WPntckZQwt82OP
	8x09QoHQMTsG+eGJO1bAstJQWOou6HX0kTCMZytdKWWwx24dXbaruAD+DE4oiOlG7H43Vb/XtX2
	0vZdCvblITxT6x5nHklyJmpwHy6ZsrVe1FevpxVXAEPYPO0Kl5dc6jw
X-Google-Smtp-Source: AGHT+IHqyrD1eQ8+R2Eoh1fh2j5lDdKTDPWitWk/AFFrwGNk+j09vRhskZzie6luRndcH4/LPLs3Dg==
X-Received: by 2002:a5d:64c8:0:b0:386:43c9:3ac2 with SMTP id ffacd0b85a97d-38a221ea74cmr52928364f8f.15.1736249651001;
        Tue, 07 Jan 2025 03:34:11 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e1acsm50299218f8f.68.2025.01.07.03.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 03:34:10 -0800 (PST)
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
	"Rob Herring (Arm)" <robh@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 00/10] kvm/coresight: Support exclude guest and exclude host
Date: Tue,  7 Jan 2025 11:32:37 +0000
Message-Id: <20250107113252.260631-1-james.clark@linaro.org>
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

Applies to 6.13-rc6

---

Changes since V9 [9]:
  * Rebase onto 6.13-rc6 and pickup commit 38131c02a53f ("KVM: arm64:
    Track presence of SPE/TRBE in kvm_host_data instead of vCPU") to get
    host_data_set_flag(). Also requires two intertwined parent commits.

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
[9]: https://lore.kernel.org/linux-arm-kernel/20250106142446.628923-1-james.clark@linaro.org/

James Clark (7):
  arm64/sysreg: Add a comment that the sysreg file should be sorted
  tools: arm64: Update sysreg.h header files
  arm64/sysreg/tools: Move TRFCR definitions to sysreg
  coresight: trbe: Remove redundant disable call
  KVM: arm64: coresight: Give TRBE enabled state to KVM
  KVM: arm64: Support trace filtering for guests
  coresight: Pass guest TRFCR value to KVM

Oliver Upton (3):
  KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
  KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
  KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of
    vCPU

 arch/arm64/include/asm/kvm_asm.h              |   5 +-
 arch/arm64/include/asm/kvm_host.h             |  37 +-
 arch/arm64/include/asm/sysreg.h               |  12 -
 arch/arm64/kvm/arm.c                          |   5 +-
 arch/arm64/kvm/debug.c                        |  94 ++--
 arch/arm64/kvm/hyp/nvhe/debug-sr.c            |  72 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   6 -
 arch/arm64/kvm/hyp/vhe/debug-sr.c             |   5 -
 arch/arm64/tools/sysreg                       |  38 ++
 .../coresight/coresight-etm4x-core.c          |  49 ++-
 drivers/hwtracing/coresight/coresight-etm4x.h |   2 +-
 drivers/hwtracing/coresight/coresight-priv.h  |   3 +
 .../coresight/coresight-self-hosted-trace.h   |   9 -
 drivers/hwtracing/coresight/coresight-trbe.c  |  15 +-
 tools/arch/arm64/include/asm/sysreg.h         | 410 +++++++++++++++++-
 tools/include/linux/kasan-tags.h              |  15 +
 16 files changed, 626 insertions(+), 151 deletions(-)
 create mode 100644 tools/include/linux/kasan-tags.h

-- 
2.34.1

