From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v6 6/8] KVM: arm/arm64: Support VGIC dist pend/active
 changes for mapped IRQs
Date: Tue, 5 Dec 2017 13:43:54 +0100
Message-ID: <20171205124354.ghtqq3fxy7fsaudy@kamzik.brq.redhat.com>
References: <20171204200506.3224-1-cdall@kernel.org>
 <20171204200506.3224-7-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171204200506.3224-7-cdall@kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 04, 2017 at 09:05:04PM +0100, Christoffer Dall wrote:
> +/* Must be called with irq->irq_lock held */
> +static void vgic_hw_irq_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> +				      bool active, bool is_uaccess)
> +{
> +	if (!is_uaccess)
> +		irq->active = active;;
> +
> +	if (!is_uaccess)
> +		vgic_irq_set_phys_active(irq, active);
> +}
> +

Missed one.

drew
