From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 0/3] KVM: arm64: vgic-its-fixes
Date: Tue,  9 Aug 2016 13:16:03 +0200
Message-ID: <20160809111606.28744-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Here are three small fixes resulting from looking at the pull request of
kvmarm/next into kvm/next.

They basically deal with corner cases in the reference count handling and
atomicity issues.

See the individual patches for changelogs.

Christoffer Dall (3):
  KVM: arm64: vgic-its: Handle errors from vgic_add_lpi
  KVM: arm64: vgic-its: Plug race in vgic_put_irq
  KVM: arm64: vgic-its: Make updates to propbaser/pendbaser atomic

 virt/kvm/arm/vgic/vgic-its.c     | 21 +++++++++++++++++----
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 24 ++++++++++++++----------
 virt/kvm/arm/vgic/vgic.c         | 10 +++++-----
 3 files changed, 36 insertions(+), 19 deletions(-)

-- 
2.9.0

