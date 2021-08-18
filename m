Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A033FC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 19:59:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FA18610FE
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 19:59:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2FA18610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C75FC4B08D;
	Wed, 18 Aug 2021 15:59:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bbAtJaxfyFD5; Wed, 18 Aug 2021 15:59:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5AF74B0E7;
	Wed, 18 Aug 2021 15:59:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 114EE49E57
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:42:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LlQK1uxWPQAu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 14:42:14 -0400 (EDT)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com
 [209.85.222.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B9AE4099E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:42:14 -0400 (EDT)
Received: by mail-ua1-f50.google.com with SMTP id b7so1391692uav.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 11:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=+Ng1WTSvGZfgMb8v7uO3fX7kJHxGGsPeDrhYAtssMjo=;
 b=FCFhANXc7mQxpbwR01iX9xsG9YdDJu18csNeMdwwPRJp97wQ6bgZ1hEDmtGaKl84QQ
 mDbY0oWVa8Yl2hsjUhrY1hCsRnaWkSKfKh8mOem0jit7Go1mhRS5NUTKKBfaXGG3QQUY
 Cwf35BzM6HewqEh6yuZ9FvxFvFFt9JpDQn63SRNdO4hjVWh/+LlLXVeCF2Pr1HvRJf/X
 i67jgtF/qnCz2MH5focYtOQovIVaPOB2WGpGxkSe4BkQ3wZ+VIVM8aod8yxBzDuQJXOq
 zw28BweF2reGP8BOMWpPEzSLMRgKB7ZEus/26gI6pJwqpugS6Ibfj1KEwsZYYHEuSN1g
 7low==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=+Ng1WTSvGZfgMb8v7uO3fX7kJHxGGsPeDrhYAtssMjo=;
 b=gtsvbpMIx7seMnKJZe3xnMSNIOzpe08s5F89nCLeR4khc0ApZ8YTJtyoDBo+1iV6qj
 7v4BfjKE2GK6IvXuyMrrdrqbZ/lyiQhL8hXvpZU6O9eojPxTwLbKq2wnew0BdnIU/Fzy
 20w77seoN5MEGlwpjpKTt/Y2HACgAR2LWYHhK8001R60Jmcwf+8vyVixLnSyzoJ++QT1
 iaPzpbaryBRMSKKcvUW8mighydeOtegMUbjwJNH3Sf4+yR+WXH1mDawagHhhDWVHT7lW
 a4c7N7E1l0ZDIrVuy8HtA5Cp39Ok75z02CUWGC3c+Qs8czF+6AMmmQGONdeRr2etTHjp
 0i1A==
X-Gm-Message-State: AOAM531RMFYoXCbNBI8MVng9jbKnjDaMRPGVnU6/vjAegEUYMnBiYMe7
 0SyyfGV4mRgHjrKSb+ZC20iItkf4GDxpWptC3r4Smg==
X-Google-Smtp-Source: ABdhPJxD2TsqeJAu62OQI9GJbfnHm0E/nNI7HgtCLesglhFdiEu2JJtzEl0++gNNcsrTStCnIgoDo+CKE1MjNFtghVw=
X-Received: by 2002:ab0:3a8f:: with SMTP id r15mr8202775uaw.13.1629312133633; 
 Wed, 18 Aug 2021 11:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210818184057.515187-1-rananta@google.com>
In-Reply-To: <20210818184057.515187-1-rananta@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 18 Aug 2021 11:42:03 -0700
Message-ID: <CAJHc60z9AQ1huwan_WE5etEV0BAq_ZtNea+0u1AqgGHdAFmKQw@mail.gmail.com>
Subject: Re: KVM: arm64: vgic: Resample HW pending state on deactivation
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 18 Aug 2021 15:59:47 -0400
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 kvmarm@lists.cs.columbia.edu
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

Please ignore this. Sent by accident.

Regards,
Raghavendra

On Wed, Aug 18, 2021 at 11:41 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> From: Marc Zyngier <maz@kernel.org>
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
> Reported-by: Raghavendra Rao Ananta <rananta@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-v2.c | 25 ++++++++++++++++++-------
>  arch/arm64/kvm/vgic/vgic-v3.c | 25 ++++++++++++++++++-------
>  2 files changed, 36 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> index 2c580204f1dc9..3e52ea86a87ff 100644
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
> index 66004f61cd83d..74f9aefffd5e0 100644
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
> cgit 1.2.3-1.el7
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
