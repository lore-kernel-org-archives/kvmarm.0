Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E619917BD3
	for <kvmarm@lists.linux.dev>; Sat,  2 Mar 2024 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709391988; cv=none; b=JC+CEFyCc0PdEc61Dtc5nf4v37kHOdpGcP6qBrpTyvflbDQUR56o/uoT1XWimy9+fgk06kzVyfWLfUjHQYvw4a8bcWBog9ZKaXrVf+qhNZQzryqHez3EKH/eBmQ0756Sjc4lAVXlL/l6aS9a9t4y+wGBPbNRbRACvU85a2e7b4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709391988; c=relaxed/simple;
	bh=VezVKG3MnNCr2RdjBJy6ykskbpHlP5qoXhAnVh336Us=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=PWIISJArhisgoc2SA/Dy4e3JgLVV+J6eMuPFCFpS2BzmuP1xYb+7wdlKOSyj3K94gGEixiQePzLLF6N5s/w00vZkM2PoBGW1Ll76qNk5qR649nW0dBxQicF/vzJRRfSRrSrRbQTCFzbU0BzjVWJUIjiV4/EnrLXrpvy+9FZs+/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W9qthlDn; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W9qthlDn"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-60978e6f9a3so27174807b3.3
        for <kvmarm@lists.linux.dev>; Sat, 02 Mar 2024 07:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709391986; x=1709996786; darn=lists.linux.dev;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qrSAlaPh6y0XeZbwLQygm09FiBVmDsRwj6kIPbpO+ac=;
        b=W9qthlDnaXWQ1NI94Vub3M3G1M7jF2rC10BQPt8n/92vt283+cIHyeaWROetmONbRe
         hEvBZdxjSO9PtEJY10TkRkgySMadse8Hu4Gqkd6so4fvCf+mVfoWoHEjd414bDETLqDo
         ntLyaCJn1UoS0iSSA6YxOEeUMEWrgU7D3iznNzQgZzjVF4WFOgT1VbGzWPS7L3SQQ6Gc
         6rXjT11a3caax7nXNtfR4+WCP+tUMzJF2Crxv2TuyZRhM1v43o3PZT5U53Z5KuT/ZgLT
         weF0lKKdgiqd/SDhB99PQneAWNRluA3THq92aBG9sDAWx2PUOTY9f4qaIp+f5IZwquwr
         PvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709391986; x=1709996786;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qrSAlaPh6y0XeZbwLQygm09FiBVmDsRwj6kIPbpO+ac=;
        b=eu/RxH/IOluuBI2BBC5DnSaEK2GXM81TSr6VjtYXlTEINdRSwVvpe0YLWYRY+h3Jwv
         b3njGHwB6STOCRQfQuxvtOr2GjhqSoYXjHp9AiEDAYuDlodymWnH04Cz4at6Zx8Uk/gO
         wR+SxOWS7inROd7r97JjULvBkYsQryvNhLMbCV0nqigxAYprMCLzU7M+rJWH2RHiY1Yk
         4Lt4G0kWvueH0NTksNQPg9vaksm5IqAh7t7wXY8WGBzLZBT3tXaL6zg4+GGe+ogfw/XQ
         yxIVKUTUlumglxOlDeAiY8W49ficzssKX6piqGi1mcyEiFWpZ/YVyLZbt4b8audCvM5Y
         gmsg==
X-Forwarded-Encrypted: i=1; AJvYcCWstIM23C7XfzR70OtzF2ajLGbsgBH+pCFyOF1SNdY2vlasM+Pw3oYVrUsiG4iUrZGnRPAVTlN/MlegkZQmGNhuw3obuDHa
X-Gm-Message-State: AOJu0Yz6nOmYPEwrlFy23DNvMRhCTsXsxiYmn6xdZhrQUgk09zsimSrA
	maFVCEGTRmpYeogGtbJRF90iofGiTuBanjpxcggIx6BIOtTxYg0PWK3E8R6ElJdSoTvPYh+Bhgp
	Zy8a5wEWWfTiOw5Sx2+fKPUC9LJE=
