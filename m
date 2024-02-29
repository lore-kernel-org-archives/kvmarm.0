Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BFC376E9
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 03:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709178607; cv=none; b=KcwoBG8j0aULyWscgB2lW/PNjXGzAUaU0P3Nou0FcIcrbUY+4PG18Y9qqBvjLYKKf5947+nwPG1qV4k0PrksqDkoK99A0tUfEiChHhP/G8EugJSi7bhEDIr8fL6B82jwYP2Z2goneruzUlQCb1Ek0kzPQT0psZ8UZ7tIGT8tmqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709178607; c=relaxed/simple;
	bh=Er8EkfZFtuky5LDCB1/DSrXrfh17COeijDSglM1hi1A=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=unpaO9WNpXtC/fzGWsnJjGUBim/KWiKtUqwXDrLGM1AazGIdCvdXOvdy1r18ALu6Dz/Gtt072MwunCvIz1Uj3zxpBT5fx/L751E3twXWnDWjrEssiEG1igmm/YA7qtCmwx9Rns43OlMAuIWPic1G6qviYqrkFVchNuFbaONwK64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c4h/Zxil; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c4h/Zxil"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1dbae7b8ff2so4307305ad.3
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 19:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709178605; x=1709783405; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wkGL4ihV2OtiC1xVy3oIJJV1camQdA/fDE7d+XmMCGE=;
        b=c4h/ZxilPqAj9vAiqsF13kUJZwV8L9Z/lMsPwqmm0F9M6O7Y7kTH/HOE/rfZ1XIskf
         KaxbV5JsV8lIabAXiwAI9pApbOfteDyBt7APWdzrwbtb8UuGN65ql8CQGXv/dmxbKLGD
         bH0pUO/mq6SQliNu4nz3L7o16x/T5kZ0CDHB8aslBMRHVJQ2NCuf+0MHwwKRLWHUtktZ
         96xAH2lkv02I4nzkOE0NB3qVMs7Um1+cPR8LdJXw9d+xbF5b98WYrnkia2EvoPjxzF7E
         fO8SY7CIhZn35mZQivyGRkg+Z3fNfZ/Oz0qxIpM1+BQWz2YVdLCz5XMvyWzL94mM/Q/L
         TFhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709178605; x=1709783405;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wkGL4ihV2OtiC1xVy3oIJJV1camQdA/fDE7d+XmMCGE=;
        b=nUdOLhnNN4uJBCD2Gln0n5UuILEUZxsrqZvS6s7cKdMvC1U0lq3WnRS54CcK7fHR06
         fs0KT30LFwnuGCD28/Im5wpVrWcjmwGtO85SfQZtv5VhmnzqkUZuqMLJ0vGlZOK2xpVL
         PWRZExdWrF8Ftv4pmQwiIXKNLn6Jvfpxor+j49Afh70QVMe/fRMApUkfuu3vWfa4rlDx
         aUESHSMySu02BwTqh0DeWOTkG/AqOEAyREl867HT1EyhpVoeLvPrpsMIeDQqeX4sb5Fl
         Ag5QablA7P3xiKFdxlcsWsvvErpniBNlWOr3gCfVevs0pDvMUOd08GrDT8zcLOymup6U
         x/nQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwLeMdMyfDdvCeWAX84xasxPQ1SqIrNYqrnwqvONZqBgFjsrR9a6vM7h+0QRikHiTC4NjKE2gl/TzGdX9YpnL9BwqEWMvz
X-Gm-Message-State: AOJu0YytsuMiFyrpTjlg9zoXy6MmaBeW2wjq7SU2TwzF1fv5TzDBDSJK
	lBn8tifJdLxgEwWK8+YGIVOVPAnDB9eLe+pf0I2wBi4WrwGdnF6J
X-Google-Smtp-Source: AGHT+IEFuQfnfOdxrtG5oSxHaCUMHqvsrtVGazOAp72epa+sxEp407xvB6/65mkpoFr1O5KeWHfjhg==
X-Received: by 2002:a17:902:ed41:b0:1dc:297d:b621 with SMTP id y1-20020a170902ed4100b001dc297db621mr961057plb.16.1709178605410;
        Wed, 28 Feb 2024 19:50:05 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id j18-20020a170902da9200b001d9773a1993sm229042plx.213.2024.02.28.19.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 19:50:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Feb 2024 13:49:58 +1000
Message-Id: <CZH98WKJY6NT.5D53XGR31X22@wheely>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
 <lvivier@redhat.com>, <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>,
 <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 04/13] treewide: lib/stack: Make
 base_address arch specific
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>
X-Mailer: aerc 0.15.2
References: <20240228150416.248948-15-andrew.jones@linux.dev>
 <20240228150416.248948-19-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-19-andrew.jones@linux.dev>

On Thu Feb 29, 2024 at 1:04 AM AEST, Andrew Jones wrote:
> Calculating the offset of an address is image specific, which is
> architecture specific. Until now, all architectures and architecture
> configurations which select CONFIG_RELOC were able to subtract
> _etext, but the EFI configuration of riscv cannot (it must subtract
> ImageBase). Make this function architecture specific, since the
> architecture's image layout already is.

