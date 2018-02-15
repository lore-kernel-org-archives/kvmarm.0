From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH 4/4] vfio: Allow type-1 IOMMU instantiation with a
 virtio-iommu
Date: Thu, 15 Feb 2018 13:53:20 +0000
Message-ID: <7cd2a302-b3ba-8c77-c721-d54938f2568a@arm.com>
References: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
 <20180214145340.1223-5-jean-philippe.brucker@arm.com>
 <20180214082639.54556efb@w520.home>
 <9f98aa85-3160-e285-cacd-2f429c58a775@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9f98aa85-3160-e285-cacd-2f429c58a775@arm.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Robin Murphy <Robin.Murphy@arm.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>, "mst@redhat.com" <mst@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>, "peterx@redhat.com" <peterx@redhat.com>, "bharat.bhushan@nxp.com" <bharat.bhushan@nxp.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/02/18 15:35, Robin Murphy wrote:
> On 14/02/18 15:26, Alex Williamson wrote:
>> On Wed, 14 Feb 2018 14:53:40 +0000
>> Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:
>>
>>> When enabling both VFIO and VIRTIO_IOMMU modules, automatically select
>>> VFIO_IOMMU_TYPE1 as well.
>>>
>>> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>>> ---
>>>   drivers/vfio/Kconfig | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
>>> index c84333eb5eb5..65a1e691110c 100644
>>> --- a/drivers/vfio/Kconfig
>>> +++ b/drivers/vfio/Kconfig
>>> @@ -21,7 +21,7 @@ config VFIO_VIRQFD
>>>   menuconfig VFIO
>>>   	tristate "VFIO Non-Privileged userspace driver framework"
>>>   	depends on IOMMU_API
>>> -	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM_SMMU || ARM_SMMU_V3)
>>> +	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM_SMMU || ARM_SMMU_V3 || VIRTIO_IOMMU)
>>>   	select ANON_INODES
>>>   	help
>>>   	  VFIO provides a framework for secure userspace device drivers.
>>
>> Why are we basing this on specific IOMMU drivers in the first place?
>> Only ARM is doing that.  Shouldn't IOMMU_API only be enabled for ARM
>> targets that support it and therefore we can forget about the specific
>> IOMMU drivers?  Thanks,
> 
> Makes sense - the majority of ARM systems (and mobile/embedded ARM64 
> ones) making use of IOMMU_API won't actually support VFIO, but it can't 
> hurt to allow them to select the type 1 driver regardless. Especially as 
> multiplatform configs are liable to be pulling in the SMMU driver(s) anyway.

Cool, then I'll change that line to:

+	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)

Thanks,
Jean
