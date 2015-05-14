From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 3/5] VFIO: platform: add reset callback
Date: Thu, 14 May 2015 10:39:12 +0200
Message-ID: <55545F30.4090808@linaro.org>
References: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>	
 <1431008843-28411-4-git-send-email-eric.auger@linaro.org>
 <1431541959.3625.54.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E197513F9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:30:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IecNGMRntftG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 04:30:10 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC21551139
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:30:09 -0400 (EDT)
Received: by wicmx19 with SMTP id mx19so7055858wic.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 01:39:16 -0700 (PDT)
In-Reply-To: <1431541959.3625.54.camel@redhat.com>
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
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/13/2015 08:32 PM, Alex Williamson wrote:
> On Thu, 2015-05-07 at 16:27 +0200, Eric Auger wrote:
>> A new reset callback is introduced. If this callback is populated,
>> the reset is invoked on device release or upon userspace ioctl. The
>> modality is exposed on VFIO_DEVICE_GET_INFO.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> v2 -> v3:
>> - change patch title and commit message. Use IS_ERR_OR_NULL to
>>   anticipate for getter returned value.
>>
>> v1 -> v2:
>> - On VFIO_DEVICE_RESET returns -EINVAL in case the callback is not
>>   populated (instead of -ENOTTY)
>> ---
>>  drivers/vfio/platform/vfio_platform_common.c  | 12 ++++++++++--
>>  drivers/vfio/platform/vfio_platform_private.h |  1 +
>>  2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> index edbf24c..0d10018 100644
>> --- a/drivers/vfio/platform/vfio_platform_common.c
>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> @@ -103,6 +103,8 @@ static void vfio_platform_release(void *device_data)
>>  	mutex_lock(&driver_lock);
>>  
>>  	if (!(--vdev->refcnt)) {
>> +		if (!IS_ERR_OR_NULL(vdev->reset))
>> +			vdev->reset(vdev);
> 
> 
> It seems sloppy to have a function pointer that could be ERR_PTR.
The reset lookup function currently can return errors. I will change this.
> 
> Should we also be trying to reset on device open?
may be yes. I was influenced by qemu use case where reset is also
explicitly invoked through iotcl by the reset notifier. If we do so we
might have duplicated resets.

- Eric
> 
>>  		vfio_platform_regions_cleanup(vdev);
>>  		vfio_platform_irq_cleanup(vdev);
>>  	}
>> @@ -162,6 +164,8 @@ static long vfio_platform_ioctl(void *device_data,
>>  		if (info.argsz < minsz)
>>  			return -EINVAL;
>>  
>> +		if (!IS_ERR_OR_NULL(vdev->reset))
>> +			vdev->flags |= VFIO_DEVICE_FLAGS_RESET;
>>  		info.flags = vdev->flags;
>>  		info.num_regions = vdev->num_regions;
>>  		info.num_irqs = vdev->num_irqs;
>> @@ -255,8 +259,12 @@ static long vfio_platform_ioctl(void *device_data,
>>  
>>  		return ret;
>>  
>> -	} else if (cmd == VFIO_DEVICE_RESET)
>> -		return -EINVAL;
>> +	} else if (cmd == VFIO_DEVICE_RESET) {
>> +		if (!IS_ERR_OR_NULL(vdev->reset))
>> +			return vdev->reset(vdev);
>> +		else
>> +			return -EINVAL;
>> +	}
>>  
>>  	return -ENOTTY;
>>  }
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index 68909a4..84ccf6d 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -68,6 +68,7 @@ struct vfio_platform_device {
>>  		(*get_resource)(struct vfio_platform_device *vdev, int i);
>>  	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
>>  	struct device *(*get_device)(struct vfio_platform_device *vdev);
>> +	int	(*reset)(struct vfio_platform_device *vdev);
>>  };
>>  
>>  typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);
> 
> 
> 
