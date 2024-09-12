Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E02A19E96A;
	Thu, 12 Sep 2024 12:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142538; cv=none; b=ie+EdVi6nbWaPBd0za0nGVfU0/+Khe1tqNPt1Mf14JWqA9HE/bv2dMxAMwQ2gtxT0MvUzZaAGI4P2otzU9l2bfcBRA9piksJGKOkbwGOANqur5ejOGqF5Tp1QsTMlF+DEv4Y1DoJJakymSknHbn6ygVkvz7theqYje5tN6WalwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142538; c=relaxed/simple;
	bh=NisE6b5jBkIYG8cahohTY3odH/OlkvvqfpDW2Y9e3CU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l4TXDKOrNQh7PEoyfSEcgc63gHt53I4BOQfgbQzrQEnf74hSKTKQgCmaEo8B+N3UxmeVWid/4uJi/NR68Z+JQYa773bTzJBX7AHtADw/KbNKouar1obEiBTozu7AsjMQcOD9+PQv+RBOGPluEYyh7t5xQWZQA1NwVRPTjqUpC6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iQjm0KOl; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQjm0KOl"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3e04a6feef3so393556b6e.3;
        Thu, 12 Sep 2024 05:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726142535; x=1726747335; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RhlE/sT3sXQgkwTWsPGrGAWEL/QnHXai566ohH4s0z0=;
        b=iQjm0KOlG0bdcWtGOdEryGQjGnaJu6i+LrEN9aUJT8ocW6mFgua23YbxgDf/3pJanu
         LJUZSu5REbEovD3Kg3y3iZs6dRsrLFvSmCWUCMdvVUgCj3GTc1sNACKI4COp24Hv60Bl
         BMaq/117LdYVxRfF+EtCkljcQkPn1p+R5T8j7/1nQWZkzja+L61SKUC1sG6yqTVaSH4Z
         JDxfDDsOVkAIE2f3fQZKhR+/oaMm2WJbA7XH7ADK3pa/iBkz2/NAcylFdrr1VDQhPCrE
         WZnMbrvY1ZBjIZ3APjaAlmCsm2X4l3xEgVMWfJrGfygY41EoTpYfvlVqxv1OoTpHxOoK
         FXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726142535; x=1726747335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RhlE/sT3sXQgkwTWsPGrGAWEL/QnHXai566ohH4s0z0=;
        b=FwTW8JkpDsj0cflBznH4FdAcb6wZl2LY2sNd1DdeyDe5MptQbSima3Md/uD6VIc/Zg
         tKubYYgjyaqYhAcP45RCKkoRPazmwC2p4HvREufMxbrIahTS4GOrBetzZTqOlvAUvLnP
         h4yQQbDfvq32ftbtTG5L9rM5pgkzGEFom+uZcwHb9egFBRlDFdPDs+kTxC2LlOzCRNID
         ccYuJWaCCroexFayfxwQ2BR35NhUCyb0l+qQmUWZFBJmRfJYAGV98ein0NVzZaRLC5Lr
         9yRUrRr2N0kBnFveAdc5SsyQ0F7+cJEvF5IuO7ZWXm5v4Wn2t3+T4vDmpCi8hXVzz9Gl
         A53Q==
X-Forwarded-Encrypted: i=1; AJvYcCUuHF3mZptN4dAuTyT+XbVRtbMvpki5dceLJGj48L7lX8KgTUhbkfInb6vQvrLINiR8CsvkQA==@lists.linux.dev, AJvYcCVNM7FpGVEiy+c61nq/znXWh1HxEg/xubs1hDuKXojt8DEbPdmc2TmxCws8cGXNqvkAVDInC/w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzpjan7MaMg9/2lDqqpWOCMHgZdy40G7pWaCqmRHImlhjFukcZy
	xTEaqi6v9DbL6o7zy4ggg9ZALBlwjFUmW69YSrAVwDu8hiJYI/q6kv96ASvNYPDS6O8H7fx9xZF
	8NhfJfhi9wSwCi+wc5XZXnwKow4g=
X-Google-Smtp-Source: AGHT+IFDEn0YDYeD/9jctAipL6iMdSyGrxKEkVhZltDVHssnsNZVCgDM2BbSFzNex8/uLR3y/m0Zd6KEYQB/81KqoJU=
X-Received: by 2002:a05:6808:1897:b0:3e0:422e:f05b with SMTP id
 5614622812f47-3e071ae3bdamr1684193b6e.29.1726142534514; Thu, 12 Sep 2024
 05:02:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com>
