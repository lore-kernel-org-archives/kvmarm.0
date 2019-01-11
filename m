From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC v3 03/21] iommu: Introduce bind_guest_msi
Date: Fri, 11 Jan 2019 15:44:19 -0700
Message-ID: <20190111154419.502b3850@x1.home>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-4-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 854B34A4B8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jan 2019 17:44:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZFmeDyfEvZPu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jan 2019 17:44:26 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 290C64A4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jan 2019 17:44:26 -0500 (EST)
In-Reply-To: <20190108102633.17482-4-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: yi.l.liu@linux.intel.com, kevin.tian@intel.com, jacob.jun.pan@linux.intel.com, ashok.raj@intel.com, kvm@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, marc.zyngier@arm.com, iommu@lists.linux-foundation.org, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue,  8 Jan 2019 11:26:15 +0100
Eric Auger <eric.auger@redhat.com> wrote:

> On ARM, MSI are translated by the SMMU. An IOVA is allocated
> for each MSI doorbell. If both the host and the guest are exposed
> with SMMUs, we end up with 2 different IOVAs allocated by each.
> guest allocates an IOVA (gIOVA) to map onto the guest MSI
> doorbell (gDB). The Host allocates another IOVA (hIOVA) to map
> onto the physical doorbell (hDB).
> 
> So we end up with 2 untied mappings:
>          S1            S2
> gIOVA    ->    gDB
>               hIOVA    ->    gDB
                               ^^^ hDB

> Currently the PCI device is programmed by the host with hIOVA
> as MSI doorbell. So this does not work.
> 
> This patch introduces an API to pass gIOVA/gDB to the host so
> that gIOVA can be reused by the host instead of re-allocating
> a new IOVA. So the goal is to create the following nested mapping:
> 
>          S1            S2
> gIOVA    ->    gDB     ->    hDB
> 
> and program the PCI device with gIOVA MSI doorbell.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v2 -> v3:
> - add a struct device handle
> ---
>  drivers/iommu/iommu.c      | 10 ++++++++++
>  include/linux/iommu.h      | 13 +++++++++++++
>  include/uapi/linux/iommu.h |  6 ++++++
>  3 files changed, 29 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index b2e248770508..ea11442e7054 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1431,6 +1431,16 @@ static void __iommu_detach_device(struct iommu_domain *domain,
>  	trace_detach_device_from_domain(dev);
>  }
>  
> +int iommu_bind_guest_msi(struct iommu_domain *domain, struct device *dev,
> +			 struct iommu_guest_msi_binding *binding)
> +{
> +	if (unlikely(!domain->ops->bind_guest_msi))
> +		return -ENODEV;
> +
> +	return domain->ops->bind_guest_msi(domain, dev, binding);
> +}
> +EXPORT_SYMBOL_GPL(iommu_bind_guest_msi);
> +
>  void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
>  {
>  	struct iommu_group *group;
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 96d59886f230..244c1a3d5989 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -235,6 +235,9 @@ struct iommu_ops {
>  	int (*cache_invalidate)(struct iommu_domain *domain, struct device *dev,
>  				struct iommu_cache_invalidate_info *inv_info);
>  
> +	int (*bind_guest_msi)(struct iommu_domain *domain, struct device *dev,
> +			      struct iommu_guest_msi_binding *binding);
> +
>  	unsigned long pgsize_bitmap;
>  };
>  
> @@ -301,6 +304,9 @@ extern int iommu_set_pasid_table(struct iommu_domain *domain,
>  extern int iommu_cache_invalidate(struct iommu_domain *domain,
>  				struct device *dev,
>  				struct iommu_cache_invalidate_info *inv_info);
> +extern int iommu_bind_guest_msi(struct iommu_domain *domain, struct device *dev,
> +				struct iommu_guest_msi_binding *binding);
> +
>  extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
>  extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
>  extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
> @@ -724,6 +730,13 @@ iommu_cache_invalidate(struct iommu_domain *domain,
>  	return -ENODEV;
>  }
>  
> +static inline
> +int iommu_bind_guest_msi(struct iommu_domain *domain, struct device *dev,
> +			 struct iommu_guest_msi_binding *binding)
> +{
> +	return -ENODEV;
> +}
> +
>  #endif /* CONFIG_IOMMU_API */
>  
>  #ifdef CONFIG_IOMMU_DEBUGFS
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index 4605f5cfac84..f28cd9a1aa96 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -142,4 +142,10 @@ struct iommu_cache_invalidate_info {
>  	__u64		arch_id;
>  	__u64		addr;
>  };
> +
> +struct iommu_guest_msi_binding {
> +	__u64		iova;
> +	__u64		gpa;
> +	__u32		granule;

What's granule?  The size?  This looks a lot like just a stage 1
mapping interface, I can't really figure out from the description how
this matches to any specific MSI mapping.  Zero comments in the code
or headers here about how this is supposed to work.  Thanks,

Alex
