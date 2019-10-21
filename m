Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63C6CA9EAF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 11:01:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 59AB22084C
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 11:01:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59AB22084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D04594A96B;
	Mon, 21 Oct 2019 07:01:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sgeiv2-bSzDn; Mon, 21 Oct 2019 07:01:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86CC04A991;
	Mon, 21 Oct 2019 07:01:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12B074A96B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 07:01:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rk2tDdvypH0e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 07:01:13 -0400 (EDT)
Received: from foss.arm.com (unknown [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9861C4A87D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 07:01:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E950CA3;
 Mon, 21 Oct 2019 04:00:53 -0700 (PDT)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C77D3F718;
 Mon, 21 Oct 2019 04:00:51 -0700 (PDT)
Subject: Re: [PATCH v6 07/10] KVM: arm64: Provide VCPU attributes for stolen
 time
To: Marc Zyngier <maz@kernel.org>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-8-steven.price@arm.com> <86d0etynxv.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <28b3a004-b951-72fb-35fe-1f58673e6e93@arm.com>
Date: Mon, 21 Oct 2019 12:00:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <86d0etynxv.wl-maz@kernel.org>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 19/10/2019 12:28, Marc Zyngier wrote:
> On Fri, 11 Oct 2019 13:59:27 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> Allow user space to inform the KVM host where in the physical memory
>> map the paravirtualized time structures should be located.
>>
>> User space can set an attribute on the VCPU providing the IPA base
>> address of the stolen time structure for that VCPU. This must be
>> repeated for every VCPU in the VM.
>>
>> The address is given in terms of the physical address visible to
>> the guest and must be 64 byte aligned. The guest will discover the
>> address via a hypercall.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_host.h |  7 +++++
>>  arch/arm64/include/uapi/asm/kvm.h |  2 ++
>>  arch/arm64/kvm/guest.c            |  9 ++++++
>>  include/uapi/linux/kvm.h          |  2 ++
>>  virt/kvm/arm/pvtime.c             | 47 +++++++++++++++++++++++++++++++
>>  5 files changed, 67 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 1697e63f6dd8..6af16b29a41f 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -489,6 +489,13 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
>>  long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu);
>>  int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init);
>>  
>> +int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
>> +			    struct kvm_device_attr *attr);
>> +int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
>> +			    struct kvm_device_attr *attr);
>> +int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
>> +			    struct kvm_device_attr *attr);
>> +
>>  static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
>>  {
>>  	vcpu_arch->steal.base = GPA_INVALID;
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index 67c21f9bdbad..cff1ba12c768 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -323,6 +323,8 @@ struct kvm_vcpu_events {
>>  #define KVM_ARM_VCPU_TIMER_CTRL		1
>>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
>> +#define KVM_ARM_VCPU_PVTIME_CTRL	2
>> +#define   KVM_ARM_VCPU_PVTIME_IPA	0
>>  
>>  /* KVM_IRQ_LINE irq field index values */
>>  #define KVM_ARM_IRQ_VCPU2_SHIFT		28
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index dfd626447482..d3ac9d2fd405 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -858,6 +858,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>>  	case KVM_ARM_VCPU_TIMER_CTRL:
>>  		ret = kvm_arm_timer_set_attr(vcpu, attr);
>>  		break;
>> +	case KVM_ARM_VCPU_PVTIME_CTRL:
>> +		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
>> +		break;
>>  	default:
>>  		ret = -ENXIO;
>>  		break;
>> @@ -878,6 +881,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>>  	case KVM_ARM_VCPU_TIMER_CTRL:
>>  		ret = kvm_arm_timer_get_attr(vcpu, attr);
>>  		break;
>> +	case KVM_ARM_VCPU_PVTIME_CTRL:
>> +		ret = kvm_arm_pvtime_get_attr(vcpu, attr);
>> +		break;
>>  	default:
>>  		ret = -ENXIO;
>>  		break;
>> @@ -898,6 +904,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>  	case KVM_ARM_VCPU_TIMER_CTRL:
>>  		ret = kvm_arm_timer_has_attr(vcpu, attr);
>>  		break;
>> +	case KVM_ARM_VCPU_PVTIME_CTRL:
>> +		ret = kvm_arm_pvtime_has_attr(vcpu, attr);
>> +		break;
>>  	default:
>>  		ret = -ENXIO;
>>  		break;
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 52641d8ca9e8..a540c8357049 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1227,6 +1227,8 @@ enum kvm_device_type {
>>  #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
>>  	KVM_DEV_TYPE_XIVE,
>>  #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
>> +	KVM_DEV_TYPE_ARM_PV_TIME,
>> +#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
>>  	KVM_DEV_TYPE_MAX,
>>  };
>>  
>> diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
>> index a90f1b4ebd13..9dc466861e1e 100644
>> --- a/virt/kvm/arm/pvtime.c
>> +++ b/virt/kvm/arm/pvtime.c
>> @@ -2,7 +2,9 @@
>>  // Copyright (C) 2019 Arm Ltd.
>>  
>>  #include <linux/arm-smccc.h>
>> +#include <linux/kvm_host.h>
>>  
>> +#include <asm/kvm_mmu.h>
>>  #include <asm/pvclock-abi.h>
>>  
>>  #include <kvm/arm_hypercalls.h>
>> @@ -75,3 +77,48 @@ long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
>>  
>>  	return vcpu->arch.steal.base;
>>  }
>> +
>> +int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
>> +			    struct kvm_device_attr *attr)
>> +{
>> +	u64 __user *user = (u64 __user *)attr->addr;
>> +	u64 ipa;
>> +
>> +	if (attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
>> +		return -ENXIO;
>> +
>> +	if (get_user(ipa, user))
>> +		return -EFAULT;
>> +	if (!IS_ALIGNED(ipa, 64))
>> +		return -EINVAL;
>> +	if (vcpu->arch.steal.base != GPA_INVALID)
>> +		return -EEXIST;
>> +	vcpu->arch.steal.base = ipa;
> 
> And what if this IPA doesn't point to any memslot? I understand that
> everything will still work (kvm_put_user()) will handle the mishap,
> but it makes it hard for userspace to know that something is wrong.
> 
> Is there any problem in mandating that the corresponding memslot
> already has been created, and enforcing this check?

No that could be done. As you mentioned nothing bad will happen (to the
host) if this is wrong, so I didn't see the need to enforce that the
memory is setup first. And the check will be pretty weak because nothing
stop the memslot vanishing after the check. But I guess this might make
it easier to figure out what has gone wrong in user space, and we can
always remove this ordering restriction in future if necessary. So I'll
add a check for now.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
