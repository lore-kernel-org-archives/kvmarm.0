From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [kvmtool PATCH v9 06/15] PCI: Only allocate IRQ routing entry
 when available
Date: Wed, 29 Mar 2017 21:44:47 +0100
Message-ID: <6371fdda-bdd5-2aa0-de8c-4f97953ee326@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
 <20170202163223.15372-7-andre.przywara@arm.com>
 <d26dea9f-386b-316c-a2b3-d42ea1883997@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52BCF40625
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 16:43:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZkDCWavWIpkL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Mar 2017 16:43:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ED7940019
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Mar 2017 16:43:40 -0400 (EDT)
In-Reply-To: <d26dea9f-386b-316c-a2b3-d42ea1883997@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

thanks for having a look!

On 29/03/17 09:30, Marc Zyngier wrote:
> On 02/02/17 16:32, Andre Przywara wrote:
>> If we need to inject an MSI into the guest, we rely at the moment on a
>> working GSI MSI routing functionality. However we can get away without
>> IRQ routing, if the host supports MSI injection via the KVM_SIGNAL_MSI
>> ioctl.
>> So we try the GSI routing first, but if that fails due to a missing
>> IRQ routing functionality, we fall back to KVM_SIGNAL_MSI (if that is
>> supported).
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virtio/pci.c | 16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/virtio/pci.c b/virtio/pci.c
>> index 7cc0ba4..98bf6b7 100644
>> --- a/virtio/pci.c
>> +++ b/virtio/pci.c
>> @@ -193,8 +193,14 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
>>  
>>  			gsi = irq__add_msix_route(kvm,
>>  						  &vpci->msix_table[vec].msg);
>> -			if (gsi >= 0)
>> +			if (gsi >= 0) {
>>  				vpci->config_gsi = gsi;
>> +				break;
>> +			}
>> +			if (gsi == -ENXIO &&
>> +			    vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
>> +					break;
>> +			die("failed to configure MSIs");
>>  			break;
>>  		case VIRTIO_MSI_QUEUE_VECTOR:
>>  			vec = ioport__read16(data);
>> @@ -205,8 +211,14 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
>>  
>>  			gsi = irq__add_msix_route(kvm,
>>  						  &vpci->msix_table[vec].msg);
>> -			if (gsi < 0)
>> +			if (gsi < 0) {
>> +				if (gsi == -ENXIO &&
>> +				    vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
>> +					break;
>> +
>> +				die("failed to configure MSIs");
>>  				break;
>> +			}
>>  			vpci->gsis[vpci->queue_selector] = gsi;
> 
> Is it really expected to find -ENXIO in this array instead of a GSI?

Not sure I get this "in this array" comment here. Any negative return
value ends up in a break, without writing it anywhere.
Later on we check for VIRTIO_PCI_F_SIGNAL_MSI first before referencing
the array. This is admittedly a bit convoluted.
So shall I add comments here? Or rewrite the if statement to make this
more obvious?

Cheers,
Andre.

> 
>>  			if (vdev->ops->notify_vq_gsi)
>>  				vdev->ops->notify_vq_gsi(kvm, vpci->dev,
>>
> 
> Thanks,
> 
> 	M.
> 
