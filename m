Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C49191;
	Sun,  8 Sep 2024 01:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725758306; cv=none; b=tsDAUYjxzfFXPy3gydUSfSHg2Tid8Di9+JVLzomWKYDtgpiMd+9DnI3o62caMmU+ORSSe6fLlrbfKCMB6j5H1xiFQg95Ly/fvZkKPolZ44NeT/E3Ihs0MdRdYMxIGMAILezdcAT76opJxRXAISAEzFm91d9meDb88RYthdwBHWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725758306; c=relaxed/simple;
	bh=M8wGQ4W/KVkVnctgfPoNFBJOh6tq/LCaviiGYsF9L8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VUPKN6gE3LsxiRqEku1EwPvB1X/fRdf9bGnkqUaAAWTzxWcY1WMthMgzQBZ7e2nFiT3fxq3L5NMB+LxRj9QMwxLDmV5bZn8KQmLKA++EWt8rMX9H7qYH3IqL581BMAVXxKEKfqRh0rQMyF/XcM9kuyZdj9ZIduJEINgwOEDfIbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cq9lwmXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cq9lwmXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F4AC4CEDC;
	Sun,  8 Sep 2024 01:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725758306;
	bh=M8wGQ4W/KVkVnctgfPoNFBJOh6tq/LCaviiGYsF9L8s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cq9lwmXgWqhZPEPEknJJ6MusaNmJeXzo45ZYCP7ssXKwk+6pZEIShmFZ0bjRL2S69
	 ABj7sxuwzlMeZtfiuSVujQMmsIXJkZtFQd7pHlDm6BUyiPgE+fRCrnf8beNYJuy+ji
	 oQOUNrABUCQYCeiOkIaYFeDPjuOLfYgzj/2JTZK6tv2u55Q21XGQb8RQjQDXYie67v
	 MdshnfSfCPObqDnnZxY2ynGVQzEQcWiGZH9lFGCcniAEiK0rSLkI2qtihQaaKcK2t3
	 NSADrCgThi939DlQOQEISpxvU/bWX7VErE7YTncTlMIeCFowuYeR4y/5JWrhSOJFDa
	 LlWxCtzCQOwmA==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5365aec6fc1so2030112e87.3;
        Sat, 07 Sep 2024 18:18:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUw8fKhwy2ffXVr7Kr5so0TaVz2R/RcWlFHELTk+bSTH2CtrbOlCQ1HpQl1v1+k1hETiXWR5Ao=@lists.linux.dev, AJvYcCV8vTLKfkPMF8a/aKsfZoOmJPnbVXh9QF48unMJF8664E8my1yTGwnq+APfdiJtakoKpvXvxw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyPQz3p/dPdjDaZHI8WUjgBsR4CkVnun+P8sX/t2lNHTXKIiXFQ
	+E5B9A+smLNxfJZAIONn74udiKAf7peLlpfrMvbeCB1+Yj64eaZxd4JyCh+ztHvPdSet6ReCATu
	OsqnG4ajxK1t3KpSSfv+SZ0VRbuE=
X-Google-Smtp-Source: AGHT+IG//4gp0E4CfR083hPUBPN1CAx4mVwnwf3ahT0xcRrWXpKuALg+jAmTZu237ZONFZpFVA24RBtvauTzOfWgMvg=
X-Received: by 2002:a05:6512:224b:b0:536:56d6:ea4f with SMTP id
 2adb3069b0e04-536587b4312mr5939673e87.29.1725758304396; Sat, 07 Sep 2024
 18:18:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com>
 <20240906-macos-build-support-v2-4-06beff418848@samsung.com>
 <CAK7LNARTnJ10ABuD96U-MaYitnX3AF=GD+N-skH7VBfAmOw9RQ@mail.gmail.com> <CABj0suDiPf0ySOwQx=6k+6bTZqRmq1+tjPx7=dxSTO5DVqO4nQ@mail.gmail.com>
In-Reply-To: <CABj0suDiPf0ySOwQx=6k+6bTZqRmq1+tjPx7=dxSTO5DVqO4nQ@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sun, 8 Sep 2024 10:17:48 +0900
X-Gmail-Original-Message-ID: <CAK7LNATc8-mxNLRjLLwd6bKs9mbpo2FxhChWbJHwiGpOr_hzBg@mail.gmail.com>
Message-ID: <CAK7LNATc8-mxNLRjLLwd6bKs9mbpo2FxhChWbJHwiGpOr_hzBg@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] arm64: nvhe: add bee-headers support
To: "Daniel Gomez (Samsung)" <d+samsung@kruces.com>
Cc: da.gomez@samsung.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Lucas De Marchi <lucas.demarchi@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	William Hubbs <w.d.hubbs@gmail.com>, Chris Brannon <chris@the-brannons.com>, 
	Kirk Reiser <kirk@reisers.ca>, Samuel Thibault <samuel.thibault@ens-lyon.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Jiri Slaby <jirislaby@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Simona Vetter <simona.vetter@ffwll.ch>, linux-kernel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, intel-xe@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, speakup@linux-speakup.org, 
	selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-serial@vger.kernel.org, llvm@lists.linux.dev, 
	Finn Behrens <me@kloenk.dev>, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 7, 2024 at 6:28=E2=80=AFPM Daniel Gomez (Samsung)
