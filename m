Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FEE17736
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 17:51:57 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-33bdab7b4caso4774145ab.3
        for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 10:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685555517; x=1688147517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R8+/MBQepRDI0OzLzQ5plxv42NdlvgBOSqXlyRiX80Y=;
        b=hwdhRnAjamBlqJ7UBsp5ijfmrLXQrT7I1mZyxbqpm2tVzcElT4Z7N4MkwGB2xbgSkx
         2UKy2xsU8L8LQN2bSgrmxYsK9VDjtS9OGASJ5XWujuDUpT0C6x6ozO9OW1dw0DrFnFx1
         hQkg1g2J/JxoQgjiCVNr83ACf2Ld6u8RAZAF+fVPqXu/0tQJZDK8RZRdn2ivzSItdc20
         4jS4AoVF9tRyfvcH2pQfjYO25kv8cTFX5z1fFU1gSz7fApwWqsWFt0Lrl+jlMnZQn7gB
         yluzsiDaskWzNy5zOZacezfK+dLR1o6K0RyjI0O93Z7A82hAK/GV3IcOuzkO6ZGoyejJ
         u26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685555517; x=1688147517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R8+/MBQepRDI0OzLzQ5plxv42NdlvgBOSqXlyRiX80Y=;
        b=EP3edWmFwmbC5zsQFiFuXwfDTOFLp39fk3zWY2plr6ut2N4lQvQcGW4w/jJXXXVrjW
         1ld4NXWxm3TOJAXOV5iq/lwMmrXfRlxGp01IfwEiUFb7FHbARVI7pMHbsIlMvUAUcZ9h
         HEYi5W71aPCDsfvFDOoaCMqJ64tIrY2Hn7/LWXcvseLvJ5nnEK8K/HA4EE9BXJ6kCFHr
         SMauKaoP5DQY1FWpoefBBH6LiXb/C/a6B1sRrh2dqYUaeBJleq4Z1HutbggYgqcOn7N+
         bI8XsRsZkXAsC9QuSJCUTcOzofWhx/14WNPkDKfl/ZjMVTuvJwq9nl83EqEOvLgLfgCy
         7zNg==
X-Gm-Message-State: AC+VfDwTkomkemuFoDByblLUBnWGPu4WE/kEM0U0BtIStsFU6ChrX/Jf
	IH9Q3uVF9l8iQi2euY/zDoxHXpvX/2uavAN12J2c54zW1m9DxMglNVo=
X-Google-Smtp-Source: ACHHUZ7yJXTw61LUz1K4R+gWjK7FQ4VYk3Vtr9WfXanKCcQCZmy3tZpSmzEwwwtsQyzOUvwrJEAL8ukZmooRX+6EI54=
X-Received: by 2002:a05:6870:44c2:b0:19a:71ce:c9f5 with SMTP id
 t2-20020a05687044c200b0019a71cec9f5mr2683493oai.29.1685553912941; Wed, 31 May
 2023 10:25:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230522221835.957419-1-jingzhangos@google.com>
 <20230522221835.957419-2-jingzhangos@google.com> <87ttvwok3d.wl-maz@kernel.org>
 <CAAdAUtinwccyd+URCLjowXq47_LP_SjLNEqm-F9GqycmTZrYuw@mail.gmail.com> <864jntc6au.wl-maz@kernel.org>
In-Reply-To: <864jntc6au.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 31 May 2023 10:25:01 -0700
Message-ID: <CAAdAUthzGevCPfb=aK0ndTCckLtcHmxZ3kgwYUejMYVy0=CHmg@mail.gmail.com>
Subject: Re: [PATCH v10 1/5] KVM: arm64: Save ID registers' sanitized value
 per guest
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Wed, May 31, 2023 at 12:24=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 30 May 2023 19:02:03 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
>
> [...]
>
> > > > +/*
> > > > + * Set the guest's ID registers with ID_SANITISED() to the host's =
sanitized value.
> > > > + */
> > > > +void kvm_arm_init_id_regs(struct kvm *kvm)
> > > > +{
> > > > +     const struct sys_reg_desc *idreg;
> > > > +     struct sys_reg_params params;
> > > > +     u32 id;
> > > > +
> > > > +     /* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. *=
/
> > > > +     id =3D SYS_ID_PFR0_EL1;
> > > > +     params =3D encoding_to_params(id);
> > > > +     idreg =3D find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg=
_descs));
> > > > +     if (WARN_ON(!idreg))
> > > > +             return;
> > >
> > > What is this trying to guard against? Not finding ID_PFR0_EL1 in the
> > > sysreg table? But this says nothing about the following registers (al=
l
> > > 55 of them), so why do we need to special-case this one?
> > Here is to find the first idreg in the array and warn that no idregs
> > found in the array with the assumption that ID_PFR0_EL1 is the first
> > one defined and if it is not found, then no other idregs are defined
> > either.
>
> I didn't make my point clear. What we have is a purely static array.
> Why should we perform such a test on every single VM creation? Any
> structural validation should only happen once, at KVM init time.
>
> > Another way is to go through all the regs in array sys_reg_descs and
> > do the initialization if it is a idreg.
>
> That'd be a waste of precious cycles.
>
> This WARN_ON()+early return should go, but the rest is fine.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
That makes sense. We don't have to do the check on every single VM
creation. And the code to find the ID_PFR0_EL1 should not be done for
every VM creation either.
I'll use a static variable to save the pointer to ID_PFR0_EL1 and do
the check and search in kvm_sys_reg_table_init().

Thanks,
Jing
