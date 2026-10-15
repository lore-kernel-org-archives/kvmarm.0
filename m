Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83037530DE1
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074371; cv=none; b=KWftZhY7Wm+bYkFyKPynyM5amqu+zwFAkXKVAwxMPy5AJ2P/B6HmXDsIo3lOZkWI49fVUuMs7hZSSEEP5kIUb4ctmMhhpmCNTNQfaGR/oCjL6Sinb789C2P0Qz9+z+k3VgbynETUvD934ZQJHFwQnm3W2I+swHipupDQRUXzVtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074371; c=relaxed/simple;
	bh=nRMhCWv1VYJE0ooCA755xJ6dFPiezH5+ScPUC6Dphts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aPr3jz4T+D4V91336FpJ/aChJb7hfK4WMr43aWqGuW9wmyr2Cf0wXTyx4gr/GU/B+n3J8XOSybdOhzHUGjf9I/hx8FDCFoBGyPiYQ/M//ORUepQ5pVlB6vailt6YRfTM50L3JG/GHOZ/BNiXzAFmpaekDymRHv25FIb/nqEGsy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QcG0e46u; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QcG0e46u"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CC911477;
	Thu, 15 Oct 2026 07:26:00 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6F6B3F871;
	Thu, 15 Oct 2026 07:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074363; bh=nRMhCWv1VYJE0ooCA755xJ6dFPiezH5+ScPUC6Dphts=;
	h=From:To:Cc:Subject:Date:From;
	b=QcG0e46uz/7hlMfHpaXW1ozPdaqgTVqNUy1PeqfN2lkSTvz+SkpiTinzKAox+EXrg
	 W5meia0bwgyrfC9AS0HoJ9neI2kdDzSj5qtgQAsmYJNv3ddD/rPgPHM7kPSfjc15/J
	 oEU9YCoUQojOnp17pewfxUDuFTan4gdxPZ/GD0Mc=
From: Ryan Roberts <ryan.roberts@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 00/15] Arm Core Local Accelerator Driver
Date: Thu, 15 Oct 2026 15:25:34 +0100
Message-ID: <20261015142552.4128028-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi All,

This is v2 of an RFC to introduce a driver for the Arm Core Local Accelerator
(CLA), a CPU-local interface for programming attached accelerators. While the
interface is agnostic to the accelerator type, the initial (and currently only)
target is a compute engine.

The RFC aims to engage the community and get feedback on some key aspects. This
will help plan our approach for eventual upstreaming. Based on feedback from
Will and Marc in RFCv1, the driver now supports both bare metal and virtualized
environments. I also have commitments to publish the CLA spec, a supporting FVP
and a representaive user space, all to support upstreaming the driver, as per
Will's feedback.

For now you can find documentation included with patch 1, which describes the HW
and driver design. Note that the CLA is not part of the Arm Architecture.

Patch 1 documents the hardware and driver design, and adds a driver skeleton.
Patches 2-5 initialize and probe the device. Patches 6-9 add context management
for switching the device between different users. Patches 10-12 add some (small)
changes to KVM and VFIO, which then enables patches 13-15 to expose the HW for
device assignment into a VM.

Aspects I'm seeking feedback for:

* The general structure of the driver: The current shape addresses the
  performance requirements we have for the use cases, and is therefore our
  preferred approach. But there are some unusual aspects due to the HW design.

* Driver interaction with architectural support: I've opted to treat the CLA as
  a device rather than a CPU extension, so it's implemented as a (mostly)
  self-contained driver. It has some unavoidable coupling to the arch code since
  it needs to share page tables and ASIDs/VMIDs. All arm64 arch interaction is
  contained in cla-mtc.c.

* The location of the driver: although most accelerators will likely be compute
  ones, CLA is a generic MMIO interface that could handle any kind of
  accelerator. It's currently implemented as a misc driver. accel is another
  potential option, but given the current SVA approach, we would not use any of
  the services (memory-management or otherwise) that accel provides.

* Virtualization support: since the HW uses the CPU's MMU, we introduced a new
  VFIO_CPU_MMU group type, and added the kvm_arch_[get|put]_guest_mmu() API to
  KVM/arm64 so that the CLA can share the stage2 pgtables and VMID. The CPU
  pinning problem remains unsolved; the vCPU must be pinned to the pCPU that
  owns the CLA in order to access it. If the pCPU goes offline or the vCPU is
  otherwise unpinned, it would look to the guest like the HW is faulty. This
  issue is therefore contained to the guest. I've additionally improved the
  robustness of the core driver to deal with this eventuality gracefully.

I consider the core driver to be well tested and robust. The virtualization
portion is prototype and has known issues that would be addressed assuming the
approach gets positive feedback.

