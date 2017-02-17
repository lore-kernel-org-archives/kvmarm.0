From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 00/20] arm/arm64: KVM: Rework the hyp-stub API
Date: Fri, 17 Feb 2017 15:44:09 +0000
Message-ID: <20170217154429.5000-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EF6D40D8E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 10:44:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 58wHzQjxox-L for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Feb 2017 10:44:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A82DF40C66
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 10:44:21 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Russell King <linux@arm.linux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
could do with some TLC (it cannot perform a soft-restart at HYP, and
has holes in the hyp-stub support in a number of places).

This series implements the following:
- Add HVC_[GS]ET_VECTORS and HVC_SOFT_RESTART to the 32bit code
- Add HVC_RESET_VECTORS to both arm and arm64, removing the need for
  __hyp_reset_vectors
- Implement add the stub entry points in the KVM init code, which
  didn't implement any so far
- Convert the HYP code to use the init code stubs directly
- Add some API documentation that covers the above

Patches 9 and 10 would be better squashed into 7 and 8, but I've kept
separate so that I can take the blame for everything I've broken.

This has been tested on arm and arm64, both as host and guest.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-December/473472.html

Marc Zyngier (18):
  arm64: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
  arm64: KVM: Implement HVC_RESET_VECTORS stub hypercall
  arm64: KVM: Implement HVC_GET_VECTORS in the init code
  arm64: KVM: Allow the main HYP code to use the init hyp stub
    implementation
  arm64: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
  arm64: KVM: Implement HVC_SOFT_RESTART in the init code
  ARM: KVM: Convert KVM to use HVC_GET_VECTORS
  ARM: hyp-stub: Use r1 for the soft-restart address
  ARM: Expose the VA/IDMAP offset
  ARM: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
  ARM: KVM: Implement HVC_RESET_VECTORS stub hypercall
  ARM: KVM: Implement HVC_GET_VECTORS in the init code
  ARM: KVM: Allow the main HYP code to use the init hyp stub
    implementation
  ARM: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
  ARM: KVM: Implement HVC_SOFT_RESTART in the init code
  arm/arm64: KVM: Simplify __cpu_reset_hyp_mode
  arm/arm64: KVM: Remove kvm_get_idmap_start
  arm/arm64: Add hyp-stub API documentation

Russell King (2):
  ARM: hyp-stub: improve ABI
  ARM: soft-reboot into same mode that we entered the kernel

 Documentation/virtual/kvm/arm/hyp-abi.txt | 48 +++++++++++++++++++++++++
 arch/arm/include/asm/kvm_asm.h            |  2 --
 arch/arm/include/asm/kvm_host.h           |  6 ++--
 arch/arm/include/asm/kvm_mmu.h            |  1 -
 arch/arm/include/asm/proc-fns.h           |  4 +--
 arch/arm/include/asm/virt.h               | 11 ++++++
 arch/arm/kernel/hyp-stub.S                | 44 ++++++++++++++++++++---
 arch/arm/kernel/reboot.c                  |  7 ++--
 arch/arm/kvm/arm.c                        |  3 +-
 arch/arm/kvm/hyp/hyp-entry.S              | 29 +++++++++++++---
 arch/arm/kvm/init.S                       | 58 ++++++++++++++++++++++++++-----
 arch/arm/kvm/mmu.c                        |  5 ---
 arch/arm/mm/mmu.c                         |  5 +++
 arch/arm/mm/proc-v7.S                     | 12 ++++---
 arch/arm64/include/asm/kvm_asm.h          |  1 -
 arch/arm64/include/asm/kvm_host.h         |  7 ++--
 arch/arm64/include/asm/kvm_mmu.h          |  1 -
 arch/arm64/include/asm/virt.h             |  8 +++++
 arch/arm64/kernel/hyp-stub.S              | 13 ++++++-
 arch/arm64/kvm/hyp-init.S                 | 50 ++++++++++++++++++++------
 arch/arm64/kvm/hyp/hyp-entry.S            | 39 ++++++++++-----------
 21 files changed, 278 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/hyp-abi.txt

-- 
2.11.0
