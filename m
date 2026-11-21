Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795304699;
	b=Xu3rBhW4i15Tap2GwzvmNPgGwMVJ3qNA3uR3ZTUODZYagvXjN/C0QwJWWDeaGlkrcsyw
	 nvkdcPROpwnorNvL6qg2zP65ae0N8Z3slIdOZ/qy+Uu93cqfYtGiQb/wnjBtOmmdSHPuS
	 SJPFnfn7QxkoxQ03nwuos4rg24RIT1T5+jwU8hvY62KTL8Ldxn4/Jv8WYTyjx6uh1BBrz
	 UkUEV7npatSh3Gki6s90K+ctgjqi1IB0yYoyMwv8OrxKupmcpiNvGN233NL37gwprrh+8
	 q396yTvAjpd3yx1+TrgcvUlZb/TsqrULOqrUenZ+DKDrZfAjzHyJagxEAPyXgPpydmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795304699;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2AGBcOOzRTC6ShorOU+9bsy9QDvjQLHzXkUKhS0WtwU=;
	b=g7blskatsX3gNDOHTN0ZwpnAwhzZlSN1HwEp8113YknIGQSvb7fFTCBkxO2+nD1Dl4JW
	 4OVPHASC1zS+U7pe7+5p9TlXO3iju+5rFcmO5MZNeqOtr6aoF93yuJi34wVoY1KUxTFbV
	 JeJvkPajzeAEN98N2Y9r2EA+ahi6Q/E3yzeQed58Van2WW1e5IGhst/1VkZkcTuLlZUSx
	 DEuqVRiRkmFhKks2LC1FeEiYPhF314UckvHyGKPFucEebWEC5Lr3YC9mgdaYUq077v01f
	 JiA8IMrau2Ns7fXAJfnMOhZzYEf0qu1bxSEi+yM36bla1E+16eooIHAGJaCdnV+pIiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iqtuu1Nn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44378606A339
	for <kvmarm@lists.linux.dev>; Sat, 21 Nov 2026 23:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iqtuu1Nn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219461F000C0
	for <kvmarm@lists.linux.dev>; Sat, 21 Nov 2026 23:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795304699;
	bh=2AGBcOOzRTC6ShorOU+9bsy9QDvjQLHzXkUKhS0WtwU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iqtuu1NnbUiqzwMauYGYsPPooUnz9J2f60EhLdDnPjEflAyC2Yum4V54XR555sZu0
	 fqO95LJiKHzt/+Y9O5fyZekFNyVMFITbrJu2z5OusT+5LePqvOorS4MrzMODtIJRCL
	 SWwmBUrlmuKzlC0kfFwwR3mjF45xR7L+VJ2oKJQULvJ7i/kfjJyL3MYNEBFfaT9q2r
	 5rTWtPkR2Y54LGRr5CZKfs12A86UmYwYkkxmrsMpPfjcBFcTfsAJY4e16oWibEHM97
	 g8Z+5wWYbhCQYblhWCj+kEaTo989BTBU+MgMecSXLZMTLL/mimMTAbMrGSD3BdeaP9
	 h7lbp6pnZrUFQ==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5c08539c827so1341683e87.2
        for <kvmarm@lists.linux.dev>; Sat, 21 Nov 2026 15:44:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFSN+y+2kU8PRvZxH7CH2e5FptznNdaXNORDFzs50a8srl4EF2cdNHtgCl+K/whPoyGVVVBhMU=@lists.linux.dev
X-Gm-Message-State: APuU4Z907sbc6Tcx5QkS0kD7BNaNB6teboknbAW80jZ/oZu7gZwmoeng
	iBvF523szk8mL8wVVPCok0iGXf04JT2OFLgcASdJj5Avbtse1aqSwYWUtilVSX8CgxvhUXEi2ge
	f6UpXk++YbkUVXMq5gOnusSmwm0ftsGc=
X-Received: by 2002:a05:6512:10c7:b0:5c1:5bc7:83c with SMTP id
 2adb3069b0e04-5c1bc89c62amr1919255e87.53.1795304697899; Sat, 21 Nov 2026
 15:44:57 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261015142552.4128028-1-ryan.roberts@arm.com> <20261015142552.4128028-4-ryan.roberts@arm.com>
