Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795601361;
	b=RzwZVsgg/giUMWyBNC0whr1/8nIb2J5ZItJd9gPLcnQ6UlfDK9rR8EpHBSiLdX23WhpN
	 OS0VzFyi812T+o9PgB9zWfIs+1j+wEEg0T25HXS+fyDKooM8EXXKAdJBqmRXzrZ4sBWrK
	 TcTya6g4YQOl3c2TMnXPaaBnhzd3divFHljtT5/JwVT1LvJ457WqR9TqyJ237Yh8Z7/yn
	 8P7cwUtiKXPUQ6TwW1OSdj24dw24eYVXm9ldaOkUyGEfsoDgufh7DBE58O/XnBpaz6tYK
	 Z3//qPscIWfPM2ucaiJmOyGNSA1ysfs8cGphxKZAOX338nEEpqIOHZKfyL2V1MhCvXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795601361;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9Go3NrC6R1k3c+zu1uu0vGbFmy/uD6Bj5+pEG6pyJzc=;
	b=AK06TQpt2f27bdFT2I/U94gpqBxWZgPOGG04lDH2ShiMTqt7FEOfOWMnEqL0SNSEjJPc
	 Ts+QXGWqsSuCn0kJ8ymyPDcD6s8XssA2GAqSkifiqaZyNA+3F8C9HgrDCytKqdDMyicpC
	 c7WZmmTHXFhxJj3G1Ex474ehbSgJfmt54sGMxX7WLs8hHFD83h77I4PzbYWKRxNoi89Ya
	 FSHbjp4Is7HA45sAWGtQza8Wgz7+LQ8wPz4FLkdpUoBdWhwBAKipEfBGvJ/mI0ZqeaKBl
	 DdGaipJ2jqdMOPSV8j8+zK54sUYp7E+1r4TTFi0LZAd5ussWam/83vYib2A2fEHqYHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mLS1FZtl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77436606A329
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 10:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mLS1FZtl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097EA1F00A00
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 10:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795601361;
	bh=9Go3NrC6R1k3c+zu1uu0vGbFmy/uD6Bj5+pEG6pyJzc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mLS1FZtlW/uBOd8uYBASLUw7dL8m9Cq3WOCGR+qLTLOINHxdiJqcVBElWNdcIZRFD
	 +A4pF2DOHjjuyoVAtTmsc5CVWjpwsNNyDXTel3uWZktq8sv/WR0vKkYJYdbImYJdgk
	 X9hbN4TaNJzdQGYcPQzLRKg3GKj3gUS1YfjD82L+62CJk27+ndu/jcm0xKxhSnoLA8
	 mcW4TfWVXpXvUgwpsd8YqCHdKdRngXZ4sWikgqiBwjXCXPFykO3fVB/0/dOkJMVNDr
	 S60jEr5lffFgJaeQPPD8R3xWy0rT4hePGqw/JcIqfSFURZYQuE4+ivClmJJVs3FNSq
	 1yKmzXyQRPP/Q==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3ae1fd4252fso53725601fa.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 02:09:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHU2OLB51C8+cAJmEYW3ZeKx0Lhk4Dy70THoHUoak7rpuWADi/ilBNVNwULa3xhmumcgFKLRZ0=@lists.linux.dev
X-Gm-Message-State: APuU4Z9KdFFRssg5cfFrSe1AXgy3a6UqlkplXcVr8oc0jarKUPEXruBq
	LUF5GxohWJnJCIP+FtK9p3/eLF3PacxWhwRTOEwEpC90ehkeXUuLpLEkAT8Hw+Mm/7aswNH3fIk
	2tv+tALopveIhzoyuZ8YyEotRy1VdlQA=
X-Received: by 2002:a05:6512:3e1a:b0:5c1:4f34:922b with SMTP id
 2adb3069b0e04-5c1bc8726b5mr4818493e87.54.1795601359755; Wed, 25 Nov 2026
 02:09:19 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261015142552.4128028-1-ryan.roberts@arm.com> <20261015142552.4128028-15-ryan.roberts@arm.com>
