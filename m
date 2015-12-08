From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: BUG FIX: Correctly handle zero
 register transfers
Date: Tue, 8 Dec 2015 08:48:31 -0600
Message-ID: <20151208144831.GD4453@hawk.localdomain>
References: <cover.1449230499.git.p.fedin@samsung.com>
 <20151205003334.GB3117@hawk.localdomain>
 <011601d130ca$64cc9070$2e65b150$@samsung.com>
 <20151207223631.GJ4402@hawk.localdomain>
 <20151207234555.GA2980@hawk.localdomain>
 <009501d13185$b02d1150$108733f0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <009501d13185$b02d1150$108733f0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 08, 2015 at 09:57:21AM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > I messed up the "load into xzr" test royally in the last attached patch.
> > It was quite wrong.
> 
>  Yes, because "mov %0, xzr" is not trapped.
> 
> > I have now tested
> > 
> >  asm volatile(
> >      "str %3, [%1]\n\t"
> >      "ldr wzr, [%1]\n\t"
> >      "str wzr, [%2]\n\t"
> >      "ldr %0, [%2]\n\t"
> >      :"=r"(val):"r"(addr), "r"(addr2), "r"(0x55555555):"memory");
> > report("mmio: 'ldr wzr' check: read 0x%08lx", val != 0x55555555, val);
> > 
> > which passes
> 
>  I guess i forgot to mention that both addr and addr2 have to be MMIO registers. If they are plain memory, then of course everything
> will work because they are not trapped.

Yes, my round two (which still didn't fail) used mmio for both addr and
addr2.

> 
> > Anyway, I
> > probably won't clean this test up and post it. I don't think we really
> > need to add it as a regression test, unless others disagree and would
> > like to see it added.
> 
>  Considering how difficult it was to find this problem, and how tricky and unobvious it is, i would ask to add this test. Especially
> considering you've already written it. At least it will serve as a reminder about the problem.

OK. I need to wrap up some other work right now, but then I'll clean
this patch up and send it properly.

Thanks,
drew

> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
