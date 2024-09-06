Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A7A1C9EA8;
	Fri,  6 Sep 2024 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637076; cv=none; b=Cq6SD0R953ADxRkQMT1ErgEsyQvAhWEjpSnHtlYCsrRrD3TE9Jr3KGjAI9y/2M8cuLIh8pkYwH2VSQOYw3rFQF3G9NHqB6WhXy+FZqIO7hV5wRKslG7pPCY3EOAUMy7qktiJeOaqiA5+ZteaJ32JsV6UVWe6H7KXmHnWu/dY74Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637076; c=relaxed/simple;
	bh=2UKmaZtNLMhEviH6IeYoUF4i0dN1ltzq9GMvMgOlDQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rWYQ1JS4LchuQmfMcL3IqDEZPRV2ohnVQ0cRXtWRwtBgBUJn2RfKF8cvzcAo7a5s+OxOsoJWaWtfhYYI00YhvWXFXFTfBi2nEjF2GZIxlytYYt/j0fU1WQnnn/050ba6g+6GVDmC+2EPtEC4mMzNr5xxtfeZ7V6+P3WNuBLKw8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+uGcia6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+uGcia6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657E6C4CECD;
	Fri,  6 Sep 2024 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725637075;
	bh=2UKmaZtNLMhEviH6IeYoUF4i0dN1ltzq9GMvMgOlDQg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=D+uGcia6C1rMFfGtzuNOkJuofRcalbpLcwqkWo4QCWmBvbKYPJGA/uSDWpwZjBbmB
	 njLZLd39uJ74CDwwpHnOywo+j9w6RfLW9osPDFdwmgM58Feg3ncW7nfU9kwamY+IMy
	 99Py1s10IMSqqtK6gyrueYStEJqVfklEmVG7fAAmOMmjp7xtwGpS2Qy70uF4wbani/
	 Arp55SZxjIHtg+pC2RSd0gh/dunKUeUaGhb0g6r6jx92vIQXhc9rNmXyDaGmHGxnxH
	 mMaAlC4PbOxH77iNGW7Pvshd1MvQ6r6pNMr6RuFr1dAs5SjdWnfJTeb/GI6MK/vsYd
	 QhGUIsjQ5VrGw==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53655b9bbcdso1852608e87.2;
        Fri, 06 Sep 2024 08:37:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW0b3DeaYVkX+RebwhzLNI5QaZB+kogCivZuURRr1skuIq/EudRh7QsQwwOYAIb5DAJ+jDcBnE=@lists.linux.dev, AJvYcCWubbfCYZUX7utM1j/YLt1pZjmLDejT8TvKaPHuLyUbFogmg+iDVFFdAbSgNi5s6R4iPlusdw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+dDQL4wX7adnFL+yxKnCyGWlGNK/L+FzZ0XTpaK9r90RuOf/X
	Pz/IMeiUZR6t73JIYioDKXx0a1S19UGATQRZjS7NYAF/t7PHGLG4qlqL/TWpoWWatXIGCLIykjU
	8Jj0R2eUT5gMQTh4dbSHxyeZEnpQ=
X-Google-Smtp-Source: AGHT+IFANMBQ3/Jcqmb4USNwfdW9Zoa8E3V2AYrxt1g8TZNZwyh6S+HB/OdPYQYnVIS/P9F4Mt5DF0hoACFuvJ/eFH4=
X-Received: by 2002:a05:6512:104f:b0:533:46cc:a71e with SMTP id
 2adb3069b0e04-536588103damr2074798e87.54.1725637073910; Fri, 06 Sep 2024
 08:37:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com>
 <20240906-macos-build-support-v2-7-06beff418848@samsung.com> <CAHC9VhQkstJ8Ox-T+FLU34s9U0gezRba6bMA-tUPs80u6sVh2g@mail.gmail.com>
In-Reply-To: <CAHC9VhQkstJ8Ox-T+FLU34s9U0gezRba6bMA-tUPs80u6sVh2g@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sat, 7 Sep 2024 00:37:16 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQytsDzaJfAJA0nL=KPjxj3DBCRLeuHUwgGDt8fTJ0fTQ@mail.gmail.com>
Message-ID: <CAK7LNAQytsDzaJfAJA0nL=KPjxj3DBCRLeuHUwgGDt8fTJ0fTQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] selinux: move genheaders to security/selinux/
To: Paul Moore <paul@paul-moore.com>
Cc: da.gomez@samsung.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Lucas De Marchi <lucas.demarchi@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	William Hubbs <w.d.hubbs@gmail.com>, Chris Brannon <chris@the-brannons.com>, 
	Kirk Reiser <kirk@reisers.ca>, Samuel Thibault <samuel.thibault@ens-lyon.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Simona Vetter <simona.vetter@ffwll.ch>, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	speakup@linux-speakup.org, selinux@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-serial@vger.kernel.org, llvm@lists.linux.dev, 
	Finn Behrens <me@kloenk.dev>, "Daniel Gomez (Samsung)" <d+samsung@kruces.com>, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 6, 2024 at 11:54=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> On Fri, Sep 6, 2024 at 7:01=E2=80=AFAM Daniel Gomez via B4 Relay
> <devnull+da.gomez.samsung.com@kernel.org> wrote:
> >
> > From: Masahiro Yamada <masahiroy@kernel.org>
> >
> > This tool is only used in security/selinux/Makefile.
> >
> > There is no reason to keep it under scripts/.
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > ---
> >  scripts/remove-stale-files                                    | 3 +++
> >  scripts/selinux/Makefile                                      | 2 +-
> >  scripts/selinux/genheaders/.gitignore                         | 2 --
> >  scripts/selinux/genheaders/Makefile                           | 3 ---
> >  security/selinux/.gitignore                                   | 1 +
> >  security/selinux/Makefile                                     | 7 ++++=
+--
> >  {scripts/selinux/genheaders =3D> security/selinux}/genheaders.c | 0
> >  7 files changed, 10 insertions(+), 8 deletions(-)
>
> Did you read my comments on your previous posting of this patch?  Here
> is a lore link in case you missed it or it was swallowed by your
> inbox:
>
> https://lore.kernel.org/selinux/3447459d08dd7ebb58972129cddf1c44@paul-moo=
re.com
>
> Unless there is an serious need for this relocation, and I don't see
> one explicitly documented either in this patchset or the previous, I
> don't want to see this patch go upstream.


I commented on the previous thread.


I will reword it as follows:


--------------->8--------------------
selinux: move genheaders to security/selinux/

This tool is only used in security/selinux/Makefile.

Move it to security/selinux/ so that 'make clean' can clean it up.

Please note 'make clean' does not visit scripts/ because tools under
scripts/ are often used for external module builds. Obviously, genheaders
is not the case here.
--------------->8--------------------






--
Best Regards

Masahiro Yamada
