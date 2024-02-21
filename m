Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ECC811E7
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 20:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708547145; cv=none; b=ahz2KNqbhYaqakMCMt1PZNnNam5uCnfT733c8ker3SyiWX3eS2P89NvjLbSjsuPFBZhcIP8d5XZv+uLhCcpFmV/98JK0DDTDcuohMHOEXu57MmXw9bx9zb09cXRqVP8MbuvwTsUjUtQ0hC7OyW993QyO8phM1A3I/B1z9q/4x8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708547145; c=relaxed/simple;
	bh=ctqglnnCAjYhrU7DgoFcCYpe21K+LqH9msD+JxCEk8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G1fB5bGYpKLnQURZ9fqXLszzzd4WZpv2Z21mWVqfCELa/XF5Dd8X0BidG1y7OJk2Q3ezKzZOvEmVp+tTzjZyDAjWB8n6Vu52F1RCDhXSO/kg0ak+iwUpy5u1dwu43wMCsOwq4AQ+Rfgtoq9NX6AAkgUXBadVHq/c853RdhFLgCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a3zFvMYq; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3zFvMYq"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-dcc7cdb3a98so7347068276.2
        for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 12:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708547142; x=1709151942; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KUZZ04EW9/qUv3qL29C/Oq6T36PR4Q6EbgcYZzQ1nWg=;
        b=a3zFvMYqOBpK1XWgwhK8JtF8RmjR8/VtS7k+Uu/lyK0NXDsIioAT3D6TG7ndlEslLr
         jeZR1KrI5LVXG/KAB0VJM6vO5X/4CZ0jEKz81Q8IwMkzoF7R54LVEGYm6p4JatZF5MAy
         cySQglC1IWRwZZ+QgUqpXrGO7q3JXJyj4vLkQgwdu8XHW5ptdDfUBaSGhGvOqdr3Aqsl
         S9IlzTqhQOORSbIeQBiatoSa0+eQ+tky54sAoYpd1HIp0qgWKkkVQ5uBE2DEtmJyo4Dp
         IhJz5XlTCrzvy0tHbKK7TmMGt2GSw+1QcXt21wB1/qBY1busdkittl9vhdjOf6PmtKdB
         skCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708547142; x=1709151942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KUZZ04EW9/qUv3qL29C/Oq6T36PR4Q6EbgcYZzQ1nWg=;
        b=rDTLKTh5mnnmSMxlTpIPMoaZLah6zUchk27i6+NHI7+07yuk/LGW59KI5FSxZje6ma
         NDB8l6fP0RXU9uNxr00kI3b4l7EzWLAsSeqrtAAwqTNWsd0ElUjIaW4upy6LCFWfo7dS
         +uvBbeaIREkkgua+UeTYlYThWJkuLxb/qHAXpCP+yktQqino7dIANnV73ytN4mel2u0r
         0ZEhD3M0OovF58NAvRn4ujnCHXxN9IEtxt1gHo8a7CHp2HwiyQKtO0E/ZUYMeBdAVOcf
         Q0uKM/JtqsBNzqe5XhY/wnvP6/8RZvYIdJFyoVQfBlqhHv9/Wzui/ziE06HH/0vB9eTO
         Ys5g==
X-Forwarded-Encrypted: i=1; AJvYcCUk0RwpyGS9NMTSzgfYNPmxoaQ+i0M5l8f3MIL+d7tUh72GHSoHddElFLcJep6i67XZgL2qpdRNtH70KJ2Az2Vc8Gi1Zo2B
X-Gm-Message-State: AOJu0YxLKwNfwt1TzJiTN43N4x1egXoUDjkhqkO426iHnW79M8e7mJ04
	78DRvUidYnHhlwqoQa7hcg7Hl46AQuiVmbPrwQDEjX9XtraDLBoZgw9xV0OiJP4hoCFQmoTAQQi
	o14sThDgw7Oyc8I2LBBbwa4AtqgQ=
