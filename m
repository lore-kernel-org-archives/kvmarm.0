From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 0/2] irq: add get_gsi callback
Date: Fri, 24 Apr 2015 11:01:11 +0200
Message-ID: <553A0657.6050100@linaro.org>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
 <5538BBD3.9040404@redhat.com> <5538BE19.6030009@linaro.org>
 <5538C246.20304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 624CA4E638
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 04:55:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EC5P1RWEjiM0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2015 04:55:34 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D86E4E634
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 04:55:33 -0400 (EDT)
Received: by wiun10 with SMTP id n10so12784737wiu.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 02:03:48 -0700 (PDT)
In-Reply-To: <5538C246.20304@redhat.com>
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

On 04/23/2015 11:58 AM, Paolo Bonzini wrote:
> 
> 
> On 23/04/2015 11:40, Eric Auger wrote:
>>>> Why can't you just use a GHashTable?
>> You mean implementing this hash table in the interrupt controller?
> 
> No, in KVM.  Basically the kvm-vgic interrupt controller registers its 
> qemu_irqs with kvm-all.c, passing the gsi number for KVM_IRQFD along 
> the way.  Then VFIO device can pass the qemu_irq and ask for an irqfd 
> for that qemu_irq, instead of having to know the gsi number.  kvm-all.c
> acts as a mediator.
> 
> The notifier actually is not even necessary, because we already have
> a very similar concept in QOM.  But qdev_init_gpio_out_named always
> passes a dummy "notifier":
> 
> void qdev_init_gpio_out_named(DeviceState *dev, qemu_irq *pins,
>                               const char *name, int n)
> {
>     int i;
>     NamedGPIOList *gpio_list = qdev_get_named_gpio_list(dev, name);
>     char *propname = g_strdup_printf("%s[*]", name ? name : "unnamed-gpio-out");
> 
>     assert(gpio_list->num_in == 0 || !name);
>     gpio_list->num_out += n;
> 
>     for (i = 0; i < n; ++i) {
>         memset(&pins[i], 0, sizeof(*pins));
>         object_property_add_link(OBJECT(dev), propname, TYPE_IRQ,
>                                  (Object **)&pins[i],
>                                  object_property_allow_set_link,
>                                  OBJ_PROP_LINK_UNREF_ON_RELEASE,
>                                  &error_abort);
>     } 
>     g_free(propname);
> }
> 
> So you need to add a method to DeviceClass, with the same prototype
> as object_property_allow_set_link, and set the default value to
> object_property_allow_set_link in device_class_init.  Then
> qdev_init_gpio_out_named can do
> 
>     DeviceClass *dc = DEVICE_GET_CLASS(dev);
>     ...
>         object_property_add_link(OBJECT(dev), propname, TYPE_IRQ,
>                                  (Object **)&pins[i],
>                                  dc->gpio_set_hook,
>                                  OBJ_PROP_LINK_UNREF_ON_RELEASE,
>                                  &error_abort);
> 
> or something like that.
> 
> Alternatively, and probably better, add the argument to
> qdev_init_gpio_out_named; there aren't many calls.  Then
> you can add the method only to SysbusDeviceClass rather than
> to all devices, and you can change sysbus_init_irq like this:
> 
> void sysbus_init_irq(SysBusDevice *dev, qemu_irq *p)
> {
>     SysBusDeviceClass *sdc = SYSBUS_DEVICE_GET_CLASS(dev);
>     qdev_init_gpio_out_named(DEVICE(dev), p, SYSBUS_DEVICE_GPIO_IRQ, 1,
>                              sdc->irq_set_hook);
> }

Hi Paolo

I implemented this alternative but my concern is the check method is
called before the qemu_irq setting. So on this callback I cannot
retrieve the qemu_irq VFIOINTp struct container object needed to setup
irqfd hence does not work for me. I would need a post_check cb. Do you
think it it sensible to add another cb?

Thanks

Eric
> 
> 
> Paolo
> 
>> The problem is my VFIO device currently has no link to the interrupt
>> controller object. Besides it has a platform bus in between. Previously
>> I devised a reset notifier called in the machine file to pass this link
>> but Alex was not keen about this method. So the idea here is when the
>> VFIO sysbus device qemuirq is getting connected, a notifier is called,
>> VFIO device can retrieve the gsi of this qemu_irq and call KVM_IRQFD
>> with that gsi.
