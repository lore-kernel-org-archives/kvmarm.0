From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 13/15] KVM: arm64: implement ITS command queue command
 handlers
Date: Mon, 17 Aug 2015 15:33:49 +0200
Message-ID: <55D1E2BD.8070801@linaro.org>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-14-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 218565C5AE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 09:21:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bh4vvJ96u3uq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2015 09:21:15 -0400 (EDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
 [209.85.212.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 502275C3DA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 09:21:15 -0400 (EDT)
Received: by wicne3 with SMTP id ne3so71004503wic.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 06:34:34 -0700 (PDT)
In-Reply-To: <1436538111-4294-14-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/10/2015 04:21 PM, Andre Przywara wrote:
> The connection between a device, an event ID, the LPI number and the
> allocated CPU is stored in in-memory tables in a GICv3, but their
> format is not specified by the spec. Instead software uses a command
> queue in a ring buffer to let the ITS implementation use their own
> format.
> Implement handlers for the various ITS commands and let them store
> the requested relation into our own data structures.
> To avoid kmallocs inside the ITS spinlock, we preallocate possibly
> needed memory outside of the lock and free that if it turns out to
> be not needed (mostly error handling).
still dist lock ...?
> Error handling is very basic at this point, as we don't have a good
> way of communicating errors to the guest (usually a SError).
> The INT command handler is missing at this point, as we gain the
> capability of actually injecting MSIs into the guest only later on.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/linux/irqchip/arm-gic-v3.h |   5 +-
>  virt/kvm/arm/its-emul.c            | 497 ++++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/its-emul.h            |  11 +
>  3 files changed, 511 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 0b450c7..80db4f6 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -253,7 +253,10 @@
>   */
>  #define GITS_CMD_MAPD			0x08
>  #define GITS_CMD_MAPC			0x09
> -#define GITS_CMD_MAPVI			0x0a
> +#define GITS_CMD_MAPTI			0x0a
> +/* older GIC documentation used MAPVI for this command */
> +#define GITS_CMD_MAPVI			GITS_CMD_MAPTI
> +#define GITS_CMD_MAPI			0x0b
>  #define GITS_CMD_MOVI			0x01
>  #define GITS_CMD_DISCARD		0x0f
>  #define GITS_CMD_INV			0x0c
> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
> index 05245cb..89534c6 100644
> --- a/virt/kvm/arm/its-emul.c
> +++ b/virt/kvm/arm/its-emul.c
> @@ -22,6 +22,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
>  #include <linux/list.h>
> +#include <linux/slab.h>
>  
>  #include <linux/irqchip/arm-gic-v3.h>
>  #include <kvm/arm_vgic.h>
> @@ -55,6 +56,34 @@ struct its_itte {
>  	unsigned long *pending;
>  };
>  
> +static struct its_device *find_its_device(struct kvm *kvm, u32 device_id)
> +{
> +	struct vgic_its *its = &kvm->arch.vgic.its;
> +	struct its_device *device;
> +
> +	list_for_each_entry(device, &its->device_list, dev_list)
> +		if (device_id == device->device_id)
> +			return device;
> +
> +	return NULL;
> +}
> +
> +static struct its_itte *find_itte(struct kvm *kvm, u32 device_id, u32 event_id)
> +{
> +	struct its_device *device;
> +	struct its_itte *itte;
> +
> +	device = find_its_device(kvm, device_id);
> +	if (device == NULL)
> +		return NULL;
> +
> +	list_for_each_entry(itte, &device->itt, itte_list)
> +		if (itte->event_id == event_id)
> +			return itte;
> +
> +	return NULL;
> +}
> +
>  #define for_each_lpi(dev, itte, kvm) \
>  	list_for_each_entry(dev, &(kvm)->arch.vgic.its.device_list, dev_list) \
>  		list_for_each_entry(itte, &(dev)->itt, itte_list)
> @@ -71,6 +100,19 @@ static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
>  	return NULL;
>  }
>  
> +static struct its_collection *find_collection(struct kvm *kvm, int coll_id)
> +{
> +	struct its_collection *collection;
> +
> +	list_for_each_entry(collection, &kvm->arch.vgic.its.collection_list,
> +			    coll_list) {
> +		if (coll_id == collection->collection_id)
> +			return collection;
> +	}
> +
> +	return NULL;
> +}
> +
>  #define LPI_PROP_ENABLE_BIT(p)	((p) & LPI_PROP_ENABLED)
>  #define LPI_PROP_PRIORITY(p)	((p) & 0xfc)
>  
> @@ -333,9 +375,461 @@ void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int lpi)
>  	spin_unlock(&its->lock);
>  }
>  
> +static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
> +{
> +	return (le64_to_cpu(its_cmd[word]) >> shift) & (BIT_ULL(size) - 1);
> +}
> +
> +#define its_cmd_get_command(cmd)	its_cmd_mask_field(cmd, 0,  0,  8)
> +#define its_cmd_get_deviceid(cmd)	its_cmd_mask_field(cmd, 0, 32, 32)
> +#define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
> +#define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
> +#define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
> +#define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
> +#define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
> +
> +/* The DISCARD command frees an Interrupt Translation Table Entry (ITTE). */
> +static int vits_cmd_handle_discard(struct kvm *kvm, u64 *its_cmd)
> +{
> +	struct vgic_its *its = &kvm->arch.vgic.its;
> +	u32 device_id;
> +	u32 event_id;
> +	struct its_itte *itte;
> +	int ret = 0;
> +
> +	device_id = its_cmd_get_deviceid(its_cmd);
> +	event_id = its_cmd_get_id(its_cmd);
> +
> +	spin_lock(&its->lock);
> +	itte = find_itte(kvm, device_id, event_id);
> +	if (!itte || !itte->collection) {
> +		ret = E_ITS_DISCARD_UNMAPPED_INTERRUPT;
> +		goto out_unlock;
> +	}
> +
> +	__clear_bit(itte->collection->target_addr, itte->pending);
no use since the itte is deleted afterwards?
> +
> +	list_del(&itte->itte_list);
However what about the deletion of the pending field? May be worth
introducing a function to delete an itte (called several times)
> +	kfree(itte);
> +out_unlock:
> +	spin_unlock(&its->lock);
> +	return ret;
> +}
> +
> +/* The MOVI command moves an ITTE to a different collection. */
> +static int vits_cmd_handle_movi(struct kvm *kvm, u64 *its_cmd)
> +{
> +	struct vgic_its *its = &kvm->arch.vgic.its;
> +	u32 device_id = its_cmd_get_deviceid(its_cmd);
> +	u32 event_id = its_cmd_get_id(its_cmd);
> +	u32 coll_id = its_cmd_get_collection(its_cmd);
> +	struct its_itte *itte;
> +	struct its_collection *collection;
> +	int ret;
> +
> +	spin_lock(&its->lock);
> +	itte = find_itte(kvm, device_id, event_id);
> +	if (!itte) {
> +		ret = E_ITS_MOVI_UNMAPPED_INTERRUPT;
> +		goto out_unlock;
> +	}
> +	if (!itte->collection) {
> +		ret = E_ITS_MOVI_UNMAPPED_COLLECTION;
> +		goto out_unlock;
> +	}
> +
> +	collection = find_collection(kvm, coll_id);
> +	if (!collection) {
> +		ret = E_ITS_MOVI_UNMAPPED_COLLECTION;
> +		goto out_unlock;
> +	}
> +
> +	if (test_and_clear_bit(itte->collection->target_addr, itte->pending))
> +		__set_bit(collection->target_addr, itte->pending);
Don't you think we should make sure target_addr is property set on both
source & destination collection (MAPC with valid bit). Typically the
user could MAPI and then call this. This would encourage to add a valid
bit in the collection struct to tell the target_addr is set.
> +
> +	itte->collection = collection;
> +out_unlock:
> +	spin_unlock(&its->lock);
> +	return ret;
> +}
> +
> +static void vits_init_collection(struct kvm *kvm,
> +				 struct its_collection *collection,
> +				 u32 coll_id)
> +{
> +	collection->collection_id = coll_id;
> +
> +	list_add_tail(&collection->coll_list,
> +		&kvm->arch.vgic.its.collection_list);
> +}
> +
> +/* The MAPTI and MAPI commands map LPIs to ITTEs. */
> +static int vits_cmd_handle_mapi(struct kvm *kvm, u64 *its_cmd, u8 cmd)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	u32 device_id = its_cmd_get_deviceid(its_cmd);
> +	u32 event_id = its_cmd_get_id(its_cmd);
> +	u32 coll_id = its_cmd_get_collection(its_cmd);
> +	struct its_itte *itte, *new_itte;
> +	struct its_device *device;
> +	struct its_collection *collection, *new_coll;
> +	int lpi_nr;
> +	int ret = 0;
> +
> +	/* Preallocate possibly needed memory here outside of the lock */
> +	new_coll = kmalloc(sizeof(struct its_collection), GFP_KERNEL);
> +	new_itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
> +	if (new_itte)
> +		new_itte->pending = kcalloc(BITS_TO_LONGS(dist->nr_cpus),
> +					    sizeof(long), GFP_KERNEL);
> +
> +	spin_lock(&dist->its.lock);
> +
> +	device = find_its_device(kvm, device_id);
> +	if (!device) {
> +		ret = E_ITS_MAPTI_UNMAPPED_DEVICE;
> +		goto out_unlock;
> +	}
> +
> +	collection = find_collection(kvm, coll_id);
> +	if (!collection && !new_coll) {
> +		ret = -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	if (cmd == GITS_CMD_MAPTI)
> +		lpi_nr = its_cmd_get_physical_id(its_cmd);
> +	else
> +		lpi_nr = event_id;
> +	if (lpi_nr < GIC_LPI_OFFSET ||
> +	    lpi_nr >= nr_idbits_propbase(dist->propbaser)) {
> +		ret = E_ITS_MAPTI_PHYSICALID_OOR;
> +		goto out_unlock;
> +	}
> +
> +	itte = find_itte(kvm, device_id, event_id);
> +	if (!itte) {
> +		if (!new_itte || !new_itte->pending) {
> +			ret = -ENOMEM;
> +			goto out_unlock;
> +		}
> +		itte = new_itte;
> +
> +		itte->event_id	= event_id;
> +		list_add_tail(&itte->itte_list, &device->itt);
> +	} else {
> +		if (new_itte)
> +			kfree(new_itte->pending);
> +		kfree(new_itte);
> +	}
> +
> +	if (!collection) {
> +		collection = new_coll;
need to handle the case where new_coll is null which would cause a crash
in init_collection
> +		vits_init_collection(kvm, collection, coll_id);
> +	} else {
> +		kfree(new_coll);
> +	}
> +
> +	itte->collection = collection;
> +	itte->lpi = lpi_nr;
> +
> +out_unlock:
> +	spin_unlock(&dist->its.lock);
> +	if (ret) {
> +		kfree(new_coll);
> +		if (new_itte)
> +			kfree(new_itte->pending);
> +		kfree(new_itte);
> +	}
> +	return ret;
> +}
> +
> +static void vits_unmap_device(struct kvm *kvm, struct its_device *device)
> +{
> +	struct its_itte *itte, *temp;
> +
> +	/*
> +	 * The spec says that unmapping a device with still valid
> +	 * ITTEs associated is UNPREDICTABLE. We remove all ITTEs,
> +	 * since we cannot leave the memory unreferenced.
> +	 */
> +	list_for_each_entry_safe(itte, temp, &device->itt, itte_list) {
> +		list_del(&itte->itte_list);
deletion of itte->pending
> +		kfree(itte);
> +	}
> +
> +	list_del(&device->dev_list);
> +	kfree(device);
> +}
> +
> +/* The MAPD command maps device IDs to Interrupt Translation Tables (ITTs). */
or unmaps
> +static int vits_cmd_handle_mapd(struct kvm *kvm, u64 *its_cmd)
> +{
> +	struct vgic_its *its = &kvm->arch.vgic.its;
> +	bool valid = its_cmd_get_validbit(its_cmd);
> +	u32 device_id = its_cmd_get_deviceid(its_cmd);
> +	struct its_device *device, *new_device = NULL;
> +
> +	/* We preallocate memory outside of the lock here */
> +	if (valid) {
> +		new_device = kzalloc(sizeof(struct its_device), GFP_KERNEL);
> +		if (!new_device)
> +			return -ENOMEM;
> +	}
> +
> +	spin_lock(&its->lock);
> +
> +	device = find_its_device(kvm, device_id);
> +	if (device)
logically valid should be false too else that's an error?
> +		vits_unmap_device(kvm, device);
> +
> +	/*
> +	 * The spec does not say whether unmapping a not-mapped device
> +	 * is an error, so we are done in any case.
> +	 */
> +	if (!valid)
> +		goto out_unlock;
> +
> +	device = new_device;
> +
> +	device->device_id = device_id;
> +	INIT_LIST_HEAD(&device->itt);
> +
> +	list_add_tail(&device->dev_list,
> +		      &kvm->arch.vgic.its.device_list);
> +
> +out_unlock:
> +	spin_unlock(&its->lock);
> +	return 0;
> +}
> +
> +/* The MAPC command maps collection IDs to redistributors. */
> +static int vits_cmd_handle_mapc(struct kvm *kvm, u64 *its_cmd)
> +{
> +	struct vgic_its *its = &kvm->arch.vgic.its;
> +	u16 coll_id;
> +	u32 target_addr;
> +	struct its_collection *collection, *new_coll = NULL;
> +	bool valid;
> +
> +	valid = its_cmd_get_validbit(its_cmd);
> +	coll_id = its_cmd_get_collection(its_cmd);
> +	target_addr = its_cmd_get_target_addr(its_cmd);
> +
> +	if (target_addr >= atomic_read(&kvm->online_vcpus))
> +		return E_ITS_MAPC_PROCNUM_OOR;
> +
> +	/* We preallocate memory outside of the lock here */
> +	if (valid) {
> +		new_coll = kmalloc(sizeof(struct its_collection), GFP_KERNEL);
> +		if (!new_coll)
> +			return -ENOMEM;
> +	}
> +
> +	spin_lock(&its->lock);
> +	collection = find_collection(kvm, coll_id);
> +
> +	if (!valid) {
> +		struct its_device *device;
> +		struct its_itte *itte;
> +		/*
> +		 * Clearing the mapping for that collection ID removes the
> +		 * entry from the list. If there wasn't any before, we can
> +		 * go home early.
> +		 */
> +		if (!collection)
> +			goto out_unlock;
> +
> +		for_each_lpi(device, itte, kvm)
> +			if (itte->collection &&
> +			    itte->collection->collection_id == coll_id)
> +				itte->collection = NULL;
> +
> +		list_del(&collection->coll_list);
> +		kfree(collection);
> +	} else {
> +		if (!collection)
> +			collection = new_coll;
> +		else
> +			kfree(new_coll);
> +
> +		vits_init_collection(kvm, collection, coll_id);
> +		collection->target_addr = target_addr;
> +	}
> +
> +out_unlock:
> +	spin_unlock(&its->lock);
> +	return 0;
> +}
> +
> +/* The CLEAR command removes the pending state for a particular LPI. */
> +static int vits_cmd_handle_clear(struct kvm *kvm, u64 *its_cmd)
> +{
> +	struct vgic_its *its = &kvm->arch.vgic.its;
> +	u32 device_id;
> +	u32 event_id;
> +	struct its_itte *itte;
> +	int ret = 0;
> +
> +	device_id = its_cmd_get_deviceid(its_cmd);
> +	event_id = its_cmd_get_id(its_cmd);
> +
> +	spin_lock(&its->lock);
> +
> +	itte = find_itte(kvm, device_id, event_id);
> +	if (!itte) {
> +		ret = E_ITS_CLEAR_UNMAPPED_INTERRUPT;
> +		goto out_unlock;
> +	}
> +
> +	if (itte->collection)
> +		__clear_bit(itte->collection->target_addr, itte->pending);
> +
> +out_unlock:
> +	spin_unlock(&its->lock);
> +	return ret;
> +}
> +
> +/* The INV command syncs the pending bit from the memory tables. */
> +static int vits_cmd_handle_inv(struct kvm *kvm, u64 *its_cmd)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	u32 device_id;
> +	u32 event_id;
> +	struct its_itte *itte, *new_itte;
> +	gpa_t propbase;
> +	int ret;
> +	u8 prop;
> +
> +	device_id = its_cmd_get_deviceid(its_cmd);
> +	event_id = its_cmd_get_id(its_cmd);
> +
> +	spin_lock(&dist->its.lock);
> +	itte = find_itte(kvm, device_id, event_id);
> +	spin_unlock(&dist->its.lock);
> +	if (!itte)
> +		return E_ITS_INV_UNMAPPED_INTERRUPT;
> +
> +	/*
> +	 * We cannot read from guest memory inside the spinlock, so we
> +	 * need to re-read our tables to learn whether the LPI number we are
> +	 * using is still valid.
> +	 */
> +	do {
> +		propbase = BASER_BASE_ADDRESS(dist->propbaser);
> +		ret = kvm_read_guest(kvm, propbase + itte->lpi - GIC_LPI_OFFSET,
> +				     &prop, 1);
> +		if (ret)
> +			return ret;
> +
> +		spin_lock(&dist->its.lock);
> +		new_itte = find_itte(kvm, device_id, event_id);
> +		if (new_itte->lpi != itte->lpi) {
> +			itte = new_itte;
> +			spin_unlock(&dist->its.lock);
> +			continue;
> +		}
> +		update_lpi_config(kvm, itte, prop);
spec says the pending table should be sync'ed too. shouldn't we update
the pending table in the guest address range?
> +		spin_unlock(&dist->its.lock);
> +	} while (0);
> +	return 0;
> +}
> +
> +/* The INVALL command requests flushing of all IRQ data in this collection. */
> +static int vits_cmd_handle_invall(struct kvm *kvm, u64 *its_cmd)
> +{
> +	u32 coll_id = its_cmd_get_collection(its_cmd);
> +	struct its_collection *collection;
> +	struct kvm_vcpu *vcpu;
> +
> +	collection = find_collection(kvm, coll_id);
> +	if (!collection)
> +		return E_ITS_INVALL_UNMAPPED_COLLECTION;
> +
> +	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
> +
> +	its_update_lpis_configuration(kvm);
> +	its_sync_lpi_pending_table(vcpu);
here we do?
> +
> +	return 0;
> +}
> +
> +/* The MOVALL command moves all IRQs from one redistributor to another. */
> +static int vits_cmd_handle_movall(struct kvm *kvm, u64 *its_cmd)
> +{
> +	struct vgic_its *its = &kvm->arch.vgic.its;
> +	u32 target1_addr = its_cmd_get_target_addr(its_cmd);
> +	u32 target2_addr = its_cmd_mask_field(its_cmd, 3, 16, 32);
> +	struct its_collection *collection;
> +	struct its_device *device;
> +	struct its_itte *itte;
> +
> +	if (target1_addr >= atomic_read(&kvm->online_vcpus) ||
> +	    target2_addr >= atomic_read(&kvm->online_vcpus))
> +		return E_ITS_MOVALL_PROCNUM_OOR;
> +
> +	if (target1_addr == target2_addr)
> +		return 0;
> +
> +	spin_lock(&its->lock);
> +	for_each_lpi(device, itte, kvm) {
> +		/* remap all collections mapped to target address 1 */
> +		collection = itte->collection;
> +		if (collection && collection->target_addr == target1_addr)
> +			collection->target_addr = target2_addr;
> +
> +		/* move pending state if LPI is affected */
> +		if (test_and_clear_bit(target1_addr, itte->pending))
> +			__set_bit(target2_addr, itte->pending);
> +	}
> +
> +	spin_unlock(&its->lock);
> +	return 0;
> +}
> +
>  static int vits_handle_command(struct kvm_vcpu *vcpu, u64 *its_cmd)
>  {
> -	return -ENODEV;
> +	u8 cmd = its_cmd_get_command(its_cmd);
> +	int ret = -ENODEV;
> +
> +	switch (cmd) {
> +	case GITS_CMD_MAPD:
> +		ret = vits_cmd_handle_mapd(vcpu->kvm, its_cmd);
> +		break;
> +	case GITS_CMD_MAPC:
> +		ret = vits_cmd_handle_mapc(vcpu->kvm, its_cmd);
> +		break;
> +	case GITS_CMD_MAPI:
> +		ret = vits_cmd_handle_mapi(vcpu->kvm, its_cmd, cmd);
> +		break;
> +	case GITS_CMD_MAPTI:
> +		ret = vits_cmd_handle_mapi(vcpu->kvm, its_cmd, cmd);
> +		break;
> +	case GITS_CMD_MOVI:
> +		ret = vits_cmd_handle_movi(vcpu->kvm, its_cmd);
> +		break;
> +	case GITS_CMD_DISCARD:
> +		ret = vits_cmd_handle_discard(vcpu->kvm, its_cmd);
> +		break;
> +	case GITS_CMD_CLEAR:
> +		ret = vits_cmd_handle_clear(vcpu->kvm, its_cmd);
> +		break;
> +	case GITS_CMD_MOVALL:
> +		ret = vits_cmd_handle_movall(vcpu->kvm, its_cmd);
> +		break;
> +	case GITS_CMD_INV:
> +		ret = vits_cmd_handle_inv(vcpu->kvm, its_cmd);
> +		break;
> +	case GITS_CMD_INVALL:
> +		ret = vits_cmd_handle_invall(vcpu->kvm, its_cmd);
> +		break;
> +	case GITS_CMD_SYNC:
> +		/* we ignore this command: we are in sync all of the time */
> +		ret = 0;
> +		break;
> +	}
> +
> +	return ret;
>  }
>  
>  static bool handle_mmio_gits_cbaser(struct kvm_vcpu *vcpu,
> @@ -554,6 +1048,7 @@ void vits_destroy(struct kvm *kvm)
>  		list_for_each_safe(cur, temp, &dev->itt) {
>  			itte = (container_of(cur, struct its_itte, itte_list));
>  			list_del(cur);
> +			kfree(itte->pending);
should belong to a previous patch I think

Eric
>  			kfree(itte);
>  		}
>  		list_del(dev_cur);
> diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
> index cbc3877..830524a 100644
> --- a/virt/kvm/arm/its-emul.h
> +++ b/virt/kvm/arm/its-emul.h
> @@ -39,4 +39,15 @@ void vits_destroy(struct kvm *kvm);
>  bool vits_queue_lpis(struct kvm_vcpu *vcpu);
>  void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int irq);
>  
> +#define E_ITS_MOVI_UNMAPPED_INTERRUPT		0x010107
> +#define E_ITS_MOVI_UNMAPPED_COLLECTION		0x010109
> +#define E_ITS_CLEAR_UNMAPPED_INTERRUPT		0x010507
> +#define E_ITS_MAPC_PROCNUM_OOR			0x010902
> +#define E_ITS_MAPTI_UNMAPPED_DEVICE		0x010a04
> +#define E_ITS_MAPTI_PHYSICALID_OOR		0x010a06
> +#define E_ITS_INV_UNMAPPED_INTERRUPT		0x010c07
> +#define E_ITS_INVALL_UNMAPPED_COLLECTION	0x010d09
> +#define E_ITS_MOVALL_PROCNUM_OOR		0x010e01
> +#define E_ITS_DISCARD_UNMAPPED_INTERRUPT	0x010f07
> +
>  #endif
> 
