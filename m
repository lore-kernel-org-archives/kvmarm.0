Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDB9C3A5A3
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 13:42:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDB22233A2
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 13:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDB22233A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34E4C4A5DB;
	Thu, 22 Aug 2019 09:42:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EfNwNPzyJnx8; Thu, 22 Aug 2019 09:42:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAA224A5B5;
	Thu, 22 Aug 2019 09:42:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4514A4A5B5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 09:42:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fI1PrNlA4hln for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 09:42:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3A564A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 09:42:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2827D337;
 Thu, 22 Aug 2019 06:42:28 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AF093F73D;
 Thu, 22 Aug 2019 06:42:26 -0700 (PDT)
Date: Thu, 22 Aug 2019 14:42:24 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [RESEND PATCH] KVM: arm: VGIC: properly initialise private IRQ
 affinity
Message-ID: <20190822144224.12d51380@donnerap.cambridge.arm.com>
In-Reply-To: <6d2ff99a-a97b-bb4d-3df1-8e22e804aa6a@huawei.com>
References: <20190821170052.169065-1-andre.przywara@arm.com>
 <6d2ff99a-a97b-bb4d-3df1-8e22e804aa6a@huawei.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
 Julien Grall <julien.grall@arm.com>, Dave Martin <dave.martin@arm.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, 22 Aug 2019 01:13:32 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

Hi,

> On 2019/8/22 1:00, Andre Przywara wrote:
> > At the moment we initialise the target *mask* of a virtual IRQ to the
> > VCPU it belongs to, even though this mask is only defined for GICv2 and
> > quickly runs out of bits for many GICv3 guests.
> > This behaviour triggers an UBSAN complaint for more than 32 VCPUs:
> > ------
> > [ 5659.462377] UBSAN: Undefined behaviour in virt/kvm/arm/vgic/vgic-init.c:223:21
> > [ 5659.471689] shift exponent 32 is too large for 32-bit type 'unsigned int'
> > ------
> > Also for GICv3 guests the reporting of TARGET in the "vgic-state" debugfs
> > dump is wrong, due to this very same problem.
> > 
> > Fix both issues by only initialising vgic_irq->targets for a vGICv2 guest,
> > and by initialising vgic_irq->mpdir for vGICv3 guests instead. We can't
> > use the actual MPIDR for that, as the VCPU's system register is not
> > initialised at this point yet. This is not really an issue, as ->mpidr
> > is just used for the debugfs output and the IROUTER MMIO register, which
> > does not exist in redistributors (dealing with SGIs and PPIs).
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > Reported-by: Dave Martin <dave.martin@arm.com>
> > ---
> > Hi,
> > 
> > this came up here again, I think it fell through the cracks back in
> > March:
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2019-March/637209.html
> > 
> > Cheers,
> > Andre.
> > 
> >   virt/kvm/arm/vgic/vgic-init.c | 9 ++++++---
> >   1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> > index 80127ca9269f..8bce2f75e0c1 100644
> > --- a/virt/kvm/arm/vgic/vgic-init.c
> > +++ b/virt/kvm/arm/vgic/vgic-init.c
> > @@ -210,7 +210,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
> >   		irq->intid = i;
> >   		irq->vcpu = NULL;
> >   		irq->target_vcpu = vcpu;
> > -		irq->targets = 1U << vcpu->vcpu_id;
> >   		kref_init(&irq->refcount);
> >   		if (vgic_irq_is_sgi(i)) {
> >   			/* SGIs */
> > @@ -221,10 +220,14 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
> >   			irq->config = VGIC_CONFIG_LEVEL;
> >   		}
> >   
> > -		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> > +		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {  
> 
> I still think that if user-space create VCPUs before vGIC (like what
> Qemu does), the actual vGIC model will be unknown here. The UBSAN
> warning will still show up when booting a vGIC-v3 guest (with Qemu).

Yes, you are right. I vaguely remembered this issue, but couldn't find anything on the list about it. So thanks for the heads up!

So I think I have a solution, where we drop the initialisation part here altogether, instead initialise mpdir/targets together with the group in vgic_init(). Unless there is some code which needs irq->group before that point?

Will send a patch shortly.

Cheers,
Andre.

> >   			irq->group = 1;
> > -		else
> > +			/* The actual MPIDR is not initialised at this point. */
> > +			irq->mpidr = 0;
> > +		} else {
> >   			irq->group = 0;
> > +			irq->targets = 1U << vcpu->vcpu_id;
> > +		}
> >   	}
> >   
> >   	if (!irqchip_in_kernel(vcpu->kvm))
> >   
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
