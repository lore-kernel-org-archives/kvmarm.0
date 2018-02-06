From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 00/17] arm64: Add SMCCC v1.1 support and CVE-2017-5715 (Spectre variant 2) mitigation
Date: Tue,  6 Feb 2018 17:56:04 +0000
Message-ID: <20180206175621.929-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

ARM has recently published a SMC Calling Convention (SMCCC)
specification update[1] that provides an optimised calling convention
and optional, discoverable support for mitigating CVE-2017-5715. ARM
Trusted Firmware (ATF) has already gained such an implementation[2].

This series addresses a few things:

- It provides a KVM implementation of PSCI v1.0, which is a
  prerequisite for being able to discover SMCCC v1.1.

- It allows KVM to advertise SMCCC v1.1, which is de-facto supported
  already (it never corrupts any of the guest registers).

- It implements KVM support for the ARCH_WORKAROUND_1 function that is
  used to mitigate CVE-2017-5715 in a guest (if such mitigation is
  available on the host).

- It implements SMCCC v1.1 and ARCH_WORKAROUND_1 discovery support in
  the kernel itself.

- It finally provides firmware callbacks for CVE-2017-5715 for both
  kernel and KVM and drop the initial PSCI_GET_VERSION based
  mitigation.

Patch 1 is already merged, and included here for reference. Patches on
top of arm64/for-next/core. Tested on Seattle and Juno, the latter
with ATF implementing SMCCC v1.1.

[1]: https://developer.arm.com/support/security-update/downloads/

[2]: https://github.com/ARM-software/arm-trusted-firmware/pull/1240

* From v3:
  - Dropped KVM PSCI version selection API for the time being, planning
  to resend it after -rc1
  - Some minor cleanups
  - Collected Acks, TBs and RBs.

* From v2:
  - Fixed SMC handling in KVM
  - PSCI fixes and tidying up
  - SMCCC primitive rework for better code generation (both efficiency
  and correctness)
  - Remove PSCI_GET_VERSION as a mitigation vector

* From v1:
  - Fixed 32bit build
  - Fix function number sign extension (Ard)
  - Inline SMCCC v1.1 primitives (cpp soup)
  - Prevent SMCCC spamming on feature probing
  - Random fixes and tidying up

Marc Zyngier (17):
  arm64: KVM: Fix SMCCC handling of unimplemented SMC/HVC calls
  arm: KVM: Fix SMCCC handling of unimplemented SMC/HVC calls
  arm64: KVM: Increment PC after handling an SMC trap
  arm/arm64: KVM: Consolidate the PSCI include files
  arm/arm64: KVM: Add PSCI_VERSION helper
  arm/arm64: KVM: Add smccc accessors to PSCI code
  arm/arm64: KVM: Implement PSCI 1.0 support
  arm/arm64: KVM: Advertise SMCCC v1.1
  arm/arm64: KVM: Turn kvm_psci_version into a static inline
  arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
  arm64: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast handling
  firmware/psci: Expose PSCI conduit
  firmware/psci: Expose SMCCC version through psci_ops
  arm/arm64: smccc: Make function identifiers an unsigned quantity
  arm/arm64: smccc: Implement SMCCC v1.1 inline primitive
  arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support
  arm64: Kill PSCI_GET_VERSION as a variant-2 workaround

 arch/arm/include/asm/kvm_host.h   |   7 ++
 arch/arm/include/asm/kvm_psci.h   |  27 -------
 arch/arm/kvm/handle_exit.c        |  17 +++-
 arch/arm64/include/asm/kvm_host.h |   6 ++
 arch/arm64/include/asm/kvm_psci.h |  27 -------
 arch/arm64/kernel/bpi.S           |  44 +++++-----
 arch/arm64/kernel/cpu_errata.c    |  77 ++++++++++++++----
 arch/arm64/kvm/handle_exit.c      |  18 ++++-
 arch/arm64/kvm/hyp/hyp-entry.S    |  20 ++++-
 arch/arm64/kvm/hyp/switch.c       |  14 +---
 drivers/firmware/psci.c           |  55 +++++++++++--
 include/kvm/arm_psci.h            |  51 ++++++++++++
 include/linux/arm-smccc.h         | 165 +++++++++++++++++++++++++++++++++++++-
 include/linux/psci.h              |  13 +++
 include/uapi/linux/psci.h         |   3 +
 virt/kvm/arm/arm.c                |   2 +-
 virt/kvm/arm/psci.c               | 143 +++++++++++++++++++++++++++------
 17 files changed, 542 insertions(+), 147 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_psci.h
 delete mode 100644 arch/arm64/include/asm/kvm_psci.h
 create mode 100644 include/kvm/arm_psci.h

-- 
2.14.2
