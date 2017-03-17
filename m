From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 03/19] arm/arm64: vgic: turn vgic_find_mmio_region into
 public
Date: Fri, 17 Mar 2017 14:38:56 +0000
Message-ID: <7b4aa19d-d413-7714-a317-b9e59a2fbf88@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-4-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 128E440A63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 10:35:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UYxckC6ms7dL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Mar 2017 10:35:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC68F40966
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 10:35:26 -0400 (EDT)
In-Reply-To: <1488800074-21991-4-git-send-email-eric.auger@redhat.com>
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

Hi Eric,

On 06/03/17 11:34, Eric Auger wrote:
> We plan to use vgic_find_mmio_region in vgic-its.c so let's
> turn it into a public function.

Just a nit below, but for the patch:

> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 3 +--
>  virt/kvm/arm/vgic/vgic-mmio.h | 5 +++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 3654b4c..0427ddb 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -430,8 +430,7 @@ static int match_region(const void *key, const void *elt)
>  	return 0;
>  }
>  
> -/* Find the proper register handler entry given a certain address offset. */
> -static const struct vgic_register_region *
> +const struct vgic_register_region *
>  vgic_find_mmio_region(const struct vgic_register_region *region, int nr_regions,
>  		      unsigned int offset)
>  {
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 98bb566..055ad42 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -192,4 +192,9 @@ u64 vgic_sanitise_shareability(u64 reg);
>  u64 vgic_sanitise_field(u64 reg, u64 field_mask, int field_shift,
>  			u64 (*sanitise_fn)(u64));
>  
> +/* Find the proper register handler entry given a certain address offset */
> +const struct vgic_register_region *
> +vgic_find_mmio_region(const struct vgic_register_region *region,

I wonder if we should use the opportunity to use the plural in the
variable name here ("regions") to make it clear that this is an array
(just needed some time myself here to remember what it does).

Cheers,
Andre.

> +		      int nr_regions, unsigned int offset);
> +
>  #endif
> 
