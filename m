Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B3DC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3330D610A5
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3330D610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D61D54B0DB;
	Wed, 18 Aug 2021 16:00:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MT-47k-yTORA; Wed, 18 Aug 2021 16:00:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24C744B119;
	Wed, 18 Aug 2021 15:59:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6D6B4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 15:05:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M595bzJnt1TP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 15:05:43 -0400 (EDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com
 [209.85.217.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52F2249DE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 15:05:43 -0400 (EDT)
Received: by mail-vs1-f49.google.com with SMTP id j186so2425685vsc.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 12:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9CV1B2mH8PK4XbUS0fPPBFZHJZg1PKiQmC6aaYtPD7k=;
 b=jlC/SdCD3at4dNG9kwSjwhqtOpbuTijAXLqLPHWLUEMhf2AvMCdfIZ+/0CUUgvBS5m
 70xiWmtQq58RG8dRBT2p4w4Dq0K135uW+5foCGQy4cdg4AlrF3vmPu87Lk/RQWuHEv0F
 zkeHKX6vol4QAexO0QKEnFFJDdHZobyH7A5Rq2f3aVQeg4nGwFhrxHpFZeJrg8jZENCW
 6Rzr+wt2lDFbrnjJpEVbMzf+tjTI+hzyZKypDgwf7ywF+n7Zb7U6HIOthtbc90P2NcAe
 9pAQRlZVFq6PeW0GAghT+3Mdgl9E3HCcDHERiMWFCc+/KeTiOmM+OjcCLqo9lruPQaYz
 CdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9CV1B2mH8PK4XbUS0fPPBFZHJZg1PKiQmC6aaYtPD7k=;
 b=Gf3gSpscaZ63NQiX1aOG82Gw9jDAyjTtMx7JlOs6WVpNjSeCOFLJaZdsLlUr0VKu3r
 VIHG0q8vJ98cSXRYCXLlPzilV7H+cU1fJqGggdd3QErOYGayhmtSlNSGg6Gs8gpJWM0t
 BsDK1gs9y5qKiHYNKrnmICWMFRWHKpjQA+mrusv7T+v8ew6XfYbXgm2KwI4Woq8yFLQJ
 xqRzmKGvx0tHyX2LZXxV5z1OFy/y7shNhZ5smymlqaKTRjm4l1Avvtf63HEuELzvJ2sv
 uqx0Y2XEMtSSRHq6duLusBgZpaxYg0fJjvTBo8FsZO9Y6TzMz05VRbHwq9SBbSbTKJI4
 6SUg==
X-Gm-Message-State: AOAM531DfEjDRbFejP+xG1pYSzJh0uQgul+u5poD9hVXv7Ptw6XvKnwW
 M8yny4sRdjGYAVzNp0K952jt/qwddlHjwzW0xMN0Zg==
X-Google-Smtp-Source: ABdhPJzxU71p18xMzChBvv1uRBdKk5rlC4hzgstASnkvOKd+KGr7ohhYYBMh0iPqs21uTd7beQSd7ILYgInPHYYKiRo=
X-Received: by 2002:a67:2e43:: with SMTP id u64mr9474774vsu.30.1629313542587; 
 Wed, 18 Aug 2021 12:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210818181432.432256-1-maz@kernel.org>
In-Reply-To: <20210818181432.432256-1-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 18 Aug 2021 12:05:32 -0700
Message-ID: <CAJHc60zUZS3K4q88QYwP2CkGn7ywt-_fedjk7OK_W7cdQRJvxA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Resample HW pending state on
 deactivation
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-Mailman-Approved-At: Wed, 18 Aug 2021 15:59:47 -0400
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 stable@vger.kernel.org
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

On Wed, Aug 18, 2021 at 11:14 AM Marc Zyngier <maz@kernel.org> wrote:
>
> When a mapped level interrupt (a timer, for example) is deactivated
> by the guest, the corresponding host interrupt is equally deactivated.
> However, the fate of the pending state still needs to be dealt
> with in SW.
>
> This is specially true when the interrupt was in the active+pending
> state in the virtual distributor at the point where the guest
> was entered. On exit, the pending state is potentially stale
> (the guest may have put the interrupt in a non-pending state).
>
> If we don't do anything, the interrupt will be spuriously injected
> in the guest. Although this shouldn't have any ill effect (spurious
> interrupts are always possible), we can improve the emulation by
> detecting the deactivation-while-pending case and resample the
> interrupt.
>
> Fixes: e40cc57bac79 ("KVM: arm/arm64: vgic: Support level-triggered mapped interrupts")
> Reported-by: Raghavendra Rao Ananta <rananta@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/vgic/vgic-v2.c | 25 ++++++++++++++++++-------
>  arch/arm64/kvm/vgic/vgic-v3.c | 25 ++++++++++++++++++-------
>  2 files changed, 36 insertions(+), 14 deletions(-)
>
Tested-by: Raghavendra Rao Ananta <rananta@google.com>

Thanks,
Raghavendra
> diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> index 2c580204f1dc..3e52ea86a87f 100644
> --- a/arch/arm64/kvm/vgic/vgic-v2.c
> +++ b/arch/arm64/kvm/vgic/vgic-v2.c
> @@ -60,6 +60,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>                 u32 val = cpuif->vgic_lr[lr];
>                 u32 cpuid, intid = val & GICH_LR_VIRTUALID;
>                 struct vgic_irq *irq;
> +               bool deactivated;
>
>                 /* Extract the source vCPU id from the LR */
>                 cpuid = val & GICH_LR_PHYSID_CPUID;
> @@ -75,7 +76,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>
>                 raw_spin_lock(&irq->irq_lock);
>
> -               /* Always preserve the active bit */
> +               /* Always preserve the active bit, note deactivation */
> +               deactivated = irq->active && !(val & GICH_LR_ACTIVE_BIT);
>                 irq->active = !!(val & GICH_LR_ACTIVE_BIT);
>
>                 if (irq->active && vgic_irq_is_sgi(intid))
> @@ -105,6 +107,12 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>                  * device state could have changed or we simply need to
>                  * process the still pending interrupt later.
>                  *
> +                * We could also have entered the guest with the interrupt
> +                * active+pending. On the next exit, we need to re-evaluate
> +                * the pending state, as it could otherwise result in a
> +                * spurious interrupt by injecting a now potentially stale
> +                * pending state.
> +                *
>                  * If this causes us to lower the level, we have to also clear
>                  * the physical active state, since we will otherwise never be
>                  * told when the interrupt becomes asserted again.
> @@ -115,12 +123,15 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>                 if (vgic_irq_is_mapped_level(irq)) {
>                         bool resample = false;
>
> -                       if (val & GICH_LR_PENDING_BIT) {
> -                               irq->line_level = vgic_get_phys_line_level(irq);
> -                               resample = !irq->line_level;
> -                       } else if (vgic_irq_needs_resampling(irq) &&
> -                                  !(irq->active || irq->pending_latch)) {
> -                               resample = true;
> +                       if (unlikely(vgic_irq_needs_resampling(irq))) {
> +                               if (!(irq->active || irq->pending_latch))
> +                                       resample = true;
> +                       } else {
> +                               if ((val & GICH_LR_PENDING_BIT) ||
> +                                   (deactivated && irq->line_level)) {
> +                                       irq->line_level = vgic_get_phys_line_level(irq);
> +                                       resample = !irq->line_level;
> +                               }
>                         }
>
>                         if (resample)
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 66004f61cd83..74f9aefffd5e 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -46,6 +46,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>                 u32 intid, cpuid;
>                 struct vgic_irq *irq;
>                 bool is_v2_sgi = false;
> +               bool deactivated;
>
>                 cpuid = val & GICH_LR_PHYSID_CPUID;
>                 cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> @@ -68,7 +69,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>
>                 raw_spin_lock(&irq->irq_lock);
>
> -               /* Always preserve the active bit */
> +               /* Always preserve the active bit, note deactivation */
> +               deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
>                 irq->active = !!(val & ICH_LR_ACTIVE_BIT);
>
>                 if (irq->active && is_v2_sgi)
> @@ -98,6 +100,12 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>                  * device state could have changed or we simply need to
>                  * process the still pending interrupt later.
>                  *
> +                * We could also have entered the guest with the interrupt
> +                * active+pending. On the next exit, we need to re-evaluate
> +                * the pending state, as it could otherwise result in a
> +                * spurious interrupt by injecting a now potentially stale
> +                * pending state.
> +                *
>                  * If this causes us to lower the level, we have to also clear
>                  * the physical active state, since we will otherwise never be
>                  * told when the interrupt becomes asserted again.
> @@ -108,12 +116,15 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>                 if (vgic_irq_is_mapped_level(irq)) {
>                         bool resample = false;
>
> -                       if (val & ICH_LR_PENDING_BIT) {
> -                               irq->line_level = vgic_get_phys_line_level(irq);
> -                               resample = !irq->line_level;
> -                       } else if (vgic_irq_needs_resampling(irq) &&
> -                                  !(irq->active || irq->pending_latch)) {
> -                               resample = true;
> +                       if (unlikely(vgic_irq_needs_resampling(irq))) {
> +                               if (!(irq->active || irq->pending_latch))
> +                                       resample = true;
> +                       } else {
> +                               if ((val & ICH_LR_PENDING_BIT) ||
> +                                   (deactivated && irq->line_level)) {
> +                                       irq->line_level = vgic_get_phys_line_level(irq);
> +                                       resample = !irq->line_level;
> +                               }
>                         }
>
>                         if (resample)
> --
> 2.30.2
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
