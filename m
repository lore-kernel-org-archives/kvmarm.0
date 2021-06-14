Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F323C48BE8
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:50:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F74361245
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:50:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F74361245
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE33649F5D;
	Mon, 14 Jun 2021 05:50:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RP7xTpAt6IbX; Mon, 14 Jun 2021 05:50:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 098FD4083E;
	Mon, 14 Jun 2021 05:50:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B01940821
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:50:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xz+F+ruFBG5p for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 05:50:28 -0400 (EDT)
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com
 [209.85.161.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DD93405A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:50:28 -0400 (EDT)
Received: by mail-oo1-f41.google.com with SMTP id
 w13-20020a4ad02d0000b029024a98209c35so1672798oor.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 02:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3ozeCrBWe056dvCFaSIn+YQtzRjUNyCG2jQsSBdsH6g=;
 b=K2qC92mVnZ7jUjofUEv4H+1w+qvltenXJMO5pP5zAQH9F9zzM6cma5PhaHyikSIE3D
 dgQc6WK4VWss1I8rQpcUAa+kknrISK1OThLKqPD0Ynu3YYr8NHxDjWdGBi55WyPUNLif
 i3JnBKWMJgfPTrRirLFRa8yVdEoj3gif50MFdkhnQ7QcHt3pdY8TR72cKPAlAymhZAhy
 fE+SeGXJkHhWdl5z0so4A3sE6OP4b04IsNaed/cw6QlyOjQcCpURRrlseuX+X6B4TqU1
 wFpbS04rbYoW9naTxekf9c4HpCWGlieaJNAtYseO4lXhzKvQiMv8Gd3ijQNtsUu8qwFY
 4JHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3ozeCrBWe056dvCFaSIn+YQtzRjUNyCG2jQsSBdsH6g=;
 b=UHIWB3xPBhNihHOraFwvCpJ4pHEtOMKZybc3lrFFjzIF+wiaWnSCMkh1XvTMETwSee
 OeeSfzCSOsWrUV1fRoYk4KNpFtvR/B9+3steA8Fe9hir8/ZwrjcIkzjotawYmFMvugzC
 lDJDAft08dGREZxQe64U4KSpkND26oYriFSB0Bi2zYEagUWGLZGM13Aein/El2ceHR6I
 +NsvkPI3fNL2EySKd1pWCjNFXJQ0UFU2BaXTLhRIriaSs+bHc8NvEKauqKE6FmofY0mN
 hCx4zCg964IygzHlOoPge9wIkBbWEKGumtNrDtsZwcINJisyOWPaEpTNQ8Wp17uLZoZE
 l6pg==
X-Gm-Message-State: AOAM533CDkX1kBO4YOAbzEuDAvVkYzvuYAfSl9Qj9VmLLdD8RVRsrHrq
 1MS+lYuqbyvRDMWlMSfaBFtFY6hm8aWp2Vut1dYmRw==
X-Google-Smtp-Source: ABdhPJyJwQ95jW5MLr7rUkCdRFLkVYE33n19WoUneoHj3ZP6RKTjyoGOcQr4wTLfnQTTpVHh3eZs+F2r0ncYGstNVYw=
X-Received: by 2002:a4a:5482:: with SMTP id t124mr12435372ooa.42.1623664227170; 
 Mon, 14 Jun 2021 02:50:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com>
 <20210614025351.365284-2-jingzhangos@google.com>
In-Reply-To: <20210614025351.365284-2-jingzhangos@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 14 Jun 2021 10:49:50 +0100
Message-ID: <CA+EHjTybUkOVVByL5r_MwLfzc_aaPybY8AzdCLYmS8aiR-RkSA@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: stats: Make sure no missing or mismatched binary
 stats definition
To: Jing Zhang <jingzhangos@google.com>
Cc: LinuxS390 <linux-s390@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
 LinuxMIPS <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, KVMARM <kvmarm@lists.cs.columbia.edu>
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

Hi Jing,

On Mon, Jun 14, 2021 at 3:53 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> Add static check to make sure the number of stats descriptors equals
> the number of stats defined in vm/vcpu stats structures.
> Add offset field in stats descriptor to let us define stats
> descriptors freely, don't have to be in the same order as
> stats in vm/vcpu stats structures.
> Also fix some missing/mismatched stats from previous patch.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

I tested this for arm64, and it does assert if there's a mismatch. I
couldn't find any missing statistics under any of the architectures
either.

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5e77f32abef5..692af9177c9f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1296,119 +1296,152 @@ struct _kvm_stats_desc {
>         { n, offsetof(struct kvm_vcpu, stat.generic.x),                        \
>           KVM_STAT_VCPU, ## __VA_ARGS__ }
>
> -#define STATS_DESC(stat, type, unit, base, exp)                               \
> +#define STATS_DESC_COMMON(type, unit, base, exp)                              \
> +       .flags = type | unit | base |                                          \
> +           BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |                   \
> +           BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |                   \
> +           BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),                    \
> +       .exponent = exp,                                                       \
> +       .size = 1
> +

nit: you seem to be mixing tabs and spaces here

> +#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp)                    \
>         {                                                                      \
>                 {                                                              \
> -                       .flags = type | unit | base |                          \
> -                           BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |   \
> -                           BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |   \
> -                           BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),    \
> -                       .exponent = exp,                                       \
> -                       .size = 1                                              \
> +                       STATS_DESC_COMMON(type, unit, base, exp),              \
> +                       .offset = offsetof(struct kvm_vm_stat, generic.stat)   \
>                 },                                                             \
> -               .name = stat,                                                  \
> +               .name = #stat,                                                 \
>         }

nit: also here, mixing of tabs and spaces

Tested-by: Fuad Tabba <tabba@google.com> #arm64
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
