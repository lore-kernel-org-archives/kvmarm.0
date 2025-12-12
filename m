Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7F6279795
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 02:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505353; cv=pass; b=gB1cJn2MURvf+55KQc2BwCnTAI4lJlvmQtyeUpWWBcYSImscT1GPJYvG9UhF2H9DFJKNu8TYCl0aq7vF8vhnYZcGNYAW32Xz/5KT+Gu2Tt4cTI/e7hA8CYZ9gwK198oefTsSC66xjUv2g9VdMc2TSKGWXYdZYRI0HyIGr/yHOEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505353; c=relaxed/simple;
	bh=84TfbL9BjJfn33I8UDW+Ory3GlE3i/ue11dFxydhcZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J+u98HSUFVhdo2REvLVaeUlR/OLzVAvCPWKBQP6Vm77A6QMyAN8gwQ4lvpk6QOQf2pJAREj62eLMaWwzam9lPVIJffAvQp2LUHQRsATZmyiyusxn/YhbWdaHmPCfXgvQQjS3bToIbDFifreyiS4lwaGgltruHU1UGtolGQCHxMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B/Jz+v9D; arc=pass smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B/Jz+v9D"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477a1c8cc47so129375e9.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 18:09:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765505350; cv=none;
        d=google.com; s=arc-20240605;
        b=Q0E8jALX7XS0VTiqzIursBv+IS87kvhI9YQXijBQfekNhoLD9zSsKg1hKDOly1dPzS
         GcFrUJpcdYD/MuiRiYRJhZzBy/B/SfThgXidCW+TWvXOaoA2f29lbo+y9Xxy7RS/44pH
         Wpd2LjfGO1hhyzor/f0jircZS0CLVgNsQd/z0qcjigOXzg6ZCij6sHZYadFlQgOhunp+
         Ne806SKLei3S3i1ZmF4edK3HT0GRX7k3w6jqCsTUsoqp8FPrR9cx/b/LCa8SN95XvJsR
         0RdQymZ1wTwAfvf4wkJQDXfsGwFJ9zbHA5g/bfRoUS3VreGjy8MpRi3ensGXCl1Tf2z0
         FFYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=84TfbL9BjJfn33I8UDW+Ory3GlE3i/ue11dFxydhcZo=;
        fh=02/JrjdXouS72MUzulxeCm6n4n+N+uGjgshFn8s2zC4=;
        b=hGEw2y8NbV3x8L3U/ACjAe+u2TOT7THjxK9ZF8P7BnAdh4EnIoOGYnwvNqFyxjcOza
         /QpgGQQXvuchozVp4cceSAIPpKjBn6Js5CH6IkWp2f4vqCHJ6MQnkTFHoznd2HWrRyM9
         tcHoxCjeLVojvewG4ZSvdGAEpg75lzNbaJdEVGwypZpgasab0NPsfDweZnTQ1sJzUKTi
         2ndaY/rVpMqfn9FBYFgRFBQxc4I0YJrB/AedAzS4/pX9rPuMrno/UOF8fT3vZlH00bnq
         otQmOF66b4X8IdSGiUI0g92RDWopOF27Mxay8VJ7fIBms46TuAtsHylv5Dkrll8bWLAr
         KuLw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765505350; x=1766110150; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84TfbL9BjJfn33I8UDW+Ory3GlE3i/ue11dFxydhcZo=;
        b=B/Jz+v9DSbYjWwLY64CrskSq1SXnhVHwDOD/OhIyrGIxYtL+zFNDmva3kkFnlFx2ST
         1I8mQ8/8w1tabHpWZVy/43fnjiiKamhrYMvz78Aoo6FCxkVdDqnTPoXaeJLRGV6uNowX
         W+AxTuIoWAXhouyKIrMV6kMlNnHz77DQ2dtjZepKqXOMch+Rf1NlpfBgXNaJvAUpLGAA
         Ac3OguYN0QFfGBTcPGx7Z6VYYUogoKjDu5neZ9Q4RtFH3HHQU3kz3CVpZQXMRDd4IIez
         aftpYoDou3mlgo1EZcEtq89Af+NXgdXqHHybbU6BYkgH0F1dlziO1sMIVM5MuKrGngm/
         2P4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765505350; x=1766110150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=84TfbL9BjJfn33I8UDW+Ory3GlE3i/ue11dFxydhcZo=;
        b=OF3yFGQaZrlRScpEoGcEA4gHhfLS7zIPEpYtmtZn6l3cBJ7m/5/lMaDnjA/FoQ2lYk
         V7g9iaUry+SirP5sCW+Q2uTA1o4LqCO+FR0GdG9QbqY668IYPBHH44MnyeHhGwL1joqN
         yU0nfPgqXwQYJJVJrbBsvL/rWzjrClCRk9jPzoiwEU8zjz9ZNG5xi2jo19isjLgJ260r
         BIE8AddN5mLxSwb1K6a9oaz/AGVBJp7A4EZTi0wHjL1IGVETlvJ1ZjqHjaPxSEEufh/2
         WVsKPEZke56enrQbgwGA4b43TB46wMXd1hhX4hckC+5JFWZ37tqevDYiB6Y3KxY/Hvat
         +i4A==
