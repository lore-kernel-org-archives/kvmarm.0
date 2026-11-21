Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795295973;
	b=Ab3zqSOEzAyXnw1XiI5rGBuB5C4F6dn10nl8Wv7KbGJSzk258iRiqaAVWxKgrFgwam0o
	 kpET53lOiQFRH87SXOi6uzPmBMAgcF2m3G0Qh8eMVzon4q0QTfWKkD+T5yIEPYm/9yxIm
	 CPoW/Sd+gphTtQv4I8751jl1USR/tRa2rlY6mWRmL4Lqdwn0I9EXFI+McyIrbYloe42Qn
	 +Yufx5YrGV2cRXZ9dtmLYlQ4OSBQUdk+8w81sFfjlAwItJttYrrLeKww2IW9qU95EzUrL
	 l6sdYTSnwKeZARFFbohDlw1DyJg4/925uxl5kIN/SkqOyLT6jZ6FZ0Kxw1ISMJEZ2hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795295973;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=TwRAZOxTtTXy+S3cTIsOYqmghOtnES71mWdup4rt0co=;
	b=ZYtn8Bf2ncBXcGPjsJAEYhD+S0TuFhekY/Hh0vJjpxg6+BErYcNqUI+7YyaPJC9Z1uLY
	 2emvk+sX2gnUUPXgGt1WBOW6CacWj13vXwYEEAZzQUBOM5A6PyyylxmymudaRqJrTKPKf
	 K/oJrCcQ+orVZTtDQdtPdFtQZZMmqTXtRFoc5ZVNxVQ37sBFpLkntDUX10EYoaQBeTTPP
	 LmyvvSOJB1ZMRtczf4HkLadhHJgnqW0HrsKHGShThzNJE3E2+l8rRCOw+fhYYoUC3P7lH
	 +S30F6Ro9Evm/SrPy9cnrewpc+R1aWiVHl7SQkrVpyCu38OYb99UHxpqom+QezXN/ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FhMdTVcv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8166606A331
	for <kvmarm@lists.linux.dev>; Sat, 21 Nov 2026 21:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FhMdTVcv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500B71F000CF
	for <kvmarm@lists.linux.dev>; Sat, 21 Nov 2026 21:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795295973;
	bh=TwRAZOxTtTXy+S3cTIsOYqmghOtnES71mWdup4rt0co=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FhMdTVcv7hTTIDYEMkZDmUO3HkhrUrXxLq3vHaLlCKM7YzylsICoYIYrTJzEPLoo9
	 74m27GMvvah0DCKBWuQ6PrnTPtuQi0Mj5HochkXuFFLwSUgkupkE8pd+D4gi6l8yMY
	 WiUsK6auPbm+CABDYq9ad1u8O4HV35tHtAx5BB0lbe7E/mMLpijZg+MBBW/og4WDVH
	 PnrfIXeF49zLuvj/Zw5vW+24lreUmuBdqsnfKXERsHh8i+AdH9+H6q+Pj+wwBVoq9c
	 4qZChs2Zy+IC0Q+zSRy0r9qNqwm36fY+aC33daLbfWwMzTKC/LoszT1mf+BmYgeGrY
	 KtJv2l90OFpxQ==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be4fea434bso3013545e87.1
        for <kvmarm@lists.linux.dev>; Sat, 21 Nov 2026 13:19:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF/qbgo4BTgM+oCGB4mmyQfOjikWcp7GZ5MhF1s6jCBrRYHxxKbAt9Vs0QXJqpV+HHAweHoeZA=@lists.linux.dev
X-Gm-Message-State: APuU4Z92mDY65i65Ub0sP2Exw/3jEbqXKPRvRiOSM3gc48oqbV0u6ZR4
	RxuzKL71XfHz2Av92F4IGEDg6cum4oD3jdbIo/Z4NW6E/RBP/wnDtcp1eBNN6RlNPo4GfCOaU/+
	qdduPZHnpzVlBZX55/XF6gkWvWByEZR4=
X-Received: by 2002:a05:6512:2c90:b0:5c1:7c6a:fefb with SMTP id
 2adb3069b0e04-5c1bc822245mr1829531e87.5.1795295972116; Sat, 21 Nov 2026
 13:19:32 -0800 (PST)
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
Date: Sat, 21 Nov 2026 22:19:18 +0100
X-Gmail-Original-Message-ID: <CAD++jLma8atXB=eT8TvvYfKMg=h6YGPY4THsYhLCeo2VumeJrw@mail.gmail.com>
X-Gm-Features: Aa3M54r702fjHjrynCh9jy5iyOc-dutIFRI6s0mpbPcKoEHETe8434E7oYhGyyA
Message-ID: <CAD++jLma8atXB=eT8TvvYfKMg=h6YGPY4THsYhLCeo2VumeJrw@mail.gmail.com>
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

Hi Ryan, Jean-Philippe,

On Thu, Oct 15, 2026 at 4:26=E2=80=AFPM Ryan Roberts <ryan.roberts@arm.com>=
 wrote:


> +/**
> + * struct cla_dev - CLA device
> + *
> + * Immutable state:
> + * @cpu:               The CPU this CLA is attached to.
> + * @dev:               The platform device.
> + */
> +struct cla_dev {

Don't abbreviate compulsively, cla is fine, I would
call it cla_device.

> +       unsigned int cpu;
> +       struct device *dev;
> +};

I will argue in other patches that this should be a proper
struct device and not a pointer to a platform_devcive
&pdev->dev.

Yours,
Linus Walleij
