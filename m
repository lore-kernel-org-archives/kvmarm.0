Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FAE25B66D;
	Tue, 20 May 2025 22:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747780085; cv=none; b=UjhN0MkXqWLPayaW5naKFn8CYk2iToyJjRW8azLs7BwbZHLflJb8ofRWhGbLFBq48LTh0fkqQ9bWS6OiP22v+0/F/m+2JWAsF/5QAu24dQ1Wt0fgWw6jS/o6pL57WoseLuqIH6nM42X+qEtmCzc7syD31uMyousdU+nDELOMsPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747780085; c=relaxed/simple;
	bh=1rC7SEwUZWx9R8K9mnDFMVOe9WTjcLxX2/ToCfUFA30=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mJbZ0qffrXiBDhUOkXiuITJaL/gEtCpXSyIRCkA4kNtBLvlI6gL02GECBuzMTvnsR20d9DK/suPgSQcAcM3x9f9kMOvK2PN4q7xS8IsIUoJ9L9uWQsyNtoPOzayr3Xv8rHjJkR5vCmKE/GdSCXvoiW3B/VRjEC1N6TLyzQk6zkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QtcQfDnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QtcQfDnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEC5C4CEE9;
	Tue, 20 May 2025 22:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747780084;
	bh=1rC7SEwUZWx9R8K9mnDFMVOe9WTjcLxX2/ToCfUFA30=;
	h=From:Subject:Date:To:Cc:From;
	b=QtcQfDnqQckp+/Xb/jLS8IKj1G2TJ5esJX0Ep9eBKaf/0xuTGVc76r5ekbQqLEdc+
	 KnfeiGVrNQsi4wcX4smkWEuCy4aAQV+J5Ua+20OyOG5+eFfLBrkvplqBOZzIWo8nos
	 p9/UPOVLxpHluZsuEEDjQq5SAl1IltQPW21v542uCdq+8E0Wy3Orh5YYa1LepUqecJ
	 ndA2FaOGKplPCCqmhfyhR9qa785i8437ix3Wt/l+WSR89UmD0Mb5VnnRXOW0SNkNcA
	 JiOPgeaVQPI2fno5ICSI8GEdpsuI4xvIDz9W5p0YB/UGn05JOPUaNTjTPaA4UBt2Li
	 F/RuZhAVJFF9g==
From: "Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH v22 0/5] arm64/perf: Enable branch stack sampling
Date: Tue, 20 May 2025 17:27:35 -0500
Message-Id: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANcBLWgC/2XMwQ6CMAyA4VchOzvTFQabJ9/DeIDRwaKC2QzRE
 N7dgQcFD1vSpt8/skDeUWCHZGSeBhdc38UBcZcw05ZdQ9zVccEQUIJAzUt/45WviA9Cc8xqWWu
 SlGPKIrl7su659E7nOLcuPHr/WvLxfl5/SvFbl+YHXBiRAijAVMnjhXxH133vGza3BoQfL9TGI
 0SfkdaI1iAp+vfi6zMotl5Eb61QhbW50ahWfpqmN87iguQsAQAA
X-Change-ID: 20250129-arm-brbe-v19-24d5d9e5e623
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>, 
 Dave Martin <Dave.Martin@arm.com>
X-Mailer: b4 0.15-dev

This series enables perf branch stack sampling support on arm64 via a 
v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details 
on BRBE can be found in the Arm ARM[1] chapter D18.

I've picked up this series from Anshuman. v19 and later versions have 
been reworked quite a bit by Mark and myself. The bulk of those changes 
are in patch 5.

A git branch is here[2].

[1] https://developer.arm.com/documentation/ddi0487/latest/
[2] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git arm/brbe-v22

Changes in v22:
 - New patch reworking the labels in el2_setup.h
 - Move branch stack disabling after armpmu_stop() in armpmu_del()
 - Fix branch_records_alloc() to work on heterogeneous systems
 - Make setting .sched_task function ptr conditional on BRBE support
 - Reword booting.rst section name (s/feature/the/) and move next to
   other PMU related features instead of in the middle of SME features.
 - Drop setting SYS_BRBCR_EL1
 - Drop CONFIG_ARM64_BRBE ifdef
 - Rework initialization of HFGITR_EL2