<d+samsung@kruces.com> wrote:
>
> On Fri, Sep 6, 2024 at 4:03=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.=
org> wrote:
> >
> > On Fri, Sep 6, 2024 at 8:01=E2=80=AFPM Daniel Gomez via B4 Relay
> > <devnull+da.gomez.samsung.com@kernel.org> wrote:
> > >
> > > From: Daniel Gomez <da.gomez@samsung.com>
> > >
> > > endian.h header is not provided by default in macOS. Use pkg-config w=
ith
> > > the new development package 'bee-headers' [1] to find the path where =
the
> > > headers are installed.
> > >
> > > [1] Bee Headers Project links:
> > > https://github.com/bee-headers/headers
> > > https://github.com/bee-headers/homebrew-bee-headers
> > >
> > > It requires to install bee-headers Homebrew Tap:
> > >
> > >   brew tap bee-headers/bee-headers
> > >   brew install bee-headers/bee-headers/bee-headers
> > >
> > > Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> > > ---
> > >  arch/arm64/kernel/pi/Makefile     | 1 +
> > >  arch/arm64/kernel/vdso32/Makefile | 1 +
> > >  arch/arm64/kvm/hyp/nvhe/Makefile  | 3 ++-
> > >  3 files changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Mak=
efile
> > > index 4d11a8c29181..259c9a45fba0 100644
> > > --- a/arch/arm64/kernel/pi/Makefile
> > > +++ b/arch/arm64/kernel/pi/Makefile
> > > @@ -20,6 +20,7 @@ KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_SCS), $(=
KBUILD_CFLAGS))
> > >  KBUILD_CFLAGS  :=3D $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
> > >
> > >  hostprogs      :=3D relacheck
> > > +HOSTCFLAGS_relacheck.o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-he=
aders 2> /dev/null)
> > >
> > >  quiet_cmd_piobjcopy =3D $(quiet_cmd_objcopy)
> > >        cmd_piobjcopy =3D $(cmd_objcopy) && $(obj)/relacheck $(@) $(<)
> > > diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vd=
so32/Makefile
> > > index 25a2cb6317f3..6cb8a04bd829 100644
> > > --- a/arch/arm64/kernel/vdso32/Makefile
> > > +++ b/arch/arm64/kernel/vdso32/Makefile
> > > @@ -107,6 +107,7 @@ VDSO_LDFLAGS +=3D --orphan-handling=3D$(CONFIG_LD=
_ORPHAN_WARN_LEVEL)
> > >  # $(hostprogs) with $(obj)
> > >  munge :=3D ../../../arm/vdso/vdsomunge
> > >  hostprogs :=3D $(munge)
> > > +HOSTCFLAGS_$(munge).o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-hea=
ders 2> /dev/null)
> > >
> > >  c-obj-vdso :=3D note.o
> > >  c-obj-vdso-gettimeofday :=3D vgettimeofday.o
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nv=
he/Makefile
> > > index b43426a493df..d20a440b6964 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > > @@ -15,7 +15,8 @@ ccflags-y +=3D -fno-stack-protector     \
> > >              $(DISABLE_STACKLEAK_PLUGIN)
> > >
> > >  hostprogs :=3D gen-hyprel
> > > -HOST_EXTRACFLAGS +=3D -I$(objtree)/include
> > > +HOST_EXTRACFLAGS +=3D -I$(objtree)/include \
> > > +       $(shell $(HOSTPKG_CONFIG) --cflags bee-headers 2> /dev/null)
> > >
> > >  lib-objs :=3D clear_page.o copy_page.o memcpy.o memset.o
> > >  lib-objs :=3D $(addprefix ../../../lib/, $(lib-objs))
> > >
> > > --
> > > 2.46.0
> > >
> > >
> >
> > NACK.
> >
> > Developers working on Linux distributions have no interest
> > in your homebrew setup.
> >
> > For 99% of users, pkg-config does not do anything good.
> > It is a waste of process forks.
>
> I didn't think of this, and I agree with you.
>
> >
> >
> >
> > You need to do it outside.
> >
> >
> >  $ HOSTCFLAGS=3D$(pkg-config --cflags bee-headers) make
> >
> > or
> >
> >  $ export HOSTCFLAGS=3D$(pkg-config --cflags bee-headers)
> >  $ make
>
> Would a Makefile variable be suitable for this use case to make it
> easier in the command-line?



HOSTCFLAGS is an environment variable.


See Documentation/kbuild/kbuild.rst


  HOSTCFLAGS
  ----------
  Additional flags to be passed to $(HOSTCC) when building host programs.




If you do not want to type it every time,
add the following to ~/.profile or ~/.bashrc, etc.


export HOSTCFLAGS=3D"$(pkg-config --cflags bee-headers) -D_UUID_T
-D__GETHOSTUUID_H"




Or, if you want to limit this HOSTCFLAGS definition
only to a specific kernel tree, you can add GNUmakefile
to wrap Makefile.

This is how people often add local setups without
typing a long command.



GNUmakefile:

  export HOSTCFLAGS =3D $(shell pkg-config --cflags bee-headers)
-D_UUID_T -D__GETHOSTUUID_H
  include Makefile




Then, you do not need to bother the upstream kernel.







> We can detect we are in a non-linux based environment and enable a
> Makefile <VAR> (e.g., NOLINUX=3D1) and handle the NOLINUX build case
> (with pkg-config/bee-headers) inside the Makefiles for these non-linux
> cases.


NACK.



>
> >
> >
> >
> >
> >
> > --
> > Best Regards
> > Masahiro Yamada



--
Best Regards
Masahiro Yamada
