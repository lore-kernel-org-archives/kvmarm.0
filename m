From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 0/2] irq: add get_gsi callback
Date: Fri, 24 Apr 2015 11:18:05 +0200
Message-ID: <553A0A4D.905@linaro.org>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
 <5538BBD3.9040404@redhat.com> <5538BE19.6030009@linaro.org>
 <5538C246.20304@redhat.com> <553A0657.6050100@linaro.org>
 <553A08D3.3020609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C18A74E648
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 05:12:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rqqpHjanjGSL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2015 05:12:27 -0400 (EDT)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CB404E643
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 05:12:27 -0400 (EDT)
Received: by wgso17 with SMTP id o17so44214171wgs.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 02:20:42 -0700 (PDT)
In-Reply-To: <553A08D3.3020609@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/24/2015 11:11 AM, Paolo Bonzini wrote:
> 
> 
> On 24/04/2015 11:01, Eric Auger wrote:
>>>> void sysbus_init_irq(SysBusDevice *dev, qemu_irq *p)
>>>> {
>>>>     SysBusDeviceClass *sdc = SYSBUS_DEVICE_GET_CLASS(dev);
>>>>     qdev_init_gpio_out_named(DEVICE(dev), p, SYSBUS_DEVICE_GPIO_IRQ, 1,
>>>>                              sdc->irq_set_hook);
>>>> }
>> Hi Paolo
>>
>> I implemented this alternative but my concern is the check method is
>> called before the qemu_irq setting. So on this callback I cannot
>> retrieve the qemu_irq VFIOINTp struct container object needed to setup
>> irqfd hence does not work for me.
> 
> Isn't the qemu_irq passed as the third argument to the callback?  I
> thought this solution was fine because you weren't passing the "int n"
> from sysbus_connect_irq to your notifier.
Yes it is. But I need to access the EventNotifiers for trigger &
resample which were initialized before for eventfd trigger and stored in
the container object. Will study if I can restructure the code ...

Thanks

Eric

> 
> If you really cannot make it work, I guess your "sysbus: add
> irq_routing_notifier" patch would be okay.  I would only ask you to move
> the function pointer from SysBusDevice to SysBusDeviceClass.
> 
> Thanks,
> 
> Paolo
> 
>> I would need a post_check cb. Do you
>> think it it sensible to add another cb?
