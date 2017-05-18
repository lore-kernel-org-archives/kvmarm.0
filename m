From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 12/13] KVM: arm/arm64: Fix bug when registering redist iodevs
Date: Thu, 18 May 2017 11:47:21 +0200
Message-ID: <20170518094722.9926-13-cdall@linaro.org>
References: <20170518094722.9926-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00ECF40C4C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g0cKKgsRo9Y1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 May 2017 05:44:20 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCF6940C42
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:18 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id b84so195122611wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 02:47:50 -0700 (PDT)
In-Reply-To: <20170518094722.9926-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

If userspace creates the VCPUs after initializing the VGIC, then we end
up in a situation where we trigger a bug in kvm_vcpu_get_idx(), because
it is called prior to adding the VCPU into the vcpus array on the VM.

There is no tight coupling between the VCPU index and the area of the
redistributor region used for the VCPU, so we can simply ensure that all
creations of redistributors are serialized per VM, and increment an
offset when we successfully add a redistributor.

The vgic_register_redist_iodev() function can be called from two paths:
vgic_redister_all_redist_iodev() which is called via the kvm_vgic_addr()
device attribute handler.  This patch already holds the kvm->lock mutex.

The other path is via kvm_vgic_vcpu_init, which is called through a
longer chain from kvm_vm_ioctl_create_vcpu(), which releases the
kvm->lock mutex just before calling kvm_arch_vcpu_create(), so we can
simply take this mutex again later for our purposes.

Fixes: ab6f468c10 ("KVM: arm/arm64: Register iodevs when setting redist base and creating VCPUs")
Signed-off-by: Christoffer Dall <cdall@linaro.org>
Tested-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 include/kvm/arm_vgic.h           | 5 ++++-
 virt/kvm/arm/vgic/vgic-init.c    | 5 ++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 9 ++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 97b8d37..ef71858 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -195,7 +195,10 @@ struct vgic_dist {
 		/* either a GICv2 CPU interface */
 		gpa_t			vgic_cpu_base;
 		/* or a number of GICv3 redistributor regions */
-		gpa_t			vgic_redist_base;
+		struct {
+			gpa_t		vgic_redist_base;
+			gpa_t		vgic_redist_free_offset;
+		};
 	};
 
 	/* distributor enabled */
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index dc68e2e..3a0b899 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -242,8 +242,11 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	 * If we are creating a VCPU with a GICv3 we must also register the
 	 * KVM io device for the redistributor that belongs to this VCPU.
 	 */
-	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		mutex_lock(&vcpu->kvm->lock);
 		ret = vgic_register_redist_iodev(vcpu);
+		mutex_unlock(&vcpu->kvm->lock);
+	}
 	return ret;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 99da1a2..9b0f681 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -586,7 +586,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	if (!vgic_v3_check_base(kvm))
 		return -EINVAL;
 
-	rd_base = vgic->vgic_redist_base + kvm_vcpu_get_idx(vcpu) * SZ_64K * 2;
+	rd_base = vgic->vgic_redist_base + vgic->vgic_redist_free_offset;
 	sgi_base = rd_base + SZ_64K;
 
 	kvm_iodevice_init(&rd_dev->dev, &kvm_io_gic_ops);
@@ -615,11 +615,14 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, sgi_base,
 				      SZ_64K, &sgi_dev->dev);
 	mutex_unlock(&kvm->slots_lock);
-	if (ret)
+	if (ret) {
 		kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
 					  &rd_dev->dev);
+		return ret;
+	}
 
-	return ret;
+	vgic->vgic_redist_free_offset += 2 * SZ_64K;
+	return 0;
 }
 
 static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
-- 
2.9.0
