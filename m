From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 06/10] KVM: arm: vgic: Support 64-bit data
 manipulation on 32-bit host systems
Date: Tue, 13 Sep 2016 10:51:58 +0200
Message-ID: <20160913085158.GG5680@cbox>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-7-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BCCF49B7C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j1Vt8eiTw6A9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 04:40:37 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55A0B49B76
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:37 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id 1so187956466wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 01:49:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473691764-29424-7-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 12, 2016 at 03:49:20PM +0100, Vladimir Murzin wrote:
> We have couple of 64-bit registers defined in GICv3 architecture, so
> unsigned long accesses to these registers will only access a single
> 32-bit part of that regitser. On the other hand these registers can't
> be accessed as 64-bit with a single instruction like ldrd/strd or
> ldmia/stmia if we run a 32-bit host because KVM does not support
> access to MMIO space done by these instructions.
> 
> It means that a 32-bit guest accesses these registers in 32-bit
> chunks, so the only thing we need to do is to ensure that
> extract_bytes() always takes 64-bit data.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c |    2 +-
>  virt/kvm/arm/vgic/vgic-mmio.h    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 6385ed5..0d3c76a 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -23,7 +23,7 @@
>  #include "vgic-mmio.h"
>  
>  /* extract @num bytes at @offset bytes offset in data */
> -unsigned long extract_bytes(unsigned long data, unsigned int offset,
> +unsigned long extract_bytes(u64 data, unsigned int offset,
>  			    unsigned int num)
>  {
>  	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 0b3ecf9..80f92ce 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -96,7 +96,7 @@ unsigned long vgic_data_mmio_bus_to_host(const void *val, unsigned int len);
>  void vgic_data_host_to_mmio_bus(void *buf, unsigned int len,
>  				unsigned long data);
>  
> -unsigned long extract_bytes(unsigned long data, unsigned int offset,
> +unsigned long extract_bytes(u64 data, unsigned int offset,
>  			    unsigned int num);
>  
>  u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
> -- 
> 1.7.9.5
> 
