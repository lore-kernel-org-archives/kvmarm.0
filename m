Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB1A552930
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091297; cv=none; b=s9mw2DzDMo9VcrreJVpSYQzdRE8OLGMhafzZh3Avb5QHfB7EeDZi23V7mISqNZLmEcK/RvfdqrkNsdLlOEX0NiS38GE6UXjZNtg99OCD1/yCAd6WWadZHAq1wq3nWZv0qh8aM4p2EFcsuc5/tLLan4FDoobFneDpp78+yvkRWd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091297; c=relaxed/simple;
	bh=AlI+gYgyGWjTDG8mZPpqNZoJRCkR2l4HAii3muE5ymY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=egpo3CavE6OdvwkHPh6Dg9SM3zJARf7+bnDMYTVyo+wi7ZM5Us4WkFY/e68/XIHlCjuWhydc8vNS4Oa5MraBbeyxVBy75RJJzKpUjKElfjpnRARxB6++2Iuhucd86kmOSVIwe1jHT5lwIvntd+CH9wK9DfM5Kn3SdvGEKAni7KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L1GoHgwE; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L1GoHgwE"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-498012a61f6so48195e9.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 08:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790091294; x=1790696094; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BNyTVQyFI7mOSGhaMtyppzYBxtzn1iFq72gMT4Q0GAo=;
        b=L1GoHgwE4fvvat6r7a8ETLOqFyReBS6Ju1QHSuEOxx2xmo+wvvgj6sdxEl3iessWiX
         G9z+Mq2WPoGWITxJiMYsJ7fqhESvrJZzCvuP8iRu5mHjbQVL11/8AkQRC1nsyWfHF0Im
         CIABaP0fVzfsVym3W7QQmDiNkVlPB1RSOUIqtEM7Xt+dKrx07nFZrf4y2ef+HaM/p5aI
         jf7kBkpb3Lzk1jtoei+/Mg1lXBUwFuAJ074pt600P6OZG1ZkGx7/mMFQRcXqNuue0tgr
         uqXHAFZskohlCMac6T86yQWabP8gauHimtPGTTpY0kC0cioINLYJA8SZ3c0FLUeIdpBJ
         kZiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790091294; x=1790696094;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BNyTVQyFI7mOSGhaMtyppzYBxtzn1iFq72gMT4Q0GAo=;
        b=iVLk5u379jQYYPUpsyEoOPpyIp6b6tVs5+i2pEogGDZIWs0+BEo0ovBcKFVxlEVFp4
         fVPCh1XKSvIcE7+iUnCrRoRi1b3gnDXXR3PuUsDVtmTwGM+bugD9bBk3uNZc7Th7BXp5
         WjtDWdWwxCInZT346+N0hoHfK9n3+Ja094XjKSE2hgKS7ZFHNoEZhkY+Ri8cdHfruEav
         YcUEt10o72dS8FrvmvCraqd7uz9gNBouPCaJvoDYH3BnrMYjfm89Eg2h8Wup2I/tK2R5
         3LsW/C4OIUJkOly2P7zGHFF5Cxhd+xN5R89FH46SBvHP05lDpcIuVo214ysDmfX8qxQ7
         8gOg==
X-Gm-Message-State: AFuF++mB+AA/18kFAey5hgIlA4tRm5scl9xyM2NUAdNN4DXZfjqrmTpm
	Hczm+1fq7CwKnw0l2JWTzf8JPUM54gGMeCjPgzGh131OmEGHKe7dcGXfbBH3RZXgxYzD6TsYxzr
	6SbzbKA==
X-Gm-Gg: AYBFou2baguUH80XEb6PfxzfM2C03koYVx5mWJkwVijUl+EpzoA1sH+nwoM/rvR7p1c
	/LL5PaxWUs7+M1MAgIdtRxBwfh88hU/XVzIhSsIi+Cz6Qc6ULc7s6ts+1W0HMijLnR/Ol6LjaT+
	PdM2bsLp110PA/0elVlcy8zvAZnbTaX7HIEBkwiFwq4CxDMZ+qrERRS3q/vModdy8I2ZlovOQeD
	a0bVSschkYVHdl2dZFnYZ/wd54YagmNo5FQr+6obIqi/E3lQeAUQ8XbpjPKalR8CAemYGbGK2Ol
	qvUMAVeRsR3EYWIfotw7DeOMq8zEIQRAh+iPIjLByYB8GuyhzlzhPnALGKKeFcefTE4e51t0+/x
	r7D2wyPJ9acMJ8MK2rJfXkmob6xc5NGUl3ofK7gXXxAykcru9N43rqS4Nz0wp10ulxG/9XpG8Qu
	szneL34u7FWDKvv5HbD62kbrwrdBZviTokIe+QAhIRW31m71C9pGQY7y1Qo0266jnIBlAninWv8
	OXbCxusIgPB7eu8eaoxaFbS6P37sJYrpkvsWKSInZzKR33+GOQ=
