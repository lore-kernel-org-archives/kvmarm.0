Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574B586AF8
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 21:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708550007; cv=none; b=Zeeo57QZ1aY3l/aYDKKH72MZhUAJdiUv+/wAX10kXmn21WYK8xIv8c+P13cso9z3p8iYQRV+4fdiJpRoMGOX2bB9pcYx8y41hvRKa0ONyqka43BmrY4Z7U1s3r4obtdF99E0c4fbYNBr09YSM5SRv082kWXn05QtokcNDLLLVqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708550007; c=relaxed/simple;
	bh=VOXFL6Fr7ubdKKttigCoBGrhHgzzc2o+UtL3EmWAn2c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qVnI+8usH6SNx9CfwEmayj9/PMRpPgWOryAAnHh19JfmgK8zReY1H4plyXfUCvaiWZS+6IDjDzLIz2tTfpq713P2WY3kbnU7rhhJTbnCotG6hW8kj79YHYkmZN7SF+Jp8lJ80XNYu5oeXe5bjGmLJWHNY4QYn51jMZBBpl7ej4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NuPrQkDB; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NuPrQkDB"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5ce9555d42eso827454a12.2
        for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 13:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708550005; x=1709154805; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOe8CQ1Fe+hIMHxzKX7XWlTimkc/iuaovpymvDphgj4=;
        b=NuPrQkDBrzRRnp46Se33/9wFqmCzGqaq2BIrIgTTDcCWX8jzXd0YRX3am7rAFtyAeL
         sK9xE0iGsGoV4oAXqVXLXuWxWOFQZ+0qPsnQP6MrhGFBzcXJYLAgQ5YohUXVakHpDkXU
         a5IAbXTErIylsgXgpqq43s+iikv2lsqDCkVV+T7F4HKDG9pAr33sQP5a4LgZ1dJNeK5l
         Ol9SUIbi4qZZfcS7l8YayUvScY8cjCB7ZoAkAh27rU6AG/r5MA2VnqMm5+URO6Z6i4zG
         DJqapwXTTaapKt+Gz+fDzcBK10kuTNzGdD9n9VFw7YbvOWu69y7fO6kO5NJ++1CR4wt8
         bP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708550005; x=1709154805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOe8CQ1Fe+hIMHxzKX7XWlTimkc/iuaovpymvDphgj4=;
        b=dhXtMjtJhig7scv3Hk62bjGC2WNhNu3HMWTJfioH5Ulfq2eE0eevmpKuWzwRqOD3LP
         s32TAxt4rrmzGIAquPmUg1fxZJK28Mmqn+lTz9y1edBvOX4T25HTb4h4zQ8djxX7/xlw
         7BukwWwitjTHYFjDW+MgQ0vdhJE36crFnfhq3X+eXWPnO85YH3mH0rdCrh6tdILxJG3T
         yq5zuLMaL0hKgrAPMFVmbHWCAxvxODVTRERRt2W9gjZT52GcVNU3a9Dq+YqD4gV3iIJR
         nhu5DMTj9LeTmFV20Uh4isVCw4iU7TNZ7dKcAr5v7rtDQ2T0XWaDyO8oX50kiaUGpvWN
         BRsQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+BGF/b34a2DDvGH+ObCg3yU+Lh4ON5NMSA6gbd/P657KTowWUimhDps8CfTaogFJV7Iq2ae9/VMu6b4gK/qODVra8MPEB
X-Gm-Message-State: AOJu0YxIqTmytLYMK57RwtBy93X3Q/kWBvCIigYh440Fe3gi6hcNPlmC
	RXx7zBhqc3w0ykNiBH0T7Jw8jLhm8eBilQZJIoZVJWHc6oIC704/F2v0N4TinPej0UFnli+wuEZ
	U6JLogPaCAgK00cdDX6XR2zlVkiM=
