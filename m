Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA2D62A
	for <kvmarm@lists.linux.dev>; Sat, 22 Jul 2023 11:20:54 +0000 (UTC)
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-63cf3dcffe0so716196d6.1
        for <kvmarm@lists.linux.dev>; Sat, 22 Jul 2023 04:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690024854; x=1690629654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ay4FcXLZPIDPS8XWTOBLxpzzjpVgfgtsT0OJfXHGY3k=;
        b=5UG0AE8EhzQ7HG6Wf/PfHSAxPV2FYbneHmnl6dwqF8mzaH3E+RQefpTd/ZBHcdUMbr
         D33QZ/UNFffXGk6Ki6be0SePGZDoIVadFUk3xRedoxeBIyA1CLHX5bwXrqGSWRlugn6s
         cGDvg2Gp6WaRoPMAGO8ygpbC2Qhj4MLw5VRzLcAYv+9v4coRrMMI3qUtjL6bOJR+L2Dx
         Zd3qFXxgHYSU2zqWcqbvM2tf9paursqGAPad8vepHZoR3v05iOjppYqTxo1WeV/AMukX
         X1eXAgdN8qhQDKAf/Ls5ahcSwRu8TuDNl6kP35NQZDB6IJZ6JPRUYxlSIhOVLqvSjkD6
         qUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690024854; x=1690629654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ay4FcXLZPIDPS8XWTOBLxpzzjpVgfgtsT0OJfXHGY3k=;
        b=HVTfj8YzF86uEWicDsOnqUI6bbrmOKYLmCHrszwvORhXhzlivF77PwUSWUXuIuINQL
         nNyfoNQ8oA4yLdpa6zqDX1OCgqQ48HOq9rm/BqumoIeP10TtVz3fRB3NLBf6GLx9QQoy
         IbHHoCTG8o//k4SJtnV4n3/uEslh8m2nDsLYSDHyX7lPsUD9npEyaN+byXD3h7QJ5m9x
         PCOC0YLm24gqkg36rWLKnkN5fQVlwBaaw+c2rH19h/YeXxgpDqR/GqlENa4K0B+jlgok
         Ek/VuhNQ253XqqkADoHNbpiBJ0HvLuIYGBGZpG3zFje9jIdhygLUIWMT1FWZmR6dCiTv
         xYKg==
X-Gm-Message-State: ABy/qLbR+LxJYrIVlr/6VrJtYnZi+qZr1QGgiUd4edc6LnXvupTwEqNn
	5GoYJWjyd/lR9yxJEF8PSZy5RDWnL5gbAMGfLfnnudmtxF9X5Hia1kIQ3w==
X-Google-Smtp-Source: APBJJlErio8R88w6hPkjHv9U1sE3XgDhIA59FX8v0mt+EbGM5PI1l6UVaaRwkK7BT6JR5R6TeEjLidNLhZjAIjPgyxo=
X-Received: by 2002:a0c:e34e:0:b0:635:dd9a:ade4 with SMTP id
 a14-20020a0ce34e000000b00635dd9aade4mr2214691qvm.16.1690024853870; Sat, 22
 Jul 2023 04:20:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230721095144.306817-1-tabba@google.com> <20230721095144.306817-2-tabba@google.com>
 <ZLr20NXdQfXlxV9j@linux.dev>
In-Reply-To: <ZLr20NXdQfXlxV9j@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Sat, 22 Jul 2023 12:20:17 +0100
Message-ID: <CA+EHjTzTv3U4j9e27DDKQp2H0tVK4H+fbSYrsrjKkQ5CxF7zzw@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] KVM: arm64: Factor out code for checking E2H into
 a macro
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Fri, Jul 21, 2023 at 10:21=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Fuad,
>
> On Fri, Jul 21, 2023 at 10:51:38AM +0100, Fuad Tabba wrote:
> > The code for checking whether the kernel is in (h)VHE mode is
> > repeated, and will be needed again in future patches. Factor it
> > out in a macro.
> >
> > No functional change intended.
> > No change in emitted assembly code intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Looks good, one nitpick below:
>
> > ---
> >  arch/arm64/include/asm/el2_setup.h | 19 ++++++++++---------
> >  1 file changed, 10 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/as=
m/el2_setup.h
> > index 8e5ffb58f83e..383f6be66ed6 100644
> > --- a/arch/arm64/include/asm/el2_setup.h
> > +++ b/arch/arm64/include/asm/el2_setup.h
> > @@ -31,6 +31,13 @@
> >  .Lskip_hcrx_\@:
> >  .endm
> >
> > +/* Check if running in host at EL2 mode, i.e., (h)VHE. Jumps to fail i=
f not. */
> > +.macro __check_e2h fail, tmp
> > +     mrs     \tmp, hcr_el2
> > +     and     \tmp, \tmp, #HCR_E2H
> > +     cbz     \tmp, \fail
> > +.endm
> > +
>
> I was really hoping for the macro to have hVHE somewhere in the name,
> since it may not be immediately obvious to folks why we're testing E2H
> in this context.
>
> So maybe: s/__check_e2h/__check_hvhe/ ?
>
> I can fix it up when applying the series if you agree.

I agree. Thanks for doing that!

Cheers,
/fuad

>
> --
> Thanks,
> Oliver
