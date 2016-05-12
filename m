From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] fixup! vgic-new: make vgic_register_redist_iodevs more
 readable
Date: Thu, 12 May 2016 13:44:28 +0100
Message-ID: <1463057068-2291-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73A6949B34
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 08:41:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BGHnptzeSSzF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 08:41:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1B349B2C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 08:41:09 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 42 ++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 97995e2..1985d56 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -318,7 +318,7 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
 {
 	int nr_vcpus = atomic_read(&kvm->online_vcpus);
 	struct kvm_vcpu *vcpu;
-	struct vgic_io_device *devices, *device;
+	struct vgic_io_device *devices;
 	int c, ret = 0;
 
 	devices = kmalloc(sizeof(struct vgic_io_device) * nr_vcpus * 2,
@@ -326,45 +326,45 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
 	if (!devices)
 		return -ENOMEM;
 
-	device = devices;
 	kvm_for_each_vcpu(c, vcpu, kvm) {
-		kvm_iodevice_init(&device->dev, &kvm_io_gic_ops);
-		device->base_addr = redist_base_address;
-		device->regions = vgic_v3_rdbase_registers;
-		device->nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
-		device->redist_vcpu = vcpu;
+		gpa_t rd_base = redist_base_address + c * SZ_64K * 2;
+		gpa_t sgi_base = rd_base + SZ_64K;
+		struct vgic_io_device *rd_dev = &devices[c * 2];
+		struct vgic_io_device *sgi_dev = &devices[c * 2 + 1];
+
+		kvm_iodevice_init(&rd_dev->dev, &kvm_io_gic_ops);
+		rd_dev->base_addr = rd_base;
+		rd_dev->regions = vgic_v3_rdbase_registers;
+		rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
+		rd_dev->redist_vcpu = vcpu;
 
 		mutex_lock(&kvm->slots_lock);
-		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
-					      redist_base_address,
-					      SZ_64K, &device->dev);
+		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
+					      SZ_64K, &rd_dev->dev);
 		mutex_unlock(&kvm->slots_lock);
 
 		if (ret)
 			break;
 
-		device++;
-		kvm_iodevice_init(&device->dev, &kvm_io_gic_ops);
-		device->base_addr = redist_base_address + SZ_64K;
-		device->regions = vgic_v3_sgibase_registers;
-		device->nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers);
-		device->redist_vcpu = vcpu;
+		kvm_iodevice_init(&sgi_dev->dev, &kvm_io_gic_ops);
+		sgi_dev->base_addr = sgi_base;
+		sgi_dev->regions = vgic_v3_sgibase_registers;
+		sgi_dev->nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers);
+		sgi_dev->redist_vcpu = vcpu;
 
 		mutex_lock(&kvm->slots_lock);
-		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
-					      redist_base_address + SZ_64K,
-					      SZ_64K, &device->dev);
+		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, sgi_base,
+					      SZ_64K, &sgi_dev->dev);
 		mutex_unlock(&kvm->slots_lock);
 		if (ret) {
 			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
 						  &devices[c * 2].dev);
 			break;
 		}
-		device++;
-		redist_base_address += 2 * SZ_64K;
 	}
 
 	if (ret) {
+		/* The current c failed, so we start with the previous one. */
 		for (c--; c >= 0; c--) {
 			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
 						  &devices[c * 2].dev);
-- 
2.8.2
