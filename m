From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Fri, 15 Dec 2017 12:15:32 +0100
Message-ID: <20171215111532.GA910@cbox>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
 <20171213091803.GQ910@cbox>
 <dc95b58c-ee6c-e5c7-1f37-8f69c789a1fc@gmail.com>
 <20171214130954.GV910@cbox>
 <5615f3e1-756e-0537-f0b6-20ae8626ac87@gmail.com>
 <20171214154518.GX910@cbox>
 <e5ccbf1c-6078-4c43-8aa3-fc226ed358f7@gmail.com>
 <519f0e33-4419-68be-32b4-11bb5e19cf17@arm.com>
 <20171215101053.GZ910@cbox>
 <83d52c86-0c09-0a18-34e3-55eb213f8083@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B1D640795
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 06:12:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xP59vD4mQSbi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 06:12:05 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B89549D78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 06:12:05 -0500 (EST)
Received: by mail-wm0-f49.google.com with SMTP id t8so16725702wmc.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 03:15:42 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <83d52c86-0c09-0a18-34e3-55eb213f8083@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Jia He <jia.he@hxt-semitech.com>, Jia He <hejianet@gmail.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 15, 2017 at 10:33:48AM +0000, Marc Zyngier wrote:
> On 15/12/17 10:10, Christoffer Dall wrote:
> > On Fri, Dec 15, 2017 at 09:09:05AM +0000, Marc Zyngier wrote:
> >> On 15/12/17 02:27, Jia He wrote:
> >>>
> >>>
> >>
> >> [...]
> >>
> >>>> @@ -367,6 +368,7 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
> >>>>   
> >>>>   	/* Disable the virtual timer */
> >>>>   	write_sysreg_el0(0, cntv_ctl);
> >>>> +	isb();
> >>> My only concern is whether this isb() is required here?
> >>> Sorryif this is a stupid question.I understand little about arm arch 
> >>> memory barrier. But seems isb will flush all the instruction prefetch.Do 
> >>> you think if an timer interrupt irq arrives, arm will use the previous 
> >>> instruction prefetch?
> >>
> >>
> >> This barrier has little to do with prefetch. It just guarantees that the
> >> code after the isb() is now running with a disabled virtual timer.
> >> Otherwise, a CPU can freely reorder the write_sysreg() until the next
> >> context synchronization event.
> >>
> >> An interrupt coming between the write and the barrier will also act as a
> >> context synchronization event. For more details, see the ARMv8 ARM (the
> >> glossary has a section on the concept).
> >>
> > 
> > So since an ISB doesn't guarantee that the timer will actually be
> > disabled, is it a waste of energy to have it, or should we keep it as a
> > best effort kind of thing?
> 
> nit: the ISB does offer that guarantee. It is just that the guarantee
> doesn't extend to an interrupt that has already been signalled.

right, I should have said that it doesn't guarantee that an already
signalled interrupt will have been retired prior to enabling interrupts
on the CPU again.

> 
> The main issue I have with not having an ISB is that it makes it harder
> to think of when the disabling actually happens. The disabling could be
> delayed for a very long time, and would make things harder to debug if
> they were going wrong.
> 

Yes, it definitely indicates the intention of the code and the flow, and
the fact that we have to work around delayed signals in the ISR is then
something we can describe with a comment there.

I'll add an ISB in the other version of the patch I sent before.

Thanks,
-Christoffer
