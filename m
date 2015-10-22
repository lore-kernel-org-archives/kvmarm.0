From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 6/6] vfio: platform: move get/put reset at open/release
Date: Thu, 22 Oct 2015 13:40:16 +0200
Message-ID: <5628CB20.7040301@linaro.org>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
 <1445506922-6005-7-git-send-email-eric.auger@linaro.org>
 <4304536.D7eNHjlsvD@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4304536.D7eNHjlsvD@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Arnd,
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

Again many thanks for this new review.

My understanding is the following
1) vfio-platform is attached to the device through the override mechanism
2) vfio-platform get loaded through modprobe:
2-1) the platform driver init function eventually calls the
vfio-platform probe function.
2-2) request_module of vfio-platform-calxedaxgmac gets called.
3) The init of  vfio-platform-calxedaxgmac looks for
vfio_platform_register_reset. Unfortunately at that stage the init of
vfio-platform is not completed so the symbol is not available
3-1) in case symbol_get is used in vfio_platform_calxedaxgmac init, as
of today, this latter simply returns -EINVAL. Reset registration failed
but no stall.
3-2) in case symbol_get is *not* used, I think the module loader
attempts to load vfio-platform, which is already under load and this
causes a stall.

Let me know if you think this understanding is not correct.

Best Regards

Eric
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
> 
> 	Arnd
> 
