Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033241537D8
	for <kvmarm@lists.linux.dev>; Sat,  7 Sep 2024 09:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725701571; cv=none; b=u7YM6xY8+DA4Wpaskaz1/JwoC6NHfx6eeI/ApjPosIRWvGUBzDh6b3EIZsbuaJSIGu7SqXcJVms1lmcn1DF5riiKLswqLGNCNIL2igv0fDI450m2aXS8f1LzyxbNZ7ha5qx9yd9GIgo5Bcyb4B4CPZTnWhmkCMs1UpQMvH6pgEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725701571; c=relaxed/simple;
	bh=pLRCLThgiNm0DnTCnzf1SU7HK+Xdrn0HCAQw1/fv6eE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=paTYpZ5pVU4ZpcPPY81YO9rRvYHLLkrQUQ+xt4h8pg8D2Zx5lBRoDkGVJW2cCsQRqAOXzlCKvCoXmWuQ43+gF4WPbfhEdg9Z0RsY2p3A0lXy19rd8cRcD9UunF4yg6+t1oOBOfITj5hEkev6oMgmtf9GKUdMKXT8y4dbIpnXwH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kruces.com; spf=pass smtp.mailfrom=kruces.com; dkim=pass (2048-bit key) header.d=kruces-com.20230601.gappssmtp.com header.i=@kruces-com.20230601.gappssmtp.com header.b=W167v78T; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kruces.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kruces.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kruces-com.20230601.gappssmtp.com header.i=@kruces-com.20230601.gappssmtp.com header.b="W167v78T"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a86a37208b2so394774766b.0
        for <kvmarm@lists.linux.dev>; Sat, 07 Sep 2024 02:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kruces-com.20230601.gappssmtp.com; s=20230601; t=1725701567; x=1726306367; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TYAYDwYU9XEQd7B0n4GlUaSi+kByWiSIqgApWZK2k7Y=;
        b=W167v78TzEDNd9PPqwingbRuLqqFXwWxbtiwOdS7OOcKkXOQiATvCfRGx9jtZrupbo
         xhU5JGCga0MysvsxNO+9zZKspcRj2BXrmD6w+FhCzrT27paqW1SdpsAyEaNrdLG02yhR
         trQaDSwm1yinBldj0CUlnUmDItLAUhHhAxi+5pFhydyEgb/rUDATahkbbQ7At2wVTlDt
         1yYA7540gE6SFYq4yIWsG1dWs1VsKdHrF/PfhBrJGmqNaRxXZzuvUwzX5L2y3vwrVvyu
         gfKQpYLwwv7jC1yu5vDw/6JScBRkTIASzi1w8ZVM7ZRtYrTkSEdSxKYzdx3T3vggKZFT
         KLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725701567; x=1726306367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TYAYDwYU9XEQd7B0n4GlUaSi+kByWiSIqgApWZK2k7Y=;
        b=HBzvRII98wsFsbFY4LnS/hAANJqYvtIBBPJtr8VtvnhU9+5JpQoX6bm6Mb7oa6r45l
         SGfdHJotulaSoGcI5YleLIjeLaDDPX88eUQk+YpLTksed8NkZt4Nn2iSJ/p59X8MJftN
         hw6DQBfDtydIud4GlGylpTn2IkyzEH5PYrDRqTBRGBa1xs5GOt9rL+ZLKh69/FgkwD6H
         6sCfa4ov7ZJvR08fIyNFm+lw435ycDZQc5JtcR+F5HZ5Bm0U5CJgmaQbs5+0JJ1GcuA1
         ET1n80aGIGZ7ESoh8KnCoYdLhnBzIdUy4GhonlJXQ9FM9QF//jq/g4DdvuaoEteotOZe
         jSkA==
X-Forwarded-Encrypted: i=1; AJvYcCXuzr2St5m4PnhG+YS49xiLcBHM4WF26MotWiTrXQtIaK4Ej2geDWgdqjFfjTxjtKYOdnUNRBc=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywob8AQ/i0vRrdeiwsTBAMBeaD0dw322iBSEHQOhIsBJLl5BCaL
	S6Sc9o9A/7RLF8LnM5Q9uP8siB6zz2RaaM5ADQDDC2Apchsh8QZQz50DX8yDmJGS/v971a7ss9w
	lABdrBI0L7NDtqEH5MMlRbrLpqpjbb48e7bb4jg==
X-Google-Smtp-Source: AGHT+IGWwhV1FppouK54v3V9A8eHwS6rbK0nonXkKqq2rXZ9hT6w4qHPiZkVwNteqV+2HfQ53hj21jvfFLgYyvqTkhg=
X-Received: by 2002:a17:906:6a15:b0:a7a:9144:e23a with SMTP id
 a640c23a62f3a-a8d248a6d5fmr79801166b.43.1725701567219; Sat, 07 Sep 2024
 02:32:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com>
 <20240906-macos-build-support-v2-8-06beff418848@samsung.com> <CAK7LNASpWSXbjF_7n0MhosNism=BpvHOnKsa344RPM_wmC9dGA@mail.gmail.com>
