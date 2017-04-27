From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 04/22] arm/arm64: vgic: turn vgic_find_mmio_region
 into public
Date: Thu, 27 Apr 2017 02:07:24 -0700
Message-ID: <20170427090724.GD50776@lvm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-5-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84A0C40EFE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 05:04:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zrqgauHnc4Zh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Apr 2017 05:04:34 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 655F540E02
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 05:04:34 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id r190so11956813wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 02:07:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1492164934-988-5-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 12:15:16PM +0200, Eric Auger wrote:
> We plan to use vgic_find_mmio_region in vgic-its.c so let's
> turn it into a public function.
> 
> Also let's take the opportunity to rename the region parameter
> into regions to emphasize this latter is an array of regions.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> ---
> v4 -> v5:
> - add Marc's A-b
> 
> v3 -> v4:
> - rename region parameter into regions
> - add Andre's R-b
> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 11 +++++------
>  virt/kvm/arm/vgic/vgic-mmio.h |  5 +++++
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 2a5db13..1c17b2a 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -446,13 +446,12 @@ static int match_region(const void *key, const void *elt)
>  	return 0;
>  }
>  
> -/* Find the proper register handler entry given a certain address offset. */
> -static const struct vgic_register_region *
> -vgic_find_mmio_region(const struct vgic_register_region *region, int nr_regions,
> -		      unsigned int offset)
> +const struct vgic_register_region *
> +vgic_find_mmio_region(const struct vgic_register_region *regions,
> +		      int nr_regions, unsigned int offset)
>  {
> -	return bsearch((void *)(uintptr_t)offset, region, nr_regions,
> -		       sizeof(region[0]), match_region);
> +	return bsearch((void *)(uintptr_t)offset, regions, nr_regions,
> +		       sizeof(regions[0]), match_region);
>  }
>  
>  void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 98bb566..6eec91b 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -192,4 +192,9 @@ u64 vgic_sanitise_shareability(u64 reg);
>  u64 vgic_sanitise_field(u64 reg, u64 field_mask, int field_shift,
>  			u64 (*sanitise_fn)(u64));
>  
> +/* Find the proper register handler entry given a certain address offset */


nit: we don't usually comment the functions in the prototype in the
header files but keep comments with the function implementation.

But I don't care deeply about this.

Acked-by: Christoffer Dall <cdall@linaro.org>

> +const struct vgic_register_region *
> +vgic_find_mmio_region(const struct vgic_register_region *regions,
> +		      int nr_regions, unsigned int offset);
> +
>  #endif
> -- 
> 2.5.5
> 
