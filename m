Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865D812C46F;
	Wed,  7 Aug 2024 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723045500; cv=none; b=hC2VHNNm0uHT33xjgMyca/IsHO6AI2v9fEGG8RWG/DUm7S1+xDS4sbqPGUBVbbc3qiur0q4EXFTDl6ZF4C2NZnGQcPjw97OXjRi43/qspfJ+rMYhCAJ0tBUpC/FUJzn+d7Vn5jpvlLxnjHilnuYeR8uh5f2yXvcdiwgU0L+8oHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723045500; c=relaxed/simple;
	bh=62DRcqqeC5v6AnH2Jdg1gao0bSakZspPdgIljEIRA+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wv7e0T6uF02uVmPHOUSkNVtnDVmVdkwG0MiSocA9yy3CkwAIgZDiPJufYsmdtuObNLa9DseB3HgL2MMB1/IsczEcLV1Yb5Wj49eewPJMQ/opajq5/d2D/H47xj6oheEPJ2RBC/YDerKigmDdJTNCcA0ByvaZvY9sm8s0oMTK0jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZSCK7VKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSCK7VKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3FFC4AF0F;
	Wed,  7 Aug 2024 15:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723045500;
	bh=62DRcqqeC5v6AnH2Jdg1gao0bSakZspPdgIljEIRA+8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZSCK7VKGfrUUYWa85qY72U563KSZ7oAWK9C1SmiKZTS4h5x/6E+ew0qyMMpdk0yRF
	 DSqC6UEiFpc1jg5j0fuU8saCQs9kAViz9G2Unej4kLqNynQmW11z2S+AY47JGjFs+n
	 7jIuFifNc4j4X9JmQQr+BCSh1JKh2wM46HqL9F/ruVsehCMwvQt/LMof/yq/W2znap
	 03pzS1oK0CBWdcohdlosPgDPUF1aT15QwrDYa+r+DDKdBxtm1Rl7xuFGNFkC+uK6e/
	 p5VarmwbzVjNmwq3yV+sPnQtCf/hhzyAcPNHztwXh5KpYrJG9E3YiskeZLPQsZ3nY8
	 gLgSmBZ4cCJpg==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52f04b3cb33so4526916e87.0;
        Wed, 07 Aug 2024 08:44:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXP01FidMijv7oIT8FGf0f0H//lpN7iyYPK7vCBHunBWMi8PrjvOSS60Jytbqn/eJijFWlk88GTE01O8nsrlKIUgicMHWQKGe95AUtT9tXBcf6IK98bpMZqIbtwkg==
X-Gm-Message-State: AOJu0YypJ94j6ZaWxyocAJdQVRI3zTkXy6LKYw2GU8cb6WNamdZTetRI
	PtVvv4Z5cGw3LNCEnLGPYT8v0mlIIcdEJf0emThLgZz2pezgNa8oIptmKAVNFWWwBVbnAxzA3u5
	73B2ZsO31K5Y6pcZFf5VYFPmclkM=
X-Google-Smtp-Source: AGHT+IEkoeCcq7YGXm+baiHlwfmxdsFq0ZRVrTrB1cw7IHXDs0yss2GR/vUuBkAzPzYypMT+IeV+DjGwfXLBANG7Jew=
X-Received: by 2002:a05:6512:b8d:b0:52e:8071:e89d with SMTP id
 2adb3069b0e04-530bb3b45f5mr17596549e87.40.1723045498671; Wed, 07 Aug 2024
 08:44:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807-macos-build-support-v1-0-4cd1ded85694@samsung.com>
 <20240807-macos-build-support-v1-6-4cd1ded85694@samsung.com> <20240807-outgoing-charcoal-collie-0ee37e@lindesnes>
In-Reply-To: <20240807-outgoing-charcoal-collie-0ee37e@lindesnes>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 8 Aug 2024 00:44:22 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQ21o+cQQaLD1xkwSX0ma8hvB29DMDquy5VjHcBWwhGPw@mail.gmail.com>
Message-ID: <CAK7LNAQ21o+cQQaLD1xkwSX0ma8hvB29DMDquy5VjHcBWwhGPw@mail.gmail.com>
Subject: Re: [PATCH 06/12] selinux/genheaders: include bitsperlong and
 posix_types headers
To: Nicolas Schier <nicolas@fjasle.eu>
Cc: da.gomez@samsung.com, Nathan Chancellor <nathan@kernel.org>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, 
	William Hubbs <w.d.hubbs@gmail.com>, Chris Brannon <chris@the-brannons.com>, 
	Kirk Reiser <kirk@reisers.ca>, Samuel Thibault <samuel.thibault@ens-lyon.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Jiri Slaby <jirislaby@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, intel-xe@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, speakup@linux-speakup.org, 
	selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-serial@vger.kernel.org, llvm@lists.linux.dev, 
	Finn Behrens <me@kloenk.dev>, "Daniel Gomez (Samsung)" <d+samsung@kruces.com>, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 8, 2024 at 12:39=E2=80=AFAM Nicolas Schier <nicolas@fjasle.eu> =
wrote:
>
> On Wed, Aug 07, 2024 at 01:09:20AM +0200, Daniel Gomez via B4 Relay wrote=
:
> > From: Daniel Gomez <da.gomez@samsung.com>
> >
> > The genheaders requires the bitsperlong.h and posix_types.h headers.
> > To ensure these headers are found during compilation on macOS hosts,
> > add usr/include to HOST_EXTRACFLAGS in the genheaders Makefile. This
> > adjustment allows the compiler to locate all necessary headers when the=
y
> > are not available by default on macOS.
> >
> > Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> > ---
> >  scripts/selinux/genheaders/Makefile | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/scripts/selinux/genheaders/Makefile b/scripts/selinux/genh=
eaders/Makefile
> > index 1faf7f07e8db..017149c90f8e 100644
> > --- a/scripts/selinux/genheaders/Makefile
> > +++ b/scripts/selinux/genheaders/Makefile
> > @@ -2,4 +2,5 @@
> >  hostprogs-always-y +=3D genheaders
> >  HOST_EXTRACFLAGS +=3D \
> >       -I$(srctree)/include/uapi -I$(srctree)/include \
> > -     -I$(srctree)/security/selinux/include
> > +     -I$(srctree)/security/selinux/include \
> > +     -I$(srctree)/usr/include
>
> 'make headers' composes the UAPI header tree in $(objtree)/usr/include.
> So, if you build out-of-source, -I$(srctree)/usr/include will not match.
> Just remove the '$(srctree)/' prefix as '$(objtree)/' is always '.'.


Right.


> But I am suspecting that this break cross-building.


Right.

We cannot do this.


--
Best Regards
Masahiro Yamada
