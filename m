From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Thu, 6 Apr 2017 16:25:35 +0200
Message-ID: <20170406142535.GD27123@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-2-drjones@redhat.com>
 <20170404153014.GL11752@cbox>
 <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
 <20170405131049.GD6369@potion>
 <20170405173918.GA27123@cbox>
 <20170405202016.GG6369@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170405202016.GG6369@potion>
Sender: kvm-owner@vger.kernel.org
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 05, 2017 at 10:20:17PM +0200, Radim Krčmář wrote:
> 2017-04-05 19:39+0200, Christoffer Dall:
> > On Wed, Apr 05, 2017 at 03:10:50PM +0200, Radim Krčmář wrote:
> >> 2017-04-04 18:41+0200, Andrew Jones:
> >> > On Tue, Apr 04, 2017 at 05:30:14PM +0200, Christoffer Dall wrote:
> >> >> On Fri, Mar 31, 2017 at 06:06:50PM +0200, Andrew Jones wrote:
> >> >> > From: Radim Krčmář <rkrcmar@redhat.com>
> >> >> > 
> >> >> > A first step in vcpu->requests encapsulation.
> >> >> 
> >> >> Could we have a note here on why we need to access vcpu->requests using
> >> >> READ_ONCE now?
> >> > 
> >> > Sure, maybe we should put the note as a comment above the read in
> >> > kvm_request_pending().  Something like
> >> > 
> >> >  /*
> >> >   * vcpu->requests reads may appear in sequences that have strict
> >> >   * data or control dependencies.  Use READ_ONCE() to ensure the
> >> >   * compiler does not do anything that breaks the required ordering.
> >> >   */
> >> > 
> >> > Radim?
> >> 
> >> Uses of vcpu->requests should already have barriers that take care of
> >> the ordering.  I think the main reason for READ_ONCE() is to tell
> >> programmers that requests are special, but predictable.
> > 
> > I don't know what to do with "special, but predictable", unfortunately.
> > In fact, I don't even think I know what you mean.
> 
> With "special" to stand for the idea that vcpu->requests can change
> outside of the current execution thread.  Letting the programmer assume
> additional guarantees makes the generated code and resulting behavior
> more predictable.
> 
> >> READ_ONCE() is not necessary in any use I'm aware of, but there is no
> >> harm in telling the compiler that vcpu->requests are what we think they
> >> are ...
> > 
> > Hmmm, I'm equally lost.
> 
> vcpu->requests are volatile, so we need to assume that they can change
> at any moment when using them.
> 
> I would prefer if vcpu->requests were of an atomic type and READ_ONCE()
> is about as close we can get without a major overhaul.
> 

I finally see your point of conveying how things work using READ_ONCE().

If there's really no harm in letting the compiler read this as it wishes
(within the boundaries already placed by our use of compiler and memory
barriers), then I think we should just document that instead of relying
on how people would interpret READ_ONCE, but it's up to you - I think
I'm beginning to understand regardless.

> >> 
> >>  /*
> >>   * vcpu->requests are a lockless synchronization mechanism, where
> > 
> > is the requests a synchronization mechanism?  I think of it more as a
> > cross-thread communication protocol.
> 
> Partly, synchronization is too restrictive and communication seems too
> generic, but probably still better.  No idea how to shortly describe the
> part of vcpu->requests that prevents VM entry and that setting a request
> kicks VM out of guest mode.

heh, neither do I.

> 
> x86 uses KVM_REQ_MCLOCK_INPROGRESS for synchronization between cores and
> the use in this series looked very similar.
> 
> >>   * memory barriers are necessary for correct behavior, see
> >>   * Documentation/virtual/kvm/vcpu-requests.rst.
> >>   *
> >>   * READ_ONCE() is not necessary for correctness, but simplifies
> >>   * reasoning by constricting the generated code.
> >>   */
> >> 
> >> I considered READ_ONCE() to be self-documenting. :)
> > 
> > I realize that I'm probably unusually slow in this whole area, but using
> > READ_ONCE() where unnecessary doesn't help my reasoning, but makes me
> > wonder which part of this I didn't understand, so I don't seem to agree
> > with the statement that it simplifies reasoning.
> 
> No, I think it is a matter of approach.  When I see a READ_ONCE()
> without a comment, I think that the programmer was aware that this
> memory can change at any time and was defensive about it.

I think it means that you have to read it exactly once at the exact flow
in the code where it's placed.

> 
> I consider this use to simplify future development:
> We think now that READ_ONCE() is not needed, but vcpu->requests is still
> volatile and future changes in code might make READ_ONCE() necessary.
> Preemptively putting READ_ONCE() there saves us thinking or hard-to-find
> bugs.
> 

I'm always a bit sceptical about such reasoning as I think without a
complete understanding of what needs to change when doing changes, we're
likely to get it wrong anyway.

> > Really, if there is no reason to use it, I don't think we should use it.
> 
> I am leaning towards READ_ONCE() as the default for implicitly volatile
> memory, but commenting why we didn't have to use READ_ONCE() sounds good
> too.
> 

Sure, I can live with both solutions :)

> > To me, READ_ONCE() indicates that there's some flow in the code where
> > it's essential that the compiler doesn't generate multiple loads, but
> > that we only see a momentary single-read snapshot of the value, and this
> > doesn't seem to be the case.
> 
> The compiler can also squash multiple reads together, which is more
> dangerous in this case as we would not notice a new requests.  Avoiding
> READ_ONCE() requires a better knowledge of the compiler algorithms that
> prove which variable can be optimized.

Isn't that covered by the memory barriers that imply compiler barriers
that we (will) have between checking the mode and the requests variable?

> 
> The difference is really minor and I agree that the comment is bad.
> The only comment I'm happy with is nothing, though ... even "READ_ONCE()
> is not necessary" is wrong as that might change without us noticing.

"READ_ONCE() is not necessary" while actually using READ_ONCE() is a
terrible comment because it makes readers just doubt the correctness of
the code.

Regardless of whether or not we end up using READ_ONCE(), I think we
should document exactly what the requirements are for accessing this
variable at this time, i.e. any assumption about preceding barriers or
other flows of events that we rely on.

Thanks,
-Christoffer
