From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v4 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Mon, 31 Aug 2015 14:24:01 +0300
Message-ID: <017b01d0e3df$8a06d4a0$9e147de0$@samsung.com>
References: <cover.1439804074.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1439804074.git.p.fedin@samsung.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello! Two weeks has passed, i have fixed up Marc's notes, so PING...

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Pavel Fedin
> Sent: Monday, August 17, 2015 12:44 PM
> To: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org
> Cc: Marc Zyngier; Christoffer Dall
> Subject: [PATCH v4 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel irqchip
> 
> This patch set brings back functionality which was broken in v4.0.
> Unfortunately because of restrictions of such a hardware is is impossible
> to take advantage of virtual architected timer, therefore guest, running
> in such restricted mode, has to use some memory-mapped timer. But it is
> still better than nothing.
> 
> v3 => v4:
> - Revert back to using switch on kvm_vgic_hyp_init() return code. I decided
>   to leave 'vgic_present = false' statement because it helps to understand
>   the code.
> 
> v2 => v3:
> - Improved commit messages, added references to commits where the respective
>   functionality was broken
> - Explicitly specify that the solution currently affects only vGIC and has
>   nothing to do with timer.
> - Fixed code style according to previous notes
> - Removed ARM64 save/restore patch introduced in v2 because it was already
>   obsolete for linux-next
> - Modify KVM_CAP_IRQFD handling in correct place
> 
> v1 => v2:
> - Do not use defensive approach in patch 0001. Use correct conditions in
>   callers instead
> - Added ARM64-specific code, without which attempt to run a VM ends in a
>   HYP crash because of unset vGIC save/restore function pointers
> 
> 
> Pavel Fedin (3):
>   Fix NULL pointer dereference if KVM is used without in-kernel irqchip
>   Detect vGIC presence at runtime
>   Make KVM_CAP_IRQFD dependent on KVM_CAP_IRQCHIP
> 
>  arch/arm/kvm/arm.c  | 24 +++++++++++++++++++++---
>  virt/kvm/kvm_main.c |  5 +++--
>  2 files changed, 24 insertions(+), 5 deletions(-)
> 
> --
> 2.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

