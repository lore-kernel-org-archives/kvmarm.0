Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1974B341655
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 14:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758033027; cv=none; b=tpD6bpeqayIoQacZxWiN+Zgs284a3g2vyGqeHYNR94RMHKPinqHVmM8ndw9elNxHRH/gutxVJrqcfZGmZTZx35WN3OOdOu3HsDRq+G93IGuhJUO0AsHAMx5JzRuMNecGYsDKG1YAyabWacinLdvuC2i1LxGpbJjAkBVMxa8ZAwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758033027; c=relaxed/simple;
	bh=lXDcSFWQYp91MNC66yHZBJWni2JhoTUG5cLOCWW97Xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IadIjY/ux7z0wQx/tEhxfZUt3+eKius8Kka4uGGsZ+DDUNYXzKJ7HZsas2bn1kk014kTAn0nYq9vhXAB2m1kFGKdpwMa9Ni8Vuck3O9l5mJDHOUG6YMP4Ckk0XntnoZVytI+ffiVCjfqg2I6Tb7GujaXni39v1JaOfFO10TGD9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g5IAwGEn; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g5IAwGEn"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45f30011eceso58675e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 07:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758033024; x=1758637824; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fhmMdRL8qlR3Tvk3u8O3tOtlAqkQkVluaZ5zKHg+950=;
        b=g5IAwGEnUvNRYKCwJX6TPolrheK+nD88x5JxCcbE9cL/+fe0l9dI7R34NC6gLdxVKw
         U6j9n+k8otRPVXEKEuMCJoWe/nuwkRVf2+NPWKM3/OyZ1atg7wGd0GJfCFd3K8pt2Khv
         CzncIOpKaEPc+s4y8tJXuADtUuYtB9XTbRq5T3g2cPGAGYBirLfLKewFhcjh4nh77B6I
         VxtgZNNKvnQi0TKkElIXQQz6yV0f/nlaf855r/VrBlkZFWyniY7EcZyrJ4mWH86trAMU
         jh41TXdev6nLcRjatSBmUU/4RJCAmhE6tB0m3Ckd/7aTGPiojhh3ZPqDBBkR8iN+xTqc
         ST8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758033024; x=1758637824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhmMdRL8qlR3Tvk3u8O3tOtlAqkQkVluaZ5zKHg+950=;
        b=w1euFjFFnFX9+bgTa407TBJtmmDUz6poFClS5aS9RwgVc/2QMUiXO9LhXhFcNin12l
         Ik2ArpKUKORHnfAld06ypO26DBzUCN2QVP9VgYrSfvNjdY1YWAIuq7J87PT7S8/luh34
         WQUMHqOO6BFJOoaGNJxDTLM9T+1x+L5N/du4zYFKFYAzPpHQjhX6Pm19eHNz1D4IZJbM
         EbGbD40dPuUfDTmqFn6LT8mteW7ifbdBIKzcPtUcP9o2GGwKj0zXXHubeXQKygNRBu/v
         pnNx0FY3jf2NDfyBmQMSKmzXJ8DnmuEpUuRdhe5dhRvARn/bLB8nXz35KzTr90omzvg9
         jLdA==
X-Forwarded-Encrypted: i=1; AJvYcCXNYKBThUpWcakqIGBl9lLNkpDjbT/+C2WXi1+xfv1kklX7EK/VsmrfWHvdzq/LbEL6YIwIook=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6af3qnSuVM/QDlfvqwxcmEk2Da2EWKsLZtbZTPpnQMVJbCQRF
	FOtl0hQ2+C7TuG0FPBjCPEcb5YemJgpNEtld+lWzt1nY2vwFi6q1cO3SLfxdAV0Vqw==
