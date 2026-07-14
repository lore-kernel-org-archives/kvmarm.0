Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2984340D590
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 08:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784018636; cv=none; b=toYMirbvdgYh5Nv6BjzPhwqRxwy6CDNHeIUEb+E4dEjpmb1V/oa9yjCjuRarthDeiaz2F7ZrIIV0vx2xPB5blnDAjqFBJOi7KVVRW1wv06zAZOe4HEc9LPjYgsnsQ4aVmixLCvTTeBIan7Gc2nBOCqwWHMmD5qvaFPCPxCGwWEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784018636; c=relaxed/simple;
	bh=LW7r6RfvIDbXgE6CChJMnLdwS5MHDeWEV+jm5LGMJ04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQBaSEcvZDToh/3Lt8ogO2Ogt8DDHL12OtZH3cirpz/OQpjJ5C+ztlBXjgmszwq7/sDQprf1OdZehqh5pLvmsHGGWbbui4EXMAXAd9QP9xUJf6V8S1O4UaNE9iSlwE6UVgspDPwi5q6Uw4QBsRBJY+xpk4Cd/BdipARMfVifnxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kb57KZKO; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kb57KZKO"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47d70879764so2590889f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 01:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784018630; x=1784623430; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+HCqftvyh10fMpY6IqpqVPtQHg/FJB6+bDbXuzWB9b8=;
        b=kb57KZKOloybsPDmhyjMUHGmbVDTnlt8UfkY6rwlveVEEfpVJw483U57wGqtSlTeF+
         9Of6TsOHpEHjksEdQQcVFrqSviGd9OwSLNl2Es83zXU3hqNczPfDMFyH9Ww+Mh481bsF
         23Rn8nmPvCGc4tzRNkUPox1ql7i0LMNd6iVVy96Bt7ycitZlYLIa1zDZY43aIp1IgEMP
         xKhPxquDaCY9Xy90FV7SU2XG6Col0n9gRAb/67g+uZj1DEBEs4olKvNrRxgR6vGUcNXC
         cx6KF81YljqKRiJiiESqnSyVI40uH0ShPBJ9w/Jv3rSKUUyyDcNV7/LiOXMoyKZIJSJF
         Mnbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784018630; x=1784623430;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+HCqftvyh10fMpY6IqpqVPtQHg/FJB6+bDbXuzWB9b8=;
        b=l98l8PxGawhyfOD6rlM+I2scHiXbUhlRR0eis0IlieNEN5V8XA7gYauCsf2rHIN0Ks
         2s0G4CDgDd71VLIoDB/tq6VJdHrKtELIRTFB07BR0hpNpL3NKZd9kWIgyi2xdhqE0x1y
         BFZbK9yWrNPKy6BEwxjjK8Fff8B/Mv13pG6OpSndFh7SINpPKz8TZh4daouNag3ysrYi
         Z/YWuyKfPbdKp0fNeyfRFwE7dhUkdnXtJPz9Z+bKe3Oi1ALKWq7uSKBMZlU/XBfWFqSz
         1SAgTPOq+ZkbFQyHg761cLnYTX8jT4gNx01H+i4YzH/hYxHqJjz0nvcznyY0iwCdeprT
         eHWQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqq7y/Z+u5g/OWH+ejAef9daCa7mBjR+hVuIM9G9w6bqv2aA2n3sSrkh24dtn5n5YROpbqnaw0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGOLT/svq2QIplOS+TR+ApMVNMjMydmHRDw9AWkSG8hmKMIVCp
	MbfAL7CQEq85uUwFnRMMvypFsHrmgoecnPvBeJbdGF1FGpObtokPsRX1RunYH3MTOw==
