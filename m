From: Tom Hanson <thomas.hanson@linaro.org>
Subject: Re: [PATCH v2 16/54] KVM: arm/arm64: vgic-new: Add IRQ sync/flush
 framework
Date: Thu, 5 May 2016 10:23:32 -0600
Message-ID: <572B7384.2050405@linaro.org>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-17-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7582E49B50
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2016 12:20:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PkD5Ll0kG-EG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2016 12:20:57 -0400 (EDT)
Received: from mail-pf0-f170.google.com (mail-pf0-f170.google.com
 [209.85.192.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B37549AF5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2016 12:20:57 -0400 (EDT)
Received: by mail-pf0-f170.google.com with SMTP id 206so39532318pfu.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 May 2016 09:23:39 -0700 (PDT)
In-Reply-To: <1461861973-26464-17-git-send-email-andre.przywara@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/28/2016 10:45 AM, Andre Przywara wrote:

...

> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 4fb20fd..a656a12e5 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c

...
> +static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
> +{

...

> +		/* This interrupt looks like it has to be migrated. */
> +
> +		spin_unlock(&irq->irq_lock);
> +		spin_unlock(&vgic_cpu->ap_list_lock);

If using the suggested (but not provided) higher level function from patch 14 this could be:
                 vgic_unlock_aplist_irq(, spinlock_t irq);
> +
> +		/*
> +		 * Ensure locking order by always locking the smallest
> +		 * ID first.
> +		 */
> +		if (vcpu->vcpu_id < target_vcpu->vcpu_id) {
> +			vcpuA = vcpu;
> +			vcpuB = target_vcpu;
> +		} else {
> +			vcpuA = target_vcpu;
> +			vcpuB = vcpu;
> +		}
> +
> +		spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
> +		spin_lock(&vcpuB->arch.vgic_cpu.ap_list_lock);

And this whole block could be replaced by:
                 vgic_lock_cpu_aplist_pair(vcpuA, vcpuB)

> +             spin_lock(&irq->irq_lock);

...

> +		spin_unlock(&irq->irq_lock);
> +		spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
> +		spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
And this could be:
                 vgic_unlock_cpu_aplist_pair(vcpuA, vcpuB)

> +		goto retry;
> +	}
> +
> +	spin_unlock(&vgic_cpu->ap_list_lock);
> +}
