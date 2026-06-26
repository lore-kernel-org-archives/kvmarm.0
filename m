Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23CD3D3309
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782458482; cv=none; b=MLGmE0BDsFGi5HIp76sa0TlvJbV8ez1rhT1ihaUm1Lfea03feDwLobrjHky9EDuZ4UxNLtFam5iZsVYRZV0sx7qYXFGhVDIiA9P9phhbBuu9T2hR2slcJ/msewkrpcQKhtSaKkFHbz0DilZgg2Ql9zjrz7RccBDUMxfw3IemGxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782458482; c=relaxed/simple;
	bh=6sUAbrJ6+DNOruCegcBURN5O265h55W3C0STcbA2OOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XGSQvenvjF+mWjGsZDuNGpxzZr9O9YEoiqq880oW4HTsyK4QUCSBU8sWz8U3zcq4RmW/dJ61a1DxMSjzXGBeRqGNs7PG/99UbIcQoXpoynKAzrtHVasXV8+00Sk3mY9WU7d1Xxw7V5/K99ae9l96/5leaIobPI8npR9twBjCs18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I9+JwtxM; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I9+JwtxM"
X-Forwarded-Encrypted: i=1; AFNElJ+tKKOQMBRz0qrWioAe3ePKaqU1emTBXrBHz0gLNVk1PZnDKAFH5GDWfz4e+4RI6BnwYod/cwE=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782458478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06RfsAPeF75V3GyQq/gAG+GhRSXqNlvvFXiIJK2+9mA=;
	b=I9+JwtxMVd2aAYPnG3T4Kd0sPnBY2xhdFjvenOTA8iCL1jbhMLeKQ+WsKUwaL0XvVLDWFB
	OZ7ROYx11qTMFLN8lXzBiRwdUgI5i4ld7I8BleJIhOIYQeI9CZXhACWM3GcqTWsLzmsxjc
	8WHdKT8QpdWn3DUOMqwcZwio8lPRGME=
X-Gm-Message-State: AOJu0YyYxwf3tNutE7gKNSrAgUUlk/+hHdXMIxdvdBXaq/gsZiXj3ccf
	ejGspO9as0d326+8DITVLCLj1VI8lo4uYXqb6kf0ga57aGkNPUIfIJ8ScaLb0HVu5ZQS6Z0tNe0
	yuPdE53NAT82bKpC/hlPSJ9TTyOH5TltDCvkHu+Tb
X-Received: by 2002:a05:622a:e:b0:50e:38f0:ccb2 with SMTP id
 d75a77b69052e-51a7d895631mr7659891cf.15.1782458475550; Fri, 26 Jun 2026
 00:21:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260626070408.3420953-1-fuad.tabba@linux.dev>
 <20260626070408.3420953-5-fuad.tabba@linux.dev> <20260626071642.C7C821F000E9@smtp.kernel.org>
In-Reply-To: <20260626071642.C7C821F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 26 Jun 2026 08:20:38 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzLQR6VDS1xnnEb01LRtxaMpyOTMsC0be=Hw2nxCKcqcQ@mail.gmail.com>
X-Gm-Features: AVVi8Ce9wHDY6_er74vI_sJRY75xwMGhJQVVrZDuuVHYTvrj4IXxgi1Seyjikrk
Message-ID: <CA+EHjTzLQR6VDS1xnnEb01LRtxaMpyOTMsC0be=Hw2nxCKcqcQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] KVM: arm64: Move PSCI helper functions to a shared header
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Fri, 26 Jun 2026 at 08:16, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Low] The newly shared header `include/kvm/arm_psci.h` references funct=
ions without including their defining headers (`<asm/kvm_emulate.h>` and `<=
linux/wordpart.h>`), violating the practice of self-contained headers.
> --
>
> commit 6015f90f953617e9e81e02b97f5532daaa5dfdd7
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Move PSCI helper functions to a shared header
>
> This commit moves kvm_psci_valid_affinity(), kvm_psci_narrow_to_32bit(),
> and psci_affinity_mask() from psci.c to the shared include/kvm/arm_psci.h
> header. This prepares the helpers for use in protected-guest PSCI calls
> at EL2.

We've been throught this before my friend [1]

The header was already not self-contained before this commit: the
pre-existing kvm_psci_version() uses vcpu_has_feature() from
asm/kvm_emulate.h without including it. Every .c file that includes
arm_psci.h already includes kvm_emulate.h. The other dependencies
(lower_32_bits, MPIDR_HWID_BITMASK) are transitively available through
linux/kvm_host.h.

Cheers,
/fuad

[1] https://lore.kernel.org/all/CA+EHjTwpB2fmoYGfkP5RVZcB4sgbVPQ0=3DQR5dyUJ=
npQ_VQa+pA@mail.gmail.com/

>
> > diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> > index cbaec804eb839..f86a006d67136 100644
> > --- a/include/kvm/arm_psci.h
> > +++ b/include/kvm/arm_psci.h
> [ ... ]
> > +/* Narrow the PSCI register arguments (r1 to r3) to 32 bits. */
> > +static inline void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
> > +{
> > +     int i;
> > +
> > +     /*
> > +      * Zero the input registers' upper 32 bits. They will be fully
> > +      * zeroed on exit, so we're fine changing them in place.
> > +      */
> > +     for (i =3D 1; i < 4; i++)
> > +             vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)=
));
> > +}
>
> [Severity: Low]
> Does this new shared header need to include asm/kvm_emulate.h and
> linux/wordpart.h to remain self-contained?
>
> This inline function relies on lower_32_bits(), vcpu_get_reg(), and
> vcpu_set_reg(), but the definitions are not directly included here.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626070408.34=
20953-1-fuad.tabba@linux.dev?part=3D4
