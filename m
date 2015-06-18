From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] kvmtool: don't use PCI config space IRQ line field
Date: Thu, 18 Jun 2015 18:19:53 +0100
Message-ID: <5582FDB9.3020700@arm.com>
References: <1433431245-23227-1-git-send-email-andre.przywara@arm.com>
 <20150605164158.GL7420@arm.com> <557EACD2.1030500@arm.com>
 <20150616170657.GO30522@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 138AE55FE4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 13:08:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X-Iw38C2O7Xn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 13:08:56 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91D8955FE2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 13:08:55 -0400 (EDT)
In-Reply-To: <20150616170657.GO30522@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: "penberg@kernel.org" <penberg@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 06/16/2015 06:06 PM, Will Deacon wrote:
> On Mon, Jun 15, 2015 at 11:45:38AM +0100, Andre Przywara wrote:
>> On 06/05/2015 05:41 PM, Will Deacon wrote:
>>> On Thu, Jun 04, 2015 at 04:20:45PM +0100, Andre Przywara wrote:
>>>> In PCI config space there is an interrupt line field (offset 0x3f),
>>>> which is used to initially communicate the IRQ line number from
>>>> firmware to the OS. _Hardware_ should never use this information,
>>>> as the OS is free to write any information in there.
>>>> But kvmtool uses this number when it triggers IRQs in the guest,
>>>> which fails starting with Linux 3.19-rc1, where the PCI layer starts
>>>> writing the virtual IRQ number in there.
>>>>
>>>> Fix that by storing the IRQ number in a separate field in
>>>> struct virtio_pci, which is independent from the PCI config space
>>>> and cannot be influenced by the guest.
>>>> This fixes ARM/ARM64 guests using PCI with newer kernels.
>>>>
>>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>>> ---
>>>>  include/kvm/virtio-pci.h | 8 ++++++++
>>>>  virtio/pci.c             | 9 ++++++---
>>>>  2 files changed, 14 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
>>>> index c795ce7..b70cadd 100644
>>>> --- a/include/kvm/virtio-pci.h
>>>> +++ b/include/kvm/virtio-pci.h
>>>> @@ -30,6 +30,14 @@ struct virtio_pci {
>>>>  	u8			isr;
>>>>  	u32			features;
>>>>  
>>>> +	/*
>>>> +	 * We cannot rely on the INTERRUPT_LINE byte in the config space once
>>>> +	 * we have run guest code, as the OS is allowed to use that field
>>>> +	 * as a scratch pad to communicate between driver and PCI layer.
>>>> +	 * So store our legacy interrupt line number in here for internal use.
>>>> +	 */
>>>> +	u8			legacy_irq_line;
>>>> +
>>>>  	/* MSI-X */
>>>>  	u16			config_vector;
>>>>  	u32			config_gsi;
>>>> diff --git a/virtio/pci.c b/virtio/pci.c
>>>> index 7556239..e17e5a9 100644
>>>> --- a/virtio/pci.c
>>>> +++ b/virtio/pci.c
>>>> @@ -141,7 +141,7 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 p
>>>>  		break;
>>>>  	case VIRTIO_PCI_ISR:
>>>>  		ioport__write8(data, vpci->isr);
>>>> -		kvm__irq_line(kvm, vpci->pci_hdr.irq_line, VIRTIO_IRQ_LOW);
>>>> +		kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_LOW);
>>>>  		vpci->isr = VIRTIO_IRQ_LOW;
>>>>  		break;
>>>>  	default:
>>>> @@ -299,7 +299,7 @@ int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
>>>>  			kvm__irq_trigger(kvm, vpci->gsis[vq]);
>>>>  	} else {
>>>>  		vpci->isr = VIRTIO_IRQ_HIGH;
>>>> -		kvm__irq_trigger(kvm, vpci->pci_hdr.irq_line);
>>>> +		kvm__irq_trigger(kvm, vpci->legacy_irq_line);
>>>>  	}
>>>>  	return 0;
>>>>  }
>>>> @@ -323,7 +323,7 @@ int virtio_pci__signal_config(struct kvm *kvm, struct virtio_device *vdev)
>>>>  			kvm__irq_trigger(kvm, vpci->config_gsi);
>>>>  	} else {
>>>>  		vpci->isr = VIRTIO_PCI_ISR_CONFIG;
>>>> -		kvm__irq_trigger(kvm, vpci->pci_hdr.irq_line);
>>>> +		kvm__irq_trigger(kvm, vpci->legacy_irq_line);
>>>>  	}
>>>>  
>>>>  	return 0;
>>>> @@ -422,6 +422,9 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>>>  	if (r < 0)
>>>>  		goto free_msix_mmio;
>>>>  
>>>> +	/* save the IRQ that device__register() has allocated */
>>>> +	vpci->legacy_irq_line = vpci->pci_hdr.irq_line;
>>>
>>> I'd rather we used the container_of trick that we do for virtio-mmio
>>> devices when assigning the irq in device__register. Then we can avoid
>>> this line completely.
>>
>> Not completely sure I get what you mean, I take it you want to assign
>> legacy_irq_line in pci__assign_irq() directly (where the IRQ number is
>> allocated).
>> But this function is PCI generic code and is used by the VESA
>> framebuffer and the shmem device on x86 as well. For those devices
>> dev_hdr is not part of a struct virtio_pci, so we can't do container_of
>> to assign the legacy_irq_line here directly.
>> Admittedly this fix should apply to the other two users as well, but
>> VESA does not use interrupts and pci-shmem is completely broken anyway,
>> so I didn't bother to fix it in this regard.
>> Would it be justified to provide an IRQ number field in struct
>> device_header to address all users?
>>
>> Or what am I missing here?
> 
> If VESA and shmem are broken, they should either be fixed or removed.

I am tempted to remove shmem, since it's broken:
a) there is no upstream driver, only some out-of-tree uio driver module
in some Github repo
b) the PCI device BARs do not match what QEMU implements and what the
uio driver expects (IO BAR vs. MMIO BAR)
c) there is (at least one) bug in kvmtool (easily fixed, though)
I haven't completely given up yet fixing it, but that's for another
series ;-)

However ...

> 
> If you fix them, then we could have separate virtual buses for virtio-pci
> and emulated-pci (or whatever you want to call it). We could also have
> a separate bus for passthrough-devices too.
> 
> However, that's quite a lot of work for a bug-fix, so I guess the easiest
> thing is to extend your current hack to cover VESA and shmem too.

So looking more closely, shmem does not support legacy interrupts, only
MSIs. VESA does not support any interrupts at all.
So there is nothing to do here, as the only legacy PCI interrupt user is
virtio, which this patch fixes.
Do you insist on that container_of trick you mentioned earlier? If yes,
please elaborate on that, as I don't see how this should work and how it
could possibly be better (pci__assign_irq() is still generic).

Cheers,
Andre.
