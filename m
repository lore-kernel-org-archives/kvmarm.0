From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v12 4/9] hw/vfio/platform: add capability to start IRQ
 propagation
Date: Tue, 21 Apr 2015 13:54:26 +0200
Message-ID: <55363A72.2020309@linaro.org>
References: <1426785402-2091-1-git-send-email-eric.auger@linaro.org>		
 <1426785402-2091-5-git-send-email-eric.auger@linaro.org>	
 <1429221884.10086.38.camel@redhat.com> <55312751.1000506@linaro.org>
 <1429299715.10086.68.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F87A4D356
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2015 07:48:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c7qO0TcXO0eC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Apr 2015 07:48:56 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9FCE4D348
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2015 07:48:55 -0400 (EDT)
Received: by wiax7 with SMTP id x7so105577146wia.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2015 04:57:03 -0700 (PDT)
In-Reply-To: <1429299715.10086.68.camel@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger@st.com, patches@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,
On 04/17/2015 09:41 PM, Alex Williamson wrote:
> On Fri, 2015-04-17 at 17:31 +0200, Eric Auger wrote:
>> Hi Alex,
>> On 04/17/2015 12:04 AM, Alex Williamson wrote:
>>> On Thu, 2015-03-19 at 17:16 +0000, Eric Auger wrote:
>>>> Add a reset notify function that enables to start the propagation of
>>>> interrupts to the guest.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>>
>>>> ---
>>>> v10 -> v11:
>>>> - comment reword
>>>>
>>>> v8 -> v9:
>>>> - handle failure in vfio_irq_starter
>>>> ---
>>>>  hw/vfio/platform.c              | 64 +++++++++++++++++++++++++++++++++++++++++
>>>>  include/hw/vfio/vfio-platform.h |  8 ++++++
>>>>  2 files changed, 72 insertions(+)
>>>>
>>>> diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
>>>> index 31c2701..361e01b 100644
>>>> --- a/hw/vfio/platform.c
>>>> +++ b/hw/vfio/platform.c
>>>> @@ -572,6 +572,70 @@ static void vfio_platform_realize(DeviceState *dev, Error **errp)
>>>>      }
>>>>  }
>>>>  
>>>> +/**
>>>> + * vfio_irq_starter: Start IRQ forwarding for a specific VFIO device
>>>> + * @sbdev: Sysbus device handle
>>>> + * @opaque: DeviceState handle of the interrupt controller the device
>>>> + *          is attached to
>>>> + *
>>>> + * The function retrieves the absolute GSI number each VFIO IRQ
>>>> + * corresponds to and start forwarding.
>>>> + */
>>>
>>> Using "forwarding" here is really making me look for your platform's EOI
>>> trick (IRQ Forwarding), which isn't here.
>> sure
>>>
>>>> +static int vfio_irq_starter(SysBusDevice *sbdev, void *opaque)
>>>> +{
>>>> +    DeviceState *intc = (DeviceState *)opaque;
>>>> +    VFIOPlatformDevice *vdev;
>>>> +    VFIOINTp *intp;
>>>> +    qemu_irq irq;
>>>> +    int gsi, ret;
>>>> +
>>>> +    if (object_dynamic_cast(OBJECT(sbdev), TYPE_VFIO_PLATFORM)) {
>>>> +        vdev = VFIO_PLATFORM_DEVICE(sbdev);
>>>> +
>>>> +        QLIST_FOREACH(intp, &vdev->intp_list, next) {
>>>> +            gsi = 0;
>>>> +            while (1) {
>>>> +                irq = qdev_get_gpio_in(intc, gsi);
>>>> +                if (irq == intp->qemuirq) {
>>>> +                    break;
>>>> +                }
>>>> +                gsi++;
>>>> +            }
>>>
>>> A for() loop would be more compact here, but is there some other exit
>>> condition we can add?  gsi < INT_MAX?
>> Currently I do not see any way to retrieve the number of input GPIOs.
>> This is static in core/qdev.c. either I leave as is or introduce getters.
> 
> Well, INT_MAX is always an option, right? 
yes it is.
 I prefer the way vfio-pci is
> structured where we can ask for the gsi routing via
> pci_device_route_intx_to_irq() rather than searching the entire address
> space.  Can we do something similar on platform to pass in a qemuirq and
> get back a gsi?
I launched a separate thread to find out a solution for qemu_irq to gsi
conversion.

As for the notification mechanism the intx_routing_notifier is part of
the PCIDevice. By analogy this would mean a similar notifier in the
SysBusDevice. I would add a notifier setter in SysbusDevice and call it
on sysbus_connect_irq. This is what I currently think about. I will send
a separate patch and see what happens ... if anyone already is opposed
to that, please let me know ...

>  
>>>> +            intp->virtualID = gsi;
>>>> +            ret = vdev->start_irq_fn(intp);
>>>> +            if (ret) {
>>>> +                error_report("%s unable to start propagation of IRQ index %d",
>>>> +                             vdev->vbasedev.name, intp->pin);
>>>> +                exit(1);
>>>> +            }
>>>> +        }
>>>> +    }
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +/**
>>>> + * vfio_kick_irqs: start IRQ forwarding for all the VFIO devices
>>>> + * attached to the platform bus
>>>> + * @data: Device state handle of the interrupt controller the VFIO IRQs
>>>> + *        must be bound to
>>>> + *
>>>> + * Binding to the platform bus IRQs happens on a machine init done
>>>> + * notifier registered by the platform bus. Only at that time the
>>>> + * absolute virtual IRQ = GSI is known and allows to setup IRQFD.
>>>> + * This function typically can be called in a reset notifier registered
>>>> + * by the machine file.
>>>> + */
>>>
>>> So there's not actually an irqfd setup done here yet and what is
>>> currently done by the above starter function doesn't depend at all on
>>> the GSI.  Do you perhaps want to setup the vfio->eventfd signaling
>>> during your initfn and then only connect the eventfd->irqfd to KVM in
>>> the reset function?  Sort of how vfio-pci does the routing update.
>>
>> Not sure I get what you mean here. In above starter I call start_irq_fn.
>> This latter starts the injection depending on the chosen technique, 1)
>> user side handling, 2) standalone irqfd, 2) irqfd + ARM forwarding.
>> For starting 2) and 3) I actually use the GSI set above by
>> intp->virtualID = gsi;
>> See vfio_start_irqfd_injection.
>>
>> Indeed I noticed in VFIO-PCI you first started eventfd and then irqfd
>> but I thought I did not need to do that. What is the problem starting
>> VFIO signaling on reset (notifier) only? Besides, moving back to 2-step
>> settup would not fix my issue of being able to know the gsi to attach to
>> my irqfd. I need to further investigate this PCI INTx routing notifier...
> 
> vfio-pci effectively has the same issue.  PCI supports supports four
> legacy interrupt lines and we know which of those interrupt lines the
> device uses during the initfn, but we don't know the GSI that the PCI
> line maps to until later.  In our case it's not just system reset, but
> the guest can manipulate the mapping runtime via emulated platform
> chipset registers.  vfio-pci also attempts to handle KVM acceleration as
> optional, enabling userspace signaling first, then augmenting it with an
> irqfd fast path.  We should be able to handle a failure on the
> acceleration path without calling exit() to kill the VM and it would be
> cleaner for the initfn to fail if we can't setup basic signaling via
> eventfd.
> 
> Expecting to be able to configure both basic signaling and acceleration
> at the same time seems to be contributing to this reset notifier hack
> that I'm not a fan of.  vfio-platform could register it's own reset
> notifier, or perhaps a machine_init_done notifier if a path was setup
> where vfio-platform could query the gsi, as I suggest above.  Thanks,

