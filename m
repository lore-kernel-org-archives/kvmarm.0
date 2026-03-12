Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C97A351C24
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773323568; cv=none; b=heeVlaeCaM5hdenvNR2Vm+y54i93Uz+miYHhkWI3cmmlnAhbImLDfKQpQqwysNRJZ0jJn8Qf03dCtZ2PrfQNvhCkvlnSVZJ6IzT+mrOtajbOPQxBX+2t33MlLz9dXsiIle1mzXeRU6Wt/HSgkhJ6gViTIhiAD9KZo0ytYYBuuIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773323568; c=relaxed/simple;
	bh=A44E9QwVaoZrC73rlOiiTtCChj8D0zRQDarQZR5GGhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7smruJUgSWXp83rs328LMKaWaPtlO7anTZ4HmgNFZ8Cmr4TSz/zI7s3M98eXZlr01BqTSSLUDFLBm0fM/6ALTtdqjVIRBiAAODMD9ps4UPsuYjp5xSWiehKxz9gABUA1yE0h3ofNvwFpKF3DfDoSTTyLFmqkbDcE8qF6P2Ooi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e5/WqBi+; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e5/WqBi+"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so10260865e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 06:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773323564; x=1773928364; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4oHjwSYdMo6wbQaoARBQB1p5khSJ3cYUmF/TszysH+k=;
        b=e5/WqBi+BUrLLSPC/nsx3513bKRrqvd0RCjEPosCVy38mkNvfxoa2Br0qfmz0uLkzp
         6kuPPfnGbv7FuE3LXjVCW5xJhuFwBFM6dPlphdC6JbgdOUQS/WMOHiiGSbWlpnWlF0zQ
         C91RAFw1PE1gl5qD1Qtl2Dh/X50IAGY8C6XyyM7gf9moKjshpZr7xR71CtfrstMzcscW
         p8ypimxR8yF05L/QXd56x/uqvO+z4N9frSqMgSrfiZM6gqOXDIoB/LL5QZCzfTcVp00f
         r3G1z3+6vntUvQQjmCcxyghrnCkeM35xXcFeG0L7T2XZ56HOLd2FrjndG8wz64vwkaR5
         4Gog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773323564; x=1773928364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4oHjwSYdMo6wbQaoARBQB1p5khSJ3cYUmF/TszysH+k=;
        b=Utj6YxrgTP+bexMkXhc+/bQKO6lLDMDrW60BKTxT3+G9vVKfmD6xR3QdFZwyCbLjcL
         SAA1ulqvLk5q7Zq8R/mykE5qLWanRHGc+J7r11/0QrHCy0/3ks+dC1vsFQySEszU5OWh
         HE7f5F9L9iKV9QWQjNYGTERDtl6max5FCWxonsUuJNx0SDiy/W/JKRbrwfA2AdUs350Z
         Im75g9M7aONjUdA/uRIyb0XcYHMr9F6/JCbj9Zb2CldetB1ZGiioxQWDU1XfQl0BXYaM
         faRvXQXEZQCFJaOfnlzpsvyXo0YMS05pOivTnkEsC3GGhPbI+Upn40qWYPP1U1uXly1w
         FUPA==
X-Forwarded-Encrypted: i=1; AJvYcCUwf2kdspFil8P/G4ijVFBjKmfch5SfVe3eoXlEliDXDn0yRsHaYosy2i/9YrwM1zbbUstBVac=@lists.linux.dev
X-Gm-Message-State: AOJu0YzP4hbi01kHkMhl0y8JNcZ9Dv5J5hyQh9caAUlRH1Q0RlfA4dsI
	jlSnmpWwrgMWi9wTUQsrRnnAolqmMlb8j96GQcNbdDaKYyKaB0a7LEbP0PFIcyWAhQ==
X-Gm-Gg: ATEYQzwubke2gcIK19txd9JDaHCmPcrDQqjMN6WmaT1sF1aNOu1nPzvuZAwt50bR6ea
	90HzXIoKVUhMCaPbumIHhUrDXRGD82m6kXEx/HMFBTO2N5WJolewawJzoCyZMD5Qe5DZB6XCJla
	l0yJMMhHLIbDRDBAYB5TjGM38XBq/1mL9JK38Al9oQna//PFF1sH/ATEup+bVUrSieZfR12bmUA
	hG2+H36TW6byP93Q4WOEOcbi80KWgTAtwnIWV4EEqHCaERwx4S0DLScdxVeGPjmK/sDB0sxcNxb
	WEmUUYwBMA2vRXYaP+ZKX73hkhfgs3W+ydaD8DOicz4xEEnvvW5PAgZCYshhPEvNIVXiDv2NA9v
	LI8psdi0WZqEfPjRyz3vHBg2rg/hsVUHkyiQZmlDfhxHeKTfLa5ItrTd6bh7lx6ysJXGNT76TCh
	yi375G0e7pBrdJvMxYU8dMFQ7nxjWSnFUp4+dLEAgGfUb3NWwVr7aakr/1QTIuAqkBFq4=
X-Received: by 2002:a05:600c:c4b7:b0:485:419c:4eab with SMTP id 5b1f17b1804b1-4854b0a6c24mr109977735e9.6.1773323564047;
        Thu, 12 Mar 2026 06:52:44 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b65fe27sm140260795e9.9.2026.03.12.06.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 06:52:43 -0700 (PDT)
Date: Thu, 12 Mar 2026 13:52:40 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: arm64: tracing: add ftrace dependency
Message-ID: <abLFKEhE7XMXbTWE@google.com>
References: <20260312123601.625063-1-arnd@kernel.org>
 <20260312123601.625063-3-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312123601.625063-3-arnd@kernel.org>

On Thu, Mar 12, 2026 at 01:35:44PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Selecting CONFIG_TRACE_REMOTE causes a build time warning when FTRACE
> is disabled:
> 
> WARNING: unmet direct dependencies detected for TRACE_REMOTE
>   Depends on [n]: FTRACE [=n]
>   Selected by [y]:
>   - NVHE_EL2_TRACING [=y] && VIRTUALIZATION [=y] && KVM [=y] && NVHE_EL2_DEBUG [=y] && TRACING [=y]
> 
> Add this as another dependency to ensure a clean build.
> 
> Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm64/kvm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 32c7a4f85e75..bcc87f9dad33 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -78,7 +78,7 @@ if NVHE_EL2_DEBUG
>  
>  config NVHE_EL2_TRACING
>  	bool
> -	depends on TRACING
> +	depends on TRACING && FTRACE
>  	select TRACE_REMOTE
>  	default y

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

>  
> -- 
> 2.39.5
> 
