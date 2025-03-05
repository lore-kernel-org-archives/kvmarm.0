Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA2C25485B
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 20:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206417; cv=none; b=Wldn+WFWbcIBaIq5D9wtTiqS/Qj4cEA9GH8F6fIj9EZRvDETdfTxGBk+6s/eAaRH0HTyD+cUtF2Nh0JFMsT0l7eFp5D0fKykhqYM6X+oI4ZaPF8oilF0K4i4mLEAddzZiTzaU8M7WrKI1KCsWjSxrJKIGZ++1y7ET8EnCXuTlnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206417; c=relaxed/simple;
	bh=d6Rr6XQlxAVZ+mE6RfpK/xi1nsseOYVsqwUcmX//sH0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tOkIMynyC4mfH4Cmkht9hX0nVLzvdUf/4ZKhwNjJpyLSfc+KMr2Z9bhrJMAwSOkQh/yJRbhRAs4isD/KlksA03RJoX18MfYD/UOAoRJCF7XsuVRjAx23vwQF0BlAPcYeMJnl/aefKdqE10Iqyjs+y9lUgO+sNENe05IG9whj80Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PbKbEfsq; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PbKbEfsq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741206413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/RePMasBxWLOq6wL+myI83nPFWKCp36b5QRiMaqR5Jo=;
	b=PbKbEfsqG25jqb/39HbNK2rqZCcaXv8jbOTnrWTOo7yyt1Mew0xNFcRBUL/jiv2vgRu2EP
	ftTcCC0Sscpq52P3sOzgSOnnkwA875AAedBcNW2U9yzSWikcmV7ZMUJEi7xkZ7MC9uOZ9x
	BNNvhiCV1CmzyuhluPPJ1c80CbIZKf8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 00/14] KVM: arm64: FEAT_PMUv3 on Apple hardware
Date: Wed,  5 Mar 2025 12:26:27 -0800
Message-Id: <20250305202641.428114-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hopefully close to the last spin, this time addressing Marc's comments
on v2.

Full details found in the v1 cover letter.

v1: https://lore.kernel.org/kvmarm/20241217212048.3709204-1-oliver.upton@linux.dev/
v2: https://lore.kernel.org/kvmarm/20250203183111.191519-1-oliver.upton@linux.dev/

v2 -> v3:
 - Reorder and restructure patches to include map_pmuv3_event()
   definition w/ KVM usage.
 - Disallow events that lack a valid PMUv3 -> HW mapping
 - Various minor fixes/typos

Oliver Upton (14):
  drivers/perf: apple_m1: Refactor event select/filter configuration
  drivers/perf: apple_m1: Support host/guest event filtering
  KVM: arm64: Compute PMCEID from arm_pmu's event bitmaps
  KVM: arm64: Always support SW_INCR PMU event
  KVM: arm64: Use a cpucap to determine if system supports FEAT_PMUv3
  KVM: arm64: Drop kvm_arm_pmu_available static key
  KVM: arm64: Use guard() to cleanup usage of arm_pmus_lock
  KVM: arm64: Move PMUVer filtering into KVM code
  KVM: arm64: Compute synthetic sysreg ESR for Apple PMUv3 traps
  KVM: arm64: Advertise PMUv3 if IMPDEF traps are present
  KVM: arm64: Remap PMUv3 events onto hardware
  drivers/perf: apple_m1: Provide helper for mapping PMUv3 events
  KVM: arm64: Provide 1 event counter on IMPDEF hardware
  arm64: Enable IMP DEF PMUv3 traps on Apple M*

 arch/arm64/include/asm/apple_m1_pmu.h   |   1 +
 arch/arm64/include/asm/cpucaps.h        |   2 +
 arch/arm64/include/asm/cpufeature.h     |  28 +----
 arch/arm64/kernel/cpu_errata.c          |  44 ++++++++
 arch/arm64/kernel/cpufeature.c          |  28 +++++
 arch/arm64/kernel/image-vars.h          |   5 -
 arch/arm64/kvm/arm.c                    |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |   4 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  22 ++++
 arch/arm64/kvm/pmu-emul.c               | 138 +++++++++++++++++-------
 arch/arm64/kvm/pmu.c                    |  10 +-
 arch/arm64/tools/cpucaps                |   2 +
 drivers/perf/apple_m1_cpu_pmu.c         | 101 +++++++++++++----
 include/kvm/arm_pmu.h                   |  12 +--
 include/linux/perf/arm_pmu.h            |   4 +
 15 files changed, 301 insertions(+), 104 deletions(-)


base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
-- 
2.39.5

