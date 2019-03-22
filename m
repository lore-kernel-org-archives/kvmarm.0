From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 07/22] vfio: VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE
Date: Fri, 22 Mar 2019 08:58:16 +0100
Message-ID: <cc12f29f-fc8b-515f-7dcb-bdfdf7f1fa36@redhat.com>
References: <20190317172232.1068-1-eric.auger@redhat.com>
 <20190317172232.1068-8-eric.auger@redhat.com>
 <20190321161938.4358b436@x1.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190321161938.4358b436@x1.home>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org, vincent.stehle@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On 3/21/19 11:19 PM, Alex Williamson wrote:
> On Sun, 17 Mar 2019 18:22:17 +0100
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> From: "Liu, Yi L" <yi.l.liu@linux.intel.com>
>>
>> This patch adds VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE ioctl
>> which aims to pass/withdraw the virtual iommu guest configuration
>> to/from the VFIO driver downto to the iommu subsystem.
>>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v3 -> v4:
>> - restore ATTACH/DETACH
>> - add unwind on failure
>>
>> v2 -> v3:
>> - s/BIND_PASID_TABLE/SET_PASID_TABLE
>>
>> v1 -> v2:
>> - s/BIND_GUEST_STAGE/BIND_PASID_TABLE
>> - remove the struct device arg
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 53 +++++++++++++++++++++++++++++++++
>>  include/uapi/linux/vfio.h       | 17 +++++++++++
>>  2 files changed, 70 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 73652e21efec..222e9199edbf 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -1644,6 +1644,43 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
>>  	return ret;
>>  }
>>  
>> +static void
>> +vfio_detach_pasid_table(struct vfio_iommu *iommu)
>> +{
>> +	struct vfio_domain *d;
>> +
>> +	mutex_lock(&iommu->lock);
>> +
>> +	list_for_each_entry(d, &iommu->domain_list, next) {
>> +		iommu_detach_pasid_table(d->domain);
>> +	}
>> +	mutex_unlock(&iommu->lock);
>> +}
>> +
>> +static int
>> +vfio_attach_pasid_table(struct vfio_iommu *iommu,
>> +			struct vfio_iommu_type1_attach_pasid_table *ustruct)
>> +{
>> +	struct vfio_domain *d;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&iommu->lock);
>> +
>> +	list_for_each_entry(d, &iommu->domain_list, next) {
>> +		ret = iommu_attach_pasid_table(d->domain, &ustruct->config);
>> +		if (ret)
>> +			goto unwind;
>> +	}
>> +	goto unlock;
>> +unwind:
>> +	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
>> +		iommu_detach_pasid_table(d->domain);
>> +	}
>> +unlock:
>> +	mutex_unlock(&iommu->lock);
>> +	return ret;
>> +}
>> +
>>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>>  				   unsigned int cmd, unsigned long arg)
>>  {
>> @@ -1714,6 +1751,22 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>  
>>  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>>  			-EFAULT : 0;
>> +	} else if (cmd == VFIO_IOMMU_ATTACH_PASID_TABLE) {
>> +		struct vfio_iommu_type1_attach_pasid_table ustruct;
>> +
>> +		minsz = offsetofend(struct vfio_iommu_type1_attach_pasid_table,
>> +				    config);
>> +
>> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (ustruct.argsz < minsz || ustruct.flags)
>> +			return -EINVAL;
> 
> Who is responsible for validating the ustruct.config?
> arm_smmu_attach_pasid_table() only looks at the format, ignoring the
> version field :-\  In fact, where is struct iommu_pasid_smmuv3 ever used
> from the config?

This is something missing and to be fixed in smmuv3
arm_smmu_attach_pasid_table(). At the moment the virtual SMMUv3 only
supports a single context descriptor hence the shortcut.

  Should the padding fields be forced to zero?  We
> don't have flags to incorporate use of them with future extensions, so
> maybe we don't care?

My guess is if we were to add new fields in iommu_pasid_smmuv3, we would
both increment iommu_pasid_smmuv3.version and
iommu_pasid_table_config.version. I don't think padding fields are meant
to be filled here (ie. no flag needed).

> 
>> +
>> +		return vfio_attach_pasid_table(iommu, &ustruct);
>> +	} else if (cmd == VFIO_IOMMU_DETACH_PASID_TABLE) {
>> +		vfio_detach_pasid_table(iommu);
>> +		return 0;
>>  	}
>>  
>>  	return -ENOTTY;
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 02bb7ad6e986..329d378565d9 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -14,6 +14,7 @@
>>  
>>  #include <linux/types.h>
>>  #include <linux/ioctl.h>
>> +#include <linux/iommu.h>
>>  
>>  #define VFIO_API_VERSION	0
>>  
>> @@ -759,6 +760,22 @@ struct vfio_iommu_type1_dma_unmap {
>>  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>>  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
>>  
>> +/**
>> + * VFIO_IOMMU_ATTACH_PASID_TABLE - _IOWR(VFIO_TYPE, VFIO_BASE + 22,
>> + *			struct vfio_iommu_type1_attach_pasid_table)
>> + *
>> + * Passes the PASID table to the host. Calling ATTACH_PASID_TABLE
>> + * while a table is already installed is allowed: it replaces the old
>> + * table. DETACH does a comprehensive tear down of the nested mode.
>> + */
>> +struct vfio_iommu_type1_attach_pasid_table {
>> +	__u32	argsz;
>> +	__u32	flags;
>> +	struct iommu_pasid_table_config config;
>> +};
>> +#define VFIO_IOMMU_ATTACH_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 22)
>> +#define VFIO_IOMMU_DETACH_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 23)
>> +
> 
> DETACH should also be documented, it's not clear from the uapi that it
> requires no parameters.  Thanks,
sure

Thanks

Eric
> 
> Alex
> 
