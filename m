From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 10/19] KVM: arm64: ITS: Check the device id matches
 TYPER DEVBITS range
Date: Fri, 17 Mar 2017 15:41:49 +0000
Message-ID: <1ce84330-42bb-4e8d-5446-d481ac4419f2@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-11-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4E2E40A69
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 11:38:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q0KXvgaMQyWk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Mar 2017 11:38:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AA1C40A63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 11:38:19 -0400 (EDT)
In-Reply-To: <1488800074-21991-11-git-send-email-eric.auger@redhat.com>
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
> On MAPD we currently check the device id can be stored in the device table.
> Let's first check it can be encoded within the range defined by TYPER
> DEVBITS.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 694023f..322e370 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -180,6 +180,7 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
>  
>  #define VITS_ESZ 8
>  #define VITS_TYPER_IDBITS 0xF
> +#define VITS_TYPER_DEVBITS 0xF

Same comment as for the other, please use 16 here.

>  /*
>   * Finds and returns a collection in the ITS collection table.
> @@ -402,7 +403,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
>  	 * To avoid memory waste in the guest, we keep the number of IDBits and
>  	 * DevBits low - as least for the time being.
>  	 */
> -	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
> +	reg |= VITS_TYPER_DEVBITS << GITS_TYPER_DEVBITS_SHIFT;
>  	reg |= VITS_TYPER_IDBITS << GITS_TYPER_IDBITS_SHIFT;
>  	reg |= (VITS_ESZ - 1) << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;
>  
> @@ -631,7 +632,7 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>   * Check whether an ID can be stored into the corresponding guest table.
>   * For a direct table this is pretty easy, but gets a bit nasty for
>   * indirect tables. We check whether the resulting guest physical address
> - * is actually valid (covered by a memslot and guest accessbible).
> + * is actually valid (covered by a memslot and guest accessible).

Good lord, nice catch ;-)

>   * For this we have to read the respective first level entry.
>   */
>  static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)

Just seeing that "int" might not be sufficient here, since a device ID
can go up to (2^32 - 1). I wonder if you can fix it on the way.

> @@ -642,6 +643,9 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
>  	gfn_t gfn;
>  	int esz = GITS_BASER_ENTRY_SIZE(baser);
>  
> +	if (id >= (2 << (VITS_TYPER_DEVBITS + 1)))

But shouldn't this be "1 << " if you add one already?
So if you use 16 as mentioned above, wouldn't BIT(VITS_TYPER_DEVBITS) be
more readable? Or even better use BIT_ULL to cover the worst case of 32
bits of device ID here as well.

Cheers,
Andre.

> +		return false;
> +
>  	if (!(baser & GITS_BASER_INDIRECT)) {
>  		phys_addr_t addr;
>  
> 
