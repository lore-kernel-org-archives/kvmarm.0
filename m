Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4526C149;
	Sun,  8 Sep 2024 01:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725759008; cv=none; b=kPtPLRFiZPMznQvnQJHRJuhoCP+sSmU9fI4Kidh96CfdDe7V82Ub9VYmMKXhuzB+M2K6eXCdQaA7nQyzbRhKVhXeEKoDKOeBXwd5RQRYXzpqg7QcRf/GUgg0pNbc/KmECtel7F17HIotoxcngUK6ic6aqhZbWeFpIuaWbCpw5yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725759008; c=relaxed/simple;
	bh=fyOnv3k2017y/ErSznnZHp0l9XWS0bPVAmjp32U6Etk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IwSQsblCiMKSenuHlh/X/YW5yEur9R0BRE/UJaabWbjqDADMZtQwsDt//86WNV5Cds70Y7+qroZtgf9gpdJ6zUftQx/kFhRGvKPhJsmMuWDRINNCx5/bNReWc/i908jBeRffcnuW5lEAumL+FJQ5QA6pu+RYosaLtps1jGNpaq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iw0ZyrY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iw0ZyrY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E55C4CECF;
	Sun,  8 Sep 2024 01:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725759008;
	bh=fyOnv3k2017y/ErSznnZHp0l9XWS0bPVAmjp32U6Etk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iw0ZyrY4vuLZ21JCPOC7RhuX7jH+ga/520Dv1aaM8uNgOoHpA/cMaELxoMFbt9WhQ
	 6cWjNnSP4o7rT5Xc1qm3XtbFn4YS0prmu2KTWtXTjxFFhomNRnXeVVh9JP5z7M7miU
	 RsaI6nAFHnSgzlWx+0avsFEestaO6zMIOeHJmmJYY2W/sPtsC3Enk28MuA6dyzDfS8
	 B0BwayB0He+GmuHbYvmm98cgYqbFocvJdNDrBPe2nLlyhExI1t8DoPlC1Xy7y6a7TS
	 6nqNvu2hKR3rjjA6O1+SusQWQQ2vp9f+8BBS60UzZLI2p5UciVSLsD54+sq6iFumv2
	 XlPJ61sFI6v6g==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-536562739baso2513847e87.1;
        Sat, 07 Sep 2024 18:30:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVkjNI6xngTKGjm0ZJSccbu3O9jHLgqOIQPy6FYcI1gW4PNfhZz03iQRohLaCrtlyD4tXuKTrg=@lists.linux.dev, AJvYcCX9JOa4c+E7dUUYm4esjW6+gf3vw0t+A1oz/wGZZx2M7ClEcneys6HqoI0AgtakspGwnGyqhA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwRErFZ77PWCeYhbdAAlAJgsKxJkbb2yejjhqv31d35RfVUNtPQ
	5AaTvV4VrazAFZsSlTsVWCrlh5F2Vdov0VTBsHjpkowBIt7kriMufDFIz1yvjFTIch+rPKA1JyS
	Fidu7kNk06aObD570dZWwN7MNRuA=
X-Google-Smtp-Source: AGHT+IF+h293KpoI++f+ufbs7y7oQSzJ8FqYF6U09FVXsYlA3fTualWC6YvD7rLK4LHaRVS5cfnW7EaXVcZxWqO9e3g=
X-Received: by 2002:a05:6512:1598:b0:535:66bb:3303 with SMTP id
 2adb3069b0e04-536587a4100mr4487964e87.12.1725759006849; Sat, 07 Sep 2024
 18:30:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com>
 <20240906-macos-build-support-v2-8-06beff418848@samsung.com>
 <CAK7LNASpWSXbjF_7n0MhosNism=BpvHOnKsa344RPM_wmC9dGA@mail.gmail.com> <CABj0suBQCc8=0tLng=OWW=K1hjFuLFZWhbjsqHtz2FzZt4i0sw@mail.gmail.com>
In-Reply-To: <CABj0suBQCc8=0tLng=OWW=K1hjFuLFZWhbjsqHtz2FzZt4i0sw@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sun, 8 Sep 2024 10:29:30 +0900
X-Gmail-Original-Message-ID: <CAK7LNARqUTC2GixVeUQpMvzWt=h8KZvLHTHvp3ftxNwJQU6pWQ@mail.gmail.com>
Message-ID: <CAK7LNARqUTC2GixVeUQpMvzWt=h8KZvLHTHvp3ftxNwJQU6pWQ@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] Documentation: add howto build in macos
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

On Sat, Sep 7, 2024 at 6:32=E2=80=AFPM Daniel Gomez (Samsung)
<d+samsung@kruces.com> wrote:
>
> On Sat, Sep 7, 2024 at 10:33=E2=80=AFAM Masahiro Yamada <masahiroy@kernel=
.org> wrote:
> >
> > On Fri, Sep 6, 2024 at 8:01=E2=80=AFPM Daniel Gomez via B4 Relay
> > <devnull+da.gomez.samsung.com@kernel.org> wrote:
> > >
> > > From: Daniel Gomez <da.gomez@samsung.com>
> > >
> > > Add documentation under kbuild/llvm to inform about the experimental
> > > support for building the Linux kernel in macOS hosts environments.
> > >
> > > Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> >
> >
> > Instead, you can add this instruction to:
> >
> > https://github.com/bee-headers/homebrew-bee-headers/blob/main/README.md
>
> Sure, that can be done as well. But the effort here is to have this
> integrated. So, I think documentation should be in-tree.



I do not think so.


Most people are not compile-testing on macOS.

This is an unofficial tip, which you can advertise
somewhere else.




--=20
Best Regards
Masahiro Yamada
