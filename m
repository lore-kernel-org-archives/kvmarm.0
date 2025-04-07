Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F348217F36;
	Mon,  7 Apr 2025 17:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744047748; cv=none; b=jLH6O4NU2bGcyrR2zGNEHgJRct24BBxWydbm6Q6BdCOB0r0R6xEaH1hKW8al/HLz/Oue8csqvWeO11dzJ6uFBHyV5/2E7TCUhHwOl72BdYNHy0gRr0vYNYyIkntUbvdfzFWkJKso2BsBBQ4/j6ZA7mIcXfwo8anJuuVK8OlqMbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744047748; c=relaxed/simple;
	bh=mfrACnEJ4AJuVAi0UxiF43bxtbWvmtrWPliXcYJUjiE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=g7B2u/KnxM4s4hq+0MpXaMmagxom6R/1zTOhxcUEpMvT1uOJfjgD3xgmfu0bKSyy6QNuMLRXSpyoxrI6O6fRXxop5hnQ6bxJEOTOqcBRkxqQ9FCt+76k+HuXDfeItrQa3b/NNqhPZDXUsFJuAQUIgyFmNWpLj1TeY6p07PbHUOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVO5Fcps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVO5Fcps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AA8C4CEDD;
	Mon,  7 Apr 2025 17:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744047747;
	bh=mfrACnEJ4AJuVAi0UxiF43bxtbWvmtrWPliXcYJUjiE=;
	h=From:Subject:Date:To:Cc:From;
	b=lVO5FcpsRn35NINHwzli3PZVpUSklKuio+ezf/gFz8PSy7IaMeouVtzXM04h8JxUL
	 8NOk9dylKjRxfSSw+PmvT3AyhxGAPuftWkArFPLSPdxQyRRUDD4MnhgG48EIKCdVYl
	 gKDlJYgn9RUwB9XqGlU/khskJQW5010jsYRDkEsjfNqJxNIw68EMqyLiwIf/m31v57
	 i3b+bTjGWBJf3eFeyQtLWf988hZi0+hSuSF72ZCq2zJtLYaotpI0JvoZ20WgND58QZ
	 Wewdp+/NxKFlzQ60zQObNFI3S38XN2eEeb7HIARba59h7vXDErl6OxjnIWsstLDJb0
	 EAwuafF6REMXg==
From: "Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH v21 0/4] arm64/perf: Enable branch stack sampling
Date: Mon, 07 Apr 2025 12:41:29 -0500
Message-Id: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEkO9GcC/12Myw6CMBBFf4V0bc10oKZ15X8YFzwGaFRqpoZoC
 P/ugBtxMZPcm3vOpBJxoKSO2aSYxpBCHCSg2WWq7suhIx0aKRQCWjDodcl3XXFFejReY9HYxpO
 lA+ZKkAdTG16r73yR3If0jPxe9bJf6q9J3ta0HGhTmxzAAebOnq7EA932kTu1uEaEH964Px5B+
 IK8R2xrJEcbfp7nD0fnMO3sAAAA
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
in patch 4.

A git branch is here[2].

[1] https://developer.arm.com/documentation/ddi0487/latest/
[2] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git arm/brbe-v21

v21:
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
Anshuman Khandual (4):
      arm64/sysreg: Add BRBE registers and fields
      arm64: Handle BRBE booting requirements
      KVM: arm64: nvhe: Disable branch generation in nVHE guests
      perf: arm_pmuv3: Add support for the Branch Record Buffer Extension (BRBE)

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
 drivers/perf/arm_brbe.c              | 802 +++++++++++++++++++++++++++++++++++
 drivers/perf/arm_brbe.h              |  47 ++
 drivers/perf/arm_pmu.c               |  15 +-
 drivers/perf/arm_pmuv3.c             | 129 +++++-
 include/linux/perf/arm_pmu.h         |   8 +
 15 files changed, 1287 insertions(+), 22 deletions(-)
---
base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
change-id: 20250129-arm-brbe-v19-24d5d9e5e623

Best regards,
-- 
Rob Herring (Arm) <robh@kernel.org>

