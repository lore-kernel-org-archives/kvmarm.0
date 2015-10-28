From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC] vfio/type1: handle case where IOMMU does not support
 PAGE_SIZE size
Date: Wed, 28 Oct 2015 17:55:34 +0000
Message-ID: <20151028175533.GM18966@arm.com>
References: <1446037965-2341-1-git-send-email-eric.auger@linaro.org>
 <1446049648.8018.397.camel@redhat.com>
 <563101A0.7020404@linaro.org>
 <1446053858.8018.406.camel@redhat.com>
 <56310A79.4020309@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56310A79.4020309@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, suravee.suthikulpanit@amd.com, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 28, 2015 at 06:48:41PM +0100, Eric Auger wrote:
> On 10/28/2015 06:37 PM, Alex Williamson wrote:
> > Ok, so with hopefully correcting my understand of what this does, isn't
> > this effectively the same:
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 57d8c37..7db4f5a 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -403,13 +403,19 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, stru
> >  static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> >  {
> >         struct vfio_domain *domain;
> > -       unsigned long bitmap = PAGE_MASK;
> > +       unsigned long bitmap = ULONG_MAX;
> >  
> >         mutex_lock(&iommu->lock);
> >         list_for_each_entry(domain, &iommu->domain_list, next)
> >                 bitmap &= domain->domain->ops->pgsize_bitmap;
> >         mutex_unlock(&iommu->lock);
> >  
> > +       /* Some comment about how the IOMMU API splits requests */
> > +       if (bitmap & ~PAGE_MASK) {
> > +               bitmap &= PAGE_MASK;
> > +               bitmap |= PAGE_SIZE;
> > +       }
> > +
> >         return bitmap;
> >  }
> Yes, to me it is indeed the same
> >  
> > This would also expose to the user that we're accepting PAGE_SIZE, which
> > we weren't before, so it was not quite right to just let them do it
> > anyway.  I don't think we even need to get rid of the WARN_ONs, do we?
> > Thanks,
> 
> The end-user might be afraid of those latter. Personally I would get rid
> of them but that's definitively up to you.

I think Alex's point is that the WARN_ON's won't trigger with this patch,
because he clears those lower bits in the bitmap.

Will