X-Google-Smtp-Source: AGHT+IGhaBTSHgXe8Ob108OXBWpnIgIuyMFeVcBje1ELrXkN/4PqTmNclSgXiBJchbcFk4tPPGc/HanP+MFeXILDTxM=
X-Received: by 2002:a17:90a:d911:b0:299:e9d1:fc52 with SMTP id
 c17-20020a17090ad91100b00299e9d1fc52mr6242900pjv.0.1708550004870; Wed, 21 Feb
 2024 13:13:24 -0800 (PST)
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
 <CAMe9rOoUO-D7Uoj9s3eq+w9pJBZ=iucEDpU4hqtJYtPmW5T4dQ@mail.gmail.com> <CAMe9rOr1frpnKSnVQrqeiKK3aAR3xpG=VAiPYLOR9OpHnHhYUw@mail.gmail.com>
In-Reply-To: <CAMe9rOr1frpnKSnVQrqeiKK3aAR3xpG=VAiPYLOR9OpHnHhYUw@mail.gmail.com>
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 21 Feb 2024 13:12:47 -0800
Message-ID: <CAMe9rOoo55aFHHuLf=zdc4PNvU+Tu9rtpWaMUdRL=JtHGbE3pA@mail.gmail.com>
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

On Wed, Feb 21, 2024 at 12:25=E2=80=AFPM H.J. Lu <hjl.tools@gmail.com> wrot=
e:
>
> On Wed, Feb 21, 2024 at 12:18=E2=80=AFPM H.J. Lu <hjl.tools@gmail.com> wr=
ote:
> >
> > On Wed, Feb 21, 2024 at 11:22=E2=80=AFAM Edgecombe, Rick P
> > <rick.p.edgecombe@intel.com> wrote:
> > >
> > > On Wed, 2024-02-21 at 14:06 -0500, dalias@libc.org wrote:
> > > > Due to arbitrarily nestable signal frames, no, this does not suffic=
e.
> > > > An interrupted operation using the lock could be arbitrarily delaye=
d,
> > > > even never execute again, making any call to dlopen deadlock.
> > >
> > > Doh! Yep, it is not robust to this. The only thing that could be done
> > > would be a timeout in dlopen(). Which would make the whole thing just
> > > better than nothing.
> > >
> > > >
> > > > >
> > > >
> > > > It's fine to turn RDSSP into an actual emulated read of the SSP, or
> > > > at
> > > > least an emulated load of zero so that uninitialized data is not le=
ft
> > > > in the target register.
> > >
> > > We can't intercept RDSSP, but it becomes a NOP by default. (disclaime=
r
> > > x86-only knowledge).
> > >
> > > >  If doing the latter, code working with the
> > > > shadow stack just needs to be prepared for the possibility that it
> > > > could be async-disabled, and check the return value.
> > > >
> > > > I have not looked at all the instructions that become #UD but I
> > > > suspect they all have reasonable trivial ways to implement a
> > > > "disabled" version of them that userspace can act upon reasonably.
> > >
> > > This would have to be thought through functionally and performance
> > > wise. I'm not opposed if can come up with a fully fleshed out plan. H=
ow
> > > serious are you in pursuing musl support, if we had something like
> > > this?
> > >
> > > HJ, any thoughts on whether glibc would use this as well?
> >
> > Assuming that we are talking about permissive mode,  if kernel can
> > suppress UD, we don't need to disable SHSTK.   Glibc can enable
> > ARCH_SHSTK_SUPPRESS_UD instead.
>
> Kernel must suppress all possible SHSTK UDs.

If SHSTK is disabled by kernel, not by glibc,  there can be 2 issues:

1.  Glibc and kernel may be out of sync on SHSTK.
2.  When kernel disables SHSTK, glibc may be in the middle of reading
shadow stack in longjmp, searching for a restore token.

> > > It is probably worth mentioning that from the security side (as Mark
> > > mentioned there is always tension in the tradeoffs on these features)=
,
> > > permissive mode is seen by some as something that weakens security to=
o
> > > much. Apps could call dlopen() on a known unsupported DSO before doin=
g
> > > ROP. I don't know if you have any musl users with specific shadow sta=
ck
> > > use cases to ask about this.
> >
> >
> >
> > --
> > H.J.
>
>
>
> --
> H.J.



--=20
H.J.
