From: Tom Hanson <thomas.hanson@linaro.org>
Subject: Re: [PATCH v2 26/54] KVM: arm/arm64: vgic-new: Add ACTIVE registers
 handlers
Date: Thu, 5 May 2016 10:48:49 -0600
Message-ID: <572B7971.1060702@linaro.org>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-27-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-27-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/28/2016 10:45 AM, Andre Przywara wrote:

...

> +void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
> +			     gpa_t addr, unsigned int len,
> +			     unsigned long val)

...

> +		spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
> +		spin_lock(&irq->irq_lock);

If using the suggested higher level function from patch 14 this could be:
                 vgic_lock_aplist_irq(&vcpu->arch.vgic_cpu.ap_list_lock, &irq->irq_lock);

> +
> +		/*
> +		 * Recheck after dropping the IRQ lock to see if we should
> +		 * still care about queueing it.
> +		 */
> +		if (irq->active || irq->vcpu) {
> +			irq->active = true;
> +
> +			spin_unlock(&irq->irq_lock);
> +			spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
And this could be:
                         vgic_unlock_aplist_irq(&vcpu->arch.vgic_cpu.ap_list_lock, &irq->irq_lock);
> +
> +			continue;
> +		}
> +
> +		/* Did the target VCPU change while we had the lock dropped? */
> +		if (vcpu != irq->target_vcpu) {
> +			spin_unlock(&irq->irq_lock);
> +			spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
And this could be:
                          vgic_unlock_aplist_irq(&vcpu->arch.vgic_cpu.ap_list_lock, &irq->irq_lock);

> +
> +			goto retry;
> +		}
> +
> +		/* Now queue the IRQ to the VCPU's ap_list. */
> +		list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
> +		irq->vcpu = vcpu;
> +
> +		irq->active = true;
> +
> +		spin_unlock(&irq->irq_lock);
> +		spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
And this could be:
                 vgic_unlock_aplist_irq(&vcpu->arch.vgic_cpu.ap_list_lock, &irq->irq_lock);

> +
> +		kvm_vcpu_kick(vcpu);
> +	}
> +}
> +
