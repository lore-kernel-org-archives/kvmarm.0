From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 4/8] KVM: arm/arm64: Make vgic_v3_check_base more broadly
 usable
Date: Mon, 8 May 2017 21:10:29 +0200
Message-ID: <20170508191029.GL28342@cbox>
References: <20170508115454.5075-1-cdall@linaro.org>
 <20170508115454.5075-5-cdall@linaro.org>
 <6c92055f-a5b1-c3a8-2343-61205324880c@redhat.com>
 <20170508171849.GI28342@cbox>
 <7e67fe6c-0956-ec03-d18c-d6e3c59b334a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7e67fe6c-0956-ec03-d18c-d6e3c59b334a@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 08, 2017 at 07:39:24PM +0200, Auger Eric wrote:
> Hi,
> 
> On 08/05/2017 19:18, Christoffer Dall wrote:
> > On Mon, May 08, 2017 at 06:13:01PM +0200, Auger Eric wrote:
> >> Hi Christoffer,
> >>
> >> On 08/05/2017 13:54, Christoffer Dall wrote:
> >>> As we are about to fiddle with the io device registration mechanism
> >>> let's be a little more careful in verifying the addresses we can ealier
> >>> on to provide error messages to the user at time related to him/her
> >>> setting overlapping addresses. 
> >> Above sentence would need some rewording.
> >>  We still want to check a consistent
> > 
> > indeed :)
> > 
> >>> system before actually running the VM for the first time, so we make
> >>> vgic_v3_check_base available in the core vgic-v3 code as well as in the
> >>> other parts of the GICv3 code, namely the MMIO config code.
> >>>
> >>> We also return true for undefined base addresses so that the function
> >>> can be used before all base addresses are set; all callers already check
> >>> for uninitialized addresses before calling this function.
> >>>
> >>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> >>> ---
> >>>  virt/kvm/arm/vgic/vgic-v3.c | 18 ++++++++++++++----
> >>>  virt/kvm/arm/vgic/vgic.h    |  1 +
> >>>  2 files changed, 15 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> >>> index 12e52a0..b934e78 100644
> >>> --- a/virt/kvm/arm/vgic/vgic-v3.c
> >>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> >>> @@ -329,19 +329,29 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
> >>>  	return 0;
> >>>  }
> >>>  
> >>> -/* check for overlapping regions and for regions crossing the end of memory */
> >>> -static bool vgic_v3_check_base(struct kvm *kvm)
> >>> +/*
> >>> + * Check for overlapping regions and for regions crossing the end of memory
> >>> + * for base addresses which have already been set.
> >>> + */
> >>> +bool vgic_v3_check_base(struct kvm *kvm)
> >>>  {
> >>>  	struct vgic_dist *d = &kvm->arch.vgic;
> >>>  	gpa_t redist_size = KVM_VGIC_V3_REDIST_SIZE;
> >>>  
> >>>  	redist_size *= atomic_read(&kvm->online_vcpus);
> >>>  
> >>> -	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE < d->vgic_dist_base)
> >>> +	if (!IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) &&
> >>> +	    d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE < d->vgic_dist_base)
> >>>  		return false;
> >>> -	if (d->vgic_redist_base + redist_size < d->vgic_redist_base)
> >>> +
> >>> +	if (!IS_VGIC_ADDR_UNDEF(d->vgic_redist_base) &&
> >>> +	    d->vgic_redist_base + redist_size < d->vgic_redist_base)
> >>>  		return false;
> >>>  
> >>> +	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) &&
> >>> +	    IS_VGIC_ADDR_UNDEF(d->vgic_redist_base))
> >>> +		return true;
> >>> +
> >>>  	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= d->vgic_redist_base)
> >>>  		return true;
> >> It is unclear to me if the dunction can be called if either of the
> >> address is unset?
> > 
> > Yes, it can be called if both addreses are unset, in which case you'll
> > get a positive result.  If a single address is set, we cannot check
> > interaction between the two addresses, but we can check the requirements
> > for the single address, and the interaction must be checked later.
> Although unlikely can't you have the redist_base set at 0x0 and
> dist_base unset. Wouldn't this return false?

In the case od fist_base == VGIC_ADDR_UNDEF and rd_base == 0, we'll get:

Ah, duh, my && should be a ||.  I'll fix this.

Thanks,
-Christoffer
