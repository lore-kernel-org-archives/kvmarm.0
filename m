From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 7/7] KVM: arm: implement kvm_set_msi by gsi direct mapping
Date: Thu, 02 Jul 2015 17:02:40 +0200
Message-ID: <55955290.1030009@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-8-git-send-email-eric.auger@linaro.org>
 <015501d0b49c$1f1349c0$5d39dd40$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF4F6577A5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 10:51:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CLeJb-ko+c78 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 10:51:42 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8357C5778B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 10:51:42 -0400 (EDT)
Received: by wiwl6 with SMTP id l6so199925774wiw.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 08:02:58 -0700 (PDT)
In-Reply-To: <015501d0b49c$1f1349c0$5d39dd40$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,
On 07/02/2015 09:53 AM, Pavel Fedin wrote:
>  Hello!
> 
>> -----Original Message-----
>> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Eric Auger
>> Sent: Monday, June 29, 2015 6:37 PM
>> To: eric.auger@st.com; eric.auger@linaro.org; linux-arm-kernel@lists.infradead.org;
>> marc.zyngier@arm.com; christoffer.dall@linaro.org; andre.przywara@arm.com;
>> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org; patches@linaro.org; p.fedin@samsung.com; pbonzini@redhat.com
>> Subject: [PATCH 7/7] KVM: arm: implement kvm_set_msi by gsi direct mapping
>>
>> If the ITS modality is not available, let's simply support MSI
>> injection by transforming the MSI.data into an SPI ID.
>>
>> This becomes possible to use KVM_SIGNAL_MSI ioctl for arm too.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  arch/arm/kvm/Kconfig | 1 +
>>  virt/kvm/arm/vgic.c  | 5 +++++
>>  2 files changed, 6 insertions(+)
>>
>> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
>> index 151e710..0f58baf 100644
>> --- a/arch/arm/kvm/Kconfig
>> +++ b/arch/arm/kvm/Kconfig
>> @@ -31,6 +31,7 @@ config KVM
>>  	select KVM_VFIO
>>  	select HAVE_KVM_EVENTFD
>>  	select HAVE_KVM_IRQFD
>> +	select HAVE_KVM_MSI
>>  	select HAVE_KVM_IRQCHIP
>>  	select HAVE_KVM_IRQ_ROUTING
>>  	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 0b4c48c..b3c10dc 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -2314,6 +2314,11 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>>  			return kvm->arch.vgic.vm_ops.inject_msi(kvm, &msi);
>>  		else
>>  			return -ENODEV;
>> +	case KVM_IRQ_ROUTING_MSI:
>> +		if (kvm->arch.vgic.vm_ops.inject_msi)
>> +			return -EINVAL;
>> +		else
>> +			return kvm_vgic_inject_irq(kvm, 0, e->msi.data, level);
> 
>  Given API change i suggest (using KVM_MSI_VALID_DEVID flag), we could get rid of all these if()'s
> here. Just forward all parameters to vGIC implementation code and let it do its checks.
I don't understand this comment. Here this is the kernel struct that is
used (struct kvm_kernel_irq_routing_entry) and not the user one
(kvm_irq_routing_entry). The kernel struct does not have the flag field.
Another reason I think to keep using the type for homogeneity. To be
noted that in the kernel struct, the devid is passed in
kvm_extended_msi, as you suggested for the user-space struct.

Thanks

Eric
> 
>>  	default:
>>  		return -EINVAL;
>>  	}
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
