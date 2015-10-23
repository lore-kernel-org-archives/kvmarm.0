From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 6/7] vfio: platform: use list of registered reset
 function
Date: Fri, 23 Oct 2015 17:15:43 +0200
Message-ID: <562A4F1F.1040209@linaro.org>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
 <4934120.DeNtNjTIFs@wuerfel> <562A3FFC.4050504@linaro.org>
 <5844194.uTAR9RVtmZ@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73490411AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 11:13:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2BGpe46VSUif for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 11:13:06 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E91D41049
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 11:13:06 -0400 (EDT)
Received: by wicll6 with SMTP id ll6so36065416wic.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:15:46 -0700 (PDT)
In-Reply-To: <5844194.uTAR9RVtmZ@wuerfel>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 10/23/2015 04:23 PM, Arnd Bergmann wrote:
> On Friday 23 October 2015 16:11:08 Eric Auger wrote:
>> Hi Arnd,
>> On 10/23/2015 03:12 PM, Arnd Bergmann wrote:
>>> On Friday 23 October 2015 14:37:14 Eric Auger wrote:
>>>> Remove the static lookup table and use the dynamic list of registered
>>>> reset functions instead. Also load the reset module through its alias.
>>>> The reset struct module pointer is stored in vfio_platform_device.
>>>>
>>>> We also remove the useless struct device pointer parameter in
>>>> vfio_platform_get_reset.
>>>>
>>>> This patch fixes the issue related to the usage of __symbol_get, which
>>>> besides from being moot, prevented compilation with CONFIG_MODULES
>>>> disabled.
>>>>
>>>> Also usage of MODULE_ALIAS makes possible to add a new reset module
>>>> without needing to update the framework. This was suggested by Arnd.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>> Reported-by: Arnd Bergmann <arnd@arndb.de>
>>>>
>>>>
>>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>>>
>>> but doesn't this need to come before patch 4/7?
>> Well I don't think so. In [4] we introduce the dynamic registration
>> method but until this patch we still use the old lookup method in the
>> static table. I tested and the reset lookup still works in [4].
>> If we put this one before the registration, the functionality will be
>> lost here.
>>
> 
> Ok, I see. I was getting confused by the removal of the EXPORT_SYMBOL
> statement there and thought it would break the __get_symbol call.

Hum no actually you're right. I checked the reset module was loaded but
effectly the _get_symbol fails. So if I want to keep the functionality
all along the series I need to remove the EXPORT_SYMBOL when I swap the
lookup method.

Thanks

Eric
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
