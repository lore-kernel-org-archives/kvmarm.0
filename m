Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFC1275A4
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 18:41:13 +0000 (UTC)
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-48137f8b118so769786e0c.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 11:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689792073; x=1690396873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBoCKwV9+yw5yEM2f9YXHvNElnWUATO81mW+x/3Putw=;
        b=bufVZJwM1OlyCyiEwHt7Sv2C+PzUgWOJOonyUixehBdihStk3zFElamFU5TGF0ITN1
         vzly1rT68+WUMJpRX+A3cMyXENHCjwrIFvlflflSLu7qhY+3RnghxiQIBOkadxqXVo+m
         gb5XrhgCF4esJh7njnxijnq6gXFVoOcU1C1cgwOmF7IUxS1ZxaW93fk6gPBrGKslhR0s
         I0Koe86t3YGV17q+UZ7TcMiUoenIaX7sgszozctU8dZPMyegtUDG7mVI/fIvKC5BOCpV
         4YKinkYz8WYkh+aM0fy7l/4oDMuUz5QIMs22ArwvVIvQWJ/ZHVxhd7PHUhyYmJBrIaO+
         68DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689792073; x=1690396873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KBoCKwV9+yw5yEM2f9YXHvNElnWUATO81mW+x/3Putw=;
        b=WAwu5YQNzuLV622qpneqH4A1jUy2gzWcbBn3Q0hvjV5IyZvfoSEfqPsG1aX5BnSr3Q
         XlMIf76EewOv7pUXRu67NXqUT4Z5rnD2HMsJH+gZ4INlUGW2XCwOjzxGjgj7FIVbWL2v
         V78OWUAE3iHbIV1AFlrQK6UuTEBTNVPkHwgGxhUKyyJrFJ5Ll/o7ugULPBV3riHMwi7d
         eXdQzUdhVRhoFAuKGuHJdXbNGAvwZQVq6EI2BAvj5WX8rNHi/P3RkQ5ZR9lbXwT0HUIg
         DQ1vJyeGrGYGUIm2sQKicsm4IYgclkbVi07iGOQ9QDrlHKuvQSvEA+6lCyVMZFlx7/jM
         0AjQ==
X-Gm-Message-State: ABy/qLZq7juveQQ5dh3vEp4dbAV5kQ6brQDEp+VFG2pyhh4cfRVOpGPn
	cbfwB03I19eq0bREO9es3b5AIsOQ6fgDUkbMFxTX0Q==
X-Google-Smtp-Source: APBJJlEaFhuR7LxE3Zol8qn/Vo4SkP0z/sENVPmxOzW7kY4ywKmROzfccqY0mAsHXBSUSULqGzDwPYG9pzo8FtzNQEM=
X-Received: by 2002:a05:6122:31a7:b0:47c:95d2:da25 with SMTP id
 ch39-20020a05612231a700b0047c95d2da25mr1408428vkb.2.1689792072611; Wed, 19
 Jul 2023 11:41:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230719150639.1968034-1-tabba@google.com> <20230719150639.1968034-4-tabba@google.com>
 <ZLgh+rPYxTjmD6xR@linux.dev>
In-Reply-To: <ZLgh+rPYxTjmD6xR@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 19 Jul 2023 19:40:35 +0100
Message-ID: <CA+EHjTwX03MQeuFnWY6vpoWtKMd7OP-Z2=EdZKQaeYJ07WOfLw@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] KVM: arm64: Use the appropriate feature trap
 register when activating traps
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Wed, Jul 19, 2023 at 6:48=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, Jul 19, 2023 at 04:06:37PM +0100, Fuad Tabba wrote:
> > Use the architectural feature trap/control register that
> > corresponds to the current KVM mode, i.e., CPTR_EL2 or CPACR_EL1,
> > when activating traps.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe=
/switch.c
> > index 0a6271052def..e5ea517bab9c 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -63,7 +63,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
> >               __activate_traps_fpsimd32(vcpu);
> >       }
> >
> > -     write_sysreg(val, cptr_el2);
> > +     if (has_hvhe())
> > +             write_sysreg(val, cpacr_el1);
> > +     else
> > +             write_sysreg(val, cptr_el2);
> > +
>
> Does it make sense to have an accessor that's shared with
> kvm_reset_cptr_el2()? Due to the lack of synchronization between the
> aliases we really want to avoid inconsistently using one or the other.

I think that's a good idea. I'll add one when I respin.

Cheers,
/fuad

> --
> Thanks,
> Oliver
