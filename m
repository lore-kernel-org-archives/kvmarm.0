Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0E45625F0
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092633; cv=none; b=FTjacMBEPXdRejw2wFsjTKiC59H/yIegfxXHSlkXWpd8AIx5gfpiQ+z8G5s6TQAYxJZQbF7dKez9z3uSrdXuo9nOxfkZ/xVeqbBUmsmn6+fA7xEXV5tNH6XX3+LpW3g+WfXwkLJxRv22IWrzcK7T3TXMt3FswLBz51rxaOu32Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092633; c=relaxed/simple;
	bh=PFs5N1QRY/lF0PmUBLw54rV+mEjwTgLurYi1P0tnIxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YC+QMBSI1ZuReN+BqVpjTc5X7ZQ83foP3J4csZ6I9CS0g1Covi5gqEIMQmoa6KJsiMZJdNKK4fHrV7pY99K22S6h1MSTzuaHAqKvjCM+3YZQ1XxTwDQRo89dQtGic8u5AMvfJQTpNAa49/NrarveF+RrFBwkf0saBHn0261Tfng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rjfp/hMK; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rjfp/hMK"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49e65a8f70eso48365e9.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 08:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790092630; x=1790697430; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5TpKHAnlgFCarQTDeOf8zyy4gJ8n9kWvIOm7HPEEJnU=;
        b=rjfp/hMKyUdLfPuKCy+p0ws3C4KgYdzpASHfzYM504Iv3SAJizvrAMJDvRAyzBZoZM
         iCPDq+qvL4NUKe6gtof0zoBfVPhjYW3dNaJyhWdbLCVjmgVA8FVPiAN6L9nPXd6DVrVE
         eBz6sgzx/iw7Cp01DBEf4ZmVtUegg6LtFKqkl+dUtIjBHQUatXRezEoQZ1kgRhuJRMWg
         6ojIxwuHLACvc6512uH4fVLur/PxtreOA2T5snBlls2I9yAY2gxNqp8pbrxcXMZG+WSP
         Kk/ttosfJxfJ/cdh0Elx5DQ+JN78HCahKVcun9pYJmybG8vVWzAPwnYydpGCs7CsxDkC
         BPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790092630; x=1790697430;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5TpKHAnlgFCarQTDeOf8zyy4gJ8n9kWvIOm7HPEEJnU=;
        b=fiFxmA3svmLQBT9l8npiLHOqQi2bwP70B4kgUYJh3z6Ez5caZ7OEYMGj1FcodWRUCj
         23seJykqg4YQUX8mbLqVDl63QpXi9sqiz5Jg1ORYZ0OxumJhGGxv5hf98WrdmwBYigGG
         rc5O6a7eo097AHK8OdYhaw+tEUbVCPUPEBwVSfhskKGwYxezDJFEePP6v5bCLwHdctAS
         6uAqMPz2ODryAB3/n3hQJux8v/H8dpuJqkiIGALUa/V4zuN9bfaFtNfzohPBq9t7TRbu
         uX+ejGzxDfrAlMZq7G6I1/+NiZ21t3ikgWxkZDwVRuegpojyHJ5m4mdoLXpV/GLk3800
         IxDQ==
X-Forwarded-Encrypted: i=1; AKwUvBwB/QtcegQzGgiepydzpyLaKeS2lFELeKm8mJOk0dZn/f7l0LyPo26IgQuqgjp788Xvud0waf4=@lists.linux.dev
X-Gm-Message-State: AFuF++n9yISeZbc56ZyfZNg1UaE/GQoC9v75SZpF2jabbm9fAYTqPj1h
	CgMgxQ+EBrEkFoZUUvB4YReQqfsgsin6HK3BTBz/ZoLJZab+pV9IfisTI/TdevOoPiso/emspuS
	2ErlqeQ==
X-Gm-Gg: AYBFou0gfLO3/tbCmiTRvIAALMfMDav+mA2RfPzi1tKegKT1YDJm7dFIF7PkDq3itWd
	uX38lqO+KgYMVGlVMQOCSAPH6ePtW1aNtaNkHmMzuyZ9GRFgl625jGb7XhQSvvI4qZRN/mPIqjb
	7O6w04o4f7KgzIX+Aar9I225YPkdO6MTigpEpqlBJzdssSsxENqXMa2CCqnchx5P8jx+rq871ul
	1S+9Mszf+NoCfEYEtVH5WQTGMAj7VykxyqY+yGQVgQGcacjeMFWvrWuUfDbjZtFayxqcgJNxsqU
	/5tGBrhhp/CS8cOIOD0VujzBjLhhaisO2/HO9JpDV/AN3C3PubYn2J2RIXccANSVd+AEdkT2dlm
	1AXJV5WIfS8j93MAVamcvZ4HOGQUS1dw9lxb2xJdrADUZq/CP6Dbp+ikc2UhLiSRlkd0TM9OFao
	3ZMEHXpMIEEtG0HWU1JjDS1l9+LBEh9xg0GjBkHpltPjj62I0/SucYQ7ufVtEpMvxB7MYOv2w8F
	kmyfRRDbNP8iflcz1IvJwSNLeAG1POto1p8gbZq
