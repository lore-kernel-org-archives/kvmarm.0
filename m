Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E08A599A5D
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 21:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792098117; cv=none; b=ZkUxa6Gl7ag7MOUu2+UrCdkNaZS8dVwhuF+WXOdqjBIKYxg/AGwJq/9WnP+v39rYLJ7zObFi9duh8DsaSCCA0H8+Ct+4NPV7hl3Exmj99s4d+3oxlwdbupS+qbPiJHKRhlDoYH9EnYJQN7rZywR3a68vS+Gtha9AviS1ZxSKFDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792098117; c=relaxed/simple;
	bh=zXc6Ys/gWWkzmEliuQdASNz6ds2YWjzdc3KtsxCtxrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=riAon+QqEt4z0vH1xkBCFSONKbJ3uyQM4Jy/SVLwURcFeJAEwiDZ512sGSe6AFI+5zZWRNItWdeTT+8H3mDwpSm57FRDdzFfQ1iYW4qwAOJeCn+nHrnG/ILA5y84hJmcUwUmB6P60OTekPgvYKTQyqYqYS84D0dINo5gYrvecac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ELxK4pas; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ELxK4pas"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a018493d57so20325e9.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792098109; x=1792702909; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XwTlxJIqTOSxTH9UHFtQ7dio6tQl6wFCUesbKwWeJcI=;
        b=ELxK4pashQs6Eq/yOflKGitDmK/v5suj7+XLsQNP8x9wF9OcBColvQpH5nS7um59yP
         npmmWpU60ZzVrLMXhoZUt2ldfMG/AkhoV3/zLqAcCUaFNWhesPlgr9WUpWm7xiXDOwMd
         L4kCoazZxP5/JK9xoeRwDB+JtW8F1C6bG+2lTg3uW8bNB9U7v058ru8KhLjZZajLpLW2
         D1FznsJnMbDNnag6bC134ZQ4TbRpju8oaMBgSUb7g5O2ClX4JBo2SfrVV7pgdoVXaDBn
         MPUHr3H5X3/j+BUyZRZzS76denN0eX06oV2TZJfgsZTR3gEGnrQPje7MmvgqaTzmZM4I
         ijBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792098109; x=1792702909;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XwTlxJIqTOSxTH9UHFtQ7dio6tQl6wFCUesbKwWeJcI=;
        b=QSNocI7KNT2RD1E+Xbfzd2WLmqKLK2vuJ4Ad32Pp7NRuVZhnOvE9XLRnG8sd9zaNO+
         ZiTo6ceyyFFE8ntmsUSQ5KbFGt8/KTrAEW6bu0MC9k7zOV4Ix7ZMkLPDd5LZSlivoPd1
         J6nnkleZxn4Zi82fWTRncoEdJEA9FqYYxwU5g3R3a7VXrm4WmZPbQo0ICk0fvvWn00qx
         k7nqFndTn+F1phiOVzjdElU2JGipo9KhyBcQvIp7x0B+FzNvdN08t7EoIC4H6Xy2zpQK
         rrQ3TQGo5VJMUsJgV8EIlWAyqSrDC5XMnfvsPOQgu64y54SVzaNdakX5JCiE/zBQQTs1
         pmzw==
X-Gm-Message-State: AFq9FYJwmhRaRuYunkWEdFL8bTlxDuIn2EgSVCP++CpiFEUJMz5s13YD
	6wEdbAnHdsb1ywH5/2nEUyIbeI9GTTTm1EspAjfjRuw44zEuTqBKkWyX9Q5utpIQ5SLaN+oxzzd
	tf3BeXw==
