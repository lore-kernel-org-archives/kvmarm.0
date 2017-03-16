From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/2] KVM: arm/arm64: vgic: Workaround GICC_PMR misreporting
Date: Thu, 16 Mar 2017 11:45:33 +0000
Message-ID: <20170316114535.25233-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We have an annoying bug in the way we deal with GICC_PMR being
reported to userspace. When emulating a GICv2, we only report the top
5 bits (which is what the HW deals with) in an 8 bit field, completely
missing the left shift that would make it look like a normal value.

VM save/restore works just fine because we have the same issue on both
sides, and fixing it without any opt-in would break that migration.

This series implements a new attribute for the GICv2 emulation that
can be probed and set by userspace if it is interested in the real PMR
value. It also implements the reverse hack when emulating GICv2 on a
GICv3 host...

As this impacts userspace, I'm quite eager to have feedback from
people dealing with that side of the world.

Marc Zyngier (2):
  KVM: arm/arm64: vgic-v2: Expose the correct GICC_PMR values to
    userspace
  KVM: arm/arm64: vgic-v3: Format PMR to mimic the GICv2 behaviour

 arch/arm/include/uapi/asm/kvm.h     |  4 ++--
 arch/arm64/include/uapi/asm/kvm.h   |  4 ++--
 include/kvm/arm_vgic.h              |  5 +++++
 virt/kvm/arm/vgic/vgic-kvm-device.c |  5 +++++
 virt/kvm/arm/vgic/vgic-v2.c         | 16 ++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c         | 21 +++++++++++++++++++++
 6 files changed, 51 insertions(+), 4 deletions(-)

-- 
2.11.0
