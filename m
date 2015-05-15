From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v4 00/12] KVM Guest Debug support for arm64
Date: Fri, 15 May 2015 15:27:03 +0100
Message-ID: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org
Cc: jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

Here is V4 of the KVM Guest Debug support for arm64.

The changes are all due to Christoffer's review of v3 and sees a few
tweaks. The main change to the debug register code means we no longer
overlay the registers in sys_reg[] context but have specific areas for
the vcpu_debug_state and external_debug_state. As a result the need to
__u64 align the registers has been removed and we now have:

#define KVM_ARM_MAX_DBG_REGS 16
struct kvm_guest_debug_arch {
        __u32 dbg_bcr[KVM_ARM_MAX_DBG_REGS];
        __u64 dbg_bvr[KVM_ARM_MAX_DBG_REGS];
        __u32 dbg_wcr[KVM_ARM_MAX_DBG_REGS];
        __u64 dbg_wvr[KVM_ARM_MAX_DBG_REGS];
};

There are additional comments to clarify how we handle trapping and
preserving registers.

=46or full details see the changelog on each of the patches.

GIT Repos:

The patches for this series are based off v4.1-rc3 and can be found
at:

https://git.linaro.org/people/alex.bennee/linux.git
branch: guest-debug/4.1-rc3-v4

I'm still in the process of going through the QEMU comments and adding
the re-injection support. However the current working state can be
seen at:

https://github.com/stsquad/qemu
branch: kvm/guest-debug-v4

Alex Benn=C3=A9e (12):
  KVM: add comments for kvm_debug_exit_arch struct
  KVM: define common KVM_GUESTDBG_USE_SW/HW_BP bits
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
 arch/arm64/include/asm/kvm_host.h      |  30 +-
 arch/arm64/include/uapi/asm/kvm.h      |  18 ++
 arch/arm64/kernel/asm-offsets.c        |   7 +
 arch/arm64/kernel/hw_breakpoint.c      |  12 -
 arch/arm64/kvm/Makefile                |   2 +-
 arch/arm64/kvm/debug.c                 | 203 ++++++++++++
 arch/arm64/kvm/handle_exit.c           |  44 +++
 arch/arm64/kvm/hyp.S                   | 545 ++++++++++---------------=
--------
 arch/arm64/kvm/reset.c                 |  15 +
 arch/arm64/kvm/sys_regs.c              | 136 ++++++--
 arch/arm64/kvm/trace.h                 | 105 +++++++
 arch/powerpc/include/uapi/asm/kvm.h    |   4 +-
 arch/s390/include/uapi/asm/kvm.h       |   2 -
 arch/x86/include/uapi/asm/kvm.h        |   2 -
 include/uapi/linux/kvm.h               |  11 +-
 21 files changed, 798 insertions(+), 458 deletions(-)
 create mode 100644 arch/arm64/kvm/debug.c

--=20
2.3.5

