From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC] Handling CP15 timer without in-kernel irqchip
Date: Fri, 2 Oct 2015 22:26:56 +0200
Message-ID: <20151002202656.GC32011@cbox>
References: <00a001d0fce3$f76e2170$e64a6450$@samsung.com>
 <20151002112224.73e46be1@arm.com>
 <012601d0fd22$4c7425a0$e55c70e0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <012601d0fd22$4c7425a0$e55c70e0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 02, 2015 at 05:54:53PM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > So let me put it another way. The only way I look into this is when we
> > have this particular platform fully supported in mainline.
> 
>  I am sorry for possible misunderstanding. Please give me one more minute to defend myself...
>  So far, we are not putting back timer disable hack. So, i'd like to clarify some things about
> variant 2. From kernel's point of view, this is not a hack, but pure feature enhancement. The idea
> is to add KVM API which would allow to emulate system registers, unhandled by KVM, in userspace.
> Currently KVM just prints error message about unhandled system register access and feeds guest with
> "illegal instruction" exception. What i actually propose is to add an API which would allow to
> handle these things in userspace. This will even be architecture-agnostic, and it can be useful for
> emulating absolutely any future peripherials which could use system register (or coprocessor, on
> ARM32) interface.
>  The rest of timer-related stuff would be needed to be implemented in userspace, and this would have
> absolutely nothing to do with kernel.

Except that we now have an ABI that we need to maintain, userspace
functionality we need to maintain, we need to ensure that people running
VMs don't accidentally use userspace timers with poor performance
without noticigin, and there's a high chance that this whole thing will
bit-rot; we've seen it happen before.

I appreciate your enthusiasm on this topic, but we are already swamped
with a lot of other important things to do, and this is just not very
high on the radar at the moment.

> By the way, this would also allow to run under KVM legitimate
> guests which for some reason expect both timers (are there any? RTOS?)
>  So, what is your final word? Would you consider this improvement?
> 
I don't want to deny it flat out, and it's hard to say not having seen
the code, the ABI definition, and hear what the userspace maintainers
think about this.

-Christoffer
