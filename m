Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9ED4C4320A
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 19:41:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 626B66108D
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 19:41:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 626B66108D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A71C240877;
	Wed, 18 Aug 2021 15:41:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xwB7+SzBuUMA; Wed, 18 Aug 2021 15:40:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B294A1AF;
	Wed, 18 Aug 2021 15:40:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8790E49E8C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 15:40:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xdhugGg1ZQtX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 15:40:55 -0400 (EDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com
 [209.85.208.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9897440877
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 15:40:55 -0400 (EDT)
Received: by mail-lj1-f177.google.com with SMTP id c12so7143215ljr.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 12:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Q6+vD/Bnma2e6Trh4huFu+B0sfIPuUgIZs2tPcEJfAQ=;
 b=XGiRKLPl7vDuYMdoVHAsKGg6g8vXwsJKQQsPQA/8l0WpCgIHD37c3LYRBILsJ2GpUI
 PB7Cb7JFzNoxxp9hpkASPLK2x/S1mmzP3ZjERSrp58zQB07HkoZnuRto6cic3AqJQbhX
 y76kKBAzc5zfwEX82leZwMJFQBcah9ojQfTkDrvREPlqVcHx1M5CQeIbkP+WUgluwlMJ
 Xi16fBTHKjqF/aM4FAB9iF169JMMPpXJAjmqVTCnk59z/MImHG5Irj0bCilupZj7MD6u
 AtQI1PEc9tUu0eC/LY2u5mSVguS7lnR7k4Hgoy63K7H8P/c9HEjqNP/7iWRaLXxori6Y
 iI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Q6+vD/Bnma2e6Trh4huFu+B0sfIPuUgIZs2tPcEJfAQ=;
 b=GA78IWz/c5FgsSwTEk80Djzsk56UByQG/nSw2cLDKcAIryPD33KSvAHQfN9fm2LSBV
 YEdNMfCL79qI9PG9b+D5OwGrSk6PoKBAheUATdWfuOs+FLO2yGvAvopOuw+ST3eXVR0j
 GgyH0ovuCrRYxNd5olAK/wb92htrYcoyA2XxO4dHqv3wsIuOHcQe+gsu4n14orSeZemc
 d04aOD+1vZ7yK6ZyZ7tmbzXP9+6xBbqDJMF5c4y1zMy1GU8fnQDe0tmb3aROkZipSnCH
 SmxfoeDRwq0yk2QCx+c0M6akTf+55ppVnWhZOoztZKO0IqWnLTpJYTkk68DoApew0c9Q
 +eAQ==
X-Gm-Message-State: AOAM532ndcHKZ8RGiBN+KCFQ4oaxKp3y4s57kgG0aQTWX3W38AY/4KFT
 ODaX/mHMpZ4Grp8m6VNPNIkQQrnD/yyG0opvA+1DcQ==
X-Google-Smtp-Source: ABdhPJxrD+XuX8eAfWllsW3ODtUZyuvIfj8TmpggSk0RGyDarRBBtgoCJliqN4IAvuYDkQ8VMB6LtXgrrXPj5bJhnbE=
X-Received: by 2002:a2e:a782:: with SMTP id c2mr9239281ljf.388.1629315653719; 
 Wed, 18 Aug 2021 12:40:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210818181432.432256-1-maz@kernel.org>
 <CAJHc60zUZS3K4q88QYwP2CkGn7ywt-_fedjk7OK_W7cdQRJvxA@mail.gmail.com>
In-Reply-To: <CAJHc60zUZS3K4q88QYwP2CkGn7ywt-_fedjk7OK_W7cdQRJvxA@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 18 Aug 2021 12:40:42 -0700
Message-ID: <CAOQ_QsgGiGSfEq1QGfePiRF-=spCuR6XZ2QXfUsZ1zWds0ftag@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Resample HW pending state on
 deactivation
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hey Marc,

On Wed, Aug 18, 2021 at 12:05 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Wed, Aug 18, 2021 at 11:14 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > When a mapped level interrupt (a timer, for example) is deactivated
> > by the guest, the corresponding host interrupt is equally deactivated.
> > However, the fate of the pending state still needs to be dealt
> > with in SW.
> >
> > This is specially true when the interrupt was in the active+pending
> > state in the virtual distributor at the point where the guest
> > was entered. On exit, the pending state is potentially stale
> > (the guest may have put the interrupt in a non-pending state).
> >
> > If we don't do anything, the interrupt will be spuriously injected
> > in the guest. Although this shouldn't have any ill effect (spurious
> > interrupts are always possible), we can improve the emulation by
> > detecting the deactivation-while-pending case and resample the
> > interrupt.
> >
> > Fixes: e40cc57bac79 ("KVM: arm/arm64: vgic: Support level-triggered mapped interrupts")
> > Reported-by: Raghavendra Rao Ananta <rananta@google.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/arm64/kvm/vgic/vgic-v2.c | 25 ++++++++++++++++++-------
> >  arch/arm64/kvm/vgic/vgic-v3.c | 25 ++++++++++++++++++-------
> >  2 files changed, 36 insertions(+), 14 deletions(-)
> >
> Tested-by: Raghavendra Rao Ananta <rananta@google.com>
>
> Thanks,
> Raghavendra
> > diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> > index 2c580204f1dc..3e52ea86a87f 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v2.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v2.c
> > @@ -60,6 +60,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
> >                 u32 val = cpuif->vgic_lr[lr];
> >                 u32 cpuid, intid = val & GICH_LR_VIRTUALID;
> >                 struct vgic_irq *irq;
> > +               bool deactivated;
> >
> >                 /* Extract the source vCPU id from the LR */
> >                 cpuid = val & GICH_LR_PHYSID_CPUID;
> > @@ -75,7 +76,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
> >
> >                 raw_spin_lock(&irq->irq_lock);
> >
> > -               /* Always preserve the active bit */
> > +               /* Always preserve the active bit, note deactivation */
> > +               deactivated = irq->active && !(val & GICH_LR_ACTIVE_BIT);
> >                 irq->active = !!(val & GICH_LR_ACTIVE_BIT);
> >
> >                 if (irq->active && vgic_irq_is_sgi(intid))
> > @@ -105,6 +107,12 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
> >                  * device state could have changed or we simply need to
> >                  * process the still pending interrupt later.
> >                  *
> > +                * We could also have entered the guest with the interrupt
> > +                * active+pending. On the next exit, we need to re-evaluate
> > +                * the pending state, as it could otherwise result in a
> > +                * spurious interrupt by injecting a now potentially stale
> > +                * pending state.
> > +                *
> >                  * If this causes us to lower the level, we have to also clear
> >                  * the physical active state, since we will otherwise never be
> >                  * told when the interrupt becomes asserted again.
> > @@ -115,12 +123,15 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
> >                 if (vgic_irq_is_mapped_level(irq)) {
> >                         bool resample = false;
> >
> > -                       if (val & GICH_LR_PENDING_BIT) {
> > -                               irq->line_level = vgic_get_phys_line_level(irq);
> > -                               resample = !irq->line_level;
> > -                       } else if (vgic_irq_needs_resampling(irq) &&
> > -                                  !(irq->active || irq->pending_latch)) {
> > -                               resample = true;
> > +                       if (unlikely(vgic_irq_needs_resampling(irq))) {
> > +                               if (!(irq->active || irq->pending_latch))
> > +                                       resample = true;
> > +                       } else {
> > +                               if ((val & GICH_LR_PENDING_BIT) ||
> > +                                   (deactivated && irq->line_level)) {
> > +                                       irq->line_level = vgic_get_phys_line_level(irq);
> > +                                       resample = !irq->line_level;
> > +                               }
> >                         }
> >
> >                         if (resample)
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 66004f61cd83..74f9aefffd5e 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -46,6 +46,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >                 u32 intid, cpuid;
> >                 struct vgic_irq *irq;
> >                 bool is_v2_sgi = false;
> > +               bool deactivated;
> >
> >                 cpuid = val & GICH_LR_PHYSID_CPUID;
> >                 cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> > @@ -68,7 +69,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >
> >                 raw_spin_lock(&irq->irq_lock);
> >
> > -               /* Always preserve the active bit */
> > +               /* Always preserve the active bit, note deactivation */
> > +               deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
> >                 irq->active = !!(val & ICH_LR_ACTIVE_BIT);
> >
> >                 if (irq->active && is_v2_sgi)
> > @@ -98,6 +100,12 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >                  * device state could have changed or we simply need to
> >                  * process the still pending interrupt later.
> >                  *
> > +                * We could also have entered the guest with the interrupt
> > +                * active+pending. On the next exit, we need to re-evaluate
> > +                * the pending state, as it could otherwise result in a
> > +                * spurious interrupt by injecting a now potentially stale
> > +                * pending state.
> > +                *
> >                  * If this causes us to lower the level, we have to also clear
> >                  * the physical active state, since we will otherwise never be
> >                  * told when the interrupt becomes asserted again.
> > @@ -108,12 +116,15 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >                 if (vgic_irq_is_mapped_level(irq)) {
> >                         bool resample = false;
> >
> > -                       if (val & ICH_LR_PENDING_BIT) {
> > -                               irq->line_level = vgic_get_phys_line_level(irq);
> > -                               resample = !irq->line_level;
> > -                       } else if (vgic_irq_needs_resampling(irq) &&
> > -                                  !(irq->active || irq->pending_latch)) {
> > -                               resample = true;
> > +                       if (unlikely(vgic_irq_needs_resampling(irq))) {
> > +                               if (!(irq->active || irq->pending_latch))
> > +                                       resample = true;
> > +                       } else {
> > +                               if ((val & ICH_LR_PENDING_BIT) ||
> > +                                   (deactivated && irq->line_level)) {
> > +                                       irq->line_level = vgic_get_phys_line_level(irq);
> > +                                       resample = !irq->line_level;
> > +                               }

The vGICv3 and vGICv2 implementations look identical here, should we
have a helper that keeps the code common between the two?

Otherwise, the functional change LGTM, so:

Reviewed-by: Oliver Upton <oupton@google.com>

> >                         }
> >
> >                         if (resample)
> > --
> > 2.30.2
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
