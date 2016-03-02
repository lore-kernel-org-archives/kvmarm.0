From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/3] MSI-X: update GSI routing after changed MSI-X
 configuration
Date: Wed, 2 Mar 2016 01:16:10 +0000
Message-ID: <20160302011610.GE14022@arm.com>
References: <1456850978-14091-1-git-send-email-andre.przywara@arm.com>
 <1456850978-14091-3-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1719410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 20:08:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sPXghqA1K1rg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 20:08:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08CF0411BE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 20:08:50 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1456850978-14091-3-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <sasha.levin@oracle.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 01, 2016 at 04:49:37PM +0000, Andre Przywara wrote:
> When we set up GSI routing to map MSIs to KVM's GSI numbers, we
> write the current device's MSI setup into the kernel routing table.
> However the device driver in the guest can use PCI configuration space
> accesses to change the MSI configuration (address and/or payload data).
> Whenever this happens after we have setup the routing table already,
> we must amend the previously sent data.
> So when MSI-X PCI config space accesses write address or payload,
> find the associated GSI number and the matching routing table entry
> and update the kernel routing table (only if the data has changed).
> 
> This fixes vhost-net, where the queue's IRQFD was setup before the
> MSI vectors.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/irq.h |  1 +
>  irq.c             | 31 +++++++++++++++++++++++++++++++
>  virtio/pci.c      | 36 +++++++++++++++++++++++++++++++++---
>  3 files changed, 65 insertions(+), 3 deletions(-)
> 
> diff --git a/include/kvm/irq.h b/include/kvm/irq.h
> index bb71521..f35eb7e 100644
> --- a/include/kvm/irq.h
> +++ b/include/kvm/irq.h
> @@ -21,5 +21,6 @@ int irq__exit(struct kvm *kvm);
>  
>  int irq__allocate_routing_entry(void);
>  int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg);
> +void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg);
>  
>  #endif
> diff --git a/irq.c b/irq.c
> index 1aee478..25ac8d7 100644
> --- a/irq.c
> +++ b/irq.c
> @@ -89,6 +89,37 @@ int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
>  	return next_gsi++;
>  }
>  
> +static bool update_data(u32 *ptr, u32 newdata)
> +{
> +	if (*ptr == newdata)
> +		return false;
> +
> +	*ptr = newdata;
> +	return true;
> +}
> +
> +void irq__update_msix_route(struct kvm *kvm, u32 gsi, struct msi_msg *msg)
> +{
> +	struct kvm_irq_routing_msi *entry;
> +	unsigned int i;
> +	bool changed;
> +
> +	for (i = 0; i < irq_routing->nr; i++)
> +		if (gsi == irq_routing->entries[i].gsi)
> +			break;
> +	if (i == irq_routing->nr)
> +		return;
> +
> +	entry = &irq_routing->entries[i].u.msi;
> +
> +	changed  = update_data(&entry->address_hi, msg->address_hi);
> +	changed |= update_data(&entry->address_lo, msg->address_lo);
> +	changed |= update_data(&entry->data, msg->data);
> +
> +	if (changed)
> +		ioctl(kvm->vm_fd, KVM_SET_GSI_ROUTING, irq_routing);
> +}

What goes wrong if you just call the ioctl every time? Is this actually
a fast path in practice?

Will
