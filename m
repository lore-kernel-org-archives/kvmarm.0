From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH] VFIO: platform: AMD xgbe reset module
Date: Thu, 15 Oct 2015 16:46:09 +0200
Message-ID: <561FBC31.3020900@linaro.org>
References: <1444836792-2405-1-git-send-email-eric.auger@linaro.org>
 <7287273.XGFpHqQ9fN@wuerfel> <20151015121228.GA965@cbox>
 <5270338.MbsQ1bGczu@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79C4341252
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 10:43:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id skSFJKi4Iyjz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 10:43:52 -0400 (EDT)
Received: from mail-qk0-f181.google.com (mail-qk0-f181.google.com
 [209.85.220.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CC8440FA6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 10:43:52 -0400 (EDT)
Received: by qkap81 with SMTP id p81so38798101qka.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 07:46:11 -0700 (PDT)
In-Reply-To: <5270338.MbsQ1bGczu@wuerfel>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: thomas.lendacky@amd.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, suravee.suthikulpanit@amd.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Arnd,
On 10/15/2015 03:59 PM, Arnd Bergmann wrote:
> On Thursday 15 October 2015 14:12:28 Christoffer Dall wrote:
>>>
>>> enum vfio_platform_op {
>>>       VFIO_PLATFORM_BIND,
>>>       VFIO_PLATFORM_UNBIND,
>>>       VFIO_PLATFORM_RESET,
>>> };
>>>
>>> struct platform_driver {
>>>         int (*probe)(struct platform_device *);
>>>         int (*remove)(struct platform_device *);
>>>       ...
>>>       int (*vfio_manage)(struct platform_device *, enum vfio_platform_op);
>>>         struct device_driver driver;
>>> };
>>>
>>> This would integrate much more closely into the platform driver framework,
>>> just like the regular vfio driver integrates into the PCI framework.
>>> Unlike PCI however, you can't just use the generic driver framework to
>>> unbind the driver, because you still need device specific code.
>>>
>> Thanks for these suggestions, really helpful.
>>
>> What I don't understand in the latter example is how VFIO knows which
>> struct platform_driver to interact with?
> 
> This would assume that the driver remains bound to the device, so VFIO
> gets a pointer to the device from somewhere (as it does today) and then
> follows the dev->driver pointer to get to the platform_driver.

>  
>> Also, just so I'm sure I understand correctly, VFIO_PLATFORM_UNBIND is
>> then called by VFIO before the VFIO driver unbinds from the device
>> (unbinding the platform driver from the device being a completely
>> separate thing)?
> 
> This is where we'd need a little more changes for this approach. Instead
> of unbinding the device from its driver, the idea would be that the
> driver remains bound as far as the driver model is concerned, but
> it would be in a quiescent state where no other subsystem interacts with
> it (i.e. it gets unregistered from networking core or whichever it uses).

Currently we use the same mechanism as for PCI, ie. unbind the native
driver and then bind VFIO platform driver in its place. Don't you think
changing this may be a pain for user-space tools that are designed to
work that way for PCI?

My personal preference would be to start with your first proposal since
it looks (to me) less complex and "unknown" that the 2d approach.

Let's wait for Alex opinion too...

Thanks again

Eric




> 
> 	Arnd
> 
