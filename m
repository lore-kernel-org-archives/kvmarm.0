Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC664155354
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 20:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816133; cv=none; b=tezaPHAxSiiRJUWTfxPN3EZla2yrFZcw0tWAf7YZ0I0paRAvM5Z5flCPUN022I+3nxTi+FMUWIkdvwi/2dIvEjk3NqrAo/ZQqP9Yr81VhKR8yE93V/1Pv6K5SAplTgo5i/2k8kC14j9uiE/egGcIK5aTTjWoiyz0ZHvs3b51j5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816133; c=relaxed/simple;
	bh=H1aQBeHH7NqKcbJs4OPBAMJMmfiu21IpdWTUowIomWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=meqAcPDEWMO2yvP5uwhGqWok77saq/qZRYuRMEaddg28eNNWk4qRHjcJYwZM3gbp7enCp5gwgCi83AWMo4r4YVuF4hfQoofvqDBsKs2gNwfnmCLguwOMtOsa+I5r4Ij4ywfSHIxperHBod8Fds/eDTbjE0z0tXPZUWyCUisIsqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cWdcy+DJ; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cWdcy+DJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xvUcJfsdEuMpQhr6e4VqGZarfLetfx+ve9t3zeaMRwY=;
	b=cWdcy+DJF+BFHXc306LtCh6ebpeGgHLOWjGbPknAq8vgrbdzppliUxYa+n0rX8zGv19KIh
	MNMxoG0DAXPCOxSpWkykLZX978zstbbubSOrswJ/OAvlkcgS36O6BWga8KHS0nW4g/EI92
	mlKzBu7Bh64gQ/0ITlotYmfO3weBoFc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 00/19] KVM: arm64: Transition to a per-ITS translation cache
Date: Mon, 22 Apr 2024 20:01:39 +0000
Message-ID: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


v2: https://lore.kernel.org/kvmarm/20240419223842.951452-1-oliver.upton@linux.dev/

v2 -> v3:
 - Add lockdep assertion to kvm_vfio_create() (Sean)
 - Address intermediate compilation issue in vgic_its_invalidate_cache()
   (Marc)
 - Use a more compact cache index based on the DID/EID range of the ITS
   (Marc)
 - Comment improvements (Marc)
 - Avoid explicit acquisition of the translation cache's xa_lock()
   (Marc)
 - Eliminate the need to disable IRQs to acquire the translation cache's
   xa_lock()
 - Collapse internal helper into vgic_its_check_cache()


Oliver Upton (19):
  KVM: Treat the device list as an rculist
  KVM: arm64: vgic-its: Walk LPI xarray in its_sync_lpi_pending_table()
  KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_invall()
  KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_cmd_handle_movall()
  KVM: arm64: vgic-debug: Use an xarray mark for debug iterator
  KVM: arm64: vgic-its: Get rid of vgic_copy_lpi_list()
  KVM: arm64: vgic-its: Scope translation cache invalidations to an ITS
  KVM: arm64: vgic-its: Maintain a translation cache per ITS
  KVM: arm64: vgic-its: Spin off helper for finding ITS by doorbell addr
  KVM: arm64: vgic-its: Use the per-ITS translation cache for injection
  KVM: arm64: vgic-its: Rip out the global translation cache
  KVM: arm64: vgic-its: Get rid of the lpi_list_lock
  KVM: selftests: Align with kernel's GIC definitions
  KVM: selftests: Standardise layout of GIC frames
  KVM: selftests: Add quadword MMIO accessors
  KVM: selftests: Add a minimal library for interacting with an ITS
  KVM: selftests: Add helper for enabling LPIs on a redistributor
  KVM: selftests: Use MPIDR_HWID_BITMASK from cputype.h
  KVM: selftests: Add stress test for LPI injection

 arch/arm64/kvm/vgic/vgic-debug.c              |  82 ++-
 arch/arm64/kvm/vgic/vgic-init.c               |   8 -
 arch/arm64/kvm/vgic/vgic-its.c                | 352 ++++-------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |   2 +-
 arch/arm64/kvm/vgic/vgic.c                    |   6 +-
 arch/arm64/kvm/vgic/vgic.h                    |   6 +-
 include/kvm/arm_vgic.h                        |  13 +-
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/aarch64/arch_timer.c        |   8 +-
 .../testing/selftests/kvm/aarch64/psci_test.c |   2 +
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  15 +-
 .../selftests/kvm/aarch64/vgic_lpi_stress.c   | 410 ++++++++++++
 .../kvm/aarch64/vpmu_counter_access.c         |   6 +-
 .../selftests/kvm/dirty_log_perf_test.c       |   5 +-
 .../selftests/kvm/include/aarch64/gic.h       |  21 +-
 .../selftests/kvm/include/aarch64/gic_v3.h    | 586 +++++++++++++++++-
 .../kvm/include/aarch64/gic_v3_its.h          |  19 +
 .../selftests/kvm/include/aarch64/processor.h |  19 +-
 .../selftests/kvm/include/aarch64/vgic.h      |   5 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  18 +-
 .../selftests/kvm/lib/aarch64/gic_private.h   |   4 +-
 .../selftests/kvm/lib/aarch64/gic_v3.c        |  99 +--
 .../selftests/kvm/lib/aarch64/gic_v3_its.c    | 248 ++++++++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  38 +-
 virt/kvm/kvm_main.c                           |  14 +-
 virt/kvm/vfio.c                               |   2 +
 26 files changed, 1572 insertions(+), 418 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c


base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
-- 
2.44.0.769.g3c40516874-goog

