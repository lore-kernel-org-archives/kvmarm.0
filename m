Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A03134D1
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 09:54:38 +0000 (UTC)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-53074ee0c2aso11042a12.1
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 02:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695722076; x=1696326876; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6RX+RxNThxWlZjWaBBvh6220YGe9sto71QyN0kHdm+4=;
        b=JGeUKqnetfc6CbyTvGU+d40MLHfylOFILyqvUFi3fhJPtR8T17Y+4683gsg+ohDHNK
         j4f3zEFwFoeLpfjAHKowndjBmtOrgWjZOmRwjUmF0Lus9PlMXAzO5+yv/xRFe43UpYW1
         xjHEOCvGLbzcIjU90DzSQVr0SXQQEK0HEOp7qwQNyIM8Hw4rdqesngmqWynhMmYbdL0f
         LuO0fXF495BKicKb/u4XhEKHeqYCDdzKoNZzc4SbFvQ5jSwqnfgsOi80ZV3+SZoWhcWx
         hHUKIGTNdRrmH0bGZPtc7UER4GBWkvgqiNr8ELD7j1PlPjtvbIhlYgwnX2bFbK/LLmn3
         UtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695722076; x=1696326876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6RX+RxNThxWlZjWaBBvh6220YGe9sto71QyN0kHdm+4=;
        b=pUJELHBsJo3nJJPWUa0tTm43hwqHfGhOMYe120ZaCutAxsHr+iQ2vPUZDOM/yCqZJS
         iYekK5A/JGpNcxiXLcU+3bwFVhLgdxL8MlRvIjefOM+uNkamfxhYsNubAggDMu6Yv5yC
         gQQQDxfG5tKloZABamOXhJBKOvN0sj+2Rh/IzbBEpDC77mv2VO3M6cETIHzLZKSUXHt0
         M2aycRKZDk09fYAOWJvnVwSs5uMvm8rLottHc2Z9y+Wkl6BNErTxy3fw8Qz3eoohcq1L
         psOBSWKWPZUCChAWh7mkjWy7grlQpavVx+hQI+oUEm5DoSk6PZcGXEPLr+PGoJIoXBNr
         1/ug==
X-Gm-Message-State: AOJu0YyQB7D3o6xQhQ6ZWNjEBnRWPGsZnLw0Hxi//Fda79v/qZF8JCps
	vPi2RcZMU/7JUt0uZkoNPvWM0Q==
X-Google-Smtp-Source: AGHT+IH0oPXZ48Gz2F+rYGnYegliWL0EvgOHsb6Ik8iDn17MeOfSc7/8iYbXOPOHUtU7T66FPETntw==
X-Received: by 2002:a50:9fef:0:b0:523:b133:57fe with SMTP id c102-20020a509fef000000b00523b13357femr77612edf.1.1695722076407;
        Tue, 26 Sep 2023 02:54:36 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id q18-20020adfb192000000b0031f8a59dbeasm1842861wra.62.2023.09.26.02.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 02:54:35 -0700 (PDT)
Date: Tue, 26 Sep 2023 09:54:31 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 40/45] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <ZRKqV88hfmz+mfB3@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-41-jean-philippe@linaro.org>
 <ZQsdfcCaeQSn2pzQ@google.com>
 <20230925171853.GA2068481@myrica>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925171853.GA2068481@myrica>

Hi Jean,

On Mon, Sep 25, 2023 at 06:18:53PM +0100, Jean-Philippe Brucker wrote:
> On Wed, Sep 20, 2023 at 04:27:41PM +0000, Mostafa Saleh wrote:
> > > +static void kvm_arm_smmu_domain_free(struct iommu_domain *domain)
> > > +{
> > > +	int ret;
> > > +	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
> > > +	struct arm_smmu_device *smmu = kvm_smmu_domain->smmu;
> > > +
> > > +	if (smmu) {
> > > +		struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
> > > +
> > > +		ret = kvm_call_hyp_nvhe(__pkvm_host_iommu_free_domain,
> > > +					host_smmu->id, kvm_smmu_domain->id);
> > > +		/*
> > > +		 * On failure, leak the pgd because it probably hasn't been
> > > +		 * reclaimed by the host.
> > > +		 */
> > > +		if (!WARN_ON(ret))
> > > +			free_pages(kvm_smmu_domain->pgd, host_smmu->pgd_order);
> > I believe this doube-free the pgd in case of attatch_dev fails, as it
> > would try to free it their also (in kvm_arm_smmu_domain_finalize).
> > 
> > I think this is right place to free the pgd.
> 
> Since this depends on kvm_smmu_domain->smmu being non-NULL, which is only
> true if finalize() succeeded, then we shouldn't get a double-free.

Yes, the other free was comming from an experiment I was making to use
the IOMMU layer with guest VMs, so this is correct. Sorry about that.

> But finalize() does leak kvm_smmu_domain->id if the pgd allocation fails,
> I fixed that.

Thanks!

> Thanks,
> Jean
