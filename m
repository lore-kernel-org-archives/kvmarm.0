Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8C53A5E64
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867819; cv=none; b=ss+NfINEKJHisofJwyQsPy/Uzk6k5MDbBuMOmWOQy+TPgj11Qmke0Msrj9Z6OeCyvjOJ1w5+bBBNPGwIVGQLzXH8l7v0v7VoY0MkCr/xjHS4s/f/cIAQp4GQzWpAnk8+3ZmXE6coqB0lC/TSR7PSU4VhRhKuEN9JdY16OHO7scM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867819; c=relaxed/simple;
	bh=hneQixZug+omiC5d9ZfrRbcSwIyTECL9ua9pAppEj4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qQMrLYqvjj1AwXwJuKZTwv98o771WCr1E3+dqmdfoa4dJuxuEnhAZ/D2QvguYClWG3P4Sres500XvqKODDWUk0xulojHOtIOJWc0HqZ+YsdFi7Mo/JNb9jvkH1p2QFO4t+SYPJEy4Q2ddaHqxyzIs1UpJHWVoUMh/eHjtvpR+EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dIbDIsxf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dIbDIsxf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9582497;
	Thu,  1 Oct 2026 08:16:52 -0700 (PDT)
Received: from e143914.cambridge.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0B263F86F;
	Thu,  1 Oct 2026 08:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790867816; bh=hneQixZug+omiC5d9ZfrRbcSwIyTECL9ua9pAppEj4k=;
	h=From:To:Cc:Subject:Date:From;
	b=dIbDIsxfoe46x4maw4x7xVrxF9pHGaC1gY7zoQBGSF5JqNxjO1HgFslQMCaHwaaSb
	 EVbbAl6jQ2Oo9COa/3DlynMiG6HJ9vxeLQWK7AQI9SxOC0AcvniUDJR790+h1K0oXq
	 CADG7BzuFe1Xs1O+EGD9Y7ki09+hbFtlwCJc4BS4=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	andrew.jones@linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH v3 0/8] arm64: Add Stage-2 MMU and Nested Guest Framework
Date: Thu,  1 Oct 2026 16:16:37 +0100
Message-ID: <20261001151645.2427065-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v3 of the guest framework for kvm-unit-tests/arm64, I have confirmation
from Jing that he was ok with me posting v3 on top of his v2 [1].

This series introduces lightweight infrastructure for managing arm64 stage-2
translation tables and running EL1 guests from EL2.

The stage-2 library provides page-table mapping, unmapping and context loading.
The initial implementation is deliberately limited to a 4K granule, 48-bit IPA
space and 8-bit VMIDs.

The series also includes a stage-2 demand-paging test which handles a guest
stage-2 fault by installing the missing mapping and resuming the guest.

The first 2 patches are just preparatory patches and could be merged
earlier.

Changes since v2:
- Fixed free_pages(NULL), ran into a hang and debugged it to this
- Validate the currently supported stage-2 configuration: 4K granules,
  48-bit IPAs and 8-bit VMIDs.
- Store the VTCR_EL2 and VTTBR_EL2 values in the stage-2 mmu.
- Replace s2mmu_enable()/s2mmu_disable() with s2mmu_load(); saving
  of the previous stage-2 context is now handled by the guest world switch.
- Make s2mmu_map() return errors, rather than printing.
- Fix the required barriers for stage-2 TLB invalidation.
- Split guest creation, so that the policy of mapping is in a separate
  identity helper.
- Remove the hardcoded UART mapping from guest creation. This can be added back
  ad-hoc for debugging.
- Move system register state into C, using assembly for GPRs and
  exception vectors.
- Fix the EL1 exception frame so that x29 and x30 are saved and restored
  correctly, make the frame 16-byte aligned, and use generated offsets instead
  of hard-coded values.
- Use the EL12 system-register aliases when accessing guest EL1 state from a
  VHE host.
- Fix the demand-paging test's IPA placement to avoid the identity-mapped guest
  code region and verify the expected data value explicitly.
- Added a new test to test the exception handling.
- Few other small fixes

See the full diff of v3 and v2 at:
  https://gitlab.arm.com/linux-arm/kvm-unit-tests-jg/-/compare/guest_framework_v2..guest_framework_v3

An LLM was used to review the code, and implement the host-state code
and the guest-test.c tests (both were also reviewed by me)

Thanks,
Joey

[1]: https://lore.kernel.org/kvmarm/20260413204630.1149038-1-jingzhangos@google.com/


Jing Zhang (6):
  lib: arm64: Generalize exception vector definitions for EL2 support
  lib: arm64: Add stage2 page table management library
  lib: arm64: Add foundational guest execution framework
  lib: arm64: Add support for guest exit exception handling
  lib: arm64: Add guest-internal exception handling
  arm64: Add Stage-2 MMU demand paging test

Joey Gouly (2):
  lib/alloc_page: check for NULL ptr passed to free_pages()
  arm64: Add basic guest execution tests

 arm/Makefile.arm64         |   5 +
 arm/debug.c                |   6 +-
 arm/gic.c                  |   2 +-
 arm/guest-test.c           | 157 ++++++++++++++
 arm/micro-bench.c          |   4 +-
 arm/mte.c                  |   6 +-
 arm/pl031.c                |   2 +-
 arm/pmu.c                  |   2 +-
 arm/psci.c                 |   2 +-
 arm/selftest.c             |   6 +-
 arm/stage2-mmu-test.c      | 113 +++++++++++
 arm/timer.c                |   6 +-
 lib/alloc_page.c           |   3 +-
 lib/arm64/asm-offsets.c    |  10 +
 lib/arm64/asm/esr.h        |   3 +
 lib/arm64/asm/guest.h      |  99 +++++++++
 lib/arm64/asm/processor.h  |  32 +--
 lib/arm64/asm/stage2_mmu.h |  76 +++++++
 lib/arm64/asm/sysreg.h     |  36 ++++
 lib/arm64/guest.c          | 264 ++++++++++++++++++++++++
 lib/arm64/guest_arch.S     | 223 ++++++++++++++++++++
 lib/arm64/processor.c      |   8 +-
 lib/arm64/stage2_mmu.c     | 406 +++++++++++++++++++++++++++++++++++++
 23 files changed, 1432 insertions(+), 39 deletions(-)
 create mode 100644 arm/guest-test.c
 create mode 100644 arm/stage2-mmu-test.c
 create mode 100644 lib/arm64/asm/guest.h
 create mode 100644 lib/arm64/asm/stage2_mmu.h
 create mode 100644 lib/arm64/guest.c
 create mode 100644 lib/arm64/guest_arch.S
 create mode 100644 lib/arm64/stage2_mmu.c

-- 
2.43.0

