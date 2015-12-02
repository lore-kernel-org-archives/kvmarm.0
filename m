From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 18/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Wed, 2 Dec 2015 17:27:51 +0100
Message-ID: <20151202162751.GO18376@cbox>
References: <565DB021.3020901@huawei.com>
 <565DB3A5.3030701@arm.com>
 <565DB935.5040609@linaro.org>
 <565DBF8D.1070006@arm.com>
 <565DCA24.7000908@linaro.org>
 <565DD17A.50009@arm.com>
 <565E5A13.2080706@huawei.com>
 <565EAFC4.2040301@arm.com>
 <565EBEA3.8080500@huawei.com>
 <565EC64C.1090501@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <565EC64C.1090501@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shannon Zhao <zhaoshenglong@huawei.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 02, 2015 at 10:22:04AM +0000, Marc Zyngier wrote:
> On 02/12/15 09:49, Shannon Zhao wrote:
> > 
> > 
> > On 2015/12/2 16:45, Marc Zyngier wrote:
> >> On 02/12/15 02:40, Shannon Zhao wrote:
> >>>>
> >>>>
> >>>> On 2015/12/2 0:57, Marc Zyngier wrote:
> >>>>>> On 01/12/15 16:26, Shannon Zhao wrote:
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> On 2015/12/1 23:41, Marc Zyngier wrote:
> >>>>>>>>>>>> The reason is that when guest clear the overflow register, it will trap
> >>>>>>>>>>>>>> to kvm and call kvm_pmu_sync_hwstate() as you see above. At this moment,
> >>>>>>>>>>>>>> the overflow register is still overflowed(that is some bit is still 1).
> >>>>>>>>>>>>>> So We need to use some flag to mark we already inject this interrupt.
> >>>>>>>>>>>>>> And if during guest handling the overflow, there is a new overflow
> >>>>>>>>>>>>>> happening, the pmu->irq_pending will be set ture by
> >>>>>>>>>>>>>> kvm_pmu_perf_overflow(), then it needs to inject this new interrupt, right?
> >>>>>>>>>> I don't think so. This is a level interrupt, so the level should stay
> >>>>>>>>>> high as long as the guest hasn't cleared all possible sources for that
> >>>>>>>>>> interrupt.
> >>>>>>>>>>
> >>>>>>>>>> For your example, the guest writes to PMOVSCLR to clear the overflow
> >>>>>>>>>> caused by a given counter. If the status is now 0, the interrupt line
> >>>>>>>>>> drops. If the status is still non zero, the line stays high. And I
> >>>>>>>>>> believe that writing a 1 to PMOVSSET would actually trigger an
> >>>>>>>>>> interrupt, or keep it high if it has already high.
> >>>>>>>>>>
> >>>>>>>> Right, writing 1 to PMOVSSET will trigger an interrupt.
> >>>>>>>>
> >>>>>>>>>> In essence, do not try to maintain side state. I've been bitten.
> >>>>>>>>
> >>>>>>>> So on VM entry, it check if PMOVSSET is zero. If not, call 
> >>>>>>>> kvm_vgic_inject_irq to set the level high. If so, set the level low.
> >>>>>>>> On VM exit, it seems there is nothing to do.
> >>>>>>
> >>>>>> It is even simpler than that:
> >>>>>>
> >>>>>> - When you get an overflow, you inject an interrupt with the level set to 1.
> >>>>>> - When the overflow register gets cleared, you inject the same interrupt
> >>>>>> with the level set to 0.
> >>>>>>
> >>>>>> I don't think you need to do anything else, and the world switch should
> >>>>>> be left untouched.
> >>>>>>
> >>>>
> >>>> On 2015/7/17 23:28, Christoffer Dall wrote:>> > +		
> >>>> kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> >>>>>>>>>> +					    pmu->irq_num, 1);
> >>>>>> what context is this overflow handler function?  kvm_vgic_inject_irq
> >>>>>> grabs a mutex, so it can sleep...
> >>>>>>
> >>>>>> from a quick glance at the perf core code, it looks like this is in
> >>>>>> interrupt context, so that call to kvm_vgic_inject_irq looks bad.
> >>>>>>
> >>>>
> >>>> But as Christoffer said before, it's not good to call
> >>>> kvm_vgic_inject_irq directly in interrupt context. So if we just kick
> >>>> the vcpu here and call kvm_vgic_inject_irq on VM entry, is this fine?
> >> Possibly. I'm slightly worried that inject_irq itself is going to kick
> >> the vcpu again for no good reason. 
> > Yes, this will introduce a extra kick. What's the impact of kicking a
> > kicked vcpu?
> 
> As long as you only kick yourself, it shouldn't be much (trying to
> decipher vcpu_kick).
> 

The behavior of vcpu_kick really depends on a number of things:

 - If you're kicking yourself, nothing happens.
 - If you're kicking a sleeping vcpu, wake it up
 - If you're kicking a running vcpu, send it a physical IPI
 - If the vcpu is not running, and not sleeping (so still runnable)
   don't do anything, just wait until it gets scheduled.

-Christoffer
