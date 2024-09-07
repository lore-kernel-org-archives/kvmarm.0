Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675401537A2
	for <kvmarm@lists.linux.dev>; Sat,  7 Sep 2024 09:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725701300; cv=none; b=kt07wCrROjG5Cbzu0JxXRq7yqSYGGE/V54Hu+pCqTJEPlTuf8qd+kEAoJ0rASiL+DidFpAmiDhhs+cXxFvOOi2GoyvgTOHNgxwa9JFnI20RtvJoRcBQdKwxhAxeS/Bo4g9PNGTpLWpmJhv1yeXs7iY54q38BTfQy1Kj5ZL0c7+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725701300; c=relaxed/simple;
	bh=lbf9xF8T6QLgnvYifItrn1rqxgvbvmSNipCKwXxHqRw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qFIbJvOb1Qrm3Lvb/R3+eLzQq7n0p5rsEAHMbqVDhs8qL3g7KGDrkIjaxlDvMpGI2XttKAHPXYJGe/VCHOLEEPShorlZCwiECNeeKtE/UwR0ulahFLJPYrwQ0gaHKY6wcSWhTSjXkq/9CkZRNOfuJvjOanIRNcWpbFXuZHry9+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kruces.com; spf=pass smtp.mailfrom=kruces.com; dkim=pass (2048-bit key) header.d=kruces-com.20230601.gappssmtp.com header.i=@kruces-com.20230601.gappssmtp.com header.b=ZtY9swzQ; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kruces.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kruces.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kruces-com.20230601.gappssmtp.com header.i=@kruces-com.20230601.gappssmtp.com header.b="ZtY9swzQ"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a8d13b83511so94365966b.2
        for <kvmarm@lists.linux.dev>; Sat, 07 Sep 2024 02:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kruces-com.20230601.gappssmtp.com; s=20230601; t=1725701296; x=1726306096; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mLjcQZPs76go0Vfx5eTZL9J6PO34NT3+t7m9ovsvig4=;
        b=ZtY9swzQEbhov2+1MsYTMbDz8c11ISME8lIaR2e3Yi0QoKKpKI6f+ih2eBesSrLhtu
         8jC+lP2HNIbOABOYbHve6k8IFQBL3W8Mft5wZmuUJSOIuOMGAjXJhVg0XXX7AG4HPlOH
         tti+xIscogYvVNAJZ6PUYmRmSEoL63WL4QS591g/CLrByswHcSxE1qGp+p6Mdr4OW0oW
         z4l381INc+fZNywElldE0NyIquP6DSwW5O157LZ4FWx7mtFAOkZnrf3ofCFrM2RHOqld
         BlwVDbwKVDIBOHC+0+unv3YG1FYURNfy/rym278SXxReqOm/jPWrU/QmziAHrAuvtLbB
         DAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725701296; x=1726306096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mLjcQZPs76go0Vfx5eTZL9J6PO34NT3+t7m9ovsvig4=;
        b=u0Se2EKsGE+Or6F/V7GR7kLLu2WN8+S/n2RJT8e6uUn3sgSMUVjsUo+WM46YAenKFw
         TIwX614ZwFmvJHT5LggwYkbn1HjvpPG8ZabJ8j4eqn8TNo4Mx+buavndAZZwwR0+vdYe
         csJPMeIAchqoUavWFhJy7MRW8lYDu2KyhzCDJ0GirSfTrSipu3mwY0erHl2vY+Bhj2NX
         CI/nE3VHBlF8IYd3PU3fXHeqKP271DK7NzT2xM/Z+MJuAcUuXnit3PUz54X1T9gLT7E5
         b7Zdw8sr/hUiFC9mMY/RiA+/0yaEA1du7bStUKw+aDziJaMcNmVo8yf0Qc7wn30Fig6G
         s60A==
X-Forwarded-Encrypted: i=1; AJvYcCXHpX+uawMlpVHHVTYtrd9U4MFKKemHyO/TDfIjMcraI4GBPRmIWcMb4hrY3eWeGJWOE8uuYTA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzn1oBgQuxhe1bblkoICnln7kCj/4Ew6HLDsu2toNXyM7ptyxMA
	2FHTctj9P9OtA1dzqwm8N+SchQAbhKffb6mku6zrokOHRYeeEq2baMtPwLCJsWNXpdEq5bhS8QR
	D7wZLOCz3daewrqifknJ+t0NADlRPWurIWjONZQ==
X-Google-Smtp-Source: AGHT+IHhXXnbhoNhhw+Ovt49rejZC3sVAmWR3HQdOoxj8Eoar6lFd6KvmW+TQT/o1AMvFsui8ZDqx+Trbs/ZtjaLt7Y=
X-Received: by 2002:a17:906:730a:b0:a86:721d:3021 with SMTP id
 a640c23a62f3a-a8a885faa78mr441611866b.24.1725701295453; Sat, 07 Sep 2024
 02:28:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com>
 <20240906-macos-build-support-v2-4-06beff418848@samsung.com> <CAK7LNARTnJ10ABuD96U-MaYitnX3AF=GD+N-skH7VBfAmOw9RQ@mail.gmail.com>
