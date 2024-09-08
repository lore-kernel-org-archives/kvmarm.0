Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA860176AAF
	for <kvmarm@lists.linux.dev>; Sun,  8 Sep 2024 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725817266; cv=none; b=s/7p7jJYYU0phiOpcib6zq+d/nUROnR5ZKti/sTYPyYMD37gpagPyL+A8BteowG/iAtSbunHPQwXQTqQwAFUiKUCeIXCnU7dOPb/THvsOaQ6hqxYagWKBmsLYsNtlEBwtsKtkUoLCqIYoVbeAYUcAy0qjVF0HX2h018jRL/O3J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725817266; c=relaxed/simple;
	bh=4x2mtOQlRb0PLQYsIdFIS4OpJJNhyfJXhcP1AXkKZFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m81SQ5ukfeeVL5u5T0u/n3p7bbsc4Cehfu4xPQWBa0fUYbTNEevHk78sTz8bS+TGvNTlcKD0pqmgOVZrvfPUeabqgQtvNGsQiZo9fGw+AbS7dE7z2/FM+NM10dPV227jOWb8kc4Sxz3WCxf8cIOxhXSy3GUtm3r/H7mWgyZrPtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kruces.com; spf=pass smtp.mailfrom=kruces.com; dkim=pass (2048-bit key) header.d=kruces-com.20230601.gappssmtp.com header.i=@kruces-com.20230601.gappssmtp.com header.b=NHpiTt00; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kruces.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kruces.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kruces-com.20230601.gappssmtp.com header.i=@kruces-com.20230601.gappssmtp.com header.b="NHpiTt00"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a8d56155f51so18585166b.2
        for <kvmarm@lists.linux.dev>; Sun, 08 Sep 2024 10:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kruces-com.20230601.gappssmtp.com; s=20230601; t=1725817262; x=1726422062; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fviFcg3HLptplXdgVPwFETuKylRy16bbpArI+x9x9sA=;
        b=NHpiTt00RoDzsDS3uY+WSfaaIIZ8GzW6miyemOJeNyisGWJaRU6ZqWwlW7SV4YY2of
         KeOslhYlrwn8AcEVXeF2o7Bd6zeUPIcpcEAKGohKkkt8vnIs/9cUgtfX6s8wm1ks3g80
         sApK8P2SaUWIBkufcyVpyn6SNi8WkWCWDM4ySmqxaDXAETHmxKKnLKOTnW1HSvhdcxw1
         u4zjykU5NPcj1jufwn5HwxYsq+I2oX9KBaaYuE9shDRBrU5s7UT9H5x0QErAEEKMANM7
         zj8E4YmJ0W7AIGLrQl181bggUX8pq88H0NgFH4jGhm7e9D5IQI3DIRuJOspo88aH33Lp
         fCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725817262; x=1726422062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fviFcg3HLptplXdgVPwFETuKylRy16bbpArI+x9x9sA=;
        b=fw2ZkgLGWJ6G+AmD/UAvIr6/CbRQOHkTPlayrmezOaUt8er0+f/sRxtfZceW3eeeNV
         HkvtZOL/ptxLuvmUfSU7r86QfVLdC1vBC1+8gPeISZ+uuhhCQTXiqxfvN+h2IeY5skPD
         U8HCy3k3vGLY9DLiCqwogweInB4RZqfPYI65QP9p9tkUBcSeV+TP46MKi5xxJvvytoKe
         ZdMBEjN3xBmpnEKYOu+7Bkq8fJW68kbCvsblqp4Er+97rCJwFR8v/cVxhvW2Dj91hwyT
         CvptU8/AiFLQNem0t4DMQXcXF707Ho33SHO3V0ZD7fG/9OO0g8AeFDX5sfGsjlQpWVH4
         10HA==
