Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E70A47
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 05:29:37 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b5c2433134so3526931fa.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 22:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688621375; x=1691213375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FaztYOK3CeeSOgdOjNlGUDoiqmvgCpcAtf+Kjtl/Zxo=;
        b=oLDUHC7o8LLIpKQ47Bka4IhCDsnUOJ8PJa0mHtGy5+xmtH0ph+DN7fT2bOCyxUZ/OK
         voaasNoiVitwlvc6GdEXWSG+xw+zAyvNt5YIOkZ1Gv4N8GPo9GksM1sfnehNwooTJ6MC
         TIGRcSt6tw1MrfY6kMBuzzrrO3OFxrZGWrz+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688621375; x=1691213375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FaztYOK3CeeSOgdOjNlGUDoiqmvgCpcAtf+Kjtl/Zxo=;
        b=Q5gA3dZo7juS9AO9TW5VJCp5IfpdReBqy8fV/ODEAIxXw9hxWPEtqpRewfloGEOHFO
         +Ur2Qq4j3L3f6vDdxMfLNMkYcbzjpk+syuUzTsQUPKfaYPUaQHQmwGLL8j4eqLsHi4gQ
         NFhGb5nV+EYLGZ1STNu7p9XxWUOo5aS9LHp6FKpDSDDNTkeaZeYwKZc2A+3HHodG+5qU
         RVsoM66MD/8BFWUywLb7cXFgot9zmITErf23Q2qYjI/YnUVSY47gBvRAs8Q8CukD9V2e
         lC+fThX/YcARS9K7J5u+Hqh2/6NVph/UJ1cq+F0JoNlE9QFokKM+1uLTo31600CVJeTX
         7hAA==
X-Gm-Message-State: ABy/qLYE8/nbp90yp5rFTv4XVdRiHQ2xAWNTcHCgx8i8jtT49jAhRz7X
	yc633zhLQfjwsiu9uN6J8o1yFdK1CrpFcTWxTp9ZjQ==
X-Google-Smtp-Source: APBJJlFoQbGHquM/8F8vHFVN0DzDyQkinz8d9jngOAhWJR4+2GRUPIv/nW729Pai2dwCQYTiCsN6nZl/3HDPmf9AC/g=
X-Received: by 2002:a05:651c:107b:b0:2b6:d7d2:1a65 with SMTP id
 y27-20020a05651c107b00b002b6d7d21a65mr1632317ljm.18.1688621375279; Wed, 05
 Jul 2023 22:29:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-3-stevensd@google.com>
 <20230705031002.xrxk42hli6oavtlt@linux.intel.com> <CAD=HUj6-VbznOOtn5WJee7Of_nh33ygg7_ph2G=hgnvNk_Cbsw@mail.gmail.com>
 <20230705105343.iounmlflfued7lco@linux.intel.com>
In-Reply-To: <20230705105343.iounmlflfued7lco@linux.intel.com>
From: David Stevens <stevensd@chromium.org>
Date: Thu, 6 Jul 2023 14:29:24 +0900
Message-ID: <CAD=HUj5ezWt7rLAv2qOpFsMHyFU87Hqtw_p8pWNF5+oxbLhxDg@mail.gmail.com>
Subject: Re: [PATCH v7 2/8] KVM: Introduce __kvm_follow_pfn function
To: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 5, 2023 at 7:53=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel.com=
> wrote:
>
> On Wed, Jul 05, 2023 at 06:22:59PM +0900, David Stevens wrote:
> > On Wed, Jul 5, 2023 at 12:10=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.inte=
l.com> wrote:
> > >
> > > > @@ -2514,35 +2512,26 @@ static bool hva_to_pfn_fast(unsigned long a=
ddr, bool write_fault,
> > > >   * The slow path to get the pfn of the specified host virtual addr=
ess,
> > > >   * 1 indicates success, -errno is returned if error is detected.
> > > >   */
> > > > -static int hva_to_pfn_slow(unsigned long addr, bool *async, bool w=
rite_fault,
> > > > -                        bool interruptible, bool *writable, kvm_pf=
n_t *pfn)
> > > > +static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t =
*pfn)
> > > >  {
> > > > -     unsigned int flags =3D FOLL_HWPOISON;
> > > > +     unsigned int flags =3D FOLL_HWPOISON | FOLL_GET | foll->flags=
;
> > > >       struct page *page;
> > > >       int npages;
> > > >
> > > >       might_sleep();
> > > >
> > > > -     if (writable)
> > > > -             *writable =3D write_fault;
> > > > -
> > > > -     if (write_fault)
> > > > -             flags |=3D FOLL_WRITE;
> > > > -     if (async)
> > > > -             flags |=3D FOLL_NOWAIT;
> > > > -     if (interruptible)
> > > > -             flags |=3D FOLL_INTERRUPTIBLE;
> > > > -
> > > > -     npages =3D get_user_pages_unlocked(addr, 1, &page, flags);
> > > > +     npages =3D get_user_pages_unlocked(foll->hva, 1, &page, flags=
);
> > > >       if (npages !=3D 1)
> > > >               return npages;
> > > >
> > > > +     foll->writable =3D (foll->flags & FOLL_WRITE) && foll->allow_=
write_mapping;
> > > > +
> > > >       /* map read fault as writable if possible */
> > > > -     if (unlikely(!write_fault) && writable) {
> > > > +     if (unlikely(!foll->writable) && foll->allow_write_mapping) {
> > >
> > > I guess !foll->writable should be !(foll->flags & FOLL_WRITE) here.
> >
> > The two statements are logically equivalent, although I guess using
> > !(foll->flags & FOLL_WRITE) may be a little clearer, if a little more
> > verbose.
>
> Well, as the comment says, we wanna try to map the read fault as writable
> whenever possible. And __gfn_to_pfn_memslot() will only set the FOLL_WRIT=
E
> for write faults. So I guess using !foll->writable will not allow this.
> Did I miss anything?

We just set the foll->writable out parameter to be equal to
((foll->flags & FOLL_WRITE) && foll->allow_write_mapping). Taking a =3D
foll->flags & FOLL_WRITE and b =3D foll->allow_write_mapping, we have
!(a && b) && b -> (!a || !b) && b -> (!a && b) || (!b && b) -> !a &&
b.

-David
