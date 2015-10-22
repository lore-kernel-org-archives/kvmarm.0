From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 6/6] vfio: platform: move get/put reset at open/release
Date: Thu, 22 Oct 2015 15:26:55 +0200
Message-ID: <5628E41F.5050602@linaro.org>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
 <1445506922-6005-7-git-send-email-eric.auger@linaro.org>
 <4304536.D7eNHjlsvD@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDE0D410BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 09:24:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vf5TXeuBTqjB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2015 09:24:21 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCD0740FAB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 09:24:20 -0400 (EDT)
Received: by wicll6 with SMTP id ll6so119087859wic.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 06:26:57 -0700 (PDT)
In-Reply-To: <4304536.D7eNHjlsvD@wuerfel>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/22/2015 12:29 PM, Arnd Bergmann wrote:
> On Thursday 22 October 2015 11:42:02 Eric Auger wrote:
>> Currently reset lookup is done on probe. This introduces a
>> race with new registration mechanism in the case where the
>> vfio-platform driver is bound to the device before its module
>> is loaded: on the load, the probe happens which triggers the
>> reset module load which itself attempts to get the symbol for
>> the registration function (vfio_platform_register_reset). The
>> symbol is not yet available hence the lookup fails. In case we
>> do the lookup in the first open we are sure the vfio-platform
>> module is loaded and vfio_platform_register_reset is available.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> I don't understand the explanation. I would expect the request_module()
> call to block until the module is actually loaded. Is this not
> what happens?
> 
>>         mutex_unlock(&driver_lock);
>> @@ -181,6 +182,8 @@ static int vfio_platform_open(void *device_data)
>>                 if (ret)
>>                         goto err_irq;
>>  
>> +               vfio_platform_get_reset(vdev);
>> +
>>                 if (vdev->reset)
>>                         vdev->reset(vdev);
>>
> 
> This needs some error handling to ensure that the open() fails
> if there is no reset handler.

Is that really what we want? The code was meant to allow the use case
where the VFIO platform driver would be used without such reset module.

I think the imperious need for a reset module depends on the device and
more importantly depends on the IOMMU mapping. With QEMU VFIO
integration this is needed because the whole VM memory is IOMMU mapped
but in a simpler user-space driver context, we might live without.

Any thought?

Eric
> 
> 	Arnd
> 