X-Google-Smtp-Source: AGHT+IHulW4fhdXYsgZSX5RqxAxS95jeQrXQWkLqG01c1LAdpuKIFalEI/fkzodUlC0P2/EUntFG0c+fYBgzVA4WA2w=
X-Received: by 2002:a25:1f8b:0:b0:dc7:46ef:8b9e with SMTP id
 f133-20020a251f8b000000b00dc746ef8b9emr389206ybf.29.1708547142617; Wed, 21
 Feb 2024 12:25:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220235415.GP4163@brightrain.aerifal.cx> <a57d6c7eada4b9a7c35addbc8556f5b53a0c3e6f.camel@intel.com>
 <20240221012736.GQ4163@brightrain.aerifal.cx> <d18f060d-37ac-48b1-9f67-a5c5db79b34e@sirena.org.uk>
 <20240221145800.GR4163@brightrain.aerifal.cx> <4a3809e8-61b2-4341-a868-292ba6e64e8a@sirena.org.uk>
 <20240221175717.GS4163@brightrain.aerifal.cx> <f4a54297767eb098d903404cbe8860d655d79bed.camel@intel.com>
 <20240221183055.GT4163@brightrain.aerifal.cx> <c3085fbe10193dfe59b25bc7da776e60779b0e8c.camel@intel.com>
 <20240221190639.GU4163@brightrain.aerifal.cx> <e3a432c0fa9f5fe837e9d2fc7b36304709a34428.camel@intel.com>
 <CAMe9rOoUO-D7Uoj9s3eq+w9pJBZ=iucEDpU4hqtJYtPmW5T4dQ@mail.gmail.com>
In-Reply-To: <CAMe9rOoUO-D7Uoj9s3eq+w9pJBZ=iucEDpU4hqtJYtPmW5T4dQ@mail.gmail.com>
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 21 Feb 2024 12:25:06 -0800
Message-ID: <CAMe9rOr1frpnKSnVQrqeiKK3aAR3xpG=VAiPYLOR9OpHnHhYUw@mail.gmail.com>
Subject: Re: [musl] Re: [PATCH v8 00/38] arm64/gcs: Provide support for GCS in userspace
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "dalias@libc.org" <dalias@libc.org>, 
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "Szabolcs.Nagy@arm.com" <Szabolcs.Nagy@arm.com>, 
	"musl@lists.openwall.com" <musl@lists.openwall.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "broonie@kernel.org" <broonie@kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"debug@rivosinc.com" <debug@rivosinc.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"shuah@kernel.org" <shuah@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "maz@kernel.org" <maz@kernel.org>, 
	"oleg@redhat.com" <oleg@redhat.com>, "fweimer@redhat.com" <fweimer@redhat.com>, 
	"keescook@chromium.org" <keescook@chromium.org>, "james.morse@arm.com" <james.morse@arm.com>, 
	"ebiederm@xmission.com" <ebiederm@xmission.com>, "will@kernel.org" <will@kernel.org>, 
	"brauner@kernel.org" <brauner@kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"thiago.bauermann@linaro.org" <thiago.bauermann@linaro.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "sorear@fastmail.com" <sorear@fastmail.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 12:18=E2=80=AFPM H.J. Lu <hjl.tools@gmail.com> wrot=
e:
>
> On Wed, Feb 21, 2024 at 11:22=E2=80=AFAM Edgecombe, Rick P
> <rick.p.edgecombe@intel.com> wrote:
> >
> > On Wed, 2024-02-21 at 14:06 -0500, dalias@libc.org wrote:
> > > Due to arbitrarily nestable signal frames, no, this does not suffice.
> > > An interrupted operation using the lock could be arbitrarily delayed,
> > > even never execute again, making any call to dlopen deadlock.
> >
> > Doh! Yep, it is not robust to this. The only thing that could be done
> > would be a timeout in dlopen(). Which would make the whole thing just
> > better than nothing.
> >
> > >
> > > >
> > >
> > > It's fine to turn RDSSP into an actual emulated read of the SSP, or
> > > at
> > > least an emulated load of zero so that uninitialized data is not left
> > > in the target register.
> >
> > We can't intercept RDSSP, but it becomes a NOP by default. (disclaimer
> > x86-only knowledge).
> >
> > >  If doing the latter, code working with the
> > > shadow stack just needs to be prepared for the possibility that it
> > > could be async-disabled, and check the return value.
> > >
> > > I have not looked at all the instructions that become #UD but I
> > > suspect they all have reasonable trivial ways to implement a
> > > "disabled" version of them that userspace can act upon reasonably.
> >
> > This would have to be thought through functionally and performance
> > wise. I'm not opposed if can come up with a fully fleshed out plan. How
> > serious are you in pursuing musl support, if we had something like
> > this?
> >
> > HJ, any thoughts on whether glibc would use this as well?
>
> Assuming that we are talking about permissive mode,  if kernel can
> suppress UD, we don't need to disable SHSTK.   Glibc can enable
> ARCH_SHSTK_SUPPRESS_UD instead.

Kernel must suppress all possible SHSTK UDs.

> > It is probably worth mentioning that from the security side (as Mark
> > mentioned there is always tension in the tradeoffs on these features),
> > permissive mode is seen by some as something that weakens security too
> > much. Apps could call dlopen() on a known unsupported DSO before doing
> > ROP. I don't know if you have any musl users with specific shadow stack
> > use cases to ask about this.
>
>
>
> --
> H.J.



--=20
H.J.
