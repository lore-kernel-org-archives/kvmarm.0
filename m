Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ED027456
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743007720; cv=none; b=DpHmCHUAvAWcjm5TiwFBD2s8vpnSj7bc9QUt+olCxfgsJElZP66Qgdy8kYlhq/CpaQzpftfZwnqbjxNsk8Ya5XgfgAnw/e31psSNqJILV3H8ho808eOsVIl/wVMyQcxGulymeTRuHPNa9SYTgaYIAbUicuPBQvbxkNQP/n+Onvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743007720; c=relaxed/simple;
	bh=v+AmZUmpN4LDUzxm3w5ft1I/+r4feJlmYE8bhA3zNfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6XYmKHY+OKjBrw2BFFoSFdngKMfZE11lngYvET/WufBVqfjTTXImSUs8oycCErWQA8p6DWjPoxPaWhRxPc81hxVkcouyJUvpemUk/3VzHFHUz8kHA0WPUtoVbsnZI70i1+w7EdFdNo/6ph8EcYTPLtYMWxDaj0gzp2OsFzwsUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iom2ZOL8; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iom2ZOL8"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e6c18e2c7dso3022a12.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 09:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743007717; x=1743612517; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xIONhgKygIJfrRbEsZfUKmIHxiah0KpnWCpr3sd5zNk=;
        b=iom2ZOL8a93eUsdInAZ7Naam3codVevDzt5cwKFKQknFTlpsuiQk7gO9ISjI16/EVW
         /reH6ERtgeNyNYdv8bbAxuLFSEA/BmiM4FhTcI06SNIM2t6kp//yMlQj/4id1/QM991Q
         CC8XKaZjlonrmBKlaW9+HoeE6eEszbhHqtuxgMpmagymbkBLtaaM9qgk38/kyGRJ5I2a
         lxEdceLNEYir7Pk0WfauR2z8mKGdDG1/wSbWwIO/sEm3xye04F9knQ1asZTqz8e+0gui
         cHyZSatCtiu5rIVFOI04qb2bpjJZpWz34DEsyz8K6SjZAMKRQVFb2fHLT8INMatVtOBk
         Co3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743007717; x=1743612517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xIONhgKygIJfrRbEsZfUKmIHxiah0KpnWCpr3sd5zNk=;
        b=hRTjrSpGXC6cM3Q792u0Z0BGMPavhm6SScedJDjBpHbATyaifw1Dwcdc5vci7Qk32y
         oDBhGuLRWuf+LXlU/l0QnLc7Jn6aRQMeLj9zk+T/bojvZiRZygvq+2+gTH8xGQTiRKu6
         PnDeC+8jaNBDRzIGy5s+0WDgrshJSd7km7b2CDfmdbTFocUY+eiE7iKO6H0c+fHpeC9Y
         k7OvFfqasDsZHivnjNNd2wMeMBtQZQSeiNddD4BmD/oDWwhhRmCDmrErVfZTZzbIIYiF
         FSOAnIohRSrQZ5tthRCB1U5OC81Tf0+JhInyJCXcr8cr+lNIpZvSANFJg9qgNtorP0UE
         uOnw==
X-Forwarded-Encrypted: i=1; AJvYcCXkoF85X++35MOW4Mx5KnTh8P4YRl9XzxtwQxNvnvO3coP5qAi7noZnQ5cexC1a4IwugT6N3zw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSrRKnkuAfJ6SVd4wWwp1B2jS38fKSUOkOo6CD5MZDLpG/TbIb
	haMxpp9Kbf8EDCe4pJf+vlCdtA68Oj4SjowPA3DohswyVwfOJPb0+uXDLOvrhA==
X-Gm-Gg: ASbGncs2USz+yX5begELp5WYlksArEoWVsqbcKsOqhvVgnFOO4Aa5bunTMNwhUQj73y
	h86z79rFbULA4J0gRM5noW3dCLK9IJVPolHPfMxHR/3oVTh098xSSJXL6bP8T/PAWw+YG5CB7lc
	gqF+z+qH9SDEaV+Bjf3KOnUSrBIBmc0ivOf/jmlrtmQXMegV3k83Z+bIUNGNRL4DcIl9+LgS5MI
	y+gPp+L8gnLpg0QdHZGRsy6OLVGIniOgM/OSmfxXf/aJ32EmU5zio/DSDKk86A9iB7JKts28trw
	wgm6DFdhLgXaFd5ld3VjQdUMF0PpYISN4hCIA4dJoLrPX0DuEAByth2cBYPgHqGQagxoQHwu+NP
	rOnM=
X-Google-Smtp-Source: AGHT+IELoh1UdGLEoChuBbrPrSJlW3iazs22Tqnm/p66h/kdfAKvlGAngZOzasm3FVG0orud4x07LQ==
X-Received: by 2002:a17:907:7f86:b0:ac1:e881:89a7 with SMTP id a640c23a62f3a-ac6fae48539mr15547466b.6.1743007717280;
        Wed, 26 Mar 2025 09:48:37 -0700 (PDT)
Received: from google.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac404959f47sm907950666b.170.2025.03.26.09.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 09:48:36 -0700 (PDT)
Date: Wed, 26 Mar 2025 16:48:33 +0000
From: Quentin Perret <qperret@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	will@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com, Andrei Homescu <ahomescu@google.com>
Subject: Re: [PATCH v4 3/3] KVM: arm64: Release the ownership of the hyp rx
 buffer to Trustzone
Message-ID: <Z-Qv4b0vgVql2yOb@google.com>
References: <20250326113901.3308804-1-sebastianene@google.com>
 <20250326113901.3308804-4-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326113901.3308804-4-sebastianene@google.com>

On Wednesday 26 Mar 2025 at 11:39:01 (+0000), Sebastian Ene wrote:
> Introduce the release FF-A call to notify Trustzone that the hypervisor
> has finished copying the data from the buffer shared with Trustzone to
> the non-secure partition.
>
> Reported-by: Andrei Homescu <ahomescu@google.com>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 6df6131f1107..ac898ea6274a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -749,6 +749,7 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
>  	DECLARE_REG(u32, uuid3, ctxt, 4);
>  	DECLARE_REG(u32, flags, ctxt, 5);
>  	u32 count, partition_sz, copy_sz;
> +	struct arm_smccc_res _res;
>  
>  	hyp_spin_lock(&host_buffers.lock);
>  	if (!host_buffers.rx) {
> @@ -765,11 +766,11 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
>  
>  	count = res->a2;
>  	if (!count)
> -		goto out_unlock;
> +		goto release_rx;
>  
>  	if (hyp_ffa_version > FFA_VERSION_1_0) {
>  		/* Get the number of partitions deployed in the system */
> -		if (flags & 0x1)
> +		if (flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY)
>  			goto out_unlock;
>  
>  		partition_sz  = res->a3;
> @@ -781,10 +782,12 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
>  	copy_sz = partition_sz * count;
>  	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
>  		ffa_to_smccc_res(res, FFA_RET_ABORTED);
> -		goto out_unlock;
> +		goto release_rx;
>  	}
>  
>  	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
> +release_rx:
> +	ffa_rx_release(&_res);

I'm a bit confused about this release call here. In the pKVM FF-A proxy
model, the hypervisor is essentially 'transparent', so do we not expect
EL1 to issue that instead? How is EL1 supposed to know that the
hypervisor has already sent the release call? And isn't EL1 going to be
confused if the content of the buffer is overridden before is has issued
the release call itself? What would otherwise prevent that from
happening?

Thanks,
Quentin

>  out_unlock:
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
> -- 
> 2.49.0.395.g12beb8f557-goog
> 
