From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/2] KVM/ARM updates for v4.1, take 2
Date: Wed, 22 Apr 2015 16:08:36 +0100
Message-ID: <1429715318-31725-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Marcelo,

This is the second pull request for the KVM/ARM updates targeting
v4.1. Not much to see this time, just a couple of borring fixes.

Thanks,

	M.

The following changes since commit b79013b2449c23f1f505bdf39c5a6c330338b244:

  Merge tag 'staging-4.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging (2015-04-13 17:37:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.1-take2

for you to fetch changes up to fd1d0ddf2ae92fb3df42ed476939861806c5d785:

  KVM: arm/arm64: check IRQ number on userland injection (2015-04-22 15:42:24 +0100)

----------------------------------------------------------------
KVM/ARM changes for v4.1, take #2:

Rather small this time:

- a fix for a nasty bug with virtual IRQ injection
- a fix for irqfd

----------------------------------------------------------------
Andre Przywara (1):
      KVM: arm/arm64: check IRQ number on userland injection

Eric Auger (1):
      KVM: arm: irqfd: fix value returned by kvm_irq_map_gsi

 arch/arm/include/uapi/asm/kvm.h   | 8 +++++++-
 arch/arm/kvm/arm.c                | 3 +--
 arch/arm64/include/uapi/asm/kvm.h | 8 +++++++-
 virt/kvm/arm/vgic.c               | 5 ++++-
 4 files changed, 19 insertions(+), 5 deletions(-)
