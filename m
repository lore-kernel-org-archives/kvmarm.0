From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL] KVM/ARM updates for 4.10
Date: Fri,  9 Dec 2016 15:53:25 +0000
Message-ID: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Andre Przywara <andre.przywara@arm.com>, Longpeng <longpeng2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

[Now with the various lists on Cc... sorry for the duplicates]

Paolo, Radim,

Here's the KVM/ARM updates for 4.10. Only a handful of patches this
time, as what we had planned for this cycle (GICv3 save/restore,
mainly) is taking much more time than expected.

The only feature worth mentionning is the support of the GICv3 ITS on
32bit ARMv8 platforms. The rest is only a bunch of fixes.

Thanks,

	M.

The following changes since commit a25f0944ba9b1d8a6813fd6f1a86f1bd59ac25a6:

  Linux 4.9-rc5 (2016-11-13 10:32:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.10

for you to fetch changes up to 21cbe3cc8a48ff17059912e019fbde28ed54745a:

  arm64: KVM: pmu: Reset PMSELR_EL0.SEL to a sane value before entering the guest (2016-12-09 15:47:00 +0000)

----------------------------------------------------------------
KVM/ARM updates for 4.10:

- Support for the GICv3 ITS on 32bit platforms
- A handful of timer and GIC emulation fixes
- A PMU architecture fix

----------------------------------------------------------------
Andre Przywara (1):
      KVM: arm/arm64: vgic-v2: Limit ITARGETSR bits to number of VCPUs

Christoffer Dall (1):
      KVM: arm/arm64: timer: Check for properly initialized timer on init

Longpeng(Mike) (1):
      arm/arm64: KVM: Clean up useless code in kvm_timer_enable

Marc Zyngier (1):
      arm64: KVM: pmu: Reset PMSELR_EL0.SEL to a sane value before entering the guest

Vladimir Murzin (2):
      KVM: arm64: vgic-its: Fix compatibility with 32-bit
      ARM: KVM: Support vGICv3 ITS

 Documentation/virtual/kvm/api.txt   |  2 +-
 arch/arm/include/uapi/asm/kvm.h     |  2 ++
 arch/arm/kvm/Kconfig                |  1 +
 arch/arm/kvm/Makefile               |  1 +
 arch/arm/kvm/arm.c                  |  6 ++++++
 arch/arm64/kvm/Kconfig              |  4 ----
 arch/arm64/kvm/hyp/switch.c         |  8 +++++++-
 arch/arm64/kvm/reset.c              |  6 ------
 include/linux/irqchip/arm-gic-v3.h  |  8 ++++----
 virt/kvm/arm/arch_timer.c           | 17 ++++++-----------
 virt/kvm/arm/vgic/vgic-its.c        | 11 ++++++-----
 virt/kvm/arm/vgic/vgic-kvm-device.c |  2 --
 virt/kvm/arm/vgic/vgic-mmio-v2.c    |  3 ++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |  2 --
 virt/kvm/arm/vgic/vgic.h            | 26 --------------------------
 15 files changed, 36 insertions(+), 63 deletions(-)
