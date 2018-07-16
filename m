From: Bharat Bhushan <bharat.bhushan@nxp.com>
Subject: RE: [PATCH v4 07/10] KVM: arm/arm64: vgic: Return error on
 incompatible uaccess GICD_IIDR writes
Date: Mon, 16 Jul 2018 15:43:28 +0000
Message-ID: <AM5PR0401MB25455D849AB57AF98A3C91F49A5D0@AM5PR0401MB2545.eurprd04.prod.outlook.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
 <1531746387-7033-8-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBE384A124
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 11:30:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uLoqHtqe5hcT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 11:30:31 -0400 (EDT)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60065.outbound.protection.outlook.com [40.107.6.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 974C64A15A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 11:30:31 -0400 (EDT)
In-Reply-To: <1531746387-7033-8-git-send-email-christoffer.dall@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-
> bounces@lists.cs.columbia.edu] On Behalf Of Christoffer Dall
> Sent: Monday, July 16, 2018 6:36 PM
> To: kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Cc: kvm@vger.kernel.org; Marc Zyngier <marc.zyngier@arm.com>; Andre
> Przywara <andre.przywara@arm.com>
> Subject: [PATCH v4 07/10] KVM: arm/arm64: vgic: Return error on
> incompatible uaccess GICD_IIDR writes
> 
> If userspace attempts to write a GICD_IIDR that does not match the
> kernel version, return an error to userspace.  The intention is to allow
> implementation changes inside KVM while avoiding silently breaking
> migration resulting in guests not running without any clear indication
> of what went wrong.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 21 ++++++++++++++++++---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 21 ++++++++++++++++++---
>  2 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-
> mmio-v2.c
> index db646f1..4f0f2c4 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -75,6 +75,20 @@ static void vgic_mmio_write_v2_misc(struct kvm_vcpu
> *vcpu,
>  	}
>  }
> 
> +static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
> +					   gpa_t addr, unsigned int len,
> +					   unsigned long val)
> +{
> +	switch (addr & 0x0c) {

I am just understanding the code, not sure if it make sense to replace hardcoded "0x0c".

Thanks
-Bharat

> +	case GIC_DIST_IIDR:
> +		if (val != vgic_mmio_read_v2_misc(vcpu, addr, len))
> +			return -EINVAL;
> +	}
> +
> +	vgic_mmio_write_v2_misc(vcpu, addr, len, val);
> +	return 0;
> +}
> +
>  static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
>  				 gpa_t addr, unsigned int len,
>  				 unsigned long val)
> @@ -367,9 +381,10 @@ static void vgic_mmio_write_apr(struct kvm_vcpu
> *vcpu,
>  }
> 
>  static const struct vgic_register_region vgic_v2_dist_registers[] = {
> -	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
> -		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
> -		VGIC_ACCESS_32bit),
> +	REGISTER_DESC_WITH_LENGTH_UACCESS(GIC_DIST_CTRL,
> +		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc,
> +		NULL, vgic_mmio_uaccess_write_v2_misc,
> +		12, VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
>  		VGIC_ACCESS_32bit),
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-
> mmio-v3.c
> index ef57a1a..abdb0ec 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -113,6 +113,20 @@ static void vgic_mmio_write_v3_misc(struct
> kvm_vcpu *vcpu,
>  	}
>  }
> 
> +static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
> +					   gpa_t addr, unsigned int len,
> +					   unsigned long val)
> +{
> +	switch (addr & 0x0c) {
> +	case GICD_IIDR:
> +		if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
> +			return -EINVAL;
> +	}
> +
> +	vgic_mmio_write_v3_misc(vcpu, addr, len, val);
> +	return 0;
> +}
> +
>  static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
>  					    gpa_t addr, unsigned int len)
>  {
> @@ -449,9 +463,10 @@ static void vgic_mmio_write_pendbase(struct
> kvm_vcpu *vcpu,
>  	}
> 
>  static const struct vgic_register_region vgic_v3_dist_registers[] = {
> -	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
> -		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16,
> -		VGIC_ACCESS_32bit),
> +	REGISTER_DESC_WITH_LENGTH_UACCESS(GICD_CTLR,
> +		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc,
> +		NULL, vgic_mmio_uaccess_write_v3_misc,
> +		16, VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICD_STATUSR,
>  		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
>  		VGIC_ACCESS_32bit),
> --
> 2.7.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://emea01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flist
> s.cs.columbia.edu%2Fmailman%2Flistinfo%2Fkvmarm&amp;data=02%7C01%
> 7Cbharat.bhushan%40nxp.com%7Cf2d3e98a8d1a48166ce108d5eb1d06f4%7C
> 686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C636673432268886197&am
> p;sdata=DitjaxtCqfVUge823Qw9IpT%2Fg9EoN2xI%2FIlj6mCdZ9k%3D&amp;r
> eserved=0
