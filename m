From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 3/7] KVM: arm: vgic-new: improve compatibility with
 32-bit
Date: Mon, 5 Sep 2016 13:29:04 +0200
Message-ID: <20160905112904.GH26366@cbox>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-4-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57C7849B45
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Sep 2016 07:18:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TOerzOgwbXmr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Sep 2016 07:18:16 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6065949B47
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Sep 2016 07:18:16 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id 1so133708530wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Sep 2016 04:26:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1471344418-19568-4-git-send-email-vladimir.murzin@arm.com>
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

Hi Vladimir,

I think commit title is too vague, can you be more specific?

On Tue, Aug 16, 2016 at 11:46:54AM +0100, Vladimir Murzin wrote:
> We have couple of 64-bit register defined in GICv3 architecture, so

'a couple',  'registers' (plural)

> "unsigned long" kind of accessors wouldn't work for 32-bit. However,

'wouldn't work for 32-bit' is kind of generic as well.  Perhaps you mean
that unsigned long accesses to these registers will only access a single
32-bit work of that register.

> these registers can't be access as 64-bit in a one go if we run 32-bit

'accessed', 's/in one go/with a single instruction/' ?

'a 32-bit host'

> host simply because KVM doesn't support multiple load/store on MMIO

by 'multiple load/store' you mean the 'load/store multiple' instructions
specifically, right?  Not a sequence of multiple loads and stores.  I
think you should be more specific here as well, for example, I think
ldrd and strd are problematic as well.

> space.
> 
> It means that 32-bit guest access these registers in 32-bit chunks, so

'a 32-bit guest', 'accesses'

> the only thing we need to do is to ensure that extract_bytes() always
> takes 64-bit data.
> 
> Since we are here fix couple of other width related issues by using
> ULL variants over UL.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c |    6 +++---
>  virt/kvm/arm/vgic/vgic-mmio.h    |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index ff668e0..cc20b60 100644
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
> @@ -179,7 +179,7 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>  	int target_vcpu_id = vcpu->vcpu_id;
>  	u64 value;
>  
> -	value = (mpidr & GENMASK(23, 0)) << 32;
> +	value = (mpidr & GENMASK_ULL(23, 0)) << 32;

why does this make a difference when mpidr is an unsigned long?

>  	value |= ((target_vcpu_id & 0xffff) << 8);
>  	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
>  		value |= GICR_TYPER_LAST;
> @@ -603,7 +603,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
>  	bool broadcast;
>  
>  	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
> -	broadcast = reg & BIT(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
> +	broadcast = reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
>  	target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
>  	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
>  	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
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
