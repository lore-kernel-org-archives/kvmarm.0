From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v4 07/12] KVM: arm64: add data structures to model ITS
 interrupt translation
Date: Wed, 6 Apr 2016 11:53:47 +0200
Message-ID: <5704DCAB.7040207@linaro.org>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-8-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458958450-19662-8-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/26/2016 03:14 AM, Andre Przywara wrote:
> The GICv3 Interrupt Translation Service (ITS) uses tables in memory
> to allow a sophisticated interrupt routing. It features device tables,
> an interrupt table per device and a table connecting "collections" to
> actual CPUs (aka. redistributors in the GICv3 lingo).
> Since the interrupt numbers for the LPIs are allocated quite sparsely
> and the range can be quite huge (8192 LPIs being the minimum), using
> bitmaps or arrays for storing information is a waste of memory.
> We use linked lists instead, which we iterate linearily. This works
> very well with the actual number of LPIs/MSIs in the guest being
> quite low. Should the number of LPIs exceed the number where iterating
> through lists seems acceptable, we can later revisit this and use more
> efficient data structures.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h      |  3 ++
>  virt/kvm/arm/vgic/its-emul.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index bafea11..ecf3260 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -22,6 +22,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <kvm/iodev.h>
> +#include <linux/list.h>
>  
>  #define VGIC_V3_MAX_CPUS	255
>  #define VGIC_V2_MAX_CPUS	8
> @@ -118,6 +119,8 @@ struct vgic_its {
>  	u64			cbaser;
>  	int			creadr;
>  	int			cwriter;
> +	struct list_head	device_list;
> +	struct list_head	collection_list;
>  };
>  
>  struct vgic_dist {
> diff --git a/virt/kvm/arm/vgic/its-emul.c b/virt/kvm/arm/vgic/its-emul.c
> index de8d360..c0334ff 100644
> --- a/virt/kvm/arm/vgic/its-emul.c
> +++ b/virt/kvm/arm/vgic/its-emul.c
> @@ -21,6 +21,7 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
> +#include <linux/list.h>
>  
>  #include <linux/irqchip/arm-gic-v3.h>
>  
> @@ -31,6 +32,34 @@
>  #include "vgic.h"
>  #include "vgic_mmio.h"
>  
> +struct its_device {
> +	struct list_head dev_list;
> +
> +	/* the head for the list of ITTEs */
> +	struct list_head itt;
> +	u32 device_id;
> +};
> +
> +#define COLLECTION_NOT_MAPPED ((u32)-1)
> +
> +struct its_collection {
> +	struct list_head coll_list;
> +
> +	u32 collection_id;
> +	u32 target_addr;
> +};
> +
> +#define its_is_collection_mapped(coll) ((coll) && \
> +				((coll)->target_addr != COLLECTION_NOT_MAPPED))
> +
> +struct its_itte {
> +	struct list_head itte_list;
> +
> +	struct its_collection *collection;
> +	u32 lpi;
> +	u32 event_id;
> +};
> +
>  #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
>  
>  static int vgic_mmio_read_its_ctlr(struct kvm_vcpu *vcpu,
> @@ -137,6 +166,12 @@ static int vgic_mmio_read_its_idregs(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static void its_free_itte(struct its_itte *itte)
> +{
> +	list_del(&itte->itte_list);
> +	kfree(itte);
> +}
> +
>  /*
>   * This function is called with both the ITS and the distributor lock dropped,
>   * so the actual command handlers must take the respective locks when needed.
> @@ -309,6 +344,9 @@ int vits_init(struct kvm *kvm)
>  
>  	spin_lock_init(&its->lock);
>  
> +	INIT_LIST_HEAD(&its->device_list);
> +	INIT_LIST_HEAD(&its->collection_list);
> +
>  	regions = kmalloc_array(ARRAY_SIZE(its_registers),
>  				sizeof(struct vgic_io_device), GFP_KERNEL);
>  
> @@ -332,11 +370,39 @@ void vits_destroy(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  	struct vgic_its *its = &dist->its;
> +	struct its_device *dev;
> +	struct its_itte *itte;
> +	struct list_head *dev_cur, *dev_temp;
> +	struct list_head *cur, *temp;
>  
>  	if (!vgic_has_its(kvm))
>  		return;
>  
> +	/*
> +	 * We may end up here without the lists ever having been initialized.
> +	 * Check this and bail out early to avoid dereferencing a NULL pointer.
> +	 */
> +	if (!its->device_list.next)
> +		return;
don't you check collection_list in a similar way then?
> +
> +	spin_lock(&its->lock);
> +	list_for_each_safe(dev_cur, dev_temp, &its->device_list) {
> +		dev = container_of(dev_cur, struct its_device, dev_list);
> +		list_for_each_safe(cur, temp, &dev->itt) {
use list_for_each_safe_entry instead?

Eric
> +			itte = (container_of(cur, struct its_itte, itte_list));
> +			its_free_itte(itte);
> +		}
> +		list_del(dev_cur);
> +		kfree(dev);
> +	}
> +
> +	list_for_each_safe(cur, temp, &its->collection_list) {
> +		list_del(cur);
> +		kfree(container_of(cur, struct its_collection, coll_list));
> +	}
> +
>  	kfree(dist->pendbaser);
>  
>  	its->enabled = false;
> +	spin_unlock(&its->lock);
>  }
> 

