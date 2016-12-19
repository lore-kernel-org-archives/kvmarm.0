From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v8 04/16] MSI-X: update GSI routing after changed MSI-X
 configuration
Date: Mon, 19 Dec 2016 18:44:33 +0000
Message-ID: <db8ea8bd-499f-bac5-6ac9-47ceaa469de3@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
 <20161104173203.21168-5-andre.przywara@arm.com>
 <da4e554a-ebd1-fa59-3e94-0e0190ddade3@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D12240295
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2016 13:42:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qECCumIssXTH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2016 13:42:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B2F44028D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2016 13:42:20 -0500 (EST)
In-Reply-To: <da4e554a-ebd1-fa59-3e94-0e0190ddade3@arm.com>
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

Hi,

On 09/12/16 17:13, Marc Zyngier wrote:
> On 04/11/16 17:31, Andre Przywara wrote:
>> When we set up GSI routing to map MSIs to KVM's GSI numbers, we
>> write the current device's MSI setup into the kernel routing table.
>> However the device driver in the guest can use PCI configuration space
>> accesses to change the MSI configuration (address and/or payload data).
>> Whenever this happens after we have setup the routing table already,
>> we must amend the previously sent data.
>> So when MSI-X PCI config space accesses write address or payload,
>> find the associated GSI number and the matching routing table entry
>> and update the kernel routing table (only if the data has changed).
>>
>> This fixes vhost-net, where the queue's IRQFD was setup before the
>> MSI vectors.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  include/kvm/irq.h |  1 +
>>  irq.c             | 31 +++++++++++++++++++++++++++++++
>>  virtio/pci.c      | 36 +++++++++++++++++++++++++++++++++---
>>  3 files changed, 65 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/kvm/irq.h b/include/kvm/irq.h
>> index bb71521..f35eb7e 100644
>> --- a/include/kvm/irq.h
>> +++ b/include/kvm/irq.h
>> @@ -21,5 +21,6 @@ int irq__exit(struct kvm *kvm);
>>  
>>  int irq__allocate_routing_entry(void);
>>  int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg);
>> +void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg);
>>  
>>  #endif
>> diff --git a/irq.c b/irq.c
>> index a742aa2..895e5eb 100644
>> --- a/irq.c
>> +++ b/irq.c
>> @@ -93,6 +93,37 @@ int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
>>  	return next_gsi++;
>>  }
>>  
>> +static bool update_data(u32 *ptr, u32 newdata)
>> +{
>> +	if (*ptr == newdata)
>> +		return false;
>> +
>> +	*ptr = newdata;
>> +	return true;
>> +}
>> +
>> +void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg)
>> +{
>> +	struct kvm_irq_routing_msi *entry;
>> +	unsigned int i;
>> +	bool changed;
>> +
>> +	for (i = 0; i < irq_routing->nr; i++)
>> +		if (gsi == irq_routing->entries[i].gsi)
>> +			break;
>> +	if (i == irq_routing->nr)
>> +		return;
>> +
>> +	entry = &irq_routing->entries[i].u.msi;
>> +
>> +	changed  = update_data(&entry->address_hi, msg->address_hi);
>> +	changed |= update_data(&entry->address_lo, msg->address_lo);
>> +	changed |= update_data(&entry->data, msg->data);
>> +
>> +	if (changed)
>> +		ioctl(kvm->vm_fd, KVM_SET_GSI_ROUTING, irq_routing);
> 
> Check the return value and let the caller know if something has failed?

As the caller is a void function and the call chain for this originates
in an MMIO access triggered by the guest (update MSI information in the
PCI config space), I guess again die() would be the appropriate action here?

> 
>> +}
>> +
>>  int __attribute__((weak)) irq__exit(struct kvm *kvm)
>>  {
>>  	free(irq_routing);
>> diff --git a/virtio/pci.c b/virtio/pci.c
>> index 072e5b7..b3b4aac 100644
>> --- a/virtio/pci.c
>> +++ b/virtio/pci.c
>> @@ -152,6 +152,30 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 p
>>  	return ret;
>>  }
>>  
>> +static void update_msix_map(struct virtio_pci *vpci,
>> +			    struct msix_table *msix_entry, u32 vecnum)
>> +{
>> +	u32 gsi, i;
>> +
>> +	/* Find the GSI number used for that vector */
>> +	if (vecnum == vpci->config_vector) {
>> +		gsi = vpci->config_gsi;
>> +	} else {
>> +		for (i = 0; i < VIRTIO_PCI_MAX_VQ; i++)
>> +			if (vpci->vq_vector[i] == vecnum)
>> +				break;
>> +		if (i == VIRTIO_PCI_MAX_VQ)
>> +			return;
>> +		gsi = vpci->gsis[i];
>> +	}
>> +
>> +	if (gsi == 0)
>> +		return;
>> +
>> +	msix_entry = &msix_entry[vecnum];
>> +	irq__update_msix_route(vpci->kvm, gsi, &msix_entry->msg);
>> +}
>> +
>>  static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *vdev, u16 port,
>>  					void *data, int size, int offset)
>>  {
>> @@ -270,10 +294,16 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
>>  		offset	= vpci->msix_io_block;
>>  	}
>>  
>> -	if (is_write)
>> -		memcpy(table + addr - offset, data, len);
>> -	else
>> +	if (!is_write) {
>>  		memcpy(data, table + addr - offset, len);
>> +		return;
>> +	}
>> +
>> +	memcpy(table + addr - offset, data, len);
>> +
>> +	/* Did we just update the address or payload? */
>> +	if (addr % 0x10 < 0xc)
>> +		update_msix_map(vpci, table, (addr - offset) / 16);
> 
> Where are these constants coming from? Please stick to either decimal or
> hex...

Sure, seems to be a leftover from my initial hacking approach. Thanks
for spotting that.

Cheers,
Andre.

> 
>>  }
>>  
>>  static void virtio_pci__signal_msi(struct kvm *kvm, struct virtio_pci *vpci, int vec)
>>
> 
> Thanks,
> 
> 	M.
> 
