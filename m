From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 09/26] KVM: arm/arm64: GICv4: Add init/teardown of the
 per-VM vPE irq domain
Date: Fri, 10 Nov 2017 08:55:23 +0000
Message-ID: <466be864-0831-e855-aeff-456a19e2cd4a@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-10-marc.zyngier@arm.com>
 <4a41a67d-a04b-b3ca-a5e8-c582e27c17d1@redhat.com>
 <20171110082043.GG14144@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110082043.GG14144@cbox>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, Auger Eric <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/11/17 08:20, Christoffer Dall wrote:
> On Tue, Nov 07, 2017 at 02:08:23PM +0100, Auger Eric wrote:
>> Hi Marc,
>>
>> On 27/10/2017 16:28, Marc Zyngier wrote:
>>> In order to control the GICv4 view of virtual CPUs, we rely
>>> on an irqdomain allocated for that purpose. Let's add a couple
>>> of helpers to that effect.
>>>
>>> At the same time, the vgic data structures gain new fields to
>>> track all this... erm... wonderful stuff.
>>>
>>> The way we hook into the vgic init is slightly convoluted. We
>>> need the vgic to be initialized (in order to guarantee that
>>> the number of vcpus is now fixed), and we must have a vITS
>>> (otherwise this is all very pointless). So we end-up calling
>>> the init from both vgic_init and vgic_its_create.
>>>
>>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  arch/arm/kvm/Makefile         |  1 +
>>>  arch/arm64/kvm/Makefile       |  1 +
>>>  include/kvm/arm_vgic.h        | 19 ++++++++++
>>>  virt/kvm/arm/vgic/vgic-init.c |  9 +++++
>>>  virt/kvm/arm/vgic/vgic-its.c  |  8 +++++
>>>  virt/kvm/arm/vgic/vgic-v4.c   | 83 +++++++++++++++++++++++++++++++++++++++++++
>>>  virt/kvm/arm/vgic/vgic.h      |  2 ++
>>>  7 files changed, 123 insertions(+)
>>>  create mode 100644 virt/kvm/arm/vgic/vgic-v4.c
>>>
>>> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
>>> index d9beee652d36..0a1dd2cdb928 100644
>>> --- a/arch/arm/kvm/Makefile
>>> +++ b/arch/arm/kvm/Makefile
>>> @@ -31,6 +31,7 @@ obj-y += $(KVM)/arm/vgic/vgic-init.o
>>>  obj-y += $(KVM)/arm/vgic/vgic-irqfd.o
>>>  obj-y += $(KVM)/arm/vgic/vgic-v2.o
>>>  obj-y += $(KVM)/arm/vgic/vgic-v3.o
>>> +obj-y += $(KVM)/arm/vgic/vgic-v4.o
>>>  obj-y += $(KVM)/arm/vgic/vgic-mmio.o
>>>  obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
>>>  obj-y += $(KVM)/arm/vgic/vgic-mmio-v3.o
>>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>>> index 5d9810086c25..c30fd388ef80 100644
>>> --- a/arch/arm64/kvm/Makefile
>>> +++ b/arch/arm64/kvm/Makefile
>>> @@ -26,6 +26,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-init.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-irqfd.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v2.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3.o
>>> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v4.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>> index ba9fb450aa1b..7eeb6c2a2f9c 100644
>>> --- a/include/kvm/arm_vgic.h
>>> +++ b/include/kvm/arm_vgic.h
>>> @@ -26,6 +26,8 @@
>>>  #include <linux/list.h>
>>>  #include <linux/jump_label.h>
>>>  
>>> +#include <linux/irqchip/arm-gic-v4.h>
>>> +
>>>  #define VGIC_V3_MAX_CPUS	255
>>>  #define VGIC_V2_MAX_CPUS	8
>>>  #define VGIC_NR_IRQS_LEGACY     256
>>> @@ -236,6 +238,15 @@ struct vgic_dist {
>>>  
>>>  	/* used by vgic-debug */
>>>  	struct vgic_state_iter *iter;
>>> +
>>> +	/*
>>> +	 * GICv4 ITS per-VM data, containing the IRQ domain, the VPE
>>> +	 * array, the property table pointer as well as allocation
>>> +	 * data. This essentially ties the Linux IRQ core and ITS
>>> +	 * together, and avoids leaking KVM's data structures anywhere
>>> +	 * else.
>>> +	 */
>>> +	struct its_vm		its_vm;
>>>  };
>>>  
>>>  struct vgic_v2_cpu_if {
>>> @@ -254,6 +265,14 @@ struct vgic_v3_cpu_if {
>>>  	u32		vgic_ap0r[4];
>>>  	u32		vgic_ap1r[4];
>>>  	u64		vgic_lr[VGIC_V3_MAX_LRS];
>>> +
>>> +	/*
>>> +	 * GICv4 ITS per-VPE data, containing the doorbell IRQ, the
>>> +	 * pending table pointer, the its_vm pointer and a few other
>>> +	 * HW specific things. As for the its_vm structure, this is
>>> +	 * linking the Linux IRQ subsystem and the ITS together.
>>> +	 */
>>> +	struct its_vpe	its_vpe;
>>>  };
>>>  
>>>  struct vgic_cpu {
>>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>>> index 5801261f3add..40be908da238 100644
>>> --- a/virt/kvm/arm/vgic/vgic-init.c
>>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>>> @@ -285,6 +285,12 @@ int vgic_init(struct kvm *kvm)
>>>  	if (ret)
>>>  		goto out;
>>>  
>>> +	if (vgic_supports_direct_msis(kvm)) {
>>> +		ret = vgic_v4_init(kvm);
>>> +		if (ret)
>>> +			goto out;
>>> +	}
>>> +
>>>  	kvm_for_each_vcpu(i, vcpu, kvm)
>>>  		kvm_vgic_vcpu_enable(vcpu);
>>>  
>>> @@ -320,6 +326,9 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>>>  
>>>  	kfree(dist->spis);
>>>  	dist->nr_spis = 0;
>>> +
>>> +	if (vgic_supports_direct_msis(kvm))
>>> +		vgic_v4_teardown(kvm);
>>>  }
>>>  
>>>  void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 8ee03f1e89fc..89768d2b6a91 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -1603,6 +1603,14 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>>>  	if (!its)
>>>  		return -ENOMEM;
>>>  
>>> +	if (vgic_initialized(dev->kvm)) {
>> Don't we need to test vgic_supports_direct_msis() on this path too?
>>
> 
> Seems to me that we should, otherwise creating an ITS after the VGIC has
> been initialized would fail on non-GICv4 compatible systems, right?
> 
> How about this patch as a follow-up to the series:
> 
> commit 48ec1662d0f10d6468907cdc7e12c46ca1ef497c (HEAD -> next-gicv4)
> Author: Christoffer Dall <christoffer.dall@linaro.org>
> Date:   Fri Nov 10 09:16:23 2017 +0100
> 
>     KVM: arm/arm64: Fix GICv4 ITS initialization issues
>     
>     We should only try to initialize GICv4 data structures on a GICv4
>     capable system.  Move the vgic_supports_direct_msis() check inito
>     vgic_v4_init() so that any KVM VGIC initialization path does not fail
>     on non-GICv4 systems.
>     
>     Also be slightly more strict in the checking of the return value in
>     vgic_its_create, and only error out on negative return values from the
>     vgic_v4_init() function.  This is important because the kvm device code
>     only treats negative values as errors and only cleans up in this case.
>     Errornously treating a positive return value as an error from the
>     vgic_v4_init() function can lead to NULL pointer dereferences, as has
>     recently been observed.
>     
>     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 40be908da238..62310122ee78 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -285,11 +285,9 @@ int vgic_init(struct kvm *kvm)
>  	if (ret)
>  		goto out;
>  
> -	if (vgic_supports_direct_msis(kvm)) {
> -		ret = vgic_v4_init(kvm);
> -		if (ret)
> -			goto out;
> -	}
> +	ret = vgic_v4_init(kvm);
> +	if (ret)
> +		goto out;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_enable(vcpu);
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index b8c1b724ba3e..c93ecd4a903b 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1673,7 +1673,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>  
>  	if (vgic_initialized(dev->kvm)) {
>  		int ret = vgic_v4_init(dev->kvm);
> -		if (ret) {
> +		if (ret < 0) {
>  			kfree(its);
>  			return ret;
>  		}
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index e367d65a0ebe..bb7e31fcee35 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -118,6 +118,9 @@ int vgic_v4_init(struct kvm *kvm)
>  	struct kvm_vcpu *vcpu;
>  	int i, nr_vcpus, ret;
>  
> +	if (!vgic_supports_direct_msis(kvm))
> +		return 0; /* Nothing to see here... move along. */
> +
>  	if (dist->its_vm.vpes)
>  		return 0;
>  
> 

Yup, this seems like the right thing to do.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
