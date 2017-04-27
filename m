From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 13/22] KVM: arm64: vgic-its: Check the device id
 matches TYPER DEVBITS range
Date: Thu, 27 Apr 2017 09:48:37 -0700
Message-ID: <20170427164837.GQ50776@lvm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-14-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1492164934-988-14-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 12:15:25PM +0200, Eric Auger wrote:
> On MAPD we currently check the device id can be stored in the device table.
> Let's first check it can be encoded within the range defined by TYPER
> DEVBITS.
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
>  virt/kvm/arm/vgic/vgic-its.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 757598d..de1ed6d 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -194,6 +194,7 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
>  #define GIC_LPI_OFFSET 8192
>  
>  #define VITS_TYPER_IDBITS 16
> +#define VITS_TYPER_DEVBITS 16
>  
>  /*
>   * Finds and returns a collection in the ITS collection table.
> @@ -394,7 +395,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
>  	 * To avoid memory waste in the guest, we keep the number of IDBits and
>  	 * DevBits low - as least for the time being.
>  	 */
> -	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
> +	reg |= GIC_ENCODE_SZ(VITS_TYPER_DEVBITS, 5) << GITS_TYPER_DEVBITS_SHIFT;
>  	reg |= GIC_ENCODE_SZ(VITS_TYPER_IDBITS, 5) << GITS_TYPER_IDBITS_SHIFT;
>  	reg |= GIC_ENCODE_SZ(abi->ite_esz, 4) << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;
>  
> @@ -639,10 +640,10 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
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
>  	int index;
> @@ -650,6 +651,9 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
>  	gfn_t gfn;
>  	int esz = GITS_BASER_ENTRY_SIZE(baser);
>  
> +	if (id >= BIT_ULL(VITS_TYPER_DEVBITS))
> +		return false;
> +

Isn't vgic_its_check_id called with both a device id and a collection
id?  How can this then be a valid check?

>  	if (!(baser & GITS_BASER_INDIRECT)) {
>  		phys_addr_t addr;
>  
> -- 
> 2.5.5
> 

Thanks,
-Christoffer
