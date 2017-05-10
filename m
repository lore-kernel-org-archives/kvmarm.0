From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 05/10] KVM: arm/arm64: don't clear exit request from
 caller
Date: Wed, 10 May 2017 12:07:31 +0200
Message-ID: <20170510100731.fag26qu3i3vgtg2c@kamzik.brq.redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-6-drjones@redhat.com>
 <20170506181256.GB5923@cbox>
 <20170509171706.huhsia6lasf46bo6@kamzik.brq.redhat.com>
 <20170510095511.GB28721@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170510095511.GB28721@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 10, 2017 at 11:55:11AM +0200, Christoffer Dall wrote:
> On Tue, May 09, 2017 at 07:17:06PM +0200, Andrew Jones wrote:
> > On Sat, May 06, 2017 at 08:12:56PM +0200, Christoffer Dall wrote:
> > > On Wed, May 03, 2017 at 06:06:30PM +0200, Andrew Jones wrote:
> > > > VCPU requests that the receiver should handle should only be cleared
> > > > by the receiver. 
> > > 
> > > I cannot parse this sentence.
> > 
> > I'll try again:
> > 
> > VCPU requests should only be cleared by the receiving VCPUs.  The only
> > exception is when a request is set as a side-effect.  In these cases
> > the "requester" threads may clear the requests when it is sure the
> > receiving VCPUs do not need to see them.
> > 
> 
> I can parse this, and I mostly understand this, except for the part
> about side-effects.

E.g. kvm_vcpu_block(). This case isn't perfect, because the requester is
also the receiver, but the protocol applies to self-requests too, so it
still counts. Here KVM_REQ_UNHALT may be set as a side-effect of the call,
but on exit from the call, the caller may be sure that the receiver
(itself) doesn't care about the request, and thus can just clear it.

Thanks,
drew

> 
> > > 
> > > > Not only does this properly implement the protocol,
> > > > but also avoids bugs where one VCPU clears another VCPU's request,
> > > > before the receiving VCPU has had a chance to see it.
> > > 
> > > Is this an actual race we have currently or just something thay may
> > > happen later.  Im' not sure.
> > 
> > Since ARM is just learning to handle VCPU requests, then it's not a bug
> > now.  Actually, I think I should state this protocol (what I wrote above)
> > in the document, and then I can just reference that here in this commit
> > message as the justification for change.
> 
> That might solve the missing piece for me above, yes.
> 
> > > 
> > > > ARM VCPUs
> > > > currently only handle one request, EXIT, and handling it is achieved
> > > > by checking pause to see if the VCPU should sleep.
> > > 
> > > This makes sense.  So forget my comment on the previous patch about
> > > getting rid of the pause flag.
> > 
> > Forgotten
> > 
> > > 
> > > > 
> > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > > ---
> > > >  arch/arm/kvm/arm.c | 10 ++++++++--
> > > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > > > index 9174ed13135a..7be0d9b0c63a 100644
> > > > --- a/arch/arm/kvm/arm.c
> > > > +++ b/arch/arm/kvm/arm.c
> > > > @@ -553,7 +553,6 @@ void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
> > > >  {
> > > >  	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
> > > >  
> > > > -	kvm_clear_request(KVM_REQ_VCPU_EXIT, vcpu);
> > > >  	vcpu->arch.pause = false;
> > > >  	swake_up(wq);
> > > >  }
> > > > @@ -625,7 +624,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > > >  
> > > >  		update_vttbr(vcpu->kvm);
> > > >  
> > > > -		if (vcpu->arch.power_off || vcpu->arch.pause)
> > > > +		if (kvm_request_pending(vcpu)) {
> > > > +			if (kvm_check_request(KVM_REQ_VCPU_EXIT, vcpu)) {
> > > > +				if (vcpu->arch.pause)
> > > > +					vcpu_sleep(vcpu);
> > > > +			}
> > > 
> > > Can we factor out this bit to a separate function,
> > > kvm_handle_vcpu_requests() or something like that?
> > 
> > Later patches make this look a bit better, but a function to bundle all
> > the request handling up sounds good too. Will do.
> > 
> 
> Thanks,
> -Christoffer
