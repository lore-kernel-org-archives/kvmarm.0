Return-Path: <SRS0=3tuy=W2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731C8C3A5A7
	for <kvmarm@archiver.kernel.org>; Fri, 30 Aug 2019 10:02:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 022742186A
	for <kvmarm@archiver.kernel.org>; Fri, 30 Aug 2019 10:02:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 022742186A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4385E4A55F;
	Fri, 30 Aug 2019 06:02:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bU2DApArHXJ0; Fri, 30 Aug 2019 06:02:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0BB84A529;
	Fri, 30 Aug 2019 06:02:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17AF14A529
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Aug 2019 06:02:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u5nlIiS1-rCg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Aug 2019 06:02:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A330C4A4EE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Aug 2019 06:02:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A7A5344;
 Fri, 30 Aug 2019 03:02:26 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 A37183F718; Fri, 30 Aug 2019 03:02:22 -0700 (PDT)
Subject: Re: [PATCH v4 07/10] KVM: arm64: Provide VCPU attributes for stolen
 time
To: Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190830084255.55113-8-steven.price@arm.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <36104ec0-2237-fb0e-376f-ab50c23c6101@kernel.org>
Date: Fri, 30 Aug 2019 11:02:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190830084255.55113-8-steven.price@arm.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 30/08/2019 09:42, Steven Price wrote:
> Allow user space to inform the KVM host where in the physical memory
> map the paravirtualized time structures should be located.
> 
> User space can set an attribute on the VCPU providing the IPA base
> address of the stolen time structure for that VCPU. This must be
> repeated for every VCPU in the VM.
> 
> The address is given in terms of the physical address visible to
> the guest and must be 64 byte aligned. The guest will discover the
> address via a hypercall.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  7 +++++
>  arch/arm64/include/uapi/asm/kvm.h |  2 ++
>  arch/arm64/kvm/guest.c            |  9 ++++++
>  include/uapi/linux/kvm.h          |  2 ++
>  virt/kvm/arm/pvtime.c             | 47 +++++++++++++++++++++++++++++++
>  5 files changed, 67 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1697e63f6dd8..6af16b29a41f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -489,6 +489,13 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
>  long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu);
>  int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init);
>  
> +int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
> +			    struct kvm_device_attr *attr);
> +int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
> +			    struct kvm_device_attr *attr);
> +int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
> +			    struct kvm_device_attr *attr);
> +
>  static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
>  {
>  	vcpu_arch->steal.base = GPA_INVALID;
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9a507716ae2f..bde9f165ad3a 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -323,6 +323,8 @@ struct kvm_vcpu_events {
>  #define KVM_ARM_VCPU_TIMER_CTRL		1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> +#define KVM_ARM_VCPU_PVTIME_CTRL	2
> +#define   KVM_ARM_VCPU_PVTIME_SET_IPA	0
>  
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index dfd626447482..d3ac9d2fd405 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -858,6 +858,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  	case KVM_ARM_VCPU_TIMER_CTRL:
>  		ret = kvm_arm_timer_set_attr(vcpu, attr);
>  		break;
> +	case KVM_ARM_VCPU_PVTIME_CTRL:
> +		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> @@ -878,6 +881,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>  	case KVM_ARM_VCPU_TIMER_CTRL:
>  		ret = kvm_arm_timer_get_attr(vcpu, attr);
>  		break;
> +	case KVM_ARM_VCPU_PVTIME_CTRL:
> +		ret = kvm_arm_pvtime_get_attr(vcpu, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> @@ -898,6 +904,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  	case KVM_ARM_VCPU_TIMER_CTRL:
>  		ret = kvm_arm_timer_has_attr(vcpu, attr);
>  		break;
> +	case KVM_ARM_VCPU_PVTIME_CTRL:
> +		ret = kvm_arm_pvtime_has_attr(vcpu, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5e3f12d5359e..265156a984f2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1222,6 +1222,8 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
>  	KVM_DEV_TYPE_XIVE,
>  #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
> +	KVM_DEV_TYPE_ARM_PV_TIME,
> +#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
>  	KVM_DEV_TYPE_MAX,
>  };
>  
> diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
> index d9d0dbc6994b..7b1834b98a68 100644
> --- a/virt/kvm/arm/pvtime.c
> +++ b/virt/kvm/arm/pvtime.c
> @@ -2,7 +2,9 @@
>  // Copyright (C) 2019 Arm Ltd.
>  
>  #include <linux/arm-smccc.h>
> +#include <linux/kvm_host.h>
>  
> +#include <asm/kvm_mmu.h>
>  #include <asm/pvclock-abi.h>
>  
>  #include <kvm/arm_hypercalls.h>
> @@ -75,3 +77,48 @@ long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
>  
>  	return vcpu->arch.steal.base;
>  }
> +
> +int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
> +			    struct kvm_device_attr *attr)
> +{
> +	u64 __user *user = (u64 __user *)attr->addr;
> +	u64 ipa;
> +
> +	if (attr->attr != KVM_ARM_VCPU_PVTIME_SET_IPA)
> +		return -ENXIO;
> +
> +	if (get_user(ipa, user))
> +		return -EFAULT;
> +	if (ipa & 63)

nit: Please express this as !IS_ALIGNED(ipa, 64) instead.

> +		return -EINVAL;
> +	if (vcpu->arch.steal.base != GPA_INVALID)
> +		return -EEXIST;
> +	vcpu->arch.steal.base = ipa;

I'm still worried that you end-up not knowing whether the IPA is valid
or not at this stage, nor that we check about overlapping vcpus. How do
we validate that?

I also share Christoffer's concern that the memslot parsing may be
expensive on a system with multiple memslots. But maybe that can be
solved by adding some caching capabilities to your kvm_put_guest(),
should this become a problem.

> +	return 0;
> +}
> +
> +int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
> +			    struct kvm_device_attr *attr)
> +{
> +	u64 __user *user = (u64 __user *)attr->addr;
> +	u64 ipa;
> +
> +	if (attr->attr != KVM_ARM_VCPU_PVTIME_SET_IPA)

It is a bit odd that this is using "SET_IPA" as a way to GET it.

> +		return -ENXIO;
> +
> +	ipa = vcpu->arch.steal.base;
> +
> +	if (put_user(ipa, user))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
> +			    struct kvm_device_attr *attr)
> +{
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_PVTIME_SET_IPA:
> +		return 0;
> +	}
> +	return -ENXIO;
> +}
> 

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