X-Forwarded-Encrypted: i=1; AJvYcCWVf+WPfNcIQZaLqQZMsy+gI8aA5NklXtKeoU824WOLTD7emWHOMT8TwEnVZ2zzr0F0xwZJD1A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTifhar7gsb87jpnvrw5PxT3OFVI0Z1LdPqZLUfmVsou2nwBqh
	otcti6yDZYR0Jjr350IaI/EitrvflYdWcQ9t8bW442XXBCOK/CpwmS3oxbPmXy3hBLzasfgBhvM
	vTU2kVGVLlCxoQ6A8l5i2Msf2NIpLKjHREqj45g==
X-Google-Smtp-Source: AGHT+IG0taDaRweGpDhiFssf20qgh8akE04jwmSCvgTsBJig1BN0pA1T1q/8W0tMp8E8Ed3WvXCdk5VBeHS2T6PZWVU=
X-Received: by 2002:a17:907:9690:b0:a8d:2faf:d343 with SMTP id
 a640c23a62f3a-a8d2fafee8fmr226989166b.27.1725817261797; Sun, 08 Sep 2024
 10:41:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com>
 <20240906-macos-build-support-v2-2-06beff418848@samsung.com> <CAK7LNARw-7uwJB7ibmSYE5nYUtPXcr4J9cHBQqm9BnNS=SRUhQ@mail.gmail.com>
In-Reply-To: <CAK7LNARw-7uwJB7ibmSYE5nYUtPXcr4J9cHBQqm9BnNS=SRUhQ@mail.gmail.com>
From: "Daniel Gomez (Samsung)" <d+samsung@kruces.com>
Date: Sun, 8 Sep 2024 19:40:34 +0200
Message-ID: <CABj0suCHeWGDXX-S6U9X5iCzwMqn9pq=i84PSKwKtUXhGxaBjQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] file2alias: fix uuid_t definitions for macos
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

