From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 07/19] KVM: arm64: ITS: Report the ITE size in
 GITS_TYPER
Date: Fri, 17 Mar 2017 14:39:11 +0000
Message-ID: <abdb6d8a-4572-a604-cee3-6e2dd0ffa181@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-8-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37E1B40A63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 10:35:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qO33CTE+U0H1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Mar 2017 10:35:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C35A40966
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 10:35:40 -0400 (EDT)
In-Reply-To: <1488800074-21991-8-git-send-email-eric.auger@redhat.com>
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



On 06/03/17 11:34, Eric Auger wrote:
> An ITE size of 8 Bytes is reported to the guest. Combining this
> information with the number of event IDs the guest wants to support,
> this latter will be able to allocate each device's ITT with the
> right size.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - correct ITT_ENTRY_SIZE field
> - remove ITE_SIZE since all entries become 8 bytes
> ---
>  include/linux/irqchip/arm-gic-v3.h | 1 +
>  virt/kvm/arm/vgic/vgic-its.c       | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 672cfef..d81f10f 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -232,6 +232,7 @@
>  #define GITS_CTLR_QUIESCENT		(1U << 31)
>  
>  #define GITS_TYPER_PLPIS		(1UL << 0)
> +#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
>  #define GITS_TYPER_IDBITS_SHIFT		8
>  #define GITS_TYPER_DEVBITS_SHIFT	13
>  #define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 6120c6e..6d84508 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -176,6 +176,8 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
>  
>  #define GIC_LPI_OFFSET 8192
>  
> +#define VITS_ESZ 8
> +
>  /*
>   * Finds and returns a collection in the ITS collection table.
>   * Must be called with the its_lock mutex held.
> @@ -399,6 +401,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
>  	 */
>  	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
>  	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
> +	reg |= (VITS_ESZ - 1) << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;
>  
>  	return extract_bytes(reg, addr & 7, len);
>  }
> @@ -1387,7 +1390,7 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
>  	(GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)		| \
>  	 GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, SameAsInner)		| \
>  	 GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)		| \
> -	 ((8ULL - 1) << GITS_BASER_ENTRY_SIZE_SHIFT)			| \
> +	 ((u64)(VITS_ESZ - 1) << GITS_BASER_ENTRY_SIZE_SHIFT)		| \

Nit: wouldn't (VITS_ESZ - 1ULL) save you the cast? Or you define
VITS_ESZ to 8ULL above.

But apart from that:
Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

>  	 GITS_BASER_PAGE_SIZE_64K)
>  
>  #define INITIAL_PROPBASER_VALUE						  \
> 
