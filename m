From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 1/6] vfio: Add interface for add/del reserved iova
 region
Date: Mon, 05 Oct 2015 16:45:19 -0600
Message-ID: <1444085119.26107.366.camel@redhat.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1443825938.26107.186.camel@redhat.com>
	 <CY1PR0301MB127662473625F595FB222C5C90480@CY1PR0301MB1276.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CY1PR0301MB127662473625F595FB222C5C90480@CY1PR0301MB1276.namprd03.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
To: Bhushan Bharat <Bharat.Bhushan@freescale.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "pranavkumar@linaro.org" <pranavkumar@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 2015-10-05 at 04:55 +0000, Bhushan Bharat wrote:
> Hi Alex,
> 
> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Saturday, October 03, 2015 4:16 AM
> > To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
> > Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> > christoffer.dall@linaro.org; eric.auger@linaro.org; pranavkumar@linaro.org;
> > marc.zyngier@arm.com; will.deacon@arm.com
> > Subject: Re: [RFC PATCH 1/6] vfio: Add interface for add/del reserved iova
> > region
> > 
> > On Wed, 2015-09-30 at 20:26 +0530, Bharat Bhushan wrote:
> > > This Patch adds the VFIO APIs to add and remove reserved iova regions.
> > > The reserved iova region can be used for mapping some specific
> > > physical address in iommu.
> > >
> > > Currently we are planning to use this interface for adding iova
> > > regions for creating iommu of msi-pages. But the API are designed for
> > > future extension where some other physical address can be mapped.
> > >
> > > Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
> > > ---
> > >  drivers/vfio/vfio_iommu_type1.c | 201
> > +++++++++++++++++++++++++++++++++++++++-
> > >  include/uapi/linux/vfio.h       |  43 +++++++++
> > >  2 files changed, 243 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > > b/drivers/vfio/vfio_iommu_type1.c index 57d8c37..fa5d3e4 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -59,6 +59,7 @@ struct vfio_iommu {
> > >  	struct rb_root		dma_list;
> > >  	bool			v2;
> > >  	bool			nesting;
> > > +	struct list_head	reserved_iova_list;
> > 
> > This alignment leads to poor packing in the structure, put it above the bools.
> 
> ok
> 
> > 
> > >  };
> > >
> > >  struct vfio_domain {
> > > @@ -77,6 +78,15 @@ struct vfio_dma {
> > >  	int			prot;		/* IOMMU_READ/WRITE */
> > >  };
> > >
> > > +struct vfio_resvd_region {
> > > +	dma_addr_t	iova;
> > > +	size_t		size;
> > > +	int		prot;			/* IOMMU_READ/WRITE */
> > > +	int		refcount;		/* ref count of mappings */
> > > +	uint64_t	map_paddr;		/* Mapped Physical Address
> > */
> > 
> > phys_addr_t
> 
> Ok,
> 
> > 
> > > +	struct list_head next;
> > > +};
> > > +
> > >  struct vfio_group {
> > >  	struct iommu_group	*iommu_group;
> > >  	struct list_head	next;
> > > @@ -106,6 +116,38 @@ static struct vfio_dma *vfio_find_dma(struct
> > vfio_iommu *iommu,
> > >  	return NULL;
> > >  }
> > >
> > > +/* This function must be called with iommu->lock held */ static bool
> > > +vfio_overlap_with_resvd_region(struct vfio_iommu *iommu,
> > > +					   dma_addr_t start, size_t size) {
> > > +	struct vfio_resvd_region *region;
> > > +
> > > +	list_for_each_entry(region, &iommu->reserved_iova_list, next) {
> > > +		if (region->iova < start)
> > > +			return (start - region->iova < region->size);
> > > +		else if (start < region->iova)
> > > +			return (region->iova - start < size);
> > 
> > <= on both of the return lines?
> 
> I think is should be "<" and not "=<", no ?

Yep, looks like you're right.  Maybe there's a more straightforward way
to do this.

> > 
> > > +
> > > +		return (region->size > 0 && size > 0);
> > > +	}
> > > +
> > > +	return false;
> > > +}
> > > +
> > > +/* This function must be called with iommu->lock held */ static
> > > +struct vfio_resvd_region *vfio_find_resvd_region(struct vfio_iommu
> > *iommu,
> > > +						 dma_addr_t start, size_t
> > size) {
> > > +	struct vfio_resvd_region *region;
> > > +
> > > +	list_for_each_entry(region, &iommu->reserved_iova_list, next)
> > > +		if (region->iova == start && region->size == size)
> > > +			return region;
> > > +
> > > +	return NULL;
> > > +}
> > > +
> > >  static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma
> > > *new)  {
> > >  	struct rb_node **link = &iommu->dma_list.rb_node, *parent =
> > NULL; @@
> > > -580,7 +622,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> > >
> > >  	mutex_lock(&iommu->lock);
> > >
> > > -	if (vfio_find_dma(iommu, iova, size)) {
> > > +	if (vfio_find_dma(iommu, iova, size) ||
> > > +	    vfio_overlap_with_resvd_region(iommu, iova, size)) {
> > >  		mutex_unlock(&iommu->lock);
> > >  		return -EEXIST;
> > >  	}
> > > @@ -626,6 +669,127 @@ static int vfio_dma_do_map(struct vfio_iommu
> > *iommu,
> > >  	return ret;
> > >  }
> > >
> > > +/* This function must be called with iommu->lock held */ static int
> > > +vfio_iommu_resvd_region_del(struct vfio_iommu *iommu,
> > > +				dma_addr_t iova, size_t size, int prot) {
> > > +	struct vfio_resvd_region *res_region;
> > 
> > Have some consistency in naming, just use "region".
> 
> Ok,
> 
> > > +
> > > +	res_region = vfio_find_resvd_region(iommu, iova, size);
> > > +	/* Region should not be mapped in iommu */
> > > +	if (res_region == NULL || res_region->map_paddr)
> > > +		return -EINVAL;
> > 
> > Are these two separate errors?  !region is -EINVAL, but being mapped is -
> > EBUSY.
> 
> Yes, will separate them.
> 
> > 
> > > +
> > > +	list_del(&res_region->next);
> > > +	kfree(res_region);
> > > +	return 0;
> > > +}
> > > +
> > > +/* This function must be called with iommu->lock held */ static int
> > > +vfio_iommu_resvd_region_add(struct vfio_iommu *iommu,
> > > +				       dma_addr_t iova, size_t size, int prot) {
> > > +	struct vfio_resvd_region *res_region;
> > > +
> > > +	/* Check overlap with with dma maping and reserved regions */
> > > +	if (vfio_find_dma(iommu, iova, size) ||
> > > +	    vfio_find_resvd_region(iommu, iova, size))
> > > +		return -EEXIST;
> > > +
> > > +	res_region = kzalloc(sizeof(*res_region), GFP_KERNEL);
> > > +	if (res_region == NULL)
> > > +		return -ENOMEM;
> > > +
> > > +	res_region->iova = iova;
> > > +	res_region->size = size;
> > > +	res_region->prot = prot;
> > > +	res_region->refcount = 0;
> > > +	res_region->map_paddr = 0;
> > 
> > They're already 0 by the kzalloc
> 
> Yes ;)
> > 
> > > +
> > > +	list_add(&res_region->next, &iommu->reserved_iova_list);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static
> > > +int vfio_handle_reserved_region_add(struct vfio_iommu *iommu,
> > > +				struct vfio_iommu_reserved_region_add
> > *region) {
> > > +	dma_addr_t iova = region->iova;
> > > +	size_t size = region->size;
> > > +	int flags = region->flags;
> > > +	uint64_t mask;
> > > +	int prot = 0;
> > > +	int ret;
> > > +
> > > +	/* Verify that none of our __u64 fields overflow */
> > > +	if (region->size != size || region->iova != iova)
> > > +		return -EINVAL;
> > > +
> > > +	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
> > > +
> > > +	WARN_ON(mask & PAGE_MASK);
> > > +
> > > +	if (flags & VFIO_IOMMU_RES_REGION_READ)
> > > +		prot |= IOMMU_READ;
> > > +	if (flags & VFIO_IOMMU_RES_REGION_WRITE)
> > > +		prot |= IOMMU_WRITE;
> > > +
> > > +	if (!prot || !size || (size | iova) & mask)
> > > +		return -EINVAL;
> > > +
> > > +	/* Don't allow IOVA wrap */
> > > +	if (iova + size - 1 < iova)
> > > +		return -EINVAL;
> > > +
> > > +	mutex_lock(&iommu->lock);
> > > +
> > > +	if (region->flags & VFIO_IOMMU_RES_REGION_ADD) {
> > > +		ret = vfio_iommu_resvd_region_add(iommu, iova, size,
> > prot);
> > > +		if (ret) {
> > > +			mutex_unlock(&iommu->lock);
> > > +			return ret;
> > > +		}
> > > +	}
> > 
> > Silently fail if not VFIO_IOMMU_RES_REGION_ADD?
> 
> As per below comment we do not need this flag. So the above flag checking will be removed.
> 
> > 
> > > +
> > > +	mutex_unlock(&iommu->lock);
> > > +	return 0;
> > > +}
> > > +
> > > +static
> > > +int vfio_handle_reserved_region_del(struct vfio_iommu *iommu,
> > > +				struct vfio_iommu_reserved_region_del
> > *region) {
> > > +	dma_addr_t iova = region->iova;
> > > +	size_t size = region->size;
> > > +	int flags = region->flags;
> > > +	int ret;
> > > +
> > > +	if (!(flags & VFIO_IOMMU_RES_REGION_DEL))
> > > +		return -EINVAL;
> > > +
> > > +	mutex_lock(&iommu->lock);
> > > +
> > > +	/* Check for the region */
> > > +	if (vfio_find_resvd_region(iommu, iova, size) == NULL) {
> > > +		mutex_unlock(&iommu->lock);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	/* remove the reserved region */
> > > +	if (region->flags & VFIO_IOMMU_RES_REGION_DEL) {
> > > +		ret = vfio_iommu_resvd_region_del(iommu, iova, size,
> > flags);
> > > +		if (ret) {
> > > +			mutex_unlock(&iommu->lock);
> > > +			return ret;
> > > +		}
> > > +	}
> > > +
> > > +	mutex_unlock(&iommu->lock);
> > > +	return 0;
> > > +}
> > > +
> > >  static int vfio_bus_type(struct device *dev, void *data)  {
> > >  	struct bus_type **bus = data;
> > > @@ -905,6 +1069,7 @@ static void *vfio_iommu_type1_open(unsigned
> > long arg)
> > >  	}
> > >
> > >  	INIT_LIST_HEAD(&iommu->domain_list);
> > > +	INIT_LIST_HEAD(&iommu->reserved_iova_list);
> > >  	iommu->dma_list = RB_ROOT;
> > >  	mutex_init(&iommu->lock);
> > >
> > > @@ -1020,6 +1185,40 @@ static long vfio_iommu_type1_ioctl(void
> > *iommu_data,
> > >  			return ret;
> > >
> > >  		return copy_to_user((void __user *)arg, &unmap, minsz);
> > > +	} else if (cmd == VFIO_IOMMU_RESERVED_REGION_ADD) {
> > > +		struct vfio_iommu_reserved_region_add region;
> > > +		long ret;
> > > +
> > > +		minsz = offsetofend(struct
> > vfio_iommu_reserved_region_add,
> > > +				    size);
> > > +		if (copy_from_user(&region, (void __user *)arg, minsz))
> > > +			return -EFAULT;
> > > +
> > > +		if (region.argsz < minsz)
> > > +			return -EINVAL;
> > > +
> > > +		ret = vfio_handle_reserved_region_add(iommu, &region);
> > > +		if (ret)
> > > +			return ret;
> > > +
> > > +		return copy_to_user((void __user *)arg, &region, minsz);
> > > +	} else if (cmd == VFIO_IOMMU_RESERVED_REGION_DEL) {
> > > +		struct vfio_iommu_reserved_region_del region;
> > > +		long ret;
> > > +
> > > +		minsz = offsetofend(struct
> > vfio_iommu_reserved_region_del,
> > > +				    size);
> > > +		if (copy_from_user(&region, (void __user *)arg, minsz))
> > > +			return -EFAULT;
> > > +
> > > +		if (region.argsz < minsz)
> > > +			return -EINVAL;
> > > +
> > > +		ret = vfio_handle_reserved_region_del(iommu, &region);
> > > +		if (ret)
> > > +			return ret;
> > > +
> > > +		return copy_to_user((void __user *)arg, &region, minsz);
> > 
> > So we've just created an interface that is available for all vfio-type1 users,
> > whether it makes any sense for the platform or not,
> 
> How we should decide that a given platform needs this or not?

You later add new iommu interfaces, presumably if the iommu doesn't
implement those interfaces then there's no point in us exposing these
interfaces to vfio.

> > and it allows the user to
> > consume arbitrary amounts of kernel memory, by making an infinitely long
> > list of reserved iova entries, brilliant!
> 
> I was not sure of how to limit the user. What I was thinking of having a default number of pages a user can reserve (512 pages). Also we can give a sysfs interface so that user can change the default number of pages. Does this sound good? If not please suggest?

Isn't 512 entries a lot for a linked list?  Can we use our existing rb
tree to manage these entries rather than a secondary list?  How many
entries do we realistically need?  Can the iommu callbacks help give us
a limit?  Can we somehow use information about the devices in the group
to produce a limit, ie. MSI vectors possible from the group?

> > 
> > >  	}
> > >
> > >  	return -ENOTTY;
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index b57b750..1abd1a9 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -440,6 +440,49 @@ struct vfio_iommu_type1_dma_unmap {
> > >  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
> > >  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
> > >
> > > +/**************** Reserved IOVA region specific APIs
> > > +**********************/
> > > +
> > > +/*
> > > + * VFIO_IOMMU_RESERVED_REGION_ADD - _IO(VFIO_TYPE, VFIO_BASE
> > + 17,
> > > + *					struct
> > vfio_iommu_reserved_region_add)
> > > + * This is used to add a reserved iova region.
> > > + * @flags - Input: VFIO_IOMMU_RES_REGION_ADD flag is for adding
> > > + * a reserved region.
> > 
> > Why else would we call VFIO_IOMMU_RESERVED_REGION_ADD except to
> > add a region, this flag is redundant.
> 
> Ok, will remove this.
> 
> > 
> > > + * Also pass READ/WRITE/IOMMU flags to be used in iommu mapping.
> > > + * @iova - Input: IOVA base address of reserved region
> > > + * @size - Input: Size of the reserved region
> > > + * Return: 0 on success, -errno on failure  */ struct
> > > +vfio_iommu_reserved_region_add {
> > > +	__u32   argsz;
> > > +	__u32   flags;
> > > +#define VFIO_IOMMU_RES_REGION_ADD	(1 << 0) /* Add a reserved
> > region */
> > > +#define VFIO_IOMMU_RES_REGION_READ	(1 << 1) /* readable region */
> > > +#define VFIO_IOMMU_RES_REGION_WRITE	(1 << 2) /* writable
> > region */
> > > +	__u64	iova;
> > > +	__u64   size;
> > > +};
> > > +#define VFIO_IOMMU_RESERVED_REGION_ADD _IO(VFIO_TYPE,
> > VFIO_BASE + 17)
> > > +
> > > +/*
> > > + * VFIO_IOMMU_RESERVED_REGION_DEL - _IO(VFIO_TYPE, VFIO_BASE +
> > 18,
> > > + *					struct
> > vfio_iommu_reserved_region_del)
> > > + * This is used to delete an existing reserved iova region.
> > > + * @flags - VFIO_IOMMU_RES_REGION_DEL flag is for deleting a region
> > > +use,
> > > + *  only a unmapped region can be deleted.
> > > + * @iova - Input: IOVA base address of reserved region
> > > + * @size - Input: Size of the reserved region
> > > + * Return: 0 on success, -errno on failure  */ struct
> > > +vfio_iommu_reserved_region_del {
> > > +	__u32   argsz;
> > > +	__u32   flags;
> > > +#define VFIO_IOMMU_RES_REGION_DEL	(1 << 0) /* unset the
> > reserved region */
> > > +	__u64	iova;
> > > +	__u64   size;
> > > +};
> > > +#define VFIO_IOMMU_RESERVED_REGION_DEL _IO(VFIO_TYPE,
> > VFIO_BASE + 18)
> > > +
> > 
> > These are effectively both
> > 
> > struct vfio_iommu_type1_dma_unmap
> 
> Yes, do you want to suggest that we should use " struct vfio_iommu_type1_dma_unmap". I found that confusing.
> What is we use "struct vfio_iommu_reserved_region" and use flag VFIO_IOMMU_RES_REGION_DEL/ VFIO_IOMMU_RES_REGION_ADD.

What if we just use the existing map and unmap interface with a flag to
indicate an MSI reserved mapping?  I don't really see why we need new
ioctls for this.