In-Reply-To: <CAK7LNASpWSXbjF_7n0MhosNism=BpvHOnKsa344RPM_wmC9dGA@mail.gmail.com>
From: "Daniel Gomez (Samsung)" <d+samsung@kruces.com>
Date: Sat, 7 Sep 2024 11:32:20 +0200
Message-ID: <CABj0suBQCc8=0tLng=OWW=K1hjFuLFZWhbjsqHtz2FzZt4i0sw@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] Documentation: add howto build in macos
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

On Sat, Sep 7, 2024 at 10:33=E2=80=AFAM Masahiro Yamada <masahiroy@kernel.o=
rg> wrote:
>
> On Fri, Sep 6, 2024 at 8:01=E2=80=AFPM Daniel Gomez via B4 Relay
> <devnull+da.gomez.samsung.com@kernel.org> wrote:
> >
> > From: Daniel Gomez <da.gomez@samsung.com>
> >
> > Add documentation under kbuild/llvm to inform about the experimental
> > support for building the Linux kernel in macOS hosts environments.
> >
> > Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
>
>
> Instead, you can add this instruction to:
>
> https://github.com/bee-headers/homebrew-bee-headers/blob/main/README.md

Sure, that can be done as well. But the effort here is to have this
integrated. So, I think documentation should be in-tree.

>
>
>
>
>
> > ---
> >  Documentation/kbuild/llvm.rst | 78 +++++++++++++++++++++++++++++++++++=
++++++++
> >  1 file changed, 78 insertions(+)
> >
> > diff --git a/Documentation/kbuild/llvm.rst b/Documentation/kbuild/llvm.=
rst
> > index 6dc66b4f31a7..de3bde925793 100644
> > --- a/Documentation/kbuild/llvm.rst
> > +++ b/Documentation/kbuild/llvm.rst
> > @@ -186,6 +186,84 @@ yet. Bug reports are always welcome at the issue t=
racker below!
> >       - Supported
> >       - ``LLVM=3D1``
> >
> > +Experimental Build in macOS
> > +---------------------------
> > +
> > +Building on macOS with LLVM is experimental. This section provides ste=
ps to
> > +install dependencies via Homebrew, set up the environment, and start t=
he build
> > +process.
> > +
> > +1. **Create a Case-Sensitive Volume**
> > +
> > +   For fetching and building the project, you need a case-sensitive vo=
lume. Use the following
> > +   command to create one:
> > +
> > +   .. code-block:: shell
> > +
> > +      diskutil apfs addVolume /dev/disk<N> "Case-sensitive APFS" linux
> > +
> > +   Replace `/dev/disk<N>` with the appropriate disk identifier.
> > +
> > +2. **Install Build Dependencies**
> > +
> > +Use Homebrew to install the required build dependencies.
> > +
> > +- **Core Utilities**: `coreutils`, `findutils`, `gnu-sed`, `gnu-tar`, =
`grep`,
> > +  `llvm`, `make`, and `pkg-config`.
> > +
> > +   .. code-block:: shell
> > +
> > +      brew install coreutils findutils gnu-sed gnu-tar grep llvm make =
pkg-config
> > +
> > +- **Bee Headers**: Install byteswap, elf and endian headers using the
> > +  `Bee Headers Project <https://github.com/bee-headers/headers>`_.
> > +
> > +   .. code-block:: shell
> > +
> > +      brew tap bee-headers/bee-headers
> > +      brew install bee-headers/bee-headers/bee-headers
> > +
> > +   After installation, verify the `CFLAGS` with `pkg-config`:
> > +
> > +   .. code-block:: shell
> > +
> > +      pkg-config --cflags bee-headers
> > +      -I/opt/homebrew/Cellar/bee-headers/0.1/include
> > +
> > +3. **Configure the PATH**
> > +
> > +   Include all the required GNU tools and LLVM in your `PATH`. This en=
sures that
> > +   the necessary tools are available during the build process.
> > +
> > +   .. code-block:: shell
> > +
> > +      PATH=3D"/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
> > +      PATH=3D"/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
> > +      PATH=3D"/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
> > +      PATH=3D"/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
> > +      PATH=3D"/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
> > +      PATH=3D"/opt/homebrew/opt/make/libexec/gnubin:$PATH"
> > +      PATH=3D"/opt/homebrew/opt/llvm/bin:$PATH"
> > +
> > +Building the Project
> > +--------------------
> > +
> > +Once the environment is set up, you can start the build process using =
LLVM. Run
> > +the following commands to initiate the build:
> > +
> > +.. code-block:: shell
> > +
> > +   make LLVM=3D1 allyesconfig
> > +   make LLVM=3D1 -j$(nproc)
> > +
> > +Supported in macOS
> > +~~~~~~~~~~~~~~~~~~
> > +
> > +At the moment, only arm64 is supported and tested with `allyesconfig` =
Makefile
> > +configuration target. Other Kconfig options not included in `allyescon=
fig`
> > +target and architectures may be supported as well as support in macOS =
is based
> > +on LLVM effort and maintenance.
> > +
> >  Getting Help
> >  ------------
> >
> >
> > --
> > 2.46.0
> >
> >
>
>
> --
> Best Regards
> Masahiro Yamada
