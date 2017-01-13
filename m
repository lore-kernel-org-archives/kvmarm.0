From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/3] KVM/ARM updates for 4.10-rc4
Date: Fri, 13 Jan 2017 11:31:30 +0000
Message-ID: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Radim, Paolo,

Here's the KVM/ARM updates for 4.10-rc4. Two timer fixes, and one vgic
fix for a deadlock that's been reported this week (which should land
into stable).

Please pull.

Thanks,

	M.

The following changes since commit a121103c922847ba5010819a3f250f1f7fc84ab8:

  Linux 4.10-rc3 (2017-01-08 14:18:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.10-rc4

for you to fetch changes up to 1193e6aeecb36c74c48c7cd0f641acbbed9ddeef:

  KVM: arm/arm64: vgic: Fix deadlock on error handling (2017-01-13 11:19:35 +0000)

----------------------------------------------------------------
KVM/ARM updates for 4.10-rc4

- Fix for timer setup on VHE machines
- Drop spurious warning when the timer races against
  the vcpu running again
- Prevent a vgic deadlock when the initialization fails

----------------------------------------------------------------
Christoffer Dall (1):
      KVM: arm/arm64: Fix occasional warning from the timer work function

Jintack Lim (1):
      KVM: arm64: Access CNTHCTL_EL2 bit fields correctly on VHE systems

Marc Zyngier (1):
      KVM: arm/arm64: vgic: Fix deadlock on error handling

 arch/arm/include/asm/virt.h   |  5 +++++
 arch/arm/kvm/arm.c            |  3 +++
 arch/arm64/include/asm/virt.h |  9 +++++++++
 include/kvm/arm_arch_timer.h  |  1 +
 virt/kvm/arm/arch_timer.c     | 26 +++++++++++++++++++++++---
 virt/kvm/arm/hyp/timer-sr.c   | 33 +++++++++++++++++++++------------
 virt/kvm/arm/vgic/vgic-init.c | 18 +++++++++++++-----
 virt/kvm/arm/vgic/vgic-v2.c   |  2 --
 virt/kvm/arm/vgic/vgic-v3.c   |  2 --
 9 files changed, 75 insertions(+), 24 deletions(-)
