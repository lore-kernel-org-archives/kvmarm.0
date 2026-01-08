Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B105447DFBE
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881414; cv=pass; b=f/RWOmcHEaZV4LHIyaJIDvq0UtuwSR2JnIbYJ1+lEcaVGWqSIRVj+3fEgJFrOxdlWdF9mI0fMH1tjd4xie/6/stb0hpmWQSHDL7IrQ3iHKLJkeApPedr2qtlBh6ElykO460pyoKRl07eAIAdK4UlyM7Qc62TPqfP5P9jDj8OunE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881414; c=relaxed/simple;
	bh=YkKdPv86ApMrpTeTFnhz+IcSUQLsILOLPvJQz1PDFUE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j1tVOtfMy/apC0Qm+iuCeXOGyG7G9KeeJ7DZnxEXe5QBZCQ77HxaWxd1pn+EfCLoFdICiSzd/hPuh2s9I5r2SnTZ6d+Erxrs4LWmHfFI0C7sz39CN2+qVKic+R8L2uh/CY3Iq53+iYIEqKuUZGK1CECn6BEVMg8uBf45t9NIN8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vQ6QTJCK; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vQ6QTJCK"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4edb8d6e98aso1158111cf.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Jan 2026 06:10:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767881411; cv=none;
        d=google.com; s=arc-20240605;
        b=R/IQs8c/csyIvX+d5YsP/X4PTwuLdNnY/+hAujma7gto2kWoTSOPMxslBlFgbXUZWK
         BemjX4FuJ4S5UndcCnY6UPVwaaBtVHJR20V7wUj32dYrYXSlVtOfNEjlDRFe61YO4lg6
         hQhGP2Xw1ub6Tedl5/rjfHgh5iNZxm0o9A5Oel6tH3Xfz4cPar//wvPo0Pehg1Oi3SsY
         3274nECqLoiMHoJI9CNcR5exc082pz0tukp4P7kZWDul9N0+r9X9HhbPDEQ/w3v1kG6G
         lbq3aPlyw693lOZM6JhJzxe7VCJGOHfTFfRYZpzDiYj7n0lDHiQTsxJCuayjLz3D8Sgj
         g9oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TGOhyPqsKhZPttb5gff3fg7ZFzXcVrSNwuwgJbbCpXM=;
        fh=Xp4NJihs4z3/r94d+6IVupDVYvJrHMj0aUS+w2XCtg0=;
        b=KP+2q/0jvwlqgsYLVq3ZePU0svvXk+WpCGZnYCEh9G/8pAbdSU8qRg2jNhckGGkBtj
         QZsxNhuwjh1uuIos1wuto/xp+OhY5q0ZNEqhu1aaltZGgFxt4mO03TqUBJ9ory/uN3lI
         35+5HznvcVFJDQ9Jwsd3H0I4c2iCjrjod457UK9mF5ElxDYVrf3q9CDDvoInpFBY1Rw9
         FKHJ0UdIHihwlO64h2mP+h9E5kJmq9VdTQQ7djKA/Z6ofAQ/Eym53K02FyqP1NPrnzAM
         JWmRvzkd4+DJhYoC9txSw1OwNHBBYUWZOFJxLJl1LvhGYdye7iAWLqjFnlVMdzNrVevr
         zLFg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767881411; x=1768486211; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TGOhyPqsKhZPttb5gff3fg7ZFzXcVrSNwuwgJbbCpXM=;
        b=vQ6QTJCK/lbUKRl88k2B+YSJdqIga4Fdc5QCHqedUy+ak76Cd0gbg/+81KT1zDhJFW
         ig5FQlPt50BOnzZ7UFEq8POfBzV89/o7bldPcMwJCpTe8UyjUo29W2RQbilu+HeiRtck
         k2nO5TE8TJUMJwuA6C+m/GL+bwTZOoIh+OBsdQtQH+Plkc/XWSd2TcyKcA724opvIuuH
         L4ACGw+h7U6IjgUEdiB2zKR3FrA1ClAGlp0yULI9arGJdN9591kWE8r7uwz2QEoYPijy
         6fg6CqSo7mVFR/ES/31RNwMJhRaIX5+LcWQrWWOPzMGq66Ladjb05Q+V6SOUqGw9lFSG
         V/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881411; x=1768486211;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGOhyPqsKhZPttb5gff3fg7ZFzXcVrSNwuwgJbbCpXM=;
        b=Mal7gf0iU6BSo6vT5ZWv+yTwCK041/gmA0mMEY5eXwYtbPeukBFPWrl7MwhSEi4iNk
         BCXkr2EZbuOqrUsHPpYM8p25WOpssIaXCC7SvXPhZAPNqHUha1zv+3zfwXKMSZhztUsa
         LQGoXRPYU5WV8JWB9mcznYJD81RzU5KFTX7fNsgRJDyX1+hnLi3jmBxyhkCy/tSLgari
         021Gawgz+h8dvk4yqbK9vMpnIH4nT0oDwASrjO/RYdovR/FQjSJEnBC3FdIGUHtN4lxU
         24DcJ+1mbqYqZUNV/XgMxWz0/Fkgib5pdAL0y1Ku1sVQroSGJOIbX4I8xt2w1l62Q4R+
         yfvA==
