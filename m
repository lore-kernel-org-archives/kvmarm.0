From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH] KVM: arm/arm64: vgic: Don't notify EOI for non-SPIs
Date: Thu, 1 Dec 2016 10:28:45 +0000
Message-ID: <5FC3163CFD30C246ABAA99954A238FA817475F7E@lhreml504-mbs>
References: <1480584341-32340-1-git-send-email-marc.zyngier@arm.com>
 <1480584341-32340-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 588B3404E2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 05:28:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sJir2+8gngG9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 05:28:10 -0500 (EST)
Received: from lhrrgout.huawei.com (lhrrgout.huawei.com [194.213.3.17])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F647404DE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 05:28:10 -0500 (EST)
In-Reply-To: <1480584341-32340-2-git-send-email-marc.zyngier@arm.com>
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
To: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-
> bounces@lists.cs.columbia.edu] On Behalf Of Marc Zyngier
> Sent: Thursday, December 01, 2016 9:26 AM
> To: Paolo Bonzini; Radim Kr=E8m=E1=F8
> Cc: Catalin Marinas; kvmarm@lists.cs.columbia.edu; linux-arm-
> kernel@lists.infradead.org; kvm@vger.kernel.org
> Subject: [PATCH] KVM: arm/arm64: vgic: Don't notify EOI for non-SPIs
> =

> When we inject a level triggerered interrupt (and unless it is backed
> by the physical distributor - timer style), we request a maintenance
> interrupt. Part of the processing for that interrupt is to feed to the
> rest of KVM (and to the eventfd subsystem) the information that the
> interrupt has been EOIed.
> =

> But that notification only makes sense for SPIs, and not PPIs (such as
> the PMU interrupt). Skip over the notification if the interrupt is not
> an SPI.

Just to clarify my understanding, the maintenance interrupt is generated =

for cases where there is no mapping of virt to phys interrupts
(ie, ICH_LR HW bit is not set). And I was under the impression that
kvm_notify_acked_irq will eventually deactivate the interrupt on distributor
for such cases. Its not clear to me how the deactivation is done
otherwise.

Could you please help me to understand this better.

Thanks,
Shameer


> Cc: stable@vger.kernel.org # 4.7+
> Fixes: 140b086dd197 ("KVM: arm/arm64: vgic-new: Add GICv2 world switch
> backend")
> Fixes: 59529f69f504 ("KVM: arm/arm64: vgic-new: Add GICv3 world switch
> backend")
> Reported-by: Catalin Marinas <catalin.marinas@arm.com>
> Tested-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 6 ++++--
>  virt/kvm/arm/vgic/vgic-v3.c | 6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> =

> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 0a063af..9bab867 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -50,8 +50,10 @@ void vgic_v2_process_maintenance(struct kvm_vcpu
> *vcpu)
> =

>  			WARN_ON(cpuif->vgic_lr[lr] & GICH_LR_STATE);
> =

> -			kvm_notify_acked_irq(vcpu->kvm, 0,
> -					     intid - VGIC_NR_PRIVATE_IRQS);
> +			/* Only SPIs require notification */
> +			if (vgic_valid_spi(vcpu->kvm, intid))
> +				kvm_notify_acked_irq(vcpu->kvm, 0,
> +						     intid - VGIC_NR_PRIVATE_IRQS);
>  		}
>  	}
> =

> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 9f0dae3..5c9f974 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -41,8 +41,10 @@ void vgic_v3_process_maintenance(struct kvm_vcpu
> *vcpu)
> =

>  			WARN_ON(cpuif->vgic_lr[lr] & ICH_LR_STATE);
> =

> -			kvm_notify_acked_irq(vcpu->kvm, 0,
> -					     intid - VGIC_NR_PRIVATE_IRQS);
> +			/* Only SPIs require notification */
> +			if (vgic_valid_spi(vcpu->kvm, intid))
> +				kvm_notify_acked_irq(vcpu->kvm, 0,
> +						     intid - VGIC_NR_PRIVATE_IRQS);
>  		}
> =

>  		/*
> --
> 2.1.4
> =

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
