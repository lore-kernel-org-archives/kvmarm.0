From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v7 05/23] iommu: Introduce cache_invalidate API
Date: Thu, 2 May 2019 11:53:34 +0100
Message-ID: <6af5ddb7-75ad-7d3f-b303-f6f06adb1bf0@arm.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-6-eric.auger@redhat.com>
 <a9745aef-8686-c761-e3d0-dd0e98a1f5b2@arm.com>
 <e5d2fdd6-4ce1-863e-5198-0b05d727a5b6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e5d2fdd6-4ce1-863e-5198-0b05d727a5b6@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>, "yi.l.liu@intel.com" <yi.l.liu@intel.com>, Will Deacon <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>
Cc: "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "kevin.tian@intel.com" <kevin.tian@intel.com>, Vincent Stehle <Vincent.Stehle@arm.com>, "ashok.raj@intel.com" <ashok.raj@intel.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Christoffer Dall <Christoffer.Dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 02/05/2019 07:58, Auger Eric wrote:
> Hi Jean-Philippe,
> 
> On 5/1/19 12:38 PM, Jean-Philippe Brucker wrote:
>> On 08/04/2019 13:18, Eric Auger wrote:
>>> +int iommu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
>>> +			   struct iommu_cache_invalidate_info *inv_info)
>>> +{
>>> +	int ret = 0;
>>> +
>>> +	if (unlikely(!domain->ops->cache_invalidate))
>>> +		return -ENODEV;
>>> +
>>> +	ret = domain->ops->cache_invalidate(domain, dev, inv_info);
>>> +
>>> +	return ret;
>>
>> Nit: you don't really need ret
>>
>> The UAPI looks good to me, so
>>
>> Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> Just to make sure, do you accept changes proposed by Jacob in
> https://lkml.org/lkml/2019/4/29/659 ie.
> - the addition of NR_IOMMU_INVAL_GRANU in enum iommu_inv_granularity and
> - the addition of NR_IOMMU_CACHE_TYPE

Ah sorry, I forgot about that, I'll review the next version. Yes they
can be useful (maybe call them IOMMU_INV_GRANU_NR and
IOMMU_CACHE_INV_TYPE_NR?). I guess it's legal to export in UAPI values
that will change over time, as VFIO also does it in its enums.

Thanks,
Jean
