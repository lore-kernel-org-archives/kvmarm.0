From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 32/55] KVM: arm/arm64: register GICH iodev for the guest
 hypervisor
Date: Mon,  9 Jan 2017 01:24:28 -0500
Message-ID: <1483943091-1364-33-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03F214025C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r+d0CwAV-QOt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:32 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 464DA40839
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:32 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PWuJ005289
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:13 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id E1BCF80
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:13 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id C8D5299
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:13 -0500 (EST)
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com
 [209.85.220.198])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QD5T041300
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:13 -0500
Received: by mail-qk0-f198.google.com with SMTP id d75so52980311qkc.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:13 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Register a device for the virtual interface control block(GICH) access
from the guest hypervisor.

TODO: Get GICH address from DT, which is hardcoded now.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/uapi/asm/kvm.h  |  6 ++++++
 include/kvm/arm_vgic.h             |  5 ++++-
 virt/kvm/arm/vgic/vgic-mmio.c      |  6 ++++++
 virt/kvm/arm/vgic/vgic-v2-nested.c | 24 ++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c        |  7 +++++++
 virt/kvm/arm/vgic/vgic.h           |  6 ++++++
 6 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 78117bf..3995d3d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -99,6 +99,12 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
 #define KVM_ARM_VCPU_NESTED_VIRT	4 /* Support nested virtual EL2 */
 
+/* FIXME: This should come from DT */
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+#define KVM_VGIC_V2_GICH_BASE          0x08030000
+#define KVM_VGIC_V2_GICH_SIZE          0x2000
+#endif
+
 struct kvm_vcpu_init {
 	__u32 target;
 	__u32 features[7];
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fc882d6..5bda20c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -125,7 +125,8 @@ enum iodev_type {
 	IODEV_CPUIF,
 	IODEV_DIST,
 	IODEV_REDIST,
-	IODEV_ITS
+	IODEV_ITS,
+	IODEV_GICH,
 };
 
 struct vgic_io_device {
@@ -198,6 +199,8 @@ struct vgic_dist {
 
 	struct vgic_io_device	dist_iodev;
 
+	struct vgic_io_device	hyp_iodev;
+
 	bool			has_its;
 
 	/*
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 049c570..2e4097d 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -512,6 +512,9 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	case IODEV_ITS:
 		data = region->its_read(vcpu->kvm, iodev->its, addr, len);
 		break;
+	case IODEV_GICH:
+		data = region->read(vcpu, addr, len);
+		break;
 	}
 
 	vgic_data_host_to_mmio_bus(val, len, data);
@@ -543,6 +546,9 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	case IODEV_ITS:
 		region->its_write(vcpu->kvm, iodev->its, addr, len, data);
 		break;
+	case IODEV_GICH:
+		region->write(vcpu, addr, len, data);
+		break;
 	}
 
 	return 0;
diff --git a/virt/kvm/arm/vgic/vgic-v2-nested.c b/virt/kvm/arm/vgic/vgic-v2-nested.c
index 85f646b..cb55324 100644
--- a/virt/kvm/arm/vgic/vgic-v2-nested.c
+++ b/virt/kvm/arm/vgic/vgic-v2-nested.c
@@ -206,6 +206,30 @@ static void vgic_mmio_write_v2_gich(struct kvm_vcpu *vcpu,
 		4 * VGIC_V2_MAX_LRS, VGIC_ACCESS_32bit),
 };
 
+int vgic_register_gich_iodev(struct kvm *kvm, struct vgic_dist *dist)
+{
+	struct vgic_io_device *io_device = &kvm->arch.vgic.hyp_iodev;
+	int ret = 0;
+	unsigned int len;
+
+	len = KVM_VGIC_V2_GICH_SIZE;
+
+	io_device->regions = vgic_v2_gich_registers;
+	io_device->nr_regions = ARRAY_SIZE(vgic_v2_gich_registers);
+	kvm_iodevice_init(&io_device->dev, &kvm_io_gic_ops);
+
+	io_device->base_addr = KVM_VGIC_V2_GICH_BASE;
+	io_device->iodev_type = IODEV_GICH;
+	io_device->redist_vcpu = NULL;
+
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, KVM_VGIC_V2_GICH_BASE,
+			len, &io_device->dev);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 /*
  * For LRs which have HW bit set such as timer interrupts, we modify them to
  * have the host hardware interrupt number instead of the virtual one programmed
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 9bab867..b8b73fd 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -280,6 +280,13 @@ int vgic_v2_map_resources(struct kvm *kvm)
 		goto out;
 	}
 
+	/* Register virtual GICH interface to kvm io bus */
+	ret = vgic_register_gich_iodev(kvm, dist);
+	if (ret) {
+		kvm_err("Unable to register VGIC GICH regions\n");
+		goto out;
+	}
+
 	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
 		ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
 					    kvm_vgic_global_state.vcpu_base,
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 2aef680..11d61a7 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -121,8 +121,14 @@ static inline int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 int vgic_init(struct kvm *kvm);
 
 #ifdef CONFIG_KVM_ARM_NESTED_HYP
+int vgic_register_gich_iodev(struct kvm *kvm, struct vgic_dist *dist);
 void vgic_init_nested(struct kvm_vcpu *vcpu);
 #else
+static inline int vgic_register_gich_iodev(struct kvm *kvm,
+		struct vgic_dist *dist)
+{
+	return 0;
+}
 static inline void vgic_init_nested(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-- 
1.9.1
