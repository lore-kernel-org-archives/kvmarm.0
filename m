From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 00/14] arm64: Add SMCCC v1.1 support and CVE-2017-5715
Date: Fri, 26 Jan 2018 14:28:33 +0000
Message-ID: <20180126142847.31240-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8376349D36
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jan 2018 09:23:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f5PMp4Hy9lCJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jan 2018 09:23:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 838D849D32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jan 2018 09:23:33 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

ARM has recently published a SMC Calling Convention (SMCCC)
specification update[1] that provides an optimised calling convention
and optional, discoverable support for mitigating CVE-2017-5715. ARM
Trusted Firmware (ATF) has already gained such an implementation[2].

This series addresses a few things:

- It provides a KVM implementation of PSCI v1.0, which is a
  prerequisite for being able to discover SMCCC v1.1, together with a
  new userspace API to control the PSCI revision number that the guest
  sees.

- It allows KVM to advertise SMCCC v1.1, which is de-facto supported
  already (it never corrupts any of the guest registers).

- It implements KVM support for the ARCH_WORKAROUND_1 function that is
  used to mitigate CVE-2017-5715 in a guest (if such mitigation is
  available on the host).

- It implements SMCCC v1.1 and ARCH_WORKAROUND_1 discovery support in
  the kernel itself.

- It finally provides firmware callbacks for CVE-2017-5715 for both
  kernel and KVM.

This method is intended to fully replace the initial PSCI_GET_VERSION
approach. Although PSCI_GET_VERSION still works, it has an obvious
overhead and is called on some of the hottest paths. We expect
ARCH_WORKAROUND_1 to be much faster.

Patch 1 is already merged, and included here for reference. Patches on
top of arm64/for-next/core. Tested on Seattle and Juno, the latter
with ATF implementing SMCCC v1.1.

[1]: https://developer.arm.com/-/media/developer/pdf/ARM%20DEN%200070A%20Firmware%20interfaces%20for%20mitigating%20CVE-2017-5715_V1.0.pdf

Hopefully this link is a persistent one. It is otherwise linked to
from [3], which is persistent.

[2]: https://github.com/ARM-software/arm-trusted-firmware/pull/1240

[3]: https://developer.arm.com/support/security-update/frequently-asked-questions

Marc Zyngier (14):
  arm64: KVM: Fix SMCCC handling of unimplemented SMC/HVC calls
  arm: KVM: Fix SMCCC handling of unimplemented SMC/HVC calls
  arm/arm64: KVM: Consolidate the PSCI include files
  arm/arm64: KVM: Add PSCI_VERSION helper
  arm/arm64: KVM: Add smccc accessors to PSCI code
  arm/arm64: KVM: Implement PSCI 1.0 support
  arm/arm64: KVM: Add PSCI version selection API
  arm/arm64: KVM: Advertise SMCCC v1.1
  arm/arm64: KVM: Turn kvm_psci_version into a static inline
  arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
  arm64: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast handling
  firmware/psci: Expose PSCI conduit
  firmware/psci: Expose SMCCC version through psci_ops
  arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support

 Documentation/virtual/kvm/api.txt      |   3 +-
 Documentation/virtual/kvm/arm/psci.txt |  30 +++++
 arch/arm/include/asm/kvm_host.h        |   3 +
 arch/arm/include/asm/psci.h            |  25 ----
 arch/arm/include/uapi/asm/kvm.h        |   6 +
 arch/arm/kvm/guest.c                   |  13 +++
 arch/arm/kvm/handle_exit.c             |   8 +-
 arch/arm64/include/asm/kvm_host.h      |   3 +
 arch/arm64/include/asm/kvm_psci.h      |  27 -----
 arch/arm64/include/uapi/asm/kvm.h      |   6 +
 arch/arm64/kernel/bpi.S                |  20 ++++
 arch/arm64/kernel/cpu_errata.c         |  71 +++++++++++-
 arch/arm64/kvm/guest.c                 |  14 ++-
 arch/arm64/kvm/handle_exit.c           |   9 +-
 arch/arm64/kvm/hyp/hyp-entry.S         |  20 +++-
 arch/arm64/kvm/hyp/switch.c            |  20 ++--
 drivers/firmware/psci.c                |  48 +++++++-
 include/kvm/arm_psci.h                 |  63 ++++++++++
 include/linux/arm-smccc.h              |  18 +++
 include/linux/psci.h                   |  13 +++
 virt/kvm/arm/arm.c                     |   2 +-
 virt/kvm/arm/psci.c                    | 202 +++++++++++++++++++++++++++++----
 22 files changed, 522 insertions(+), 102 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/psci.txt
 delete mode 100644 arch/arm/include/asm/psci.h
 delete mode 100644 arch/arm64/include/asm/kvm_psci.h
 create mode 100644 include/kvm/arm_psci.h

-- 
2.14.2
