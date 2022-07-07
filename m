Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055D3C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jul 2022 05:17:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EC154B978;
	Thu,  7 Jul 2022 01:17:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8hWkObBMvlUk; Thu,  7 Jul 2022 01:17:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF614B8DC;
	Thu,  7 Jul 2022 01:17:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 790FF4B944
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 01:17:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nRSvyj0Es5Cy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jul 2022 01:17:02 -0400 (EDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com
 [209.85.217.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 198974B8DC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 01:17:02 -0400 (EDT)
Received: by mail-vs1-f49.google.com with SMTP id a184so8076003vsa.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Jul 2022 22:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=78VvqqeGGhzujgkUxwnpYoL4c4XN7DDS4lxQpLU4nvU=;
 b=ngY6+5JOojjN1GcAOXKIFriMglWIoZmmf2cAlLrGPALF+QbWeW/0XbSEf+TZ97Dux5
 lqb/41JuwsCNPoTiLutzeCXYgRWssDCNgaZzS7JWvvLUXJ6XmV6vgcO1KdyBfi7iYq+9
 R5RAAulKwm7Qm7F/YQlcCvzyo1eYkh4Gdf+hxkZ1X9pXguLgq9VxsIMFaxivEakSLHLj
 83Y8iU5YIbnIxVDRaRMpkt9TdiXrxq7skete619N+rnNdR//vgHFc0TGJw0gNqXeeOd6
 sNiR2MZdOst8QL5Gb0mn0mc0a7hQvLuPCrRvlwO6BHGoyaG8bYqefNKOTCZrgRQTcYXU
 g8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=78VvqqeGGhzujgkUxwnpYoL4c4XN7DDS4lxQpLU4nvU=;
 b=EVsbPJJSlKykRqUqnw/LpxLJiVJkstqCDf+xrvGksRBAKsUG8lOH455dWIu84F99SV
 AFB54KbbndO4MtyTzqo+mNMTb3LmxpqmUmLgXSXgqrMt4Byhdb44UChAFrckcONuKuk3
 05AyR5AVupe4os1PRi4MYmibke8zIZEwwd2hDvrdM7xmcaIQsZpgnSJ38BseucCFSifl
 DHoL+v8EenPXg2vq71DYcEmIRInRr3T4Ho8kvk4nBpa7xVJgj2DlLRfcgRaV874bbmJJ
 AAzCT+MydX6dnrjQlh5ypkVlWpoUI0CWOCbLUBsyjEakAoxdUVPvpb7/qnUhccXiQAj2
 Y+Fw==
X-Gm-Message-State: AJIora8aY266tO2Y1n4jEwpIvpWZVYmc6a5aSnW6JE0JblucYBOIXjQL
 XdPZLAR2h4vtnbRp9UCZ0iqoVcFqMwRAgKfP7oyCiQ==
X-Google-Smtp-Source: AGRyM1vVS0K94KTjakbjtLBu0kFtsRQN9XX9G7FKNJYewAaeG6AxXLcIw9hRoUT38sLaanq1PHd8w9CVjEDhyese92s=
X-Received: by 2002:a67:f553:0:b0:357:c2b:8408 with SMTP id
 z19-20020a67f553000000b003570c2b8408mr4591742vsn.51.1657171021509; Wed, 06
 Jul 2022 22:17:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-2-maz@kernel.org>
 <CAAeT=FzLaOnHP51SedG-0C8H90UPEtW+qLm2L2k_73hu66fSwg@mail.gmail.com>
In-Reply-To: <CAAeT=FzLaOnHP51SedG-0C8H90UPEtW+qLm2L2k_73hu66fSwg@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 6 Jul 2022 22:16:45 -0700
Message-ID: <CAAeT=Fwd0Vq6J6SN_-kfAJgqbVzJV-j2oP4q1MLrNy_0Prvriw@mail.gmail.com>
Subject: Re: [PATCH 01/19] KVM: arm64: Add get_reg_by_id() as a sys_reg_desc
 retrieving helper
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Wed, Jul 6, 2022 at 9:05 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Marc,
>
> On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > find_reg_by_id() requires a sys_reg_param as input, which most
> > users provide as a on-stack variable, but don't make any use of
> > the result.
> >
> > Provide a helper that doesn't have this requirement and simplify
> > the callers (all but one).
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/kvm/sys_regs.c        | 28 +++++++++++++++++-----------
> >  arch/arm64/kvm/sys_regs.h        |  4 ++++
> >  arch/arm64/kvm/vgic-sys-reg-v3.c |  8 ++------
> >  3 files changed, 23 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index c06c0477fab5..1f410283c592 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2650,21 +2650,29 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
> >         return find_reg(params, table, num);
> >  }
> >
> > +const struct sys_reg_desc *get_reg_by_id(u64 id,
> > +                                        const struct sys_reg_desc table[],
> > +                                        unsigned int num)
> > +{
> > +       struct sys_reg_params params;
> > +
> > +       if (!index_to_params(id, &params))
> > +               return NULL;
> > +
> > +       return find_reg(&params, table, num);
> > +}
>
> Since all the callers of get_reg_id() specify ARRAY_SIZE(array) for
> the 3rd argument, and I think future callers of it are also likely to
> do the same, perhaps it might be more convenient if we make get_reg_id()
> a wrapper macro like below (and rename "get_reg_by_id()" to
> "__get_reg_by_id()") ?
>
> #define get_reg_id(id, table)   __get_reg_id(id, table, ARRAY_SIZE(table))

Looking at the following patches, let me withdraw this comment... Instead,

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji


>
> > +
> >  /* Decode an index value, and find the sys_reg_desc entry. */
> >  static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
> >                                                     u64 id)
> >  {
> >         const struct sys_reg_desc *r;
> > -       struct sys_reg_params params;
> >
> >         /* We only do sys_reg for now. */
> >         if ((id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM64_SYSREG)
> >                 return NULL;
> >
> > -       if (!index_to_params(id, &params))
> > -               return NULL;
> > -
> > -       r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> > +       r = get_reg_by_id(id, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> >
> >         /* Not saved in the sys_reg array and not otherwise accessible? */
> >         if (r && !(r->reg || r->get_user))
> > @@ -2723,11 +2731,10 @@ static int reg_to_user(void __user *uaddr, const u64 *val, u64 id)
> >
> >  static int get_invariant_sys_reg(u64 id, void __user *uaddr)
> >  {
> > -       struct sys_reg_params params;
> >         const struct sys_reg_desc *r;
> >
> > -       r = find_reg_by_id(id, &params, invariant_sys_regs,
> > -                          ARRAY_SIZE(invariant_sys_regs));
> > +       r = get_reg_by_id(id, invariant_sys_regs,
> > +                         ARRAY_SIZE(invariant_sys_regs));
> >         if (!r)
> >                 return -ENOENT;
> >
> > @@ -2736,13 +2743,12 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
> >
> >  static int set_invariant_sys_reg(u64 id, void __user *uaddr)
> >  {
> > -       struct sys_reg_params params;
> >         const struct sys_reg_desc *r;
> >         int err;
> >         u64 val = 0; /* Make sure high bits are 0 for 32-bit regs */
> >
> > -       r = find_reg_by_id(id, &params, invariant_sys_regs,
> > -                          ARRAY_SIZE(invariant_sys_regs));
> > +       r = get_reg_by_id(id, invariant_sys_regs,
> > +                         ARRAY_SIZE(invariant_sys_regs));
> >         if (!r)
> >                 return -ENOENT;
> >
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index aee8ea054f0d..ce30ed9566ae 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -195,6 +195,10 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
> >                                           const struct sys_reg_desc table[],
> >                                           unsigned int num);
> >
> > +const struct sys_reg_desc *get_reg_by_id(u64 id,
> > +                                        const struct sys_reg_desc table[],
> > +                                        unsigned int num);
> > +
> >  #define AA32(_x)       .aarch32_map = AA32_##_x
> >  #define Op0(_x)        .Op0 = _x
> >  #define Op1(_x)        .Op1 = _x
> > diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> > index 07d5271e9f05..644acda33c7c 100644
> > --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> > +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> > @@ -263,14 +263,10 @@ static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
> >  int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> >                                 u64 *reg)
> >  {
> > -       struct sys_reg_params params;
> >         u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> >
> > -       params.regval = *reg;
> > -       params.is_write = is_write;
> > -
> > -       if (find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
> > -                             ARRAY_SIZE(gic_v3_icc_reg_descs)))
> > +       if (get_reg_by_id(sysreg, gic_v3_icc_reg_descs,
> > +                         ARRAY_SIZE(gic_v3_icc_reg_descs)))
> >                 return 0;
> >
> >         return -ENXIO;
> > --
> > 2.34.1
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
