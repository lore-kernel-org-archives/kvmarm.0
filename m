Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7D1C2B9F4
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 13:28:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7004D61059
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 13:28:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7004D61059
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8AEE4B090;
	Mon, 14 Jun 2021 09:28:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FVYNxacAHu6p; Mon, 14 Jun 2021 09:28:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAE284B07F;
	Mon, 14 Jun 2021 09:28:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6298E40874
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 09:28:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cvi93Y3lN2xP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 09:28:40 -0400 (EDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com
 [209.85.208.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53BAA405EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 09:28:40 -0400 (EDT)
Received: by mail-lj1-f179.google.com with SMTP id r14so20067048ljd.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 06:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Q5Z/aRJGZDJZL2EoNoPXOS7QUgj78LrAb9XaHxJadEA=;
 b=JiV08GosC2hu0mBkUDRXU/N884IpJJ34SBN+GRNPcDZ65ZIK3IlpEE+snOmDGdRceK
 tudF5VzHPI6svSmHaten143+9jq6T8AneF3vjk5jm6TokSrvzJRR+eF6OJpOVQBUvYT1
 9ZgGKOXkazUUV9TzXB6CrvcL9grdWhXTsvpH4wnjEsjBtT1E651Zg5KBC1IQQ5ONl8FY
 +qfgCELQ+ZU3YQy0jhDIBvIyerCR4IcHkRsx2vXw06ZDq4fS+xn+SMx1DMdeoVaJIi7J
 8CJfkJm5Dz4CksAOqr8NLGYnhhvejzLauWaVYAnUm9fzIR3Y3DWTdYjtDKVoKSP7oYdf
 Httg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Q5Z/aRJGZDJZL2EoNoPXOS7QUgj78LrAb9XaHxJadEA=;
 b=n3P3lM5P1uov14JH43lwwMIDpmwGemBCrJIxvx7GYVvCvpigu2o5R8f8laxWRrqeb9
 eFPZoxGu2hhLmrMjOOTgFfprxWP18OmivqsuMFh6G+fbln2DcxEYf3pt9qLlxfWBZ/nL
 BrYpb5lmRuhA5tUrSek41tQCI0oz1qhvrVdy7EdO2IzLxvmJuPYRbib9o8jmSID6qekp
 2vgoqtNocqjlkX61N/YBXiGbNKC3foBgPZaNzKQ1REVYGJroh8zcCHEM0oD9wBDM5Qox
 YK74VsIQubhCr4yxXu9UtVDlDGA+cpdoGPC8CggX++u7RpB3spdHrGanuvKgOnm264yy
 Lshg==
X-Gm-Message-State: AOAM530z7+6kNg1dq5G5whuavl47svJApJpV1yC10x5f8/grYOotU/Tr
 HYHUI6dPXoWXPFiXR888uwC93QZlPFfSVihrfvgp0g==
X-Google-Smtp-Source: ABdhPJzkTobUBO7OfrBdhTzHUcheq0UTf5Nx2DXYGm1qPTWlKyDMAcFAsG0mMq2AInD+nV0hjIJk0U4MuH67YXYy1fY=
X-Received: by 2002:a2e:8814:: with SMTP id x20mr13996006ljh.394.1623677318799; 
 Mon, 14 Jun 2021 06:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com>
 <20210614025351.365284-2-jingzhangos@google.com>
 <CA+EHjTybUkOVVByL5r_MwLfzc_aaPybY8AzdCLYmS8aiR-RkSA@mail.gmail.com>
In-Reply-To: <CA+EHjTybUkOVVByL5r_MwLfzc_aaPybY8AzdCLYmS8aiR-RkSA@mail.gmail.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 14 Jun 2021 08:28:26 -0500
Message-ID: <CAAdAUthx2Hpqx6nLg8JeAO5XwVyBL7Dr6Et244LDUv1=99NgrQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: stats: Make sure no missing or mismatched binary
 stats definition
To: Fuad Tabba <tabba@google.com>
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

Hi Fuad,

On Mon, Jun 14, 2021 at 4:50 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Jing,
>
> On Mon, Jun 14, 2021 at 3:53 AM Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Add static check to make sure the number of stats descriptors equals
> > the number of stats defined in vm/vcpu stats structures.
> > Add offset field in stats descriptor to let us define stats
> > descriptors freely, don't have to be in the same order as
> > stats in vm/vcpu stats structures.
> > Also fix some missing/mismatched stats from previous patch.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>
> I tested this for arm64, and it does assert if there's a mismatch. I
> couldn't find any missing statistics under any of the architectures
> either.
>
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 5e77f32abef5..692af9177c9f 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1296,119 +1296,152 @@ struct _kvm_stats_desc {
> >         { n, offsetof(struct kvm_vcpu, stat.generic.x),                        \
> >           KVM_STAT_VCPU, ## __VA_ARGS__ }
> >
> > -#define STATS_DESC(stat, type, unit, base, exp)                               \
> > +#define STATS_DESC_COMMON(type, unit, base, exp)                              \
> > +       .flags = type | unit | base |                                          \
> > +           BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |                   \
> > +           BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |                   \
> > +           BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),                    \
> > +       .exponent = exp,                                                       \
> > +       .size = 1
> > +
>
> nit: you seem to be mixing tabs and spaces here
>
> > +#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp)                    \
> >         {                                                                      \
> >                 {                                                              \
> > -                       .flags = type | unit | base |                          \
> > -                           BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |   \
> > -                           BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |   \
> > -                           BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),    \
> > -                       .exponent = exp,                                       \
> > -                       .size = 1                                              \
> > +                       STATS_DESC_COMMON(type, unit, base, exp),              \
> > +                       .offset = offsetof(struct kvm_vm_stat, generic.stat)   \
> >                 },                                                             \
> > -               .name = stat,                                                  \
> > +               .name = #stat,                                                 \
> >         }
>
> nit: also here, mixing of tabs and spaces
>
> Tested-by: Fuad Tabba <tabba@google.com> #arm64
> Reviewed-by: Fuad Tabba <tabba@google.com>
>
> Thanks,
> /fuad
Thanks for the review and testing!

Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