Thanks for those explanation. I do not have any issue with reverting to
the 2 stage setup.

Best Regards

Eric


> 
> Alex
> 
>>>> +void vfio_kick_irqs(void *data)
>>>> +{
>>>> +    DeviceState *intc = (DeviceState *)data;
>>>> +    DeviceState *dev =
>>>> +        qdev_find_recursive(sysbus_get_default(), TYPE_PLATFORM_BUS_DEVICE);
>>>> +    PlatformBusDevice *pbus = PLATFORM_BUS_DEVICE(dev);
>>>> +
>>>> +    assert(pbus->done_gathering);
>>>> +    foreach_dynamic_sysbus_device(vfio_irq_starter, intc);
>>>> +}
>>>> +
>>>>  static const VMStateDescription vfio_platform_vmstate = {
>>>>      .name = TYPE_VFIO_PLATFORM,
>>>>      .unmigratable = 1,
>>>> diff --git a/include/hw/vfio/vfio-platform.h b/include/hw/vfio/vfio-platform.h
>>>> index 31893a3..c9ee898 100644
>>>> --- a/include/hw/vfio/vfio-platform.h
>>>> +++ b/include/hw/vfio/vfio-platform.h
>>>> @@ -77,4 +77,12 @@ typedef struct VFIOPlatformDeviceClass {
>>>>  #define VFIO_PLATFORM_DEVICE_GET_CLASS(obj) \
>>>>       OBJECT_GET_CLASS(VFIOPlatformDeviceClass, (obj), TYPE_VFIO_PLATFORM)
>>>>  
>>>> +/**
>>>> + * vfio_kick_irqs - reset notifier that starts IRQ injection
>>>> + * for all VFIO dynamic sysbus devices attached to the platform bus.
>>>> + *
>>>> + * @opaque: handle to the interrupt controller DeviceState
>>>> + */
>>>> +void vfio_kick_irqs(void *opaque);
>>>> +
>>>>  #endif /*HW_VFIO_VFIO_PLATFORM_H*/
>>>
>>>
>>>
>>
> 
> 
> 
