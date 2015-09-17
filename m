From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] Second set of KVM/ARM updates for 4.3-rc2
Date: Thu, 17 Sep 2015 15:46:03 +0100
Message-ID: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Marek Majtyka <marek.majtyka@tieto.com>, Pavel Fedin <p.fedin@samsung.com>, Ming Lei <ming.lei@canonical.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

We've had a "nice" collection of fixes trickling in this week, and
since both Christoffer and I are away next week, I've decided to send
everything your way a bit early. Fairly random stuff to be honnest,
but a negative diffstat can't be that bad! :-)

Thanks,

       M.

The following changes since commit 0c0672922dcc70ffba11d96385e98e42fb3ae08d:

  arm/arm64: KVM: Fix PSCI affinity info return value for non valid cores (2015-09-04 17:02:48 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.3-rc2-2

for you to fetch changes up to ef748917b529847277f07c98c55e1c0ce416449f:

  arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS' (2015-09-17 13:13:27 +0100)

----------------------------------------------------------------
Second set of KVM/ARM changes for 4.3-rc2

- Workaround for a Cortex-A57 erratum
- Bug fix for the debugging infrastructure
- Fix for 32bit guests with more than 4GB of address space
  on a 32bit host
- A number of fixes for the (unusual) case when we don't use
  the in-kernel GIC emulation
- Removal of ThumbEE handling on arm64, since these have been
  dropped from the architecture before anyone actually ever
  built a CPU
- Remove the KVM_ARM_MAX_VCPUS limitation which has become
  fairly pointless

----------------------------------------------------------------
Marc Zyngier (3):
      arm64: KVM: Fix user access for debug registers
      arm64: KVM: Disable virtual timer even if the guest is not using it
      arm: KVM: Disable virtual timer even if the guest is not using it

Marek Majtyka (1):
      arm: KVM: Fix incorrect device to IPA mapping

Ming Lei (1):
      arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'

Pavel Fedin (1):
      arm/arm64: KVM: vgic: Check for !irqchip_in_kernel() when mapping resources

Will Deacon (2):
      KVM: arm64: add workaround for Cortex-A57 erratum #852523
      arm64: KVM: Remove all traces of the ThumbEE registers

 arch/arm/include/asm/kvm_host.h   |  8 ++------
 arch/arm/kvm/Kconfig              | 11 -----------
 arch/arm/kvm/arm.c                |  2 +-
 arch/arm/kvm/interrupts_head.S    |  6 ++++--
 arch/arm/kvm/mmu.c                |  6 ++++--
 arch/arm64/include/asm/kvm_arm.h  |  1 -
 arch/arm64/include/asm/kvm_asm.h  |  4 +---
 arch/arm64/include/asm/kvm_host.h |  8 ++------
 arch/arm64/kvm/Kconfig            | 11 -----------
 arch/arm64/kvm/hyp.S              | 31 ++++++++++---------------------
 arch/arm64/kvm/sys_regs.c         | 15 ++++-----------
 include/kvm/arm_vgic.h            |  6 +-----
 virt/kvm/arm/vgic-v3.c            |  2 +-
 13 files changed, 30 insertions(+), 81 deletions(-)
