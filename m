Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABDA84FCE
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566354; cv=none; b=llt2u7xPUr0JvK/EZjsRfx14Cc7+gzaYsZpw45/lwFIb+8o5dc2HDJr+VP+uoUdoC4NKI0nYz2YEHdZq/dzpPfvttW4nh9er0VHflVRFA4TZwHypOrsrJk7UshwrwAdBJVYmIakhWeKWLGFn3U6jzjgSoFsVEdEyLXADa16QQW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566354; c=relaxed/simple;
	bh=J0llk+kjeclR7JroQX4O+5ZELLLJ/xmjw9YWLIweYyI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hQwj3qmTjZ5c/R3fkrntoMM5mewGE0BcMXAzzr13nSx2P6ZrCs8ZKSn0TlQaD4if6I4RCoWPjh4XcEeR6UMloyY27ckkws683xHeRf6HhH+ewRQ+8w4mnWI1wJfpxh58JpCyk6Q3PLdckjWgXhf0d38wZgvvuoH2NfjkmPOIwCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YJ6gYz98; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YJ6gYz98"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ljM18/iFyG6cNR987k2TdzFRJC60ZeJTTlFbedQybvw=;
	b=YJ6gYz98B8Chni5lhtrcI7fLZlojscYBWQsgi9LdWZVyIu/iMcrHyZ9O07ffyM33ec4uUB
	yk5O6jsIqUIC1ETGHQ8Atec+IC37e2DCIDTfVPEb0Kx77hE7me008v8ZvjLkP786aEwZUT
	6+uKZaT+9ukUhExgVUscOrWci8GccEg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 00/19] KVM: arm64: Transition to a per-ITS translation cache
Date: Fri, 19 Apr 2024 22:38:23 +0000
Message-ID: <20240419223842.951452-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now that I'm back from vacation, time to torture you all with GIC
changes. Now with fewer bugs!

Have a look at v1 for the full cover letter.

v1: https://lore.kernel.org/kvmarm/20240227224249.2209194-1-oliver.upton@linux.dev/

v1 -> v2:
 - Fully bake my attempt at converting the device list to an rculist
   (Sean, Paolo)
 - Drop Paolo's Ack (see above)
 - Rebase to v6.9-rc3

Oliver Upton (19):
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
  KVM: selftests: Add stress test for LPI injection

 arch/arm64/kvm/vgic/vgic-debug.c              |  82 ++-
 arch/arm64/kvm/vgic/vgic-init.c               |   8 -
 arch/arm64/kvm/vgic/vgic-its.c                | 334 +++-------
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
 25 files changed, 1567 insertions(+), 403 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c


base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
-- 
2.44.0.769.g3c40516874-goog

