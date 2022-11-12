Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7035129A8
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 17:12:00 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id 6so6790992pgm.6
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 09:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=UKVt0/d69LlFjfItWR2g9B0gW2X5tZpcB4HmnnOIFQckLt2H+EYCuomFre/4CjgAH1
         x09sfxnZfQpEBMQbxktHESTs4fZVf/W3eKUQenIa8fPXN74kUb/5O6MzfVrxvPsKaWbt
         TI1nee79UtVIc29URiGMM/8ABAttzziYdITPdssjchqt2s47tFcEUGNIseMSm1EuiBbE
         oowoA6aLUOn346KALg9+irsCkAA2gLNGpqRdeXiclGkhJ1neYDb8nKk+uvu9RQN15Twn
         oqKl3c9Xzz4MkPeEUa8m8fT2lgQHproqRT5dMbxZ2trvWBq01CLAcZx9iDhsWlGtUkeQ
         4E1Q==
X-Gm-Message-State: ANoB5pkA7IjrG9NxpGhRqIfR6mVnulOXVmHuzzk/t4f4fKgOdzi6qG4V
	mabNOFZhj2VM5x2Y9RQ62hrBfCCV5/v/Uad+bpzwug==
X-Google-Smtp-Source: AA0mqf5DICL/2gA2W9iIaKXpvPpequGwdfWsmg3dq8MWyHwh/KLJ/3GKXQMeXrpPRy8098xWMqdkZMYeGaya8U+kDxg=
X-Received: by 2002:a63:4711:0:b0:474:4380:cca6 with SMTP id
 u17-20020a634711000000b004744380cca6mr5941504pga.229.1668273119742; Sat, 12
 Nov 2022 09:11:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221107085435.2581641-1-maz@kernel.org> <20221107085435.2581641-3-maz@kernel.org>
 <CAAeT=FwNKZhc=a4Jggw-ENL=9G26QTU7OsRbHd2+F+=ZTPt24w@mail.gmail.com> <87edu8uz1o.wl-maz@kernel.org>
In-Reply-To: <87edu8uz1o.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Sat, 12 Nov 2022 09:11:42 -0800
Message-ID: <CAAeT=Fwp-Xx49XmbVm55x-4+GRVuGbT6kqhAcfXTpWTqfvEu+Q@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] KVM: arm64: PMU: Align chained counter
 implementation with architecture pseudocode
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112171142.UFA1lAzjtp3Z9bIWQrm4USgwGIP3d3cwDrmuB5Mb5cc@z>

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
