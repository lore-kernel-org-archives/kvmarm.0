From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL] KVM/ARM fixes for 4.5-rc4
Date: Thu, 11 Feb 2016 15:59:44 +0000
Message-ID: <1455206386-24997-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Cosmin Gorgovan <cosmin@linux-geek.org>, Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

Please find below the KVM/ARM updates for 4.5-rc4. One fix for the
timer, and another for the HYP MMU setup.

Please pull!

Thanks,

	M.

The following changes since commit 6327f35a2010c06a3bc2bfb14202a38764fb9920:

  arm64: KVM: Fix guest dead loop when register accessor returns false (2016-01-24 21:56:01 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.5-rc4

for you to fetch changes up to 3c5b1d92b3b02be07873d611a27950addff544d3:

  arm64: KVM: Configure TCR_EL2.PS at runtime (2016-02-11 13:16:47 +0000)

----------------------------------------------------------------
KVM/ARM fixes for 4.5-rc4

- Fix for an unpleasant crash when the VM is created without a timer
- Allow HYP mode to access the full PA space, and not only 40bit

----------------------------------------------------------------
Andre Przywara (1):
      KVM: arm/arm64: Fix reference to uninitialised VGIC

Tirumalesh Chalamarla (1):
      arm64: KVM: Configure TCR_EL2.PS at runtime

 arch/arm64/include/asm/kvm_arm.h |  2 --
 arch/arm64/kvm/hyp-init.S        | 12 +++++++-----
 virt/kvm/arm/arch_timer.c        |  9 ++++++---
 3 files changed, 13 insertions(+), 10 deletions(-)