v21:
 - https://lore.kernel.org/r/20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org
 - Drop clean-up patches 1-7 already applied
 - Rebase on v6.15-rc1

v20:
 - https://lore.kernel.org/r/20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org
 - Added back some of the arm64 specific exception types. The x86 IRQ 
   branches also include other exceptions like page faults. On arm64, we 
   can distinguish the exception types, so we do. Also, to better 
   align with x86, we convert 'call' branches which are user to kernel 
   to 'syscall'.
 - Only enable exceptions and exception returns if recording kernel
   branches (matching x86)
 - Drop requiring event and branch privileges to match
 - Add "branches" caps sysfs attribute like x86
 - Reword comment about FZP and MDCR_EL2.HPMN interaction
 - Rework BRBE invalidation to avoid invalidating in interrupt handler
   when no handled events capture the branch stack (i.e. when there are 
   multiple users).
 - Also clear BRBCR_ELx bits in brbe_disable(). This is for KVM nVHE 
   checks if BRBE is enabled.
 - Document that MDCR_EL3.SBRBE can be 0b01 also

v19:
 - https://lore.kernel.org/all/20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org/
 - Drop saving of branch records when task scheduled out (Mark). Make 
   sched_task() callback actually get called. Enabling requires a call 
   to perf_sched_cb_inc(). So the saving of branch records never 
   happened.
 - Got rid of added armpmu ops. All BRBE support is contained within 
   pmuv3 code.
 - Fix freeze on overflow for VHE
 - The cycle counter doesn't freeze BRBE on overflow, so avoid assigning
   it when BRBE is enabled.
 - Drop all the Arm specific exception branches. Not a clear need for
   them.
 - Fix handling of branch 'cycles' reading. CC field is
   mantissa/exponent, not an integer.
 - Rework s/w filtering to better match h/w filtering
 - Reject events with disjoint event filter and branch filter or with 
   exclude_host set
 - Dropped perf test patch which has been applied for 6.14
 - Dropped patch "KVM: arm64: Explicitly handle BRBE traps as UNDEFINED"
   which has been applied for 6.14

v18:
 - https://lore.kernel.org/all/20240613061731.3109448-1-anshuman.khandual@arm.com/

For v1-v17, see the above link. Not going to duplicate it all here...

Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
---
---
Anshuman Khandual (4):
      arm64/sysreg: Add BRBE registers and fields
      arm64: el2_setup.h: Make __init_el2_fgt labels consistent, again
      arm64: Handle BRBE booting requirements
      KVM: arm64: nvhe: Disable branch generation in nVHE guests

Rob Herring (Arm) (1):
      perf: arm_pmuv3: Add support for the Branch Record Buffer Extension (BRBE)

 Documentation/arch/arm64/booting.rst |  21 +
 arch/arm64/include/asm/el2_setup.h   |  81 +++-
 arch/arm64/include/asm/kvm_host.h    |   2 +
 arch/arm64/include/asm/sysreg.h      |  17 +-
 arch/arm64/kvm/debug.c               |   4 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c   |  32 ++
 arch/arm64/kvm/hyp/nvhe/switch.c     |   2 +-
 arch/arm64/tools/sysreg              | 132 ++++++
 drivers/perf/Kconfig                 |  11 +
 drivers/perf/Makefile                |   1 +
 drivers/perf/arm_brbe.c              | 802 +++++++++++++++++++++++++++++++++++
 drivers/perf/arm_brbe.h              |  47 ++
 drivers/perf/arm_pmu.c               |  16 +-
 drivers/perf/arm_pmuv3.c             | 125 +++++-
 include/linux/perf/arm_pmu.h         |   8 +
 15 files changed, 1276 insertions(+), 25 deletions(-)
---
base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
change-id: 20250129-arm-brbe-v19-24d5d9e5e623

Best regards,
-- 
Rob Herring (Arm) <robh@kernel.org>

