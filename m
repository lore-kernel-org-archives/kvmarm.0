From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 2/3] KVM: arm/arm64: Merge vgic_set_lr() and
 vgic_sync_lr_elrsr()
Date: Tue, 27 Oct 2015 09:56:47 +0300
Message-ID: <00b001d11084$a6347c00$f29d7400$@samsung.com>
References: <cover.1445849885.git.p.fedin@samsung.com>
 <31bc5d39898f4a51f8d75d338229856ff49c097e.1445849885.git.p.fedin@samsung.com>
 <20151026152238.GD20298@cbox> <014d01d11005$f4f93a30$deebae90$@samsung.com>
 <20151026194205.GG20298@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151026194205.GG20298@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > --- cut ---
> > Additionally, remove unnecessary vgic_set_lr() and LR_STATE_PENDING check
> > in vgic_unqueue_irqs(), because all these things are now done by the
> > following vgic_retire_lr().
> > --- cut ---
> 
> This does not explain the question I'm raising.
> 
> After applying this patch, and before applying your next patch,
> unqueueing an IRQ will not restore the pending state on the
> distributor, but just throw that piece of state away

 It will restore the state and not throw it away.
 I guess i'm just not clear enough and you misunderstand me. This check in vgic_unqueue_irqs() is redundant from the beginning.
Let's look at current vgic_retire_lr():
https://git.kernel.org/cgit/linux/kernel/git/kvmarm/kvmarm.git/tree/virt/kvm/arm/vgic.c?h=next#n1099
 It already does LR_STATE_PENDING check and pushback by itself, since cff9211eb1a1f58ce7f5a2d596b617928fd4be0e (it's your commit,
BTW), so that this check:
https://git.kernel.org/cgit/linux/kernel/git/kvmarm/kvmarm.git/tree/virt/kvm/arm/vgic.c?h=next#n728
 is already redundant. So actually this is a separate change, and perhaps it's my fault to squash it in.

> which breaks bisectability and makes it impossible to understand the logic by looking
> at this commit in isolation.

 Will this be understood better if i make this particular refactor a separate commit, with better explanations?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

