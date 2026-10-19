Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72414F4039
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 13:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416273; cv=none; b=sfqsNeR5YjFx3vppIhh5hqIK/JKmfgCkYxmzfVOgTTU5oG4GlOY6+6nLLLvER2VN/HC5HSmeBEFUZbg/r6Mr8XSFA6fQ5gnRfOseXJH5nlt8m7g1JeswufGbyF//21tUPwefvYve/fQ+qtUK7TUZrl/2wwbVltXUAUw+g/7oiW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416273; c=relaxed/simple;
	bh=fDkFGAJIewpSZCZEpiACGen5Ds7hOG+tTHb8YHWdPKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ejTkgJrHHI3E5/8+W2e75CS4wLKuUIFqJL+69B7IYgXPi/P723aE2oyeZ8YlyBThmTM9/xhSAdUXHhh4/gUxuRvB7bCfGXaTa8sXo2LJ0qA4BoZ60bBv+tC8c+bTfDOIaD0S7SEiWWyAzVYgI1CJAABGspoHe2xn1x9DezI2LQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rElGef7D; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rElGef7D"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 078D31682;
	Mon, 19 Oct 2026 06:24:26 -0700 (PDT)
Received: from [10.0.136.108] (M0PRX50XMG.cambridge.arm.com [10.0.136.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1EC13F7D8;
	Mon, 19 Oct 2026 06:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792416269; bh=fDkFGAJIewpSZCZEpiACGen5Ds7hOG+tTHb8YHWdPKM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rElGef7DRAE+Tjg5yoNlldt1qmnVWEXGcX9op4jU1NNy+H4uGmpe7gP+C1zYaE/OG
	 rnf/bPXkKlIgygU3XH4IgDfBU+zFUorAsUkQceGGTP+dCdZjD5gdnPbNDSSqCmn+cm
	 0nEvwvgLWT6rNPUzRBNY9LrwmuowaaFbKd9aLjRE=
Message-ID: <00455317-5671-48ff-b773-fd40ddb2ad7b@arm.com>
Date: Mon, 19 Oct 2026 14:24:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Require matching VGIC model for
 GICv3 ITS
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com
References: <20261016152225.898761-1-sascha.bischoff@arm.com>
 <20261016152225.898761-2-sascha.bischoff@arm.com>
 <87y0bw8rzm.wl-maz@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <87y0bw8rzm.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 17/10/2026 12:51, Marc Zyngier wrote:
> On Fri, 16 Oct 2026 16:22:23 +0100,
> Sascha Bischoff <sascha.bischoff@arm.com> wrote:
>>
>> On a GICv5 host with legacy support, KVM registers both VGICv3 and
>> VGICv5 devices. A VM can create a GICv3 ITS with another VGIC model,
>> setting has_its even though that model cannot use the GICv3 ITS.
>>
>> Reject GICv3 ITS creation when the VM already has an incompatible VGIC.
>> KVM also permits creating an ITS before its VGIC, so record the model
>> required by the ITS and reject a later incompatible VGIC. Preserve
>> either creation order when the models match.
>>
>> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
>> ---
>>   arch/arm64/kvm/vgic/vgic-init.c | 5 +++++
>>   arch/arm64/kvm/vgic/vgic-its.c  | 9 +++++++++
>>   include/kvm/arm_vgic.h          | 2 ++
>>   3 files changed, 16 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
>> index b5ea1e39c6862..48a92555fa6ab 100644
>> --- a/arch/arm64/kvm/vgic/vgic-init.c
>> +++ b/arch/arm64/kvm/vgic/vgic-init.c
>> @@ -125,6 +125,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>>   		goto out_unlock;
>>   	}
>>   
>> +	if (kvm->arch.vgic.its_model && kvm->arch.vgic.its_model != type) {
>> +		ret = -ENODEV;
>> +		goto out_unlock;
>> +	}
>> +
>>   	if (kvm_id_regs_final(kvm))
>>   		goto out_unlock;
>>   	ret = 0;
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> index e5657cb603567..bf901626ea6df 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -1875,6 +1875,14 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>>   
>>   	mutex_lock(&dev->kvm->arch.config_lock);
>>   
>> +	if ((irqchip_in_kernel(dev->kvm) && !vgic_is_v3(dev->kvm)) ||
>> +	    (dev->kvm->arch.vgic.its_model &&
>> +	     dev->kvm->arch.vgic.its_model != KVM_DEV_TYPE_ARM_VGIC_V3)) {
>> +		mutex_unlock(&dev->kvm->arch.config_lock);
>> +		kfree(its);
>> +		return -ENODEV;
>> +	}
>> +
> 
> A comment would go a long way to make it clear what this is checking
> for:
> 
> 	- if a GIC already exists and is not v3, fail
> 	- if an ITS already exists and is not v3, fail
> 

Noted; have added a comment to explain what we are doing.

>>   	if (vgic_initialized(dev->kvm)) {
>>   		ret = vgic_v4_init(dev->kvm);
>>   		if (ret < 0) {
>> @@ -1903,6 +1911,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>>   
>>   	dev->kvm->arch.vgic.msis_require_devid = true;
>>   	dev->kvm->arch.vgic.has_its = true;
>> +	dev->kvm->arch.vgic.its_model = KVM_DEV_TYPE_ARM_VGIC_V3;
>>   	its->enabled = false;
>>   	its->dev = dev;
>>   
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 7be81b936bf10..a2b6b328808ba 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -548,6 +548,8 @@ struct vgic_dist {
>>   	struct vgic_io_device	cpuif_iodev;
>>   
>>   	bool			has_its;
>> +	/* VGIC model required by the VM's ITS devices. */
>> +	u32			its_model;
> 
> I reckon that has_its and its_model can be made the same thing, since
> its_model == 0 indicates the lack of ITS, and it is otherwise the same
> as vgic_model.
> 
> I ended up with this (untested). Thoughts?

Overall, I think it is a good idea but doesn't quite work the way you've 
written it as it is possible for both the vgic_model and the its_model 
to be 0 (the defaults), which results in falsely returning true. One 
needs to explicitly check for its_model being non-zero first. More 
details below.

> 
> 	M.
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 2d915769cdc7c..c70390b7fcab6 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -456,6 +456,9 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>   		 */
>   		if (vcpu->vcpu_id >= kvm_vgic_global_state.max_gicv5_vcpus)
>   			return -EINVAL;
> +		break;
> +	default:
> +		unreachable();

This switch currently doesn't include GICv2, so that needs to be added 
to make sure that this unreachable() is unreachable.

>   	}
>   
>   	return ret;
> @@ -572,6 +575,8 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>   		kfree(dist->vgic_v5_irs_data);
>   		dist->vgic_v5_irs_data = NULL;
>   		break;
> +	default:
> +		unreachable();

kvm_vgic_destroy() is called proactively as part of tearing down a VM. 
That calls kvm_vgic_dist_destroy(). Therefore, this can be called before 
a vgic_model has been set. Therefore, this unreachable() is reachable. 
Either we leave this as reachable, or we return early if vgic_model is 
unset. Alas, we can't include the lack of a model in the switch, as 
there's no enum def for NO_DEVICE, so we need to do that early.

>   	}
>   
>   	xa_destroy(&dist->lpi_xa);
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 0ec461df74cd9..171e5e345c220 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -1963,7 +1963,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>   	xa_init(&its->translation_cache);
>   
>   	dev->kvm->arch.vgic.msis_require_devid = true;
> -	dev->kvm->arch.vgic.has_its = true;
>   	dev->kvm->arch.vgic.its_model = KVM_DEV_TYPE_ARM_VGIC_V3;
>   	its->enabled = false;
>   	its->dev = dev;
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 636c576b2b99e..282fac37b6642 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -42,10 +42,7 @@ bool vgic_has_its(struct kvm *kvm)
>   {
>   	struct vgic_dist *dist = &kvm->arch.vgic;
>   
> -	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> -		return false;
> -
> -	return dist->has_its;
> +	return (dist->its_model == dist->vgic_model);

One needs to avoid the case where both the its_model and the vgic_model 
is unset incorrectly returning true. Therefore, this becomes:

     return dist->its_model && (dist->its_model == dist->vgic_model);

I don't *think* it is an issue with the code as it stands, but if this 
were called before the vgic itself was created, then it would return 
false, even if the ITS itself has been created.

Maybe the better test is to just check if its_model is non-zero? I.e.,

     return !!dist->its_model;

Frankly, I think that this second version is the safer one, albeit less 
rigorous. It feels strange to me that a check for having an ITS would 
return false until the rest of the vgic has been created, and just risks 
some future code checking it at the wrong time.

I'll post a new version of this shortly.

Thanks for the feedback!

Sascha

>   }
>   
>   bool vgic_supports_direct_msis(struct kvm *kvm)
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index c4135815884b6..4b2c41917b77c 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -503,7 +503,9 @@ struct vgic_dist {
>   	bool			initialized;
>   
>   	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
> -	u32			vgic_model;
> +	enum kvm_device_type	vgic_model;
> +	/* VGIC model required by the VM's ITS devices. */
> +	enum kvm_device_type	its_model;
>   
>   	/* Implementation revision as reported in the GICD_IIDR */
>   	u32			implementation_rev;
> @@ -548,9 +550,6 @@ struct vgic_dist {
>   	struct vgic_io_device	dist_iodev;
>   	struct vgic_io_device	cpuif_iodev;
>   
> -	bool			has_its;
> -	/* VGIC model required by the VM's ITS devices. */
> -	u32			its_model;
>   	bool			table_write_in_progress;
>   
>   	/*
> 

