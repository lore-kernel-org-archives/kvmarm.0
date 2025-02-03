Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFDD153801
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 18:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738607495; cv=none; b=odRKikYbe6GEs9rXYXU3JK70Ybifje0fhA1rRzB/sjeRYndX792iB4gjkrdt1uJDUD0C6O+M1yOvGSebGLyQ4Aao6O4NhKDhz+LI6b/ndeIEPeHW//azsmAhhX4JmnDbDE7fN+9mGLrbJCcBk7lDPyIvBpd8Wm/wK51jz1ujzmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738607495; c=relaxed/simple;
	bh=daQJ6ETea9n+180bdivfIYERdbzsdAAUTyKsDfzUO7M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SUs+BWbaYoR82IY1ZetMVShGfKMGhfaWvFLclxgypuFRdddf/ojKKz7VnfodgBrgB9JbTPzAHgp6K+k4ZoBe+sqg18pbeMMldgY9cB93UK8wfpLQoqRXKRcEz7yrsDGEZMpgwFg4hbFsAZKJnZCfPEs1+FjjmIueySuE32CTr8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cpiXL2f4; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cpiXL2f4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738607485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Lr+rZhocEfUS/HlkswYK6NQV1238xdUU8Vazl6Hbx30=;
	b=cpiXL2f4KtwMVnA7stRER6DK6i3BBVQAyKwD1vt5GTdAE5/900luZqfrht1i0+ullMnY28
	VsENVFpmpbnqfNIN3fWbQlJ0zi3eoWC+8CNDF0H/+K3D5rTUzgjNW8QHqy1qMYLyq4x6b1
	Glr9zwxLZbuko6CCzc1KheZk0Ud/KvU=
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
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 00/14] KVM: arm64: Support FEAT_PMUv3 on Apple hardware
Date: Mon,  3 Feb 2025 10:30:57 -0800
Message-Id: <20250203183111.191519-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series adds support for PMUv3 emulation on Apple hardware. See the
v1 cover letter for a more detailed explanation.

Tested on an M2 Pro Mac Mini w/ Debian + Windows guests. Also tested
using kvm-unit-tests, with a small test fix [*].

[*]: https://lore.kernel.org/kvmarm/20250203181026.159721-1-oliver.upton@linux.dev/

v1: https://lore.kernel.org/kvmarm/20241217212048.3709204-1-oliver.upton@linux.dev/

v1 -> v2:
 - Rebase to 6.14-rc1
 - Fix CONFIG_GUEST_PERF_EVENTS=n compilation error
 - Enroll M1 parts for PMUv3 emulation (Janne)
 - Collect Janne's Tested-by

Oliver Upton (14):
  drivers/perf: apple_m1: Refactor event select/filter configuration
  drivers/perf: apple_m1: Support host/guest event filtering
  drivers/perf: apple_m1: Provide helper for mapping PMUv3 events
  KVM: arm64: Compute PMCEID from arm_pmu's event bitmaps
  KVM: arm64: Always support SW_INCR PMU event
  KVM: arm64: Remap PMUv3 events onto hardware
  KVM: arm64: Use a cpucap to determine if system supports FEAT_PMUv3
  KVM: arm64: Drop kvm_arm_pmu_available static key
  KVM: arm64: Use guard() to cleanup usage of arm_pmus_lock
  KVM: arm64: Move PMUVer filtering into KVM code
  KVM: arm64: Compute synthetic sysreg ESR for Apple PMUv3 traps
  KVM: arm64: Advertise PMUv3 if IMPDEF traps are present
  KVM: arm64: Provide 1 event counter on IMPDEF hardware
  arm64: Enable IMP DEF PMUv3 traps on Apple M*

 arch/arm64/include/asm/apple_m1_pmu.h   |   1 +
 arch/arm64/include/asm/cpufeature.h     |  28 +-----
 arch/arm64/kernel/cpu_errata.c          |  44 ++++++++
 arch/arm64/kernel/cpufeature.c          |  19 ++++
 arch/arm64/kernel/image-vars.h          |   5 -
 arch/arm64/kvm/arm.c                    |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |   4 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  22 ++++
 arch/arm64/kvm/pmu-emul.c               | 127 +++++++++++++++++-------
 arch/arm64/kvm/pmu.c                    |  10 +-
 arch/arm64/tools/cpucaps                |   2 +
 drivers/perf/apple_m1_cpu_pmu.c         | 101 +++++++++++++++----
 include/kvm/arm_pmu.h                   |  12 +--
 include/linux/perf/arm_pmu.h            |   1 +
 14 files changed, 276 insertions(+), 104 deletions(-)


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.39.5

