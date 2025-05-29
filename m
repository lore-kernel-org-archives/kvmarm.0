Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CE222687B
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748526993; cv=none; b=If3c0hTpaVAML8WVhVfaKXYLuXoOB7fszHCJrC65DhTX5tUekITebbrdafBvplK26XQYAI2QJRzzXiKdug1hKg9A7O/rrMkpWhY4ItJBKQFGVuZpYUIOPa5rw1Am0PMFuVYH07l/KpzKMV92z1E+rDNgkIH54KDBwREOV7QCFQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748526993; c=relaxed/simple;
	bh=TsPOS6LVXHO8JXbYSYGqNKLcztarndE6eVNRtsyq9K0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U3ByfE/OGaAocWjyeHKtnY3sNcyc+F32EXAZnu/XslmF5bnEfqwEQuhojWadpXLZ2FOZJdDFKU7VqKXbuF6Abry8eOQT+urc5htHTe7GHVda1rom43+U82QUMbwUom+oZmC2H+lba5GIyKJydVp0OQT89nEeiPu4hVbQGX7Y/Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FAAD176A;
	Thu, 29 May 2025 06:56:13 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84D9B3F673;
	Thu, 29 May 2025 06:56:28 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v2 0/9] arm64: support EL2
Date: Thu, 29 May 2025 14:55:48 +0100
Message-Id: <20250529135557.2439500-1-joey.gouly@arm.com>
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
have been tested with Marc Zyngier's Linux kvm-arm64/nv-next branch [1] and
kvmtool branch arm64/nv-6.13 [2]

The goal is to later extend and add new tests for Nested Virtualisation,
however they should also work with bare metal as well.

Changes since v1[3]:
	- Authorship fixed on 2 patches
	- Tested and fixed EFI support
	- Recactored assembly and added init_el macro
	- Clear trap registers, trying to avoid relying on default register
	  state
	- Cleaned up PMU changes

The debug tests fail with --nested, but pass with --nested --e2h0, I
need to investigate this.

Thanks,
Joey

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-next (commit a35d752b17f4)
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git arm64/nv-6.13 (commit 5b6fe295ea7)
[3] https://lore.kernel.org/kvmarm/20250220141354.2565567-1-joey.gouly@arm.com/

Alexandru Elisei (2):
  arm64: micro-bench: use smc when at EL2
  arm64: selftest: update test for running at EL2

Joey Gouly (7):
  arm64: drop to EL1 if booted at EL2
  arm64: efi: initialise SCTLR_ELx fully
  arm64: efi: initialise the EL
  arm64: timer: use hypervisor timers when at EL2
  arm64: micro-bench: fix timer IRQ
  arm64: pmu: count EL2 cycles
  arm64: run at EL2 if supported

 arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
 arm/efi/crt0-efi-aarch64.S |  5 ++++
 arm/micro-bench.c          | 26 ++++++++++++++++--
 arm/pmu.c                  | 13 ++++++---
 arm/selftest.c             | 18 ++++++++----
 arm/timer.c                | 10 +++++--
 lib/acpi.h                 |  2 ++
 lib/arm/asm/setup.h        |  1 +
 lib/arm/asm/timer.h        | 11 ++++++++
 lib/arm/setup.c            |  6 ++++
 lib/arm/timer.c            | 19 +++++++++++--
 lib/arm64/asm/sysreg.h     | 19 +++++++++++++
 12 files changed, 167 insertions(+), 19 deletions(-)

-- 
2.25.1

