From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 7/8] KVM: arm/arm64: Register ITS iodev when setting base
 address
Date: Mon, 8 May 2017 18:41:36 +0100
Message-ID: <a33cabd3-cf92-1a49-7b47-8d35d3daab4d@arm.com>
References: <20170508115454.5075-1-cdall@linaro.org>
 <20170508115454.5075-8-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170508115454.5075-8-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 08/05/17 12:54, Christoffer Dall wrote:
> We have to register the ITS iodevice before running the VM, because in
> migration scenarios, we may be restoring a live device that wishes to
> inject MSIs before we get a chance to run the VM.
> 
> All we need to register the ITS io device is the base address of the
> ITS, so we can simply register that when the base address of the ITS is
> set.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 29 +----------------------------
>  virt/kvm/arm/vgic/vgic-v3.c  |  8 --------
>  virt/kvm/arm/vgic/vgic.h     |  1 -
>  3 files changed, 1 insertion(+), 37 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 9f7105c..375c503 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2390,7 +2390,7 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  
>  		its->vgic_its_base = addr;
>  
> -		return 0;
> +		return vgic_register_its_iodev(dev->kvm, its);
>  	}
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
>  		const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> @@ -2467,30 +2467,3 @@ int kvm_vgic_register_its_device(void)
>  	return kvm_register_device_ops(&kvm_arm_vgic_its_ops,
>  				       KVM_DEV_TYPE_ARM_VGIC_ITS);
>  }

This patch has the unfortunate side effect of breaking kvmtool 
(although the ITS support patches are not merged yet). The code 
sequence now requires that KVM_DEV_ARM_VGIC_CTRL_INIT has been issued 
on the ITS *before* we can set the ITS base address.

I find it a bit odd (I see KVM_DEV_ARM_VGIC_CTRL_INIT as a way to say 
"I'm done, do what you must and make it work"), but that's obviously 
what QEMU must be doing (the save/restore sequence hints at that, but I 
only just realized the issue). Of course, kvmtool does the opposite.

But now that we've coupled setting the address and mapping the iodev, 
there is not much that's left for KVM_DEV_ARM_VGIC_CTRL_INIT, and I 
wonder why we're keeping it (other than for backward compatibility)?

We're now unable to set the address more than once (fair enough). What 
is also interesting is that this makes it plain obvious that we have a 
race between setting the address and registering the device (no lock is 
taken here, and two threads could try and play a dirty game on us).

I've come up with the two following patches, that seem to make it work.

Thanks,

	M.

>From 25e5367b7b7c3bcbeaff3a1b74605aed41e996cf Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Mon, 8 May 2017 18:15:40 +0100
Subject: [PATCH 1/2] KVM: arm/arm64: Get rid of its->initialized field

The its->initialized doesn't bring much to the table, and creates
unnecessary ordering between setting the address and initializing it
(which amounts to exactly nothing).

Let's kill it altogether, making KVM_DEV_ARM_VGIC_CTRL_INIT the no-op
it deserves to be.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h       | 1 -
 virt/kvm/arm/vgic/vgic-its.c | 7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a5c5c4eda6f4..97b8d3728b31 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -148,7 +148,6 @@ struct vgic_its {
 	gpa_t			vgic_its_base;
 
 	bool			enabled;
-	bool			initialized;
 	struct vgic_io_device	iodev;
 	struct kvm_device	*dev;
 
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 9b67621df08d..c6237cd6595c 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1545,9 +1545,6 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
 	struct vgic_io_device *iodev = &its->iodev;
 	int ret;
 
-	if (!its->initialized)
-		return -EBUSY;
-
 	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
 		return -ENXIO;
 
@@ -1597,7 +1594,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	INIT_LIST_HEAD(&its->collection_list);
 
 	dev->kvm->arch.vgic.has_its = true;
-	its->initialized = false;
 	its->enabled = false;
 	its->dev = dev;
 
@@ -2398,8 +2394,7 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			its->initialized = true;
-
+			/* Nothing to do */
 			return 0;
 		case KVM_DEV_ARM_ITS_SAVE_TABLES:
 			return abi->save_tables(its);
-- 
2.11.0


>From fdcc35008da30248054979f102ef4064594b2001 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Mon, 8 May 2017 18:34:25 +0100
Subject: [PATCH 2/2] KVM: arm/arm64: Plug race between ITS base address
 setting and iodev registration

We set the ITS base address (and other fields) outside of the critical
section, leaving the door open for two thread to race on changing the
fields.

Change vgic_register_its_iodev() to take an address parameter, and
move all the initialization inside the mutex-protected section.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index c6237cd6595c..0a97ab49b44f 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1540,14 +1540,19 @@ void vgic_enable_lpis(struct kvm_vcpu *vcpu)
 		its_sync_lpi_pending_table(vcpu);
 }
 
-static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
+static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
+				   u64 addr)
 {
 	struct vgic_io_device *iodev = &its->iodev;
 	int ret;
 
-	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
-		return -ENXIO;
+	mutex_lock(&kvm->slots_lock);
+	if (!IS_VGIC_ADDR_UNDEF(its->vgic_its_base)) {
+		ret = -EBUSY;
+		goto out;
+	}
 
+	its->vgic_its_base = addr;
 	iodev->regions = its_registers;
 	iodev->nr_regions = ARRAY_SIZE(its_registers);
 	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
@@ -1555,9 +1560,9 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
 	iodev->base_addr = its->vgic_its_base;
 	iodev->iodev_type = IODEV_ITS;
 	iodev->its = its;
-	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
 				      KVM_VGIC_V3_ITS_SIZE, &iodev->dev);
+out:
 	mutex_unlock(&kvm->slots_lock);
 
 	return ret;
@@ -2385,9 +2390,7 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 		if (ret)
 			return ret;
 
-		its->vgic_its_base = addr;
-
-		return vgic_register_its_iodev(dev->kvm, its);
+		return vgic_register_its_iodev(dev->kvm, its, addr);
 	}
 	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
 		const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-- 
2.11.0


-- 
Jazz is not dead. It just smells funny...
