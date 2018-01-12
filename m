From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: vgic-its: Fix vgicv4 init
Date: Fri, 12 Jan 2018 11:44:57 +0100
Message-ID: <20180112104457.GB21403@cbox>
References: <1515405174-21066-1-git-send-email-eric.auger@redhat.com>
 <20180111185538.GI15307@cbox>
 <5f4fbcc8-ad99-4d33-5a1a-9bac2fc40894@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5f4fbcc8-ad99-4d33-5a1a-9bac2fc40894@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 12, 2018 at 08:45:31AM +0100, Auger Eric wrote:
> Hi Christoffer
> 
> On 11/01/18 19:55, Christoffer Dall wrote:
> > On Mon, Jan 08, 2018 at 10:52:54AM +0100, Eric Auger wrote:
> >> Commit 3d1ad640f8c94 ("KVM: arm/arm64: Fix GICv4 ITS initialization
> >> issues") moved the vgic_supports_direct_msis() check in vgic_v4_init().
> >> However when vgic_v4_init is called from vgic_its_create(), the has_its
> >> field is not yet set. Hence vgic_supports_direct_msis returns false and
> >> vgic_v4_init does nothing.
> >>
> >> Let's move the check back to vgic_v4_init caller.
> >>
> >> Fixes: 3d1ad640f8c94 ("KVM: arm/arm64: Fix GICv4 ITS initialization issues")
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >>
> >> v1 -> v2:
> >> - move the check to the caller
> > 
> > Why this change, I slightly preferred the first version of this patch,
> > but I will admit that the "has_its = true; no_wait(); has_its = false;"
> > things is pretty ugly...
> 
> I didn't find the 1st solution elegant either and reverted to how the
> code looked like before your patch.
> > 
> >> - identify the right commit this patch fixes
> >> ---
> >>  virt/kvm/arm/vgic/vgic-init.c | 8 +++++---
> >>  virt/kvm/arm/vgic/vgic-its.c  | 2 +-
> >>  virt/kvm/arm/vgic/vgic-v4.c   | 3 ---
> >>  3 files changed, 6 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> >> index 6231012..40be908 100644
> >> --- a/virt/kvm/arm/vgic/vgic-init.c
> >> +++ b/virt/kvm/arm/vgic/vgic-init.c
> >> @@ -285,9 +285,11 @@ int vgic_init(struct kvm *kvm)
> >>  	if (ret)
> >>  		goto out;
> >>  
> >> -	ret = vgic_v4_init(kvm);
> >> -	if (ret)
> >> -		goto out;
> >> +	if (vgic_supports_direct_msis(kvm)) {
> >> +		ret = vgic_v4_init(kvm);
> >> +		if (ret)
> >> +			goto out;
> >> +	}
> >>  
> >>  	kvm_for_each_vcpu(i, vcpu, kvm)
> >>  		kvm_vgic_vcpu_enable(vcpu);
> >> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> >> index 8e633bd..aebc88d 100644
> >> --- a/virt/kvm/arm/vgic/vgic-its.c
> >> +++ b/virt/kvm/arm/vgic/vgic-its.c
> >> @@ -1687,7 +1687,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
> >>  	if (!its)
> >>  		return -ENOMEM;
> >>  
> >> -	if (vgic_initialized(dev->kvm)) {
> >> +	if (kvm_vgic_global_state.has_gicv4 && vgic_initialized(dev->kvm)) {
> > 
> > ... but now we're using vgic_supports_direct_msis() in one part of the
> > init path and a half-open coded version of that in another path, which
> > is not very pretty.
> > 
> > So I actually would suggest doing the init stuff more open-coded,
> > because init of the gic/its/gicv4 is a mess anyway.
> > 
> > Something like this:
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> > index 62310122ee78..743ca5cb05ef 100644
> > --- a/virt/kvm/arm/vgic/vgic-init.c
> > +++ b/virt/kvm/arm/vgic/vgic-init.c
> > @@ -285,9 +285,11 @@ int vgic_init(struct kvm *kvm)
> >  	if (ret)
> >  		goto out;
> >  
> > -	ret = vgic_v4_init(kvm);
> > -	if (ret)
> > -		goto out;
> > +	if (vgic_has_its(kvm)) {
> > +		ret = vgic_v4_init(kvm);
> > +		if (ret)
> > +			goto out;
> > +	}
> >  
> >  	kvm_for_each_vcpu(i, vcpu, kvm)
> >  		kvm_vgic_vcpu_enable(vcpu);
> > diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> > index 4a37292855bc..bc4265154bac 100644
> > --- a/virt/kvm/arm/vgic/vgic-v4.c
> > +++ b/virt/kvm/arm/vgic/vgic-v4.c
> > @@ -118,7 +118,7 @@ int vgic_v4_init(struct kvm *kvm)
> >  	struct kvm_vcpu *vcpu;
> >  	int i, nr_vcpus, ret;
> >  
> > -	if (!vgic_supports_direct_msis(kvm))
> > +	if (!kvm_vgic_global_state.has_gicv4)
> >  		return 0; /* Nothing to see here... move along. */
> >  
> >  	if (dist->its_vm.vpes)
> > 
> > Does that work?
> Looks OK to me. Unfortunately I don't have access to this specific
> machine anymore at the moment so I can't test it right now.
> 

ok, I've queued my version with your reported-by.

Thanks,
-Christoffer