In-Reply-To: <20261015142552.4128028-15-ryan.roberts@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 25 Nov 2026 11:09:07 +0100
X-Gmail-Original-Message-ID: <CAD++jL=bXyBRP8oBr2xtzwkzbEPHXCKA0XPXRueY6pUSagbXtQ@mail.gmail.com>
X-Gm-Features: Aa3M54rLQayJf3xCdY0Eq4zHAmpJ1R1cYyaDehvs8Q24SnEwz4VjC8tWxJP40dg
Message-ID: <CAD++jL=bXyBRP8oBr2xtzwkzbEPHXCKA0XPXRueY6pUSagbXtQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 14/15] misc/arm-cla: Support exclusive context assignment
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
> Introduce a nr_contexts members to cla_domain to count the mapped
> contexts. At the moment PL0 contexts share the domain, while PL1
> contexts require exclusive assignment, since there is no context
> save/restore.

Do you mean to say there is no context save/restore for the
virtualiuzed users? Because there seems to be for the ordinary
(kernel arbitrated) ones.

> A negative count indicates the domain is exclusive.

Exclusive to what? Please be more specific.

> Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>

(...)

> diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cl=
a.h
> index c9ecab5ab6bf..43a58a329525 100644
> --- a/drivers/misc/arm-cla/arm-cla.h
> +++ b/drivers/misc/arm-cla/arm-cla.h
> @@ -105,6 +105,7 @@ struct cla_dev {
>   * @lock:              Protects the following members.
>   * @ctxs:              All live contexts, keyed on cla_ctx_key.
>   * @queued_ctxs:       Queue of contexts waiting for assignment.
> + * @nr_ctxs:           Context count. Negative value for exclusive assig=
nment.

Describe here what it means if a context is excludive,

> +static int cla_domain_get(struct cla_domain *domain, bool share)
> +{
> +       lockdep_assert_held(&domain->lock);
> +
> +       if (share) {
> +               /* Time share the domain with other contexts. */
> +               if (domain->nr_ctxs < 0)
> +                       return -EBUSY;
> +               domain->nr_ctxs++;
> +               WARN_ON(domain->nr_ctxs < 0); /* LONG_MAX contexts?! */
> +       } else {
> +               /* Reserve the domain for exclusive assignment. */
> +               if (domain->nr_ctxs !=3D 0)
> +                       return -EBUSY;
> +               domain->nr_ctxs--;

Maybe:
domain->nr_ctxs =3D -1;

So it is clear what is going on?

> +       }
> +       return 0;
> +}

Notice that here the _get() semantics are reference counting as is
proper, compared to the other _get() in the series that I complained about.

> +/* Undo cla_domain_get() */
> +static void cla_domain_put(struct cla_domain *domain)
> +{
> +       lockdep_assert_held(&domain->lock);
> +
> +       if (domain->nr_ctxs =3D=3D -1)
> +               domain->nr_ctxs =3D 0;
> +       else if (domain->nr_ctxs > 0)
> +               domain->nr_ctxs--;nr_c
> +       else
> +               WARN(1, "invalid domain refcount %ld\n", domain->nr_ctxs)=
;

Looks good

> @@ -53,7 +85,7 @@ struct cla_ctx *cla_ctx_create(struct cla_domain *domai=
n,
>                                struct cla_ctx_key *key)
>  {
>         struct cla_ctx *ctx;
> -       int ret =3D -ENOMEM;
> +       int ret;
>
>         mutex_lock(&domain->lock);
>         ctx =3D cla_domain_lookup_ctx(domain, key);
> @@ -68,9 +100,14 @@ struct cla_ctx *cla_ctx_create(struct cla_domain *dom=
ain,
>                 goto err_unlock;
>         }
>
> +       ret =3D cla_domain_get(domain, key->type =3D=3D CLA_CTX_PL0);

Add a comment that we can share PL0 domains only.

Yours,
Linus Walleij
