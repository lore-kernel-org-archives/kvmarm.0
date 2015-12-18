From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v7 19/19] KVM: ARM64: Add a new kvm ARM PMU device
Date: Fri, 18 Dec 2015 11:00:12 +0100
Message-ID: <20151218100012.GD32720@cbox>
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
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <567262CA.6050905@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 17, 2015 at 03:22:50PM +0800, Shannon Zhao wrote:
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
> 
> >>     The irq_num describes the PMU overflow interrupt number for the
> >> specified
> >>     vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one
> >> VM the
> >>     interrupt type must be same for each vcpu.
> > 
> > some formatting snafus that I expect come from pasting the text in an
> > e-mail client.
> > 
> >>
> >>   Errors:
> >>     -ENXIO: Getting or setting this attribute is not yet supported
> > 
> > 'not yet supported' as in something we'll implement later, or as in you
> > need to call this other function before you can access this state?
> > 
> Since only when the group is not KVM_DEV_ARM_PMU_GRP_IRQ, it will return
> -ENXIO. So what about this?
> 
> "-ENXIO: Unsupported attribute group"
> 
better,

-Christoffer
