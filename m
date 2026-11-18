Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998487;
	b=J+vGfx/ud44hQ6MlOKOSPvQ1H942gbEINHSuVDQ2OjaosksQbL9eo99r4qjhuCPDQqSv
	 DXEd9WWokcKC1sok6297BCTHSqkO1Li6ncEJCcjMR5+JdKIbDlqq2fqj6GnwoRTeGUw6e
	 76hNxvWAUDSOuWWSvTbOwvqahCyRPUtdLwUIuZRh7Bzo+w/QU4wZxIF+XZ/u/c3LC/+wX
	 Yb1dKHka/JMX2pb0EZhQ1twESRtMrgIbK9lRXyC2EmwQemzj43RZRvoQGlMbstGDMNdKh
	 EuiDW1B51CWJqBgkRJ4ENe2qReIMNVJNiTDS1PL2iya6JII8SET0unuRxK16lh+Hhhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998487;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=8DddB4BOu0Fwu4SIijc7HO6ywtYEmx0fPwUuOrXpjQw=;
	b=yS8XhPq4NQRXsXu8fLId3y1xAqW7lPjlYT0bThP5bwqaRPtH6e+bI38y+bCxiEk/g++N
	 mfT4mMQ4IJOFb1q3Hwg8D3ddquWzi7I178Gno0vqRGmhkC5GRXyuggtNDjBkUqN7FoAsD
	 Wcl1JGfOOSlqHs2K8XVwQZI+eVtRIwsASAiv6j0YVJE2B5TYc6cKatLd/F0WU9aoW6F8d
	 GQduzec9mS7QQXOT6oPq7vq/tZVmflPg65vglJtJ9+MgMJdilO6/L6/jSnKGfpO2Cm9Un
	 i1UHOCBjZZJ1hKlGMygCh26tEC8rhN2jslznKWLhYcfsfzwe003b9piQ7Dop79KYEZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=YTlHwufU;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59630606A32F
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 10:41:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59630606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=YTlHwufU
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-490f38e9688so472723f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 02:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1794998486; x=1795603286; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8DddB4BOu0Fwu4SIijc7HO6ywtYEmx0fPwUuOrXpjQw=;
        b=YTlHwufUyATh0kxqubTeQNAwP5J0ZfLw52oUUT8ZZa59QEolopEy8I83eXUvf1DJNZ
         CjGpfWNgG4RoJacE4ySTQn4rlip+ncx2OpFoC30Ltzj0Wk5+KK7sSGwezAaQJYEkjFj5
         D8Xt85eUrSn7158HUlM6cqD/6S/0erWHiDhrJgTgpnIhZAf7aNMg8jXae1T0ILvDwX6v
         GJiKLlwS5ruB8wn9dPDk2oYxiRHWzpyGVY/mUf+yFoMz/rQYzvaOXLCur421pfSNKfe6
         M0jOh4o8p43OlJrf8+/Mx6neN/exhhylghQIueZKGUVUNc04NPrf1OQGmPskKmNgfnga
         Y9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794998486; x=1795603286;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8DddB4BOu0Fwu4SIijc7HO6ywtYEmx0fPwUuOrXpjQw=;
        b=j+N4dOOlYyvtH0Cj02e8jVqjDtYBE/HUOZu3IrO5UYQeEWufjQJA/BftWAcTzqJ+tr
         Evx9Ltqe/BHXnS+SRj2LZ87Q9OJiVj4RNynkWKF0LNRZPcOTMbPkg2gxq+xzjjRpcvXP
         4dSqbz9NBTWM1x94iP+v8SqWZKrPyl7xaaKrOK4C9JXTR2j6wK6XaO+BoBBgSEJjHUl7
         tjgdDZhTJxcSgLMnJ7EPlQoH4TBSS76NsueXfLREVmwYSx2YyTmx3P7fFMnoZawWDEBE
         kQGl+Z/TusrLYWJv5osUjkcQDvSyUlj5TgVjH8LlfevQqs3IYe7qFlTIMm60l+u7/6Yu
         3ekg==
