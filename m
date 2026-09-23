Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D8C470433
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 10:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790158562; cv=none; b=IrJ+Ed06s6SayCmDqcL2TvuFKUNXFgRntSPjGQQP20yXMG8bPjYM0PgxV28tv+9NzDIpMyvuNUW8hAKaZ2AgNFk09FmHCMtii//RddRvEWQdY8JSD72fgqFJ9YRNxJ+AGiuK/BQOqYoetnN1m7yMkRZa63/nOEN4FYOB1X4dGOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790158562; c=relaxed/simple;
	bh=EIUUzLZaMLycy3iJsghOslrbsHk9RROoG95frX8jYxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lULX1y6t+IGvnMXUICF5YzPaSDTW1jeIHRFHT0UR0UyhXG8D/OG/LSvM9dvs4+qiupIKZtOzVHFbW5jPHitqe9ygDg2lbHg1IfAIdkQ9p60SIvK1ck6CpAZnTfcnHjO+dbkKUOce12VF9EQxaDZ6CT3Md8Nqy8E9Uu3QwPw+KSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=umivEjJA; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="umivEjJA"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49e6425f96eso35965e9.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 03:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790158543; x=1790763343; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yZHQHfq1ph65L7qxzKlrPBl8SiUbUAuTYjQIuazmnA4=;
        b=umivEjJAnhnqbgxild7Z2GEz2mRFzjkU0qjw9B+uUclS8jt+IaovCEoh0ZNFMRAFdw
         PMcbPqfKkxZHy0dsY+ZicXl+MKOWkOWK/iO1tTmzp3WP38D6Wzj8TduQd5pnqIomQTJl
         2Ad82Wt3sNg+Zsc5w7ZwtE6rKiPRZIGMMndojscj79QZG+RYa9FpY+i4OAEVT/WRJwxW
         ZG7J9ZDJ5N/407mAm/v7j2TBaztxB8ffnkCcn9VqcqzDODQyqvCpGpLC/GR+2yi3Wga3
         fAi7kjSDuRd7n8cJEwUAhPxXMTKC3/PNkmJgaPMEHwDIVvK5o32s9niVTYxiO/7kGIne
         vIqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790158543; x=1790763343;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yZHQHfq1ph65L7qxzKlrPBl8SiUbUAuTYjQIuazmnA4=;
        b=2UDYqIu6y90lRIlH1HUfDBrxfstLd1NZgD4+LWApQ+WIBSiprYei85+VP5HD4vKo1d
         8QHSOjwIdBf5Pi8IU/4tqpVBj7oT/rLHNntGCipj9p7OINiP8Dqs7eFU/5ugF/x/7l66
         0sCBg4IWKOQuGjEQyu9no3QHpbOAuYgFGN1c17i1ZzW6A8bJM6IFx2zRc8v0tdbpDxaa
         wOF7AYdAYNyoSXw0w08CtODJ83DiVmMMPmFjwg1Nt2Gdafb5YzXj08bYK2H2Wi3+o3aH
         tn6TRY5RHdaxIW5jtlGY/5FtxcAua3fWoToQYk7mdjXhPTmhkRFpgUXo4WKONEyfZfME
         jF1Q==
X-Forwarded-Encrypted: i=1; AKwUvBwRvA1YQ7ZC8DJWnpewM+KInUKq6+ex+tCM0dJjMt+WNoj/sgS0Uv7/GsixotMwOqv+YlQUTzc=@lists.linux.dev
X-Gm-Message-State: AFuF++m0hA0lmHUWtMiBspGzmv67KvwwOqohykBnC14LUMGiZ6h6lGA0
	ZViig/tNd6FOAdu/25Md+DejLLpHRdDa/vJYYRMEW3L3/y8uHoL5BFfElgFGTY1mrw==
X-Gm-Gg: AYBFou1Ts5CW9pH6WQJCGfriqt/dVh84xXkHnCub/dcLqUDxtnQYB3fQb9lDIagcWrx
	ybOXZdE6A7kPp0kx7hk8MQSAphD7+JUe+eoBQNqYcZwxT7fPnNs4B3zfi8+7vCx214nNv3jqRzX
	9Gs2t/72r45+IzK7AJyzmTQzAIVnUzYfGTB2WbHE3GT63sFLpQ5LfW5gC0VCWk3z7ydETeGKme9
	Jd8Un/nh9rVLE5nDjLwWEZgiTDNuKAx11wymDu7cY7BIwtajbA39SgyxzwIWwyrFCqhPDzWGLYz
	ejLE7JyI2DoKk2h/ziu1TSMsLardTBNfgtQE+/rcOovHIJXc0uxVCZJa4bueLmTsYAHU+vcM0b7
	DfPgFRf21QtvQBEjgUGZtOixJMDIqhntIeaYjmbFTpIqyoj97zRW7IM2HlBIiEzpG6Z/giwGcxn
	gLZoTkRELkv26Rp9ZSCHTHn/ExKG/YswZYYfqxrR9cpdTrFo9kl9fTCgXmX4UfoqeZavfv9bHYd
	n/yIZ4ZTDocfl0OC7z7VBHAsXVrF/lFQLjEk8du
X-Received: by 2002:a05:600c:379a:b0:49f:c6ca:42d2 with SMTP id 5b1f17b1804b1-49fe0c0bad5mr679925e9.1.1790158543084;
        Wed, 23 Sep 2026 03:15:43 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde1e975asm71831925e9.14.2026.09.23.03.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 03:15:42 -0700 (PDT)
Date: Wed, 23 Sep 2026 10:15:38 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 05/25] iommu/arm-smmu-v3: Move hitless machinery to
 common code
Message-ID: <arOmyuQwuWkynORS@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-6-smostafa@google.com>
 <arLeIO20VQZD80nr@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arLeIO20VQZD80nr@nvidia.com>

On Tue, Sep 22, 2026 at 12:59:28PM -0700, Nicolin Chen wrote:
> On Tue, Sep 22, 2026 at 01:12:38PM +0000, Mostafa Saleh wrote:
> > Move the hitless STE functions to the common file so it can be
> > reused by the hypervisor.
> 
> s/it/they

Will do.

> 
> > No functional change.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> With some nits:
> 
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -59,10 +59,8 @@ enum arm_smmu_msi_index {
> >  	ARM_SMMU_MAX_MSIS,
> >  };
> >  
> > -#define NUM_ENTRY_QWORDS 8
> >  static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
> >  static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
> > -
> >  static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
> 
> This line removal seems unnecessary.

Yes, I will fix it.

> 
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > @@ -1321,6 +1316,8 @@ static inline u64 arm_smmu_tlb_inv_range_enc(u8 num, u8 scale)
> >  		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale & 0x1f);
> >  }
> >  
> > +#define NUM_ENTRY_QWORDS 8
> > +
> 
> Maybe we should drop the duplicated define in arm-smmu-v3-test.c?

Makes sense, will do.

Thanks,
Mostafa

> 
> Nicolin
