From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 7/9] KVM: arm/arm64: vgic: Permit uaccess writes to
 return errors
Date: Mon, 16 Jul 2018 09:28:00 +0100
Message-ID: <08e71965-e39e-430f-3db5-765283ba3a0f@arm.com>
References: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
 <1531587940-2490-8-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB80D4A11C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 04:15:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3l6d0tyMIu2Z for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 04:15:06 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 837E04A0FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 04:15:06 -0400 (EDT)
In-Reply-To: <1531587940-2490-8-git-send-email-christoffer.dall@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/07/18 18:05, Christoffer Dall wrote:
> Currently we do not allow any vgic mmio write operations to fail, which
> makes sense from mmio traps from the guest.  However, we should be able
> to report failures to userspace, if userspace writes incompatible values
> to read-only registers.  Rework the internal interface to allow errors
> to be returned on the write side for userspace writes.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 26 +++++++++++++++++++++-----
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 31 ++++++++++++++++++++++++-------
>  virt/kvm/arm/vgic/vgic-mmio.c    | 18 +++++++++++++-----
>  virt/kvm/arm/vgic/vgic-mmio.h    | 19 +++++++++++--------
>  4 files changed, 69 insertions(+), 25 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index 34e36fc..b79de42 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -77,11 +77,26 @@ static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> -static void vgic_mmio_uaccess_write_v2_group(struct kvm_vcpu *vcpu,
> -					     gpa_t addr, unsigned int len,
> -					     unsigned long val)
> +static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
> +					   gpa_t addr, unsigned int len,
> +					   unsigned long val)
> +{
> +	switch (addr & 0x0c) {
> +	case GIC_DIST_IIDR:
> +		if (val != vgic_mmio_read_v2_misc(vcpu, addr, len))
> +			return -EINVAL;
> +	}
> +
> +	vgic_mmio_write_v2_misc(vcpu, addr, len, val);
> +	return 0;
> +}
> +
> +static int vgic_mmio_uaccess_write_v2_group(struct kvm_vcpu *vcpu,
> +					    gpa_t addr, unsigned int len,
> +					    unsigned long val)
>  {
>  	/* Ignore writes from userspace */
> +	return 0;
>  }

I think it'd make more sense if this patch came before the previous one
(change the prototype of the userspace accessor, and only then add a new
accessor that can return an error). It would avoid churn in the above
function, and you could move vgic_mmio_uaccess_write_v2_misc into patch 6.

Not a big deal though, as the code is otherwise perfectly fine.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
