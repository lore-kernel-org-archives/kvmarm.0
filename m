Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A187584FAC
	for <kvmarm@lists.linux.dev>; Wed,  6 Mar 2024 12:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709729498; cv=none; b=LlyT+Mi2NRYMVhCFsMwUOxKmXF9IfIEcCkboQmctxv2pIzLE6GfnSOm//knjFgn9GPe5CQPmUhvNFTCuMCxa3WJuSPSA2n1Acrib/bUp1sc/X7iDWzY/vPT8sloeL7lVjQWZt4TBLVJ5OhDndl9qPEw2x5a5E3d3IFP2K4Fyczw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709729498; c=relaxed/simple;
	bh=ft0AWz4SOE0fZeNxVCcXJtIXw3InLx9aXgawOGYsbu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKSYaEVr9cABOygtqqSEC+3nfuBhS9UYupqiKD2FNzB8GA/gTK/qkW8P//FB0ztCncP53Ds6DneGaL2Mq9Ob0o0yHO4obUjCx3BQQW3ig7F7zIMxuvDO0sorKvWqr11hQDA+cfLL54dgOlTekx7e3/YfH8pxLIAacsQDO0qBdtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K6ycD4nc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K6ycD4nc"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-412d84ffbfaso71655e9.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Mar 2024 04:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709729494; x=1710334294; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tM1chBD6Cze8MbSTN6oJIjYyTDYaAp1NtgWbkaFmd3c=;
        b=K6ycD4ncT/2fEiiCT0MQz3EInYsIoviFvxJmUEKUaHtTxOdZAKTWyH3wDk7YoROEgU
         qOocbIgLDJue3SRHwq1vydAYWrORc8a5lU5QgRz76prvl0ntg4+mAWeWpbRCglTOWtuc
         Vx9cIg2rAvtSAW8yv/Ml/m9OaFbTb97ERkWErCokLlhBqOZSMrfTPwMqltVO4oi0pw/u
         RJ18YyKkVYLflaariNyOXNzy2Wbn8Z41a4BEvi/6dgEvud2alrXiUIzD6050QFVTKbJI
         rpmbnFaU5iC7Jkl2RQbRW7thhmRn5C81T+0JWg1Tt/arh+3fbvTNHgNhZY6aVbZ9yMKf
         GDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709729494; x=1710334294;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tM1chBD6Cze8MbSTN6oJIjYyTDYaAp1NtgWbkaFmd3c=;
        b=CQMMDOQh8ZOFIOn4dMrOiyYpLKJSIhyZhFksxHyfTpNsoSyp8lmuYOKUkVprqBdckL
         tugQ5UtHHjImXIJyqkAcutB1z4WsYuySoWTLdDHmGKdW5KegrmXjlfeLO1dePaOsry3g
         SNUmsA73DTQdGRDFiTBCd4WjWns+BEjGS5MIWse3yBtMfkzMQomyFYuHKnwheDB6DsUJ
         xWXiM0KuTb/Qm7yt0S0nRKlMPF5Gs8hQrtss8H0iFobpc6xNJp+cvFfE5NDoZnLdebSQ
         TZWQAANi1iKW8tGG3zptYmcKUvZk9xRBzIbiC2gWpGUqaPnzuTC+Ze2N4v58kvJB+7Ik
         7KnA==
X-Forwarded-Encrypted: i=1; AJvYcCXgvCPJQ02JjiErNgLjQz5M+OchvdMWQfT7ze4yZEgvqkav9q3QI1feKPNs0M4k51jd4ca2ImOYQn4JTjnPxw/fc0nQJORx
X-Gm-Message-State: AOJu0YyE06IfPLcTeOKKUAjyThI0b/8QVs3BpLoGwlGJIrA043sVdzSF
	BRT3pfJ9LJDSYmdaySnHwRw2BgV4VPRB0HPyPbZaxYA3HkzYeAebWHSK3b0+1Q==
X-Google-Smtp-Source: AGHT+IFobmqb8Y7aHK1JkGE/eGsjqIXPupLPeTU4ZQu5iZYMf7M2LupPjQjOgwv327j5mZHNoSXSrA==
X-Received: by 2002:a05:600c:5106:b0:412:c3d0:593d with SMTP id o6-20020a05600c510600b00412c3d0593dmr346589wms.5.1709729493277;
        Wed, 06 Mar 2024 04:51:33 -0800 (PST)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id co14-20020a0560000a0e00b0033e3ce48ba1sm8504913wrb.16.2024.03.06.04.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 04:51:32 -0800 (PST)
Date: Wed, 6 Mar 2024 12:51:28 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 24/45] KVM: arm64: smmu-v3: Setup stream table
Message-ID: <Zehm0GC7MyxcRx7d@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-25-jean-philippe@linaro.org>
 <CAFgf54qcTAru0Nvy1wH_tJMadOSW7Y3zEip5RTm+mtSa54Bymg@mail.gmail.com>
 <20240123194530.GA40099@myrica>
 <CAFgf54pAtSLWjaqhZShxzKkOLWFkjXmsmMk1P0TdXOUWhn00sg@mail.gmail.com>
 <20240226141352.GC1579460@myrica>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240226141352.GC1579460@myrica>

