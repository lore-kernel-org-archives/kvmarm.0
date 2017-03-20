From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 04/19] KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_REGS
 group
Date: Mon, 20 Mar 2017 18:12:52 +0000
Message-ID: <0fc9f005-bc80-c66f-ad23-9baaae07fcde@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-5-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A04740B5E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 14:09:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yu97NF7tDrCE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Mar 2017 14:09:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB5CB40AE8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 14:09:18 -0400 (EDT)
In-Reply-To: <1488800074-21991-5-git-send-email-eric.auger@redhat.com>
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
> The ITS KVM device exposes a new KVM_DEV_ARM_VGIC_GRP_ITS_REGS
> group which allows the userspace to save/restore ITS registers.
> 
> At this stage the get/set/has operations are not yet implemented.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

> ---
>  arch/arm/include/uapi/asm/kvm.h   |  1 +
>  arch/arm64/include/uapi/asm/kvm.h |  1 +
>  virt/kvm/arm/vgic/vgic-its.c      | 36 +++++++++++++++++++++++++++++++++++-
>  3 files changed, 37 insertions(+), 1 deletion(-)

....

> @@ -1520,10 +1544,20 @@ static int vgic_its_get_attr(struct kvm_device *dev,
>  		if (copy_to_user(uaddr, &addr, sizeof(addr)))
>  			return -EFAULT;
>  		break;
> +	}
> +	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +		u64 reg;
> +		int ret;
> +
> +		ret = vgic_its_attr_regs_access(dev, attr, &reg, false);
> +		if (ret)
> +			return ret;
> +		return put_user(reg, uaddr);
> +	}
>  	default:
>  		return -ENXIO;
>  	}
> -	}

And thanks for finding and fixing this nasty mishap. Fortunately C
doesn't care about blocks in switch statements too much, so I think this
works as intended (so it's not a "real" bug).

Cheers,
Andre.
