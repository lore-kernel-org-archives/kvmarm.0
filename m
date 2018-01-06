From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v9 0/7] Handle guest RAS Error in KVM and kernel
Date: Sun, 7 Jan 2018 00:02:50 +0800
Message-ID: <1515254577-6460-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, robert.moore@intel.com, lv.zheng@intel.com, james.morse@arm.com, corbet@lwn.net, will.deacon@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org
Cc: gengdongjiu@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

This series patches mainly do below things:

1. Trap guest RAS ERR* registers accesses to EL2 from Non-secure EL1,
   KVM will will do a minimum simulation, these registers are simulated
   to RAZ/WI in KVM.
2. Route guest synchronous External Abort to EL2. If it is also routed
   to EL3 by firmware at the same time, system will trap to EL3 firmware instead
   of EL2 KVM, then firmware judges whether EL2 routing is enabled, if enabled,
   jump back to EL2 KVM, otherwise jump back to EL1 host kernel.
3. Enable APEI ARv8 SEI notification to parse the CPER records for SError
   in the ACPI GHES driver, KVM will call handle_guest_sei() to let ACPI
   driver to parse the CPER recorded for SError which happened in the guest
4. If ACPI driver parsed the CPER record failed, KVM will classify the Error
   through Exception Syndrome Register and do different approaches according
   to Asynchronous Error Type
5. If the guest RAS SError is not propagated and not consumed, this exception
   is precise, we temporarily shut down the VM to isolate the error. For other
   Asynchronous Error Type, KVM directly injects virtual SError with IMPLEMENTATION
   DEFINED ESR or KVM panic if the error is fatal. For the RAS extension, guest
   virtual ESR must be set, because all-zero  means 'RAS error: Uncategorized' instead
   of 'no valid ISS', so set this ESR to IMPLEMENTATION DEFINED by default if user space
   does not specify it.

change since v8:
1. update the patch [1/7] and [2/7] to align this serie.
   https://www.spinics.net/lists/arm-kernel/msg623513.html
   https://www.spinics.net/lists/arm-kernel/msg623520.html
2. In kvm ,check handle_guest_sei()'s return value. If this function return true, stop
   classifying errors.
3. Temporarily shut down the VM to isolate the error for recoverable error (UER)
4. update some patch's commit messages and clean some patches

Dongjiu Geng (5):
  acpi: apei: Add SEI notification type support for ARMv8
  KVM: arm64: Trap RAS error registers and set HCR_EL2's TERR & TEA
  arm64: kvm: Introduce KVM_ARM_SET_SERROR_ESR ioctl
  arm64: kvm: Set Virtual SError Exception Syndrome for guest
  arm64: kvm: handle guest SError Interrupt by categorization

James Morse (1):
  KVM: arm64: Save ESR_EL2 on guest SError

Xie XiuQi (1):
  arm64: cpufeature: Detect CPU RAS Extentions

 Documentation/virtual/kvm/api.txt    | 11 ++++++
 arch/arm/include/asm/kvm_host.h      |  1 +
 arch/arm/kvm/guest.c                 |  9 +++++
 arch/arm64/Kconfig                   | 16 +++++++++
 arch/arm64/include/asm/cpucaps.h     |  3 +-
 arch/arm64/include/asm/esr.h         | 11 ++++++
 arch/arm64/include/asm/kvm_arm.h     |  2 ++
 arch/arm64/include/asm/kvm_emulate.h | 17 +++++++++
 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/asm/sysreg.h      | 15 ++++++++
 arch/arm64/include/asm/system_misc.h |  1 +
 arch/arm64/kernel/cpufeature.c       | 13 +++++++
 arch/arm64/kvm/guest.c               | 14 ++++++++
 arch/arm64/kvm/handle_exit.c         | 68 +++++++++++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/switch.c          | 25 +++++++++++--
 arch/arm64/kvm/inject_fault.c        | 13 ++++++-
 arch/arm64/kvm/reset.c               |  3 ++
 arch/arm64/kvm/sys_regs.c            | 10 ++++++
 arch/arm64/mm/fault.c                | 16 +++++++++
 drivers/acpi/apei/Kconfig            | 15 ++++++++
 drivers/acpi/apei/ghes.c             | 53 ++++++++++++++++++++++++++++
 include/acpi/ghes.h                  |  1 +
 include/uapi/linux/kvm.h             |  3 ++
 virt/kvm/arm/arm.c                   |  7 ++++
 24 files changed, 320 insertions(+), 9 deletions(-)

-- 
1.9.1

