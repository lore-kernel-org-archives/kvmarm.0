From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Sat, 8 Apr 2017 11:23:14 -0700
Message-ID: <20170408182314.GD29201@lvm>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-2-drjones@redhat.com>
 <20170404153014.GL11752@cbox>
 <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
 <20170405131049.GD6369@potion>
 <20170405173918.GA27123@cbox>
 <20170405202016.GG6369@potion>
 <20170406142535.GD27123@cbox>
 <20170407131537.GE23559@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170407131537.GE23559@potion>
Sender: kvm-owner@vger.kernel.org
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 07, 2017 at 03:15:37PM +0200, Radim Krčmář wrote:
> 2017-04-06 16:25+0200, Christoffer Dall:
> > On Wed, Apr 05, 2017 at 10:20:17PM +0200, Radim Krčmář wrote:
> >> 2017-04-05 19:39+0200, Christoffer Dall:
> >> > On Wed, Apr 05, 2017 at 03:10:50PM +0200, Radim Krčmář wrote:
> >> x86 uses KVM_REQ_MCLOCK_INPROGRESS for synchronization between cores and
> >> the use in this series looked very similar.
> >> 
> >> >>   * memory barriers are necessary for correct behavior, see
> >> >>   * Documentation/virtual/kvm/vcpu-requests.rst.
> >> >>   *
> >> >>   * READ_ONCE() is not necessary for correctness, but simplifies
> >> >>   * reasoning by constricting the generated code.
> >> >>   */
> >> >> 
> >> >> I considered READ_ONCE() to be self-documenting. :)
> >> > 
> >> > I realize that I'm probably unusually slow in this whole area, but using
> >> > READ_ONCE() where unnecessary doesn't help my reasoning, but makes me
> >> > wonder which part of this I didn't understand, so I don't seem to agree
> >> > with the statement that it simplifies reasoning.
> >> 
> >> No, I think it is a matter of approach.  When I see a READ_ONCE()
> >> without a comment, I think that the programmer was aware that this
> >> memory can change at any time and was defensive about it.
> > 
> > I think it means that you have to read it exactly once at the exact flow
> > in the code where it's placed.
> 
> The compiler can still reorder surrounding non-volatile code, but
> reading exactly once is the subset of meaning that READ_ONCE() should
> have.  Not assigning it any more meaning sounds good.
> 
> >> I consider this use to simplify future development:
> >> We think now that READ_ONCE() is not needed, but vcpu->requests is still
> >> volatile and future changes in code might make READ_ONCE() necessary.
> >> Preemptively putting READ_ONCE() there saves us thinking or hard-to-find
> >> bugs.
> >> 
> > 
> > I'm always a bit sceptical about such reasoning as I think without a
> > complete understanding of what needs to change when doing changes, we're
> > likely to get it wrong anyway.
> 
> I think we cannot achieve and maintain a complete understanding, so
> getting things wrong is just a matter of time.
> 
> It is almost impossible to break ordering of vcpu->requests, though.
> 
> >> > To me, READ_ONCE() indicates that there's some flow in the code where
> >> > it's essential that the compiler doesn't generate multiple loads, but
> >> > that we only see a momentary single-read snapshot of the value, and this
> >> > doesn't seem to be the case.
> >> 
> >> The compiler can also squash multiple reads together, which is more
> >> dangerous in this case as we would not notice a new requests.  Avoiding
> >> READ_ONCE() requires a better knowledge of the compiler algorithms that
> >> prove which variable can be optimized.
> > 
> > Isn't that covered by the memory barriers that imply compiler barriers
> > that we (will) have between checking the mode and the requests variable?
> 
> It is, asm volatile ("" ::: "memory") is enough.
> 
> The minimal conditions that would require explicit barrier:
>  1) not having vcpu->mode(), because it cannot work without memory
>     barriers
>  2) the instruction that disables interrupts doesn't have "memory"
>     constraint  (the smp_rmb in between is not necessary here)
> 
> And of course, there would have to be no functions that would contain a
> compiler barrier or their bodies remained unknown in between disabling
> interrupts and checking requests ...
> 
> >> The difference is really minor and I agree that the comment is bad.
> >> The only comment I'm happy with is nothing, though ... even "READ_ONCE()
> >> is not necessary" is wrong as that might change without us noticing.
> > 
> > "READ_ONCE() is not necessary" while actually using READ_ONCE() is a
> > terrible comment because it makes readers just doubt the correctness of
> > the code.
> > 
> > Regardless of whether or not we end up using READ_ONCE(), I think we
> > should document exactly what the requirements are for accessing this
> > variable at this time, i.e. any assumption about preceding barriers or
> > other flows of events that we rely on.
> 
> Makes sense.  My pitch at the documentation after dropping READ_ONCE():

I'm confused again, I thought you wanted to keep READ_ONCE().

> 
>   /*
>    *  The return value of kvm_request_pending() is implicitly volatile

why is that, actually?

>    *  and must be protected from reordering by the caller.
>    */

Can we be specific about what that means?  (e.g. must be preceded by a
full smp_mb() - or whatever the case is).

Perhaps we should just let Drew respin at this point, in case he's
confident about the right path, and then pick up from there?

Thanks,
-Christoffer
