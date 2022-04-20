Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DEAC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 17:07:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA5B84B1B6;
	Wed, 20 Apr 2022 13:07:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QERnJ5CzgOYV; Wed, 20 Apr 2022 13:07:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B0454B1BF;
	Wed, 20 Apr 2022 13:07:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AE694B1B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 13:07:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9HqZtEdq6--G for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 13:07:00 -0400 (EDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com
 [209.85.208.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 315514B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 13:07:00 -0400 (EDT)
Received: by mail-lj1-f177.google.com with SMTP id bj36so2616020ljb.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 10:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=nwXZACexIQTCKX7fmQhCIlLscOf1Xe3RKBnrv/G98uk=;
 b=BtWx0WnVulW7TX9tHR5fuA8v+iY5c2SN57DW1HG5FmHTqp2dOl0qBvyuCtPv2i5gia
 1CtfT9QV502kMtFFgjO1mMbq3RcuyuQXXotHgc2ylqNltYpgO5lpJNuqflA/hqfflys+
 sBh9pqmeGjf4bmJLUUbSWV26+p51R1lXH9VHVOGqI3QjvFsJh7gsUC/9KNbRYNqRr2ZL
 D92Qa/cfU74JSTUqLbcB0QqbINGM1+VXX8RbhVaoDOsQBgDw2/jzuoD/3r7iohdD9xF/
 6Nw/8azbHPVI2VVdpOODG3Gng/IRWlU9HMDGOTSAEz/E8U1z3VP/4D/AWOdDSNPddNtm
 v7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=nwXZACexIQTCKX7fmQhCIlLscOf1Xe3RKBnrv/G98uk=;
 b=RZ5BP0QP5qKwjiMPblVxTtjLucsYKMSjZhRgb2xvhQ1cefXCvHS0CnfQjd3OZHLMKh
 YVg9SB6Z2BA6uUwHLAj5A/j1+nHvy0VGQNGSmbEVo4rWaavyWaus4iVdfFVi4I3gIcRi
 J+QZnQsdPpbeo4DXmcj7aYPNNkBj59z9GlRI35ChL0MRfyevx49wYV4aAv5zitdM5Eqv
 /XNNm1twXm9lEuyv0lG6sW7QT4tpiB08AJt41W35RJHw44hZwQ+W+H03aASw7RiJLBEE
 BYJvL7qoirp8vcX56lf+ExwdI0pZbq/xzQmxZrRWURioq3mxLn+1H5q4+osZbl378uhy
 ZQcw==
X-Gm-Message-State: AOAM533oqunLXAHmsDxe5LB0wz8/+jTT5maRwoqzFVGm/RAktI/xcwkq
 dgRcoodu9u4ICJEB3s+kKAl5LwJxaCQcc4uuw6cDQw==
X-Google-Smtp-Source: ABdhPJyGf8++29sfZ4IombK+Ehkrq5O/Fj1OHcyZrq+mqvGz2SwZasPtkzcHYZNH6OzyhQngA6L8RJ0mM5f8tZXe9i8=
X-Received: by 2002:a2e:5cc1:0:b0:24b:112f:9b36 with SMTP id
 q184-20020a2e5cc1000000b0024b112f9b36mr14125759ljb.337.1650474418585; Wed, 20
 Apr 2022 10:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
 <YmA7D7DyY7MDfli4@google.com>
In-Reply-To: <YmA7D7DyY7MDfli4@google.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 20 Apr 2022 10:06:47 -0700
Message-ID: <CAOQ_QsgaRF1ZkKATk38PTi2GqhajXPrxVuZFa6d-KPnY-Sfutg@mail.gmail.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
To: Quentin Perret <qperret@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Wed, Apr 20, 2022 at 9:55 AM Quentin Perret <qperret@google.com> wrote:
>
> On Friday 15 Apr 2022 at 21:58:50 (+0000), Oliver Upton wrote:
> > +/*
> > + * Used to indicate a pte for which a 'make-before-break' sequence is in
>
> 'break-before-make' presumably :-) ?

Gosh, I'd certainly hope so! ;)

> <snip>
> > +static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t new, struct kvm_pgtable_mm_ops *mm_ops)
> > +{
> > +     /* Yikes! We really shouldn't install to an entry we don't own. */
> > +     WARN_ON(!stage2_pte_is_locked(*ptep));
> > +
> > +     if (stage2_pte_is_counted(new))
> > +             mm_ops->get_page(ptep);
> > +
> > +     if (kvm_pte_valid(new)) {
> > +             WRITE_ONCE(*ptep, new);
> > +             dsb(ishst);
> > +     } else {
> > +             smp_store_release(ptep, new);
> > +     }
> > +}
>
> I'm struggling a bit to understand this pattern. We currently use
> smp_store_release() to install valid mappings, which this patch seems
> to change. Is the behaviour change intentional? If so, could you please
> share some details about the reasoning that applies here?

This is unintentional. We still need to do smp_store_release(),
especially considering we acquire a lock on the PTE in the break
pattern. In fact, I believe the compare-exchange could be loosened to
have only acquire semantics. What I had really meant to do here (but
goofed) is to avoid the DSB when changing between invalid PTEs.

Thanks for the review!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