In-Reply-To: <20240906-macos-build-support-v2-0-06beff418848@samsung.com>
From: Jeff Xie <xiehuan09@gmail.com>
Date: Thu, 12 Sep 2024 20:02:03 +0800
Message-ID: <CAEr6+EAcwq5n7R8BmsKg8B46TkrSvEL9hDmjZeD3ek_1rKg_hQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Enable build system on macOS hosts
To: da.gomez@samsung.com
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
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
	Finn Behrens <me@kloenk.dev>, "Daniel Gomez (Samsung)" <d+samsung@kruces.com>, gost.dev@samsung.com, 
	Nick Desaulniers <nick.desaulniers@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for submitting this patchset. This problem has troubled me
for two years.
I have always built the kernel in the docker container. I have tested
this patchset and it is very good.
Tested-by: Jeff Xie <xiehuan09@gmail.com>

On Fri, Sep 6, 2024 at 7:04=E2=80=AFPM Daniel Gomez via B4 Relay
<devnull+da.gomez.samsung.com@kernel.org> wrote:
>
> This patch set allows for building the Linux kernel for arm64 in macOS
> with LLVM.
>
> Patches are based on previous Nick's work and suggestions [1][2][3] to
> enable the Linux kernel build system on macOS hosts.
>
> macOS does not provide certain headers that are available in a GNU/Linux
> distribution with development headers installed, usually provided by
> the GNU C Library (glibc) and/or other projects. These missing headers
> are needed as build dependencies. To address this, the patches depend
> on a new Bee Headers Homebrew Tap formula [6][7][8] that provides them
> together with a pkg-config file to locate the include directory.
>
> To locate them, Makefiles include something like:
>         $(shell $(HOSTPKG_CONFIG) --cflags bee-headers 2> /dev/null)
>
> [6] Project:
> https://github.com/bee-headers
> [7] Headers repository:
> https://github.com/bee-headers/headers.git
> [8] Homebrew Tap formula:
> https://github.com/bee-headers/homebrew-bee-headers.git
>
> To set up the environment, documentation is provided via last patch in
> this series.
>
> More configurations and architectures as well as support for Rust
> (from Finn Behrens [4] [5]) can be added in the future to extend build
> support.
>
> [1]: WIP: build Linux on MacOS
> https://github.com/ClangBuiltLinux/linux/commit/f06333e29addbc3d714adb340=
355f471c1dfe95a
>
> [2] Subject: [PATCH] scripts: subarch.include: fix SUBARCH on MacOS hosts
> https://lore.kernel.org/all/20221113233812.36784-1-nick.desaulniers@gmail=
.com/
>
> [3] Subject: Any interest in building the Linux kernel from a MacOS host?
> https://lore.kernel.org/all/CAH7mPvj64Scp6_Nbaj8KOfkoV5f7_N5L=3DTv5Z9zGyn=
5SS+gsUw@mail.gmail.com/
>
> [4] https://github.com/kloenk/linux/commits/rust-project_macos-dylib/
>
> [5] https://kloenk.eu/posts/build-linux-on-m1-macos/
>
> To: Masahiro Yamada <masahiroy@kernel.org>
> To: Nathan Chancellor <nathan@kernel.org>
> To: Nicolas Schier <nicolas@fjasle.eu>
> To: Lucas De Marchi <lucas.demarchi@intel.com>
> To: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> To: Rodrigo Vivi <rodrigo.vivi@intel.com>
> To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> To: Maxime Ripard <mripard@kernel.org>
> To: Thomas Zimmermann <tzimmermann@suse.de>
> To: David Airlie <airlied@gmail.com>
> To: Daniel Vetter <daniel@ffwll.ch>
> To: William Hubbs <w.d.hubbs@gmail.com>
> To: Chris Brannon <chris@the-brannons.com>
> To: Kirk Reiser <kirk@reisers.ca>
> To: Samuel Thibault <samuel.thibault@ens-lyon.org>
> To: Paul Moore <paul@paul-moore.com>
> To: Stephen Smalley <stephen.smalley.work@gmail.com>
> To: Ondrej Mosnacek <omosnace@redhat.com>
> To: Catalin Marinas <catalin.marinas@arm.com>
> To: Will Deacon <will@kernel.org>
> To: Marc Zyngier <maz@kernel.org>
> To: Oliver Upton <oliver.upton@linux.dev>
> To: James Morse <james.morse@arm.com>
> To: Suzuki K Poulose <suzuki.poulose@arm.com>
> To: Zenghui Yu <yuzenghui@huawei.com>
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> To: Jiri Slaby <jirislaby@kernel.org>
> To: Nick Desaulniers <ndesaulniers@google.com>
> To: Bill Wendling <morbo@google.com>
> To: Justin Stitt <justinstitt@google.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-kbuild@vger.kernel.org
> Cc: intel-xe@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: speakup@linux-speakup.org
> Cc: selinux@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.linux.dev
> Cc: linux-serial@vger.kernel.org
> Cc: llvm@lists.linux.dev
> Cc: Finn Behrens <me@kloenk.dev>
> Cc: Daniel Gomez (Samsung) <d+samsung@kruces.com>
> Cc: gost.dev@samsung.com
>
> Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> ---
> Changes in v2:
> - Add documentation and set this 'feature' as experimental.
> - Update cover letter.
> - Drop unnecessary changes. Patches removed:
>         - kbuild: add header_install dependency to scripts
>         - include: add endian.h support
>         - include: add elf.h support
> - Update Makefiles to find Bee Headers with pkg-config.
> - Update file2alias to solve uuid_t conflicts inside Makefile as
> suggested by Nicolas Schier.
> - Adapt xe_gen_wa_oob to solve getprogname()/
> program_invocation_short_name in runtime. as suggested by Lucas De
> Marchi.
> - Remove linux/version.h in accessibility/speakup as suggested by
> Masahiro Yamada.
> - Replace selinux patches with new Masahiro Yamada's patches:
>         Message-id: 20240809122007.1220219-1-masahiroy@kernel.org
>         Link: https://lore.kernel.org/all/20240809122007.1220219-1-masahi=
roy@kernel.org/
> - Replace tty/vt with new Masahiro Yamada's patch:
>         Message-id: 20240809160853.1269466-1-masahiroy@kernel.org
>         Link: https://lore.kernel.org/all/20240809160853.1269466-1-masahi=
roy@kernel.org/
>         (Already merged in the linux-next tag used)
> - Replace scripts/kallsyms patch with Masahiro Yamada's patch:
>         Message-id: 20240807181148.660157-1-masahiroy@kernel.org
>         Link: https://lore.kernel.org/all/20240807181148.660157-1-masahir=
oy@kernel.org/
>         (Already merged in the linux-next tag used)
> - Link to v1: https://lore.kernel.org/r/20240807-macos-build-support-v1-0=
-4cd1ded85694@samsung.com
>
> ---
> Daniel Gomez (5):
>       file2alias: fix uuid_t definitions for macos
>       drm/xe: xe_gen_wa_oob: fix program_invocation_short_name for macos
>       arm64: nvhe: add bee-headers support
>       scripts: add bee-headers support
>       Documentation: add howto build in macos
>
> Masahiro Yamada (2):
>       selinux: do not include <linux/*.h> headers from host programs
>       selinux: move genheaders to security/selinux/
>
> Nick Desaulniers (1):
>       scripts: subarch.include: fix SUBARCH on macOS hosts
>
>  Documentation/kbuild/llvm.rst                      | 78 ++++++++++++++++=
++++++
>  arch/arm64/kernel/pi/Makefile                      |  1 +
>  arch/arm64/kernel/vdso32/Makefile                  |  1 +
>  arch/arm64/kvm/hyp/nvhe/Makefile                   |  3 +-
>  drivers/gpu/drm/xe/xe_gen_wa_oob.c                 |  4 ++
>  scripts/Makefile                                   |  4 +-
>  scripts/mod/Makefile                               |  7 ++
>  scripts/mod/file2alias.c                           |  3 +
>  scripts/remove-stale-files                         |  3 +
>  scripts/selinux/Makefile                           |  2 +-
>  scripts/selinux/genheaders/.gitignore              |  2 -
>  scripts/selinux/genheaders/Makefile                |  5 --
>  scripts/selinux/mdp/Makefile                       |  2 +-
>  scripts/selinux/mdp/mdp.c                          |  4 --
>  scripts/subarch.include                            |  2 +-
>  security/selinux/.gitignore                        |  1 +
>  security/selinux/Makefile                          |  7 +-
>  .../genheaders =3D> security/selinux}/genheaders.c   |  3 -
>  security/selinux/include/classmap.h                | 19 ++++--
>  security/selinux/include/initial_sid_to_string.h   |  2 -
>  20 files changed, 123 insertions(+), 30 deletions(-)
> ---
> base-commit: ad40aff1edffeccc412cde93894196dca7bc739e
> change-id: 20240807-macos-build-support-9ca0d77adb17
>
> Best regards,
> --
> Daniel Gomez <da.gomez@samsung.com>
>
>
>


--=20
Thanks,
JeffXie
