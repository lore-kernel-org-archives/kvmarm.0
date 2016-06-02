From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 0/8] KVM/ARM Fixes for v4.7-rc2
Date: Thu,  2 Jun 2016 12:20:52 +0200
Message-ID: <1464862860-1183-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

The following changes since commit 1a695a905c18548062509178b98bc91e67510864:

  Linux 4.7-rc1 (2016-05-29 09:29:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.7-rc2

for you to fetch changes up to 05fb05a6ca25e02ad8c31bc440b3c4996864f379:

  KVM: arm/arm64: vgic-new: Removel harmful BUG_ON (2016-06-02 11:52:21 +0200)

They contain fixes for the vgic; two of the patches address a bug introduced in
v4.6 while the rest are for the new vgic.

Thanks,
-Christoffer

---

Christoffer Dall (2):
      KVM: arm/arm64: vgic-v2: Clear all dirty LRs
      KVM: arm/arm64: vgic-v3: Clear all dirty LRs

Marc Zyngier (6):
      KVM: arm/arm64: vgic-v2: Always resample level interrupts
      KVM: arm/arm64: vgic-v3: Always resample level interrupts
      arm64: KVM: Make ICC_SRE_EL1 access return the configured SRE value
      arm64: KVM: vgic-v3: Prevent the guest from messing with ICC_SRE_EL1
      arm64: KVM: vgic-v3: Relax synchronization when SRE==1
      KVM: arm/arm64: vgic-new: Removel harmful BUG_ON

 arch/arm64/kvm/hyp/vgic-v3-sr.c | 36 +++++++++++++++++++++---------------
 arch/arm64/kvm/sys_regs.c       | 13 ++++++++++++-
 virt/kvm/arm/hyp/vgic-v2-sr.c   |  7 +++----
 virt/kvm/arm/vgic/vgic-mmio.c   |  4 +---
 virt/kvm/arm/vgic/vgic-v2.c     | 14 +++++++++-----
 virt/kvm/arm/vgic/vgic-v3.c     | 14 +++++++++-----
 6 files changed, 55 insertions(+), 33 deletions(-)
