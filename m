Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19871DA53
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 06:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712385685; cv=none; b=Vy9NDVUpdQQYTU+SkHbn5+RfaZIIj68e+CLZ4AljHFoQwafWd/XT5EZzliqrodbBu1Mk+7aYUFVQ4QXhhQRhjzCWhDxoGG9Uc6tKwKDfVe+4RNLj6vKGwFVRqQ9G/8LJWS04QTKGqJJS2QFBUhHGPy8MneOKdLhABhYQvd0S6Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712385685; c=relaxed/simple;
	bh=Y4myA46EG/4i4dFaAu7Ev5ZT2oGDovwCLjemmigFZOI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=u7KZuW5zNXeHX9Ufz8Tv1GQ6KJ3b7QSnkfWhQedMlL8fWRNonGe4CVn7Rzu5Zw2aPMPmL+dArF7/VyhQyCPPppciwvAvpzUnZRPlQBdQzkXkg2RHolMn3f0gXETiKQ9X1qknd8ZHWWTvxse6fenJ6fFu8491e206WeJnBAArHgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a6s4nev4; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6s4nev4"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2a2da57ab3aso1654017a91.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 23:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712385683; x=1712990483; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOBsUw970qmuGR/nEFMV7OyuXkGlmB6mY4yq9LvFZhQ=;
        b=a6s4nev4TuEvSWoI0gOqwf07CnLZZItA3YsvJlIJOMlpbnyCdMNmkB4yIDV6osR+cK
         Nk3WgS8M/jABx+Jh+jZ9iEEpcC+j8KrOMsuXlFd1UADfSdWLOOYfCfKmUl1GqP81otQo
         OOjnuQwp1WPHFguIj4BrGbktJC4ZLSKvf9ey3PIeyYA5iQ8m7fNmomah6prvPzV0jqq2
         yxRhrlfMqSmmPXb11HN2WLc6zcykBHakRfk38+81IxjwaYmbjiUW+6FFfybb3IjBERHi
         kq316CfccXkC38IEW/yPSXiM0VoZSjNljrShypEkl7HR8jtbZqsKFlKr766NczG77jy7
         7FwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712385683; x=1712990483;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HOBsUw970qmuGR/nEFMV7OyuXkGlmB6mY4yq9LvFZhQ=;
        b=IIk10KTmDNKmARW6SZWdUHRscUHQ4zuTy4R98PTGNIFX2dbB0jue4icP/YS7+SGm8h
         u7dHB1Qlt+g+7CjSlruQSEFEi6ffaTGSmDMcToDHnVPbKAiAknjhJfjk4Fi+KT3/5DFC
         kv9Y2nQpKSdG2wQ1rTs9vWddu0W21ITiwTX05w2xin34mzZO0XeXrDfrWOmiObJ64Z0/
         9pUirKKdG2XZkZoE9Ifi8OkTey2R2AS3q0uFIdBDeSLa8Vb0PuUl4FuRaF+In0HsM7Fn
         poDcZ0eqdVNW/KhzpIsn+h1dQCUV35rOB8sc/SjcrgosWrIQV7o7dGjrNQS0/EPoMSG8
         V/8A==
X-Forwarded-Encrypted: i=1; AJvYcCWlGCKBODrjGXV3KyaejmF+3skT5BSKyFgrt9Mdg4Ft6Ksn+zS1vmc6cOLRKhXHSJPBfwMbKiRIgAbJ62UeuEf6Ghz0SIG6
X-Gm-Message-State: AOJu0YyZQc57sRWFijThQDJ86rzpp1JyFSC+PT76bMX5HtAufT3BiyJ8
	JEERzBg+9c5voTKNcX2BRkcyaCFjAPo2ApMpmoPVyYSC16957skX
X-Google-Smtp-Source: AGHT+IECgMT1sUsB4ORarMAQ68oanRLeoWItfNujPbS4ONFWnZwwkfklDBXxjBwIn7/t2lERNjsJuA==
X-Received: by 2002:a17:90b:1890:b0:2a2:a7be:3b5c with SMTP id mn16-20020a17090b189000b002a2a7be3b5cmr3049173pjb.6.1712385682917;
        Fri, 05 Apr 2024 23:41:22 -0700 (PDT)
Received: from localhost (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nh1-20020a17090b364100b002a076b6cc69sm2560825pjb.23.2024.04.05.23.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 23:41:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Apr 2024 16:41:12 +1000
Message-Id: <D0CU26801BXH.1ZO7Z28QAJ0V1@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Huth" <thuth@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>,
 "Nadav Amit" <namit@vmware.com>, "David Woodhouse" <dwmw@amazon.co.uk>,
 "Ricardo Koller" <ricarkol@google.com>, "rminmin" <renmm6@chinaunicom.cn>,
 "Gavin Shan" <gshan@redhat.com>, "Nina Schoetterl-Glausch"
 <nsg@linux.ibm.com>, "Sean Christopherson" <seanjc@google.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests RFC PATCH 07/17] shellcheck: Fix SC2235
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-8-npiggin@gmail.com>
 <20240405-a578a48a6cad5c42abe5943c@orel>
In-Reply-To: <20240405-a578a48a6cad5c42abe5943c@orel>

On Sat Apr 6, 2024 at 12:24 AM AEST, Andrew Jones wrote:
> On Fri, Apr 05, 2024 at 07:00:39PM +1000, Nicholas Piggin wrote:
> >   SC2235 (style): Use { ..; } instead of (..) to avoid subshell
> >   overhead.
> >=20
> > No bug identified. Overhead is pretty irrelevant.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  scripts/arch-run.bash | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index ae4b06679..d1edd1d69 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -580,15 +580,15 @@ kvm_available ()
> >  		return 1
> > =20
> >  	[ "$HOST" =3D "$ARCH_NAME" ] ||
> > -		( [ "$HOST" =3D aarch64 ] && [ "$ARCH" =3D arm ] ) ||
> > -		( [ "$HOST" =3D x86_64 ] && [ "$ARCH" =3D i386 ] )
> > +		{ [ "$HOST" =3D aarch64 ] && [ "$ARCH" =3D arm ] ; } ||
> > +		{ [ "$HOST" =3D x86_64 ] && [ "$ARCH" =3D i386 ] ; }
> >  }
> > =20
> >  hvf_available ()
> >  {
> >  	[ "$(sysctl -n kern.hv_support 2>/dev/null)" =3D "1" ] || return 1
> >  	[ "$HOST" =3D "$ARCH_NAME" ] ||
> > -		( [ "$HOST" =3D x86_64 ] && [ "$ARCH" =3D i386 ] )
> > +		{ [ "$HOST" =3D x86_64 ] && [ "$ARCH" =3D i386 ] ; }
> >  }
>
> This one is a bit ugly. Most developers are used to seeing expressions
> like
>
>   a || (b && c)
>
> not=20
>
>  a || { b && c ; }
>
> I'm inclined to add SC2235 to the ignore list...

I'm sure it's a good warning for bash scripts that do a lot of
computation and have these in hot loops. But I _think_ none of
our scripts are like that so I would be okay with disabling
the warning. I'll do that unless someone disagrees.

Thanks,
Nick
