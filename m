From: Tom Hanson <thomas.hanson@linaro.org>
Subject: Re: [PATCH v2 07/54] KVM: arm/arm64: vgic: Remove irq_phys_map from
 interface
Date: Tue, 3 May 2016 16:22:37 -0600
Message-ID: <572924AD.9050902@linaro.org>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-8-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1E7049B2E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 18:20:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h5kH23--FoU8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2016 18:20:07 -0400 (EDT)
Received: from mail-pf0-f178.google.com (mail-pf0-f178.google.com
 [209.85.192.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBD0749B2C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 18:20:07 -0400 (EDT)
Received: by mail-pf0-f178.google.com with SMTP id y69so16318745pfb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2016 15:22:44 -0700 (PDT)
In-Reply-To: <1461861973-26464-8-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/28/2016 10:45 AM, Andre Przywara wrote:
...
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 3a74b17..9475000 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -333,10 +333,10 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
...
> +	ret = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
> +	if (ret)
> +		return ret;
>
>   	return 0;
>   }

This isn't wrong, but it is overly complicated.  I'd recommend either:
     ret = kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
     return ret;
OR
     return kvm_vgic_map_phys_irq(vcpu, irq->irq, phys_irq);
