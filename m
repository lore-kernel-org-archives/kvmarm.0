From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC PATCH 6/7] arm64: KVM: Handle trappable TLB instructions
Date: Thu, 1 Sep 2016 15:55:25 +0100
Message-ID: <20160901145525.GM6721@arm.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
 <1471344312-26685-7-git-send-email-punit.agrawal@arm.com>
 <20160819151846.GE9893@arm.com>
 <87a8g2sb4o.fsf@e105922-lin.cambridge.arm.com>
 <87h9a7rhvf.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87h9a7rhvf.fsf@e105922-lin.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 26, 2016 at 10:37:08AM +0100, Punit Agrawal wrote:
> > Will Deacon <will.deacon@arm.com> writes:
> >> The easiest thing to do is just TLBI VMALLE1IS for all trapped operations,
> >> but you might want to see how that performs.
> >
> > That sounds reasonable for correctness. But I suspect we'll have to do
> > more to claw back some performance. Let me run a few tests and come back
> > on this.
> 
> Assuming I've correctly switched in TCR and replacing the various TLB
> operations in this patch with TLBI VMALLE1IS, there is a drop in kernel
> build times of ~5% (384s vs 363s).

What do you mean by "switched in TCR"? Why is that necessary if you just
nuke the whole thing? Is the ~5% relative to no trapping at all, or
trapping, but being selective about the operation?

Will
