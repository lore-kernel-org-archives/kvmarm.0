From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 09/22] vfio: VFIO_IOMMU_BIND/UNBIND_MSI
Date: Fri, 22 Mar 2019 10:30:02 +0100
Message-ID: <16931d58-9c88-8cfb-a392-408ea7afdf16@redhat.com>
References: <20190317172232.1068-1-eric.auger@redhat.com>
 <20190317172232.1068-10-eric.auger@redhat.com>
 <20190321170159.38358f38@x1.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6543D4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Mar 2019 05:30:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VlyHshU81+s8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Mar 2019 05:30:12 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 013474A2E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Mar 2019 05:30:11 -0400 (EDT)
In-Reply-To: <20190321170159.38358f38@x1.home>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: yi.l.liu@linux.intel.com, kevin.tian@intel.com, jacob.jun.pan@linux.intel.com, ashok.raj@intel.com, kvm@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, marc.zyngier@arm.com, iommu@lists.linux-foundation.org, vincent.stehle@arm.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,
On 3/22/19 12:01 AM, Alex Williamson wrote:
> On Sun, 17 Mar 2019 18:22:19 +0100
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> This patch adds the VFIO_IOMMU_BIND/UNBIND_MSI ioctl which aim
>> to pass/withdraw the guest MSI binding to/from the host.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v3 -> v4:
>> - add UNBIND
>> - unwind on BIND error
>>
>> v2 -> v3:
>> - adapt to new proto of bind_guest_msi
>> - directly use vfio_iommu_for_each_dev
>>
>> v1 -> v2:
>> - s/vfio_iommu_type1_guest_msi_binding/vfio_iommu_type1_bind_guest_msi
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 58 +++++++++++++++++++++++++++++++++
>>  include/uapi/linux/vfio.h       | 29 +++++++++++++++++
>>  2 files changed, 87 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 12a40b9db6aa..66513679081b 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -1710,6 +1710,25 @@ static int vfio_cache_inv_fn(struct device *dev, void *data)
>>  	return iommu_cache_invalidate(d, dev, &ustruct->info);
>>  }
>>  
>> +static int vfio_bind_msi_fn(struct device *dev, void *data)
>> +{
>> +	struct vfio_iommu_type1_bind_msi *ustruct =
>> +		(struct vfio_iommu_type1_bind_msi *)data;
>> +	struct iommu_domain *d = iommu_get_domain_for_dev(dev);
>> +
>> +	return iommu_bind_guest_msi(d, dev, ustruct->iova,
>> +				    ustruct->gpa, ustruct->size);
>> +}
>> +
>> +static int vfio_unbind_msi_fn(struct device *dev, void *data)
>> +{
>> +	dma_addr_t *iova = (dma_addr_t *)data;
>> +	struct iommu_domain *d = iommu_get_domain_for_dev(dev);
> 
> Same as previous, we can encapsulate domain in our own struct to avoid
> a lookup.
> 
>> +
>> +	iommu_unbind_guest_msi(d, dev, *iova);
> 
> Is it strange that iommu-core is exposing these interfaces at a device
> level if every one of them requires us to walk all the devices?  Thanks,

Hum this per device API was devised in response of Robin's comments on

[RFC v2 12/20] dma-iommu: Implement NESTED_MSI cookie.

"
But that then seems to reveal a somewhat bigger problem - if the callers
are simply registering IPAs, and relying on the ITS driver to grab an
entry and fill in a PA later, then how does either one know *which* PA
is supposed to belong to a given IPA in the case where you have multiple
devices with different ITS targets assigned to the same guest? (and if
it's possible to assume a guest will use per-device stage 1 mappings and
present it with a single vITS backed by multiple pITSes, I think things
start breaking even harder.)
"

However looking back into the problem I wonder if there was an issue
with the iommu_domain based API.

If my understanding is correct, when assigned devices are protected by a
vIOMMU then they necessarily end up in separate host iommu domains even
if they belong to the same iommu_domain on the guest. And there can only
be a single device in this iommu_domain.

If this is confirmed, there is a non ambiguous association between 1
physical iommu_domain, 1 device, 1 S1 mapping and 1 physical MSI
controller.

I added the device handle handle to disambiguate those associations. The
gIOVA ->gDB mapping is associated with a device handle. Then when the
host needs a stage 1 mapping for this device, to build the nested
mapping towards the physical DB it can easily grab the gIOVA->gDB stage
1 mapping registered for this device.

The correctness looks more obvious to me, at least.

Thanks

Eric

> 
> Alex
> 
>> +	return 0;
>> +}
>> +
>>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>>  				   unsigned int cmd, unsigned long arg)
>>  {
>> @@ -1814,6 +1833,45 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>  					      vfio_cache_inv_fn);
>>  		mutex_unlock(&iommu->lock);
>>  		return ret;
>> +	} else if (cmd == VFIO_IOMMU_BIND_MSI) {
>> +		struct vfio_iommu_type1_bind_msi ustruct;
>> +		int ret;
>> +
>> +		minsz = offsetofend(struct vfio_iommu_type1_bind_msi,
>> +				    size);
>> +
>> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (ustruct.argsz < minsz || ustruct.flags)
>> +			return -EINVAL;
>> +
>> +		mutex_lock(&iommu->lock);
>> +		ret = vfio_iommu_for_each_dev(iommu, &ustruct,
>> +					      vfio_bind_msi_fn);
>> +		if (ret)
>> +			vfio_iommu_for_each_dev(iommu, &ustruct.iova,
>> +						vfio_unbind_msi_fn);
>> +		mutex_unlock(&iommu->lock);
>> +		return ret;
>> +	} else if (cmd == VFIO_IOMMU_UNBIND_MSI) {
>> +		struct vfio_iommu_type1_unbind_msi ustruct;
>> +		int ret;
>> +
>> +		minsz = offsetofend(struct vfio_iommu_type1_unbind_msi,
>> +				    iova);
>> +
>> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (ustruct.argsz < minsz || ustruct.flags)
>> +			return -EINVAL;
>> +
>> +		mutex_lock(&iommu->lock);
>> +		ret = vfio_iommu_for_each_dev(iommu, &ustruct.iova,
>> +					      vfio_unbind_msi_fn);
>> +		mutex_unlock(&iommu->lock);
>> +		return ret;
>>  	}
>>  
>>  	return -ENOTTY;
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 29f0ef2d805d..6763389b6adc 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -789,6 +789,35 @@ struct vfio_iommu_type1_cache_invalidate {
>>  };
>>  #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 24)
>>  
>> +/**
>> + * VFIO_IOMMU_BIND_MSI - _IOWR(VFIO_TYPE, VFIO_BASE + 25,
>> + *			struct vfio_iommu_type1_bind_msi)
>> + *
>> + * Pass a stage 1 MSI doorbell mapping to the host so that this
>> + * latter can build a nested stage2 mapping
>> + */
>> +struct vfio_iommu_type1_bind_msi {
>> +	__u32   argsz;
>> +	__u32   flags;
>> +	__u64	iova;
>> +	__u64	gpa;
>> +	__u64	size;
>> +};
>> +#define VFIO_IOMMU_BIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 25)
>> +
>> +/**
>> + * VFIO_IOMMU_UNBIND_MSI - _IOWR(VFIO_TYPE, VFIO_BASE + 26,
>> + *			struct vfio_iommu_type1_unbind_msi)
>> + *
>> + * Unregister an MSI mapping
>> + */
>> +struct vfio_iommu_type1_unbind_msi {
>> +	__u32   argsz;
>> +	__u32   flags;
>> +	__u64	iova;
>> +};
>> +#define VFIO_IOMMU_UNBIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 26)
>> +
>>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>>  
>>  /*
> 
