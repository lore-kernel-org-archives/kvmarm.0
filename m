Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A7925761
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732808194; cv=none; b=ES31ShOWgikTz2g8M2maJdlk7sv9u5/JAn2UwoIk1KUwadpEbtjWmU31A83TwGYwZ0+u9d19cvBBSn417dfUurmzQnX7gBQ9yVohkqdivKn8A3/gl1u6zZ0N0CiA1Bp9IBUYKgUtHYi1UcEY+No9KMvHzBy4G27PzgodCfb8wjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732808194; c=relaxed/simple;
	bh=9cvR0Hdf8jyPtNU6IIOEpOjRr+PSnXveawJRkW9SU+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kH7y9mwLO16Ro/lBLgMWUn71k6E8XcSlmK41iWd3lQH4ymOfY5padoPBVe6IaqdPPfoxluQ4CHAVE1HuNfcBVMvrBij0HuN6lnZyI8p2y8B5skYXX5y5DviUIrvS709Pihxn1G7FDi/zBdelGdjgixig+FcsC7IBYRLuE72IW0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=jq3Ju64r; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="jq3Ju64r"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3824a8a5c56so737166f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 07:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732808190; x=1733412990; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WBJf/895gAZ0pPcmkrD9nFaEZSFBwkUTysldFoBxcWc=;
        b=jq3Ju64rtFmOZ6fMpt4RECwYSTD0X9PrBE/ijBkp1lSbtBG0FPs9L02r6573XmVA0Y
         T+E/Hq4ONTBC331CnVyFTCXMbAF0CqC9sPNIuEbpKfSHMJy8ljvsRsEe+zcbdXHPwhD/
         D02Cf0/sxZK4tJJjp6tnLYeLYzBtEtuzMoU4PjgLGY2YQkXX/q+DVWQdNqDmki/uZt/U
         dJlfMUR18vZge74fB+s5ouZ3Cj3l0HWzkiEWRZ/oEkF7KQvzXaf3heVbY8IMppyaSMit
         mFvrBLXTVkL1hvr36q4pCTDKlX74TIpwOU47UPEXU6SmmJZP13t6Vwr7YJT/6USOinco
         afEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732808190; x=1733412990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBJf/895gAZ0pPcmkrD9nFaEZSFBwkUTysldFoBxcWc=;
        b=WILMTRLNIUV7tSrbwD1BH2h9JzoHywG/nbRD+CGP+xKsRt8e8ZGRB/1ycnaVOGl1hF
         J1kIuiYkVVhmrN2q8+hY3xruzuISnrrn3ETsODwtUqk/UpeawR1Gcc8BGEzDvGK3ha0E
         B450aBGU9Af3V5fENer2cVyYfcySrpZfsr0WQfSHNuDKwlEVIVnqnDM2h8uork7zth9X
         rxT4EgRka6IqEqNLyA8mvUIgwzr32PwaBsW2jdtUXsIM70J4jsvknT/wxnBpaGB04bGy
         10i1qmBtrFQGhqDvo/CqwheFNCjRwWQWBlL8YNw9BYIrn6VDHdCnvMt8JU430bsStP4l
         OJ+g==
X-Gm-Message-State: AOJu0YzZ9Z8PWkIKETmuIjCC1/8LvGu7SGotGylRAcDzj+TqDUHEDKzo
	/jNMfG5Z8trlykXVxKLfK1DzIa6m6xXdcwt/TqAlrgsm71AV2yVvVUnUxrvgXOw=
X-Gm-Gg: ASbGncu/4it5CyVP4DlzGp6P/4sB5Xwsum7V9OnRiGCbhootowrANktDGaxXT+/i5vL
	G3rQBksZ3xdBnCVDR5TXP6mM+H9HzgvVhqOFgwKaJcf38E1huZhcryxHEaJM6Nt+IvNrUofEtUH
	8MBLxxEBdZqXYyrvNbPJgJ3fiCyIJPa/wcqk+vQB33NP5Zrq9q9MVJR5IwtibQ74VHylMdHmGYz
	J82+wC8nA2z6tna8H7wI3lbqZw7f2Ussn3YLv2xFPJ2qTMkfxM6CdELqQGn8a4N7Q26/NIkLGJo
	b3xyCYqrcSyCyOkS20gpg0K2iTrgML9121Q=
X-Google-Smtp-Source: AGHT+IEDPnwcu7h+ElXTqfyvSsHEYUOyA3lbFZXVCKxjr1xKnSJc9XnED6kHQjXE8ZQpcgdam5tq2Q==
X-Received: by 2002:a5d:648a:0:b0:385:db39:2cc with SMTP id ffacd0b85a97d-385db3904b7mr224126f8f.1.1732808190484;
        Thu, 28 Nov 2024 07:36:30 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385ccce7859sm1996147f8f.0.2024.11.28.07.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 07:36:29 -0800 (PST)
Date: Thu, 28 Nov 2024 16:36:28 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [PATCH] arm64: Fix sve_vl() for build errors
Message-ID: <20241128-40f8c0b30bfe9455e1a7d982@orel>
References: <20241128150002.2424523-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128150002.2424523-1-suzuki.poulose@arm.com>

On Thu, Nov 28, 2024 at 03:00:02PM +0000, Suzuki K Poulose wrote:
> commit 5b9895f8a5d9 ("arm: Fix clang error in sve_vl()") breaks the build
> with the following compiler version, as the "rdvl" expects a 64bit register.
> 
> /tmp/ccGJYtuC.s: Assembler messages:
> /tmp/ccGJYtuC.s:2165: Error: operand mismatch -- `rdvl w3,#8'
> /tmp/ccGJYtuC.s:2165: Info:    did you mean this?
> /tmp/ccGJYtuC.s:2165: Info:     rdvl x3, #8
> make: *** [<builtin>: arm/selftest.o] Error 1
> make: *** Waiting for unfinished jobs....
> 
> $ aarch64-none-elf-gcc --version
> aarch64-none-elf-gcc (GNU Toolchain for the A-profile Architecture 10.2-2020.11 (arm-10.16)) 10.2.1 20201103
> 
> Fix this by switching to use "unsigned long" variable and restoring the 64bit
> register for the instruction
> 
> Fixes: 5b9895f8a5d9 ("arm: Fix clang error in sve_vl()")
> Cc: Raghavendra Rao Ananta <rananta@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  lib/arm64/asm/processor.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index e261e74d..e5b0ad10 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -154,12 +154,12 @@ static inline bool system_supports_sve(void)
>  	return ((get_id_aa64pfr0_el1() >> ID_AA64PFR0_EL1_SVE_SHIFT) & 0xf) != 0;
>  }
>  
> -static inline int sve_vl(void)
> +static inline unsigned long sve_vl(void)
>  {
> -	int vl;
> +	unsigned long vl;
>  
>  	asm volatile(".arch_extension sve\n"
> -		     "rdvl %w0, #8"
> +		     "rdvl %x0, #8"
>  		     : "=r" (vl));
>  
>  	return vl;
> -- 
> 2.34.1
>

Pushed to master.

Thanks,
drew
