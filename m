Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65EF1CF5C4;
	Fri,  6 Sep 2024 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725631380; cv=none; b=ioo9vOuQOeA02TJIZlkRAybA5W8qxnNju0QwYOLBlx1ErzpMWW5j9skbf2DEubG2M2kVStw4xTgeRjFJb4YKQ8GEBCS5z12SMfyIC8S9ltx90H6cI65X+Zemi31aAanWZnSyFR2BHjc6rnsKXKvkFt/32+o3Kw3chXZ5Ds6uaV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725631380; c=relaxed/simple;
	bh=OO0AElYeEOI3GYdUWGdnaZhtFPRBNB1P+5L7lTeyPbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c8kHObeHvRJwYlW/zcZOo8hSdYE5ziiCfAJHcK/OwTEFSaJlBtNLpjP/Z5VzojSVD2PrdXFGtBETCfHV6n0Wa1mOgUPs00kIAbwFqhkp7tJa5F6owdY46EsuaoDf14M+JH03DSikNHVRpQs0EX8o5YgrjYdZXYC7Cd+sVzfJReY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sz4aCJLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sz4aCJLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FBAC4CEC5;
	Fri,  6 Sep 2024 14:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725631380;
	bh=OO0AElYeEOI3GYdUWGdnaZhtFPRBNB1P+5L7lTeyPbM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Sz4aCJLwKJW66WNHMDkSza870NQ+KuHtMUB6RKXaaLIyT1PzUcCXiU4mzUpny79nU
	 9RplbKUfrE1rlSxsF91T3RDlDEHJHNzGEpu+bq8dJHmOg/KE1E7688DmmhB6r/d36v
	 Po+T5dBXJSOte9a79XlrkMOnEIOkGVa/4SzIpjKS8DJP1jPgBpD5vxmRcWOET8glIH
	 umA7qiJHYVFd9YlqX/PGB7Tc0duXENcecSQ7L5Iq1npTo1hNfbj8DQ/b3R1/wOu8/1
	 oGn7Eql155UsBU542uxU8a6MmTKRggu3qO8gtRyI4zdZGy/jXPqRpD8LyQ/XuTWiD+
	 iFqto7iQINTvA==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2f406034874so24461231fa.1;
        Fri, 06 Sep 2024 07:03:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU3QPm7WCDNzzqN4NxyCyW4EAZa9Z13Ely/zX9tKadTzkIacH+bVUpSRBMOEVNBExyB8ef9NLM=@lists.linux.dev, AJvYcCVggX7OuXuc6YMEjXmb/67tk0nLkQYXNbnwC59gvHLxePrCkJqka+rbTt7/vrQPYuSe/sdX+Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwxegjY1aFVyFQ7C205lAjx08QgUhqTDKubwh782PEyndEYnjGR
	q/Brv4i3RCpdt7NZj5Ciu6XqPEQ5UMp/g3IRm4Hcp7UTJka+p8MOhMYCnGWqNTmqlB9K/Yg5zY0
	bP4BBQyRIACMn/1ry+X2GRxxgL+s=
X-Google-Smtp-Source: AGHT+IHDPemzgtRgtIK3pe/WquzDZM64UIne/QjVdYwQNSINL5RkN2+H+MExlIZPV5kHOwbjtPDmzO7x05c0KOYPFxo=
X-Received: by 2002:a2e:868d:0:b0:2f7:4df2:6a13 with SMTP id
 38308e7fff4ca-2f751f33229mr16214701fa.25.1725631378202; Fri, 06 Sep 2024
 07:02:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com> <20240906-macos-build-support-v2-4-06beff418848@samsung.com>
