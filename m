Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168071;
	b=1OLbTVWqhLEYL8uC/SPGthx1uRW/1AkdDtC88DOHTR6LBr82ddOKJiJsWD+EJ9gcvDno
	 SozU9rLcqshk3iGnfPkdjhyOjkiNVHtjiGFZQaDMPUyIyMLuiPeJHzEv6lbkIAkyrxN8P
	 JadeNUiTKPv2UfEVkc/kUNnXgUN6O8zjR5HJK3Yw3D8OwFc2u648b79GsMgopiFt6PZt3
	 5L3KT5l6DwbT47bea7rTw8o0Pn0JmII0xS8Jg+u2vZgL2jB/iHj+Xjve6aQfuJXrMyuzR
	 sjy3ssPWd7iZ5PgVIgvedWpFJhyVFOE9BrNLbFFShaNjjEG7265rKNQUCvCJQLQbSEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168071;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YU5P8Wuc2M6bZTL3XK84wjuebJ0zvL/QXfNPgZyOqi0=;
	b=A8pZl/jWjMixP1FwLrKWrbCKpwUiMAsPfWRMf711jpRwhSQSMZAweRjWUxl/ApbEjkl8
	 DE6kfy19QhgfACfrhH3RPPeV4ZxtTzu831hDXDdVmymTxPQWKOAOV0ATSyxNSLakj32rw
	 6+X+0Wj4dWNQma6UFHNKDUomOHZr4dwB/JQVsYCzX2fY8eAMoBOQofeGT46QSQdnc1t32
	 Dfsf3pi6NMYe4/LncOgMb6wIyqD3J2LR+jcSTprungw1hXDEmJU0eLLKy0+H6Dhj+l8ax
	 z+Rz4JExIVK/25e3V09RXTRPejWa+Tlhb0YN93G9Htl9H0sP3SbzXAqNA5gi52xBISw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TTQIJQdF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16D2606A325
	for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 09:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TTQIJQdF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5111F000EB
	for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 09:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795168071;
	bh=YU5P8Wuc2M6bZTL3XK84wjuebJ0zvL/QXfNPgZyOqi0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TTQIJQdFmsgcCJvZ5orSt7w0DatjFVZQwcM9IEaWaC+WjWprBbCupEHBw2ZEdEY5b
	 BIBCQ8gTLt9anGc3R+WoUEP/8X0wqmmRyUA0Is+/tDt6D0Coe+GssnIRmwyUztMzR9
	 n9c4oX6NDEhgWoC9wYM7VnNjMV3ikjcOOi9DiBzT4NUIQQANyKjVCwoQ9tX93LQ4Td
	 Wyq5vz3a4GnOFKlXnvezyfJNzLPLOgMgy6KV/q8eVLSgE7z+o4JrHPe3rMwYrkadWP
	 lboTcbWu9QSv9dLAlRzQXsDKcewPjqfaR/lq9p/AjBDOYgb+cEVXKzHr7WrFntR/Gm
	 Qp/UOxFXEysyQ==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3adef977ad9so5319851fa.1
        for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 01:47:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGCcLecyMPWtJjCEsdx6Afxt6novrdVbjz8aVvVPfHZxp+mKGNi5ARObuBON+Gw+w8Pfu8JXsM=@lists.linux.dev
X-Gm-Message-State: APuU4Z9Qd3V+co/5qrETTSG3WxSG58hqsjADUSAANZb1qQqSKpKRwz5y
	do/KwaQo2sVnx3lqzrMESG4TysrCqoC2k6QrqTEI0Nm1CSIh29ZpJ5Fe8gErTlxViS9ecvqDupe
	80V9yLkCk7ki9eLcBx529MzHSjrGHARU=
X-Received: by 2002:a05:6512:6d0:b0:5c0:463:7b4d with SMTP id
 2adb3069b0e04-5c1bc85f15fmr656116e87.46.1795168069914; Fri, 20 Nov 2026
 01:47:49 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261015142552.4128028-1-ryan.roberts@arm.com> <20261015142552.4128028-2-ryan.roberts@arm.com>
In-Reply-To: <20261015142552.4128028-2-ryan.roberts@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Fri, 20 Nov 2026 10:47:37 +0100
X-Gmail-Original-Message-ID: <CAD++jLkrWojU3FeTPGOCFHHsbmTGYG0Tz3b2nrn7mMfsDssCQw@mail.gmail.com>
X-Gm-Features: Aa3M54rOrfZtY95RmYFxRv97HUcFxeSdg2w3O8Cm90EYC1dabPW2gsgZ-nnS-cY
Message-ID: <CAD++jLkrWojU3FeTPGOCFHHsbmTGYG0Tz3b2nrn7mMfsDssCQw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 01/15] misc/arm-cla: Add driver skeleton and documentation
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@nvidia.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Jean-Philippe Brucker <jpb@kernel.org>, Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 4:26=E2=80=AFPM Ryan Roberts <ryan.roberts@arm.com>=
 wrote:

> +Inter-Accelerator Communication
> +-------------------------------
> +
> +On some platforms, multiple accelerators, each attached to a separate CL=
A within
> +a cluster, are also directly connected to each other via a shared bus to
> +accelerate cooperation between accelerators. The accelerators sharing a =
bus
> +cannot be isolated from each other. When collaborative operations are la=
unched
> +on each of the participating accelerators, they synchronize over the bus=
,
> +stalling until all are ready.

What the patch series needs to do is tell us how this topology is discovere=
d.
I.e. will it be discoverable from the hardware itself, or will this topolog=
y be
described in device tree or ACPI for example?

The kernel must certainly know this topology to be able to synchronize
work across several cores? What happens if an asynchronous acceleration
task is running on some cores and no actual CPU load is on any of them
and the kernel want to put them to idle or shut them down? Same problem
on the cluster level?

Further since this appears to be hardware topology userspace must obtain
this information from the kernel, not the other way around: we cannot
have a situation where userspace "just knows" stuff about the hardware,
keeping the kernel in the dark.

I think this is a wider question about the discovery of these CLA:s:
there must be a coherent story about how userspace finds it and maps
it topology and that information must come from the kernel, so the
kernel and userspace have the same map of the world.

Right now IIUC the driver probes from discovery in the hardware from
CPU-specific registers so does this discovery also include the topology?

Yours,
Linus Walleij
