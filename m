Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B3C168483;
	Wed, 26 Jun 2024 22:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441157; cv=none; b=dFNoZyGdyW0wS/2J5frnJ9ZSgtcYdSyqB1mYnus17lF4J0zDm04VUP9k9tPA7X6TFoBjyqgyw/kq8z9++TK+Y48fsw6serfS/FQIKcUcR96C5tu1Vb6Cs/S1lm+qbgYZrQTSUln/SZfFNzN3H7WgXD4ItcIbwcHlBkNiNvh9iq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441157; c=relaxed/simple;
	bh=kk9N8S/9pjJldXV6CMVRpAD3Z0nGrY99ofJV3fvXtDg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=klwskcUDOMgYLdXm1Zm9fVSHd1HgThvF1lHqUa+pHK0FZB2ojfAswwaN3f/El9ktZMxBAV/8ULPpZIRLH3Npc48t2hUANQmUOxF3YmFSCsa96dyoza5liRoHbm6SrwLBl8nPOmAe/Xm0EbqkscwYdtlvHfjQ3d0Yk7Tes2KsrfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LenWavY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LenWavY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10BFC116B1;
	Wed, 26 Jun 2024 22:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719441157;
	bh=kk9N8S/9pjJldXV6CMVRpAD3Z0nGrY99ofJV3fvXtDg=;
	h=From:Subject:Date:To:Cc:From;
	b=LenWavY3RR1u7fsla77j3LoWys7mobMCJ868xPwsHHjVhhrGa2zkR8FfKufAQNyKW
	 8Halrva5mTGE0v3uBo3PXs0ytVoM3tJaJ9nzH07p+MGQUuHminXLoJ3nMecRe9P1tq
	 Z5RQ6jskfaq08g133uVl2FlVocD8raPacTpI3CZR5AfoA7i61foKrpSGRVE2SswBnf
	 ltRutt1pcygewz0dduJXRGFRj8ZyZhH8gnGnbnU/L7+X3/qO5C2Xl1NAU6YxJjz7Om
	 w2TuGRS556hg2TtDOLNRj4+3oEssYXiSDCBT9Zz1X8jx3DtZvoLYfFfD3tnJUrocot
	 /ag5Jm/ExjRFA==
From: "Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH v2 00/12] arm64: Add support for Armv9.4 PMU fixed
 instruction counter
Date: Wed, 26 Jun 2024 16:32:24 -0600
Message-Id: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPiWfGYC/32NQQ6CQAxFr0K6tqYMKMrKexgWMFOgUQbSQaIh3
 N2RA7h8L/nvrxBYhQOUyQrKiwQZfQRzSMD2te8YxUUGQyanMxVY64DT8MIMryjWz4qUZ8XJOUd
 0MRB3k3Ir7715ryL3EuZRP/vFkv7sv9qSIqEtGmec5bbNmtuD1fPzOGoH1bZtX5matbyzAAAA
To: Russell King <linux@armlinux.org.uk>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 James Clark <james.clark@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14-dev

This series adds support for the optional fixed instruction counter 
added in Armv9.4 PMU. Most of the series is a refactoring to remove the 
index to counter number conversion which dates back to the Armv7 PMU 
driver. Removing it is necessary in order to support more than 32 
counters without a bunch of conditional code further complicating the 
conversion.

Patches 1-2 are a fix and cleanup for the threshold support. Patch 1 is 
a dependency of patch 12.

Patches 3-4 move the 32-bit Arm PMU drivers into drivers/perf/ and drop 
non-DT probe support. These can be taken first if there's no comments on 
them.

Patch 5 is new to v2 and implements the common pattern of the linux/ 
header including the asm/ header of the same name.

Patch 6 changes struct arm_pmu.num_events to a bitmap of events, and 
updates all the users. This removes the index to counter conversion 
on the PMUv3 and Armv7 drivers.

Patch 7 updates various register accessors to use 64-bit values matching 
the register size.

Patches 8-9 update KVM PMU register accesses to use shared accessors 
from asm/arm_pmuv3.h.

Patches 10-11 rework KVM and perf PMU defines for counter indexes and 
number of counters.

Patch 12 finally adds support for the fixed instruction counter.

I tested this on FVP with VHE host and a guest. I tested the Armv7 PMU 
changes with QEMU.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
Changes in v2:
- Include threshold fix patches and account for threshold support in 
  counter assignment.
- Add patch including asm/arm_pmuv3.h from linux/perf/arm_pmuv3.h
- Fix compile error for Apple PMU
- Minor review comments detailed in individual patches
- Link to v1: https://lore.kernel.org/r/20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org

---
Rob Herring (Arm) (12):
      perf: arm_pmuv3: Avoid assigning fixed cycle counter with threshold
      perf: arm_pmuv3: Drop unnecessary IS_ENABLED(CONFIG_ARM64) check
      perf/arm: Move 32-bit PMU drivers to drivers/perf/
      perf: arm_v6/7_pmu: Drop non-DT probe support
      perf: arm_pmuv3: Include asm/arm_pmuv3.h from linux/perf/arm_pmuv3.h
      perf: arm_pmu: Remove event index to counter remapping
      perf: arm_pmuv3: Prepare for more than 32 counters
      KVM: arm64: pmu: Use arm_pmuv3.h register accessors
      KVM: arm64: pmu: Use generated define for PMSELR_EL0.SEL access
      arm64: perf/kvm: Use a common PMU cycle counter define
      KVM: arm64: Refine PMU defines for number of counters
      perf: arm_pmuv3: Add support for Armv9.4 PMU instruction counter

 arch/arm/include/asm/arm_pmuv3.h                   |  20 +++
 arch/arm/kernel/Makefile                           |   2 -
 arch/arm64/include/asm/arm_pmuv3.h                 |  55 +++++++-
 arch/arm64/include/asm/kvm_host.h                  |   8 +-
 arch/arm64/include/asm/sysreg.h                    |   1 -
 arch/arm64/kvm/pmu-emul.c                          |  15 +-
 arch/arm64/kvm/pmu.c                               |  87 +++---------
 arch/arm64/kvm/sys_regs.c                          |  11 +-
 arch/arm64/tools/sysreg                            |  30 ++++
 drivers/perf/Kconfig                               |  12 ++
 drivers/perf/Makefile                              |   3 +
 drivers/perf/apple_m1_cpu_pmu.c                    |   4 +-
 drivers/perf/arm_pmu.c                             |  11 +-
 drivers/perf/arm_pmuv3.c                           | 154 +++++++++++----------
 .../perf_event_v6.c => drivers/perf/arm_v6_pmu.c   |  26 +---
 .../perf_event_v7.c => drivers/perf/arm_v7_pmu.c   |  90 ++++--------
 .../perf/arm_xscale_pmu.c                          |  15 +-
 include/kvm/arm_pmu.h                              |   8 +-
 include/linux/perf/arm_pmu.h                       |  10 +-
 include/linux/perf/arm_pmuv3.h                     |  11 +-
 20 files changed, 301 insertions(+), 272 deletions(-)
---
base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
change-id: 20240607-arm-pmu-3-9-icntr-04375ddd0082

Best regards,
-- 
Rob Herring (Arm) <robh@kernel.org>

