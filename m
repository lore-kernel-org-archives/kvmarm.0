From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 07/11] KVM: arm/arm64: Register iodevs when setting
 redist base and creating VCPUs
Date: Wed, 17 May 2017 13:18:27 +0200
Message-ID: <20170517111827.GA11893@cbox>
References: <20170509085618.28311-1-cdall@linaro.org>
 <20170509085618.28311-8-cdall@linaro.org>
 <de4eb037-2837-fe77-d5ee-514529bfcd99@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <de4eb037-2837-fe77-d5ee-514529bfcd99@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean,

On Tue, May 16, 2017 at 12:23:52PM +0100, Jean-Philippe Brucker wrote:
> Hi,
> 
> On 09/05/17 09:56, Christoffer Dall wrote:
> > Instead of waiting with registering KVM iodevs until the first VCPU is
> > run, we can actually create the iodevs when the redist base address is
> > set.  The only downside is that we must now also check if we need to do
> > this for VCPUs which are created after creating the VGIC, because there
> > is no enforced ordering between creating the VGIC (and setting its base
> > addresses) and creating the VCPUs.
> 
> This triggers a BUG(), when the order is VGIC init, then VCPU init (which
> is what kvmtool does).
> 
> Issuing KVM_CREATE_VCPU after VGIC intialization produces the following calls:
> 
> kvm_vm_ioctl_create_vcpu
>  kvm_arch_vcpu_create
>   kvm_vcpu_init
>    kvm_arch_vcpu_init
>     kvm_vgic_vcpu_init
>      vgic_register_redist_iodev
>       kvm_vcpu_get_idx
>        ... no VCPU registered yet in kvm->vcpus :(
>        BUG();
> 
>  ... would later register vcpu:
>  kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu
> 
> My quick fix is to move kvm_vgic_vcpu_init into kvm_arch_vcpu_postcreate,
> but it discards the return value of kvm_vgic_vcpu_init, so I don't know
> how to do it properly.
> 

Would you mind giving this patch a go with your setup?

commit 7370dc8eefc9004923c2454c2f01c49850c8d94b (HEAD -> vcpu_idx_redist_bugfix)
Author: Christoffer Dall <cdall@linaro.org>
Date:   Wed May 17 13:12:51 2017 +0200

    KVM: arm/arm64: Fix bug when registering redist iodevs
    
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
    
    Signed-off-by: Christoffer Dall <cdall@linaro.org>

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 97b8d37..2304aeb 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -195,9 +195,13 @@ struct vgic_dist {
 		/* either a GICv2 CPU interface */
 		gpa_t			vgic_cpu_base;
 		/* or a number of GICv3 redistributor regions */
-		gpa_t			vgic_redist_base;
+		struct {
+			gpa_t		vgic_redist_base;
+			gpa_t		vgic_redist_free_offset;
+		};
 	};
 
+
 	/* distributor enabled */
 	bool			enabled;
 
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


Thanks,
-Christoffer
