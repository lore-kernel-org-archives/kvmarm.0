Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4211922FE
	for <kvmarm@lists.linux.dev>; Fri,  9 Aug 2024 13:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723211271; cv=none; b=RzaKrX9i/Yw0y6Bw3U31FOHv/8YbFVSWmOJqKbjCtoR3VYCsXEjGzySzRJL7KFM5kizf4EA10L9XXa7CYz1bb0/oCfOjKHZYdKTaQ1wUKG0iRi5DGb4fwtsHjuU25/qE9v1K0t1IKaCsCtMsyqBXC1FnufbAnCToy1ZkYIezyC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723211271; c=relaxed/simple;
	bh=zPBG76iZDhJQn2tTBVBYoO0U+jj9wyZQIHm8xtA5Vzo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vGKyM9vr4WyigBiCdbSin7Jz3M2odkhamBxv9bXTTLd4b3BZdTqRVJz8IA+AR+nB8qNHf9zrZzUMoGnka4uNeviW0InBBirRkHy9Bl/9H2tfwB0O7Rz+saZMJS+zVXlCGCcHH9KcqyeZaWALOJT/tIsm5jcmeSaOFlpdv9Bjfug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kruces.com; spf=pass smtp.mailfrom=kruces.com; dkim=pass (2048-bit key) header.d=kruces-com.20230601.gappssmtp.com header.i=@kruces-com.20230601.gappssmtp.com header.b=plcKtCsL; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kruces.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kruces.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kruces-com.20230601.gappssmtp.com header.i=@kruces-com.20230601.gappssmtp.com header.b="plcKtCsL"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-530ad969360so2307869e87.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Aug 2024 06:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kruces-com.20230601.gappssmtp.com; s=20230601; t=1723211268; x=1723816068; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpHG5jPmqSzzMq80QApgQU2Gxos+KWN9CPGhvKscsRg=;
        b=plcKtCsLbKYRKTtpqQcBNjPWfQ9qO8AJSEdUYxSdYndK8vVkP9/wFNz7hP7Dfw0k7Z
         N5BvLbQcZN0i/F1SrJ6goDkIkTMo6OM3ByYYzf/4GlTQVP+QLG54R1+e3wi5w6ZYyeE/
         H0xxApaPXXQBzHlkR292pEKlGdYHVQX1kHtE+quDmbb5fKIOAeo2dsbv/7xrqLTny06x
         OZkRF5ZCgjMvjYi40WlobyoTZ1ysMnupbGdlh4wJbQMCNj/bTnwN182VQdopO2IzGmta
         /JNv+wHP6V3AgczUfRFYT1kHoZfCa77iIojBSvrI78aNGXanFCcjUQYXcEP8FN1sNqiR
         MGVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723211268; x=1723816068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpHG5jPmqSzzMq80QApgQU2Gxos+KWN9CPGhvKscsRg=;
        b=lhCoYVAR9R3IV8v5WdeAv5rB8htrOuTsafrAitRjtTLu/OVteW32b0l4Aj9CDIeFUO
         rlNxBs1lWjdvhIEzdV37pfr15pQGc/XeiJNZLbDSkBxWm0BaSCcVpEjkfdtbOTRvDGTy
         11P1x45uc6zFienooJ/ZCgU9z+BG8xLKrx/IRQhtjNlUmx3DUrBSK5QORZ6oH8nS20O+
         TOtArmd0faQWbhtA+b6eLzBVMaiXSu6tiBjT7XyUmuTpPRt7l0Xlmu+i0sq5dFkXIEuv
         hfwfg3XwrakzqqM/aWS0Fq78vRmdyyAWVLCex4J1wWtDAFTpFHGTL473eS9mAb6dT2Tl
         qe8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUivrK0ojqFLcei5OhnPiyGnyj9XCCdUKH7yGQir6nWi788w6/kevlV8tp6q8zvoCK6B/1XNUV7d5+abGl9Mgt1+EzYn2Q9
X-Gm-Message-State: AOJu0YzNHlwESFcC4lKmpouw6wcYcP2QPtIKSevAKbvEaMpsjlBZdk8+
	uYxMESz4ZQPQArzF5wBL86tk+A6ml9LKbOWlSyOPfraqxp4CgZoEQmTl0ECJe1nuTPalC+GFdMm
	v8q+Kbr14xz+v2owh8LaIuCFaROpNse8pJ6PrKQ==
X-Google-Smtp-Source: AGHT+IHRvyhFxRd+8gsq4yU0wWg6PpO4Ch68Ej98GVi8jrDPqmad9RYqQx3J3nljLKafMtNu25HNa4FplBYJma626Jg=
X-Received: by 2002:a05:6512:158d:b0:52e:9b68:d2da with SMTP id
 2adb3069b0e04-530ee96c1b3mr1277926e87.9.1723211267644; Fri, 09 Aug 2024
 06:47:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807-macos-build-support-v1-0-4cd1ded85694@samsung.com>
 <20240807-macos-build-support-v1-11-4cd1ded85694@samsung.com> <CAK7LNARafZ=zFMeoDdiMh=ZRU_XiJ08Naf=oAdYpOiUN02HizQ@mail.gmail.com>
