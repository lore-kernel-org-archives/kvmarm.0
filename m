Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795564374;
	b=fPSEQ2LP2LXtfQLjXhQDdt5uxGTNc0/0RGKeRPFHehuJ18+vvaWJFPQBwmoH6GTGx9ZM
	 XPOihlGO2w/FaQvO45iwWYNEoqOEXzZy/pgw0RjMfF8xLfqECaPnGPYIXYMXl7DYzVMEW
	 pR+OhxM8g595A28ZXEbWM/9uiQj+RecvpNHl1DzZdXX8Vfq0JcrmYLS7NJtICzC0ZU2p9
	 cQJ+Iaulh7zr9bk4fHUUxbUoHxfgr9DcQrvA2ZLTscC85TOIp/Ck0VVUkGMFZwNABCphz
	 Yii4Ntzmz2+C9pwKUcfb7JyKdqDk4fXY1LynpeP9pW1bXxf7gzrAanO0M4UhlAHXQ6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795564374;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FdmbSo5Y/+1WVcBaZi3UOeVDRS7HdI9UnXMTYxRF8pM=;
	b=11ySd8SdU6FkU1UfZzB2jM7yJcmv/WA8XeAlu37lSJzXClJd3W3M/ReERH/Pf257WOKn
	 RAduTx+L8kv/qO45FxCM2v+ukESPuw2/F4DiWu8rM7tbxsV1m79GzCM/VlKWofr3JUjDj
	 16TBb/XJB/gqnRMQ3kAW7+/rDOKX9FY9ysVQ7Cn5WlxCWPLa+uEjyzi6WyLlew1lmPCZj
	 qUuH7nUTBbss0jWiTvsy+nl8Avq8HydNLLtvvMRc1Q2e2u4hSYA7jwvh2a54wo5a0ixTX
	 Pd3ufLTPy2i3kZifa7uwvZgm0hNlLIWSjkvrgtI7BDoPd1joToMQ6wOyj+ZoaZ9zpUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sxln5p4T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D3E606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 23:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sxln5p4T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84941F000C4
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 23:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795564373;
	bh=FdmbSo5Y/+1WVcBaZi3UOeVDRS7HdI9UnXMTYxRF8pM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Sxln5p4TnQV37sviKlKWXp5rOvoFAUSUNEhADtcG4eGJK7Roa/GTplzxTEvlNg1FP
	 tkk2V7FcUY/Xf+cMmNe9kSQPBEICb04tRRJR1S3wgMsgCSboJjspXH9uxM/MnNHr3/
	 nCOBgg3cBDtm5T5N3aV2U1eqbf16WwXvjzJb6i4ZK2qfWXmnQ/ZRL2SMbhmDSFiZFe
	 cP0NdDu+5UZDnyTbbAWmjka7cbeq9kMBgDOfnpHG8O4iOsIJ8XuD36ABIWr1xkC3pK
	 UAnISlFk7aXkcGMluVa/CChhbEH/loe4oHFIQ6UH6A9i7X8tHD2u1XfRG8Pf7N6Bbt
	 BczI9l5DSCPdg==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5c158c4c15fso6366841e87.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 15:52:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEeYlLT/632Gdvc87I5MQGRwF80lUS8EwDlNOq6NQuTqvuEvi+DzAoFyi1qmMv8wWx7OWwsYc8=@lists.linux.dev
X-Gm-Message-State: APuU4Z+huYSq0q9+y+EFWhx9tyPrsleVbTarUJmGLH5JoD7JEYDyrLMg
	ze3+TGj25ZZ5FRBh+EHuUk9xocFPfqWvV4XVCvnnDMWV2GEbXcEnpfMlIdzkpQFrg2PBg7jFkLh
	3zyoUGX61sCRC0F6rB/081smiE6vmB/w=
X-Received: by 2002:a05:6512:3c86:b0:5bf:a34f:14ce with SMTP id
 2adb3069b0e04-5c1b7bcb80cmr4369964e87.11.1795564372635; Tue, 24 Nov 2026
 15:52:52 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261015142552.4128028-1-ryan.roberts@arm.com> <20261015142552.4128028-14-ryan.roberts@arm.com>
In-Reply-To: <20261015142552.4128028-14-ryan.roberts@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 25 Nov 2026 00:52:40 +0100
X-Gmail-Original-Message-ID: <CAD++jLmpMQ1KExszFo-So-dQ2rxDiG2fo1GYGV_T0VPQM2b=MQ@mail.gmail.com>
X-Gm-Features: Aa3M54pFqitfpRija09wdUEiLNXZP7zwbQjloIBuStVWLIh0bhqixHx00fUO9n0
Message-ID: <CAD++jLmpMQ1KExszFo-So-dQ2rxDiG2fo1GYGV_T0VPQM2b=MQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 13/15] misc/arm-cla: Add stage-2 MTC and VM context switch
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@nvidia.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Jean-Philippe Brucker <jpb@kernel.org>, Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ryan, Jean-Philippe,