X-Forwarded-Encrypted: i=1; AJvYcCWvi07/RpO3Dp35uTloXpzofipZ2U81CUF3Kh6NUFVCs/U4uPZWWH0QF592rwcGba/Wzj6LctU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPN5bde3o0spnNRWXeT2ObFLfIP3n+myge56lYxOWbdeobY5bU
	HX4YiqHdUGd9lG/mmd6W910Ywf8qpPhC+EFtL2f/8MniXU4mMoTFkLi3G+b/gm1EkEiEeL+88lT
	JfopOJ55+dMPzsuwY3hLutRz0knMLwTX2sePQGucj
X-Gm-Gg: AY/fxX5iLdZ1pj0l9e9Xz07VVegXDAX3DFkO9jOp45xgpXWfdWam3bPZg3phKFo1EqF
	om6hl9OcRqNubPlS/UuyDrLIdsWA06JKD6YSr6EZ+eH+s/e7fBEZEX3e5YwE+BpalhqvGUY62fo
	+PYKNs/JbP7uAQuVIn56SkWjr9V4CGF3wvnZhCV4CJ0gYzujPlsvCDg0cOWcai6Woz7PT8ETZre
	O0Jr2asZ2/DFiMxQLhva0tY33QbOUm7Zcv1eKZ0vGTExZrEqQP9vOto/75WxfyUJwWBnubs
X-Received: by 2002:ac8:7d45:0:b0:4f3:7b37:81b with SMTP id
 d75a77b69052e-4ffc0a80347mr7952831cf.18.1767881411175; Thu, 08 Jan 2026
 06:10:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-2-8be3867cb883@kernel.org> <CA+EHjTxdSnpFHkm6o85EtjQjAWemBfcv9Oq6omWyrrMdkOuuVA@mail.gmail.com>
 <3c8b4a5e-89f4-47e0-9a5d-24399407db0c@sirena.org.uk>
In-Reply-To: <3c8b4a5e-89f4-47e0-9a5d-24399407db0c@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 14:09:34 +0000
X-Gm-Features: AQt7F2rujxIGY5_NcyYbFMLNUJyJwV68zqszeu4LHx3dTWaBmmJ-A6j-sa3_670
Message-ID: <CA+EHjTxLkLjPj=1vwDqROXOUXi2LhOQb90WP6dFaTiYG1nWovA@mail.gmail.com>
Subject: Re: [PATCH v9 02/30] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 Jan 2026 at 11:54, Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Jan 07, 2026 at 07:25:04PM +0000, Fuad Tabba wrote:
> > On Tue, 23 Dec 2025 at 01:21, Mark Brown <broonie@kernel.org> wrote:
>
> > > +#define sme_cond_update_smcr(vl, fa64, zt0, reg)               \
> > > +       do {                                                    \
> > > +               u64 __old = read_sysreg_s((reg));               \
> > > +               u64 __new = vl;                                 \
> > > +               if (fa64)                       \
> > > +                       __new |= SMCR_ELx_FA64;                 \
> > > +               if (zt0)                                        \
> > > +                       __new |= SMCR_ELx_EZT0;                 \
> > > +               if (__old != __new)                             \
> > > +                       write_sysreg_s(__new, (reg));           \
> > > +       } while (0)
> > > +
>
> > Should we cap the VL based on SMCR_ELx_LEN_MASK (as we do in
> > sve_cond_update_zcr_vq())?
>
> Yes, although I fear if we've got to the point where we've ever got a
> bigger value going in we're going to have bigger problems.

Yeah, but I think that we should be consistent with the SVE case, at
the very least, not to confuse the next person (e.g., future me) who
might look at the two and wonder why they are different.

> > Should we also preserve the remaining old bits from SMCR_EL1, i.e.,
> > copy over the bits that aren't
> > SMCR_ELx_LEN_MASK|SMCR_ELx_FA64|SMCR_ELx_EZT0? For now they are RES0,
> > but that could change.
>
> My thinking here is that any new bits are almost certainly going to need
> explicit support (like with the addition of ZT0) and that copying them
> forward without understanding is more likely to lead to a bug like
> exposing state we didn't mean to than clearing them will.

I understand the 'secure by default' intent for enable bits, but I'm
concerned that this implementation changes the current behavior of the
host kernel, which isn't mentioned in the commit message. Previously,
both the feature enablement code (cpu_enable_fa64) and the vector
length setting code (sme_set_vq/write_vl) performed a RMW, preserving
existing bits in SMCR_EL1. This new macro zeroes out any bits not
explicitly tracked here.

In terms of copying them over, if they were set from the beginning,
doesn't that mean that that explicit support was already added?

Cheers,
/fuad
