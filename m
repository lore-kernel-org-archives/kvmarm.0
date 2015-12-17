From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 19/19] KVM: ARM64: Add a new kvm ARM PMU device
Date: Thu, 17 Dec 2015 08:33:14 +0000
Message-ID: <20151217083314.2ed36f9f@why.wild-wind.fr.eu.org>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
	<1450169379-12336-20-git-send-email-zhaoshenglong@huawei.com>
	<567032AD.8000206@arm.com>
	<567036DE.80605@linaro.org>
	<567038E3.3010102@arm.com>
	<20151215204739.GK4120@cbox>
	<56711348.6010406@huawei.com>
	<56711B99.1000608@huawei.com>
	<20151216203336.GE24889@cbox>
	<567262CA.6050905@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <567262CA.6050905@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 17 Dec 2015 15:22:50 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

> 
> 
> On 2015/12/17 4:33, Christoffer Dall wrote:
> > On Wed, Dec 16, 2015 at 04:06:49PM +0800, Shannon Zhao wrote:
> >> Hi,
> >>
> >> On 2015/12/16 15:31, Shannon Zhao wrote:
> >>>>>>>>> But in this case, you're returning an error if it is *not* initialized.
> >>>>>>>>> I understand that in that case you cannot return an interrupt number (-1
> >>>>>>>>> would be weird), but returning -EBUSY feels even more weird.
> >>>>>>>>>
> >>>>>>>>> I'd settle for -ENOXIO, or something similar. Anyone having a better idea?
> >>>>>>>>>
> >>>>> ENXIO or ENODEV would be my choice too, and add that to the
> >>>>> Documentation clearly describing when this error code is used.
> >>>>>
> >>>>> By the way, why do you loop over all VCPUS to set the same value when
> >>>>> you can't do anything per VCPU anyway?  It seems to me it's either a
> >>>>> per-VM property (that you can store on the VM data structure) or it's a
> >>>>> true per-VCPU property?
> >>> This is a per-VCPU property. PMU interrupt could be PPI or SPI. For PPI
> >>> the interrupt numbers are same for each vcpu, while for SPI they are
> >>> different, so it needs to set them separately. I planned to support both
> >>> PPI and SPI. I think I should add support for SPI at this moment and let
> >>> users (QEMU) to set these interrupts for each one.
> >>
> >> How about below vPMU Documentation?
> >>
> >> ARM Virtual Performance Monitor Unit (vPMU)
> >> ===========================================
> >>
> >> Device types supported:
> >>   KVM_DEV_TYPE_ARM_PMU_V3         ARM Performance Monitor Unit v3
> >>
> >> Instantiate one PMU instance for per VCPU through this API.
> >>
> >> Groups:
> >>   KVM_DEV_ARM_PMU_GRP_IRQ
> >>   Attributes:
> >>     The attr field of kvm_device_attr encodes two values:
> >>     bits:     | 63 .... 32 | 31 .... 0 |
> >>     values:   | vcpu_index |  irq_num  |
> BTW, I change this Attribute to below format and pass vcpu_index through
> this Attribute while pass irq_num through kvm_device_attr.addr.
> Is it fine?
> 
>     bits:     | 63 .... 32 | 31 ....  0 |
>     values:   |  reserved  | vcpu_index |

Using the .addr field for something that is clearly not an address is
rather odd. Is there any prior usage of that field for something that
is not an address?

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