X-Forwarded-Encrypted: i=1; AJvYcCV3XkbBek4k43e9C7L8CPk3a822K+slITbF3d4nQLhbUDcbaGnQVcBkHKPHrUOBKiU4O8svpHw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzER3brQtCEIQ6k94zsoxAKCyhsZfLRm9V1R9M5zmcEJnCtIv5k
	grdp4FSDY8KBpUHZvOu72Widf8IrUjW2HB3lBdrcmDkZzXMaqQhLU+uIFo5uZ+iIaGflRLF0mYL
	CvkOQFJIfCWZ4cExNcywhU3iLn2DPMtwRmqrMeWEO
X-Gm-Gg: AY/fxX4S99AqJguSOTgYT+vUB4gYNwuBfmfFCwJITRlZwRZgcDvOv8o5kYunx0x4QHg
	N1kr6wqsaAduQB0XcHcphikqOcxaZVwznlrnr2/+hl3kl4QmM0Fq1SzUot2Xj6uHyxTzwzpQnXY
	DVMLy3zNrW3W+/PbboDc9K79gywA3CW/AYrxLGXmf4UE12YMHJM+pGQ4P5t+Enpq2YWcWdfObux
	TzSu3EHCHiqsJPLOMx80UiquofLJHRlNUZfZFkeAKRPrZniCZ1MmXYHfD2YvMuvPKX7Ts2DT2NR
	QMUuZ6azdXDpzWUeQao4QI5UHSH/
X-Google-Smtp-Source: AGHT+IGoi5wVrkD2fWPEWoc/lIs5FT33tT8boqcMkmHzGIlAt4ukcQFeZJmytGledBHa8gl+3ojCpFp5RQ8KAJmzYtQ=
X-Received: by 2002:a05:600c:68d7:b0:475:da0c:38a8 with SMTP id
 5b1f17b1804b1-47a88d1fc5bmr854875e9.4.1765505349917; Thu, 11 Dec 2025
 18:09:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1478ac09-8134-5551-13b6-c7be096262af@redhat.com>
 <CACw3F52i_Yr+8Gd1=H=EMi7NnVJ8WCgMkaG1dSe8FD7PvOsW8w@mail.gmail.com> <c44b75bd-bf54-0aab-78a2-89f448cf126c@redhat.com>
In-Reply-To: <c44b75bd-bf54-0aab-78a2-89f448cf126c@redhat.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 11 Dec 2025 18:08:58 -0800
X-Gm-Features: AQt7F2rAtAMfq5kg2V3CkWpX1f5OFLeUqrS16Y_3ULq9rATVCLdx1UlpLQpqi04
Message-ID: <CACw3F53ZGQxefk9E8c8-9UM2o3Rv+0SwSt=n_fatBOxwQE3FNw@mail.gmail.com>
Subject: Re: sea_to_user sefltest failure
To: Sebastian Ott <sebott@redhat.com>
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2025 at 10:11=E2=80=AFAM Sebastian Ott <sebott@redhat.com> =
wrote:
>
> On Thu, 11 Dec 2025, Jiaqi Yan wrote:
> > CONFIGs seem alright to me. Do you boot kernel with cmdline options lik=
e "default_hugepagesz=3D1G hugepagesz=3D1G hugepages=3D64", or dynamically =
set up
> > huge pages via "echo 64 > /sys/kernel/mm/hugepages/hugepages-1048576kB/=
nr_hugepages"?
>
> Neither of these. When I do the test is skipped:
> # echo 64 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> # ./arm64/sea_to_user
> Random seed: 0x6b8b4567
> # Mapped 0x40000 pages: gva=3D0x80000000 to gpa=3D0xff80000000
> # Before EINJect: data=3D0xbaadcafe
> # EINJ_GVA=3D0x81234bad, einj_gpa=3D0xff81234bad, einj_hva=3D0xffff41234b=
ad,
> einj_hpa=3D0x80241234bad
> ok 1 # SKIP EINJ module probably not loaded?sh: line 1:
> /sys/kernel/debug/apei/einj/error_type: No such file or directory
> Bail out! Failed to write EINJ entry: No such file or directory (2)

Looks like EINJ is not available on your test machine. You will need
to check several things:
1. does your firmware have EINJ support? kernel should log something
like "ACPI: EINJ populated" at boot time, but it doesn't guarantee the
EINJ support, just suggesting it may support.
2. if you are sure about the firmware, did you build kernel with
CONFIG_ACPI_APEI_EINJ=3Dm?
3. if CONFIG_ACPI_APEI_EINJ=3Dm, please also "modprobe einj". If
modprobe failed or /sys/kernel/debug/apei/einj/error_type still
doesn't show up, firmware probably doesn't support EINJ at all.

I will probably add more comments at the top of the file to clarify things.

> # 1 skipped test(s) detected. Consider enabling relevant config options t=
o
> improve coverage.
> # Planned tests !=3D run tests (0 !=3D 1)
> # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
>
