Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFC313D638
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 11:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758023888; cv=none; b=YOUvpjG4s+FEDwH42TWjHtoPyZh93pwxVIKt222WwH4BDKJMt1ttYQxHMexagyr2HggTebTN98rUQTzGGNxeNXyZJz01hvXo85ThG3jzs30Wa6jBWw7OesT1zcz4X12QMpKIAYXjg90Y4XqWmMbk+ByesOxaCriBi4E1IfnZFJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758023888; c=relaxed/simple;
	bh=uO0NCh73QWjdt5Uyj9kU6fcAnxi3vw1tE7kTtVZcrLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uK/XSNNAzDLoZUNajR3vgPvY/R9GiJxgKhEwaP8AxngyG4err9g7msex4msGFQehC3K1JO8UxWratDK7BfhvuADrBewcGD1yx5qKhIRRqfm+Ql633cGTKM++T6jYIFY67emwcIQL9nrbHinR4K/2EcFrKNtvcrwHPX1Ac2I+7us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IRMaoVVB; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IRMaoVVB"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45f2d21cbabso44215e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 04:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758023885; x=1758628685; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3psH5CD7tcrvwMqVdIhmXfChnHfszSZCh0gJTDmLAQs=;
        b=IRMaoVVBjdeuH8ugFznBCW1iCt3/TlqYGM/S05KBIm/tJNKwVSdr8ZcNl3gcHwvyMv
         IIDemWvYmGJdALGnhjUmirLCGd8QD+jgGQD8DRgpkTouCxqZ8+hsXX5KF0dE8pwPs8Hy
         jJZq02spHF2xitLfI6/JGTX94utND2fIn5gl/RrSWa6lXBu9kYqaYgdCBlcVBLDUFl1H
         v509dSAyPvcrXaicajMjBxIjHxal0WPsJRYtyhmyF7+9k308we5+WQGs3a6uJAL4nLWK
         ItIjulJj8DZ8vAYSLa6kk1IYlnWJcoNjgf1B27WkzoHIBNQtcJqgrpor/t5F4Fq1ILrm
         qq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758023885; x=1758628685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3psH5CD7tcrvwMqVdIhmXfChnHfszSZCh0gJTDmLAQs=;
        b=XC7B7/MvgpykUyI69iCwHNUz3jCCiXg7Awa9kqwBTVARPa9mLNWvVpyGG6HGk7gThu
         9Tz4aMHzx4/bptmU2SR8SsKzZB0i109s0t9Z+jiMuWratYt3JANCJpxbIMd0ARARQ/Pk
         ENVJHu7LGJkCRrbu3f0aOXtxH70ws/CepU2q3yayu3OxWNFE1cxG/cdHWME3gGCfybZY
         rEM8YD2f6fKHk/2RIjY2GKcfRifLl2fWOzapCQDPS9Kc763D5giM0qp6V7+oiV5VjISI
         DYEREUYmSYKZ9UAGWqSyaSZ6b5pivlh3S8fnGUa2VXjY7hxSlIC2xg6FMDB1iMyPuMb+
         eUxg==
X-Forwarded-Encrypted: i=1; AJvYcCWnk8+SB3s3kbXmPLNFVqHlCso6NCS5UaJIKDJ8XF8bhEC+Zrp+vifTnm4QuTVMy67XP7qIHp0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrAR/MgC+u5O6fjk1T/cmZsvYRuNGQ9/KboxcSGC1vZd9t4ILD
	OZKGyXYRfDq1XxHIeC/9iXRjMa6tbALvCvEvQJPV6MLe9Shq6yHiH06l33gJ1Bcoow==