Changes since RFCv1 [1]
=======================

 - Added KVM guest support through VFIO mdev, including exclusive domain
   assignment, stage-2 memory translation and VMID pinning
 - Changed the userspace ABI to expose one `/dev/cla/<class-id>` device per
   accelerator class; `ARM_CLA_PARAM_DEV_ACCELS` now reports only accelerators
   belonging to the opened class (per Arnd)
 - Removed `ARM_CLA_UABI_VERSION` and the `ARM_CLA_PARAM_UABI_VERSION` query
   (per Arnd)
 - Various driver bug fixes and robustness improvements


Source, along with some tests, is available at [2]. Patches based on v7.3-rc5.

[1] https://lore.kernel.org/all/20260717104759.123203-1-ryan.roberts@arm.com/
[2] https://gitlab.arm.com/linux-arm/linux-rr/-/tree/features/cla-driver-v2-rfc-tests

Thanks,
Ryan


Jean-Philippe Brucker (10):
  misc/arm-cla: Add driver skeleton and documentation
  misc/arm-cla: Add launch operation helpers
  misc/arm-cla: Probe firmware-described devices
  misc/arm-cla: Initialize devices on CPU bringup
  misc/arm-cla: Accelerator context save and restore
  KVM: arm64: Export stage-2 MMU config
  vfio: Support VFIO devices that access the CPU MMU
  misc/arm-cla: Add stage-2 MTC and VM context switch
  misc/arm-cla: Support exclusive context assignment
  misc/arm-cla: Add vfio-mdev user interface

Ryan Roberts (4):
  dt-bindings: misc: Add Arm Core Local Accelerator
  misc/arm-cla: Set up memory translation context
  misc/arm-cla: Manage domain contexts
  misc/arm-cla: Add userspace interface

Shameer Kolothum (1):
  KVM: arm64: Introduce support to pin VMIDs

 .../devicetree/bindings/misc/arm,cla.yaml     |  77 +++
 Documentation/misc-devices/arm-cla.rst        | 217 +++++++
 Documentation/misc-devices/index.rst          |   1 +
 MAINTAINERS                                   |   9 +
 arch/arm64/include/asm/kvm_host.h             |  14 +
 arch/arm64/include/asm/kvm_mmu.h              |   1 +
 arch/arm64/kvm/mmu.c                          | 102 ++++
 arch/arm64/kvm/sys_regs.c                     |  14 +-
 arch/arm64/kvm/vmid.c                         |  77 ++-
 drivers/misc/Kconfig                          |   1 +
 drivers/misc/Makefile                         |   1 +
 drivers/misc/arm-cla/Kconfig                  |  26 +
 drivers/misc/arm-cla/Makefile                 |  15 +
 drivers/misc/arm-cla/arm-cla-regs.h           | 192 ++++++
 drivers/misc/arm-cla/arm-cla.h                | 393 ++++++++++++
 drivers/misc/arm-cla/cla-ctx.c                | 229 +++++++
 drivers/misc/arm-cla/cla-init.c               | 562 ++++++++++++++++++
 drivers/misc/arm-cla/cla-mdev.c               | 469 +++++++++++++++
 drivers/misc/arm-cla/cla-mtc.c                | 335 +++++++++++
 drivers/misc/arm-cla/cla-ops.c                | 417 +++++++++++++
 drivers/misc/arm-cla/cla-regs.c               | 370 ++++++++++++
 drivers/misc/arm-cla/cla-sched.c              | 474 +++++++++++++++
 drivers/misc/arm-cla/cla-topology.c           | 202 +++++++
 drivers/misc/arm-cla/cla-user.c               | 541 +++++++++++++++++
 drivers/vfio/group.c                          |  37 +-
 drivers/vfio/vfio.h                           |   5 +
 drivers/vfio/vfio_main.c                      |  16 +-
 include/linux/vfio.h                          |   1 +
 include/uapi/linux/arm-cla.h                  | 198 ++++++
 29 files changed, 4969 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/arm,cla.yaml
 create mode 100644 Documentation/misc-devices/arm-cla.rst
 create mode 100644 drivers/misc/arm-cla/Kconfig
 create mode 100644 drivers/misc/arm-cla/Makefile
 create mode 100644 drivers/misc/arm-cla/arm-cla-regs.h
 create mode 100644 drivers/misc/arm-cla/arm-cla.h
 create mode 100644 drivers/misc/arm-cla/cla-ctx.c
 create mode 100644 drivers/misc/arm-cla/cla-init.c
 create mode 100644 drivers/misc/arm-cla/cla-mdev.c
 create mode 100644 drivers/misc/arm-cla/cla-mtc.c
 create mode 100644 drivers/misc/arm-cla/cla-ops.c
 create mode 100644 drivers/misc/arm-cla/cla-regs.c
 create mode 100644 drivers/misc/arm-cla/cla-sched.c
 create mode 100644 drivers/misc/arm-cla/cla-topology.c
 create mode 100644 drivers/misc/arm-cla/cla-user.c
 create mode 100644 include/uapi/linux/arm-cla.h

--
2.43.0