X-Received: by 2002:a05:600c:35ce:b0:49e:b733:7277 with SMTP id 5b1f17b1804b1-49fdd9655e8mr272935e9.2.1790091293445;
        Tue, 22 Sep 2026 08:34:53 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdaaec8ebsm55719525e9.2.2026.09.22.08.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:34:52 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:34:48 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 14/25] iommu/arm-smmu-v3-kvm: Shadow the command queue
Message-ID: <arKgGEyRZutTLLB6@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-15-smostafa@google.com>
 <20260922133243.DE4181F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922133243.DE4181F000FF@smtp.kernel.org>

On Tue, Sep 22, 2026 at 01:32:43PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] hyp: wrong WARN_ON() in smmu_emulate_cmdq_enable() causes panic
> - [Medium] hyp: WARN_ON() on host MMIO access creates dead-branch trap
> --
> 
> commit 6579ca2101bec241418169d448cfd8bd062f327e
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Shadow the command queue
> 
> At boot, allocate a command queue per SMMU which is used as a shadow
> by the hypervisor. The host command queue is pinned in a shared state
> to prevent it from being donated to VMs.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > index 7a51cb70205fe..b26c21b595b47 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> [ ... ]
> > @@ -132,6 +222,23 @@ static int smmu_init(void)
> >  	return ret;
> >  }
> >  
> > +static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	u32 shift = smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
> > +
> > +	smmu->cmdq_host.llq.max_n_shift = min(shift, smmu->cmdq_max_shift);
> > +	smmu->cmdq_host.base_dma = smmu->cmdq_host.q_base & Q_BASE_ADDR_MASK;
> > +	smmu->cmdq_host.base_dma &= ~(cmdq_size(&smmu->cmdq_host) - 1);
> > +	WARN_ON(smmu_share_pages(smmu->cmdq_host.base_dma,
> > +				 cmdq_size(&smmu->cmdq_host)));
> 
> [Severity: Medium]
> If the host provides an invalid or unmapped command queue base address via
> the ARM_SMMU_CMDQ_BASE register, smmu_share_pages() will return an error.
> Since WARN_ON() expands to a fatal break instruction at EL2, would this
> allow the host to intentionally crash the hypervisor by passing bad input?
> 
> Could we handle the smmu_share_pages() failure gracefully instead of using
> WARN_ON() on host-controlled inputs?

No it couldn't, this only happen if the host is malicious or gone too
wrong.

> 
> > +}
> > +
> [ ... ]
> > @@ -158,6 +265,14 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> >  		break;
> >  	/* Passthrough the register access for bisectability, handled later */
> >  	case ARM_SMMU_CMDQ_BASE:
> > +		if (is_write) {
> > +			/* Not allowed by the architecture */
> > +			if (is_cmdq_enabled(smmu))
> > +				break;
> > +			smmu->cmdq_host.q_base = val;
> > +		}
> > +		mask = read_write;
> > +		break;
> 
> [Severity: Medium]
> When the host writes to ARM_SMMU_CMDQ_BASE while the command queue is
> enabled, the switch statement in smmu_dabt_device() breaks with mask
> remaining zero.

Yes, because that is not allowed by the architecture and no well
behaved host will attempt that.

> 
> Later in smmu_dabt_device(), there is an existing check:
> 
> > 	if (WARN_ON(!mask))
> > 		goto out_ret;
> 
> Because WARN_ON() at EL2 causes a fatal panic, the goto out_ret recovery
> path is dead code. Would this allow the host to crash the hypervisor by
> performing an invalid write to ARM_SMMU_CMDQ_BASE?
> 

Yes, the host can crash the hypervisor in many ways.

Thanks,
Mostafa




> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922131259.2975334-1-smostafa@google.com?part=14