X-Gm-Gg: ASbGncswZ9K6ohLJ1YRNGlQQkT3vqOGB1SjFj/IsvqsDmkzMQ4vAY4IxdsX5MB7cnBY
	Vpdd/iKfj4oW2JbRj+2AyBPjIUb4p7YJpRczpPR8jqvEzz/Wbdz0UjzWjgekcyOlwB2dLMeU4v6
	qxIkunnLqLlXBmOwVPhDxuEHXOFxqPIXuh03wZMNHRuZYHD6n7RjT5vRib75iNdl+IpS23Kjd/3
	mhlm2LQB2Oi36WlLrkQzNMKdAsS8AdPlgqeIf6kMwHD0mZIjWVHCkA6a9gwNXOeO7lDM3FbDP5V
	QBzeQC2oky0cUaqqCJcf1LtxSQWnYimW5PCNWERAS9fcAliwFCwzOwY5sIxazeU3O5t98XcOEnx
	GxNeJopxlGjcP6WmgPsV1WAANm6dLG+gfelBN6rT+s5jbsd/xKeHamDnqt+qFTrD19QeyFA==
X-Google-Smtp-Source: AGHT+IG7Q075/69lFtwq0hoEJKVoCNlBE4hU6CDHrnoiEI5/aWCVfJbO7FkOPky6dULeT2aGJwID/Q==
X-Received: by 2002:a05:600c:8b6a:b0:45f:5b02:b0cb with SMTP id 5b1f17b1804b1-45f5b02b390mr996015e9.0.1758023884645;
        Tue, 16 Sep 2025 04:58:04 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7e645d1fcsm15966584f8f.48.2025.09.16.04.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 04:58:03 -0700 (PDT)
Date: Tue, 16 Sep 2025 11:58:00 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com
Subject: Re: [PATCH v4 01/28] KVM: arm64: Add a new function to donate memory
 with prot
Message-ID: <aMlQyEdJdJ4Q9iS5@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-2-smostafa@google.com>
 <aMAvwlMQ-Jf2MWzd@willie-the-truck>
 <aMcWIDQzi5CDNC4C@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMcWIDQzi5CDNC4C@google.com>

On Sun, Sep 14, 2025 at 07:23:12PM +0000, Pranjal Shrivastava wrote:
> On Tue, Sep 09, 2025 at 02:46:42PM +0100, Will Deacon wrote:
> > On Tue, Aug 19, 2025 at 09:51:29PM +0000, Mostafa Saleh wrote:
> > > Soon, IOMMU drivers running in the hypervisor might interact with
> > > non-coherent devices, so it needs a mechanism to map memory as
> > > non cacheable.
> > > Add ___pkvm_host_donate_hyp() which accepts a new argument for prot,
> > > so the driver can add KVM_PGTABLE_PROT_NORMAL_NC.
> > > 
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
> > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++++++++--
> > >  2 files changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > index 5f9d56754e39..52d7ee91e18c 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > > @@ -36,6 +36,7 @@ int __pkvm_prot_finalize(void);
> > >  int __pkvm_host_share_hyp(u64 pfn);
> > >  int __pkvm_host_unshare_hyp(u64 pfn);
> > >  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> > > +int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot);
> > >  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
> > >  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
> > >  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > index 8957734d6183..861e448183fd 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > @@ -769,13 +769,15 @@ int __pkvm_host_unshare_hyp(u64 pfn)
> > >  	return ret;
> > >  }
> > >  
> > > -int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> > > +int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot)
> > >  {
> > >  	u64 phys = hyp_pfn_to_phys(pfn);
> > >  	u64 size = PAGE_SIZE * nr_pages;
> > >  	void *virt = __hyp_va(phys);
> > >  	int ret;
> > >  
> > > +	WARN_ON(prot & KVM_PGTABLE_PROT_X);
> > 
> > Should this actually just enforce that the permissions are
> > KVM_PGTABLE_PROT_RW:
> > 
> > 	WARN_ON((prot & KVM_PGTABLE_PROT_RWX) != KVM_PGTABLE_PROT_RW);
> > 
> > ?
> > 
> > Since the motivation is about the memory type rather than the
> > permissions, it would be best to preserve the current behaviour.
> 
> +1. I believe the current `WARN_ON(prot & KVM_PGTABLE_PROT_X);` check
> would potentially allow "Read-only" or "Write-only" donations to slide
> through silently.

True, this can only be done from the hypervisor code though, I will
make the check stricter as Will suggested, and if needed we can relax
that later.

Thanks,
Mostafa

> 
> > 
> > Will
> 
> Thanks,
> Praan
