Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04F41AD9ED;
	Wed, 31 Jul 2024 16:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722444698; cv=none; b=mJT2H2Uz+qcP8rirK2JqkMCXOv0AvajFalWL3iYQeJmfwFT8XtyKfkXdcebnYRV2EMVTmUCz1C+c1OS0z0hA1Vk0AxJY0yBCqfuhDOHYwEph3mjJvbE62nIHpCPcRHtYa09YLHxZlfVHq6/74M46zO1lpa+PqIDniE8BwgayGUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722444698; c=relaxed/simple;
	bh=a3N1jdJkjGQcJ3ZzY05M9xZbajIj8LwGdUK1HF2vmvM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=SPPpyZIWc0D7PiKE7LDHoRvgHvEe4D7B3njNT/lLCHlHbRoKuu/6flgO8DFP43Q+VEAuZXRr7IEhyPEG8H2U/L7Ari8HC4lc+eOp4/oWnqnB0uAdG0zno01Y+zQKDmNrxjwljGqNa7AK99aPyzWWchN/72hCNmmZU6vWJ77Oa7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAeVyuNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAeVyuNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84E4C116B1;
	Wed, 31 Jul 2024 16:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722444698;
	bh=a3N1jdJkjGQcJ3ZzY05M9xZbajIj8LwGdUK1HF2vmvM=;
	h=From:Subject:Date:To:Cc:From;
	b=iAeVyuNoztqPUGoDanPeAcyu7Ve54IKxX4KN/dntZHo3z5MbsuDnY8Ju3bdLl2tQz
	 JpvpSsPEZn4MadFMaSGCS7lNbZz54aIrH0bpoMDI98ADKC6RCSnvemigwpRxj15Pbq
	 R7fPltHSBJvjig4qvhwRyma6fys1jAJGzRbW9wC5R1VVSeFG5qcwhT1Y+dexn5K8It
	 kGIE2fuvcsi/IuQSQt3yxUPpGVy/N+QFAnODhdCIIzlswW/wRR2FtNlEnBdervg07u
	 fovGFErtcmLgC1cRHwmcXILoqEUw7mgLP3mNfTlOAZO9tf/x7pUuQXn/bL7MazzYkD
	 oTbP6nQRfCMHA==
From: "Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH v3 0/7] arm64: Add support for Armv9.4 PMU fixed
 instruction counter
Date: Wed, 31 Jul 2024 10:51:17 -0600
Message-Id: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIVrqmYC/33NSw6CMBCA4auQrh1T2kLBlfcwLqAPaJRCpthoC
 He3sNLEuPwnM98sJBh0JpBTthA00QU3+hT8kBHVN74z4HRqwigTtKQSGhxgGh7AoQan/IxABZe
 F1prSipF0N6Gx7rmbl2vq3oV5xNf+Iubb9J8Wc6CgZKuZVsZa3p5vBr25H0fsyMZF9kGw8hfBN
 qKWlWiFTUvFF7Gu6xvBKQEc9gAAAA==
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, James Clark <james.clark@linaro.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

This series adds support for the optional fixed instruction counter 
added in Armv9.4 PMU. Most of the series is a refactoring to remove the 
index to counter number conversion which dates back to the Armv7 PMU 
driver. Removing it is necessary in order to support more than 32 
counters without a bunch of conditional code further complicating the 
conversion.

Patch 1 changes struct arm_pmu.num_events to a bitmap of events, and 
updates all the users. This removes the index to counter conversion 
on the PMUv3 and Armv7 drivers.

Patch 2 updates various register accessors to use 64-bit values matching 
the register size.

Patches 3-4 update KVM PMU register accesses to use shared accessors 
from asm/arm_pmuv3.h.

Patches 5-6 rework KVM and perf PMU defines for counter indexes and 
number of counters.

Patch 7 finally adds support for the fixed instruction counter.

I tested this on FVP with VHE host and a guest. Also ran kvm-unittests 
in Arm's kernelCI.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
Changes in v3:
- Fix using 64-bit counters in pre-Armv8.5. The chained event check 
  for cycle counter in armv8pmu_event_is_chained() was returning the 
  cycle counter needed chaining which is never true. Separate fix is 
  here: https://lore.kernel.org/all/20240710182357.3701635-1-robh@kernel.org/
- Rebase to v6.11-rc1 and dropped already applied patches
- Link to v2: https://lore.kernel.org/r/20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org

Changes in v2:
- Include threshold fix patches and account for threshold support in 
  counter assignment.
- Add patch including asm/arm_pmuv3.h from linux/perf/arm_pmuv3.h
- Fix compile error for Apple PMU
- Minor review comments detailed in individual patches
- Link to v1: https://lore.kernel.org/r/20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org

---
Rob Herring (Arm) (7):
      perf: arm_pmu: Remove event index to counter remapping
      perf: arm_pmuv3: Prepare for more than 32 counters
      KVM: arm64: pmu: Use arm_pmuv3.h register accessors
      KVM: arm64: pmu: Use generated define for PMSELR_EL0.SEL access
      arm64: perf/kvm: Use a common PMU cycle counter define
      KVM: arm64: Refine PMU defines for number of counters
      perf: arm_pmuv3: Add support for Armv9.4 PMU instruction counter

 arch/arm/include/asm/arm_pmuv3.h   |  20 ++++++
 arch/arm64/include/asm/arm_pmuv3.h |  53 ++++++++++++--
 arch/arm64/include/asm/kvm_host.h  |   8 +--
 arch/arm64/include/asm/sysreg.h    |   1 -
 arch/arm64/kvm/pmu-emul.c          |  14 ++--
 arch/arm64/kvm/pmu.c               |  87 ++++++-----------------
 arch/arm64/kvm/sys_regs.c          |  11 +--
 arch/arm64/tools/sysreg            |  30 ++++++++
 drivers/perf/apple_m1_cpu_pmu.c    |   4 +-
 drivers/perf/arm_pmu.c             |  11 +--
 drivers/perf/arm_pmuv3.c           | 140 +++++++++++++++++++------------------
 drivers/perf/arm_v6_pmu.c          |   6 +-
 drivers/perf/arm_v7_pmu.c          |  77 ++++++++------------
 drivers/perf/arm_xscale_pmu.c      |  12 ++--
 include/kvm/arm_pmu.h              |   8 +--
 include/linux/perf/arm_pmu.h       |  10 ++-
 include/linux/perf/arm_pmuv3.h     |   9 ++-
 17 files changed, 272 insertions(+), 229 deletions(-)
---
base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
change-id: 20240607-arm-pmu-3-9-icntr-04375ddd0082

Best regards,
-- 
Rob Herring (Arm) <robh@kernel.org>

