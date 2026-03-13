Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9C931DDBB
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 11:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773400063; cv=none; b=ry6TQz9DAACRLiIIMdbkY0/9c4/0u9eqHmEQaHw/ZPa1C3rHwLT6XYgE9jYBxnP9B8jYmxiXGD7prcjtQ1Lr1mzFr7AxvxXS3cfsQ+xN05pb72NQ9w4MnPiu7n+Xa9e4E6KQLsg9xy+pWBp+APrUzYWEQNFcrC9yi91/9UjcIG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773400063; c=relaxed/simple;
	bh=pD3QLCiXs4+NxunzyQ9Zzrc1hNhjdRO9E2U9/Xo57Es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FikF5RKuA2lTp+4zJr5akCYCw/NHxm/cvaF44CPGduYSnGTW1/rLJufvwMTLT7ne41qVx1uzLSLtC7kroW5M0HkB8uazOdqbfd4COr0Ea+wp2GTGtV+z8XSqvmg0gKJdIwXbmLb33cgh4r7YLSzxqb06T6gg5XteZn7dzw0mGPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MBCldvJ9; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MBCldvJ9"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48557c8ad47so6521905e9.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 04:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773400060; x=1774004860; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Treo8+ILHQ1M2ArKnaNpioch/szegt3Svu0aZTIh4xM=;
        b=MBCldvJ9CVpGLgLbV95uP5tddBe7/UonSLhZ9DXTvN9EV57bqSbmEoQ1GX7wehVRsu
         J5ry1/EyyCpuHnifRZhdKqoel2s2u05MZAwgrINJXCTLJAi4W8hgah+UN3OzR7lgNtRF
         g0zE/HY3F6q9LUOyVyODmZCY1R0ZbuEgI5VM4L3t+LxAMSZQziFBZnFET8PdFyzt7f+T
         lnrSjIN6fYcv0riKbm4RQ3y6A7uvUd9ldqT8k488AkHJrtvknuScr7xuSNZvLXmoVaxg
         /dul8K7P8V1TtWWI7/9LYxwwlOgduZhaKuPGdVGPXQ4SlhjyqjgfQlr49WC20zJeWVbp
         AoDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773400060; x=1774004860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Treo8+ILHQ1M2ArKnaNpioch/szegt3Svu0aZTIh4xM=;
        b=mxHJjKhUR9Yasdb9ajrjO12JLCec5/hdSmIZfL6PHfkljczH/27ZiGzSR3M8uz2dlg
         L31h9eEPmG5p0H2Km53N6skB8RaSIcJyP/kQJVPIbvGPXrFGYRe3hQ8TmNBQN/Dp7HPl
         YiIJbq+kAqBe8Nx/VZgQDZJP4RY/lKYrQv8L40lVFPnYHOnDjxZv0n0xjYHVV1BtIAM8
         iXz1qrjdtUqUf1He/3sCPrIWWAnbbCH2QvbKIEXBa9qo9cE+eDC+D9gOPqHxrKSuNg4o
         yhHMeavyvgSR8CyKULS5P4ZEUsxi45/VdGb95YEWGximYsSULmkMI9yiY+Go8qQ6gjFf
         dNDw==
X-Forwarded-Encrypted: i=1; AJvYcCUq6Td/v6J+3nkGM3vp3OHhJTAVMRkBvrATED2FQ82hDtrjVW0WX1ElLSKkDGR5XJq/5m3Q3AI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxKOe3Q8iyw1iaGCvQfvKzcRucWOjX0g3NnGHgEn4xA/M6F9AM
	yev2tZ4x1E/SQfd8dZVF2H1nzSCpg71d1opxfR2LDNM+2iVXseN3wIAZcolJzZfz2g==
X-Gm-Gg: ATEYQzwqjkWxi9Gm0tJLWNOH4ZnzocuWPku+z+CaSz3MbqyXGXXMmna0xy44U3QNzi/
	jmlFwmcpZIdqpJoFWqKS0kw1ZETlEwgffewdIZRj3QmrnjHfLWEHde+BRAMZf0giqaQlL5FPTpH
	Nfy368ez3bmtwCFGYREA9fVxj6qb4jobEhK2kb9IuQOGtAdD77h4JLVCArhJADRK9Dmw0jV+h4N
	gYNfTLODR5pwrCkWKW4gpSbEabzXq0qSjiIpzm/oyDZ02Cn98RzOqQmCKRU6mEPZAqkVMJ+sgLr
	d/fsOD/7L9pajAVBDdn7JokzbnKXQnH9bjVgMmAAevYWziYKFvQeYT3H4v8JepCE+BPsJhwycFz
	ehKmQzyzF2bpsLuoOLo6dFLO4EMR1tLFelMuIG/N0q8JmkJg5MC1UYTecoJ0dW3k9qlqmJ5NHaw
	1bW5asOmZaM6jeM0ChQLPCMjhflvND4VSspo7rIr3UNHLu9lxmC8UDfGIftrWLCMmvCvM=
X-Received: by 2002:a05:600c:a09:b0:483:9139:4c1d with SMTP id 5b1f17b1804b1-485566e1a4cmr47428785e9.14.1773400059656;
        Fri, 13 Mar 2026 04:07:39 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48557c6ece3sm18109795e9.29.2026.03.13.04.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 04:07:39 -0700 (PDT)
Date: Fri, 13 Mar 2026 11:07:35 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: avoid unused-variable warning
Message-ID: <abPv9_8F38yEiAQ9@google.com>
References: <20260313094925.3749287-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313094925.3749287-1-arnd@kernel.org>

On Fri, Mar 13, 2026 at 10:49:16AM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The 'cpu' variable is only used inside of an #ifdef block and causes
> a warning if there is no user:
> 
> arch/arm64/kvm/hyp_trace.c: In function 'kvm_hyp_trace_init':
> arch/arm64/kvm/hyp_trace.c:422:13: error: unused variable 'cpu' [-Werror=unused-variable]
>   422 |         int cpu;
>       |             ^~~
> 
> Change the #ifdef to an equivalent IS_ENABLED() check to avoid
> the warning.
> 
> Fixes: b22888917fa4 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm64/kvm/hyp_trace.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index c1e28f6581ab..8b7f2bf2fba8 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -424,17 +424,16 @@ int __init kvm_hyp_trace_init(void)
>  	if (is_kernel_in_hyp_mode())
>  		return 0;
>  
> -#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
>  	for_each_possible_cpu(cpu) {
>  		const struct arch_timer_erratum_workaround *wa =
>  			per_cpu(timer_unstable_counter_workaround, cpu);
>  
> -		if (wa && wa->read_cntvct_el0) {
> +		if (IS_ENABLED(CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND) &&
> +		    wa && wa->read_cntvct_el0) {
>  			pr_warn("hyp trace can't handle CNTVCT workaround '%s'\n", wa->desc);
>  			return -EOPNOTSUPP;
>  		}
>  	}
> -#endif
>  
>  	hyp_trace_init_events();

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

>  
> -- 
> 2.39.5
> 
