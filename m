From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v2] sysbus: add irq_routing_notifier
Date: Mon, 27 Apr 2015 15:37:02 +0200
Message-ID: <553E3B7E.9080009@redhat.com>
References: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>
 <CAEgOgz5rBLZD1U0iodZvytb_RYjH7a04attgZxZ-WbuFOkPxpA@mail.gmail.com>
 <553DF2AA.2070102@linaro.org> <553E11E7.7070704@redhat.com>
 <553E297F.4020706@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E49D24E90C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 09:28:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3bPZITe9JOmA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2015 09:28:45 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF8BD4E79A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 09:28:45 -0400 (EDT)
In-Reply-To: <553E297F.4020706@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Alex Williamson <alex.williamson@redhat.com>, eric.auger@st.com, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>, Patch Tracking <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 27/04/2015 14:20, Eric Auger wrote:
> On 04/27/2015 12:39 PM, Paolo Bonzini wrote:
>>
>>
>> On 27/04/2015 10:26, Eric Auger wrote:
>>>>> One of my long term goals is to try and get rid of sysbus IRQ
>>>>> abstraction completely in favor of just qdev gpios. This means
>>>>> features that apply to GPIOs automatically apply to IRQs and vice
>>>>> versa. Can your notifier hook be pushed up to the qdev GPIO level to
>>>>> make it more globally usable and avoid a new feature to sysbus IRQs?
>>> Yes sure, I am going to put the notifier in DeviceClass then.
>>
>> I've thought too about this, and I'm not sure about it.
>>
>> It would mean you have to pass the gpio name (e.g.
>> SYSBUS_DEVICE_GPIO_IRQ) to the hook, and in the case of sysbus IRQs this
>> would leak the SYSBUS_DEVICE_GPIO_IRQ abstraction to the implementors of
>> the hook.
> Hi Paolo,
> 
> Currently my notifier has the following proto:
>     void (*connect_gpio_out_notifier)(DeviceState *dev, qemu_irq irq);
> 
> It is sufficient for my need.
> 
> is it really mandated to pass other qdev_connect_gpio_out_named args,
> ie. name & n?

It's an ugly situation.  If you look at qdev_connect_gpio_out_named, it
is really a thin wrapper around object_property_set_link.  Just like
Peter wasn't too happy with changing sysbus_connect_irq, the same
objection would apply here.  Callers of object_property_set_link should
call the notifiers, not just those that use qdev_connect_gpio_out_named.

This is why I originally asked you to look into using the check callback
instead.

This is why I think it's better to keep the sysbus patch.

Paolo
