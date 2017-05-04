From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 10/24] KVM: arm64: vgic-its: Implement
 vgic_mmio_uaccess_write_its_iidr
Date: Thu, 4 May 2017 16:39:26 +0100
Message-ID: <d877c0e7-6147-f8d5-c3d6-d8dee36f97bb@arm.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-11-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D53405DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 11:36:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BxoeOHNCEXFk for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 11:36:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A2D40296
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 11:36:24 -0400 (EDT)
In-Reply-To: <1493898284-29504-11-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 04/05/17 12:44, Eric Auger wrote:
> The GITS_IIDR revision field is used to encode the migration ABI
> revision. So we need to restore it to check the table layout is
> readable by the destination.
> 
> By writing the IIDR, userspace thus forces the ABI revision to be
> used and this must be less than or equal to the max revision KVM
> supports.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v5 -> v6:
> - fix typos in the commit message
> - dont't use update_64bit_reg anymore
> 
> v4 -> v5
> - rename user_revision into abi_rev and REV into MAX_ABI_REV
> - IIDR reports abi_rev set by userspace if any.
> - If value set by userspace exceeds the max supported revision, an
>   error is reported.
> - add some defines
> 
> v4: creation
> ---
>  include/linux/irqchip/arm-gic-v3.h |  4 ++++
>  virt/kvm/arm/vgic/vgic-its.c       | 20 +++++++++++++++++---
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 81ebe43..59f1abd 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -242,6 +242,10 @@
>  #define GITS_TYPER_PTA			(1UL << 19)
>  #define GITS_TYPER_HWCOLLCNT_SHIFT	24
>  
> +#define GITS_IIDR_REV_SHIFT		12
> +#define GITS_IIDR_REV(r)		(((r) >> GITS_IIDR_REV_SHIFT) & 0xf)
> +#define GITS_IIDR_PRODUCTID_SHIFT	24
> +
>  #define GITS_CBASER_VALID			(1ULL << 63)
>  #define GITS_CBASER_SHAREABILITY_SHIFT		(10)
>  #define GITS_CBASER_INNER_CACHEABILITY_SHIFT	(59)
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index c336cce..072efbd 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -411,7 +411,20 @@ static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm,
>  					     struct vgic_its *its,
>  					     gpa_t addr, unsigned int len)
>  {
> -	return (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
> +	return (PRODUCT_ID_KVM << GITS_IIDR_PRODUCTID_SHIFT) |
> +	       (its->abi_rev << GITS_IIDR_REV_SHIFT) | IMPLEMENTER_ARM;

Given that abi_rev is a 32bit quantity, and the REV field only only 4
bit wide, I'd feel safer with a mask somewhere...

And hopefully, we'll never have more than 16 ABIs! ;-)

> +}
> +
> +static int vgic_mmio_uaccess_write_its_iidr(struct kvm *kvm,
> +					    struct vgic_its *its,
> +					    gpa_t addr, unsigned int len,
> +					    unsigned long val)
> +{
> +	u32 rev = GITS_IIDR_REV(val);
> +
> +	if (rev > MAX_ABI_REV)
> +		return -EINVAL;
> +	return vgic_its_set_abi(its, rev);
>  }
>  
>  static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
> @@ -1393,8 +1406,9 @@ static struct vgic_register_region its_registers[] = {
>  	REGISTER_ITS_DESC(GITS_CTLR,
>  		vgic_mmio_read_its_ctlr, vgic_mmio_write_its_ctlr, 4,
>  		VGIC_ACCESS_32bit),
> -	REGISTER_ITS_DESC(GITS_IIDR,
> -		vgic_mmio_read_its_iidr, its_mmio_write_wi, 4,
> +	REGISTER_ITS_DESC_UACCESS(GITS_IIDR,
> +		vgic_mmio_read_its_iidr, its_mmio_write_wi,
> +		vgic_mmio_uaccess_write_its_iidr, 4,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_ITS_DESC(GITS_TYPER,
>  		vgic_mmio_read_its_typer, its_mmio_write_wi, 8,
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
