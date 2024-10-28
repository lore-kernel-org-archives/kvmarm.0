Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3702746C
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730134112; cv=none; b=nAwOe/zlUTCeVxfhcptedqqcwyEn2kRB/6hOAR9aSA1l+/tYl6fSuXC5pTfEph/GrUjgO8+jLax1807fmXVBsVrggIoMmh0F9VKeZnr0ZdsyGXdPYO2h0mYvq+50RQjoD7BvHiGHwcFyOwI1JeAjmG+1DwIfFV9xrhJkDsqZC74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730134112; c=relaxed/simple;
	bh=Z81VI0WzpwNdvgio5+Kwvm0Y3L1Kjxh7fuMIetlvim0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=igjrq7FRY4ZpjNMADEmp3jKUxaiebU3T7DfUZS6Xr/cv41U+GebLXo37MyqfoDBWdN3qXG7bNH3Hqb/juPJ1+zBYvsqfILEy7YrDBYLDS8GpVqiyZ4ErxfWyvAdcj+rCUWvbDlUNeVHcA1QYCLrM5iInnWH3TOemaZsxF3DoOQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xFE9g/6c; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xFE9g/6c"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c9c28c1ecbso6167112a12.0
        for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 09:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730134109; x=1730738909; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KnUNLueAKjDgxYCEbUwQTT/VPUr4XHGzj00PvTOp+E=;
        b=xFE9g/6cLgCWA4yTds9JZulY7oNBOyBX3uqdrGWvIKOCWj5/8L4/kP0ZBYN/Ai35eu
         /srp5VQnYuTeeN3dey1CVy1fN7vL5EIvvHkVBpcpPTJazJ7sNv1QyXGi2oJvfgX3mWbe
         pEv78CCP1xBZG6QRCH/rkj1AZZgomQX7bN4PreNcEGTlKv/T318e3Kz3x3YJRMHvZgg9
         S/UkRfP2MghIS27YJuQ3K7fmAiY2YidQ3k+twP2Xv5RyvSzknAX7AWPZ0dR/MGaEteB3
         Q8j/WoWepp5xhg6/FD1jW9BMrtokUSKRM+12Dtl86E4HrymIze12v8X5JbC6WqOk12oM
         /0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730134109; x=1730738909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KnUNLueAKjDgxYCEbUwQTT/VPUr4XHGzj00PvTOp+E=;
        b=mabIvG4CFE4q+ao/X+vUKDS89xDlM2QOde5MyxlMbEMwb5oaRAghs/HHpzJWCOYUnZ
         UZDosuabH51g5lQDq7fl0+m1mgvqVGE/N62CJ9XUnWgvw6CDoNcf2HZSKoYJe1Nv+DXr
         rZGmgV/T0n8oIJ8q9gdW6/ugM59hX3aL+FIWn+mmaEE0sLJ3sjQueOrqOW14ig5RcJLv
         vBtl61MVVTSKrk/PF06asl9KWfaPiza4l8F/qhRhfVKQh83qZSCYDMKLfrMj0NB0w2/1
         xJZ1KZA9zEwYsPMgIUYWBpBxTCdwLRR+g0ASoT9xw2JVFybNLWvgLgDoFG3mUFqtJSQn
         nPgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFQsrvyy/4Z7whMmzPLGyXMthNsgMDGvIKbm7bwUdW5FhjhCuaGdPwABow6Eg3Y7eRH0oLtIs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzdiz/WiBgUfAaad/Fj/RhpS21QUhHtP76OEyhXLXvWRuhO8x2b
	IKT2QcVwSpBjJgYhwXSMJJAmH6whFRAtURUvrIh0toTa3FI0dv2vfTbGNNxsakyMjYfKRc2hY9w
	w3A6tiehLAxqMNcR/5egwVAAl33xv6lDzwUf33A==
X-Google-Smtp-Source: AGHT+IGfJV04ZqowAK9zEadNBVsMz49bjr9g5V5cwHxrCIWiztesrHX+uwsDooy37BW15MpUHvqKweovZtxtaKLQHXA=
X-Received: by 2002:a05:6402:26c9:b0:5cb:69be:db47 with SMTP id
 4fb4d7f45d1cf-5cbbf922bb5mr7338589a12.28.1730134108942; Mon, 28 Oct 2024
 09:48:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com> <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com> <Zxub7ol4p8P_sWF8@redhat.com>
 <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com> <Zx-9WxXkmkMuGIlQ@redhat.com>
In-Reply-To: <Zx-9WxXkmkMuGIlQ@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 28 Oct 2024 16:48:18 +0000
Message-ID: <CAFEAcA9w0mb5bcU8p+fScQony-=oqLmNurGWpnL_sBneQCzxUg@mail.gmail.com>
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, cohuck@redhat.com, 
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev, 
	richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org, 
	oliver.upton@linux.dev, sebott@redhat.com, 
	shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, abologna@redhat.com, 
	jdenemar@redhat.com, shahuang@redhat.com, mark.rutland@arm.com, 
	philmd@linaro.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Oct 2024 at 16:35, Daniel P. Berrang=C3=A9 <berrange@redhat.com>=
 wrote:
>
> On Mon, Oct 28, 2024 at 04:16:31PM +0000, Peter Maydell wrote:
> > On Fri, 25 Oct 2024 at 14:24, Daniel P. Berrang=C3=A9 <berrange@redhat.=
com> wrote:
> > > On Fri, Oct 25, 2024 at 03:18:25PM +0200, Eric Auger wrote:
> > > > On 10/25/24 15:06, Daniel P. Berrang=C3=A9 wrote:
> > > > > Also, is this naming convention really the same one that users
> > > > > will see when they look at /proc/cpuinfo to view features ? It
> > > > No it is not. I do agree that the custom cpu model is very low leve=
l. It
> > > > is very well suited to test all series turning ID regs as writable =
but
> > > > this would require an extra layer that adapts /proc/cpuinfo feature
> > > > level to this regid/field abstraction.
> > > >
> > > > In /cpu/proc you will see somethink like:
> > > >  Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics f=
php
> > > > asimdhp cpuid asimdrdm lrcpc dcpop asimddp
> > >
> > > Right, IMHO, this is the terminology that QEMU must use in user
> > > facing APIs.
> >
> > /proc/cpuinfo's naming is rather weird for historical
> > reasons (for instance there is only one FEAT_FP16 feature
> > but cpuinfo lists "fphp" and "asimdhp" separately).
>
> There's plenty of wierd history in x86 too. In this
> case I might suggest just picking one of the two
> common names, and ignoring the other.
>
> If we really wanted to, we could alias the 2nd name
> to the first, but its likely not worth the bother.

Or we could use the standard set of architectural
feature names, and not have the problem at all, and not
have to document what we mean by our nonstandard names.
(cpuinfo names do actually mostly line up with the
standard names, just not 100%. Similarly gcc/clang command
line options are mostly the architectural feature name.)

thanks
-- PMM
