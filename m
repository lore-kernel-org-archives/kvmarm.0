Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C86C1CEADD;
	Fri,  6 Sep 2024 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725631400; cv=none; b=lipExuMDc8F+9uWwRie6TbU1zgfHqw5FbNq5nrSKAUU6//EvgMd0yM5AIAfRWyyjoSVovy5umS6sEgiYTWNN+Z9xlJbsXEqSHU1pSFcdkiGUU5aBlAKPFGcG9AxFEHFAt2FqtynRU+Ogc688XSJKsuCOHQ4quJrC/xrUbQFb9KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725631400; c=relaxed/simple;
	bh=cCvVFVarD948ikan+/2TaJVbsKjZAcxCYUNJAassXuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OWd1PtOIHBGAnVjXZkqX/yTHbq4qk6YMIQDLl2d9dIxgejiMunr7oa2CFdF6KSNmHDZUZUyGRD8lp0ckbNNVBEhFgWDOxxqbvatNO85mncgwdAiJQob/NI7nUAdFeBEpYYQCjmGN3icHdX4A127mQYwWR9YhPDnsuLW0idaaa+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dyMY9vi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dyMY9vi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A084C4AF09;
	Fri,  6 Sep 2024 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725631400;
	bh=cCvVFVarD948ikan+/2TaJVbsKjZAcxCYUNJAassXuo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dyMY9vi+Iv/1EE4rQ5BwnYhfwk66+LJ4z96MdbykYSppKKoQ6y3a0sNfUu/b88uyD
	 CnMZ+ONw74z6CdB7oB6DTdO6H33Yg0CqFxIeKoXjlAeH7r+IeYZBwiBhKopg0VRDv1
	 gzpGPqLViAnfIcvPs8ONYWfyESePiuh7ufuvViitOGQLxvTFW462hGXk6bbFU2yUaH
	 L9ypC5UisZq5so1J2EZ4Zsx2oDa8QzGHtDF2R5KDWuQbRupAZrdUcRbDK0gOWrBwUd
	 QfmUhasthbSt1k+8xvJ7JF5Ifym3SEZdnZdQXjE4OvCP9je+KurLddBgNN2nspGq59
	 NazYJG1NuiiDw==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5343e75c642so2437680e87.2;
        Fri, 06 Sep 2024 07:03:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXip1DM9FZxx9LPc0c65hTcU7o9xmBNqYLa4V2c+NmcFWrPXPK/NRDa+GpIAuPZMNJXbC50ew==@lists.linux.dev, AJvYcCXp9pASBb1LUn6AYEIycYzSDtC8bU9N0yHg/SHE/QKCE4ArXcTNn4ojxSTmoNqERpdaYg3S2YA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpX+xQ1/3jAcUoqoxQm9f5sMDcyqLpLFUe+o50JYu06hR+d7ty
	rpjiHbwnlrJYmg1PSdSTgCpz/a7jDDvImiFee4WR1mdvIrdNz1fB9TRIRSscrLWXKlUCVWn3RbK
	hblRJHqhiiWDyyzriQFiABKZWljA=
X-Google-Smtp-Source: AGHT+IEwm1OihzyduuH3GdpU3yiLq9gm3KuXayVrsg5BxQSVxVXk/rmKiVyZVYISmyKuN7IvBRI5rMb23e03P34iqD4=
X-Received: by 2002:a05:6512:39ce:b0:536:54df:bff2 with SMTP id
 2adb3069b0e04-53658812f84mr1830079e87.54.1725631398698; Fri, 06 Sep 2024
 07:03:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com> <20240906-macos-build-support-v2-5-06beff418848@samsung.com>
In-Reply-To: <20240906-macos-build-support-v2-5-06beff418848@samsung.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Fri, 6 Sep 2024 23:02:42 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQGuXzuA5tNSv0q_AMAy8Zw5MtG2RFRW0nQOwCO8Z5FLw@mail.gmail.com>
Message-ID: <CAK7LNAQGuXzuA5tNSv0q_AMAy8Zw5MtG2RFRW0nQOwCO8Z5FLw@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] scripts: add bee-headers support
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
>   brew tap bee-headers/bee-headers
>   brew install bee-headers/bee-headers/bee-headers
>
> Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> ---
>  scripts/Makefile     | 4 +++-
>  scripts/mod/Makefile | 5 +++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/Makefile b/scripts/Makefile
> index 6bcda4b9d054..40f6a9159f8c 100644
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -25,8 +25,10 @@ generate_rust_target-rust :=3D y
>  rustdoc_test_builder-rust :=3D y
>  rustdoc_test_gen-rust :=3D y
>
> -HOSTCFLAGS_sorttable.o =3D -I$(srctree)/tools/include
> +HOSTCFLAGS_sorttable.o =3D -I$(srctree)/tools/include \
> +       $(shell $(HOSTPKG_CONFIG) --cflags bee-headers 2> /dev/null)
>  HOSTLDLIBS_sorttable =3D -lpthread
> +HOSTCFLAGS_insert-sys-cert.o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-=
headers 2> /dev/null)
>  HOSTCFLAGS_asn1_compiler.o =3D -I$(srctree)/include
>  HOSTCFLAGS_sign-file.o =3D $(shell $(HOSTPKG_CONFIG) --cflags libcrypto =
2> /dev/null)
>  HOSTLDLIBS_sign-file =3D $(shell $(HOSTPKG_CONFIG) --libs libcrypto 2> /=
dev/null || echo -lcrypto)
> diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
> index 75c12c045f21..33bb032039ba 100644
> --- a/scripts/mod/Makefile
> +++ b/scripts/mod/Makefile
> @@ -9,6 +9,11 @@ modpost-objs   :=3D modpost.o file2alias.o sumversion.o =
symsearch.o
>  devicetable-offsets-file :=3D devicetable-offsets.h
>
>  HOSTCFLAGS_file2alias.o +=3D -D_UUID_T -D__GETHOSTUUID_H
> +HOSTCFLAGS_modpost.o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-headers =
2> /dev/null)
> +HOSTCFLAGS_file2alias.o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-heade=
rs 2> /dev/null)
> +HOSTCFLAGS_sumversion.o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-heade=
rs 2> /dev/null)
> +HOSTCFLAGS_symsearch.o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-header=
s 2> /dev/null)
> +HOSTCFLAGS_mk_elfconfig.o =3D $(shell $(HOSTPKG_CONFIG) --cflags bee-hea=
ders 2> /dev/null)
>
>  $(obj)/$(devicetable-offsets-file): $(obj)/devicetable-offsets.s FORCE
>         $(call filechk,offsets,__DEVICETABLE_OFFSETS_H__)



Same as 4/8.

NACK.




--
Best Regards

Masahiro Yamada
