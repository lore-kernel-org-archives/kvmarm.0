Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC28318C02E
	for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810309; cv=none; b=NizukytTFCso3E+Q5mVu1TuuNDXUNSz9D4ZB6fgj8t12IFWdmF8yzDGz7OxQRYW4DiNAqtUwqAp2rStwTbYp4iRjpnceTqkPp9sFkMytFzRLJzW4GInNX7uMzZwpa5pKV/xJAGBUMHZRIf4B85DMlk1C5895cBqoP7gM+IcLozQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810309; c=relaxed/simple;
	bh=92fy7czo0I6XSlwsqZFHCiAGIpMohrM1BHQ5mrrOdho=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CIPpFN5gJrIl3MF0mpaZXehM96Yd53Zg4c+gaNQAm2MGwjzQzjM7uYrpKS/f/U1+av88H0LZABmIPPsyEs/3r/z/YL8XMDufpSW2buSC/RzN1j4ZlnQ36jNcP8Liz0CueVUfsrfzXPCqkMsVCblsVpiOPTzp6IF3LHVIa4R4Nnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 143561692;
	Thu, 25 Sep 2025 07:24:59 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB0A63F694;
	Thu, 25 Sep 2025 07:25:05 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Date: Thu, 25 Sep 2025 15:19:48 +0100
Message-Id: <20250925141958.468311-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series is for adding support to running the kvm-unit-tests at EL2. These
have been tested with Linux 6.17-rc6 KVM nested virt.

This latest round I also tested using the run_tests.sh script with QEMU TCG,
running at EL2.

The goal is to later extend and add new tests for Nested Virtualisation,
however they should also work with bare metal as well.

Changes since v2[1]:
	- Move the sctlr setup in EFI to a function.
	- Decided to not re-use el2_setup.h from Linux, looked more
	  complicated to use than needed for KUT.
	- Add EL2 env variable for testing, open to feedback for that.
	  This was untested with kvmtool as my testing setup only has
	  busybox ash currently, and the run_tests.sh script needs bash.

Issues (that I think are fine to investigate/fix later):
	- Some of the debug tests fail with QEMU at EL2 and kvmtool.
	- The gic ipi test times out with QEMU at EL2, but works with kvmtool.

Thanks,
Joey

[1] https://lore.kernel.org/kvmarm/20250529135557.2439500-1-joey.gouly@arm.com/

Alexandru Elisei (2):
  arm64: micro-bench: use smc when at EL2
  arm64: selftest: update test for running at EL2

Joey Gouly (8):
  arm64: drop to EL1 if booted at EL2
  arm64: efi: initialise SCTLR_ELx fully
  arm64: efi: initialise the EL
  arm64: timer: use hypervisor timers when at EL2
  arm64: micro-bench: fix timer IRQ
  arm64: pmu: count EL2 cycles
  arm64: run at EL2 if supported
  arm64: add EL2 environment variable

 arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
 arm/efi/crt0-efi-aarch64.S |  5 ++++
 arm/micro-bench.c          | 26 ++++++++++++++++--
 arm/pmu.c                  | 13 ++++++---
 arm/run                    |  7 +++++
 arm/selftest.c             | 18 ++++++++----
 arm/timer.c                | 10 +++++--
 lib/acpi.h                 |  2 ++
 lib/arm/asm/setup.h        |  8 ++++++
 lib/arm/asm/timer.h        | 11 ++++++++
 lib/arm/setup.c            |  4 +++
 lib/arm/timer.c            | 19 +++++++++++--
 lib/arm64/asm/sysreg.h     | 19 +++++++++++++
 lib/arm64/processor.c      | 12 ++++++++
 14 files changed, 191 insertions(+), 19 deletions(-)

-- 
2.25.1