X-Google-Smtp-Source: AGHT+IEaoJ0EIEJMr1Auv9LAe6hd3ruRGKQaWswy7UXoWRUhb+BsZa3cljQHfsjmVp7ROvTWXxlriSX3h2quvblOfsc=
X-Received: by 2002:a81:6f03:0:b0:608:7a9c:9a82 with SMTP id
 k3-20020a816f03000000b006087a9c9a82mr4546852ywc.47.1709391985893; Sat, 02 Mar
 2024 07:06:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <22a53b78-10d7-4a5a-a01e-b2f3a8c22e94@app.fastmail.com>
 <4c7bdf8fde9cc45174f10b9221fa58ffb450b755.camel@intel.com>
 <20240220185714.GO4163@brightrain.aerifal.cx> <9fc9c45ff6e14df80ad023e66ff7a978bd4ec91c.camel@intel.com>
 <20240220235415.GP4163@brightrain.aerifal.cx> <a57d6c7eada4b9a7c35addbc8556f5b53a0c3e6f.camel@intel.com>
 <20240221012736.GQ4163@brightrain.aerifal.cx> <d18f060d-37ac-48b1-9f67-a5c5db79b34e@sirena.org.uk>
 <20240221145800.GR4163@brightrain.aerifal.cx> <4a3809e8-61b2-4341-a868-292ba6e64e8a@sirena.org.uk>
 <20240302145702.GD1884416@port70.net>
In-Reply-To: <20240302145702.GD1884416@port70.net>
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Sat, 2 Mar 2024 07:05:49 -0800
Message-ID: <CAMe9rOoVNZ+q0MAcpW-HDuptD8WDEDddZjOycy7G=P48nJ=DSA@mail.gmail.com>
Subject: Re: [musl] Re: [PATCH v8 00/38] arm64/gcs: Provide support for GCS in userspace
To: Mark Brown <broonie@kernel.org>, "dalias@libc.org" <dalias@libc.org>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "Szabolcs.Nagy@arm.com" <Szabolcs.Nagy@arm.com>, 
	"musl@lists.openwall.com" <musl@lists.openwall.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "debug@rivosinc.com" <debug@rivosinc.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "shuah@kernel.org" <shuah@kernel.org>, 
	"arnd@arndb.de" <arnd@arndb.de>, "maz@kernel.org" <maz@kernel.org>, "oleg@redhat.com" <oleg@redhat.com>, 
	"fweimer@redhat.com" <fweimer@redhat.com>, "keescook@chromium.org" <keescook@chromium.org>, 
	"james.morse@arm.com" <james.morse@arm.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, 
	"will@kernel.org" <will@kernel.org>, "brauner@kernel.org" <brauner@kernel.org>, 
	"hjl.tools@gmail.com" <hjl.tools@gmail.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"thiago.bauermann@linaro.org" <thiago.bauermann@linaro.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "sorear@fastmail.com" <sorear@fastmail.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 2, 2024 at 6:57=E2=80=AFAM Szabolcs Nagy <nsz@port70.net> wrote=
:
>
> * Mark Brown <broonie@kernel.org> [2024-02-21 17:36:12 +0000]:
>
> > On Wed, Feb 21, 2024 at 09:58:01AM -0500, dalias@libc.org wrote:
> > > On Wed, Feb 21, 2024 at 01:53:10PM +0000, Mark Brown wrote:
> > > > On Tue, Feb 20, 2024 at 08:27:37PM -0500, dalias@libc.org wrote:
> > > > > On Wed, Feb 21, 2024 at 12:35:48AM +0000, Edgecombe, Rick P wrote=
:
> >
> > > > > > (INCSSP, RSTORSSP, etc). These are a collection of instructions=
 that
> > > > > > allow limited control of the SSP. When shadow stack gets disabl=
ed,
> > > > > > these suddenly turn into #UD generating instructions. So any ot=
her
> > > > > > threads executing those instructions when shadow stack got disa=
bled
> > > > > > would be in for a nasty surprise.
> >
> > > > > This is the kernel's problem if that's happening. It should be
> > > > > trapping these and returning immediately like a NOP if shadow sta=
ck
> > > > > has been disabled, not generating SIGILL.
> >
> > > > I'm not sure that's going to work out well, all it takes is some co=
de
> > > > that's looking at the shadow stack and expecting something to happe=
n as
> > > > a result of the instructions it's executing and we run into trouble=
.  A
> >
> > > I said NOP but there's no reason it strictly needs to be a NOP. It
> > > could instead do something reasonable to convey the state of racing
> > > with shadow stack being disabled.
> >
> > This feels like it's getting complicated and I fear it may be an uphill
> > struggle to get such code merged, at least for arm64.  My instinct is
>
> the aarch64 behaviour is already nop
> for gcs instructions when gcs is disabled.
> the isa was designed so async disable is
> possible.
>
> only x86 linux would have to emulate this.

On Linux/x86, normal instructions are used to update SSP after
checking SHSTK is enabled.   If SHSTK is disabled in between,
program behavior may be undefined.

--=20
H.J.
