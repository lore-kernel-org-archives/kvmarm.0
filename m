Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE891C32;
	Sat, 17 Aug 2024 01:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723857085; cv=none; b=fcBpJ2Z41mwxG8nK8oVhp+MrWspGazc83z4ozxC90+sVh8UcsBY9zax9YET7ewv2SN32mh7DX672Ka3YV2DmnyFGWDTC/fZtmCESK4Hz+RnzQdLIEOy2T4N1ish5oC5rjPXbzEFfwYEkNW+FP6RUpHG5rHsa99DTU8YittkSPvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723857085; c=relaxed/simple;
	bh=g8Geri2XNbL38pyOWzp7d2MgOy9oPpFutYakSLbV27M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RPS2hwXnXpnG0yi4B4aQ8mYcCQpP1xMdURL7UATKekAlHJtWK0Xk1Gbr4E88HwhG+HbsDWGr2DtJ9i0rSBo62FLtsKFFVGk3lB+Jl3fDyBiJvbM+bUQpDtYuJy1GgrNQdBtEYxYPfme+KAXQIE+UhO8dQdvGGxUE2S7UvfSxAY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHrdNdxq; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHrdNdxq"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e0875f1e9edso2536948276.1;
        Fri, 16 Aug 2024 18:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723857082; x=1724461882; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ug8rihSZJE889SueAoqTX9ZWSfO/z3Gsu452Tq7F+6A=;
        b=aHrdNdxqC9MFVHgDgszrpoqsZXUIAWBtsHu5PPTRHB+MdmVtyEpaf9ZVYMXusu27Ac
         3Wzh7+s30FKpt7vVhmbSxxU8c3WZI9CRX5+9AP/O3kyaTmFwWtzs0ZfZETKdNVeyQbxF
         TumXhjq9upQIllRP7UpcYhax1SkP5S6K/ohaUB+3meqoKWGsNpXDwxagfc3llQKR0d4G
         C9ureEm2D335x0y+i2m+TXQEtpzksXwYWS/usPMDEpTt5crHOLi3nVQGN/jhC0H4hOOI
         I8TaLFEpvkmMW7RX3s3OrXFgBx9JldIk20lmp/X5OhA/SdHBox528vUXzbNg7cno0vjA
         oeAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723857082; x=1724461882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ug8rihSZJE889SueAoqTX9ZWSfO/z3Gsu452Tq7F+6A=;
        b=QQE4NobXvD+7I2Tsip3xdNy6sFZ4y+FXokbogL1cdIfB/+GftvgIDShH1oZY1zNutG
         N8PBDSPRkr3mR1xebS9/jV4Bj+dA0n46LhfZlvWFlDMoaBbYsPPE9fFteapZ6G9lJC7G
         4t9Cr2VKNjwmECgq30i84clTbHDsoVpt5KwYN2ZpC6FXIQSitF0W/f71Jv2niVfyov+G
         q4pvLY1Cbnx10TWivaAmOqp6GWXohnwAuNAtxl9JgrkAm8EQT3sHeu+NgTN/9rN2YSfD
         PrHmhIGhkm8RFU1MY4aZk1tBMFHDMTNCefy+CCrnEZu2jrafMQT/4k9XZSf8EnCs9Tyw
         XGww==
X-Forwarded-Encrypted: i=1; AJvYcCU+ovaDe8UsmWjuD07x+t84O0AwT5TWXPIyTOkN0zeEE+eIVz5uQ+1MNNXx2zoCXIUY/XFx5P0SbG+YO0e68T7pM703vT2cFuAirIjYzXD8DDDGfPjE4eO0FousOw==
X-Gm-Message-State: AOJu0YyiuNQQt5jbeplojkeCKrbxxcJlJQn1U9RvOvavuX/uKuJebMPa
	Dy9Hef++p3qT7zRQr9bIlSEi2pb3G4Z5N4Mfea+JyQ2QCqyVlz7ZCDKiv5UJb3e2YK0nr4ApAeK
	w3bc2julHURw3GWO73UJw3vQPlNQ=
X-Google-Smtp-Source: AGHT+IEM2mdGVjOsGnMz8WXTnI9118qcDH2jUCIIbDZ4rPiQ10iGBBlTUuDxRR73hnxLfbHp9nYn32+CIgpvlrRB+hI=
X-Received: by 2002:a05:6902:701:b0:e08:5e73:cdf3 with SMTP id
 3f1490d57ef6-e1180e6c54emr4739180276.9.1723857082428; Fri, 16 Aug 2024
 18:11:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807-macos-build-support-v1-0-4cd1ded85694@samsung.com>
 <CGME20240807110114eucas1p2e1ca4cbd352c6cd9d60688b1570df8d4@eucas1p2.samsung.com>
 <2024080753-debug-roulette-8cb1@gregkh> <3jnp6tnkjpvnisefomxagazu2u3uzzt7rcon3r5jssraxzwegb@gsxc7c5sfh7v>
 <2024080758-dedicator-smoky-44be@gregkh>
In-Reply-To: <2024080758-dedicator-smoky-44be@gregkh>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 17 Aug 2024 13:11:11 +1200
Message-ID: <CAGsJ_4zA6=ajoOgAm9kweeiBFKz4TJxxjYFGHHd3HQY8dxHpWA@mail.gmail.com>
Subject: Re: [PATCH 00/12] Enable build system on macOS hosts
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Gomez <da.gomez@samsung.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, 
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
	"Daniel Gomez (Samsung)" <d+samsung@kruces.com>, "gost.dev@samsung.com" <gost.dev@samsung.com>, 
	Nick Desaulniers <nick.desaulniers@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 8, 2024 at 2:20=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Aug 07, 2024 at 01:56:38PM +0000, Daniel Gomez wrote:
> > On Wed, Aug 07, 2024 at 01:01:08PM GMT, Greg Kroah-Hartman wrote:
> > > On Wed, Aug 07, 2024 at 01:09:14AM +0200, Daniel Gomez via B4 Relay w=
rote:
> > > > This patch set allows for building the Linux kernel for arm64 in ma=
cOS with
> > > > LLVM.
> > >
> > > Is this a requirement somewhere that this must work?  It seems like a=
n
> > > odd request, what workflows require cross-operating-system builds lik=
e
> > > this?
> >
> > This isn't a requirement, but it would, for example, support workflows =
for QEMU
> > users and developers on macOS. They could build/compile the kernel nati=
vely and
> > use it to launch QEMU instances, simplifying their process.
>
> But that's not a real workload of anyone?  How often does this ever come
> up?  Who is going to maintain this cross-build functionality over time?

it is a real workload of me,  i was running qemu-system-aarch64 on x86
and it was
pretty slow. so got a M3 pro to accelerate my development. frequently chang=
ing
kernel's source code, i am using qemu-system-aarch64 to do quick verificati=
on.

>
> thanks,
>
> greg k-h
>

Thanks
Barry