On Mon, Feb 26, 2024 at 02:13:52PM +0000, Jean-Philippe Brucker wrote:
> On Fri, Feb 16, 2024 at 12:19:01PM +0000, Mostafa Saleh wrote:
> > On Tue, Jan 23, 2024 at 7:45 PM Jean-Philippe Brucker
> > <jean-philippe@linaro.org> wrote:
> > >
> > > Hi Mostafa,
> > >
> > > On Tue, Jan 16, 2024 at 08:59:41AM +0000, Mostafa Saleh wrote:
> > > > > +__maybe_unused
> > > > > +static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
> > > > > +{
> > > > > +       struct arm_smmu_cmdq_ent cmd = {
> > > > > +               .opcode = CMDQ_OP_CFGI_STE,
> > > > > +               .cfgi.sid = sid,
> > > > > +               .cfgi.leaf = true,
> > > > > +       };
> > > > > +
> > > > > +       return smmu_send_cmd(smmu, &cmd);
> > > > > +}
> > > > > +
> > > > I see the page tables are properly configured for ARM_SMMU_FEAT_COHERENCY but no
> > > > handling for the STE or CMDQ, I believe here we should have something as:
> > > > if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > > >         kvm_flush_dcache_to_poc(step, STRTAB_STE_DWORDS << 3);
> > > >
> > > > Similarly in "smmu_add_cmd" for the command queue. Or use NC mapping
> > > > (which doesn't exist
> > > > upstream as far as I can see)
> > >
> > > Right, the host driver seems to do this. If I'm following correctly we end
> > > up with dma_direct_alloc() calling pgprot_dmacoherent() and get
> > > MT_NORMAL_NC, when the SMMU is declared non-coherent in DT/IORT.
> > >
> > > So we'd get mismatched attributes if hyp is then mapping these structures
> > > cacheable, but I don't remember how that works exactly. Might be fine
> > > since host donates the pages to hyp and we'd have a cache flush in
> > > between. I'll have to read up on that.
> > 
> > I guess that is not enough, as the hypervisor writes the STE/CMDQ at any time.
> > 
> > > Regardless, mapping NC seems cleaner, more readable. I'll see if I can add
> > > that attribute to kvm_pgtable_hyp_map().
> > 
> > There is a patch for that already in Android
> > https://android.googlesource.com/kernel/common/+/636c912401dec4d178f6cdf6073f546b15828cf7%5E%21/#F0
> 
> Nice, I've added this (rather than CMO, to avoid mismatched attributes)
> but don't have the hardware to test it:
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> index 4b0b70017f59..e43011b51ef4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> @@ -268,12 +268,17 @@ static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
>  }
>  
>  /* Transfer ownership of structures from host to hyp */
> -static void *smmu_take_pages(u64 base, size_t size)
> +static void *smmu_take_pages(struct hyp_arm_smmu_v3_device *smmu, u64 base,
> +			     size_t size)
>  {
>  	void *hyp_ptr;
> +	enum kvm_pgtable_prot prot = PAGE_HYP;
> +
> +	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
> +		prot |= KVM_PGTABLE_PROT_NC;
>  
>  	hyp_ptr = hyp_phys_to_virt(base);
> -	if (pkvm_create_mappings(hyp_ptr, hyp_ptr + size, PAGE_HYP))
> +	if (pkvm_create_mappings(hyp_ptr, hyp_ptr + size, prot))
>  		return NULL;
>  
>  	return hyp_ptr;
> @@ -293,7 +298,7 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
>  	cmdq_size = cmdq_nr_entries * CMDQ_ENT_DWORDS * 8;
>  
>  	cmdq_base &= Q_BASE_ADDR_MASK;
> -	smmu->cmdq_base = smmu_take_pages(cmdq_base, cmdq_size);
> +	smmu->cmdq_base = smmu_take_pages(smmu, cmdq_base, cmdq_size);
>  	if (!smmu->cmdq_base)
>  		return -EINVAL;
>  
> @@ -350,7 +355,7 @@ static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
>  	}
>  
>  	strtab_base &= STRTAB_BASE_ADDR_MASK;
> -	smmu->strtab_base = smmu_take_pages(strtab_base, strtab_size);
> +	smmu->strtab_base = smmu_take_pages(smmu, strtab_base, strtab_size);
>  	if (!smmu->strtab_base)
>  		return -EINVAL;

Thanks, that is missing the L2 for the STE, but I guess for that we can
just CMO for now, as the HW doen't update it, unlike the CMDQ which must
be mapped as NC and CMO won't be enough.

I am investigating to see if we can map the memory donated from the host
on demand with differet prot, in that case iommu_donate_pages can return
memory with the different attributes.

Thanks,
Mostafa
