Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F7EB65C;
	Mon,  3 Feb 2025 00:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738543398; cv=none; b=j5sFTOxdxYrrRSBUSTH5Pq9i5hwawouk62OdPVnstdphBuXG55Ky3A4zHUFcruxvIIo4oD1BCy/mgYeD8yvev5pNCFKNc/KYU26c4hrTX7dBgoNwppDhzJR4igoCoz6psFa99kDRxkSDw9u4mAM9Ukf3fcUqcZTSQrWqIwhoqZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738543398; c=relaxed/simple;
	bh=GpuZv6X9a6Iwav9fDexP5CTqJHFoGKqBKJpUPFkjJQs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=JxUdCzcGWqLva002N/5J6tQ6mwzrY0sW32D+6MwHeTceNKga+v8kLDROKOYqY6gl2qFpOrHNCLfJwTwfnRK8FG4JotqtWL6ANbBbPJhQYazPCwecS6OJYyVYCOCAu/ApPfdoExOF3esNCq/EkCm+HYeNUerpnTvNHeGf4Q99xXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TwN2gbFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TwN2gbFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CA5C4CED1;
	Mon,  3 Feb 2025 00:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738543396;
	bh=GpuZv6X9a6Iwav9fDexP5CTqJHFoGKqBKJpUPFkjJQs=;
	h=From:Subject:Date:To:Cc:From;
	b=TwN2gbFcustSVQowbpDiSu3hDdQ5n7MYCaOg3+uUa6Ar/XcJBfkMu1jb2OgKVD/Q4
	 s7BYp78utgencj8QXwYswiRUQ3IbwABey4810SZvhuV7woxFX9znp4UbvaAcco3VTg
	 pz3iNYNj7T8fEMQdExBXZNsaJO2oBRxRMInAKx5rk8iqaTOqJeisTpaFc0dDDlECr3
	 2wgajwRkIsUSDibsQEEI1QtBLukE5o5oK3Y79bT0Q6pxdTTBfTt+QHT9SWuxMVHPA4
	 5enNChqZ4+ypGpoBfytmoPcqGJ3b7p+4ZVifBnlBnNh7lKl8XEx6V7rsgmfNQrM+Ai
	 FXjKZHaTDvMiw==
From: "Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH v19 00/11] arm64/perf: Enable branch stack sampling
Date: Sun, 02 Feb 2025 18:42:54 -0600
Message-Id: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA4RoGcC/x2MQQqAMAzAviI9W3DVCfMr4mG6qj04pQMRhn93e
 EwgyZBYhRMMVQblW5KcsYBxdQXL7uPGKKEIoIZsY8ih1wNnnRlv45C6YINjyz21UJJLeZXn/43
 T+34amuVzXwAAAA==
X-Change-ID: 20250129-arm-brbe-v19-24d5d9e5e623
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev

This series enables perf branch stack sampling support on arm64 via a 
v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details 
on BRBE can be found in the Arm ARM[1] chapter D18.

I've picked up this series from Anshuman. This version has been reworked 
quite a bit by Mark and myself. The bulk of those changes are in patch 
11.

Patches 1-7 are new clean-ups/prep which stand on their own. They 
were previously posted here[2]. Please pick them up if there's no issues 
with them.

Patches 8-11 add BRBE support with the actual support in patch 11.

[1] https://developer.arm.com/documentation/ddi0487/latest/
[2] https://lore.kernel.org/all/20250107-arm-pmu-cleanups-v1-v1-0-313951346a25@kernel.org/

v19:
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
 arch/arm64/tools/sysreg              | 132 ++++++
 drivers/perf/Kconfig                 |  11 +
 drivers/perf/Makefile                |   1 +
 drivers/perf/apple_m1_cpu_pmu.c      |   4 -
 drivers/perf/arm_brbe.c              | 794 +++++++++++++++++++++++++++++++++++
 drivers/perf/arm_brbe.h              |  47 +++
 drivers/perf/arm_pmu.c               |  23 +-
 drivers/perf/arm_pmuv3.c             |  96 ++++-
 drivers/perf/arm_v7_pmu.c            |  50 ---
 include/linux/perf/arm_pmu.h         |  21 +-
 16 files changed, 1250 insertions(+), 91 deletions(-)
---
base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
change-id: 20250129-arm-brbe-v19-24d5d9e5e623

Best regards,
-- 
Rob Herring (Arm) <robh@kernel.org>

