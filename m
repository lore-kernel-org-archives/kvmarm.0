Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE0E17E44A;
	Sun,  1 Sep 2024 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207339; cv=none; b=n4wiyz/xPKN6DQqTSVBxy2Cyd1vYzdgS4CI42c77xQezcVmjeYf7LsS9E169qtGH8aXi5O5uSJX+35i9MIeSrSe6UvFAbnKp6J7teOAMZCa+Zr4cyPH8/V3Wd9lTe3ynYW+9mI2HHitdFcgQx8pjnNRG68kKE0DDYVL/5ADDdXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207339; c=relaxed/simple;
	bh=gYIgZOi4sdR4hTdNE3LJJ3LeXGN5BLGNfkofNqnsRBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N6qqo20wIkhFTpJlW43OidiwknW60YVmFQQ/2ZN47qOO+nTSh5IRp0EOHOg84KyhTVjQjPaOymrBVRws8KlIDKDO6Vm3N3zddDoosP9lVeOiofyw+Dt9eSr9Fdm4Qsa5IISgmuAnBSVlhDRsc7CLa7QvhG0zjjqvXDQl0NRe1uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5h1/eNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5h1/eNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939F5C4CECA;
	Sun,  1 Sep 2024 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725207338;
	bh=gYIgZOi4sdR4hTdNE3LJJ3LeXGN5BLGNfkofNqnsRBc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=F5h1/eNLAut+K9xbInA8o1Vqa2sZpvVnt33i+mDoFpaubGehtbFtkTdZKWa1mvOQU
	 CSsiRwCvOWvZvMvEO8L0Dsxwyr89B9qMvVFfrWbzq6Z8wKms7E7vADuGZJavaJ+Yq9
	 ddCRkatwMBI2yP8xVSOJokY6nLAtiaa47fyw12UjAMSKYqFuQqVvxjY3Vk9ZgQzRoc
	 6bOCtTkFHWjSazc04tEnJCsudAEBR8Pcv/himZ9VWJRdbe++qCe48wzQKqTx7uOX07
	 J7ewjUPy7qvCfaKAR8hR3puGLgD0egOP9gXsf94jOOO8lGHC7jbxrL/PZ8tNivTSUu
	 C2srQRHZ3LE7g==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53346132348so4320883e87.2;
        Sun, 01 Sep 2024 09:15:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVUpQ468UjH0YYC43sQzFBKnkfsv3LtvM4G9+Q5MmJSU4HAWAWIjvCmTQzG7qFjvYRU7/DjeZ8=@lists.linux.dev, AJvYcCX6Kp8gzTNtGA0EhzTOYHXVoDYuQdrmbM5+u3lhUl4OhzS7SZW72LqqK2sPMeBESa0GGHDZmA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyY8hTbBgLvs9NoCVmdoQ/LauZnA+y7RUI0gXVsCsoHpuv7sKTS
	eGs6/iw7RIB2dxgWNyZrBbrqPld5+r0KnW5Sl8s/2WSA+mK91cBcvuAcHDTXCRLrj6vPQ4/RUEK
	4bIH02tuf2fgIY4VOvluyGcMefe8=
X-Google-Smtp-Source: AGHT+IEvW4vK5zxx451a7ZmsPELGu2ASm3u0aIbHJUwKBVb/P5sQhkJtI91jLzLi0FROvKEcgj/L3zpZL4SS+3Wibx0=
X-Received: by 2002:a05:6512:282b:b0:533:d3e:16e9 with SMTP id
 2adb3069b0e04-53546bb4402mr4892938e87.57.1725207337206; Sun, 01 Sep 2024
 09:15:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807-macos-build-support-v1-0-4cd1ded85694@samsung.com>
 <20240807-macos-build-support-v1-8-4cd1ded85694@samsung.com>
 <CGME20240807110435eucas1p2eca071b0a0122b8686d43c57bd94dc8c@eucas1p2.samsung.com>
 <2024080717-cross-retiree-862e@gregkh> <dxkmmrlhlhsrjulnyabfgcr37ojway2dxaypelf3uchkmhw4jn@z54e33jdpxmr>
 <2024080720-skyline-recapture-d80d@gregkh> <20240807-mottled-stoic-degu-d1e4cb@lindesnes>
 <20240823225450.spuvjs5b5ruujim4@AALNPWDAGOMEZ1.aal.scsc.local> <ZtIjNBhqdxmMBxfM@fjasle.eu>