X-Received: by 2002:a05:600c:43c7:b0:49e:62d0:4653 with SMTP id 5b1f17b1804b1-49fdd974593mr123865e9.2.1790092629439;
        Tue, 22 Sep 2026 08:57:09 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde1aca52sm117415e9.14.2026.09.22.08.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:57:08 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:57:05 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 24/25] iommu/arm-smmu-v3-kvm: Enable nesting
Message-ID: <arKlUTZLw_CF1mMv@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-25-smostafa@google.com>
 <20260922134959.16CBB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922134959.16CBB1F000FF@smtp.kernel.org>

On Tue, Sep 22, 2026 at 01:49:58PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] iommu/arm-smmu-v3: missing ATTR_TYPES_OVR check before setting STE.SHCFG
> --
> 
> commit 9a13859889ae6cece3b72c3b06628dae2d48b4cf
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Enable nesting
> 
> As now the hypervisor controls the command queue, stream table, and shadows
> the stage-2 page table, we enable stage-2 translation in case the host puts
> an STE in bypass or stage-1. The hypervisor will control the S2 part of the
> STE and sanitize it.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > index 5417a5c2bf58a..39c97404e0397 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > @@ -461,6 +461,57 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
> >  	return 0;
> >  }
> >  
> > +static int smmu_attach_stage_2(struct arm_smmu_ste *ste)
> > +{
> [ ... ]
> > +	sl = pgt_cfg->arm_lpae_s2_cfg.vtcr.sl;
> > +	ts = pgt_cfg->arm_lpae_s2_cfg.vtcr.tsz;
> > +
> > +	ste->data[1] &= ~cpu_to_le64(STRTAB_STE_1_SHCFG);
> > +	ste->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
> 
> [Severity: High]
> Does this code write to a RES0 field on hardware lacking the ATTR_TYPES_OVR
> feature?
> 
> On hardware where the ATTR_TYPES_OVR feature is not supported, the
> STRTAB_STE_1_SHCFG field is RES0. Writing a non-zero value to it triggers a
> hardware event that aborts the transaction and breaks DMA functionally for
> the device.
> 
> In the host kernel driver, this is guarded by a check for
> smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR. Is it possible to add a
> similar feature check here in smmu_attach_stage_2 before setting the
> STRTAB_STE_1_SHCFG_INCOMING flag?
> 

Technically true, although this was unchecked for the kernel for years,
so I doubt any HW cares, but I will fix it.

> > +
> > +	ste->data[1] &= ~cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_S2FWB | STRTAB_STE_1_STRW);
> [ ... ]
> > @@ -520,8 +599,7 @@ static int smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool
> >  		if (l1_idx >= cfg->l2.num_l1_ents)
> >  			return -E2BIG;
> >  
> > -		host_ste_ptr = &host_ste_copy;
> > -		ret = smmu_get_host_l2_ste(smmu, sid, host_ste_ptr);
> > +		ret = smmu_get_host_l2_ste(smmu, sid, &target);
> >  		if (ret)
> >  			return ret;
> >  
> >  		/* No hypervisor entry, first time the L2 is populated. */
> >  		if (!l1tab[l1_idx].l2ptr) {
> >  			struct arm_smmu_strtab_l2 *l2table;
> >  
> >  			l2table = pkvm_iommu_alloc_pages(get_order(sizeof(*l2table)));
> >  			if (!l2table)
> >  				return -ENOMEM;
> 
> [Severity: High]
> This is a pre-existing issue, but does this out of memory condition trigger
> a fatal panic at EL2?
> 
> When pkvm_iommu_alloc_pages fails here in smmu_reshadow_ste, the ENOMEM
> error propagates up to smmu_filter_command.
> 
> The caller, smmu_emulate_cmdq_insert, will then hit WARN_ON(skip). At EL2,
> WARN_ON expands to a fatal break instruction, crashing the entire host
> system.
> 
> Since unprivileged host userspace can influence device mappings and exhaust
> the hypervisor L2 table memory pool, can this error path be handled without
> causing a hypervisor panic?


Same as discussed before.

Thanks,
Mostafa

> 
> >  			/* Ensure L2 is observed before writing the ptr. */
> >  			dma_wmb();
> >  			arm_smmu_write_strtab_l1_desc(&l1tab[l1_idx], hyp_virt_to_phys(l2table));
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922131259.2975334-1-smostafa@google.com?part=24
