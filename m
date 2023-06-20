Received: from out-39.mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113C3200A2
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 16:34:12 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687278850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xcRVuhONyC7dT/WLBQhivasfcDQUdqa+TcGrJypZ0P4=;
	b=d2eZBy0Hf63C6RtHxmhcZVYecWbgT6St2PrAzNeUdxemz0BmQJ5cAyC9i5B+NC/eiMrjVs
	WL7BfDu2zFbTh35nAaWDCs5VHifiuL59ylJycKNqmFOHezJ+38FFrjyirLibbYlJGF+gIe
	KT40uaR/n3xGRx310oqBwypuN7SiqhU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 00/20] arm64: Handle PSCI calls in userspace
Date: Tue, 20 Jun 2023 11:33:33 -0500
Message-ID: <20230620163353.2688567-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v2 of the series for doing PSCI calls in userspace.

Changes since v1 [*]:
 - Avoid successive calls to KVM_ARM_VCPU_FINALIZE (Joey)
 - Clear the 'paused' state from calling vCPU in kvm_cpu__continue_vm()
   (Shaoqin)

[*] https://lore.kernel.org/kvmarm/20230526221712.317287-1-oliver.upton@linux.dev/

Oliver Upton (20):
  update_headers: Use a list for arch-generic headers
  update_headers: Add missing entries to list of headers to copy
  Copy 64-bit alignment attrtibutes from Linux 6.4-rc1
  Update headers with Linux 6.4-rc1
  Import arm-smccc.h from Linux 6.4-rc1
  aarch64: Copy cputype.h from Linux 6.4-rc1
  arm: Stash kvm_vcpu_init for later use
  arm: Use KVM_SET_MP_STATE ioctl to power off non-boot vCPUs
  aarch64: Expose ARM64_CORE_REG() for general use
  arm: Generalize execution state specific VM initialization
  Add helpers to pause the VM from vCPU thread
  aarch64: Add support for finding vCPU for given MPIDR
  aarch64: Add skeleton implementation for PSCI
  aarch64: psci: Implement CPU_SUSPEND
  aarch64: psci: Implement CPU_OFF
  aarch64: psci: Implement CPU_ON
  aarch64: psci: Implement AFFINITY_INFO
  aarch64: psci: Implement MIGRATE_INFO_TYPE
  aarch64: psci: Implement SYSTEM_{OFF,RESET}
  aarch64: smccc: Start sending PSCI to userspace

 Makefile                                  |   4 +-
 arm/aarch32/include/kvm/kvm-arch.h        |   2 +-
 arm/aarch32/kvm-cpu.c                     |   5 +
 arm/aarch64/include/asm/cputype.h         | 186 +++++
 arm/aarch64/include/asm/kvm.h             |  38 +
 arm/aarch64/include/asm/smccc.h           |  65 ++
 arm/aarch64/include/kvm/kvm-arch.h        |   2 +-
 arm/aarch64/include/kvm/kvm-config-arch.h |   6 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |  28 +-
 arm/aarch64/kvm-cpu.c                     |  48 +-
 arm/aarch64/kvm.c                         |  25 +-
 arm/aarch64/psci.c                        | 207 +++++
 arm/aarch64/smccc.c                       |  81 ++
 arm/include/arm-common/kvm-arch.h         |   2 +
 arm/include/arm-common/kvm-config-arch.h  |   1 +
 arm/include/arm-common/kvm-cpu-arch.h     |   2 +-
 arm/kvm-cpu.c                             |  21 +-
 arm/kvm.c                                 |   2 +-
 include/kvm/kvm-cpu.h                     |   3 +
 include/linux/arm-smccc.h                 | 240 ++++++
 include/linux/kvm.h                       |  55 +-
 include/linux/psci.h                      |  47 ++
 include/linux/types.h                     |  13 +
 include/linux/vfio.h                      | 920 +++++++++++++++++++++-
 include/linux/vhost.h                     | 186 ++---
 include/linux/virtio_blk.h                | 105 +++
 include/linux/virtio_net.h                |   4 +
 kvm-cpu.c                                 |  16 +
 riscv/include/asm/kvm.h                   |   3 +
 util/update_headers.sh                    |  25 +-
 x86/include/asm/kvm.h                     |  50 +-
 31 files changed, 2213 insertions(+), 179 deletions(-)
 create mode 100644 arm/aarch64/include/asm/cputype.h
 create mode 100644 arm/aarch64/include/asm/smccc.h
 create mode 100644 arm/aarch64/psci.c
 create mode 100644 arm/aarch64/smccc.c
 create mode 100644 include/linux/arm-smccc.h


base-commit: 3b1cdcf9e78f7d36f0cca805c4172bba53779b69
-- 
2.41.0.162.gfafddb0af9-goog

