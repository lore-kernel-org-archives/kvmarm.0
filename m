Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EB51DE2AA;
	Tue, 18 Feb 2025 20:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911236; cv=none; b=Xbdtt45bM75UzcOzVjy32GYd3ExfreoA8wflqfbpqADGMEYQH5XT2G96uBoV8H4jWbCht167bUElsfGuOiS1S/4RoTtwnyhRmKjwfvByKV3Mav6klDfVIA/vR1n5X6pKfyVmGBsMX/j8DhqZJse/24qcK2nnWmJGei880PqYY6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911236; c=relaxed/simple;
	bh=Z+quPJdBJcgbjzBSnWCWvWeBqOxZIeqQH+qlwCfJsj4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=PT9P1/JYelstp3p2nONDt7W+C6ApINLkf/D+Icst8KP+XJBfE6QMV9A7SMWTEUkB8yePCmMjhvjTh2wcedlTRKmrY8lU7eehF53fEP396Uq+6otqJT+3BgRC9pr2VA8onYz0PTY21G87SABAhoVisRqkk9zQi7S7DLM8A8EvFGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfD7MU8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfD7MU8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304A2C4CEE8;
	Tue, 18 Feb 2025 20:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739911235;
	bh=Z+quPJdBJcgbjzBSnWCWvWeBqOxZIeqQH+qlwCfJsj4=;
	h=From:Subject:Date:To:Cc:From;
	b=hfD7MU8OoRdA9sY9iZLZCIddEVIcPVmmnLpjLISeCrnX9t/ScM3543GiLiuqyNN7K
	 41EAUOA8VMmt4bteYuzd3hoXbIX4QfE7mXHVrXJDoLT4lk/7QySK2bnhdV5WZ1a56P
	 BU0XE1B4s8+0gtVQrIc4QNJEkYmbPwbx4k+suKzk/VSM8BNNhO/ZUJ6OVyETi4D1dU
	 YBUfNSgVLzGuuiR+TdLP2C2t1uI1iKFtnWojn+q9gTF6jRQNUEzIMutgaKDttgi+Gp
	 X/lOlZsm2NRPJFDF1p0z4BBW10VRrzdnlPhIpp2oHbagCqxXH8zEiPRmxBA9Y/G0KR
	 fON7T4wzzY1VA==
From: "Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH v20 00/11] arm64/perf: Enable branch stack sampling
Date: Tue, 18 Feb 2025 14:39:55 -0600
Message-Id: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABvwtGcC/1WMwQrCMBBEf6Xs2chmY6Tx5H9ID22ztkFtZCNFK
 fl303ryMAMzzLwFEkvgBKdqAeE5pBCnEgh3FfRjOw2sgi8FEJJFTU618lCddKxm7RQdvPWOLR/
 JQLk8ha/hvfEuTcljSK8onw1f9mv9IxX7J61CpXttEGskU9vzjWXi+z7KAE3O+QuI9lSarAAAA
 A==
X-Change-ID: 20250129-arm-brbe-v19-24d5d9e5e623
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev

This series enables perf branch stack sampling support on arm64 via a 
v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details 
on BRBE can be found in the Arm ARM[1] chapter D18.

I've picked up this series from Anshuman. v19 and v20 versions have been 
reworked quite a bit by Mark and myself. The bulk of those changes are 
in patch 11.

Patches 1-7 are new clean-ups/prep which stand on their own. They 
were previously posted here[2]. Please pick them up if there's no issues 
with them.

Patches 8-11 add BRBE support with the actual support in patch 11.

A git branch is here[3].

[1] https://developer.arm.com/documentation/ddi0487/latest/
[2] https://lore.kernel.org/all/20250107-arm-pmu-cleanups-v1-v1-0-313951346a25@kernel.org/
[3] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git arm/brbe-v20

v20:
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
Changes in v20:
- EDITME: describe what is new in this series revision.
- EDITME: use bulletpoints and terse descriptions.
- Link to v19: https://lore.kernel.org/r/20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org

---
Anshuman Khandual (4):
      arm64/sysreg: Add BRBE registers and fields
      arm64: Handle BRBE booting requirements
      KVM: arm64: nvhe: Disable branch generation in nVHE guests
      perf: arm_pmuv3: Add support for the Branch Record Buffer Extension (BRBE)

Mark Rutland (3):
      perf: arm_pmu: Don't disable counter in armpmu_add()
      perf: arm_pmuv3: Don't disable counter in armv8pmu_enable_event()
      perf: arm_pmu: Move PMUv3-specific data

Rob Herring (Arm) (4):
      perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0() before enabling counters
      perf: arm_v7_pmu: Drop obvious comments for enabling/disabling counters and interrupts
      perf: arm_v7_pmu: Don't disable counter in (armv7|krait_|scorpion_)pmu_enable_event()
      perf: apple_m1: Don't disable counter in m1_pmu_enable_event()

 Documentation/arch/arm64/booting.rst |  21 +
 arch/arm64/include/asm/el2_setup.h   |  86 +++-
 arch/arm64/include/asm/kvm_host.h    |   2 +
 arch/arm64/include/asm/sysreg.h      |  17 +-
 arch/arm64/kvm/debug.c               |   4 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c   |  32 ++
 arch/arm64/kvm/hyp/nvhe/switch.c     |   2 +-
 arch/arm64/tools/sysreg              | 132 ++++++
 drivers/perf/Kconfig                 |  11 +
 drivers/perf/Makefile                |   1 +
 drivers/perf/apple_m1_cpu_pmu.c      |   4 -
 drivers/perf/arm_brbe.c              | 802 +++++++++++++++++++++++++++++++++++
 drivers/perf/arm_brbe.h              |  47 ++
 drivers/perf/arm_pmu.c               |  23 +-
 drivers/perf/arm_pmuv3.c             | 135 +++++-
 drivers/perf/arm_v7_pmu.c            |  50 ---
 include/linux/perf/arm_pmu.h         |  21 +-
 17 files changed, 1297 insertions(+), 93 deletions(-)
---
base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
change-id: 20250129-arm-brbe-v19-24d5d9e5e623

Best regards,
-- 
Rob Herring (Arm) <robh@kernel.org>

