From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v6 00/12] KVM Guest Debug support for arm64
Date: Fri, 19 Jun 2015 13:23:38 +0100
Message-ID: <1434716630-18260-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org
Cc: jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Here is V6 of the KVM Guest Debug support for arm64.

The changes are even more minimal than the last round which is
hopefully a good indication the series is ready for merging:

  API/ABI Changes:
    - returned to using u64 for control registers
    - renamed KVM_GUESTDBG_USE_HW_BP->KVM_GUESTDBG_USE_HW

  Keeping the control registers as 64 bit simplifies a lot of the code
  especially around sys_regs code which is used for trap and emulate
  as well as the GET/SET_ONE_REG interface which treats everything as
  a 64 bit register. Hints have also been dropped that the
  architecture could possibly expand the register one day and this
  makes the ABI future proof against that.

  The ioctl flag re-name was to make it clear that we are setting both
  HW breakpoints and watchpoints.

  Code Changes:
    - Fix endian issues trapped aarch32 debug regs
    - Changes due to control regs -> 64 bit
      - Simplification of the sys_regs
      - Simpler save/restore macro for hyp.S
      - Tracing fixes for new register size

The rest of the changes cover whitespace, spelling, and re-wording of
some of the comments. I've also added some more r-b and s-o-b tags
from the last round of review.

=46or full details see the changelog on each of the patches.

GIT Repos:

The patches for this series are based off v4.1-rc8 and can be found
at:

Kernel:
https://git.linaro.org/people/alex.bennee/linux.git
branch: guest-debug/4.1-rc8-v8

QEMU:
https://github.com/stsquad/qemu
branch: kvm/guest-debug-v6

Alex Benn=C3=A9e (12):
  KVM: add comments for kvm_debug_exit_arch struct
  KVM: arm64: fix misleading comments in save/restore
  KVM: arm64: guest debug, define API headers
  KVM: arm: guest debug, add stub KVM_SET_GUEST_DEBUG ioctl
  KVM: arm: introduce kvm_arm_init/setup/clear_debug
  KVM: arm64: guest debug, add SW break point support
  KVM: arm64: guest debug, add support for single-step
  KVM: arm64: re-factor hyp.S debug register code
  KVM: arm64: introduce vcpu->arch.debug_ptr
  KVM: arm64: guest debug, HW assisted debug support
  KVM: arm64: enable KVM_CAP_SET_GUEST_DEBUG
  KVM: arm64: add trace points for guest_debug debug

 Documentation/virtual/kvm/api.txt      |  15 +-
 arch/arm/include/asm/kvm_host.h        |   4 +
 arch/arm/kvm/arm.c                     |  46 ++-
 arch/arm/kvm/trace.h                   |  17 +
 arch/arm64/include/asm/hw_breakpoint.h |  12 +
 arch/arm64/include/asm/kvm_asm.h       |  26 +-
 arch/arm64/include/asm/kvm_host.h      |  36 ++-
 arch/arm64/include/uapi/asm/kvm.h      |  27 ++
 arch/arm64/kernel/asm-offsets.c        |   7 +
 arch/arm64/kernel/hw_breakpoint.c      |  12 -
 arch/arm64/kvm/Makefile                |   2 +-
 arch/arm64/kvm/debug.c                 | 204 ++++++++++++
 arch/arm64/kvm/handle_exit.c           |  44 +++
 arch/arm64/kvm/hyp.S                   | 550 ++++++++++---------------=
--------
 arch/arm64/kvm/reset.c                 |  15 +
 arch/arm64/kvm/sys_regs.c              | 158 +++++++---
 arch/arm64/kvm/trace.h                 | 105 +++++++
 include/uapi/linux/kvm.h               |   5 +
 18 files changed, 821 insertions(+), 464 deletions(-)
 create mode 100644 arch/arm64/kvm/debug.c

--=20
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe kvm" in
