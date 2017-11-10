From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v8 0/7] Support RAS virtualization in KVM
Date: Sat, 11 Nov 2017 03:54:03 +0800
Message-ID: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, bp@alien8.de, rjw@rjwysocki.net, james.morse@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, gengdongjiu@huawei.com, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

This series patches mainly do below things:

1. Trap RAS ERR* registers Accesses to EL2 from Non-secure EL1,
   KVM will will do a minimum simulation, there registers are simulated
   to RAZ/WI in KVM.
2. Route synchronous External Abort exceptions from Non-secure EL0
   and EL1 to EL2. When exception EL3 routing is enabled by firmware,
   system will trap to EL3 firmware instead of EL2 KVM, then firmware
   judges whether El2 routing is enabled, if enabled, jump to EL2 KVM, 
   otherwise jump to EL1 host kernel.
3. Enable APEI ARv8 SEI notification to parse the CPER records for SError
   in the ACPI GHES driver, KVM will call handle_guest_sei() to let ACPI
   driver to parse the CPER record for SError which happened in the guest
4. Although we can use APEI driver to handle the guest SError, but not all
   system support SEI notification, such as kernel-first. So here KVM will
   also classify the Error through Exception Syndrome Register and do different
   approaches according to Asynchronous Error Type
5. If the guest SError error is not propagated and not consumed, then KVM return
   recoverable error status to user-space, user-space will specify the guest ESR
   and inject a virtual SError. For other Asynchronous Error Type, KVM directly
   injects virtual SError with IMPLEMENTATION DEFINED ESR or KVM is panic if the
   error is fatal. In the RAS extension, guest virtual ESR must be set, because
   all-zero  means 'RAS error: Uncategorized' instead of 'no valid ISS', so set
   this ESR to IMPLEMENTATION DEFINED by default if user space does not specify it.

Dongjiu Geng (5):
  acpi: apei: Add SEI notification type support for ARMv8
  KVM: arm64: Trap RAS error registers and set HCR_EL2's TERR & TEA
  arm64: kvm: Introduce KVM_ARM_SET_SERROR_ESR ioctl
  arm64: kvm: Set Virtual SError Exception Syndrome for guest
  arm64: kvm: handle SError Interrupt by categorization

James Morse (1):
  KVM: arm64: Save ESR_EL2 on guest SError

Xie XiuQi (1):
  arm64: cpufeature: Detect CPU RAS Extentions

 Documentation/virtual/kvm/api.txt    | 11 ++++++
 arch/arm/include/asm/kvm_host.h      |  1 +
 arch/arm/kvm/guest.c                 |  9 +++++
 arch/arm64/Kconfig                   | 16 +++++++++
 arch/arm64/include/asm/barrier.h     |  1 +
 arch/arm64/include/asm/cpucaps.h     |  3 +-
 arch/arm64/include/asm/esr.h         | 15 ++++++++
 arch/arm64/include/asm/kvm_arm.h     |  2 ++
 arch/arm64/include/asm/kvm_asm.h     |  3 ++
 arch/arm64/include/asm/kvm_emulate.h | 17 +++++++++
 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/asm/sysreg.h      | 15 ++++++++
 arch/arm64/include/asm/system_misc.h |  1 +
 arch/arm64/kernel/cpufeature.c       | 13 +++++++
 arch/arm64/kernel/process.c          |  3 ++
 arch/arm64/kvm/guest.c               | 14 ++++++++
 arch/arm64/kvm/handle_exit.c         | 67 +++++++++++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/switch.c          | 31 +++++++++++++++--
 arch/arm64/kvm/inject_fault.c        | 13 ++++++-
 arch/arm64/kvm/reset.c               |  3 ++
 arch/arm64/kvm/sys_regs.c            | 10 ++++++
 arch/arm64/mm/fault.c                | 16 +++++++++
 drivers/acpi/apei/Kconfig            | 15 ++++++++
 drivers/acpi/apei/ghes.c             | 53 ++++++++++++++++++++++++++++
 include/acpi/ghes.h                  |  1 +
 include/uapi/linux/kvm.h             |  3 ++
 virt/kvm/arm/arm.c                   |  7 ++++
 27 files changed, 336 insertions(+), 9 deletions(-)

-- 
1.9.1
