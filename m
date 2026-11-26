Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795668789;
	b=AQBDetre2t+W0Uk7rRNlntdNWSVaOx4gD/IzYP/LReQ/1blK9RuVP22oUpCusep/3eOu
	 HjWAUUrgNdHOVTwfoKcoXiYDoas6G3z5I2wNnWwJbHMxP8RNDx52CuwhvXMrDOHPlUiVp
	 pbW0XjnXMDbxqJClWFHd95hgIGi9RD+YSUP7TNQ+bSJjg3laRdcFa7lVyugFOGTJ23J7W
	 Xcrm3xImzoEW99S7Z/bGsQWdzhLM9DklJPFNrdWvg9NO2cOtHbx5bL73utNkX2kIgVm4b
	 M/dgPnR17DzvFVbWGubdpF3sQIchuDkTQ8ZSvsJDkHK0DL0MsynMVNgjlV9PR6/3t+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795668789;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3Lt4WVagAGoPNQQ8sUuV+xbM6KmxoNVjHzW8jPpsfl4=;
	b=4LIg5IcSOwx1kvDe9W5eM5bbcR8XwdWcLmv5XEpUPXqQCchaOgOMZOi/h+umiFJU9C9a
	 i/eL3ZbROP3SrElBwKwmAnrGvYOA6XjScgdUWo6Jcqpn+30G/CpKnB6+a1HwYD59LMkiI
	 2LWyOGooAA/KS4j474FDggzFKa41w+V4pkTg872XjiL2ngqPbEw8c3sPsCGkJPfd2QWZB
	 cA4m8x+dSFzy3uo889PgMCOO6tIVixZPs2HFYZMBOLSE2e+y+ymZuKJ1Q94ismJSeKIm7
	 HPQKcECGYQhRdgkjzCD01svFV5mv2j5lLGi6lDUZJ76eJQJraYcoYjQ6Oh3ueGVdytw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Wd+w00+j;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BC3606A32C
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 04:53:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57BC3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Wd+w00+j
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-55c7445cf85so1381061cf.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 20:53:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795668788; cv=none;
        d=google.com; s=arc-20260327;
        b=jSPoY6Rozj+mUZc+WGe1DvWuhy4wYTStKe2hoTSZu1HZKKI+lDdmKKywkr+qkdVUvo
         n+RuLB97iJfMOH7LBIc2MhyE3LSozGepvmQVmciA2OtNZ6ZJUZg9xtYFri/T8DOoyUDf
         EDdywutU092ASXm6TLWr080zayKNU1Y/OLQ95QQcnLNr7Q9eJfwzqalOmOqAbN4qFgTI
         2sm7Bs4Owf9AW862lsRONmSUC0aDcsMYw09kcw6eJGP0h+MgatZp5UkUxzhN0A1FlRJU
         KqJ5VxEFPGtvnWcJLHLhogkTlQttsGK4kf6mMB6Q7rPFJ1xutgIzqbSnCJHSmdTkZyFS
         RxRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3Lt4WVagAGoPNQQ8sUuV+xbM6KmxoNVjHzW8jPpsfl4=;
        fh=peWThKuqxrCMK7lZ1XkW0UTGd3MxaraWIspQPHDJTXo=;
        b=KNAiMWBI8kVsCgaWjFCifAQ0GAO+vNf3a6rcE2j2KPOslA1zUPksFaAqJXo+2r7DmN
         X+pMmkeg4EZEg8WnhqJbncXauQ6/FPHIHeinEPlGZvr3WGUaIkWHlTR99pGY4qcbsVZe
         IoY8wbLyFdMd6c62zUm2cOSdmwSLqBgqyEvPqX07vzmYynLZVJWhBRGLJs33oE1vx373
         Z4xk4NFDnC0T95U2UixSu6X8kj5mFWQVQat2SloZ4/XDqupOuQ7xxu+ms4JZkcULyh7P
         nsm/NTQLwVpTvjGqzHhlU4d0r7V2M482DL28yfV45l7P8EWq5GsSE8ZNuAnL47SbgfPe
         7WUg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795668788; x=1796273588; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3Lt4WVagAGoPNQQ8sUuV+xbM6KmxoNVjHzW8jPpsfl4=;
        b=Wd+w00+jwprH2Z7WaB0z9B+eXn8VFSBg9vXrPggY+8dvXkKNWOGXmmPPgXtKo2cs0b
         1Nv6r3K5sy9ukrueHL7Qd1zX0NXV9GwTnkcV34yL+j5AzAfXphYvGjTiQOZKel26sS0O
         RESaNfPrqDL3xjKl+UIAQ6h+6TKCeoZdfhY6ngrtyMs5l3QLeK+f4hwUCTTSC57hfcsx
         SkNmH3CbqFox4LsvPxIcdRg98abwh0ObP/OSXed2HoTnMOAOfaT2jlHrXmEIlsp55aFf
         gEQ3c2lOlTlHAblApePu2yA6ObqmDo42EdaxXuLX1Jxqqx9ZB1hLJqzbeUdRef9VS85k
         0jXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795668788; x=1796273588;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Lt4WVagAGoPNQQ8sUuV+xbM6KmxoNVjHzW8jPpsfl4=;
        b=gFUtAbrT0WeBD3Q5vQl7SSLmHYuWhrA+Ixn//BVZhEVJyE2ng0HSC7Lf72amAOnh8i
         BpxErX3aeR/+Cm1qWc3NDwfQpgEf2iS30lXI+iLn3rrHCvxkoxfVsBCY/kxLvfJobSgk
         4ufdFonhdzRp6iDLnGI19MJtWw+mQAWAvBxfeE643NRQVo7A62v2UcRh16vDqF5OKsAS
         8lr5ext1x4lfD6Eupr+/JbtOlG7JxscXjpDsr2u5h/wc8BUNBowSx2WpSyrOJJJp8GIm
         pngRAqwgbsXKMejTQNYZREeKIikthk5GzYUb14aY+SzyhjPbLulnG1gE9/p+BJwpXUH/
         aKOg==