X-Gm-Gg: ASbGncsh878BNicPYUak/zrdM923gMZKETWlBywjEt9vulz4DMQmH7/Qpi95t6spMXu
	nEFzLxrDvpBSdmi6mOUJ6PEk3bwzo/LWYmWZF5tWWOQWjFOPzVKkrC4IlfwVj44D/lYL6N0VBri
	yGVn7ABGVSnDQhQmgzU9EUxJQRSt5WwpeIiAt3BaUWjjM6HDrt7HIGUka3Taso8IxWkHZe5KHl9
	ZpbN7dLBLQv95Xi/vII/k/VR4QM8e4eFXG4ZL7E62T1XsmVemTvOPPQYvg7l5FfGO7wsRxHN3l4
	d+GozjrrEXLnaCDHiniK2Jidw22GIwSDkNm/RWgAMsnXjpmirhmFXqmTs1H5EBceTlBF8L4BtUu
	sUSsLNnjIDECckZRk8OCYDO7RMuR7uhXXvFeBf77e0R8gMpW6yni6RVWlCVgmSm2Xym8bJFOpDR
	KShT+GIhIqsvBpzY0=
X-Google-Smtp-Source: AGHT+IGo1adSqugDdIZRQSzWcjgsYTglPxgYm/2Pf1a15n6l2x2VoKYdVxQeE+Hpg647GI1uAq/aog==
X-Received: by 2002:a05:600c:8b35:b0:45a:2861:3625 with SMTP id 5b1f17b1804b1-45f320ea2dfmr1944965e9.4.1758033024087;
        Tue, 16 Sep 2025 07:30:24 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm340062f8f.46.2025.09.16.07.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:30:23 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:30:20 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 14/28] iommu/arm-smmu-v3: Add KVM mode in the driver
Message-ID: <aMl0fJJyV5sJKIKS@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-15-smostafa@google.com>
 <aMQlm9ucDtd5-15r@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMQlm9ucDtd5-15r@willie-the-truck>

On Fri, Sep 12, 2025 at 02:52:27PM +0100, Will Deacon wrote:
> On Tue, Aug 19, 2025 at 09:51:42PM +0000, Mostafa Saleh wrote:
> > Add a file only compiled for KVM mode.
> > 
> > At the moment it registers the driver with KVM, and add the hook
> > needed for memory allocation.
> > 
> > Next, it will create the array with available SMMUs and their
> > description.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h             |  4 +++
> >  arch/arm64/kvm/iommu.c                        | 10 ++++--
> >  drivers/iommu/arm/arm-smmu-v3/Makefile        |  1 +
> >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 36 +++++++++++++++++++
> >  4 files changed, 49 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index fcb4b26072f7..52212c0f2e9c 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1678,4 +1678,8 @@ struct kvm_iommu_ops;
> >  int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops);
> >  size_t kvm_iommu_pages(void);
> >  
> > +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> > +size_t smmu_hyp_pgt_pages(void);
> > +#endif
> > +
> >  #endif /* __ARM64_KVM_HOST_H__ */
> > diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
> > index 5460b1bd44a6..0475f7c95c6c 100644
> > --- a/arch/arm64/kvm/iommu.c
> > +++ b/arch/arm64/kvm/iommu.c
> > @@ -17,10 +17,16 @@ int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops)
> >  
> >  size_t kvm_iommu_pages(void)
> >  {
> > +	size_t nr_pages = 0;
> > +
> >  	/*
> >  	 * This is called very early during setup_arch() where no initcalls,
> >  	 * so this has to call specific functions per each KVM driver.
> >  	 */
> > -	kvm_nvhe_sym(hyp_kvm_iommu_pages) = 0;
> > -	return 0;
> > +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> > +	nr_pages = smmu_hyp_pgt_pages();
> > +#endif
> 
> Rather than hard-code this here, I wonder whether it would be better to
> have a default size for the IOMMU carveout and have the driver tells us
> how much it needs later on when it probes. Then we could either free
> any unused portion back to the host or return an error to the driver if
> it wants more than we have.

I can do that, we can set the default from a config or cmdline (or
both).

Thanks,
Mostafa

> 
> Will
> 