In-Reply-To: <20240906-macos-build-support-v2-4-06beff418848@samsung.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Fri, 6 Sep 2024 23:02:21 +0900
X-Gmail-Original-Message-ID: <CAK7LNARTnJ10ABuD96U-MaYitnX3AF=GD+N-skH7VBfAmOw9RQ@mail.gmail.com>
Message-ID: <CAK7LNARTnJ10ABuD96U-MaYitnX3AF=GD+N-skH7VBfAmOw9RQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] arm64: nvhe: add bee-headers support
To: da.gomez@samsung.com
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, 
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
	Finn Behrens <me@kloenk.dev>, "Daniel Gomez (Samsung)" <d+samsung@kruces.com>, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 6, 2024 at 8:01=E2=80=AFPM Daniel Gomez via B4 Relay
<devnull+da.gomez.samsung.com@kernel.org> wrote:
>
> From: Daniel Gomez <da.gomez@samsung.com>
>
> endian.h header is not provided by default in macOS. Use pkg-config with
> the new development package 'bee-headers' [1] to find the path where the
> headers are installed.
>
> [1] Bee Headers Project links:
> https://github.com/bee-headers/headers
> https://github.com/bee-headers/homebrew-bee-headers
>
> It requires to install bee-headers Homebrew Tap:
>
>   brew tap bee-headers/bee-headers
>   brew install bee-headers/bee-headers/bee-headers
>
> Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> ---
>  arch/arm64/kernel/pi/Makefile     | 1 +
>  arch/arm64/kernel/vdso32/Makefile | 1 +
>  arch/arm64/kvm/hyp/nvhe/Makefile  | 3 ++-
>  3 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Makefil=
e
> index 4d11a8c29181..259c9a45fba0 100644
> --- a/arch/arm64/kernel/pi/Makefile
> +++ b/arch/arm64/kernel/pi/Makefile
> @@ -20,6 +20,7 @@ KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_SCS), $(KBUI=
LD_CFLAGS))
>  KBUILD_CFLAGS  :=3D $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
>
>  hostprogs      :=3D relacheck
> +HOSTCFLAGS_relacheck.o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-header=
s 2> /dev/null)
>
>  quiet_cmd_piobjcopy =3D $(quiet_cmd_objcopy)
>        cmd_piobjcopy =3D $(cmd_objcopy) && $(obj)/relacheck $(@) $(<)
> diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32=
/Makefile
> index 25a2cb6317f3..6cb8a04bd829 100644
> --- a/arch/arm64/kernel/vdso32/Makefile
> +++ b/arch/arm64/kernel/vdso32/Makefile
> @@ -107,6 +107,7 @@ VDSO_LDFLAGS +=3D --orphan-handling=3D$(CONFIG_LD_ORP=
HAN_WARN_LEVEL)
>  # $(hostprogs) with $(obj)
>  munge :=3D ../../../arm/vdso/vdsomunge
>  hostprogs :=3D $(munge)
> +HOSTCFLAGS_$(munge).o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-headers=
 2> /dev/null)
>
>  c-obj-vdso :=3D note.o
>  c-obj-vdso-gettimeofday :=3D vgettimeofday.o
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/M=
akefile
> index b43426a493df..d20a440b6964 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -15,7 +15,8 @@ ccflags-y +=3D -fno-stack-protector     \
>              $(DISABLE_STACKLEAK_PLUGIN)
>
>  hostprogs :=3D gen-hyprel
> -HOST_EXTRACFLAGS +=3D -I$(objtree)/include
> +HOST_EXTRACFLAGS +=3D -I$(objtree)/include \
> +       $(shell $(HOSTPKG_CONFIG) --cflags bee-headers 2> /dev/null)
>
>  lib-objs :=3D clear_page.o copy_page.o memcpy.o memset.o
>  lib-objs :=3D $(addprefix ../../../lib/, $(lib-objs))
>
> --
> 2.46.0
>
>

NACK.

Developers working on Linux distributions have no interest
in your homebrew setup.

For 99% of users, pkg-config does not do anything good.
It is a waste of process forks.



You need to do it outside.


 $ HOSTCFLAGS=3D$(pkg-config --cflags bee-headers) make

or

 $ export HOSTCFLAGS=3D$(pkg-config --cflags bee-headers)
 $ make





--=20
Best Regards
Masahiro Yamada
