Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795294892;
	b=mXgQCXWmkT5vhdQlbwXYqIehSfIDhlNUmFoayCNN4L+FRmAqVSbih2aaSxRLWBOKj/PB
	 TXwryawHl+4I8mn32BTs9D08RDAVHkrUoDo86MGZO7oQW+y420m7YC0Ah1nZxSvknHE21
	 guCaIuSmcRCqydDKEksts2oOuh14R8pO4bPBNCBC8oLRQCIMmcRm9G9NBG+ssf7U5H7/L
	 e3GcuvUb6WfpfQiv7GDriyuJClR9/V/JTyKSxaeaI3KzGGbTe1CGyGvCgoxCfKhzKzZLF
	 NSm+ZQKBmdIW9uREtHm3nE7liOB3XY4kb4KWef5pIglT7jHpc2gMxgEw0UVAsUSk6Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795294892;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=v8vAHChTalJyPKJWjYAU8hJ9rNARiHKrkluyFMh0zh8=;
	b=OIc3D2chP14qkA4qTIsHr6SABgnYvpvr+nYumP5JO4AtL7UkR8lHkKGEPgbm2dckg3Wi
	 6O6K5aSiUjC2/U74N+nDOksFTcT4bkn8vuFISzj93LGrZAm2bzRS9xSc2XfUVdaV3GfOU
	 y1Lo2RkIstgj8XKzREMjcvilgwoLhI7bXF4o85iJD+YIim+ANBRJDHevyriQCnVS5ppMK
	 FmSLz4akd0/vxZThebD4ZJwp4U5N5KCbMT5Mj71g7j0M3+Umt3kMEcfAMx4NBzeEMAZqC
	 JlcLIEqdxviTRJn1DS2wl76LsKte/t8rLQIS32v+Wm8q7dzN+yxHVJ7istWIoomp2cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PhcIcnDa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617D0606A332
	for <kvmarm@lists.linux.dev>; Sat, 21 Nov 2026 21:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PhcIcnDa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B1C1F000EF
	for <kvmarm@lists.linux.dev>; Sat, 21 Nov 2026 21:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294892;
	bh=v8vAHChTalJyPKJWjYAU8hJ9rNARiHKrkluyFMh0zh8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PhcIcnDahk93XHX6nhVEyhzqPt5GML6+Zl8sQA0Ax2ohQ+5IT8DChhIUmK2Pn8qZI
	 pL6vyZZfGf9NWndz/ufGc9Y1eByB3h8etOTfGTkfMSB14pW1UtngpOIf/rL3RurMv4
	 a3fppe2SppuOI0uPoRo1NIUjKgbuBrQFlp/nxdkIUd56noxL6pZIFEtO60X9maoWoW
	 73Hr4fogCGQaWM1fmV9oJJsbGa7Lyz62RAEXQH7L0uBL3cYCCAJvOvYkoQLcXZawdV
	 1pv/4CFES8fTRs0t/4hf4Zr9LAsfZZwq7PtHj8AXZ8qNoQa5KhmxDWzWoeiccEJiqf
	 58mjFX/aM/xwg==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be3ed646a5so2779175e87.1
        for <kvmarm@lists.linux.dev>; Sat, 21 Nov 2026 13:01:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF7B4jz55e5AhZr1od+xVYAcOHYh6qkqcsv6vhyugQ+Baj6GPT8u2t8zhCUYPz3y6e588SLTK8=@lists.linux.dev
X-Gm-Message-State: APuU4Z9WdHc7k/jAgIS7OzJjti8ebsJ1KVScvFupxV8V6Jj5Za5LIZ66
	2o4C5lfCooUQ9jv6iII+Kr+Ghj6x2rIf64EhXAmHqeRt07eZ29VRBjqNiiNUumPXZrJmmKYjsuR
	QV+/xjlnCacw/EHkdU/+fRL1cdWHk4YI=
X-Received: by 2002:a05:6512:31c3:b0:5c1:465b:ebe3 with SMTP id
 2adb3069b0e04-5c1bc7be4b6mr2356062e87.13.1795294890748; Sat, 21 Nov 2026
 13:01:30 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-2-ryan.roberts@arm.com> <CAD++jLkrWojU3FeTPGOCFHHsbmTGYG0Tz3b2nrn7mMfsDssCQw@mail.gmail.com>
In-Reply-To: <CAD++jLkrWojU3FeTPGOCFHHsbmTGYG0Tz3b2nrn7mMfsDssCQw@mail.gmail.com>
From: Linus Walleij <linusw@kernel.org>
Date: Sat, 21 Nov 2026 22:01:17 +0100
X-Gmail-Original-Message-ID: <CAD++jL=fnRBZJ-H8SMbZDr_1-F-aRbq6QRN_ZqaKw_M4cJFBOg@mail.gmail.com>
X-Gm-Features: Aa3M54rcr2uec6946c6ceFg_f82syIk8ikAg7SN-MP8cTPlIYobsjIq52BzG5Cw
Message-ID: <CAD++jL=fnRBZJ-H8SMbZDr_1-F-aRbq6QRN_ZqaKw_M4cJFBOg@mail.gmail.com>
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

On Fri, Nov 20, 2026 at 10:47=E2=80=AFAM Linus Walleij <linusw@kernel.org> =
wrote:
> On Thu, Oct 15, 2026 at 4:26=E2=80=AFPM Ryan Roberts <ryan.roberts@arm.co=
m> wrote:

> What the patch series needs to do is tell us how this topology is discove=
red.
> I.e. will it be discoverable from the hardware itself, or will this topol=
ogy be
> described in device tree or ACPI for example?

Hm what about I read the whole series before replying to individual pathes.
It's righ there in patch 4/15, mea culpa.

Yours,
Linus Walleij