On Thu, Oct 15, 2026 at 4:27=E2=80=AFPM Ryan Roberts <ryan.roberts@arm.com>=
 wrote:

> From: Jean-Philippe Brucker <jpb@kernel.org>
>
> Add functions to switch the guest MTC. Reset the accelerators and CLA
> registers on switch. No save/restore of accelerators at the moment, we
> only restore the kernel's PL0CTL.
>
> Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
(...)

> +/**
> + * struct cla_regs_pl1 - Saved CLA register state (PL1)
> + * @pl0ctrl: Host PL0 control register
> + *
> + * Most registers are simply reset when transitionning to and from VMs, =
since we
> + * don't support shared assignment.
> + */
> +struct cla_regs_pl1 {
> +       u64 pl0ctrl;
> +};
> +

> +enum cla_ctx_type {
> +       CLA_CTX_PL0,
> +       CLA_CTX_PL1,
> +};

Please add authoritative definitions of the these two context states
here so we know exactly what they are for.

>   * Mutable, written by domain reassignment, device work, and CPU hotplug=
:
>   * @regs:              State for each device in domain.
>   * @asid:              Pinned ASID of live context.
> + * @guest_mmu:         Stage 2 translation configuration.

Since they are now in a union there is some information missing here,
asid for PL0, guest_mmu for PL1?

>   */
>  struct cla_ctx {
>         struct kref refcnt;
> @@ -191,7 +220,10 @@ struct cla_ctx {
>         refcount_t users;
>         struct list_head queue_node;
>         void **regs;
> -       unsigned int asid;
> +       union {
> +               unsigned int asid;
> +               struct kvm_arch_guest_mmu *guest_mmu;
> +       };
>         wait_queue_head_t waitq;
>  };

(...)

>  /**
>   * cla_ctx_create - Create a context or increase its user count
>   * @domain: CLA domain
> @@ -48,8 +79,12 @@ struct cla_ctx *cla_ctx_create(struct cla_domain *doma=
in,
>         INIT_LIST_HEAD(&ctx->queue_node);
>         init_waitqueue_head(&ctx->waitq);
>
> -       mmgrab(key->mm);
> -       get_file(key->file);
> +       if (cla_ctx_is_pl0(ctx)) {
> +               mmgrab(key->mm);
> +               get_file(key->file);
> +       } else {
> +               WARN_ON(!cla_ctx_get_pl1(ctx));
> +       }

This WARN_ON looks more like an assert() of some kind?
Since it's an enum and assigned from those everywher
this is basically a check for memory corruption...?

Well maybe better safe than sorry.

If you want to employ this pattern, and especially if there
will be PL2, PL3 etc in the future, do a switch?

switch (ctx->key.type) {
case CLA_CTX_PL0:
    mmgrab(key->mm);
    get_file(key->file);
    break;
case CLA_CTX_PL1:
    break;
default:
    WARN_ON(1); /* Should never happen */
    break;
}

So you would then use that pattern also here:

> -       mmdrop(key->mm);
> -       fput(key->file);
> +       if (cla_ctx_is_pl0(ctx)) {
> +               mmdrop(key->mm);
> +               fput(key->file);
> +       } else {
> +               cla_ctx_put_pl1(ctx);
> +       }

And here:

> -       mmdrop(ctx->key.mm);
> -       fput(ctx->key.file);
> +       if (cla_ctx_is_pl0(ctx)) {
> +               mmdrop(ctx->key.mm);
> +               fput(ctx->key.file);
> +       } else {
> +               cla_ctx_put_pl1(ctx);
> +       }


>  #define cla_kernel_mtc \
>         (cla_kernel_pl =3D=3D 2 ? CLA_MTC_REGIDX_PL2 : CLA_MTC_REGIDX_PL1=
)
>
> +/**
> + * struct cla_mtc_s2 - Stage 2 MTC configuration for the host or a VM.
> + * @hcr: HCR_EL2 register value.
> + * @vttbr: VTTBR_EL2 register value.
> + * @vtcr: VTCR_EL2 register value.
> + */
> +struct cla_mtc_s2 {
> +       u64 hcr;
> +       u64 vttbr;
> +       u64 vtcr;
> +};

At this point I have no idea what "stage 1" and "stage 2" is, but I just
assume it is something everyone working on virtualization knows about.
Maybe it could be explained briefly in the commit message for the
rest of us?

Yours,
Linus Walleij
