From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 05/23] iommu: Introduce cache_invalidate API
Date: Thu, 2 May 2019 08:58:29 +0200
Message-ID: <e5d2fdd6-4ce1-863e-5198-0b05d727a5b6@redhat.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-6-eric.auger@redhat.com>
 <a9745aef-8686-c761-e3d0-dd0e98a1f5b2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a9745aef-8686-c761-e3d0-dd0e98a1f5b2@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: peter.maydell@linaro.org, kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean-Philippe,

On 5/1/19 12:38 PM, Jean-Philippe Brucker wrote:
> On 08/04/2019 13:18, Eric Auger wrote:
>> +int iommu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
>> +			   struct iommu_cache_invalidate_info *inv_info)
>> +{
>> +	int ret = 0;
>> +
>> +	if (unlikely(!domain->ops->cache_invalidate))
>> +		return -ENODEV;
>> +
>> +	ret = domain->ops->cache_invalidate(domain, dev, inv_info);
>> +
>> +	return ret;
> 
> Nit: you don't really need ret
> 
> The UAPI looks good to me, so
> 
> Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Just to make sure, do you accept changes proposed by Jacob in
https://lkml.org/lkml/2019/4/29/659 ie.
- the addition of NR_IOMMU_INVAL_GRANU in enum iommu_inv_granularity and
- the addition of NR_IOMMU_CACHE_TYPE

Thanks

Eric
> 
