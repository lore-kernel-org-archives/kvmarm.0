From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 0/2] Rework vgic_attr_regs_access
Date: Tue, 16 Aug 2016 19:34:59 +0200
Message-ID: <20160816173501.21521-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: vijay.kilari@gmail.com
Cc: Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Two small patches to split up the functionality in vgic_attr_regs_access to
make life simpler when having to deal with GICv3 save/restore.

Changes from v1:
 - Comments and white space

Christoffer Dall (2):
  KVM: arm/arm64: Factor out vgic_attr_regs_access functionality
  KVM: arm/arm64: Rename vgic_attr_regs_access to
    vgic_attr_regs_access_v2

 virt/kvm/arm/vgic/vgic-kvm-device.c | 122 ++++++++++++++++++++++++------------
 1 file changed, 82 insertions(+), 40 deletions(-)

-- 
2.9.0

