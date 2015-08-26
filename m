From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: BUG: Fix losing level-sensitive interrupts
Date: Wed, 26 Aug 2015 14:33:06 +0300
Message-ID: <00d901d0dff2$fa5616d0$ef024470$@samsung.com>
References: <1440571563-7004-1-git-send-email-p.fedin@samsung.com>
 <20150826092721.43e8cbfd@arm.com>
 <00d701d0dfee$2f464810$8dd2d830$@samsung.com> <55DD9F5B.4080602@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55DD9F5B.4080602@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Christoffer Dall' <christoffer.dall@linaro.org>, =?ISO-8859-1?Q?'Alex_Benn=E9e'?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> As for v4.1 not having that problem, the pl011 driver has gone though a
> lot if rework lately, and I wouldn't be surprised if it now exhibited a
> different behaviour thanks to the broken userspace behaviour.

 Sorry, you misunderstood me. Or i wrote badly. I meant that _KVM_ did not have this particular
problem in kernel v4.0, because:
http://lxr.free-electrons.com/source/virt/kvm/arm/vgic.c?v=4.0#L998
 you see, LR_STATE_PENDING is assigned unconditionally. Is this code correct? I believe yes. Compare
with:
http://lxr.free-electrons.com/source/virt/kvm/arm/vgic.c#L1104
 Now it is possible to have neither PENDING nor ACTIVE irq. Does it even make sense? So what is
wrong with the modification as follows?
--- cut ---
         if (vgic_irq_is_active(vcpu, irq)) {
                 vlr.state |= LR_STATE_ACTIVE;
                 kvm_debug("Set active, clear distributor: 0x%x\n", vlr.state);
                 vgic_irq_clear_active(vcpu, irq);
                 vgic_update_state(vcpu->kvm);
         } else {
                 vlr.state |= LR_STATE_PENDING;
                 kvm_debug("Set pending: 0x%x\n", vlr.state);
         }
--- cut ---
 Alex, are you reading us? Can you explain, why you introduced that extra check?

> And what you're suggesting is to actually introduce a bug.

 Why would that be a bug, if it was not a bug in kernel 4.0?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


