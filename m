From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH 2/3] MSI-X: update GSI routing after changed MSI-X
 configuration
Date: Wed, 2 Mar 2016 22:20:21 +0000
Message-ID: <56D76725.8090006@arm.com>
References: <1456850978-14091-1-git-send-email-andre.przywara@arm.com>
 <1456850978-14091-3-git-send-email-andre.przywara@arm.com>
 <20160302011610.GE14022@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160302011610.GE14022@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Pekka Enberg <penberg@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 02/03/16 01:16, Will Deacon wrote:
> On Tue, Mar 01, 2016 at 04:49:37PM +0000, Andre Przywara wrote:
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
>> index 1aee478..25ac8d7 100644
>> --- a/irq.c
>> +++ b/irq.c
>> @@ -89,6 +89,37 @@ int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
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
>> +}
> 
> What goes wrong if you just call the ioctl every time? Is this actually
> a fast path in practice?

I guess nothing, it's just a lot of needless churn in the kernel. We
trap on every word access to the MSI data region and I have seen so many
non-updates in there. For instance if the guest updates the 	payload, it
writes the unchanged address parts also and we trap that.
Also please note that this ioctl updates the _whole table_ every time.
If you now look at what virt/kvm/kvm_main.c actually does (kmalloc,
copy_from_user, kmalloc again, update each entry (with kmallocs), RCU
switch over to the new table, free the old table, free, free), I hope
you agree that his little extra code in userland is
surely worth the effort. I had debug messages in the kernel to chase the
bug and the output was huge every time for actually no change at all
most of the times.

Cheers,
Andre.
