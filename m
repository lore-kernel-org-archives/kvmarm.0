From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 05/10] VFIO: pci: Introduce direct EOI INTx interrupt
 handler
Date: Fri, 2 Jun 2017 09:41:34 +0100
Message-ID: <4dc0ca5e-cd73-944b-77b4-6822c5289348@arm.com>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
 <1495656803-28011-6-git-send-email-eric.auger@redhat.com>
 <20170531122419.07e3f26d@w520.home>
 <ba7d07c1-4349-5c24-ec19-d372ade25432@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B75BD40C50
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 04:37:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FVzJci7xvohx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jun 2017 04:37:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39BF940BD8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 04:37:40 -0400 (EDT)
In-Reply-To: <ba7d07c1-4349-5c24-ec19-d372ade25432@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On 01/06/17 21:40, Auger Eric wrote:
> Hi Alex,
> 
> On 31/05/2017 20:24, Alex Williamson wrote:
>> On Wed, 24 May 2017 22:13:18 +0200
>> Eric Auger <eric.auger@redhat.com> wrote:
>>
>>> We add two new fields in vfio_pci_irq_ctx struct: deoi and handler.
>>> If deoi is set, this means the physical IRQ attached to the virtual
>>> IRQ is directly deactivated by the guest and the VFIO driver does
>>> not need to disable the physical IRQ and mask it at VFIO level.
>>>
>>> The handler pointer is set accordingly and a wrapper handler is
>>> introduced that calls the chosen handler function.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>
>>> ---
>>> ---
>>>  drivers/vfio/pci/vfio_pci_intrs.c   | 32 ++++++++++++++++++++++++++------
>>>  drivers/vfio/pci/vfio_pci_private.h |  2 ++
>>>  2 files changed, 28 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
>>> index d4d377b..06aa713 100644
>>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>>> @@ -121,11 +121,8 @@ void vfio_pci_intx_unmask(struct vfio_pci_device *vdev)
>>>  static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
>>>  {
>>>  	struct vfio_pci_device *vdev = dev_id;
>>> -	unsigned long flags;
>>>  	int ret = IRQ_NONE;
>>>  
>>> -	spin_lock_irqsave(&vdev->irqlock, flags);
>>> -
>>>  	if (!vdev->pci_2_3) {
>>>  		disable_irq_nosync(vdev->pdev->irq);
>>>  		vdev->ctx[0].automasked = true;
>>> @@ -137,14 +134,33 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
>>>  		ret = IRQ_HANDLED;
>>>  	}
>>>  
>>> -	spin_unlock_irqrestore(&vdev->irqlock, flags);
>>> -
>>>  	if (ret == IRQ_HANDLED)
>>>  		vfio_send_intx_eventfd(vdev, NULL);
>>>  
>>>  	return ret;
>>>  }
>>>  
>>> +static irqreturn_t vfio_intx_handler_deoi(int irq, void *dev_id)
>>> +{
>>> +	struct vfio_pci_device *vdev = dev_id;
>>> +
>>> +	vfio_send_intx_eventfd(vdev, NULL);
>>> +	return IRQ_HANDLED;
>>> +}
>>> +
>>> +static irqreturn_t vfio_intx_wrapper_handler(int irq, void *dev_id)
>>> +{
>>> +	struct vfio_pci_device *vdev = dev_id;
>>> +	unsigned long flags;
>>> +	irqreturn_t ret;
>>> +
>>> +	spin_lock_irqsave(&vdev->irqlock, flags);
>>> +	ret = vdev->ctx[0].handler(irq, dev_id);
>>> +	spin_unlock_irqrestore(&vdev->irqlock, flags);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>>  static int vfio_intx_enable(struct vfio_pci_device *vdev)
>>>  {
>>>  	if (!is_irq_none(vdev))
>>> @@ -208,7 +224,11 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
>>>  	if (!vdev->pci_2_3)
>>>  		irqflags = 0;
>>>  
>>> -	ret = request_irq(pdev->irq, vfio_intx_handler,
>>> +	if (vdev->ctx[0].deoi)
>>> +		vdev->ctx[0].handler = vfio_intx_handler_deoi;
>>> +	else
>>> +		vdev->ctx[0].handler = vfio_intx_handler;
>>> +	ret = request_irq(pdev->irq, vfio_intx_wrapper_handler,
>>>  			  irqflags, vdev->ctx[0].name, vdev);
>>
>>
>> Here's where I think we don't account for irqflags properly.  If we get
>> a shared interrupt here, then enabling direct EOI needs to be disabled
>> or else we'll starve other devices sharing the interrupt.  In practice,
>> I wonder if this makes PCI direct EOI a useful feature.  We could try
>> to get an exclusive interrupt and fallback to shared, but any time we
>> get an exclusive interrupt we're more prone to conflicts with other
>> devices.  I might have two VMs that share an interrupt and now it's a
>> race that only the first to setup an IRQ can work.  Worse, one of those
>> VMs might be fully booted and switched to MSI and now it's just a
>> matter of time until they reboot in the right way to generate a
>> conflict.  I might also have two devices in the same VM that share an
>> IRQ and now I can't start the VM at all because the second device can
>> no longer get an interrupt.  This is the same problem we have with the
>> nointxmask flag, it's a useful debugging feature but since the masking
>> is done at the APIC/GIC rather than the device, much like here, it's not
>> very practical for more than debugging and isolating specific devices
>> as requiring APIC/GIC level masking.  I'm not sure how to proceed on the
>> PCI side here. Thanks,
> 
> Thanks for the review.
> 
> I share you concerns about shared interrupts. I need to spend some
> additional time reading the VFIO code related to those and that part of
> the PCIe spec too.
> 
> Maybe we shall introduce the IRQ bypass based DEOI setup only for
> platform devices. I know those are not much used at the moment but this
> at least prepares for GICv4 direct injection.

I think that'd be good enough, unless we can ensure that we only engage
the Direct EOI feature when PCI legacy interrupts are not shared. The
system I have here (AMD Seattle) seem to have one set of INTx per PCIe
port, so the above would definitely work on it. But I understand that
there is not a guarantee at all.

Maybe the "nointxmask" flag is not that bad a solution in that case. It
would clearly outline that the user knows the platform is safe, and that
we can use the Direct EOI feature.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