arch_base_address()?

How about a default implementation unlesss HAVE_ARCH_BASE_ADDRESS?

Thanks,
Nick

>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/arm64/stack.c | 17 +++++++++++++++++
>  lib/riscv/stack.c | 18 ++++++++++++++++++
>  lib/stack.c       | 19 ++-----------------
>  lib/stack.h       |  2 ++
>  lib/x86/stack.c   | 17 +++++++++++++++++
>  5 files changed, 56 insertions(+), 17 deletions(-)
>
> diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
> index f5eb57fd8892..3369031a74f7 100644
> --- a/lib/arm64/stack.c
> +++ b/lib/arm64/stack.c
> @@ -6,6 +6,23 @@
>  #include <stdbool.h>
>  #include <stack.h>
> =20
> +#ifdef CONFIG_RELOC
> +extern char _text, _etext;
> +
> +bool base_address(const void *rebased_addr, unsigned long *addr)
> +{
> +	unsigned long ra =3D (unsigned long)rebased_addr;
> +	unsigned long start =3D (unsigned long)&_text;
> +	unsigned long end =3D (unsigned long)&_etext;
> +
> +	if (ra < start || ra >=3D end)
> +		return false;
> +
> +	*addr =3D ra - start;
> +	return true;
> +}
> +#endif
> +
>  extern char vector_stub_start, vector_stub_end;
> =20
>  int arch_backtrace_frame(const void *frame, const void **return_addrs,
> diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
> index d865594b9671..a143c22a570a 100644
> --- a/lib/riscv/stack.c
> +++ b/lib/riscv/stack.c
> @@ -2,6 +2,24 @@
>  #include <libcflat.h>
>  #include <stack.h>
> =20
> +#ifdef CONFIG_RELOC
> +extern char ImageBase, _text, _etext;
> +
> +bool base_address(const void *rebased_addr, unsigned long *addr)
> +{
> +	unsigned long ra =3D (unsigned long)rebased_addr;
> +	unsigned long base =3D (unsigned long)&ImageBase;
> +	unsigned long start =3D (unsigned long)&_text;
> +	unsigned long end =3D (unsigned long)&_etext;
> +
> +	if (ra < start || ra >=3D end)
> +		return false;
> +
> +	*addr =3D ra - base;
> +	return true;
> +}
> +#endif
> +
>  int arch_backtrace_frame(const void *frame, const void **return_addrs,
>  			 int max_depth, bool current_frame)
>  {
> diff --git a/lib/stack.c b/lib/stack.c
> index dd6bfa8dac6e..e5099e207388 100644
> --- a/lib/stack.c
> +++ b/lib/stack.c
> @@ -11,23 +11,8 @@
> =20
>  #define MAX_DEPTH 20
> =20
> -#ifdef CONFIG_RELOC
> -extern char _text, _etext;
> -
> -static bool base_address(const void *rebased_addr, unsigned long *addr)
> -{
> -	unsigned long ra =3D (unsigned long)rebased_addr;
> -	unsigned long start =3D (unsigned long)&_text;
> -	unsigned long end =3D (unsigned long)&_etext;
> -
> -	if (ra < start || ra >=3D end)
> -		return false;
> -
> -	*addr =3D ra - start;
> -	return true;
> -}
> -#else
> -static bool base_address(const void *rebased_addr, unsigned long *addr)
> +#ifndef CONFIG_RELOC
> +bool base_address(const void *rebased_addr, unsigned long *addr)
>  {
>  	*addr =3D (unsigned long)rebased_addr;
>  	return true;
> diff --git a/lib/stack.h b/lib/stack.h
> index 6edc84344b51..f8def4ad4d49 100644
> --- a/lib/stack.h
> +++ b/lib/stack.h
> @@ -10,6 +10,8 @@
>  #include <libcflat.h>
>  #include <asm/stack.h>
> =20
> +bool base_address(const void *rebased_addr, unsigned long *addr);
> +
>  #ifdef HAVE_ARCH_BACKTRACE_FRAME
>  extern int arch_backtrace_frame(const void *frame, const void **return_a=
ddrs,
>  				int max_depth, bool current_frame);
> diff --git a/lib/x86/stack.c b/lib/x86/stack.c
> index 58ab6c4b293a..7ba73becbd69 100644
> --- a/lib/x86/stack.c
> +++ b/lib/x86/stack.c
> @@ -1,6 +1,23 @@
>  #include <libcflat.h>
>  #include <stack.h>
> =20
> +#ifdef CONFIG_RELOC
> +extern char _text, _etext;
> +
> +bool base_address(const void *rebased_addr, unsigned long *addr)
> +{
> +	unsigned long ra =3D (unsigned long)rebased_addr;
> +	unsigned long start =3D (unsigned long)&_text;
> +	unsigned long end =3D (unsigned long)&_etext;
> +
> +	if (ra < start || ra >=3D end)
> +		return false;
> +
> +	*addr =3D ra - start;
> +	return true;
> +}
> +#endif
> +
>  int arch_backtrace_frame(const void *frame, const void **return_addrs,
>  			 int max_depth, bool current_frame)
>  {

