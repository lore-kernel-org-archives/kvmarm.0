From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Wed, 5 Apr 2017 09:09:59 +0200
Message-ID: <20170405070959.GA1526@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com>
 <20170404160417.GN11752@cbox>
 <20170404175718.su4tjx3psyez3qee@kamzik.brq.redhat.com>
 <20170404190438.GF31208@cbox>
 <63209d09-0c45-0bb2-322b-e422f1360df7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <63209d09-0c45-0bb2-322b-e422f1360df7@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 04, 2017 at 10:10:15PM +0200, Paolo Bonzini wrote:
> 
> 
> On 04/04/2017 21:04, Christoffer Dall wrote:
> >  - (On a related work, I suddenly felt it weird that
> >    kvm_make_all_cpus_request() doesn't wake up sleeping VCPUs, but only
> >    sends an IPI; does this mean that calling this function should be
> >    followed by a kick() for each VCPU?  Maybe Radim was looking at this
> >    in his series already.)
> 
> Yes, kvm_make_all_cpus_request in x86 is only used for "non urgent"
> requests, i.e. things to do before the next guest entry.
> 

Ah, another good thing to document somewhere.

> >  - In the explanation you wrote, you use the term 'we' a lot, but when
> >    talking about SMP barriers, I think it only makes sense to talk about
> >    actions and observations between multiple CPUs and we have to be
> >    specific about which CPU observes or does what with respect to the
> >    other.  Maybe I'm being a stickler here, but there something here
> >    which is making me uneasy.
> 
> The write1-mb-if(read2) / write2-mb-if(read1) pattern is pretty common,
> so I think it is justified to cut the ordering on the reasoning and just
> focus on what the two memory locations and conditions mean.

ok, but the pattern above was not common to me (and I'm pretty sure I'm
not the only fool in the bunch here), so if we can reference something
that explains that this is a known pattern which has been tried and
proven, that would be even better.

> But I'd
> wait for v3, since I'm sure that Drew also understands the
> synchronization better.
> 

Yes, I'm confident that v3 will be great ;)

> >  - Finally, it feels very hard to prove the correctness of this, and
> >    equally hard to test it (given how long we've been running with
> >    apparently racy code).  I would hope that we could abstract some of
> >    this into architecture generic things, that someone who eat memory
> >    barriers for breakfast could help us verify, but again, maybe this is
> >    Radim's series I'm asking for here.
> 
> What I can do here is to suggest copying the paradigms from x86, which
> is quite battle tested (Windows hammers it really hard).

That sounds reasonable, but I think part of the problem was that we
simply didn't understand what the paradigms were (see the
kvm_make_all_cpus_request above as an example), so Drew's action about
documenting what this all is and the constraints of using it is really
important for me to do that.

> 
> For QEMU I did use model checking in the past for some similarly hairy
> synchronization code, but that is really just "executable documentation"
> because the model is not written in C.
> 

I played with using blast on some of the KVM/ARM code a long time ago,
and while I was able to find a bug with it, it was sort of an obvious
bug, and the things I was able to do with it was pretty limited to the
problems I could imagine myself anyhow.  Perhaps this is what you mean
with executable documentation.  In any case, I feel it starts with
documentation.

Thanks,
-Christoffer