X-Forwarded-Encrypted: i=1; AL+hErGD8QF7mdqfw5xlca2reBvvPHn7MfLu3Az4h9oQFQKpoL7LQIvCEQ4pHcP+C27gFW990iOaiFc=@lists.linux.dev
X-Gm-Message-State: APuU4Z8cE+aJZal29amVRQo4sIKrqGCzsHziQoBXa6L+ZuFdRltMUDdR
	SCELfzzbb1HJeIu8l4FmcciP+sHzd7WAebOc3+735tufESkE4w3Yx21ZJAHDZWLBhF0=
X-Gm-Gg: AZFdTZfHU9VYCkec3zeD5khl/mQGxIusGWR5iMoW235uc3KFnooj6RF9yhdsUehSDdt
	yb/yvhza8WdR80rWGOECU1vJUEo94XLNUf4Pjig6Aq7V70Dts7GEKboOymKffb4XtRPngF0NibJ
	esEz69ftTtw2tAt57PdxyzFNbQWwz5Vxa/r4Kv3mEzpYOAQlooxQj7u0z5QQ/LX+bUhkmpsmcHm
	r2oTc7Pq+XdDunZq5WOYHc5gZB4pBaAzQaVIsbcDCfhvKdSPRoIk8lYmaiSFMm4q/7ity44D4fa
	iHkygCQG0WN+scrq5Q6qxl69AsDSLw8YHub66PYzh+Uia+n23MB0rdz5pa4rY+c8A5BpEhUdH8R
	rwU2tfHPpmuIju0GHuEhqAXrxRDP6KN6Nr/NuipQa+eZ+eCPpCr7yr+5Exr8VLBUvTBEzVP400k
	ZI6tsrKyyYa2Db9dpdkETFkkcChbUMKFadCkAudhLdxUp1KL9tTklYWUoEB9YrtbUeDnvQ9Psr+
	Ihpzx5RFjnZptoT35y/Oc1IipTfQFzO6bD7iLuaEdi5+7/xvSUvd77IccLSB2/yTxGU12kDikFV
	3FIh0nQmMPPD3/OyvKMSwvnTCOyGOQXjius6vAIc
X-Received: by 2002:a05:6000:2489:b0:495:b427:1e6f with SMTP id ffacd0b85a97d-4a62d6d71ebmr4953529f8f.0.1794998485425;
        Wed, 18 Nov 2026 02:41:25 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a6573baa9fsm4323892f8f.57.2026.11.18.02.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 02:41:24 -0800 (PST)
Date: Wed, 18 Nov 2026 13:41:20 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix NULL dereference in
 kvm_inject_nested()
Message-ID: <av2A0FxSab9P3eMW@stanley.mountain>
References: <avsH0lxpLIF2Ug64@stanley.mountain>
 <86h5hg1wak.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h5hg1wak.wl-maz@kernel.org>

On Mon, Nov 16, 2026 at 06:11:15PM +0000, Marc Zyngier wrote:
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 5959bbbfa026f..21cd872ea394b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2007,7 +2007,7 @@ static int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
>  static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>  				   struct kvm_vcpu_events *events)
>  {
> -	int i;
> +	int i, ret;
>  
>  	/* check whether the reserved field is zero */
>  	for (i = 0; i < ARRAY_SIZE(events->reserved); i++)
> @@ -2019,7 +2019,11 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>  		if (events->exception.pad[i])
>  			return -EINVAL;
>  
> -	return __kvm_arm_vcpu_set_events(vcpu, events);
> +	vcpu_load(vcpu);
> +	ret = __kvm_arm_vcpu_set_events(vcpu, events);
> +	vcpu_put(vcpu);
> +
> +	return ret;
>  }
>  
>  /*
> 
> and be done with it, avoiding the fast-path bloating altogether.
> Unless you can spot another path where the vcpu is not loaded, but
> still requires the injection of an exception?

I feel like this approach brings arm64 slightly more in line with
x86 so I like it.  I'll send that.

I'm still redoing the TCR2 changes so I won't send those today.

regards,
dan carpenter

