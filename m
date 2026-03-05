Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC4624886A
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772720419; cv=none; b=sAIdBblNpIMdzhfztEpvgnq+1Xr03ceNWPSFMweTvETW/iVFkSfnXwQTeim9S8gYlULCklL5lL9zGI3YGXlN/UmLhVUn0cTTCnMP41DKrnARYKn8dS0k3GA6eaOCfM4GZy8027wrQEQ9FUiqVNbalAnzEV49KgcoEMYwfaEz7+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772720419; c=relaxed/simple;
	bh=PwCYRuwsKmQUe+2zlK2nZChMpzwmoFOf29G9MiF8OBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pv5K8aOW9+UB/l2ifmxSXBNGY6R9RWyToZbUiNBdO+QoYH9IYYSag9b3rVST+Wsj0M+g4wNQEY6MUKbqUyWroMhwSBP4FkNCF7Z9YE2OR9hpB67ISUCmHwrhHVwH6gan6aqI7kC1peeX7Qi9L+HLrKM2o8HjK+H95znlFkAecc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BwsKdZt0; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BwsKdZt0"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59e4989dacdso2636561e87.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 06:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772720416; x=1773325216; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KAuFRx7gtOPZDHLYd8gki/p+Ss0pYYeA/wECrBUdLlE=;
        b=BwsKdZt0SnsBfERx+tDBOK6wbWAgx8CKrS5KMAlcCrF6LLkmg2mOOcUNZWlZ0KAgE4
         9aQ5Ja6Rp4MK1d6mWvc7ibbcT5NTAhE/rE19zlbSnQSJ+qeg7sKdfOFeThsGiSRLIk5V
         BAOGlZcNp34dZdQpgUEvt60eTht6ghUeQM1UeojpkWEBR04dIciWerOBmoNFepViA538
         RU6Ma8hwD79u/LvNu7GSfqJ8Mb51+OIOhuGc1KlR/+2n1sNtWfQjAtB0jP7hKoIfBIn/
         IgWM0w4b653k8ipLgeEXzJjp6Kgd4k8mXqF7fV29D1i6ynV9qzsSFwDcfKgc1ML6sVbn
         C5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772720416; x=1773325216;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAuFRx7gtOPZDHLYd8gki/p+Ss0pYYeA/wECrBUdLlE=;
        b=O535dEJozdpumZlr9WdqaG6b+5LGpJdrOJ/sd+cYZKF91NAMScM+djFnjFCTILtd98
         VXWIePoLqqbgtnYmppvSdXaUrNz774Ao2NbvaFr0JEiuxNiDR7pssS56eQHgLsdFxT3x
         3fDyJ/2mV5TYCqhBDEs6hCpLv0hBBhWrJ6Wk20OYcpTLC/fhcefIfX1JRcpFXbs4Ms+8
         QA0+NbDxl4Wx2mPci8DMy81YVJ1nWJgixzYT87o0POCHvpkSnbmN7Hcji2fCoy5gTEyD
         4tWXA9WNJAZVFo8/4TPgI8RgeV22wzlhmHoJVdEAv7OyeEsCcRgvefYy/6luvZ3dodEV
         5hHQ==
X-Gm-Message-State: AOJu0YyOi6wLGaBNWIJzuYfsXonbvMX0ZQcEYqClAJb4OIkZRY/N9FJs
	alUOAiniGtIgBrh6GUliYl03vcHNfSUOys9sIVM4nLrAebIYn9k6StYftxSx7mc5ew==
X-Gm-Gg: ATEYQzzItfGre1SRDFx9M16cRUD0Qtd/z6sgr/c/GHFf0XcHwVrZWNF6LSeU970jtOx
	oNqTpD6lcHN0XYLc1+22q8KOv5vTeV0yvlaO9TCgJ7Yf9Qndtir4u8bDk6vDC05ceUHD9cVqhvQ
	kPhsvvlJTGNVVMrQ7lqFIFVY1YxZ++S0j8o0Fr6Pw6nVi74e3X+3A3CJmzyMyW9+JQ+vZUt+iQU
	dZCHZaRUDoc9iIhY+8npEozPp2VTGMISoGevVsZPvTlgHJuU4X9ZFCAKtLuxSxp75Dxb1I9vX3t
	c+wFKgB9hTfx1I0NQmxsjqTI+B2KufePvUaiHv1oLqdUR1r2nEVGqalt+AYgzZWzOXRroOZQ2gM
	H03ALz9dHB3GxCBsamqQt+6OE4TwkmbbxAxQYZlzJ5CrnjdMtzd6UfIQNFAKeMmSv1RyqFYOsvR
	nR3iEQDTLZjDKSVrncGADUedQ8/qrDhRnqwvzR8D9sVAJ6bF/wxqyCkqQ=
X-Received: by 2002:a05:6512:145a:20b0:5a1:378c:11e8 with SMTP id 2adb3069b0e04-5a1378c1480mr17473e87.14.1772720415482;
        Thu, 05 Mar 2026 06:20:15 -0800 (PST)
Received: from google.com (27.69.88.34.bc.googleusercontent.com. [34.88.69.27])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a13555df8csm249863e87.25.2026.03.05.06.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 06:20:14 -0800 (PST)
Date: Thu, 5 Mar 2026 14:20:13 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Fuad Tabba <tabba@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: pkvm: Fallback to level-3 mapping on host
 stage-2 fault
Message-ID: <frvqntoya3r5by3vx75eicvggmjnkrhqkxn62ealjjiuuuiwyw@rkngsfqxkxbn>
References: <20260305132751.2928138-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305132751.2928138-1-maz@kernel.org>

On Thursday 05 Mar 2026 at 13:27:51 (+0000), Marc Zyngier wrote:
> If, for any odd reason, we cannot converge to mapping size that is
> completely contained in a memblock region, we fail to install a S2
> mapping and go back to the faulting instruction. Rince, repeat.
> 
> This happens when faulting in regions that are smaller than a page
> or that do not have PAGE_SIZE-aligned boundaries (as witnessed on
> an O6 board that refuses to boot in protected mode).
> 
> In this situation, fallback to using a PAGE_SIZE mapping anyway --
> it isn't like we can go any lower.
> 
> Fixes: e728e705802fe ("KVM: arm64: Adjust range correctly during host stage-2 faults")
> Link: https://lore.kernel.org/r/86wlzr77cn.wl-maz@kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> Cc: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 38f66a56a7665..d815265bd374f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -518,7 +518,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
>  		granule = kvm_granule_size(level);
>  		cur.start = ALIGN_DOWN(addr, granule);
>  		cur.end = cur.start + granule;
> -		if (!range_included(&cur, range))
> +		if (!range_included(&cur, range) && level < KVM_PGTABLE_LAST_LEVEL)
>  			continue;
>  		*range = cur;
>  		return 0;
> -- 
> 2.47.3
> 


Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
