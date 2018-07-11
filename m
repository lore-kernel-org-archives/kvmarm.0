From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v7 3/4] KVM: arm64: Share the parts of get/set events
 useful to 32bit
Date: Wed, 11 Jul 2018 15:16:21 +0800
Message-ID: <b392c9e1-d0e4-9674-a223-351b381db76c@huawei.com>
References: <20180710164952.23736-1-james.morse@arm.com>
 <20180710164952.23736-4-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B687149F86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jul 2018 03:04:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aoPdEy2GDO94 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jul 2018 03:04:20 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8059249F7F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jul 2018 03:04:20 -0400 (EDT)
In-Reply-To: <20180710164952.23736-4-james.morse@arm.com>
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
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, linuxarm@huawei.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2018/7/11 0:49, James Morse wrote:
> The get/set events helpers to do some work to check reserved
> and padding fields are zero. This is useful on 32bit too.
> 
> Move this code into virt/kvm/arm/arm.c, and give the arch
> code some underscores.
> 
> This is temporarily hidden behind __KVM_HAVE_VCPU_EVENTS until
> 32bit is wired up.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> CC: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  8 ++++----
>  arch/arm64/kvm/guest.c            | 21 ++++-----------------
>  virt/kvm/arm/arm.c                | 28 ++++++++++++++++++++++++++++
>  3 files changed, 36 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 45a384b0a78a..66d09b44ebd8 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -350,11 +350,11 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
>  int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
>  int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>  int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> -int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
> -			    struct kvm_vcpu_events *events);
> +int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
> +			      struct kvm_vcpu_events *events);
>  
> -int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> -			    struct kvm_vcpu_events *events);
> +int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> +			      struct kvm_vcpu_events *events);
>  
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
>  int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index dd05be96d981..725c7545e91a 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -289,11 +289,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>  	return -EINVAL;
>  }
>  
> -int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
> -			struct kvm_vcpu_events *events)
> +int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
> +			      struct kvm_vcpu_events *events)
>  {
> -	memset(events, 0, sizeof(*events));
> -
>  	events->exception.serror_pending = !!(vcpu->arch.hcr_el2 & HCR_VSE);
>  	events->exception.serror_has_esr = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
>  
> @@ -303,23 +301,12 @@ int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> -			struct kvm_vcpu_events *events)
> +int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> +			      struct kvm_vcpu_events *events)
>  {
> -	int i;
>  	bool serror_pending = events->exception.serror_pending;
>  	bool has_esr = events->exception.serror_has_esr;
>  
> -	/* check whether the reserved field is zero */
> -	for (i = 0; i < ARRAY_SIZE(events->reserved); i++)
> -		if (events->reserved[i])
> -			return -EINVAL;
> -
> -	/* check whether the pad field is zero */
> -	for (i = 0; i < ARRAY_SIZE(events->exception.pad); i++)
> -		if (events->exception.pad[i])
> -			return -EINVAL;
> -
>  	if (serror_pending && has_esr) {
>  		if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
>  			return -EINVAL;
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index a94eab71e5c7..f70d24e1751d 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1044,6 +1044,34 @@ static int kvm_arm_vcpu_has_attr(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> +#ifdef __KVM_HAVE_VCPU_EVENTS	/* temporary: until 32bit is wired up */
> +static int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
> +				   struct kvm_vcpu_events *events)
> +{
> +	memset(events, 0, sizeof(*events));
> +
> +	return __kvm_arm_vcpu_get_events(vcpu, events);
> +}
> +
> +static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> +				   struct kvm_vcpu_events *events)
> +{
> +	int i;
> +
> +	/* check whether the reserved field is zero */
> +	for (i = 0; i < ARRAY_SIZE(events->reserved); i++)
> +		if (events->reserved[i])
> +			return -EINVAL;
> +
> +	/* check whether the pad field is zero */
> +	for (i = 0; i < ARRAY_SIZE(events->exception.pad); i++)
> +		if (events->exception.pad[i])
> +			return -EINVAL;
> +
> +	return __kvm_arm_vcpu_set_events(vcpu, events);
> +}
> +#endif /* __KVM_HAVE_VCPU_EVENTS */
In [PATCH v7 4/4] KVM: arm: Add 32bit get/set events support, I see you remove "__KVM_HAVE_VCPU_EVENTS" in kvm_arch_vcpu_ioctl()
but here it adds, it looks like strange.
so maybe it is better keep it in both place, or remove them both.

>From the comments /* temporary: until 32bit is wired up */, do you forget to remove the __KVM_HAVE_VCPU_EVENTS	after wiring up the 32bit?

> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
> 
