From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v7 05/23] iommu: Introduce cache_invalidate API
Date: Wed, 1 May 2019 11:38:13 +0100
Message-ID: <a9745aef-8686-c761-e3d0-dd0e98a1f5b2@arm.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-6-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190408121911.24103-6-eric.auger@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: peter.maydell@linaro.org, kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/04/2019 13:18, Eric Auger wrote:
> +int iommu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
> +			   struct iommu_cache_invalidate_info *inv_info)
> +{
> +	int ret = 0;
> +
> +	if (unlikely(!domain->ops->cache_invalidate))
> +		return -ENODEV;
> +
> +	ret = domain->ops->cache_invalidate(domain, dev, inv_info);
> +
> +	return ret;

Nit: you don't really need ret

The UAPI looks good to me, so

Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
