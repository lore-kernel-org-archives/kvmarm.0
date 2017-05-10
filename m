From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 05/10] KVM: arm/arm64: don't clear exit request from
 caller
Date: Wed, 10 May 2017 14:19:12 +0200
Message-ID: <20170510121912.GD28721@cbox>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-6-drjones@redhat.com>
 <20170506181256.GB5923@cbox>
 <20170509171706.huhsia6lasf46bo6@kamzik.brq.redhat.com>
 <20170510095511.GB28721@cbox>
 <20170510100731.fag26qu3i3vgtg2c@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170510100731.fag26qu3i3vgtg2c@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 10, 2017 at 12:07:31PM +0200, Andrew Jones wrote:
> On Wed, May 10, 2017 at 11:55:11AM +0200, Christoffer Dall wrote:
> > On Tue, May 09, 2017 at 07:17:06PM +0200, Andrew Jones wrote:
> > > On Sat, May 06, 2017 at 08:12:56PM +0200, Christoffer Dall wrote:
> > > > On Wed, May 03, 2017 at 06:06:30PM +0200, Andrew Jones wrote:
> > > > > VCPU requests that the receiver should handle should only be cleared
> > > > > by the receiver. 
> > > > 
> > > > I cannot parse this sentence.
> > > 
> > > I'll try again:
> > > 
> > > VCPU requests should only be cleared by the receiving VCPUs.  The only
> > > exception is when a request is set as a side-effect.  In these cases
> > > the "requester" threads may clear the requests when it is sure the
> > > receiving VCPUs do not need to see them.
> > > 
> > 
> > I can parse this, and I mostly understand this, except for the part
> > about side-effects.
> 
> E.g. kvm_vcpu_block(). This case isn't perfect, because the requester is
> also the receiver, but the protocol applies to self-requests too, so it
> still counts. Here KVM_REQ_UNHALT may be set as a side-effect of the call,
> but on exit from the call, the caller may be sure that the receiver
> (itself) doesn't care about the request, and thus can just clear it.
> 

I see.  You could mention this as an example if you like.

Thanks,
-Christoffer
