From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 2/5] VFIO: platform: add get_device callback
Date: Thu, 14 May 2015 10:28:52 +0200
Message-ID: <55545CC4.7050502@linaro.org>
References: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>	
 <1431008843-28411-3-git-send-email-eric.auger@linaro.org>
 <1431541943.3625.53.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF00513E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:19:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HEa6tWoB3g-h for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 04:19:52 -0400 (EDT)
Received: from mail-wg0-f47.google.com (mail-wg0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2ADA513DA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:19:51 -0400 (EDT)
Received: by wgin8 with SMTP id n8so67459028wgi.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 01:28:59 -0700 (PDT)
In-Reply-To: <1431541943.3625.53.camel@redhat.com>
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
>> It is needed to introduce a new callback enabling to retrieve the
>> struct device* from the vfio_platform_device. Implementation depends
>> on the underlying device, platform or amba. This will be used to retrieve
>> the compatibility string of the device.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  drivers/vfio/platform/vfio_amba.c             |  9 +++++++++
>>  drivers/vfio/platform/vfio_platform.c         | 10 ++++++++++
>>  drivers/vfio/platform/vfio_platform_private.h |  1 +
>>  3 files changed, 20 insertions(+)
>>
>> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
>> index ff0331f..fd68115 100644
>> --- a/drivers/vfio/platform/vfio_amba.c
>> +++ b/drivers/vfio/platform/vfio_amba.c
>> @@ -48,6 +48,14 @@ static int get_amba_irq(struct vfio_platform_device *vdev, int i)
>>  	return ret ? ret : -ENXIO;
>>  }
>>  
>> +static struct device *vfio_amba_get_device(struct vfio_platform_device *vdev)
>> +{
>> +	struct amba_device *pdev = (struct amba_device *) vdev->opaque;
>> +	struct device *dev = &pdev->dev;
>> +
>> +	return dev;
>> +}
> 
> *get* device implies a increment in the reference count.  There's
> nothing like that happening here.  Do you just want a to_device wrapper?
Yes you already told that in the past and I should have learnt ...
> Why doesn't struct vfio_platform_device just cache a pointer to the
> struct device?
simpler indeed if agreed.
> 
>> +
>>  static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
>>  {
>>  	struct vfio_platform_device *vdev;
>> @@ -67,6 +75,7 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
>>  	vdev->flags = VFIO_DEVICE_FLAGS_AMBA;
>>  	vdev->get_resource = get_amba_resource;
>>  	vdev->get_irq = get_amba_irq;
>> +	vdev->get_device = vfio_amba_get_device;
>>  
>>  	ret = vfio_platform_probe_common(vdev, &adev->dev);
>>  	if (ret) {
>> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
>> index cef645c..c025d76 100644
>> --- a/drivers/vfio/platform/vfio_platform.c
>> +++ b/drivers/vfio/platform/vfio_platform.c
>> @@ -51,6 +51,15 @@ static int get_platform_irq(struct vfio_platform_device *vdev, int i)
>>  	return platform_get_irq(pdev, i);
>>  }
>>  
>> +static struct device *vfio_platform_get_device(
>> +				struct vfio_platform_device *vdev)
>> +{
>> +	struct platform_device *pdev = (struct platform_device *) vdev->opaque;
>> +	struct device *dev = &pdev->dev;
>> +
>> +	return dev;
>> +}
>> +
>>  static int vfio_platform_probe(struct platform_device *pdev)
>>  {
>>  	struct vfio_platform_device *vdev;
>> @@ -65,6 +74,7 @@ static int vfio_platform_probe(struct platform_device *pdev)
>>  	vdev->flags = VFIO_DEVICE_FLAGS_PLATFORM;
>>  	vdev->get_resource = get_platform_resource;
>>  	vdev->get_irq = get_platform_irq;
>> +	vdev->get_device = vfio_platform_get_device;
>>  
>>  	ret = vfio_platform_probe_common(vdev, &pdev->dev);
>>  	if (ret)
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index da2d60b..68909a4 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -67,6 +67,7 @@ struct vfio_platform_device {
>>  	struct resource*
>>  		(*get_resource)(struct vfio_platform_device *vdev, int i);
>>  	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
>> +	struct device *(*get_device)(struct vfio_platform_device *vdev);
>>  };
>>  
>>  typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);
> 
> 
> 