In-Reply-To: <ZtIjNBhqdxmMBxfM@fjasle.eu>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Mon, 2 Sep 2024 01:15:01 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQhHBi7nSG5SAbqD3HFO3uMR6GHckZHcQXgWao7G8i9gw@mail.gmail.com>
Message-ID: <CAK7LNAQhHBi7nSG5SAbqD3HFO3uMR6GHckZHcQXgWao7G8i9gw@mail.gmail.com>
Subject: Re: [PATCH 08/12] include: add elf.h support
To: Nicolas Schier <nicolas@fjasle.eu>
Cc: Daniel Gomez <da.gomez@samsung.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Lucas De Marchi <lucas.demarchi@intel.com>, 
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
	Zenghui Yu <yuzenghui@huawei.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>, 
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>, 
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, 
	"speakup@linux-speakup.org" <speakup@linux-speakup.org>, 
	"selinux@vger.kernel.org" <selinux@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, 
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>, Finn Behrens <me@kloenk.dev>, 
	"Daniel Gomez (Samsung)" <d+samsung@kruces.com>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 31, 2024 at 4:54=E2=80=AFAM Nicolas Schier <nicolas@fjasle.eu> =
wrote:
>
> On Sat, Aug 24, 2024 at 12:54:50AM +0200 Daniel Gomez wrote:
> > On Wed, Aug 07, 2024 at 05:46:03PM +0200, Nicolas Schier wrote:
> > > On Wed, Aug 07, 2024 at 04:18:54PM +0200, Greg Kroah-Hartman wrote:
> > > > On Wed, Aug 07, 2024 at 02:13:57PM +0000, Daniel Gomez wrote:
> > > > > > Also, as this is not internal for the kernel, but rather for us=
erspace
> > > > > > builds, shouldn't the include/ path be different?
> > > > >
> > > > > Can you suggest an alternative path or provide documentation that=
 could help
> > > > > identify the correct location? Perhaps usr/include?
> > > >
> > > > That is better than the generic include path as you are attempting =
to
> > > > mix userspace and kernel headers in the same directory :(
> > >
> > > Please keep in mind, that usr/include/ currently does not hold a sing=
le
> > > header file but is used for dynamically composing the UAPI header tre=
e.
> > >
> > > In general, I do not like the idea of keeping a elf.h file here that
> > > possibly is out-of-sync with the actual system's version (even though
> > > elf.h should not see that much changes).  Might it be more helpful to
> > > provide a "development kit" for Linux devs that need to build on MacO=
S
> > > that provides necessary missing system header files, instead of mergi=
ng
> > > those into upstream?
> >
> > I took this suggestion and tried pushing a Homebrew formula/package her=
e [1].
> > I think I chose a wrong name and maybe something like "development kit"=
 would
> > have been better. However, would it be possible instead to include the =
*.rb file
> > in the scripts/ directory? So users of this can generate the developmen=
t kit in
> > their environments. I would maintain the script to keep it in sync with=
 the
> > required glibc version for the latest kernel version.
> >
> > [1] https://github.com/Homebrew/homebrew-core/pull/181885
>
> I think it sounds sensible to hold that formula file in the upstream tree=
.  But
> I am not sure if scripts/ is the best location.
>
> Masahiro, what do you think?


I do not know much about the homebrew, but why does the upstream
kernel need to merge such masOS stuff?



>
> Kind regards,
> Nicolas



--=20
Best Regards
Masahiro Yamada
