From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 38/52] KVM: arm/arm64: GICv4: Wire init/teardown of
 per-VM support
Date: Mon, 10 Jul 2017 17:34:30 +0100
Message-ID: <4dcb1494-fe1f-2ace-2d1e-521b1dddc585@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
 <20170628150411.15846-39-marc.zyngier@arm.com>
 <738d2df9-c2b0-1444-8940-1027cf6fdd46@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C133640CE9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jul 2017 12:34:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fW1v0W29x6fx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jul 2017 12:34:01 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F2A40A86
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jul 2017 12:34:01 -0400 (EDT)
In-Reply-To: <738d2df9-c2b0-1444-8940-1027cf6fdd46@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: shankerd@codeaurora.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/07/17 12:26, Shanker Donthineni wrote:
> Hi Marc,
> 
> On 06/28/2017 10:03 AM, Marc Zyngier wrote:
>> Should the HW support GICv4 and an ITS being associated with this
>> VM, let's init the its_vm and its_vpe structures.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-init.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>> index 3a0b8999f011..0de1f0d986d4 100644
>> --- a/virt/kvm/arm/vgic/vgic-init.c
>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>> @@ -285,8 +285,14 @@ int vgic_init(struct kvm *kvm)
>>  	if (ret)
>>  		goto out;
>>  
>> -	if (vgic_has_its(kvm))
>> +	if (vgic_has_its(kvm)) {
>>  		dist->msis_require_devid = true;
>> +		if (kvm_vgic_global_state.has_gicv4) {
>> +			ret = vgic_v4_init(kvm);
>> +			if (ret)
>> +				goto out;
>> +		}
> 
> This is not quite right, ITS virtual device may not be initialized at the time of 
> calling vgic-init(). This change breaks the existing KVM functionality with QEMU
> hypervisor tool. In later patches, code assumes vgic_v4_init(kvm) was called when
> vgic_has_its(kvm) returns a true value. 
> 
> The right change would be move this logic to inside vgic_its_create() something like this.
> 
>  --- a/virt/kvm/arm/vgic/vgic-init.c
>  +++ b/virt/kvm/arm/vgic/vgic-init.c
>  @@ -285,14 +285,8 @@ int vgic_init(struct kvm *kvm)
>          if (ret)
>                  goto out;
>  
>  -       if (vgic_has_its(kvm)) { 
>  +       if (vgic_has_its(kvm))
>                  dist->msis_require_devid = true;
>  -               if (kvm_vgic_global_state.has_gicv4) {
>  -                       ret = vgic_v4_init(kvm);
>  -                       if (ret)
>  -                               goto out;
>  -               }
>  -       }
>  
>          kvm_for_each_vcpu(i, vcpu, kvm)
>                  kvm_vgic_vcpu_enable(vcpu);
> 
>  --- a/virt/kvm/arm/vgic/vgic-its.c
>  +++ b/virt/kvm/arm/vgic/vgic-its.c
>  @@ -1637,6 +1637,7 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct
>   static int vgic_its_create(struct kvm_device *dev, u32 type)
>   {
>          struct vgic_its *its;
>  +       int ret;
>  
>          if (type != KVM_DEV_TYPE_ARM_VGIC_ITS) 
>                  return -ENODEV;
>  @@ -1657,6 +1658,12 @@ static int vgic_its_create(struct kvm_device *dev, u32 ty
>          its->enabled = false;
>          its->dev = dev;
>   
>  +       if (kvm_vgic_global_state.has_gicv4) {
>  +               ret = vgic_v4_init(dev->kvm);
>  +               if (ret)
>  +                       return -ENOMEM;
>  +       }
>  +

This approach is pretty busted if you have more than a single virtual
ITS, as you now leak memory from the VPE array and IRQ domain allocations.

Also, there is no guarantee that we've created all vcpus by the time we
create an ITS, so this approach fails as well ("create vcpu 1, create
ITS, create vcpu 2, init vgic" is a valid sequence).

I guess we need to call vgic_v4_init() on both vgic_init() and
its_create(), and only perform the GICv4 init if the vgic has already
been initialized.

Or we simply restrict the order to be vgic_init() last, and fix
userspace to respect that order. Not enabling GICv4 won't break SW. It
may even be faster.

	M.
-- 
Jazz is not dead. It just smells funny...
