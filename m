From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] irq: add get_gsi callback
Date: Fri, 24 Apr 2015 11:11:47 +0200
Message-ID: <553A08D3.3020609@redhat.com>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
 <5538BBD3.9040404@redhat.com> <5538BE19.6030009@linaro.org>
 <5538C246.20304@redhat.com> <553A0657.6050100@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01DF44E641
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 05:03:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6yFROxJeC1cj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2015 05:03:37 -0400 (EDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAE254E640
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 05:03:36 -0400 (EDT)
Received: by wgyo15 with SMTP id o15so43888784wgy.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 02:11:51 -0700 (PDT)
In-Reply-To: <553A0657.6050100@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 24/04/2015 11:01, Eric Auger wrote:
>> > void sysbus_init_irq(SysBusDevice *dev, qemu_irq *p)
>> > {
>> >     SysBusDeviceClass *sdc = SYSBUS_DEVICE_GET_CLASS(dev);
>> >     qdev_init_gpio_out_named(DEVICE(dev), p, SYSBUS_DEVICE_GPIO_IRQ, 1,
>> >                              sdc->irq_set_hook);
>> > }
> Hi Paolo
> 
> I implemented this alternative but my concern is the check method is
> called before the qemu_irq setting. So on this callback I cannot
> retrieve the qemu_irq VFIOINTp struct container object needed to setup
> irqfd hence does not work for me.

Isn't the qemu_irq passed as the third argument to the callback?  I
thought this solution was fine because you weren't passing the "int n"
from sysbus_connect_irq to your notifier.

If you really cannot make it work, I guess your "sysbus: add
irq_routing_notifier" patch would be okay.  I would only ask you to move
the function pointer from SysBusDevice to SysBusDeviceClass.

Thanks,

Paolo

> I would need a post_check cb. Do you
> think it it sensible to add another cb?
