Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214FF19413C
	for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 10:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732701705; cv=none; b=nvjv0XhgmYj+S3p++QRUtu68yGKlmvj1u0B0onx98mbb1fRQ+z82DMi6+lU3iPVCznx3mra6qebc0eH8dQgTJhvi6n7uF8PnBr3uo62snGnurJRxq8plMMDmScjY0DLyFqleHpEPXQnbWjlCEfOVXQCMR4qHpyTz39cTjppgeOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732701705; c=relaxed/simple;
	bh=5kbFjSUy0XaruEKOu7IuGc7uGCmHmG7X+LL/98xQ7pQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p5eTxsRphpP32qH2Q+SGbl3ky0D9/QY6GPc9JfzzICLewTz0A+he7pX5BNvfqgj1KJR2Uu2UKYOy63XiPJPEgkPh1ADFo1ispFlqYJSb2CbryYksPUOadeKdOZPaOmm+HN2unpL7q09GlrMZjrzWrYXXaaVleEeuUM5bZSTaHug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o5o0l/Ok; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o5o0l/Ok"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53df30a5ff2so74802e87.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 02:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732701701; x=1733306501; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g9PJ9Gush9lm7lbb9dy1lav0vrsKv/73ERSUCMwZKDE=;
        b=o5o0l/Okp+sKXUm1IF/j49W3MBx/LF4pxL25JXaIo2wAO1A7Be929RCkm+doJSY0G0
         rdGl5B3qTPJdqXoOliF4tV5s5lu4vwg4BB5AfQnxbCvTU4sgc9omPI00PSyr8R1H/jlY
         KD7CnCJ7Owkk6DTu/7vaMZ1DuMSb5Xxy8mfT7pz1iO2U3MiNTkGYkI+Yj+16l1R0NGfV
         S8OPiRl5hFwj5iOQ8J94KOhhvgRkqpPtldioU0O8eTZ2/BM2sCyN/ixwF5ogRdu+RvRq
         GR7beiT2HeFXJKEUuuy+4oSWQ9Be+M2Jh3UBY6EkerxSxvKpsvyWo6tCd3hEWjHtTA54
         1yxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732701701; x=1733306501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g9PJ9Gush9lm7lbb9dy1lav0vrsKv/73ERSUCMwZKDE=;
        b=WqIeWre5TyMlAZFPm6yKnKcIhF80o301Qx3YEOBBJSaetvUUI/CnC/WtGPU59/Fwfh
         HibtR7BUjPxyRHdBrOpjEuSQg41R6U4+9p4SZfxzYEuJnTeLZ60mF0sNEjfVwNQMPi9o
         5DaAoLJkn+k81P265vOeUM9Zuqdgcq8vwS0MeZnJlaztZ6f64LSl5IIvDZQ8S4ZnBVv1
         1lVJML4NkfU7PzZXcT0gfZXIgbOJWKaLwi+my0cbofpupjzIjBBzICRX4kmIAbjlJRnh
         WQ92kfaWbnxD1BfOvGF7WwIGjLXl5HYx+l2h40yA3eX92vjngRDY8mYqn4od/P+Wfv4W
         zw/A==
X-Forwarded-Encrypted: i=1; AJvYcCXZgjO2PqKA9RPF95B15YUW1FfGdBweBHykJ20P8nTpedIdkgvM21JJuuxkeGoFWPPhjOkT4/c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEfx9ZXNjxJURbg8Gon0U1LGLNA0FLIRteR2PAVpZcuSQV6DuU
	JgObPfenIx74TR7fc73X7hlN/StgVsZChAe33BgvccWumsISPZjHu5ayQ1xqoEE=
X-Gm-Gg: ASbGnct478ZHTPC5K08/ZvtC2AozgGAjP1YxS3rW+fNgwDxd/2VHTrMCXwE/zrnymHB
	8/CuhGX/j3rBAODZEE4GE+bbzaPyXhAC0iOcyZU3QBK7SpWRMWLv/l3SVd1/bNXUTtkb/QMv/s7
	Pk4S36C6ddTlyIEbCqRhnbksUwPlZMl0CYaYBjXJNZuEuATACsEBapt11QV0qgEFoGoWuP28xGz
	C2FNseFOVksjhApRbqxXMvtcMNAEA3JB9MDn/1XHBnT4MeiRg==
X-Google-Smtp-Source: AGHT+IF2h6Ec+GYiEgi4O/av/bXoRXCF5EjeitDXO3KJ0icB0ZNqf2E5Uu6kmK0JggmmIEskxuF8ZA==
X-Received: by 2002:a05:6512:1283:b0:53d:d246:5aca with SMTP id 2adb3069b0e04-53df00d1080mr1987003e87.24.1732701701202;
        Wed, 27 Nov 2024 02:01:41 -0800 (PST)
Received: from pop-os.. ([145.224.90.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa547ffb152sm421887466b.62.2024.11.27.02.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 02:01:40 -0800 (PST)
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
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 0/8] kvm/coresight: Support exclude guest and exclude host
Date: Wed, 27 Nov 2024 10:01:17 +0000
Message-Id: <20241127100130.1162639-1-james.clark@linaro.org>
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

Applies to kvmarm/next (60ad25e14a) but includes two commits from Oliver
for a conflicting change to move TRBE and SPE flags to host data [7].

---

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

James Clark (6):
  arm64/sysreg: Add a comment that the sysreg file should be sorted
  tools: arm64: Update sysreg.h header files
  arm64/sysreg/tools: Move TRFCR definitions to sysreg
  KVM: arm64: coresight: Give TRBE enabled state to KVM
  KVM: arm64: Support trace filtering for guests
  coresight: Pass guest TRFCR value to KVM

Oliver Upton (2):
  KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
  KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of
    vCPU

 arch/arm64/include/asm/kvm_asm.h              |   5 +-
 arch/arm64/include/asm/kvm_host.h             |  39 +-
 arch/arm64/include/asm/sysreg.h               |  12 -
 arch/arm64/kvm/arm.c                          |   5 +-
 arch/arm64/kvm/debug.c                        |  92 ++--
 arch/arm64/kvm/hyp/nvhe/debug-sr.c            |  61 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   6 -
 arch/arm64/kvm/hyp/vhe/debug-sr.c             |   5 -
 arch/arm64/tools/sysreg                       |  38 ++
 .../coresight/coresight-etm4x-core.c          |  43 +-
 drivers/hwtracing/coresight/coresight-etm4x.h |   2 +-
 drivers/hwtracing/coresight/coresight-priv.h  |   3 +
 drivers/hwtracing/coresight/coresight-trbe.c  |   5 +
 tools/arch/arm64/include/asm/sysreg.h         | 410 +++++++++++++++++-
 tools/include/linux/kasan-tags.h              |  15 +
 15 files changed, 609 insertions(+), 132 deletions(-)
 create mode 100644 tools/include/linux/kasan-tags.h

-- 
2.34.1

