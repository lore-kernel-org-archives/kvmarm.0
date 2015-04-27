From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [Qemu-devel] [PATCH v2] sysbus: add irq_routing_notifier
Date: Mon, 27 Apr 2015 16:56:05 +0200
Message-ID: <553E4E05.1010405@linaro.org>
References: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>	<CAEgOgz5rBLZD1U0iodZvytb_RYjH7a04attgZxZ-WbuFOkPxpA@mail.gmail.com>	<553DF2AA.2070102@linaro.org>	<553E11E7.7070704@redhat.com>	<553E297F.4020706@linaro.org>	<553E3B7E.9080009@redhat.com>
 <CAEgOgz6eFLhkwm7qto=j=p3L5+cz5s_McUyZUcqeN265CgXSdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 557CF4E9B5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 10:50:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4mWF44GWHf3O for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2015 10:50:21 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A3F64E971
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 10:50:20 -0400 (EDT)
Received: by wizk4 with SMTP id k4so103075355wiz.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 07:58:44 -0700 (PDT)
In-Reply-To: <CAEgOgz6eFLhkwm7qto=j=p3L5+cz5s_McUyZUcqeN265CgXSdg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Crosthwaite <peter.crosthwaite@xilinx.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Patch Tracking <patches@linaro.org>, eric.auger@st.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/27/2015 04:39 PM, Peter Crosthwaite wrote:
> On Mon, Apr 27, 2015 at 6:37 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>>
>> On 27/04/2015 14:20, Eric Auger wrote:
>>> On 04/27/2015 12:39 PM, Paolo Bonzini wrote:
>>>>
>>>>
>>>> On 27/04/2015 10:26, Eric Auger wrote:
>>>>>>> One of my long term goals is to try and get rid of sysbus IRQ
>>>>>>> abstraction completely in favor of just qdev gpios. This means
>>>>>>> features that apply to GPIOs automatically apply to IRQs and vice
>>>>>>> versa. Can your notifier hook be pushed up to the qdev GPIO level to
>>>>>>> make it more globally usable and avoid a new feature to sysbus IRQs?
>>>>> Yes sure, I am going to put the notifier in DeviceClass then.
>>>>
>>>> I've thought too about this, and I'm not sure about it.
>>>>
>>>> It would mean you have to pass the gpio name (e.g.
>>>> SYSBUS_DEVICE_GPIO_IRQ) to the hook, and in the case of sysbus IRQs this
>>>> would leak the SYSBUS_DEVICE_GPIO_IRQ abstraction to the implementors of
>>>> the hook.
> 
> That's OK IMO. SYSBUS_DEVICE_GPIO_IRQ was never intended to be
> private. The semantics of it are something like "If you don't have
> anything better to name your IRQ pin use this".
> 
> This adds the requirement on machine level code that you can't
> consistently use sysbus_connect_irq for intc connection. But machines
> should be able to connect any wires between any cores without having
> to special case interrupts or chip-selects, resets or whatever. So the
> name of the GPIO has to be exposed to the callback hook registration
> if we want to break down this GPIO special casing. Names of interrupt
> pins are system-level knowledge so I think this is all OK.
> 
>>> Hi Paolo,
>>>
>>> Currently my notifier has the following proto:
>>>     void (*connect_gpio_out_notifier)(DeviceState *dev, qemu_irq irq);
>>>
>>> It is sufficient for my need.
>>>
>>> is it really mandated to pass other qdev_connect_gpio_out_named args,
>>> ie. name & n?
>>
>> It's an ugly situation.  If you look at qdev_connect_gpio_out_named, it
>> is really a thin wrapper around object_property_set_link.  Just like
>> Peter wasn't too happy with changing sysbus_connect_irq, the same
>> objection would apply here.  Callers of object_property_set_link should
>> call the notifiers, not just those that use qdev_connect_gpio_out_named.
>>
>> This is why I originally asked you to look into using the check callback
>> instead.
>>
> 
> Is this still feasible? Pushing it up to the higher again to the QOM
> level? I think this would be an ideal backend to the problem even if
> we still go with a code-friendly sysbus frontend.

Peter, Paolo,

After your feedbacks, I feel I need to spend some more time on the
original check() track. I would prefer not to introduce any patch that
will make issue in the future.

Thanks

Eric

> 
> Regards,
> Peter
> 
>> This is why I think it's better to keep the sysbus patch.
>>
>> Paolo
>>