In-Reply-To: <20261015142552.4128028-4-ryan.roberts@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Sun, 22 Nov 2026 00:44:44 +0100
X-Gmail-Original-Message-ID: <CAD++jLkpUfxjH-6x6CNfZ-vmNBpZjKA_QJi14C3MvLjvH5GDCg@mail.gmail.com>
X-Gm-Features: Aa3M54qEBsIHfq6xlw1QgwR1kLjUf8oKtfnIKMoqH8Z1sFQILc0FmuvWNVJA2Qg
Message-ID: <CAD++jLkpUfxjH-6x6CNfZ-vmNBpZjKA_QJi14C3MvLjvH5GDCg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/15] dt-bindings: misc: Add Arm Core Local Accelerator
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

Hi Ryan,

thanks for your patch!

The following review comments are based on my limited understanding
of device tree, the actual maintainers should have the final word
and need to look at it too.

On Thu, Oct 15, 2026 at 4:26=E2=80=AFPM Ryan Roberts <ryan.roberts@arm.com>=
 wrote:

> Arm Core Local Accelerator (CLA) provides a CPU-local interface to
> accelerators that access memory through the local CPU's MMU. CLAs whose
> accelerators cannot be isolated from each other form an isolation
> domain.
>
> Add a binding for arm,cla describing the register range, CPU
> association, DMA coherency and isolation domain. Document the
> privilege-level register frames, including reduced ranges exposed to
> virtual machines, and provide an example of two CLAs sharing a domain.
>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

>  .../devicetree/bindings/misc/arm,cla.yaml     | 77 +++++++++++++++++++

No matter where the driver goes, this binding should (IMO)
be in

Documentation/devicetree/bindings/arm/arm,core-local-accelerator.yaml

> +properties:
> +  compatible:
> +    const: arm,cla

I would spell it out arm,core-local-accelerator but others may like
the terse acronym. I just think it's too short to be unique and
find Documentation | grep core is good to match for one.

> +  reg:
> +    maxItems: 1
> +    description:
> +      A single contiguous register range starting at the PL0 frame, alig=
ned to
> +      256 KiB. Each privilege-level frame occupies 64 KiB, with PL0, PL1=
, PL2
> +      and PL3 at offsets 0, 0x10000, 0x20000 and 0x30000 respectively.

So these registers only exist on each node (mention that here), is this add=
ress
in the *physical memory* address of *that* CPU or of the entire system
or what is it?

I'm just confused so looking for this to be explained here.

My guesswork is that each CPU has a slice of the physical memory
in this reg, and that slice is then only visible from that one CPU.
If it's like that, spell it out.

> +  cpu:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the CPU for which this CLA is local. Only that CPU can =
access
> +      the CLA's registers.

If this thing/address is local to the CPU, shouldn't this just be subnode
inside of the CPU device tree node itself? I'm not sure so I'm asking.

> +  dma-coherent: true

Yeah, I guess ... on THAT CPU then?

I think this property is "as seen from the CPU", and assumes all CPUs
and IIUC the other CPUs cannot even see it so that doesn't sound very
coherent.

I'm just confused by this property being present here, but it's
true, in a way, I guess? Do you have to specify it?

> +  arm,domain:

Domain is a bit generic don't you think? We have power domains
and clock domains already.

At least use arm,cla-domain?

> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Identifier of the CLA isolation domain. CLAs whose attached accele=
rators
> +      cannot be isolated from each other, for example because they share=
 an
> +      inter-accelerator communication bus, must have the same domain ID.
> +      Different isolation domains must have different IDs. IDs need not =
be
> +      consecutive. A CLA that can be isolated from all other CLAs has it=
s own
> +      domain ID.

This doesn't explain what it means to isolate a domain, what
isolation even means in this context.

I know about isolating network interfaces for example: it means
to physically decouple it.

So express what "isolation" means here.

> +examples:
> +  - |
> +    /* Two CPU-local CLAs in the same isolation domain. */
> +    cla@10000000 {
> +        compatible =3D "arm,cla";
> +        reg =3D <0x10000000 0x40000>;
> +        cpu =3D <&cpu0>;
> +        dma-coherent;
> +        arm,domain =3D <0>;
> +    };
> +
> +    cla@10040000 {
> +        compatible =3D "arm,cla";
> +        reg =3D <0x10040000 0x40000>;
> +        cpu =3D <&cpu1>;
> +        dma-coherent;
> +        arm,domain =3D <0>;
> +    };

This example makes it look like these CLAs are all uniquely
mapped into the (shared) physical address space. Is it so?

Yours,
Linus Walleij