X-Gm-Gg: AYBFou3BoiBYaePJd8X6PiF66uvI/nNlWDYYC+TrOtEWxWhXc15O8hIOarBcMqLkvNb
	DyggDma65NROLuDWYnUFd40fbKShxXIJaqesNLjjnjMQrINBNDIDHt+5koWz+lb3GsSuH1FuQ5B
	RBBSi+6xekUp4bkPympbZ71GgUFWGtZ2OJSFYSM4oPKZL0VEcnyC58x/O8lu42/48aZN5F6G1C+
	kTBTkB7f7BBn2eOQy5exPdDXO84H68rCNpd96u/G8iTs24wgmaUwPBK6EMA6CirZKnr3+LzonNv
	YtX+FlE/6fx4+nam5EwGSIn7HGVR8bldKPQYEoS9/3unv2vZIQHk9DgbwXc/p+zQz2nJ8WKywoQ
	pbGrdo0UQ6nBXj3IGnJrp3RFbV+FcF4EDSHbN2GEP6ISYbfgCnpdNuxCiJl0k9Xm5f0/ifmRSaO
	kjDMt1Bn3bw7zY/z+TzTj4998+rg+BldXxxlZX6gtfE1Xa5OiTmHOmQTMIF+1oA+dlw9MrOoofu
	ga9FzQHJNivvpoeMa0511Njoim7u9mRXHjyCZdw
X-Received: by 2002:a05:600c:4307:b0:4a1:6f41:90f9 with SMTP id 5b1f17b1804b1-4a1c8adfdf2mr75015e9.14.1792098109159;
        Thu, 15 Oct 2026 14:01:49 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd471a1fsm425481f8f.3.2026.10.15.14.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:01:48 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:01:43 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 14/25] iommu/arm-smmu-v3-kvm: Shadow the command queue
Message-ID: <atE_N51rZ7kcxBWv@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-15-smostafa@google.com>
 <sashiko-outbox-173389@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-173389@kernel.org>

On Thu, Oct 15, 2026 at 08:28:01PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] iommu/arm-smmu-v3-kvm: wrong WARN_ON() causes hyp panic on invalid host MMIO
> - [Medium] iommu/arm-smmu-v3-kvm: WARN_ON used to validate host input in SMMU emulation
> --
> 
> commit bf6dcb76ab39be1d82600f47f81d772f4c08b9a6
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Shadow the command queue
> 
> This patch allocates a shadow command queue per SMMU to be used by the
> hypervisor at boot. The host command queue is pinned in a shared state
> when enabled to avoid donation issues and prevent untrusted host access
> from reaching the hypervisor state.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> 
> [ ... ]
> 
> > @@ -132,6 +225,23 @@ static int smmu_init(void)
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
> Will this cause a fatal hypervisor panic if the host provides an invalid
> physical address or an unshareable memory range?
> 
> At EL2, the WARN_ON() macro behaves as a fatal exception. If the host
> configures the emulated SMMU with an invalid address, smmu_share_pages()
> can fail and return an error. Wrapping this fallible, host-influenced
> operation in WARN_ON() will crash the hypervisor. Could this path safely
> ignore the invalid configuration or return an error instead?
> 

By design as replied in v8:
https://lore.kernel.org/all/20260922133309.CD1F51F000FF@smtp.kernel.org/

> > +}
> > +
> > +static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	WARN_ON(smmu_unshare_pages(smmu->cmdq_host.base_dma,
> > +				   cmdq_size(&smmu->cmdq_host)));
> 
> [Severity: Medium]
> Does this also have the same issue with WARN_ON() panicking the hypervisor
> if the host-provided memory range fails to unshare?

By design as above.

> 
> > +}
> > +
> 
> [ ... ]
> 
> > @@ -158,6 +268,14 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> >  		break;
> >  	/* Passthrough the register access for bisectability, handled later */
> >  	case ARM_SMMU_CMDQ_BASE:
> > +		if (is_write) {
> > +			/* Not allowed by the architecture */
> > +			if (is_cmdq_enabled(smmu))
> > +				break;
> 
> [Severity: Medium]
> If the host kernel makes an invalid MMIO write to ARM_SMMU_CMDQ_BASE while
> the CMDQ is enabled, the switch statement breaks and leaves the mask set
> to 0.
> 
> Later in smmu_dabt_device(), there is a pre-existing check:
> 
> 	if (WARN_ON(!mask))
> 		goto out_ret;
> 
> Since WARN_ON() is fatal at EL2, will this turn an invalid host MMIO access
> into a hypervisor panic? It seems like the access should be gracefully
> ignored or rejected without triggering a fatal assertion.

Yes, by design, if the host makes violates the architecture we just
panic.

Thanks,
Mostafa

> 
> > +			smmu->cmdq_host.q_base = val;
> > +		}
> > +		mask = read_write;
> > +		break;
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015200903.2735565-1-smostafa@google.com?part=14