X-Gm-Gg: AfdE7ckDlC/NiweTE7Qyfs6IRhlaGyB3AQ6W56uUAL2oqCEN4v4R/SAT7TFhwWvZ4Ff
	WbvqF/b3Ld0lL2QU3pEWfaHrjXOsv3HVE4hJao58JQ/RHzSIuvxWGnq2MRf+vt2we1cUvkjQ/RK
	rB6FrxtP8y5hFMC7cENujN9SOhlQB1AEOL5fiN9tbWgdUXN/Sqw46jfcpL37HbEXLfxQbxiRULP
	6VWGXIj6I0ApHDbtEDreEpIx8JaXTm4tQF8TedNKgVsW391cz+V7hAKAzPS03O1YDcm3G9/JPuH
	HP1Xzx02/qiLShDX+bI4lTAug1YJ+1JZgtTNsCPGyHcX0vVP/2+bjcFs9CAfAE3hLaeSQQMG9Sa
	d1jikshGpVLRPS9kZ1aKr1du4LWHPAFOcCazhQvRdrhXQs5yDE2lCoc3vJ0TUYdXKkImiqqAGTx
	aHVgU8erVtS2y/u13A2yXqpFXjEOxZAt2QDUFQXF6KV95FXzgV+RM=
X-Received: by 2002:a05:6000:2006:b0:47d:edab:a721 with SMTP id ffacd0b85a97d-47f2dce9698mr13848050f8f.31.1784018629391;
        Tue, 14 Jul 2026 01:43:49 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c7c96sm6294914f8f.33.2026.07.14.01.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 01:43:48 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:43:44 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 09/25] KVM: arm64: iommu: Add memory pool
Message-ID: <alX2wISNtLcx7xPb@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-10-smostafa@google.com>
 <alEeyoXnMC0J4zFQ@google.com>
 <alS_gB5uSEbFV-jH@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alS_gB5uSEbFV-jH@google.com>

[...]

> > nit: kvm_iommu_init uses nr_pages. 
> > 
> > >  {
> > >  	guard(mutex)(&kvm_iommu_reg_lock);
> > >  
> > > @@ -21,6 +22,36 @@ int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops)
> > >  	if (kvm_nvhe_sym(kvm_iommu_ops))
> > >  		return -EBUSY;
> > >  
> > > +	/* See kvm_iommu_pages() */
> > > +	if (pool_pages > kvm_nvhe_sym(hyp_kvm_iommu_pages)) {
> > > +		kvm_err("Not enough memory for the IOMMU pool, need 0x%x pages, check kvm-arm.hyp_iommu_pages",
> > > +			pool_pages);
> > > +		return -ENOMEM;
> > > +	}
> > > +
> > >  	kvm_nvhe_sym(kvm_iommu_ops) = hyp_ops;
> > >  	return 0;
> > >  }
> > > +
> > > +unsigned int kvm_iommu_pages(void)
> > > +{
> > > +	/*
> > > +	 * This is used very early during setup_arch() before any initcalls
> > > +	 * or any drivers are registered.
> > > +	 * This value is set by a command line option.
> > > +	 * Later, when the driver is registered, it will pass the number
> > > +	 * pages needed for it's page tables, if it was less that what
> > > +	 * the system has already allocated, the registration will fail.
> > > +	 */
> > > +	return kvm_nvhe_sym(hyp_kvm_iommu_pages);
> > > +}
> > 
> > Could we actually estimate the memory needed, based on the allocation for the
> > host stage-2 and an estimation of MMIO coverage? This would allow the whole
> > thing to run without setting this value as a best effort and to make it
> > optional, which is surely more user-friendly?
> 
> Not really, this abstracts the IOMMU, so it does not have to match the
> host stage-2, in addition that the SMMUv3 driver requires extra pages
> for other in-memory data-structure.

What I thought would be to take __hyp_pgtable_total_pages() and then add on top
of that memory to cover the MMIO region. As of "here's memory we think your
driver will need" and of course that can't take into account any
"driver"-specific struct.

To be fair, that is a bit weird to have memory reservation so early for a
"driver" but perhaps that is okay because the pKVM protection is only complete
if we have that "driver"?

> 
> At the moment, this is set from the command line which is not really
> best effort as the driver later confirms how much memory it needs.
> 
> > 
> > > +
> > > +/* Number of pages to reserve for iommu pool*/
> > > +static int __init early_hyp_iommu_pages(char *arg)
> > > +{
> > > +	if (!arg)
> > > +		return -EINVAL;
> > > +
> > > +	return kstrtouint(arg, 0, &kvm_nvhe_sym(hyp_kvm_iommu_pages));
> > 
> > How about using a memory size here with memparse()? This would be more
> > transparent for the commandline which can work on different page-size systems.
> 
> Makes sense, will do.
> 
> Thanks,
> Mostafa
