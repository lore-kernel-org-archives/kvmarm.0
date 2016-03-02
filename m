From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL] KVM/ARM updates for 4.5-rc7
Date: Wed,  2 Mar 2016 09:27:28 +0000
Message-ID: <1456910849-16049-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

I really thought that the previous PR was the last for this release,
but Michael rightly decided to prove me wrong. Oh well.

Please pull!

       M.

The following changes since commit fd451b90e78c4178bcfc5072f2b2b637500c109a:

  arm64: KVM: vgic-v3: Restore ICH_APR0Rn_EL2 before ICH_APR1Rn_EL2 (2016-02-24 17:25:58 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.5-rc7

for you to fetch changes up to 4cad67fca3fc952d6f2ed9e799621f07666a560f:

  arm/arm64: KVM: Fix ioctl error handling (2016-02-29 09:56:40 +0000)

----------------------------------------------------------------
KVM/ARM fixes for 4.5-rc7

- Fix ioctl error handling on the timer path

----------------------------------------------------------------
Michael S. Tsirkin (1):
      arm/arm64: KVM: Fix ioctl error handling

 arch/arm/kvm/guest.c   | 2 +-
 arch/arm64/kvm/guest.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
