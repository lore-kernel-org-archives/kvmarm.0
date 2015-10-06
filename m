From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 4/6] vfio: Add interface to iommu-map/unmap MSI pages
Date: Tue, 06 Oct 2015 09:12:53 -0600
Message-ID: <1444144373.4059.36.camel@redhat.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1443624989-24346-4-git-send-email-Bharat.Bhushan@freescale.com>
	 <1443825980.26107.189.camel@redhat.com>
	 <CY1PR0301MB12760850AC62467C68E2326390480@CY1PR0301MB1276.namprd03.prod.outlook.com>
	 <1444085111.26107.365.camel@redhat.com>
	 <CY1PR0301MB12763E41F28AFC5C844A1A2A90370@CY1PR0301MB1276.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CY1PR0301MB12763E41F28AFC5C844A1A2A90370@CY1PR0301MB1276.namprd03.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
To: Bhushan Bharat <Bharat.Bhushan@freescale.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "pranavkumar@linaro.org" <pranavkumar@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 2015-10-06 at 09:05 +0000, Bhushan Bharat wrote:
> 
> 
> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Tuesday, October 06, 2015 4:15 AM
> > To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
> > Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> > christoffer.dall@linaro.org; eric.auger@linaro.org; pranavkumar@linaro.org;
> > marc.zyngier@arm.com; will.deacon@arm.com
> > Subject: Re: [RFC PATCH 4/6] vfio: Add interface to iommu-map/unmap MSI
> > pages
> > 
> > On Mon, 2015-10-05 at 06:27 +0000, Bhushan Bharat wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > Sent: Saturday, October 03, 2015 4:16 AM
> > > > To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
> > > > Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> > > > christoffer.dall@linaro.org; eric.auger@linaro.org;
> > > > pranavkumar@linaro.org; marc.zyngier@arm.com; will.deacon@arm.com
> > > > Subject: Re: [RFC PATCH 4/6] vfio: Add interface to iommu-map/unmap
> > > > MSI pages
> > > >
> > > > On Wed, 2015-09-30 at 20:26 +0530, Bharat Bhushan wrote:
> > > > > For MSI interrupts to work for a pass-through devices we need to
> > > > > have mapping of msi-pages in iommu. Now on some platforms (like
> > > > > x86) does this msi-pages mapping happens magically and in these
> > > > > case they chooses an iova which they somehow know that it will
> > > > > never overlap with guest memory. But this magic iova selection may
> > > > > not be always true for all platform (like PowerPC and ARM64).
> > > > >
> > > > > Also on x86 platform, there is no problem as long as running a
> > > > > x86-guest on x86-host but there can be issues when running a
> > > > > non-x86 guest on
> > > > > x86 host or other userspace applications like (I think ODP/DPDK).
> > > > > As in these cases there can be chances that it overlaps with guest
> > > > > memory mapping.
> > > >
> > > > Wow, it's amazing anything works... smoke and mirrors.
> > > >
> > > > > This patch add interface to iommu-map and iommu-unmap msi-pages
> > at
> > > > > reserved iova chosen by userspace.
> > > > >
> > > > > Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
> > > > > ---
> > > > >  drivers/vfio/vfio.c             |  52 +++++++++++++++++++
> > > > >  drivers/vfio/vfio_iommu_type1.c | 111
> > > > ++++++++++++++++++++++++++++++++++++++++
> > > > >  include/linux/vfio.h            |   9 +++-
> > > > >  3 files changed, 171 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c index
> > > > > 2fb29df..a817d2d 100644
> > > > > --- a/drivers/vfio/vfio.c
> > > > > +++ b/drivers/vfio/vfio.c
> > > > > @@ -605,6 +605,58 @@ static int vfio_iommu_group_notifier(struct
> > > > notifier_block *nb,
> > > > >  	return NOTIFY_OK;
> > > > >  }
> > > > >
> > > > > +int vfio_device_map_msi(struct vfio_device *device, uint64_t
> > msi_addr,
> > > > > +			uint32_t size, uint64_t *msi_iova) {
> > > > > +	struct vfio_container *container = device->group->container;
> > > > > +	struct vfio_iommu_driver *driver;
> > > > > +	int ret;
> > > > > +
> > > > > +	/* Validate address and size */
> > > > > +	if (!msi_addr || !size || !msi_iova)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	down_read(&container->group_lock);
> > > > > +
> > > > > +	driver = container->iommu_driver;
> > > > > +	if (!driver || !driver->ops || !driver->ops->msi_map) {
> > > > > +		up_read(&container->group_lock);
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > > +	ret = driver->ops->msi_map(container->iommu_data,
> > > > > +				   msi_addr, size, msi_iova);
> > > > > +
> > > > > +	up_read(&container->group_lock);
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > > +int vfio_device_unmap_msi(struct vfio_device *device, uint64_t
> > > > msi_iova,
> > > > > +			  uint64_t size)
> > > > > +{
> > > > > +	struct vfio_container *container = device->group->container;
> > > > > +	struct vfio_iommu_driver *driver;
> > > > > +	int ret;
> > > > > +
> > > > > +	/* Validate address and size */
> > > > > +	if (!msi_iova || !size)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	down_read(&container->group_lock);
> > > > > +
> > > > > +	driver = container->iommu_driver;
> > > > > +	if (!driver || !driver->ops || !driver->ops->msi_unmap) {
> > > > > +		up_read(&container->group_lock);
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > > +	ret = driver->ops->msi_unmap(container->iommu_data,
> > > > > +				     msi_iova, size);
> > > > > +
> > > > > +	up_read(&container->group_lock);
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > >  /**
> > > > >   * VFIO driver API
> > > > >   */
> > > > > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > > > > b/drivers/vfio/vfio_iommu_type1.c index 3315fb6..ab376c2 100644
> > > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > > @@ -1003,12 +1003,34 @@ out_free:
> > > > >  	return ret;
> > > > >  }
> > > > >
> > > > > +static void vfio_iommu_unmap_all_reserved_regions(struct
> > > > > +vfio_iommu
> > > > > +*iommu) {
> > > > > +	struct vfio_resvd_region *region;
> > > > > +	struct vfio_domain *d;
> > > > > +
> > > > > +	list_for_each_entry(region, &iommu->reserved_iova_list, next) {
> > > > > +		list_for_each_entry(d, &iommu->domain_list, next) {
> > > > > +			if (!region->map_paddr)
> > > > > +				continue;
> > > > > +
> > > > > +			if (!iommu_iova_to_phys(d->domain, region->iova))
> > > > > +				continue;
> > > > > +
> > > > > +			iommu_unmap(d->domain, region->iova,
> > > > PAGE_SIZE);
> > > >
> > > > PAGE_SIZE?  Why not region->size?
> > >
> > > Yes, this should be region->size.
> > >
> > > >
> > > > > +			region->map_paddr = 0;
> > > > > +			cond_resched();
> > > > > +		}
> > > > > +	}
> > > > > +}
> > > > > +
> > > > >  static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
> > {
> > > > >  	struct rb_node *node;
> > > > >
> > > > >  	while ((node = rb_first(&iommu->dma_list)))
> > > > >  		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma,
> > > > node));
> > > > > +
> > > > > +	vfio_iommu_unmap_all_reserved_regions(iommu);
> > > > >  }
> > > > >
> > > > >  static void vfio_iommu_type1_detach_group(void *iommu_data, @@
> > > > > -1048,6 +1070,93 @@ done:
> > > > >  	mutex_unlock(&iommu->lock);
> > > > >  }
> > > > >
> > > > > +static int vfio_iommu_type1_msi_map(void *iommu_data, uint64_t
> > > > msi_addr,
> > > > > +				    uint64_t size, uint64_t *msi_iova) {
> > > > > +	struct vfio_iommu *iommu = iommu_data;
> > > > > +	struct vfio_resvd_region *region;
> > > > > +	int ret;
> > > > > +
> > > > > +	mutex_lock(&iommu->lock);
> > > > > +
> > > > > +	/* Do not try ceate iommu-mapping if msi reconfig not allowed */
> > > > > +	if (!iommu->allow_msi_reconfig) {
> > > > > +		mutex_unlock(&iommu->lock);
> > > > > +		return 0;
> > > > > +	}
> > > > > +
> > > > > +	/* Check if there is already region mapping the msi page */
> > > > > +	list_for_each_entry(region, &iommu->reserved_iova_list, next) {
> > > > > +		if (region->map_paddr == msi_addr) {
> > > > > +			*msi_iova = region->iova;
> > > > > +			region->refcount++;
> > > > > +			mutex_unlock(&iommu->lock);
> > > > > +			return 0;
> > > > > +		}
> > > > > +	}
> > > > > +
> > > > > +	/* Get a unmapped reserved region */
> > > > > +	list_for_each_entry(region, &iommu->reserved_iova_list, next) {
> > > > > +		if (!region->map_paddr)
> > > > > +			break;
> > > > > +	}
> > > > > +
> > > > > +	if (region == NULL) {
> > > > > +		mutex_unlock(&iommu->lock);
> > > > > +		return -ENODEV;
> > > > > +	}
> > > > > +
> > > > > +	ret = vfio_iommu_map(iommu, region->iova, msi_addr >>
> > > > PAGE_SHIFT,
> > > > > +			     size >> PAGE_SHIFT, region->prot);
> > > >
> > > > So the reserved region has a size and the msi mapping has a size and
> > > > we arbitrarily decide to use the msi mapping size here?
> > >
> > > Reserved region interface is generic and user can set reserved region of
> > any size (multiple of page-size). But we do not want to create MSI address
> > mapping beyond the MSI-page otherwise this can be security issue. But I
> > think I am not tracking how much reserved iova region is mapped, so unmap
> > is called for same size.
> > >
> > >
> > > >  The overlap checks we've done for the reserved region are
> > > > meaningless then.  No wonder you're unmapping with PAGE_SIZE, we
> > have no idea.
> > >
> > > Do you think we should divide the reserved region in pages and track
> > map/unmap per page?
> > 
> > I'd certainly expect as a user to do one large reserved region mapping and be
> > done rather than a large number of smaller mappings.  I don't really
> > understand how we're providing isolation with this interface though, we're
> > setting up the IOMMU so the guest has a mapping to the MSI, but our
> > IOMMU granularity is page size.  Aren't we giving the guest access to
> > everything else that might be mapped into that page?  Don't we need to
> > push an reservation down to the MSI allocation in order to have isolation?  If
> > we did that, couldn't we pretty much guarantee that all MSI vectors would fit
> > into a page or two?
> 
> Normally we will reserve one MSI-page for a vfio-group and all devices will use same on PowerPC. I think same applies to SMMU as well. Now for X86 I do not know how many pages we needed for a vfio-group? If we needed one/two (small numbers) msi-page then I think for msi purpose one/two reserved-iova region of PAGE_SIZE is sufficient.

x86 will not be reserving pages, x86 needs a mechanism to report the
range reserved by the platform, which needs to be addressed yet.