In-Reply-To: <CAK7LNARafZ=zFMeoDdiMh=ZRU_XiJ08Naf=oAdYpOiUN02HizQ@mail.gmail.com>
From: "Daniel Gomez (Samsung)" <d+samsung@kruces.com>
Date: Fri, 9 Aug 2024 15:47:21 +0200
Message-ID: <CABj0suDkth5OY2SEaasyMWvFMnQyjqg=YPiyp38BpP0RdC_hNg@mail.gmail.com>
Subject: Re: [PATCH 11/12] tty/vt: conmakehash requires linux/limits.h
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: da.gomez@samsung.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Lucas De Marchi <lucas.demarchi@intel.com>, 
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
	Finn Behrens <me@kloenk.dev>, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 2:15=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.or=
g> wrote:
>
> On Wed, Aug 7, 2024 at 8:10=E2=80=AFAM Daniel Gomez via B4 Relay
> <devnull+da.gomez.samsung.com@kernel.org> wrote:
> >
> > From: Daniel Gomez <da.gomez@samsung.com>
> >
> > macOS hosts do not provide the linux/limits.h header required for
> > conmakehash. To address this, ensure that usr/include is included in
> > the conmakehash HOSTCFLAGS. This will provide the necessary header for
> > successful compilation on macOS.
> >
> > Fixes error:
> > HOSTCC  drivers/tty/vt/conmakehash - due to target missing
> >   clang -Wp,-MMD,drivers/tty/vt/.conmakehash.d -Wall
> > -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
> > -std=3Dgnu11   -I ./scripts/include     -o drivers/tty/vt/conmakehash
> > drivers/tty/vt/conmakehash.c
> > drivers/tty/vt/conmakehash.c:15:10: fatal error: 'linux/
> >    limits.h' file not found 15 | #include <linux/limits.h>    |
> >    ^~~~~~~~~~~~~~~~
>
>
> The error is reported at line 15 of drivers/tty/vt/conmakehash.c
>
>
> The line 15 is #include <stdlib.h>:
>
> https://github.com/torvalds/linux/blob/v6.11-rc1/drivers/tty/vt/conmakeha=
sh.c#L15

The patches were sent using the latest linux-next at the moment of
sending, so next-20240806.
B4 adds the baseline [1] used at the bottom.

[1] base-commit: 1e391b34f6aa043c7afa40a2103163a0ef06d179

So line 15 is linux/limits.h header in this case:
https://github.com/torvalds/linux/blob/1e391b34f6aa043c7afa40a2103163a0ef06=
d179/drivers/tty/vt/conmakehash.c#L15
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/tty/vt/conmakehash.c?h=3D1e391b34f6aa043c7afa40a2103163a0ef06d179#n15

This patch adds the header:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/=
drivers/tty/vt/conmakehash.c?h=3Dnext-20240809&id=3D6e20753da6bc651e02378a0=
cdb78f16c42098c88

>
>
> So, host programs cannot include <stdlib.h> on your build machine.
>
>
>
> drivers/tty/vt/conmakehash.c has only 5 include directives:
>
> #include <stdio.h>
> #include <stdlib.h>
> #include <sysexits.h>
> #include <string.h>
> #include <ctype.h>
>
>
> You cannot build this, your build machine cannot build anything.
>
>
>
>
>
>
>
>
>
> > 1 error generated.
> > make[5]: *** [scripts/Makefile.host:116: drivers/tty/vt/conmakehash]
> > Error 1
> > make[4]: *** [scripts/Makefile.build:485: drivers/tty/vt] Error 2
> > make[3]: *** [scripts/Makefile.build:485: drivers/tty] Error 2
> > make[2]: *** [scripts/Makefile.build:485: drivers] Error 2
> > make[1]: *** [/Volumes/src/kernel/linux-next/Makefile:1925: .] Error 2
> > make: *** [Makefile:224: __sub-make] Error 2
> >
> > Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> > ---
> >  drivers/tty/vt/Makefile | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/tty/vt/Makefile b/drivers/tty/vt/Makefile
> > index 2c8ce8b592ed..d266895357e5 100644
> > --- a/drivers/tty/vt/Makefile
> > +++ b/drivers/tty/vt/Makefile
> > @@ -13,6 +13,7 @@ obj-$(CONFIG_CONSOLE_TRANSLATIONS)    +=3D consolemap=
.o consolemap_deftbl.o
> >  clean-files :=3D consolemap_deftbl.c defkeymap.c
> >
> >  hostprogs +=3D conmakehash
> > +HOSTCFLAGS_conmakehash.o =3D -I$(srctree)/usr/include
> >
> >  quiet_cmd_conmk =3D CONMK   $@
> >        cmd_conmk =3D $(obj)/conmakehash $< > $@
> >
> > --
> > Git-146)
> >
> >
>
>
> --
> Best Regards
> Masahiro Yamada
