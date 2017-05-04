From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v6 13/24] KVM: arm64: vgic-its: Check the device id
 matches TYPER DEVBITS range
Date: Thu, 4 May 2017 19:19:23 +0200
Message-ID: <20170504171923.GX5923@cbox>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-14-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493898284-29504-14-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 01:44:33PM +0200, Eric Auger wrote:
> On MAPD we currently check the device id can be stored in the device table.
> Let's first check it can be encoded within the range defined by TYPER
> DEVBITS.
> 
> Also check the collection ID belongs to the 16 bit range as GITS_TYPER
> CIL field equals to 0.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v4 -> v5:
> - use GIC_ENCODE_SZ macro
> 
> v3 -> v4:
> - VITS_TYPER_DEVBITS set to 16 for homogeneity
> - use BIT_ULL
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 6da548d..e7bb86a 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -204,6 +204,7 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
>  #define GIC_LPI_OFFSET 8192
>  
>  #define VITS_TYPER_IDBITS 16
> +#define VITS_TYPER_DEVBITS 16
>  
>  /*
>   * Finds and returns a collection in the ITS collection table.
> @@ -404,7 +405,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
>  	 * To avoid memory waste in the guest, we keep the number of IDBits and
>  	 * DevBits low - as least for the time being.
>  	 */
> -	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
> +	reg |= GIC_ENCODE_SZ(VITS_TYPER_DEVBITS, 5) << GITS_TYPER_DEVBITS_SHIFT;
>  	reg |= GIC_ENCODE_SZ(VITS_TYPER_IDBITS, 5) << GITS_TYPER_IDBITS_SHIFT;
>  	reg |= GIC_ENCODE_SZ(abi->ite_esz, 4) << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;
>  
> @@ -646,16 +647,30 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>   * Check whether an ID can be stored into the corresponding guest table.
>   * For a direct table this is pretty easy, but gets a bit nasty for
>   * indirect tables. We check whether the resulting guest physical address
> - * is actually valid (covered by a memslot and guest accessbible).
> + * is actually valid (covered by a memslot and guest accessible).
>   * For this we have to read the respective first level entry.
>   */
> -static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
> +static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id)
>  {
>  	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
> +	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
> +	int esz = GITS_BASER_ENTRY_SIZE(baser);
>  	int index;
> -	u64 indirect_ptr;
>  	gfn_t gfn;
> -	int esz = GITS_BASER_ENTRY_SIZE(baser);
> +
> +	switch (type) {
> +	case GITS_BASER_TYPE_DEVICE:
> +		if (id >= BIT_ULL(VITS_TYPER_DEVBITS))
> +			return false;
> +		break;
> +	case GITS_BASER_TYPE_COLLECTION:
> +		/* as GITS_TYPER.CID == 0, ITS supports 16-bit collection ID */

nit: GITS_TYPE.CIL




> +		if (id >= BIT_ULL(16))
> +			return false;
> +		break;
> +	default:
> +		return false;
> +	}
>  
>  	if (!(baser & GITS_BASER_INDIRECT)) {
>  		phys_addr_t addr;
> -- 
> 2.5.5
> 

Otherwise:
Reviewed-by: Christoffer Dall <cdall@linaro.org>