On Sun, Sep 8, 2024 at 1:56=E2=80=AFAM Masahiro Yamada <masahiroy@kernel.or=
g> wrote:
>
> On Fri, Sep 6, 2024 at 8:01=E2=80=AFPM Daniel Gomez via B4 Relay
> <devnull+da.gomez.samsung.com@kernel.org> wrote:
> >
> > From: Daniel Gomez <da.gomez@samsung.com>
> >
> > The uuid_t struct defined in sys/types.h on macOS hosts conflicts with
> > the one defined in file2alias, resulting in the typedef redefinition
> > error below. To resolve this conflict, define the _UUID_T and
> > __GETHOSTUUID_ in file2alias HOSTCFLAGS.
> >
> > Error:
> >   HOSTCC  scripts/mod/file2alias.o scripts/mod/file2alias.c:45:3:
> > error: typedef redefinition with different types ('struct uuid_t' vs
> > '__darwin_uuid_t' (aka 'unsigned char[16]'))    45 | } uuid_t;       |
> > ^
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    sys/_types/_uuid_t.h:31:25: note: previous definition is here 31 |
> >    typedef __darwin_uuid_t uuid_t;    |                         ^
> > scripts/mod/file2alias.c:1354:7: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1354 |
> >  uuid->b[0], uuid->b[1], uuid->b[2], uuid->b[3], uuid->b[4],      |
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1354:19: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1354 |
> >  uuid->b[0], uuid->b[1], uuid->b[2], uuid->b[3], uuid->b[4],      |
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1354:31: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1354 |
> >  uuid->b[0], uuid->b[1], uuid->b[2], uuid->b[3], uuid->b[4],      |
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1354:43: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1354 |
> >  uuid->b[0], uuid->b[1], uuid->b[2], uuid->b[3], uuid->b[4],      |
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1354:55: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1354 |
> >  uuid->b[0], uuid->b[1], uuid->b[2], uuid->b[3], uuid->b[4],      |
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1355:7: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1355 |
> >  uuid->b[5], uuid->b[6], uuid->b[7], uuid->b[8], uuid->b[9],      |
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1355:19: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1355 |
> >  uuid->b[5], uuid->b[6], uuid->b[7], uuid->b[8], uuid->b[9],      |
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1355:31: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1355 |
> >  uuid->b[5], uuid->b[6], uuid->b[7], uuid->b[8], uuid->b[9],      |
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1355:43: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1355 |
> >  uuid->b[5], uuid->b[6], uuid->b[7], uuid->b[8], uuid->b[9],      |
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1355:55: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1355 |
> >  uuid->b[5], uuid->b[6], uuid->b[7], uuid->b[8], uuid->b[9],      |
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1356:7: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1356 |
> >  uuid->b[10], uuid->b[11], uuid->b[12], uuid->b[13], uuid->b[14],      =
|
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1356:20: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1356 |
> >  uuid->b[10], uuid->b[11], uuid->b[12], uuid->b[13], uuid->b[14],      =
|
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1356:33: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1356 |
> >  uuid->b[10], uuid->b[11], uuid->b[12], uuid->b[13], uuid->b[14],      =
|
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1356:46: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1356 |
> >  uuid->b[10], uuid->b[11], uuid->b[12], uuid->b[13], uuid->b[14],      =
|
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1356:59: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1356 |
> >  uuid->b[10], uuid->b[11], uuid->b[12], uuid->b[13], uuid->b[14],      =
|
> >  ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > scripts/mod/file2alias.c:1357:7: error: member reference base
> >  type 'typeof (((struct tee_client_device_id *)0)->uuid)' (aka
> >  'unsigned char[16]') is not a structure or union 1357 |
> >  uuid->b[15]);      |                 ~~~~^ ~
> > /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/include/
> >    secure/_stdio.h:47:56: note: expanded from macro 'sprintf' 47 |
> >    __builtin___sprintf_chk (str, 0, __darwin_obsz(str), __VA_ARGS__)
> >    |                                                        ^~~~~~~~~~~
> > 17 errors generated.
> >
> > Suggested-by: Nicolas Schier <nicolas@fjasle.eu>
> > Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> > ---
> >  scripts/mod/Makefile     | 2 ++
> >  scripts/mod/file2alias.c | 3 +++
> >  2 files changed, 5 insertions(+)
> >
> > diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
> > index c729bc936bae..75c12c045f21 100644
> > --- a/scripts/mod/Makefile
> > +++ b/scripts/mod/Makefile
> > @@ -8,6 +8,8 @@ modpost-objs    :=3D modpost.o file2alias.o sumversion.=
o symsearch.o
> >
> >  devicetable-offsets-file :=3D devicetable-offsets.h
> >
> > +HOSTCFLAGS_file2alias.o +=3D -D_UUID_T -D__GETHOSTUUID_H
> > +
> >  $(obj)/$(devicetable-offsets-file): $(obj)/devicetable-offsets.s FORCE
> >         $(call filechk,offsets,__DEVICETABLE_OFFSETS_H__)
> >
> > diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> > index 99dce93a4188..ab743f6d60ef 100644
> > --- a/scripts/mod/file2alias.c
> > +++ b/scripts/mod/file2alias.c
> > @@ -11,6 +11,9 @@
> >   */
> >
> >  #include "modpost.h"
> > +#ifdef __APPLE__
> > +#define uuid_t sys_uuid_t
> > +#endif
> >  #include "devicetable-offsets.h"
>
>
>
>
> Is this what Nicolas suggested?
> https://lore.kernel.org/lkml/20240807-sexy-roadrunner-of-acceptance-a84bb=
f@lindesnes/
>
>
> I thought he suggested replacing #ifdef __APPLE__
> with -D_UUID_T -D__GETHOSTUUID_H.
>
>
> You added -D_UUID_T -D__GETHOSTUUID_H,
> keeping #ifdef __APPLE__.

I forgot to remove this.

Based on your suggestion in the other thread to use/overwrite
HOSTCFLAGS via the command line, it seems I should drop this patch.
Can you confirm?

>
>
>
>
>
>
>
>
>
> >  /* We use the ELF typedefs for kernel_ulong_t but bite the bullet and
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
