Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D256AB1
	for <kvmarm@lists.linux.dev>; Wed,  8 Feb 2023 18:02:17 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id j23so2433124wra.0
        for <kvmarm@lists.linux.dev>; Wed, 08 Feb 2023 10:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X7v96oVAyAQBz01xG5dPcw5TgpCX8c/Q/mzF1lq3fls=;
        b=JSDjd4NjgrHKtKRst4hPuvGeqhv3Ifdam+ydF66GdBY2o1JwQB227Ux5hF9yAJnSdK
         bC/sHd9PuY+1SyHl+L+j9HqfSzCq5PL0wofKxfQbDeUmx2OvAKVWis2E6mhLBSLLErjk
         ujFZBGiK2yHUXawLCYGUiF/s8MWRNlqqYl55zylEdmIn2lLpb0m0Y0XP6dEbT1bw/11P
         TgSTKZLI4Zp+lO+ZHaIl+7dzoSYqGNlVNhXLtDk/gnkPxIOJmVrowyhCeF1xymON/aq1
         XmMK9AOBL96DheyA2mBqTFdVlxSFKsqxHzHNU+UBW+S2CTDOAXaj78qU9P1PkCfbYmm5
         5VBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7v96oVAyAQBz01xG5dPcw5TgpCX8c/Q/mzF1lq3fls=;
        b=howcYpzhaA42B/TLlZ1jEJarHl5KFyiME5iw5B7OEvMPaoXJGOdL1L7hpo+mWEdwP6
         9pwjfqvmHqehqzBfTaemZA7airLRIJVtz4zyGqhkoB0w7b5LEBFht7LX29xoVeYhP/VR
         mxOB1+jlmiO5oeFm8CxYMUShfN/+rxxWaN9biME4aTtzcFCC2brvt0MHEJsQOGDfJGFw
         ikwgl17jDnRdh911AmVWbchmJ1aSWjiE7rFbFlC7OHCuXKOmGmNYRSDxzEfXzhHS1hBG
         5pESgf5glXTYThzbcAuQ40+oKi3hzAyfekdEigfdc8PihWjS0BxikZb/8a6OJWVaEESn
         XNig==
X-Gm-Message-State: AO0yUKWKq+16c/JebMDv+Re2iCFNFtrCHKUVz/qhBL+6EG/nT2zni9Yz
	nRN6JKL2jMyPXERn1Yn148mAvA==
X-Google-Smtp-Source: AK7set9Pjmyi9t3GhUz0tafPGUxnCQlCQNX1EdDzGdiVW7+aDmg9A9r+drJbsTm198Kj45dKYH4K7w==
X-Received: by 2002:adf:fcc8:0:b0:2c3:cf13:d11 with SMTP id f8-20020adffcc8000000b002c3cf130d11mr7601005wrs.33.1675879335485;
        Wed, 08 Feb 2023 10:02:15 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id o7-20020a05600002c700b002be5bdbe40csm15273523wry.27.2023.02.08.10.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:02:15 -0800 (PST)
Date: Wed, 8 Feb 2023 18:02:09 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 09/45] KVM: arm64: pkvm: Add
 pkvm_create_hyp_device_mapping()
Message-ID: <Y+PjodiXZtR5Q588@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-10-jean-philippe@linaro.org>
 <Y+JCPLyan2y2TGph@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+JCPLyan2y2TGph@google.com>

On Tue, Feb 07, 2023 at 12:22:13PM +0000, Mostafa Saleh wrote:
> > +/* Map the MMIO region into the hypervisor and remove it from host */
> > +int pkvm_create_hyp_device_mapping(u64 base, u64 size, void __iomem *haddr)
> > +{
> > +	int ret;
> > +
> > +	ret = __pkvm_create_private_mapping(base, size, PAGE_HYP_DEVICE, haddr);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* lock not needed during setup */
> > +	ret = host_stage2_set_owner_locked(base, size, PKVM_ID_HYP);
> > +	if (ret)
> > +		return ret;
> > +
> 
> Do we need to unmap in case of errors from host_stage2_set_owner_locked?

I don't think so because this function is meant for hyp setup only, so any
error causes a complete teardown of both hyp and host page tables

I wondered about adding a BUG_ON() here if the function is not used during
setup, but maybe improving the comment would be good enough.

Thanks,
Jean

