Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F33025BF0F
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 12:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750854177; cv=none; b=N6kv41f0Emuhehcu0NA+SLCOoCwIrtCjdfrxkXZdM8vGumQE8rujfzOx5+qe4Enq40sfi+UmO3vXHc0awdPHhlwwHMIDp3d7p83vqEOJNFfx4PUMRaHnIIoJ5GW1bFU2o+0tJt0OdoNSJ9Dei9znAdKNljKgrtc1wUsP5b6dvt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750854177; c=relaxed/simple;
	bh=PsQfHCEp6q5tQuX0x3zpsjWToWnh6oGziT5EQjTRAgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h0ZRBuwl9lnRRCb3W5CptLfwzrbZn/Ymn7Uyu0ZZxFd8z5zaD9XsVIYiqODksZaLu0fOCyaAufCsUQhSe1knLm+xGR4h5LR99qOBPaGWGYuwZvlukrXf1/OPoU/oHyIyXXxmgeu+3MfxsFLdfq3xaYvffNUQnu5BpnTz3t348tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hp75OQMI; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hp75OQMI"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-604bff84741so3155094a12.2
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 05:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750854174; x=1751458974; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OiG8sr1KaclHSbf6egC7naRu8LsxzyFDngHY6EqehU8=;
        b=Hp75OQMI02QY+5XthQ35N9+Iyft36E5yY59/nvxVTorXS6SGOWBKcaXKxMMMcxmTqa
         uHvjT1VoZHFPb7CX+5ZY2NcIb+c/Y4d3EUeLp/Q+1sQcJiHAXIgG4Dw9RjToU4E2Zc4G
         mpHk++RqEjSoELA1RYCi/N6339rWYnGakwVdyqrscYP1Zsp/2rTU6cB+r3iOKjgc3b33
         K0Vy/5J2t0J5tDNbVH8VOZPKBmIs40Ub0vPLZp3LQi9k8b0AnLLZX364V5odyZ96L8m8
         PISn1dVaOctzGmDO62qey9sDTBE9+JTjMSWShlI9IV7yVRp0qCRG6M3tkTiwN2fkt7vh
         FTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750854174; x=1751458974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OiG8sr1KaclHSbf6egC7naRu8LsxzyFDngHY6EqehU8=;
        b=an9FB8gGziLHi60k3DbhQmLm/KAUIIV+4ffddStybLTud7Z3jnhejFw1tQe6N5RqBu
         BTrgWv4Wl7hoNl49fDdmH4oblZBP4lBsUnSwut3opeY3s07oUl21VsE8E7thSVoEqPuN
         YQzvZDrMUuIoEin+SXAf92Fdalh4u9IA7IxiGI4CUiMHMbA5q1SREFj6CpLtzBKfSwj+
         MvanRz5SRnAEz2Nzr/QaR3WUp5v0r2Grtsl0EmO/dRFyDxa9C+/FnwD50NlLADvTQ8ji
         IsnNTmP1PxIWxtZdM/Lm6s1/XdjaOxakipl9SfuvCYBWgQanI+EuEwaj1SNB2cMZIKqy
         Trmg==
X-Forwarded-Encrypted: i=1; AJvYcCWzSWjwCmjNwsGn+Rv8pX8I49l8gB/7T5AmVkw9sFHmgiTOcIdpIKPjEzFtngXCQAN7obgPogI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwN6zEm4caOMBBDQqHdMLw5+e0BPb9FBj6ZYbXYh47aoq+iAe2T
	Pd6CrIxWbvP4HcfOqN4cXhL+QnFzoZbTbTWYgnb6EgYhIrwvk9sIjwP2PZ3ybIQcKw==
X-Gm-Gg: ASbGncsGKpVVBOlyLXJHUkgzotMR1r3rRnG0JcsGXbHXWxwI3wyW3hi9+qmm/T67baX
	6eHV/VrOsLjDyXcMaooOPv98pLSf392ThPVU+H/TckLMNPK6PZoTrBZ+5WpqoamzJ8sf9zuNsLq
	/mcbzU+6dTPzPK/Zof/Swg7jUqz6YTwb0Ii2nX1FZFxcWckUou6JH1bIf12OzjPP3szEiZJEAjt
	C1/SQwJxAK7U7uykdfXZM0nzAuycOLSfcvDHTqMoJ0/WMtA2fFEC3O9FTPZxByV9H9MYisi7HQj
	4wYGW8a9J4jAYG723f9PAS0/c42grkM5/4x/8/6sccUjKl1tccjShBmTm975TZN0rV9Co15CYnV
	OHJ7uqkhROT/7NEN9OrJK
X-Google-Smtp-Source: AGHT+IGcp1aoFc2EzYV/tl3RR8TA0Ug87fzOHVR52rNGNEdbDQoI9r/5HqWjJE0hOyK5C5jflubayA==
X-Received: by 2002:a05:6402:27d2:b0:607:ea0c:65b2 with SMTP id 4fb4d7f45d1cf-60c4de78e8amr1953498a12.31.1750854173425;
        Wed, 25 Jun 2025 05:22:53 -0700 (PDT)
Received: from google.com (8.239.204.35.bc.googleusercontent.com. [35.204.239.8])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c2f4681a8sm2391073a12.38.2025.06.25.05.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 05:22:51 -0700 (PDT)
Date: Wed, 25 Jun 2025 12:22:45 +0000
From: Quentin Perret <qperret@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix error path in init_hyp_mode()
Message-ID: <aFvqFdwNYI0-3zWY@google.com>
References: <20250625113301.580253-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625113301.580253-1-smostafa@google.com>

On Wednesday 25 Jun 2025 at 11:33:01 (+0000), Mostafa Saleh wrote:
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 38a91bb5d4c7..5bb36c3b06b5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2344,15 +2344,22 @@ static void __init teardown_hyp_mode(void)
>  	int cpu;
>  
>  	free_hyp_pgds();
> +	/* Order matches the order of initialization init_hyp_mode() */
>  	for_each_possible_cpu(cpu) {
> +		if (!per_cpu(kvm_arm_hyp_stack_base, cpu))
> +			continue;
>  		free_pages(per_cpu(kvm_arm_hyp_stack_base, cpu), NVHE_STACK_SHIFT - PAGE_SHIFT);
> +
> +		if (!kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu])
> +			continue;
>  		free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
>  
>  		if (free_sve) {
>  			struct cpu_sve_state *sve_state;
>  
>  			sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
> -			free_pages((unsigned long) sve_state, pkvm_host_sve_state_order());
> +			if (sve_state)
> +				free_pages((unsigned long) sve_state, pkvm_host_sve_state_order());

I'm a bit confused by these extra checks -- free_pages() should be safe
to call on NULL?

IIUC correctly, the actual issue is that per_cpu_ptr_nvhe_sym() will
dereference the per-cpu pages to find the sve state, which is entirely
bogus if the per-cpu pages have not been allocated. Now, looking at
this, it looks like the bigger problem is that we literally free the
per-cpu pages right before the sve state...

Should we at least change the freeing order here?

Thanks,
Quentin
