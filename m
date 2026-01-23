Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E4E11FAC42
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769187064; cv=none; b=K+7sV3YLPNRR16C5W33q/TGRxUt5RCYRoKkWHD7RjAtUxBxoRGEnieNbhZ0CPqHI6BrMtfYtUmVOnludXr/A1Ugxwyr2gViGMyyOPe39SJ2A1QWyBSAlzzDLRFQvFmGfqPZyj+4Hr9uUbg2RnlgPMJehH4k4eRM0I9cyOtEbfSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769187064; c=relaxed/simple;
	bh=5LhATeaC4lBKw5FgMCPNVHNlKxi42DoKC1WPfsAgZyo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LlAi2tgBaN6K8mBfS+fEwE1uxMwybwvdJIC2NFlA173cuGpngoYB1hLAiOrTZpdouhZX8vj3gIDvg088A+Cmi8pjQf9xNFlGLez/JTw1CotdMnuF0LssXjKjs97HQQIkGe7lX22ZMkQHQqG1rkBqsC6ipSz6kaYRyVzj8TXlEgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEDB41476;
	Fri, 23 Jan 2026 08:50:55 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE1153F694;
	Fri, 23 Jan 2026 08:51:00 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v6 00/14] arm64: EL2 support
Date: Fri, 23 Jan 2026 16:50:39 +0000
Message-Id: <20260123165053.2250754-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series is for adding support to running the kvm-unit-tests at EL2.

Changes since v5[1]:
	- make debug bp/wp skip on EL2
	- fix microbench test
	- add to CI
	- applied the fixup's Drew talked about in v5

About this failure in micro-bench:

	- micro-bench hits the assert in gicv3_lpi_alloc_tables()
		lib/arm/gic-v3.c:183: assert failed: gicv3_data.redist_base[cpu]: Redistributor for cpu0 not initialized. Did cpu0 enable the GIC?	

in micro-bench.c lpi_prep() looks like this:

	static bool lpi_prep(void)
	{
	        struct its_collection *col1;
	        struct its_device *dev2;
	        if (!gicv3_its_base())
	                return false;

QEMU by default runs with gic-v2, so gicv3_its_base() should have returned
false and the lpi tests skipped. However because of the overflow mentioned in
the first commit (new to v6), the its_data.base was being overwritten to a
non-zero value.  This meant the test tried to do gic-v3 things on a gic-v2.

Thanks,
Joey

[1] https://lore.kernel.org/kvmarm/20260114115703.926685-1-joey.gouly@arm.com/


Alexandru Elisei (2):
  arm64: micro-bench: use smc when at EL2
  arm64: selftest: update test for running at EL2

Joey Gouly (12):
  arm64: fix overflow in gic-v2 initialisation
  arm64: set SCTLR_EL1 to a known value for secondary cores
  arm64: drop to EL1 if booted at EL2
  arm64: efi: initialise SCTLR_ELx fully
  arm64: efi: initialise the EL
  arm64: timer: use hypervisor timers when at EL2
  arm64: micro-bench: fix timer IRQ
  arm64: pmu: count EL2 cycles
  arm64: run at EL2 if supported
  arm64: add EL2 environment variable
  arm64: debug: skip tests at EL2
  arm64: gitlab-ci: add EL2 tests to CI

 .gitlab-ci.yml             | 30 +++++++++++++++++
 arm/cstart64.S             | 66 ++++++++++++++++++++++++++++++++++++--
 arm/debug.c                | 10 ++++++
 arm/efi/crt0-efi-aarch64.S |  5 +++
 arm/micro-bench.c          | 26 +++++++++++++--
 arm/pmu.c                  | 13 +++++---
 arm/run                    |  9 ++++++
 arm/selftest.c             | 23 ++++++++++---
 arm/timer.c                | 12 +++++--
 lib/acpi.h                 |  2 ++
 lib/arm/asm/setup.h        |  8 +++++
 lib/arm/asm/timer.h        | 11 +++++++
 lib/arm/gic.c              | 17 ++++++----
 lib/arm/setup.c            |  4 +++
 lib/arm/timer.c            | 19 +++++++++--
 lib/arm64/asm/sysreg.h     | 19 +++++++++++
 lib/arm64/processor.c      | 14 ++++++++
 scripts/arch-run.bash      |  5 +++
 18 files changed, 266 insertions(+), 27 deletions(-)

-- 
2.25.1

