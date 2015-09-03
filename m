From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/9] arm/arm64: KVM: vgic: Factor out level irq processing
 on guest exit
Date: Thu, 03 Sep 2015 16:01:24 +0100
Message-ID: <55E860C4.8060000@arm.com>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org> <1440942866-23802-4-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-4-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/08/15 14:54, Christoffer Dall wrote:
> Currently vgic_process_maintenance() processes dealing with a completed
> level-triggered interrupt directly, but we are soon going to reuse this
> logic for level-triggered mapped interrupts with the HW bit set, so
> move this logic into a separate static function.
> 
> Probably the most scary part of this commit is convincing yourself that
> the current flow is safe compared to the old one.  In the following I
> try to list the changes and why they are harmless:
> 
>   Move vgic_irq_clear_queued after kvm_notify_acked_irq:
>     Harmless because the effect of clearing the queued flag wrt.
>     kvm_set_irq is only that vgic_update_irq_pending does not set the
>     pending bit on the emulated CPU interface or in the pending_on_cpu
>     bitmask, but we set this in __kvm_vgic_sync_hwstate later on if the
>     level is stil high.
> 
>   Move vgic_set_lr before kvm_notify_acked_irq:
>     Also, harmless because the LR are cpu-local operations and
>     kvm_notify_acked only affects the dist
> 
>   Move vgic_dist_irq_clear_soft_pend after kvm_notify_acked_irq:
>     Also harmless because it's just a bit which is cleared and altering
>     the line state does not affect this bit.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

This one has wrecked my brain, but I can't fault it so far.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
