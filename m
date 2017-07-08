From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v2 38/52] KVM: arm/arm64: GICv4: Wire init/teardown of
 per-VM support
Date: Sat, 8 Jul 2017 06:26:13 -0500
Message-ID: <738d2df9-c2b0-1444-8940-1027cf6fdd46@codeaurora.org>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
 <20170628150411.15846-39-marc.zyngier@arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C92E140FAF
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Jul 2017 07:25:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BwzxncjvoULu for <kvmarm@lists.cs.columbia.edu>;
 Sat,  8 Jul 2017 07:25:49 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67A1840CE6
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Jul 2017 07:25:49 -0400 (EDT)
In-Reply-To: <20170628150411.15846-39-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 06/28/2017 10:03 AM, Marc Zyngier wrote:
> Should the HW support GICv4 and an ITS being associated with this
> VM, let's init the its_vm and its_vpe structures.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-init.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 3a0b8999f011..0de1f0d986d4 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -285,8 +285,14 @@ int vgic_init(struct kvm *kvm)
>  	if (ret)
>  		goto out;
>  
> -	if (vgic_has_its(kvm))
> +	if (vgic_has_its(kvm)) {
>  		dist->msis_require_devid = true;
> +		if (kvm_vgic_global_state.has_gicv4) {
> +			ret = vgic_v4_init(kvm);
> +			if (ret)
> +				goto out;
> +		}

This is not quite right, ITS virtual device may not be initialized at the time of 
calling vgic-init(). This change breaks the existing KVM functionality with QEMU
hypervisor tool. In later patches, code assumes vgic_v4_init(kvm) was called when
vgic_has_its(kvm) returns a true value. 

The right change would be move this logic to inside vgic_its_create() something like this.

 --- a/virt/kvm/arm/vgic/vgic-init.c
 +++ b/virt/kvm/arm/vgic/vgic-init.c
 @@ -285,14 +285,8 @@ int vgic_init(struct kvm *kvm)
         if (ret)
                 goto out;
 
 -       if (vgic_has_its(kvm)) { 
 +       if (vgic_has_its(kvm))
                 dist->msis_require_devid = true;
 -               if (kvm_vgic_global_state.has_gicv4) {
 -                       ret = vgic_v4_init(kvm);
 -                       if (ret)
 -                               goto out;
 -               }
 -       }
 
         kvm_for_each_vcpu(i, vcpu, kvm)
                 kvm_vgic_vcpu_enable(vcpu);

 --- a/virt/kvm/arm/vgic/vgic-its.c
 +++ b/virt/kvm/arm/vgic/vgic-its.c
 @@ -1637,6 +1637,7 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct
  static int vgic_its_create(struct kvm_device *dev, u32 type)
  {
         struct vgic_its *its;
 +       int ret;
 
         if (type != KVM_DEV_TYPE_ARM_VGIC_ITS) 
                 return -ENODEV;
 @@ -1657,6 +1658,12 @@ static int vgic_its_create(struct kvm_device *dev, u32 ty
         its->enabled = false;
         its->dev = dev;
  
 +       if (kvm_vgic_global_state.has_gicv4) {
 +               ret = vgic_v4_init(dev->kvm);
 +               if (ret)
 +                       return -ENOMEM;
 +       }
 +


> +	}
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_enable(vcpu);
> @@ -323,6 +329,9 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>  
>  	kfree(dist->spis);
>  	dist->nr_spis = 0;
> +
> +	if (kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm))
> +		vgic_v4_teardown(kvm);
>  }
>  
>  void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
> 

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
