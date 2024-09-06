Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1027E1D1F60
	for <kvmarm@lists.linux.dev>; Fri,  6 Sep 2024 14:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725634607; cv=none; b=cLlx2SpbVLgV8V1ZUhqIJrRWbCkRdf78tO/cij5XmVmpYdgi0K35XloPZjXYh1bw9rJuw+EUT9CnmTqAusIj/6jI7ECkpvWl0NDpjxZFhor6lOqoDsCngWFgRhZzpn70CTFH7QsbL87ZXyDBb53w8is4JNLi+C+KenmXlevmouA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725634607; c=relaxed/simple;
	bh=Z4WKeJmpOYFiYE7cCHqfI5S+mHBFpdvOr74BGZhwPJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uRMbv92mdEz7566ovKb3XT7ee47NbnHs+cpQGcaTUwIDmacYxP/QIaBV8q9ei/eI+LQA/C06rRTP3MpHFbVpRFH2j1CGK+WVlniHnGxOm76opjET8bus/0OkzQ5x6sE3bx88tA0HEM7EGxy7hbehzX2m4VopqVnPyl9DJWbIve0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Yum8ZkNb; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Yum8ZkNb"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-502ae81b4daso201239e0c.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Sep 2024 07:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1725634605; x=1726239405; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8DQFAISHS7i5IP3gsOeV2GhBMoOIKb1H2ynRnefFiA=;
        b=Yum8ZkNbOK6DAGYWjPl8kRHOwbo1+HXMGK/8gHVzHaIWUFZsIeEOAY/oBLRBdph5G8
         B78cEx8tiWUCufR5TusdxTPY6KtOXKntrN37k9jtoHD4+XvHM0F01xfUd0B0mR9v2tsj
         CUM2v5Zq8igazAzGj6YpxdL0PE1agBEnO5dvGb/Neu2UB1AlPzcOCMzaDjPtDqFpYlx6
         t2LNza88PDyds8ofnp9lzZS7U3Wq/VtZXHEU73Og/JVhWKICNdrH7mkA+FnNKXC+qgfs
         Iyw8mQ9WZ8iw8NySyLgyk9VBYvn/HeiIHllULlvJ0GffVcI07Mh8N1eLXUNXFyuILzrA
         Y2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725634605; x=1726239405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z8DQFAISHS7i5IP3gsOeV2GhBMoOIKb1H2ynRnefFiA=;
        b=UjbTKD4peXOSFnNns8Sd/OUZrfSHjqdgFb0O8B0hi/XfpIRtBuSOI/I+S58VZ1vUGv
         qA7ULU1bGhEYd9RXHFP/deNjMugWHcefpVVG8nxw5gQB7H7UvFZ303RTeSR+J6pRjHI3
         dUOCFMzWvwBEvh9DMUjInE1az6X5QGWKbexUMjKJSKnfKdDkIWB9S5gEQPb83CIWIAt6
         wwTdWIjSah77DMA/NrU3IFLiUfoXqESKmGY9ndUpVy3skLgNQQsvXqvAuO8PD0MGYw2b
         /ksae98qp/07Hu4NW5/904FWxQ6x7vOA8CVOPXtAcRa95GSsAKYCWOtVRc8QuV1G6vCl
         +WQw==
X-Forwarded-Encrypted: i=1; AJvYcCV5mXNVpeH2E1n9ev4v8SOf+uuG40h41gmNrF9/hvQ9s3LYeU/CaU/cPrCxcmGoL2i5jEl4iWw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNw1r7JmQOyA19pSO+hbLG0NFYiDPG5FNib9PhMJ1rtgSldFG4
	3cx8xWWhyeAYck2gL8b7t2QO21/HJLILIpVXiZy6GCIDJHwBjf11DV1OpD0S+OMh53gmZ20B52e
	zQz6wHNdSpvadN3n+caoekZdsr848PFczwy/A
X-Google-Smtp-Source: AGHT+IHq7ZiORKnHJ7OGW0/x1cWaLstSbHVVP69Jhc2KtxHBDUWP5W0/AltVyanWWqQY/QWC4tnW0snbDbe3WIJv/jg=
X-Received: by 2002:a05:6122:3b17:b0:501:2842:428a with SMTP id
 71dfb90a1353d-50128425272mr4021883e0c.8.1725634604866; Fri, 06 Sep 2024
 07:56:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com> <20240906-macos-build-support-v2-6-06beff418848@samsung.com>
In-Reply-To: <20240906-macos-build-support-v2-6-06beff418848@samsung.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 6 Sep 2024 10:56:33 -0400
Message-ID: <CAHC9VhRpHgqN2fp1J3x9=zBqNr3QHsSDgUnoZ7M-SuOQ6hQ4nw@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] selinux: do not include <linux/*.h> headers from
 host programs
To: da.gomez@samsung.com
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
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

On Fri, Sep 6, 2024 at 7:01=E2=80=AFAM Daniel Gomez via B4 Relay
<devnull+da.gomez.samsung.com@kernel.org> wrote:
>
> From: Masahiro Yamada <masahiroy@kernel.org>
>
> Commit bfc5e3a6af39 ("selinux: use the kernel headers when building
> scripts/selinux") is not the right thing to do.
>
> It is clear from the warning in include/uapi/linux/types.h:
>
>   #ifndef __EXPORTED_HEADERS__
>   #warning "Attempt to use kernel headers from user space, see https://ke=
rnelnewbies.org/KernelHeaders"
>   #endif /* __EXPORTED_HEADERS__ */
>
> If you are inclined to define __EXPORTED_HEADERS__, you are likely doing
> wrong.
>
> Adding the comment:
>
>   /* NOTE: we really do want to use the kernel headers here */
>
> does not justify the hack in any way.
>
> Currently, <linux/*.h> headers are included for the following purposes:
>
>  - <linux/capability.h> is included to check CAP_LAST_CAP
>  - <linux/socket.h> in included to check PF_MAX
>
> We can skip these checks when building host programs, as they will
> be eventually tested when building the kernel space.
>
> I got rid of <linux/stddef.h> from initial_sid_to_string.h because
> it is likely that NULL is already defined. If you insist on making
> it self-contained, you can add the following:
>
>   #ifdef __KERNEL__
>   #include <linux/stddef.h>
>   #else
>   #include <stddef.h>
>   #endif
>
> scripts/selinux/mdp/mdp.c still includes <linux/kconfig.h>, which is
> also discouraged and should be fixed by a follow-up refactoring.
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
>  scripts/selinux/genheaders/Makefile              |  4 +---
>  scripts/selinux/genheaders/genheaders.c          |  3 ---
>  scripts/selinux/mdp/Makefile                     |  2 +-
>  scripts/selinux/mdp/mdp.c                        |  4 ----
>  security/selinux/include/classmap.h              | 19 ++++++++++++------=
-
>  security/selinux/include/initial_sid_to_string.h |  2 --
>  6 files changed, 14 insertions(+), 20 deletions(-)

Similar to patch 7/8, please read my comments on your previous posting
of this patch, it doesn't appear that you've made any of the changes I
asked for in your previous posting.

https://lore.kernel.org/selinux/317c7d20ab8a72975571cb554589522b@paul-moore=
.com

--=20
paul-moore.com
