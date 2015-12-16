From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 19/19] KVM: ARM64: Add a new kvm ARM PMU device
Date: Wed, 16 Dec 2015 09:04:40 +0000
Message-ID: <56712928.8050409@arm.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com> <1450169379-12336-20-git-send-email-zhaoshenglong@huawei.com> <567032AD.8000206@arm.com> <567036DE.80605@linaro.org> <567038E3.3010102@arm.com> <20151215204739.GK4120@cbox> <56711348.6010406@huawei.com> <56711B99.1000608@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56711B99.1000608@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 16/12/15 08:06, Shannon Zhao wrote:
> Hi,
> 
> On 2015/12/16 15:31, Shannon Zhao wrote:
>>>>>>>> But in this case, you're returning an error if it is *not* initialized.
>>>>>>>> I understand that in that case you cannot return an interrupt number (-1
>>>>>>>> would be weird), but returning -EBUSY feels even more weird.
>>>>>>>>
>>>>>>>> I'd settle for -ENOXIO, or something similar. Anyone having a better idea?
>>>>>>>>
>>>> ENXIO or ENODEV would be my choice too, and add that to the
>>>> Documentation clearly describing when this error code is used.
>>>>
>>>> By the way, why do you loop over all VCPUS to set the same value when
>>>> you can't do anything per VCPU anyway?  It seems to me it's either a
>>>> per-VM property (that you can store on the VM data structure) or it's a
>>>> true per-VCPU property?
>> This is a per-VCPU property. PMU interrupt could be PPI or SPI. For PPI
>> the interrupt numbers are same for each vcpu, while for SPI they are
>> different, so it needs to set them separately. I planned to support both
>> PPI and SPI. I think I should add support for SPI at this moment and let
>> users (QEMU) to set these interrupts for each one.
> 
> How about below vPMU Documentation?
> 
> ARM Virtual Performance Monitor Unit (vPMU)
> ===========================================
> 
> Device types supported:
>   KVM_DEV_TYPE_ARM_PMU_V3         ARM Performance Monitor Unit v3
> 
> Instantiate one PMU instance for per VCPU through this API.
> 
> Groups:
>   KVM_DEV_ARM_PMU_GRP_IRQ
>   Attributes:
>     The attr field of kvm_device_attr encodes two values:
>     bits:     | 63 .... 32 | 31 .... 0 |
>     values:   | vcpu_index |  irq_num  |
>     The irq_num describes the PMU overflow interrupt number for the
> specified
>     vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one
> VM the
>     interrupt type must be same for each vcpu.
> 
>   Errors:
>     -ENXIO: Getting or setting this attribute is not yet supported
>     -ENODEV: Getting the PMU overflow interrupt number while it's not set
>     -EBUSY: The PMU overflow interrupt is already set
>     -EINVAL: Invalid vcpu_index or irq_num supplied
> 
> 

Let's add at least one comment that forbids two vcpus from getting the
same SPI. This is too common a mistake that we see in actual SoCs, and I
don't want to see it replicated in VMs...

Thanks,

	M.

-- 
Jazz is not dead. It just smells funny...
