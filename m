Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EF5C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 17:12:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 144D04B83B;
	Sat, 12 Nov 2022 12:12:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xuGri4IFnFzN; Sat, 12 Nov 2022 12:12:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DE514B83D;
	Sat, 12 Nov 2022 12:12:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF7104B83B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 12:12:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NoOfNCrIJ-9r for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 12:12:00 -0500 (EST)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
 [209.85.215.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1B524B83A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 12:12:00 -0500 (EST)
Received: by mail-pg1-f174.google.com with SMTP id 136so6811116pga.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 09:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=huOfRfTKX8VpR+zLQmX1u05LOoSZKsTiMBH9KVLbC90=;
 b=YOPdyFPHiHdfei20a0O7mxQJEQ1ngcz2Ak7zBVLQQL6m6BCgnGfpFH9NTCV5g3TkKb
 lhJ/Oix0aRGD4D0zw7tU9n/WWfjvoDT4CIJZ+st0hZCA2bVYqhniDRjY/c+Tn/lktx8w
 P6E46/GhBxnYcFdIVsWV2BjvcAxD1Oz93Mm61R/l2EajnTBEtD7fsBnJDZJMWNMEvcOI
 ngtnFreoV3caaRvProwwSKldBKPGjk3MUgTrZ8Hz0ukRGsosJ+LxNxVhajZk7nssB7kp
 ok1uvAeLWgYsUVYt/TemRAbnH/NofOgyy+GWdIo4doZcp15qloZblfU/KSw65we3g32K
 tfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=huOfRfTKX8VpR+zLQmX1u05LOoSZKsTiMBH9KVLbC90=;
 b=Oie0cNtPi9KdTRqeg4T6yk6z/sdxklt1Mdf5Kcypq4sZyyeZmHWE/k6RfeDJLOjx1U
 ue41oafm7rMidhp8wrhDY1+b9e3zWxHfnwZncuvEef+hHH1rtUmzKmI0zeM+wCM6D3B3
 4sE/Yi8o24OvRx5vnpncVpt/PA3fP23I9Bx+bfM5Ojf1Uvln534G6snp6UoC5j/MYbAW
 sxN37AwQou/EuCikur8JFlI2sVJVAJ2fgPhJAvq7lthXEIh7yT8XsZ/cKPd7Jhs4lv8H
 Aa0uGdGONAiXDFlhMPoLhXf8WA8QrTXg0wzfD8Aj+PAucGKAKvsrAmTljXiflzJ2XpRq
 nxGA==
X-Gm-Message-State: ANoB5pm2dm/iUsgA8L65SW5BiStHx1dyLQufBNpPej5CKIRTknLoLlvO
 Nmz5gePryosbnTZbLhs2nNRdKITPNTo+KWizYAna4A==
X-Google-Smtp-Source: AA0mqf5DICL/2gA2W9iIaKXpvPpequGwdfWsmg3dq8MWyHwh/KLJ/3GKXQMeXrpPRy8098xWMqdkZMYeGaya8U+kDxg=
X-Received: by 2002:a63:4711:0:b0:474:4380:cca6 with SMTP id
 u17-20020a634711000000b004744380cca6mr5941504pga.229.1668273119742; Sat, 12
 Nov 2022 09:11:59 -0800 (PST)
MIME-Version: 1.0
References: <20221107085435.2581641-1-maz@kernel.org>
 <20221107085435.2581641-3-maz@kernel.org>
 <CAAeT=FwNKZhc=a4Jggw-ENL=9G26QTU7OsRbHd2+F+=ZTPt24w@mail.gmail.com>
 <87edu8uz1o.wl-maz@kernel.org>
In-Reply-To: <87edu8uz1o.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Sat, 12 Nov 2022 09:11:42 -0800
Message-ID: <CAAeT=Fwp-Xx49XmbVm55x-4+GRVuGbT6kqhAcfXTpWTqfvEu+Q@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] KVM: arm64: PMU: Align chained counter
 implementation with architecture pseudocode
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

> > > +#define PERF_ATTR_CFG1_COUNTER_64BIT   BIT(0)
> >
> > Although this isn't the new code (but just a name change),
> > wouldn't it be nicer to have armv8pmu_event_is_64bit()
> > (in arch/arm64/kernel/perf_event.c) use the macro as well ?
>
> We tried that in the past, and the amount of churn wasn't really worth
> it. I'm happy to revisit this in the future, but probably as a
> separate patch.

I see... Thank you for the clarification.  As this isn't new,
I agree with that (not addressing it in this series).

> > > @@ -340,11 +245,8 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
> > >
> > >                 pmc = &pmu->pmc[i];
> > >
> > > -               /* A change in the enable state may affect the chain state */
> > > -               kvm_pmu_update_pmc_chained(vcpu, i);
> > >                 kvm_pmu_create_perf_event(vcpu, i);
> > >
> > > -               /* At this point, pmc must be the canonical */
> > >                 if (pmc->perf_event) {
> > >                         perf_event_enable(pmc->perf_event);
> > >                         if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> > > @@ -375,11 +277,8 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
> > >
> > >                 pmc = &pmu->pmc[i];
> > >
> > > -               /* A change in the enable state may affect the chain state */
> > > -               kvm_pmu_update_pmc_chained(vcpu, i);
> > >                 kvm_pmu_create_perf_event(vcpu, i);
> >
> > Do we still need to call kvm_pmu_update_pmc_chained() here even
> > with this patch ? (I would think the reason why the function was
> > called here was because the chain state change could affect the
> > backed perf event attribute before).
> > I have the same comment for kvm_pmu_enable_counter_mask().
>
> Do you mean kvm_pmu_create_perf_event() instead? I think we can drop
> the one on disable. But the one on enable is required, as we need to
> be able to start counting an event even if the guest hasn't programmed
> the event number (unlikely, but allowed by the architecture). It can
> be made conditional though.

I'm so sorry for the confusion...
Yes, kvm_pmu_create_perf_event() is what I meant.
Thank you for the explanation for the one enabled case.
Now, I understand.

>
> I have the following fix queued:

Looks good!

Thank you,
Reiji

>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 26293f842b0f..b7a5f75d008d 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -277,9 +277,9 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>
>                 pmc = &pmu->pmc[i];
>
> -               kvm_pmu_create_perf_event(vcpu, i);
> -
> -               if (pmc->perf_event) {
> +               if (!pmc->perf_event) {
> +                       kvm_pmu_create_perf_event(vcpu, i);
> +               } else {
>                         perf_event_enable(pmc->perf_event);
>                         if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
>                                 kvm_debug("fail to enable perf event\n");
> @@ -309,8 +309,6 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>
>                 pmc = &pmu->pmc[i];
>
> -               kvm_pmu_create_perf_event(vcpu, i);
> -
>                 if (pmc->perf_event)
>                         perf_event_disable(pmc->perf_event);
>         }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
