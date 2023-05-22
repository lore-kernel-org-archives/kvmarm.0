Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C3779E1
	for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 11:00:13 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-4394a25867cso380377137.0
        for <kvmarm@lists.linux.dev>; Mon, 22 May 2023 04:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684753212; x=1687345212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OtO+oDqvW2uZLU4/0eJMtjF3Ro5r+NIMTybey9XIr3o=;
        b=W+5/vebJfHtd2rRaVplVQuf8fEfmp20u80WNyD0GwJ/cHZ0hLVra/XCvw7z/DYg4Do
         GUXWD1GEjiQKzvZQ7Le+KFt/HZhgrekbJypaWAKjwZqdzPavcBHGa7u8Z2vCQRKLfbgT
         nCM5n+H6OfmfakCV7jcepJLOWDZsNuKuUGcMfoLY2/4ibaiVmOmAQqt6aoueOfrIQYo5
         tMJgb9mwxbcxkHAHE8TdOehwNmj1X5xpDy5LU7My/DN9ow1gFVGzLIZ3A7AhDUunXF7p
         S5QVAV9KWtC8HikH/98qbbfIun5JFhL+5b6t0pPDRAa6+KluUgZlnNmTtbbAVETUMEvo
         yDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684753212; x=1687345212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OtO+oDqvW2uZLU4/0eJMtjF3Ro5r+NIMTybey9XIr3o=;
        b=efnjeTSnHqwTDFI71hxCQJZI5AGEMNQe+860ArzbqABM8bSi8KZPwMxz3PJ+E99fu6
         v6jbrOzgQL0zn6CxYWVD2DVCjLMyiUYDyhMQxwProQWb+LQpvnRV4nGA0Zg/50pGbVVR
         SnfIZCNRGCOCMTzCMQPSb+T5XIXuMOm/gTdiE43TVNHtQnxl46IWehxzB07P7cA2/VQh
         YF4pqISBoyPjoXshqLbJNJwQQvxXONHZIe3bhGQx33qH6aKreBFHN4rUlVTmK4Fjp6pJ
         lsLErHzJR9dhhSXVqIGQ64M9RH4ryEQQraTAsk+Z+kN0Q9fLP9TYeMY3o3eEpvamUcoa
         pc3Q==
X-Gm-Message-State: AC+VfDwAmvXZo33Z+OQYODGUHL6JGaJdP4DmALGyVj/rraorRFeAR79F
	FI/kw0ychVmb1N9wg2973UjetLkCxz8J+nRyA4yoLA==
X-Google-Smtp-Source: ACHHUZ4BJjuJFxKP9oG0+h0RJt/w2eQIqcZEcpvwAs+VgB5JPyoLrPSxpB1fUymp8ynu51uiqeUAqjHNDEcwiuXWYx0=
X-Received: by 2002:a05:6102:53c3:b0:437:d738:c2ce with SMTP id
 bs3-20020a05610253c300b00437d738c2cemr1623410vsb.2.1684753212085; Mon, 22 May
 2023 04:00:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230522103258.402272-1-tabba@google.com> <86a5xwljzt.wl-maz@kernel.org>
 <868rdgljk2.wl-maz@kernel.org>
In-Reply-To: <868rdgljk2.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 22 May 2023 11:59:36 +0100
Message-ID: <CA+EHjTwG+PCy2=xDdFsg9x4fvpJSRhJFrew8d6YpFR561B3HxA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Reload PTE after invoking walker callback on
 preorder traversal
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	james.morse@arm.com, catalin.marinas@arm.com, alexandru.elisei@arm.com, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, reijiw@google.com, ricarkol@google.com, dmatlack@google.com, 
	qperret@google.com, bgardon@google.com, gshan@redhat.com, peterx@redhat.com, 
	seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 22, 2023 at 11:58=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Mon, 22 May 2023 11:48:38 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> >
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtabl=
e.c
> > > index 3d61bd3e591d..120c49d52ca0 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -207,14 +207,26 @@ static inline int __kvm_pgtable_visit(struct kv=
m_pgtable_walk_data *data,
> > >             .flags  =3D flags,
> > >     };
> > >     int ret =3D 0;
> > > +   bool reload =3D false;
> > >     kvm_pteref_t childp;
> > >     bool table =3D kvm_pte_table(ctx.old, level);
> > >
> > > -   if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE))
> > > +   if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE)) {
> > >             ret =3D kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WA=
LK_TABLE_PRE);
> > > +           reload =3D true;
> > > +   }
> > >
> > >     if (!table && (ctx.flags & KVM_PGTABLE_WALK_LEAF)) {
> > >             ret =3D kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WA=
LK_LEAF);
> > > +           reload =3D true;
> > > +   }
> >
> > From these two clauses, it is clear that reload is always the value of
> > (ctx.flags & KVM_PGTABLE_WALK_LEAF). That'd simplify the patch a bit.
>
> OK, it should be obvious by now that I cannot read, because TABLE_PRE and
> LEAF are very different things.
>
> Sorry about the noise. I'll fix the trailer thing and stay quiet for
> the rest of the day...

:)

Thanks Marc!
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
