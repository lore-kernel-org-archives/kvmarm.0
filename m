From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 09/12] KVM: arm/arm64: Check all vcpu redistributors
 are set on map_resources
Date: Thu, 26 Apr 2018 12:16:59 +0200
Message-ID: <20180426101659.GD19872@C02W217FHV2R.local>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-10-git-send-email-eric.auger@redhat.com>
 <20180424210809.GJ4533@C02W217FHV2R.local>
 <cd56c99f-a266-dc04-41d7-62f35165a39b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cd56c99f-a266-dc04-41d7-62f35165a39b@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 26, 2018 at 11:56:10AM +0200, Auger Eric wrote:
> 
> 
> On 04/24/2018 11:08 PM, Christoffer Dall wrote:
> > On Fri, Apr 13, 2018 at 10:20:55AM +0200, Eric Auger wrote:
> >> On vcpu first run, we eventually know the actual number of vcpus.
> >> This is a synchronization point to check all redistributors regions
> >> were assigned.
> > 
> > Isn't it the other way around?  We want to check that all redistributors
> > (one for every VCPU) has its base address set?  (I don't suppose we care
> > about unused redistributor regions).
> Yes I meant "to check all redistributors were assigned"
> > 
> >> On kvm_vgic_map_resources() we check both dist and
> >> redist were set, eventually check potential base address inconsistencies.
> > 
> > Do we need to check that again?  Didn't we check that at
> > creation/register time?
> Yes we need to, to handle the case where the userspace does not provide
> sufficient rdist region space
> 
> create 8 vcpus (no iodev registered)
> define a redist region for 4 (4 iodevs registered)
> start the vcpus
> > 
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> ---
> >>  virt/kvm/arm/vgic/vgic-v3.c | 19 ++++++++++++++-----
> >>  1 file changed, 14 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> >> index b80f650..feabc24 100644
> >> --- a/virt/kvm/arm/vgic/vgic-v3.c
> >> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> >> @@ -484,16 +484,25 @@ struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
> >>  
> >>  int vgic_v3_map_resources(struct kvm *kvm)
> >>  {
> >> -	int ret = 0;
> >>  	struct vgic_dist *dist = &kvm->arch.vgic;
> >> -	struct vgic_redist_region *rdreg =
> >> -		list_first_entry(&dist->rd_regions,
> >> -				 struct vgic_redist_region, list);
> >> +	struct kvm_vcpu *vcpu;
> >> +	int ret = 0;
> >> +	int c;
> >>  
> >>  	if (vgic_ready(kvm))
> >>  		goto out;
> >>  
> >> -	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) || !rdreg) {
> >> +	kvm_for_each_vcpu(c, vcpu, kvm) {
> >> +		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >> +
> >> +		if (IS_VGIC_ADDR_UNDEF(vgic_cpu->rd_iodev.base_addr)) {
> >> +			kvm_err("vcpu %d redistributor base not set\n", c);
> > 
> > Shouldn't this be a kvm_debug instead?  I think the user can just
> > provoke this by failing to register enough redistributor regions.
> yes indeed.
> > 
> > I'm also wondering if we could check this on vgic_init time for gicv3,
> > which should have a defined vgic init ordering requirement.  That would
> > make debugging it slightly easier to debug than "my machine isn't
> > starting, and I get -ENXIO, and it can mean anything".
> 
> Well at vgic_init time, vcpus are frozen but dist and redist regions are
> not forced to be set, hence the late check we do in map_resources, on
> 1st VCPU run. Not sure I get this one?
> 

I thought we required userspace to register the redist regions before
initializing the vgic, but if there is no defined order there, then
fine.

(Although I'm getting the feeling we should have been more strict on our
ordering requirement, and that the whole "you can create anything you
want in any order you want" makes the kernel implementation really
complex.  I may be reversing my own oppinion on this matter here.)

Thanks,
-Christoffer
