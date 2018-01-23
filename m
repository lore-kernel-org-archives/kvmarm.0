From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 11/13] KVM: arm64: Handle RAS SErrors from EL1 on
 guest exit
Date: Tue, 23 Jan 2018 16:32:45 +0100
Message-ID: <20180123153245.GN21802@cbox>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-12-james.morse@arm.com>
 <20180119192055.GH21802@cbox> <5A662B0E.7060305@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 726B849DDC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jan 2018 10:27:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EkyOC07IJKYa for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jan 2018 10:27:29 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54FB849D40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jan 2018 10:27:29 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id i186so2618852wmi.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jan 2018 07:32:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <5A662B0E.7060305@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 22, 2018 at 06:18:54PM +0000, James Morse wrote:
> Hi Christoffer,
> 
> On 19/01/18 19:20, Christoffer Dall wrote:
> > On Mon, Jan 15, 2018 at 07:39:04PM +0000, James Morse wrote:
> >> We expect to have firmware-first handling of RAS SErrors, with errors
> >> notified via an APEI method. For systems without firmware-first, add
> >> some minimal handling to KVM.
> >>
> >> There are two ways KVM can take an SError due to a guest, either may be a
> >> RAS error: we exit the guest due to an SError routed to EL2 by HCR_EL2.AMO,
> >> or we take an SError from EL2 when we unmask PSTATE.A from __guest_exit.
> >>
> >> For SError that interrupt a guest and are routed to EL2 the existing
> >> behaviour is to inject an impdef SError into the guest.
> >>
> >> Add code to handle RAS SError based on the ESR. For uncontained and
> >> uncategorized errors arm64_is_fatal_ras_serror() will panic(), these
> >> errors compromise the host too. All other error types are contained:
> >> For the fatal errors the vCPU can't make progress, so we inject a virtual
> >> SError. We ignore contained errors where we can make progress as if
> >> we're lucky, we may not hit them again.
> >>
> >> If only some of the CPUs support RAS the guest will see the cpufeature
> >> sanitised version of the id registers, but we may still take RAS SError
> >> on this CPU. Move the SError handling out of handle_exit() into a new
> >> handler that runs before we can be preempted. This allows us to use
> >> this_cpu_has_cap(), via arm64_is_ras_serror().
> > 
> > Would it be possible to optimize this a bit later on by caching
> > this_cpu_has_cap() in vcpu_load() so that we can use a single
> > handle_exit function to process all exits?
> 
> If vcpu_load() prevents pre-emption between the guest-exit exception and the
> this_cpu_has_cap() test then we wouldn't need a separate handle_exit().

It doesn't, but you'd get another vcpu_put() / vcpu_load() if you get
preempted, and you could record anything you need to know about the CPU
that actually ran the guest in vcpu_put().

So it might be possible to call some "process pending serror" function
in vcpu_put().

> 
> But, if we support kernel-first RAS or firmware-first's NOTIFY_SEI we shouldn't
> unmask SError until we've fed the guest-exit:SError into the RAS code. This
> would also need the SError related handle_exit() calls to be separate/earlier.
> (there was some verbiage on this in the cover letter).

Yeah, I sort-of understood where this was going...

> 
> (I started down the 'make handle_exit() non-preemptible', but WF{E,I}'s
> kvm_vcpu_block()->schedule() and kvm_vcpu_on_spin()s use of kvm_vcpu_yield_to()
> put an end to that).

It's not clear to me exactly how that would work, as handle_exit() can
also block on stuff like allocating memory.  I suppose enabling
preemption could be per exit reason, but that might be hard to maintain.

> 
> 
> In terms of caching this_cpu_has_cap() value, is this due to a performance
> concern? It's all called behind 'exception_index == ARM_EXCEPTION_EL1_SERROR',
> so we've already taken an SError out of the guest. Once its all put together
> we're likely to have a pending signal for user-space.
> 'Corrected' (or at least ignorable) errors are going to be the odd one out, I
> don't think we should worry about these!

The performance concern is having to call another function to check the
return value again in the critical path.  On older implementations this
kind of thing is actually measureable, and there's a tendency to add a
call here and a call there for any new aspect of the architecture, and
it will eventually weigh things down, I believe.  On the other hand,
having a "process some things before we enable preemption" which is your
handle_exit_early() function (could this also have been called
handle_exit_nopreempt() ?) is a potentially generally useful thing to
have and a reasonable thing overall.

Anyway, I was just trying to spitball a bit on the topic, no immediate
change required.

Thanks,
-Christoffer
