Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C8122EE0
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073784; cv=none; b=ZSfOAxPqsYDDVw4K+S0qxZWvPok8ipZBuOB2WTQQ5fxk1TAIQ64KE8d/BjZEKtp+kW9mlNhELrno2EVpJ7ki6JFmbfem8S9nSBhSlLFMVJUyYwDt3+xtS/jFYUCDKugltxxRDMAbIav31VcF7x9IE/J5/ZOO+Hivc7pzg/oE570=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073784; c=relaxed/simple;
	bh=HA7d92vxFZps5K7y0c1w0pgZ7g3IOOxknMcGBQiGL+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=slGnKx8sBQzsabyYOLCbW6LFKCpRVOtNPEaKLzo0nvzduH+OUUwApKTeSrGbLeSrxqyTRfykdsXQXTsn6BmMgyg4YtkpEFV7vU3Xi6dA19lkvO/UK5m/rZ9y6QteAFuce+noFyqWHqhunMf+qCDr3t94geewDbH43MdByQNVgiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tC6N98tX; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tC6N98tX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D1G+awonkXdk5GXjT+f6dKQoSZn4hssIzTEzVmkmkKg=;
	b=tC6N98tX6FKcmATiWtFY09tu6JcuvoyQBR6hWrMO8lqsoK8itAskEF5CHbx0WwxzPDtAUE
	8qZMnE3KqerL6glHWA3ADf4XKCf6jc1Lb0ovsC8dreXOrgH9HwVgAfXRh0zRKus/vs+95F
	xPanqaSVDXgGfEwH6virKo9y0MywU5A=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 00/20] KVM: arm64: Transition to a per-ITS translation cache
Date: Tue, 27 Feb 2024 22:42:29 +0000
Message-ID: <20240227224249.2209194-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As discussed [*], here is the new take on the LPI translation cache,
migrating to an xarray indexed by (devid, eventid) per ITS.

The end result is quite satisfying, as it becomes possible to rip out
other nasties such as the lpi_list_lock. To that end, patches 2-6 aren't
_directly_ related to the translation cache cleanup, but instead are
done to enable the cleanups at the end of the series.

I changed out my test machine from the last time so the baseline has
moved a bit, but here are the results from the vgic_lpi_stress test:

+----------------------------+------------+-------------------+
|       Configuration        |  v6.8-rc1  | v6.8-rc1 + series |
+----------------------------+------------+-------------------+
| -v 1 -d 1 -e 1 -i 1000000  | 2063296.81 |        1362602.35 |
| -v 16 -d 16 -e 16 -i 10000 |  610678.33 |        5200910.01 |
| -v 16 -d 16 -e 17 -i 10000 |  678361.53 |        5890675.51 |
| -v 32 -d 32 -e 1 -i 100000 |  580918.96 |        8304552.67 |
| -v 1 -d 1 -e 17 -i 1000    | 1512443.94 |         1425953.8 |
+----------------------------+------------+-------------------+

Unlike last time, no dramatic regressions at any performance point. The
regression on a single interrupt stream is to be expected, as the
overheads of SRCU and two tree traversals (kvm_io_bus_get_dev(),
translation cache xarray) are likely greater than that of a linked-list
with a single node.

Keep in mind this is a microbenchmark, and the added overhead shouldn't
lead to real-world performance issues.

Applies to kvmarm/next, due to the dependency on the prior LPI rework
going into 6.9.

[*] https://lore.kernel.org/kvmarm/20240213093250.3960069-1-oliver.upton@linux.dev/

Oliver Upton (20):
  KVM: Treat the device list as an rculist
  KVM: arm64: vgic-its: Walk LPI xarray in its_sync_lpi_pending_table()
  KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_invall()
  KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_cmd_handle_movall()
  KVM: arm64: vgic-debug: Use an xarray mark for debug iterator
  KVM: arm64: vgic-its: Get rid of vgic_copy_lpi_list()
  KVM: arm64: vgic-its: Scope translation cache invalidations to an ITS
  KVM: arm64: vgic-its: Spin off helper for finding ITS by doorbell addr
  KVM: arm64: vgic-its: Maintain a translation cache per ITS
  KVM: arm64: vgic-its: Use the per-ITS translation cache for injection
  KVM: arm64: vgic-its: Rip out the global translation cache
  KVM: arm64: vgic-its: Get rid of the lpi_list_lock
  KVM: selftests: Align with kernel's GIC definitions
  KVM: selftests: Standardise layout of GIC frames
  KVM: selftests: Add quadword MMIO accessors
  KVM: selftests: Add a minimal library for interacting with an ITS
  KVM: selftests: Add helper for enabling LPIs on a redistributor
  KVM: selftests: Use MPIDR_HWID_BITMASK from cputype.h
  KVM: selftests: Hack in support for aligned page allocations
  KVM: selftests: Add stress test for LPI injection

 arch/arm64/kvm/vgic/vgic-debug.c              |  82 ++-
 arch/arm64/kvm/vgic/vgic-init.c               |   8 -
 arch/arm64/kvm/vgic/vgic-its.c                | 335 +++-------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |   2 +-
 arch/arm64/kvm/vgic/vgic.c                    |   6 +-
 arch/arm64/kvm/vgic/vgic.h                    |   6 +-
 include/kvm/arm_vgic.h                        |  13 +-
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/aarch64/arch_timer.c        |   8 +-
 .../testing/selftests/kvm/aarch64/psci_test.c |   2 +
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  15 +-
 .../selftests/kvm/aarch64/vgic_lpi_stress.c   | 413 ++++++++++++
 .../kvm/aarch64/vpmu_counter_access.c         |   6 +-
 .../selftests/kvm/dirty_log_perf_test.c       |   5 +-
 .../selftests/kvm/include/aarch64/gic.h       |  21 +-
 .../selftests/kvm/include/aarch64/gic_v3.h    | 586 +++++++++++++++++-
 .../kvm/include/aarch64/gic_v3_its.h          |  19 +
 .../selftests/kvm/include/aarch64/processor.h |  19 +-
 .../selftests/kvm/include/aarch64/vgic.h      |   5 +-
 .../selftests/kvm/include/kvm_util_base.h     |   2 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  18 +-
 .../selftests/kvm/lib/aarch64/gic_private.h   |   4 +-
 .../selftests/kvm/lib/aarch64/gic_v3.c        |  99 +--
 .../selftests/kvm/lib/aarch64/gic_v3_its.c    | 248 ++++++++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  38 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  27 +-
 virt/kvm/kvm_main.c                           |   8 +-
 27 files changed, 1590 insertions(+), 407 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c


base-commit: 8b177908c5fe6e38911f46c82dfa0fec7644d6dc
-- 
2.44.0.rc1.240.g4c46232300-goog

