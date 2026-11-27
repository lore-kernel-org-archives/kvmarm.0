Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795768032;
	b=1b8UCeIr872+byG9sKU7QxqtNmqk4OCOGbQg2I3e6aoFf8akhGpfkjlgZuCvioVaR+Vg
	 QfdEiPT5ewpY7ftQ7NNxah/onWPN/NgUIPTbdOadf/v0f9zDuduDzlOAW89XBsh9CYNmL
	 vSKb/cD2/XR8gndVVf+sRm6sNcf5Lzg25QYdAFm0c5+jXq8/I36ZoDuZUoCh5+M/KUTCy
	 /A4ZpXq8+SIxyQ+ApsSqJ6QjR+ZViI6xJCv6F1hWsPX1tpFq+/xGqnvEms+QZKIO9lz/h
	 GdH9df9t1DeimOKz3k+A0PBkLtyGrx3mV1dvTj8B8HR+7v4e6sCOffPlWy6+IVNsQ8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795768032;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=0qdXfgFbrt8cELQOGisVmBrQ50jtAJGNxPG8ew5/7vY=;
	b=HmwZ+Pidib/OEQUCkv3flWvNctDu85sPouxd15UEL210+M2i2Vy+OpRpa+vLYSrhfChW
	 mnkV+qYZz8qIQETSVHccVa+7v7jesBBzxTxZk2Oz6mHMXtFxn1isVfiTvq5+VPt/9llvk
	 3QByBqJ11Rva1muP3NSWKwAtHfSNCsl3KO6F08jwBghzVcc1kyUWCsK2PzKbbZBmhz90m
	 f+alRXRieO9zd42yjhHnQWdnuoK8YGP7l9aTikMbgSGGgEovAgx7vvJ6RrDoXtNQtkW2S
	 mk0Rh4rCmAUnsFhKLD30dL0dhkw6AxXnH6qPD24IckhHuhoIolMmsTu8sKicVAlKSFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nWxVVwyo;
	arc=none smtp.remote-ip=95.215.58.120
Received: from mta1.migadu.com (out-120.mta1.migadu.com [95.215.58.120])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79A9606A31C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 08:27:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A79A9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nWxVVwyo
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=P7zTh4ysMCYZDF5Ib3q0oR+g3D93VzbkeVMGD4akERA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795768029; v=1; x=1796372829;
 b=nWxVVwyo3nhf9qDpV8God0aKFJHJ/M7C00Dw8roHhe6nwbPSARmFR80ODLAiv8qtTE0e/YV9
 /2KGFYT9zOpcjrVXpJMFItjHxJSxRKKkYpiIS/EFp1dGKnN4BGdT+Wwy+0Os/i3mgorTN89+31M
 8n78XOiC2aG7OmKfZmr3qqgg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 137acc9baf8eed0f;
	Fri, 27 Nov 2026 08:27:09 +0000
X-Mizu-Trace-ID: 137acc9baf8eed0f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so42436e87.1
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 00:27:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHA5lTf3oAC853layz871Q073rV2Fxacf3xoFshlA4NK1M5ZS9cJlglbpFVde1V4ZUZ4/8JOuo=@lists.linux.dev
X-Gm-Message-State: APuU4Z8ys4VtYszuIv2GwdA/OPUyiceeso9I+Kfay0UVSJyMWkF1lc9A
	k5ZYrKN//MyNpXKpydWyDQnwaArRspSd3V/kJ+ShruDWfzfT3OOOFNfleTmgMFgfs0wRjF9IbnV
	nlcJPdIVf/5XsctF4m53qILhhIfXVN+bffBv4Mvvt
X-Received: by 2002:a05:6512:3041:b0:5c0:7c6e:4559 with SMTP id
 2adb3069b0e04-5c21a2490b8mr800282e87.9.1795768028694; Fri, 27 Nov 2026
 00:27:08 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261009072147.474952-1-fuad.tabba@linux.dev> <awV15Rv-caDclC9K@arm.com>
In-Reply-To: <awV15Rv-caDclC9K@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 27 Nov 2026 08:26:32 +0000
X-Gmail-Original-Message-ID: <CA+EHjTw_T_HhfNUytcqf6xefkOoOHgpFq3=J7bgsZSMyu1ON-A@mail.gmail.com>
X-Gm-Features: Aa3M54qBZ_c98t9Ayo9A6TeJjo0TeideV9tW7aQLWPW5qkPop4MRVlx3am7GbX8
Message-ID: <CA+EHjTw_T_HhfNUytcqf6xefkOoOHgpFq3=J7bgsZSMyu1ON-A@mail.gmail.com>
Subject: Re: [PATCH] arm64: Use symbolic constants for the ccmp NZCV immediates
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	anshuman.khandual@arm.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Nov 2026 at 11:32, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Fri, Oct 09, 2026 at 08:21:47AM +0100, Fuad Tabba wrote:
> > diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> > index f7dc5fb9427d6..15c381ef7d2c2 100644
> > --- a/arch/arm64/include/asm/ptrace.h
> > +++ b/arch/arm64/include/asm/ptrace.h
> > @@ -30,6 +30,10 @@
> >  #define PSR_MODE_THREAD_BIT  (1 << 0)
> >  #define PSR_IL_BIT           (1 << 20)
> >
> > +/* CCMP NZCV immediates that make the named condition hold */
> > +#define CCMP_NZCV_EQ         (PSR_Z_BIT >> 28)
> > +#define CCMP_NZCV_LT         (PSR_N_BIT >> 28)
> > +
> >  /* AArch32-specific ptrace requests */
> >  #define COMPAT_PTRACE_GETREGS                12
> >  #define COMPAT_PTRACE_SETREGS                13
>
> One nit: I'd place the definitions above (or below) the
> ARM64_S390_COMMON block, the generated s390 header shouldn't need them.
> Otherwise it greatly improves clarity.
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks, I'll respin it as you suggest.

Cheers,
/fuad
