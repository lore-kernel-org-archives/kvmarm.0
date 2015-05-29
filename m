From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v5 00/12] KVM Guest Debug support for arm64
Date: Fri, 29 May 2015 10:30:16 +0100
Message-ID: <1432891828-4816-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org
Cc: jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Here is V5 of the KVM Guest Debug support for arm64.

The changes are fairly minimal from the last round:

  - dropped KVM_GUESTDBG_USE_SW/HW_BP unifying patch (ABI break)
  - new comment patch to fix comments in hyp.S (also sent separately)
  - simplified singlestep code (no longer needs to preserve pstate)
  - don't set MDSCR_EL1.KDE (not needed)

=46or full details see the changelog on each of the patches.

GIT Repos:

The patches for this series are based off v4.1-rc5 and can be found
at:

https://git.linaro.org/people/alex.bennee/linux.git
branch: guest-debug/4.1-rc5-v5

While adding debug exception injection support into QEMU I ran into
problem with GDB in the guest which relies on working single step
support. So while guest SW BKPTs get delivered (and HW BKPTs if the
host is not using them) GDB tends to get confused as it tries to
single step. If the host isn't doing any debugging of the guest then
everything works as normal.

The actual solution would be to fully emulate single step in QEMU by
creating a new debug event when the guest sets MDSCR_EL1.SS. QEMU
would then need to ensure the correct position is reached while
honouring the guests setting of MDSCR_EL1.KDE. However this would be a
bunch of potentially hairy new code so I've left this as an exercise
for a future patch series.

https://github.com/stsquad/qemu
branch: kvm/guest-debug-v5

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
 arch/arm64/include/asm/kvm_host.h      |  29 +-
 arch/arm64/include/uapi/asm/kvm.h      |  20 ++
 arch/arm64/kernel/asm-offsets.c        |   7 +
 arch/arm64/kernel/hw_breakpoint.c      |  12 -
 arch/arm64/kvm/Makefile                |   2 +-
 arch/arm64/kvm/debug.c                 | 194 ++++++++++++
 arch/arm64/kvm/handle_exit.c           |  44 +++
 arch/arm64/kvm/hyp.S                   | 551 ++++++++++---------------=
--------
 arch/arm64/kvm/reset.c                 |  15 +
 arch/arm64/kvm/sys_regs.c              | 136 ++++++--
 arch/arm64/kvm/trace.h                 | 105 +++++++
 include/uapi/linux/kvm.h               |   5 +
 18 files changed, 788 insertions(+), 452 deletions(-)
 create mode 100644 arch/arm64/kvm/debug.c

--=20
2.4.1

