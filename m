Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28A8320F
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 17:40:43 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2bcc846fed0so4024671fa.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 10:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692639642; x=1693244442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2KX7owYVbLU+ijCZMyTqUTbMoObdlfJG3Oyp5/y4wY=;
        b=oh9VwzBbpPpafybwAP8GHSVpFnHZQDjfRG7xT1QEJ77K8HSIWsAynMTQd6E9joGkP6
         Rq607N/5QDq5bIVhaJnN70wZCbzXL2heuTQS8SRp3GWe8l0xCY2TOSWuAVpdExmgy158
         CQwKrKE/Ae9yP2xfXomETJ39Qf27TSgKwRPeeH7SHWnoWrQy3w77StDMXC5Qkd1yzPCb
         6ngmmuMBt0rSr9ZLEMYSA17abx0bBZBcmGdhHKbPWdFTUT1IYyeSWBsEkCHQCg/HYhP6
         T47g4KE9iVt66bWkAG0OyKCri+pesQVldwCYJzIOT4paN3e2qKy6lTIJhqQ5KJXWuNkB
         XZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692639642; x=1693244442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P2KX7owYVbLU+ijCZMyTqUTbMoObdlfJG3Oyp5/y4wY=;
        b=GJ7wgt8EXIRxoUiPi8VQpiQqx17hM8EANGJtyhRaNEoPyIf8nfDKhJf9FQLQ58rIaF
         F4Oksp+ThF4LTTTTU/GUBD67L5aLiXehWhRPw5hFF6DuVBqlJMZx8Z1T4J0+jMyhJDH+
         ELbhJn+wra7VQhl8B9HRew05oUI94YZVcI3UabgLU7Cn0WsayWfCvKJsdfPVUuKw3ZkJ
         S5Uldi08HsGJiuq2EsRu+olbqBMy45e0yousuN/d/ehF3NigbLH18XArrY9cS1okejjj
         TgEnG2ffTtTjhulNcuQ8HUP//z+lFgWC9qlCe8rJmTSt4H6k8NqVOXvz5IJcNWMk0RhQ
         WV8Q==
X-Gm-Message-State: AOJu0YzydLeNIsJMp0Zz1JoUq3vLTuAo8kLKsGjEtAjvVjzF5iOOh/3Q
	NqHnWO3tbQoWE1w1Mfu5qC3Hn3jfIy7ix69hL1cufw==
X-Google-Smtp-Source: AGHT+IGixA1mCi+LjuXuZlXx3gJPK2xjvqGQSnRKH4QShLy5tdi/PKQQ9ZOnc0bwcE2qdBZcXZJ0IzEnB1blkIpc1Ws=
X-Received: by 2002:a2e:6e10:0:b0:2b9:cb50:7043 with SMTP id
 j16-20020a2e6e10000000b002b9cb507043mr5697619ljc.2.1692639641800; Mon, 21 Aug
 2023 10:40:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-8-jingzhangos@google.com> <86pm3lfyxo.wl-maz@kernel.org>
In-Reply-To: <86pm3lfyxo.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 21 Aug 2023 10:40:30 -0700
Message-ID: <CAAdAUtiyJuSioPG3LTPkW82jujt-1405bjSBwMowt9sOoZYQCw@mail.gmail.com>
Subject: Re: [PATCH v8 07/11] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>, 
	Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Thu, Aug 17, 2023 at 8:53=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 07 Aug 2023 17:22:05 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > All valid fields in ID_AA64PFR0_EL1 are writable from usrespace
> > with this change.
>
> userspace
>
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 879004fd37e5..392613bec560 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2041,7 +2041,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .get_user =3D get_id_reg,
> >         .set_user =3D set_id_reg,
> >         .reset =3D read_sanitised_id_aa64pfr0_el1,
> > -       .val =3D ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK,=
 },
> > +       .val =3D GENMASK(63, 0), },
> >       ID_SANITISED(ID_AA64PFR1_EL1),
> >       ID_UNALLOCATED(4,2),
> >       ID_UNALLOCATED(4,3),
>
> Same remark as the previous patch. What makes it legal to make
> *everything* writable? For example, we don't expose the AMU. And yet
> you are telling userspace "sure, go ahead".
>
> Userspace will then try and restore *something*, and will eventually
> crap itself because the kernel won't allow it.
>
> Why do we bother describing the writable fields if userspace can't
> write to them?

I'll send out another version which wouldn't enable writable masks for
RES0 fields and KVM hidden fields.
Does it sound good to you?

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
