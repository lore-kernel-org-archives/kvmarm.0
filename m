From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 2/4] vfio: platform: reset: calxedaxgmac: add reset
 function registration
Date: Mon, 19 Oct 2015 15:17:30 +0200
Message-ID: <5624ED6A.5030408@linaro.org>
References: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
 <1445184015-24414-3-git-send-email-eric.auger@linaro.org>
 <3829716.dW4OHEgDOa@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3829716.dW4OHEgDOa@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@linaro.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Arnd,
On 10/19/2015 03:04 PM, Arnd Bergmann wrote:
> On Sunday 18 October 2015 18:00:13 Eric Auger wrote:
>> diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
>> index 619dc7d..4f76b17 100644
>> --- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
>> +++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
>> @@ -29,8 +29,7 @@
>>  #define DRIVER_VERSION  "0.1"
>>  #define DRIVER_AUTHOR   "Eric Auger <eric.auger@linaro.org>"
>>  #define DRIVER_DESC     "Reset support for Calxeda xgmac vfio platform device"
>> -
>> -#define CALXEDAXGMAC_COMPAT "calxeda,hb-xgmac"
>> +#define COMPAT		"calxeda,hb-xgmac"
> 
> Why the rename?
This define was not used. Since the code is meant to be duplicated from
one reset module to the other I thought it did not bring any have a
specialized name
> 
>>  /* XGMAC Register definitions */
>>  #define XGMAC_CONTROL           0x00000000      /* MAC Configuration */
>> @@ -80,6 +79,43 @@ int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_platform_calxedaxgmac_reset);
>>  
>> +static int __init vfio_platform_calxedaxgmac_init(void)
>> +{
>> +	int (*register_reset)(struct module *, char*,
>> +				vfio_platform_reset_fn_t);
>> +	int ret;
>> +
>> +	register_reset = symbol_get(vfio_platform_register_reset);
>> +	if (!register_reset)
>> +		return -EINVAL;
> 
> I don't understand what you do the symbol_get() here for.
> Why not just call that function directly
the function is implemented in a separate module. This is just to make
sure the vfio-platform module is loaded, in case the end-user attempts
to load the reset module without having this latter loaded.
> 
>> +	ret = register_reset(THIS_MODULE, COMPAT,
>> +	vfio_platform_calxedaxgmac_reset);
> 
> This is whitespace damaged, the second line needs to be indented
> to the opening braces.
ok
> 
> I would also suggest defining register_reset as a macro that
> implicitly passes the THIS_MODULE argument, as other subsystems
> do.
ok

Thanks

Best Regards

Eric
> 
> 	Arnd
> 
