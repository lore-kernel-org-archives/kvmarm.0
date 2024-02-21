Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773208062A
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 20:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708546755; cv=none; b=o5yr3SoJnt6AAeTIZYeJiFfxOBsXoq0lUOSOL0xdUdGLj73dSKtVV6kRLRIWjFnwcSX5PGSsV207Qf56i14wwxrheee4cqBZYKyYvr8ux77Ku4H4dnlsKG3vAsvSfBOLrKrDu4Rw8L7EENHpy2ElvPsLSId2tyLzRT8nQEQfxT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708546755; c=relaxed/simple;
	bh=3MLf9ApObXt/rf0vuQJhZzlgEUk2/WyJwumEOjHoveg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eV1CSKbp/X6NT02d019Wn0mssOuWvnl8Tc3TKSogdKOz0UjKnj/xYFVmcJY6bgboGfrCN+LLiV1uor9WtVKYm4XA+AYAaZxAOzHaiwEset9f2Na+f7OzZLy93IFBBrEACvlLgWWlhAS+PNY4aWv5/jTyY0Uykj6Kl0cjggHRaPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TYldiayE; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TYldiayE"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-dc6d24737d7so6420468276.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 12:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708546753; x=1709151553; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dC0/jGGGg/HFaRyL81RjL7rrIVZv2xHBQs/cZSwhbtU=;
        b=TYldiayEUnqqCuXfDsHTziuoKofSpLytAFhQwuVNDYug3rlTpN3OJrGtE9+yRWchsa
         nlTtE16VBbryacCjiA/Sci2QwIvv8uRGSY4+6DDI5bBP5wmZ5oDgerGczkuX8cz3xZe9
         3vNiyIJR8vIZS+NUzRXr4j7W1zfFfklAWHqXRolqpFy64FxTHh6VpE7c00egPaWsiMyi
         5DE4G8B+EJVfqoXEEaiOaxXQHkm3owra3sfkbuw99aL1XW3xPu/i3g6GCbmfkhN1FkQO
         WkW1D4idHkh9cl6rQLtO7jHc+pP3M9ksdU+VWxEF4x09xASwNfau8XUoYxUQmRCPGvus
         OuBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708546753; x=1709151553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dC0/jGGGg/HFaRyL81RjL7rrIVZv2xHBQs/cZSwhbtU=;
        b=sEunTEqof8VJ8w0R1QGFvIJtM24e3EePcGft/3oXH0QucMRN8WmgT+H9QH3bidjgzj
         /ghi58UlB/ufcktAM6Rm0QmJfqEk3sayVA24q5P1FNqliEpY8yZiOD7fb2Lk3t8oE/KV
         BFwbdNkK0VvMUIGnozDCgI4hDmMExI4ZAM5lzJNfGul9z6rzsRAJedeAUf9BeFhJqJNX
         ZFb/EubqQ6PTyCxBTzDkYl0Jp9p6e42mATVpEB5XEqqJWC5rxEGW+oZYOgpR/QqCMMrd
         sfOyld6BA9QQHmWjSgV4hY5h6MRGFgt7wtlDkOOnVKsLyHDRR887QdLLugo4KMkbkc51
         DMlA==
X-Forwarded-Encrypted: i=1; AJvYcCVVyXbkxMznhqa/PVbhahPSMPdqSeyuZWwj5J1dt3M7Kj+pqe6FR6RCs2TtNrhRI9s3bQp9I/fYJ9reswseVNrMakn5td7+
X-Gm-Message-State: AOJu0YzqxKslKcor/DuowW1W8nWEV/mt8NICRY/ZZvZktI65Qvt88XQy
	6Iq1hv8H0VzVUxg30Y4OWRuHcBIisKSgscl2/dV5s2y+625rVMJNXlByrl50KXqXHunPPVr3KR+
	0tr62ORHh2A8TmLqtoxYjWXcMorA=
X-Google-Smtp-Source: AGHT+IH3LQerluMYb9fAN1mFFrYm7uBDz1sUFvXpU3AHFaytahksdyc6iEy7q2HkrUujPZEoOh6XClpzAjLcebGmCEk=
X-Received: by 2002:a25:a543:0:b0:dc7:497e:cddf with SMTP id
 h61-20020a25a543000000b00dc7497ecddfmr380363ybi.33.1708546753425; Wed, 21 Feb
 2024 12:19:13 -0800 (PST)
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
In-Reply-To: <e3a432c0fa9f5fe837e9d2fc7b36304709a34428.camel@intel.com>
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 21 Feb 2024 12:18:37 -0800
Message-ID: <CAMe9rOoUO-D7Uoj9s3eq+w9pJBZ=iucEDpU4hqtJYtPmW5T4dQ@mail.gmail.com>
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

On Wed, Feb 21, 2024 at 11:22=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Wed, 2024-02-21 at 14:06 -0500, dalias@libc.org wrote:
> > Due to arbitrarily nestable signal frames, no, this does not suffice.
> > An interrupted operation using the lock could be arbitrarily delayed,
> > even never execute again, making any call to dlopen deadlock.
>
> Doh! Yep, it is not robust to this. The only thing that could be done
> would be a timeout in dlopen(). Which would make the whole thing just
> better than nothing.
>
> >
> > >
> >
> > It's fine to turn RDSSP into an actual emulated read of the SSP, or
> > at
> > least an emulated load of zero so that uninitialized data is not left
> > in the target register.
>
> We can't intercept RDSSP, but it becomes a NOP by default. (disclaimer
> x86-only knowledge).
>
> >  If doing the latter, code working with the
> > shadow stack just needs to be prepared for the possibility that it
> > could be async-disabled, and check the return value.
> >
> > I have not looked at all the instructions that become #UD but I
> > suspect they all have reasonable trivial ways to implement a
> > "disabled" version of them that userspace can act upon reasonably.
>
> This would have to be thought through functionally and performance
> wise. I'm not opposed if can come up with a fully fleshed out plan. How
> serious are you in pursuing musl support, if we had something like
> this?
>
> HJ, any thoughts on whether glibc would use this as well?

Assuming that we are talking about permissive mode,  if kernel can
suppress UD, we don't need to disable SHSTK.   Glibc can enable
ARCH_SHSTK_SUPPRESS_UD instead.

> It is probably worth mentioning that from the security side (as Mark
> mentioned there is always tension in the tradeoffs on these features),
> permissive mode is seen by some as something that weakens security too
> much. Apps could call dlopen() on a known unsupported DSO before doing
> ROP. I don't know if you have any musl users with specific shadow stack
> use cases to ask about this.



--=20
H.J.
