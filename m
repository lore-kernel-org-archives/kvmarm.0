From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL] KVM/ARM fixes for v4.4-rc6
Date: Fri, 18 Dec 2015 13:00:08 +0000
Message-ID: <1450443609-2233-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

We have a one line fix for the VGIC this time around, fixing a patch
that went in -rc2. Oh well. Hopefully this is the last one for v4.4.

Please pull!

Thanks,

	M.

The following changes since commit 0de58f852875a0f0dcfb120bb8433e4e73c7803b:

  ARM/arm64: KVM: correct PTE uncachedness check (2015-12-04 16:30:17 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.4-rc6

for you to fetch changes up to fdec12c12ed4333afb49c9948c29fbd5fb52da97:

  KVM: arm/arm64: vgic: Fix kvm_vgic_map_is_active's dist check (2015-12-11 16:33:31 +0000)

----------------------------------------------------------------
KVM/ARM fixes for v4.4-rc6

- Fix for the active interrupt detection code, affecting
  the timer interrupt injection.

----------------------------------------------------------------
Christoffer Dall (1):
      KVM: arm/arm64: vgic: Fix kvm_vgic_map_is_active's dist check

 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
