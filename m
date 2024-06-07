Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B026819;
	Fri,  7 Jun 2024 20:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717792323; cv=none; b=KnsleeFEiVjW72vZHRFg3V2yiLkkpkSL4AAEP8PsB8FwC4zqSMtgDwKix7z8D/MCDcYa3jY1OjpdpYCj05yhpVH+pFsRBr16opqjdruiuK7saeL/4TkFui7BHUiexnN8DHOVG/xONoLsb7pRxgLQ2MptquHvUVytIX4/EXFcjM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717792323; c=relaxed/simple;
	bh=X4B1La1z1pxjkZPYe8MXZt4HnbUKOeGUnGDR7svXFnY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ZdONmihoFc7Q/Tt3kJNlhhG6UFLXwsK+a/naKSC9TALg1ipGNUL4dmrZOuklxptNsPdrlOxS6DNJsAK7E0rEtkosEO6hqa8ZFy+aXbWM2v/ROfGw7f89eN+Ak6oZS0T1/qPLAgTU5A0gCsOEgMguVFQuoUSCK7Q5UVQFWRTYeWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0S21Kci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0S21Kci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9ACFC2BBFC;
	Fri,  7 Jun 2024 20:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717792323;
	bh=X4B1La1z1pxjkZPYe8MXZt4HnbUKOeGUnGDR7svXFnY=;
	h=From:Subject:Date:To:Cc:From;
	b=i0S21KciwE9FHfuVZmGF6pWg2iaggajBlMr1gDX7jHhHbqi61mw6qJcRclL5w3U4K
	 tAiWVDL9hgNZ8/Wz9/M7BJq4rZimfXFUYF48bC33grP4XEjUeOf/E2VIEa4YjaP3Zi
	 gj7bVQE/F6uiqdYJ0MqatakrSQODbpxtMty4PPvaFh8CpGqvBC2DHuNK1NR4dSEQvc
	 ynm6cSIbdI72F3E3o7C4sO6eoFXPyKAda9GbbsMYc6NLdVCW3B0uO+PM8cqD4lnrXf
	 iTSqGMr9a8wNwaHCrb563J57HcqWeRTx5dGe2SdWOqZVh04HPnbDLlJxDgmgf1aW6h
	 gW4RfM6XmkDng==
From: "Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 0/9] arm64: Add support for Armv9.4 PMU fixed instruction
 counter
Date: Fri, 07 Jun 2024 14:31:25 -0600
Message-Id: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB1uY2YC/x3MPQqAMAxA4atIZgOx9f8q4iA2agarpCqCeHeL4
 ze890BgFQ7QJg8oXxJk8xFZmsC4DH5mFBcNhkxOJVU46Ir7eqLFBmX0hyLltiqcc0S1gdjtypP
 c/7Pr3/cDRyd5VGMAAAA=
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
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14-dev

This series adds support for the optional fixed instruction counter 
added in Armv9.4 PMU. Most of the series is a refactoring to remove the 
index to counter number conversion which dates back to the Armv7 PMU 
driver. Removing it is necessary in order to support more than 32 
counters without a bunch of conditional code further complicating the 
conversion.

Patches 1-2 move the 32-bit Arm PMU drivers into drivers/perf/ and drop 
non-DT probe support. These can be taken first if there's no comments on 
them.

Patch 3 changes struct arm_pmu.num_events to a bitmap of events, and 
updates all the users. This removes the index to counter conversion 
on the PMUv3 and Armv7 drivers.

Patch 4 updates various register accessors to use 64-bit values matching 
the register size.

Patches 5-6 update KVM PMU register accesses to use shared accessors 
from asm/arm_pmuv3.h.

Patches 7-8 rework KVM and perf PMU defines for counter indexes and 
number of counters.

Patch 9 finally adds support for the fixed instruction counter.

I tested this on FVP with VHE host and a guest. I tested the Armv7 PMU 
changes with QEMU.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
Rob Herring (Arm) (9):
      perf/arm: Move 32-bit PMU drivers to drivers/perf/
      perf: arm_v6/7_pmu: Drop non-DT probe support
      perf: arm_pmu: Remove event index to counter remapping
      perf: arm_pmuv3: Prepare for more than 32 counters
      KVM: arm64: pmu: Use arm_pmuv3.h register accessors
      KVM: arm64: pmu: Use generated define for PMSELR_EL0.SEL access
      arm64: perf/kvm: Use a common PMU cycle counter define
      KVM: arm64: Refine PMU defines for number of counters
      perf: arm_pmuv3: Add support for Armv9.4 PMU instruction counter

 arch/arm/include/asm/arm_pmuv3.h                   |  23 ++++
 arch/arm/kernel/Makefile                           |   2 -
 arch/arm64/include/asm/arm_pmuv3.h                 |  56 ++++++++-
 arch/arm64/include/asm/kvm_host.h                  |   8 +-
 arch/arm64/include/asm/sysreg.h                    |   1 -
 arch/arm64/kvm/pmu-emul.c                          |  14 +--
 arch/arm64/kvm/pmu.c                               |  88 ++++---------
 arch/arm64/kvm/sys_regs.c                          |  11 +-
 arch/arm64/tools/sysreg                            |  30 +++++
 drivers/perf/Kconfig                               |  12 ++
 drivers/perf/Makefile                              |   3 +
 drivers/perf/arm_pmu.c                             |  11 +-
 drivers/perf/arm_pmuv3.c                           | 138 ++++++++++-----------
 .../perf_event_v6.c => drivers/perf/arm_v6_pmu.c   |  26 +---
 .../perf_event_v7.c => drivers/perf/arm_v7_pmu.c   |  90 +++++---------
 .../perf/arm_xscale_pmu.c                          |  15 +--
 include/kvm/arm_pmu.h                              |   8 +-
 include/linux/perf/arm_pmu.h                       |  10 +-
 include/linux/perf/arm_pmuv3.h                     |   7 +-
 19 files changed, 289 insertions(+), 264 deletions(-)
---
base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
change-id: 20240607-arm-pmu-3-9-icntr-04375ddd0082

Best regards,
-- 
Rob Herring (Arm) <robh@kernel.org>