X-Forwarded-Encrypted: i=1; AL+hErFB/TJlviIVGhtgJ63cqHxxHwyiZa67mrd7FJdGkfDdH293I/yuID5kDT9RGjkACh94IDXns3c=@lists.linux.dev
X-Gm-Message-State: APuU4Z/3h2uoEbXLAlVTnwFUojoGYkftgJfwq9YVRE1GmtyYPF/1q3Q2
	UVFam0lw5KF8VS8rqIHecIVCSOrfSe8hETJp++OQQvgR5F+WGqLBR3K5U4QrRzBd7v1lpskKVfw
	jKCbRPlsw7K1xhTFDVFyxCvXZ6kQW0VLz87e9QlGP
X-Gm-Gg: AZFdTZeDF37hHbZfmvsr86wX8clDiztFH2fJySYBaoV+WLXlgGi36qIE0+Y7jIt/+R6
	YmXLTQ94kp/XKwNpjbyxEPvZwBvTMsab5y97XYZ3tzIMkbz8UQMKgMdlhKZ4/zAEHvWlWM1RdtM
	R59YKnesAz3x+UjBB263ggDuuBgN5Zc9pRHWc6L3GfVXYkqdejXyHawl2Ihm5NFNS6HcEObY80u
	Q8m84DBJ3aohpjT3bnEX4LBVy1/Wh7cdyMTX8vkOq/qqiuWz00MQOSnFoBXyYWKqEBprtfy5Xrw
	bZ55MYLjDVZgAZUs6luI5DttkWxEJF+jADJhUeFuH/I72VSu1Ybl06YMjPqak3zjQl01wchsdTp
	pB9SOkGBOwbSR6abr7vh+unEwHCP2FWhDYgmNob/2G0O0L7LU+yQC9HTZ4Q==
X-Received: by 2002:a05:622a:1e86:b0:536:3ee4:81cd with SMTP id
 d75a77b69052e-55d88127bafmr101738501cf.4.1795668787640; Wed, 25 Nov 2026
 20:53:07 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261125061523.1540234-1-irogers@google.com> <DN4FM3TBOJ9T.2QOOL77P5HETO@garyguo.net>
 <20261125132225.00254c37@gandalf.local.home>
In-Reply-To: <20261125132225.00254c37@gandalf.local.home>
From: Ian Rogers <irogers@google.com>
Date: Wed, 25 Nov 2026 20:52:56 -0800
X-Gm-Features: Aa3M54pMQmXw5Cgtc0EakW9NOiIZs8STgUuBigJfJMSZlzejGTE6XZMetCnzc-8
Message-ID: <CAP-5=fWkUW787c4dGx9rccucqD67dfRgwBB_SoCxFnfZXtXP-w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/30] unwind: Minimal DWARF CFI unwinding for user
 and kernel space
To: Steven Rostedt <rostedt@goodmis.org>, Gary Guo <gary@garyguo.net>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, jpoimboe@kernel.org, peterz@infradead.org, 
	mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org, 
	linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	nathan@kernel.org, llvm@lists.linux.dev, nsc@kernel.org, 
	linux-kbuild@vger.kernel.org, ojeda@kernel.org, 
	rust-for-linux@vger.kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, 
	wnliu@google.com, dylanbhatch@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 10:22=E2=80=AFAM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>
> On Wed, 25 Nov 2026 16:28:02 +0000
> "Gary Guo" <gary@garyguo.net> wrote:
>
> > A quick question: how do you plan to get this working on 32-bit ARM whi=
ch has
> > its own EHABI?
>
> Do we care? Isn't ARM 32 mostly deprecated at this moment? Or at least no=
t
> adding new features.

There has been recent work on both MIPS and Alpha for perf events, so
supporting ARM32 EHABI doesn't seem unreasonable. Devices like the
Raspberry Pi Zero W/WH, which use a 32-bit CPU are end-of-life in 2030
(according to https://endoflife.date/raspberry-pi ). It is
out-of-scope here, but extending the kernel and verification
infrastructure shouldn't be hard.

Thanks,
Ian

> -- Steve
