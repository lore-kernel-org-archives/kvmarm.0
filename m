From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
Date: Tue, 19 Apr 2016 11:26:26 +0100
Message-ID: <1461061586-15012-1-git-send-email-andre.przywara@arm.com>
References: <5714D749.9030007@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5714D749.9030007@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vladimir,

can you try the attached patch on top of the series to see if this
fixes the GICv3 emulation issues you see?

I think these lines got lost during the MMIO framework rebasing.

Cheers,
Andre.

---
 virt/kvm/arm/vgic/vgic_mmio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index ec96188..92f39ba 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -1228,6 +1228,7 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
 	kvm_for_each_vcpu(c, vcpu, kvm) {
 		kvm_iodevice_init(&region->dev, &kvm_io_v3redist_ops);
 		region->base_addr = redist_base_address;
+		region->redist_vcpu = vcpu;
 
 		mutex_lock(&kvm->slots_lock);
 		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
@@ -1241,6 +1242,7 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
 		region++;
 		kvm_iodevice_init(&region->dev, &kvm_io_v3redist_private_ops);
 		region->base_addr = redist_base_address + SZ_64K;
+		region->redist_vcpu = vcpu;
 
 		mutex_lock(&kvm->slots_lock);
 		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
-- 
2.7.3

