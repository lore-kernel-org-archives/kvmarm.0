From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v1 2/4] KVM: arm/arm64: vgic: Improve comment on
 kvm_vgic_inject_irq
Date: Fri, 22 Feb 2019 08:37:56 +0000
Message-ID: <20190222083756.359523ca@why.wild-wind.fr.eu.org>
References: <20190222082327.3312-1-leo.yan@linaro.org>
        <20190222082327.3312-3-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222082327.3312-3-leo.yan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leo Yan <leo.yan@linaro.org>
Cc: Christoffer Dall <christoffer.dall@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Andre Przywara <andre.przywara@arm.com>, Jun Yao <yaojun8558363@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 22 Feb 2019 16:23:24 +0800
Leo Yan <leo.yan@linaro.org> wrote:

> The function kvm_vgic_inject_irq() is not only used by PPIs but also can
> be used to inject interrupt for SPIs; this patch improves comment for
> argument @cpuid to reflect support SPIs as well.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 7cfdfbc910e0..79fe64c15051 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -394,7 +394,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
>  /**
>   * kvm_vgic_inject_irq - Inject an IRQ from a device to the vgic
>   * @kvm:     The VM structure pointer
> - * @cpuid:   The CPU for PPIs
> + * @cpuid:   The CPU for PPIs and SPIs
>   * @intid:   The INTID to inject a new state to.
>   * @level:   Edge-triggered:  true:  to trigger the interrupt
>   *			      false: to ignore the call

What does the CPU mean for SPIs? By definition, the routing of an SPI
is defined by the distributor configuration. And what about LPIs? SGIs?

I'm afraid you've misunderstood what cpuid is for.

	M.
-- 
Without deviation from the norm, progress is not possible.
