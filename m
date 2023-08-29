Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F1F1399
	for <kvmarm@lists.linux.dev>; Tue, 29 Aug 2023 08:03:13 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-31c3df710bdso3231769f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Aug 2023 01:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693296192; x=1693900992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4gXf3eI1QYqFSBc9LYV5znKy6QYEcZ1Llv8J9Br/30g=;
        b=R4nfeAQe8389sakj85amigGqLjaTc5JmMj9kA/xecvE2GXDEaoUHkRK0WyXB3oI7pG
         N2Y3YUgKsb48TcEPLCZ9o2myLSza9uD5H7rEhmA8xr1ZDbiwGBiwDlqztMO84VEimyck
         0lM3IQiAYPWmW0gii9vGagavXCxeBVCYRx/jLcwbJRG6c8pMvabk5XOr8qWhlz/YF6tG
         3DY8AZUF9Gr0/dCw/TOgKsY32OYI9Bu9Jq1AqI/6TUUIv7fP37wD1kZRWIlVjow6EG5m
         nRV/+5QkP+eTrpPmQngb/iQ333LZWTcLuU1R+56qteSoUnZTu9scy5xqs4m6OOx0tvyU
         CNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693296192; x=1693900992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4gXf3eI1QYqFSBc9LYV5znKy6QYEcZ1Llv8J9Br/30g=;
        b=ALraFvB1vEqHWptGGzZY0wPu6svJ69qw7SpUt+DpFw1nWavrZGz9W10ByPrGaHcggg
         RCJfy49UX7UPJURuA9QClq7o1tOcTTXUya0S4vvUyZpH/GKdzEWBbXFFLYUgG6vCmQDr
         EvqwFh1P3flSnGktT3WciPTR+vImGbPBuN/w+GHwlhT9jptNVg9pywpqmBtqW4Z9xMsQ
         vIgOLceB/XVewAGizH1qi7LueuN3DdlI3oAx7T1+fOhSkiLpj4IL3aDqC6Re0ahM0va3
         6cNHt6pFgaYIdaBnYT+gTLQcEwHq34FH/uuuWfMneOLSFqXKFHppvrx5j/G4ChWfQWSI
         aB+A==
X-Gm-Message-State: AOJu0YxVVikvLnEuOYA8g3HYop8WhSqJpK478uAyDXzVhlIWAXESYbb2
	dNcXGjZMQM8B67zry1d2JtLipg==
X-Google-Smtp-Source: AGHT+IGxucRA+7L1hdHwgNAnEmkSoW5Bvkr6fFVHqCl2UnKHxiBF8oS42kFwTnL8bpzXsEtHLeDh5Q==
X-Received: by 2002:a05:6000:229:b0:31c:8c93:61e3 with SMTP id l9-20020a056000022900b0031c8c9361e3mr4756583wrz.60.1693296191819;
        Tue, 29 Aug 2023 01:03:11 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id a17-20020adfe5d1000000b00317f70240afsm12819304wrn.27.2023.08.29.01.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 01:03:11 -0700 (PDT)
Date: Tue, 29 Aug 2023 09:03:05 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] KVM: arm64: Properly return allocated EL2 VA from
 hyp_alloc_private_va_range()
Message-ID: <ZO2mOU2Mu42QKlSU@google.com>
References: <20230828153121.4179627-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828153121.4179627-1-maz@kernel.org>

On Mon, Aug 28, 2023 at 04:31:21PM +0100, Marc Zyngier wrote:
> Marek reports that his RPi4 spits out a warning at boot time,
> right at the point where the GICv2 virtual CPU interface gets
> mapped.
> 
> Upon investigation, it seems that we never return the allocated
> VA and use whatever was on the stack at this point. Yes, this
> is good stuff, and Marek was pretty lucky that he ended-up with
> a VA that intersected with something that was already mapped.
> 
> On my setup, this random value is plausible enough for the mapping
> to take place. Who knows what happens...
> 
> Cc: Vincent Donnefort <vdonnefort@google.com>
> Fixes: f156a7d13fc3 ("KVM: arm64: Remove size-order align in the nVHE hyp private VA range")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/79b0ad6e-0c2a-f777-d504-e40e8123d81d@samsung.com

Having a hard time reproducing the issue, but clearly that set is missing from
the original patch!

Sorry about that extra work.

> ---
>  arch/arm64/kvm/mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 11c1d786c506..50be51cc40cc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -652,6 +652,9 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
>  
>  	mutex_unlock(&kvm_hyp_pgd_mutex);
>  
> +	if (!ret)
> +		*haddr = base;
> +
>  	return ret;
>  }
>  
> -- 
> 2.34.1
> 