In-Reply-To: <CAK7LNARTnJ10ABuD96U-MaYitnX3AF=GD+N-skH7VBfAmOw9RQ@mail.gmail.com>
From: "Daniel Gomez (Samsung)" <d+samsung@kruces.com>
Date: Sat, 7 Sep 2024 11:27:49 +0200
Message-ID: <CABj0suDiPf0ySOwQx=6k+6bTZqRmq1+tjPx7=dxSTO5DVqO4nQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] arm64: nvhe: add bee-headers support
To: Masahiro Yamada <masahiroy@kernel.org>
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

On Fri, Sep 6, 2024 at 4:03=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.or=
g> wrote:
>
> On Fri, Sep 6, 2024 at 8:01=E2=80=AFPM Daniel Gomez via B4 Relay
> <devnull+da.gomez.samsung.com@kernel.org> wrote:
> >
> > From: Daniel Gomez <da.gomez@samsung.com>
> >
> > endian.h header is not provided by default in macOS. Use pkg-config wit=
h
> > the new development package 'bee-headers' [1] to find the path where th=
e
> > headers are installed.
> >
> > [1] Bee Headers Project links:
> > https://github.com/bee-headers/headers
> > https://github.com/bee-headers/homebrew-bee-headers
> >
> > It requires to install bee-headers Homebrew Tap:
> >
> >   brew tap bee-headers/bee-headers
> >   brew install bee-headers/bee-headers/bee-headers
> >
> > Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> > ---
> >  arch/arm64/kernel/pi/Makefile     | 1 +
> >  arch/arm64/kernel/vdso32/Makefile | 1 +
> >  arch/arm64/kvm/hyp/nvhe/Makefile  | 3 ++-
> >  3 files changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Makef=
ile
> > index 4d11a8c29181..259c9a45fba0 100644
> > --- a/arch/arm64/kernel/pi/Makefile
> > +++ b/arch/arm64/kernel/pi/Makefile
> > @@ -20,6 +20,7 @@ KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_SCS), $(KB=
UILD_CFLAGS))
> >  KBUILD_CFLAGS  :=3D $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
> >
> >  hostprogs      :=3D relacheck
> > +HOSTCFLAGS_relacheck.o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-head=
ers 2> /dev/null)
> >
> >  quiet_cmd_piobjcopy =3D $(quiet_cmd_objcopy)
> >        cmd_piobjcopy =3D $(cmd_objcopy) && $(obj)/relacheck $(@) $(<)
> > diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso=
32/Makefile
> > index 25a2cb6317f3..6cb8a04bd829 100644
> > --- a/arch/arm64/kernel/vdso32/Makefile
> > +++ b/arch/arm64/kernel/vdso32/Makefile
> > @@ -107,6 +107,7 @@ VDSO_LDFLAGS +=3D --orphan-handling=3D$(CONFIG_LD_O=
RPHAN_WARN_LEVEL)
> >  # $(hostprogs) with $(obj)
> >  munge :=3D ../../../arm/vdso/vdsomunge
> >  hostprogs :=3D $(munge)
> > +HOSTCFLAGS_$(munge).o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-heade=
rs 2> /dev/null)
> >
> >  c-obj-vdso :=3D note.o
> >  c-obj-vdso-gettimeofday :=3D vgettimeofday.o
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe=
/Makefile
> > index b43426a493df..d20a440b6964 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -15,7 +15,8 @@ ccflags-y +=3D -fno-stack-protector     \
> >              $(DISABLE_STACKLEAK_PLUGIN)
> >
> >  hostprogs :=3D gen-hyprel
> > -HOST_EXTRACFLAGS +=3D -I$(objtree)/include
> > +HOST_EXTRACFLAGS +=3D -I$(objtree)/include \
> > +       $(shell $(HOSTPKG_CONFIG) --cflags bee-headers 2> /dev/null)
> >
> >  lib-objs :=3D clear_page.o copy_page.o memcpy.o memset.o
> >  lib-objs :=3D $(addprefix ../../../lib/, $(lib-objs))
> >
> > --
> > 2.46.0
> >
> >
>
> NACK.
>
> Developers working on Linux distributions have no interest
> in your homebrew setup.
>
> For 99% of users, pkg-config does not do anything good.
> It is a waste of process forks.

I didn't think of this, and I agree with you.

>
>
>
> You need to do it outside.
>
>
>  $ HOSTCFLAGS=3D$(pkg-config --cflags bee-headers) make
>
> or
>
>  $ export HOSTCFLAGS=3D$(pkg-config --cflags bee-headers)
>  $ make

Would a Makefile variable be suitable for this use case to make it
easier in the command-line?

We can detect we are in a non-linux based environment and enable a
Makefile <VAR> (e.g., NOLINUX=3D1) and handle the NOLINUX build case
(with pkg-config/bee-headers) inside the Makefiles for these non-linux
cases.


>
>
>
>
>
> --
> Best Regards
> Masahiro Yamada
