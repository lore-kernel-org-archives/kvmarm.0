From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC 06/13] KVM: arm64: ITS: Expose ITT_Entry_Size in GITS_TYPER
Date: Thu, 12 Jan 2017 17:06:30 +0000
Message-ID: <3efc34ee-36c1-860a-365a-a9363b7fc8e5@arm.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
 <1484236613-24633-7-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C29F40194
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:03:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 58qk664QeBHr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 12:03:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 966344019A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:03:34 -0500 (EST)
In-Reply-To: <1484236613-24633-7-git-send-email-eric.auger@redhat.com>
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
Cc: Prasun.Kapoor@cavium.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 12/01/17 15:56, Eric Auger wrote:
> An ITT_Entry_Size of 2x8Bytes is reported to the guest
> to provision for ITTE state storage.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  include/linux/irqchip/arm-gic-v3.h | 1 +
>  virt/kvm/arm/vgic/vgic-its.c       | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 170e00a..8cfd81bc 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -233,6 +233,7 @@
>  #define GITS_CTLR_QUIESCENT		(1U << 31)
>  
>  #define GITS_TYPER_PLPIS		(1UL << 0)
> +#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
>  #define GITS_TYPER_IDBITS_SHIFT		8
>  #define GITS_TYPER_DEVBITS_SHIFT	13
>  #define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index e174220..96378b8 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -33,6 +33,8 @@
>  #include "vgic.h"
>  #include "vgic-mmio.h"
>  
> +#define ITTE_SIZE 16
> +
>  /*
>   * Creates a new (reference to a) struct vgic_irq for a given LPI.
>   * If this LPI is already mapped on another ITS, we increase its refcount
> @@ -399,6 +401,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
>  	 */
>  	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
>  	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
> +	reg |= ITTE_SIZE << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;

The field is defined as the "... number of bytes per translation table
entry, minus one.". So it should be: (ITTE_SIZE - 1) << ...

Cheers,
Andre.

>  
>  	return extract_bytes(reg, addr & 7, len);
>  }
> 
