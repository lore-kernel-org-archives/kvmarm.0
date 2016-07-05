From: vijay.kilari@gmail.com
Subject: [RFC PATCH v1] arm/arm64: vgic-new: Create dist and redist iodevs
 earlier
Date: Tue,  5 Jul 2016 20:41:31 +0530
Message-ID: <1467731491-6458-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A17140B40
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2016 11:06:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3GLPmBMSlTqv for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jul 2016 11:06:28 -0400 (EDT)
Received: from mail-pf0-f194.google.com (mail-pf0-f194.google.com
 [209.85.192.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54ABC409A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2016 11:06:27 -0400 (EDT)
Received: by mail-pf0-f194.google.com with SMTP id i123so19281986pfg.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jul 2016 08:11:58 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: Vijaya Kumar K <vijayak@caviumnetworks.com>, Prasun.Kapoor@cavium.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <vijayak@caviumnetworks.com>

The dist and redist regions are created and registered in
vgic_register_dist_iodevs() and vgic_v3_init_redist_iodev()
calls for distributor and redistributor respectively when
vgic_v3_map_resources() is called. This mapping of resources
is done when vcpu run ioctl is called.

Below is the call stack of the same.

[<ffff0000080b2e8c>] vgic_register_redist_iodevs+0x94/0x27c
[<ffff0000080b0fd8>] vgic_v3_map_resources+0x138/0x188
[<ffff0000080affa4>] kvm_vgic_map_resources+0xb0/0xb8
[<ffff0000080a3888>] kvm_arch_vcpu_ioctl_run+0x4a8/0x550
[<ffff00000809c218>] kvm_vcpu_ioctl+0x304/0x74c
[<ffff000008232cac>] do_vfs_ioctl+0xc0/0x754
[<ffff0000082333d0>] SyS_ioctl+0x90/0xa4
[<ffff000008084af0>] el0_svc_naked+0x24/0x28

During live migration, the destination VM first restores the all the
GIC registers(dist, rdist and cpuif registers) using ioctl's before
resuming the VM.So no vcpu run ioctl is called untill complete
GIC context is restored.

Hence, In case of live migration, when ioctls are called to write
dist/rdist registers the ioctls fails as
vcpu->kvm->arch.vgic.dist_iodev andkvm->arch.vgic.redist_iodevs
are NULL.

In this patch, the distributor and redistributor regions are created
as and when KVM_VGIC_V3_ADDR_TYPE_{DIST|REDIST} ioctl is called.
However the vgic_v3_map_resouces() is still called when vcpu is
executed, which validates the distributor and redistributor addresses.
Ex: Check for overlap.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c |   19 +++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c         |   12 ------------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 0130c4b..cc843fe 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -101,6 +101,25 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		*addr = *addr_ptr;
 	}
 
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+	switch (type) {
+	case KVM_VGIC_V3_ADDR_TYPE_DIST:
+		r = vgic_register_dist_iodev(kvm, vgic->vgic_dist_base, VGIC_V3);
+		if (r) {
+			kvm_err("Unable to register VGICv3 dist MMIO regions\n");
+			goto out;
+		}
+		break;
+	case KVM_VGIC_V3_ADDR_TYPE_REDIST:
+		r = vgic_register_redist_iodevs(kvm, vgic->vgic_redist_base);
+		if (r) {
+			kvm_err("Unable to register VGICv3 redist MMIO regions\n");
+			goto out;
+		}
+		break;
+	}
+#endif
+
 out:
 	mutex_unlock(&kvm->lock);
 	return r;
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 346b4ad..a149b35 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -267,18 +267,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
 		goto out;
 	}
 
-	ret = vgic_register_dist_iodev(kvm, dist->vgic_dist_base, VGIC_V3);
-	if (ret) {
-		kvm_err("Unable to register VGICv3 dist MMIO regions\n");
-		goto out;
-	}
-
-	ret = vgic_register_redist_iodevs(kvm, dist->vgic_redist_base);
-	if (ret) {
-		kvm_err("Unable to register VGICv3 redist MMIO regions\n");
-		goto out;
-	}
-
 	dist->ready = true;
 
 out:
-- 
1.7.9.5
