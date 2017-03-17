From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 08/19] KVM: arm64: ITS: Interpret MAPD Size field and
 check related errors
Date: Fri, 17 Mar 2017 15:03:13 +0000
Message-ID: <7daaac71-1dbf-94c9-2b6b-fadf94a5b776@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-9-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6A840A74
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 10:59:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 289lY79ADrvZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Mar 2017 10:59:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D2D040A63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 10:59:42 -0400 (EDT)
In-Reply-To: <1488800074-21991-9-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 06/03/17 11:34, Eric Auger wrote:
> Up to now the MAPD's ITT size field has been ignored. It encodes
> the number of eventid bit minus 1. It should be used to check
> the eventid when a MAPTI command is issued on a device. Let's
> store the nb_eventid_bits in the its_device and do the check
> on MAPTI. Also make sure the ITT size field does not exceed the
> GITS_TYPER IDBITS field.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> ---
>  include/linux/irqchip/arm-gic-v3.h |  2 ++
>  virt/kvm/arm/vgic/vgic-its.c       | 14 +++++++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index d81f10f..a7a5548 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -338,9 +338,11 @@
>  #define E_ITS_INT_UNMAPPED_INTERRUPT		0x010307
>  #define E_ITS_CLEAR_UNMAPPED_INTERRUPT		0x010507
>  #define E_ITS_MAPD_DEVICE_OOR			0x010801
> +#define E_ITS_MAPD_ITTSIZE_OOR			0x010802
>  #define E_ITS_MAPC_PROCNUM_OOR			0x010902
>  #define E_ITS_MAPC_COLLECTION_OOR		0x010903
>  #define E_ITS_MAPTI_UNMAPPED_DEVICE		0x010a04
> +#define E_ITS_MAPTI_ID_OOR			0x010a05
>  #define E_ITS_MAPTI_PHYSICALID_OOR		0x010a06
>  #define E_ITS_INV_UNMAPPED_INTERRUPT		0x010c07
>  #define E_ITS_INVALL_UNMAPPED_COLLECTION	0x010d09
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 6d84508..56bcd92 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -99,6 +99,7 @@ struct its_device {
>  
>  	/* the head for the list of ITTEs */
>  	struct list_head itt_head;
> +	u32 nb_eventid_bits;
>  	u32 device_id;
>  };
>  
> @@ -177,6 +178,7 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
>  #define GIC_LPI_OFFSET 8192
>  
>  #define VITS_ESZ 8
> +#define VITS_TYPER_IDBITS 0xF

Alone for consistency reasons I'd use "16" here and subtract one upon
encoding this into the TYPER register.

>  
>  /*
>   * Finds and returns a collection in the ITS collection table.
> @@ -400,7 +402,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
>  	 * DevBits low - as least for the time being.
>  	 */
>  	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
> -	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
> +	reg |= VITS_TYPER_IDBITS << GITS_TYPER_IDBITS_SHIFT;
>  	reg |= (VITS_ESZ - 1) << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;
>  
>  	return extract_bytes(reg, addr & 7, len);
> @@ -560,6 +562,7 @@ static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
>  #define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
>  #define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
>  #define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
> +#define its_cmd_get_size(cmd)		its_cmd_mask_field(cmd, 1, 0,  5)

Can you please move this up to be in order with the other fields?

>  /*
>   * The DISCARD command frees an Interrupt Translation Table Entry (ITTE).
> @@ -745,6 +748,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	if (!device)
>  		return E_ITS_MAPTI_UNMAPPED_DEVICE;
>  
> +	if (event_id >= (2 << device->nb_eventid_bits))

And I'd find it less confusing to hold the actual bit size in
nb_eventid_bits (and abstract from the particular encoding in TYPER).
That would avoid this slightly odd (2 << ...) here, for instance.

> +		return E_ITS_MAPTI_ID_OOR;
> +
>  	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
>  		lpi_nr = its_cmd_get_physical_id(its_cmd);
>  	else
> @@ -825,11 +831,15 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>  {
>  	u32 device_id = its_cmd_get_deviceid(its_cmd);
>  	bool valid = its_cmd_get_validbit(its_cmd);
> +	size_t size = its_cmd_get_size(its_cmd);

If you add 1 here, you'd make clear that this is an encoding property.

Cheers,
Andre.

>  	struct its_device *device;
>  
>  	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
>  		return E_ITS_MAPD_DEVICE_OOR;
>  
> +	if (valid && size > VITS_TYPER_IDBITS)
> +		return E_ITS_MAPD_ITTSIZE_OOR;
> +
>  	device = find_its_device(its, device_id);
>  
>  	/*
> @@ -852,6 +862,8 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>  		return -ENOMEM;
>  
>  	device->device_id = device_id;
> +	device->nb_eventid_bits = size + 1;
> +
>  	INIT_LIST_HEAD(&device->itt_head);
>  
>  	list_add_tail(&device->dev_list, &its->device_list);
> 
