Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF35199EAD
	for <kvmarm@lists.linux.dev>; Sun, 14 Sep 2025 19:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757877803; cv=none; b=NCQ/NtiUFhAidVvNIQ9VA5vndiGZKw70R4AuCr3bYohQnBFbThsgEUuDOpPnva978UoetF0Xx4PtCnxlMXgBftLj1zrVIf+Ayu9iFXgRgHUIRTU8phP7d7obVgzljMI5KjG8mMXeDUc1kXlFGRLaiF0o58a/C5hIhwCjNQ6Ev/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757877803; c=relaxed/simple;
	bh=uX0wZKJmEpYuqOqFw3mmAD3zJbyD9U44trnTAWBGHIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hP5izCxOTUdn1KlAgNnELLlsEHT9iZph3T7b3mCUhVCjNtt4tvQ0RFS+WubhtRCTzaEvkJtj7HHmbznfgy4JpaQknyHvvJo00+v9AFujB6SCMWiBSPckDi7D17KXsWvxKfHuxf2z/0u7OpTcooZQUAqr5mASa+CdTizCtbIA7iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r3UZ+LuU; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r3UZ+LuU"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-24cca557085so213505ad.1
        for <kvmarm@lists.linux.dev>; Sun, 14 Sep 2025 12:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757877801; x=1758482601; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TG+gYRralj304lv9jlQQvH2rsqe/nskBvKJU5W4aZb0=;
        b=r3UZ+LuUgQsbyrdM63D6leg0ZuNINznx1HGMgzUigDvAlFMCKcUP9SQwAqdsf8d+ys
         KPNp8is/U4hx1J2dbljWgvuRZ8eAjLB0LptE/ptrBwhZn36DPURTne/TDZ/mHv7C2OJv
         K8VGwgJIs+Okt+G+O8JKK08z1OGrELoaBQ+AgyqduVcENahcJDybN3fpQCPogzalmk91
         Ww1f7fYBPf35njMa9/8blsKid/uQ0vQl9xFOIs01BZy7PzHT+Nm3QcWFUkAzyDdkxQEQ
         xAazdtByxUVqxgsTDYWODizANcwCgxs8titpIAhMqdAqSq217UIChTrZaJX/nPCmrtyL
         +rwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757877801; x=1758482601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TG+gYRralj304lv9jlQQvH2rsqe/nskBvKJU5W4aZb0=;
        b=r5+5B2iKDOYOqEHMJvEedgsTEAzH+drTsdQoFSnL5m9CTQdLLgpzberflErs4kyxee
         jUmCjKHEMCsUQ1AcR6Vj+7h5Bo/VvVQftJkMnzsw6J5h8BTr/6fOOOVMaEVC6H/0dyD9
         mU3N+AHRYzah5DCQJYiDxFFhu/MoFpYv8PmotVUGGMb5Ujpk5uXlpINxCTAf/eux+2Wn
         NZgCLufTYa3jXkkbvjUDqgvIQ982T8Iv+B1CAeISCL+LA2akDsosHFFA/m2lHTypyVM8
         kWqkMrileBAjf76vS46fucYLMJl9oejLRMQG0R3KEjX2PEXNWFVdo7oWJYJMXqJSS7Zx
         Oa4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXJ3pFA/2nTwlurxfCh5r3QnZcmwGd2A0Fa3iWFWo6pgAR1bDSyR3mazqRmhQzP7sfm2lxDjSo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJ/tKjphrUciHDYp+n9C5emVETpIWImQw10f62aHwno0anvdfV
	QeX0JVxNYJybowhfeCPlVv/aAbxoNcjjSEP4DV/R4wJZuoNF4aA6ApPCS4hix2wV1Q==
X-Gm-Gg: ASbGncuCX9zPH+TGn7kZqyPkSSBmHZ1K3gkkP540vR+eTX7U8OZV0xB8KfecPRFr0S1
	yy4zofPtVVDU0EdMpQzUag18HhLskDXFEjGCZp2p4ajKrMOXPIKziKQ+6BRucp+IXuWICd/dbQK
	ThlR9SWlWn7K8JLTUweBCYmbVVf2MSzq2waZ8TfX0cxJYFB23IrV3VoDKJ98BBtXMIvINVm2uSU
	G08ugxNLHoIEmOcq34Lj+SIyT2kQnTg2EVi0e+m3rQ4OUhXNuSTRYS1EjeR1Srxw/juN9vQH7j5
	qsiN/Qv3v5aR1Zy7pnW+y7NsPCJbLYhus0tbRPhpUXct7fYnH78xCiE35V3j6UzJeeGrQjY3Ipo
	4+LUysSdjZ1JhymTOJTTYj6ojMYM1FHOIddfw+U5VRZ/O2p9m0/pqmVMhE3PRLmO6fmFyZZh26w
	==
X-Google-Smtp-Source: AGHT+IHeCAQpludM0vTJDLMiqTdpngcD9vok0tgM2qTCvopIbkrrbFlepcXGw62j8sLSWvlQCNe2WQ==
X-Received: by 2002:a17:903:183:b0:246:a8ac:1a36 with SMTP id d9443c01a7336-260e7c51cb0mr3888035ad.2.1757877800544;
        Sun, 14 Sep 2025 12:23:20 -0700 (PDT)
Received: from google.com (23.178.142.34.bc.googleusercontent.com. [34.142.178.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32e2b9125a8sm1504984a91.1.2025.09.14.12.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 12:23:19 -0700 (PDT)
Date: Sun, 14 Sep 2025 19:23:12 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Will Deacon <will@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com
Subject: Re: [PATCH v4 01/28] KVM: arm64: Add a new function to donate memory
 with prot
Message-ID: <aMcWIDQzi5CDNC4C@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-2-smostafa@google.com>
 <aMAvwlMQ-Jf2MWzd@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMAvwlMQ-Jf2MWzd@willie-the-truck>

On Tue, Sep 09, 2025 at 02:46:42PM +0100, Will Deacon wrote:
> On Tue, Aug 19, 2025 at 09:51:29PM +0000, Mostafa Saleh wrote:
> > Soon, IOMMU drivers running in the hypervisor might interact with
> > non-coherent devices, so it needs a mechanism to map memory as
> > non cacheable.
> > Add ___pkvm_host_donate_hyp() which accepts a new argument for prot,
> > so the driver can add KVM_PGTABLE_PROT_NORMAL_NC.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++++++++--
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 5f9d56754e39..52d7ee91e18c 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -36,6 +36,7 @@ int __pkvm_prot_finalize(void);
> >  int __pkvm_host_share_hyp(u64 pfn);
> >  int __pkvm_host_unshare_hyp(u64 pfn);
> >  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
> > +int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot);
> >  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
> >  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
> >  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 8957734d6183..861e448183fd 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -769,13 +769,15 @@ int __pkvm_host_unshare_hyp(u64 pfn)
> >  	return ret;
> >  }
> >  
> > -int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> > +int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot)
> >  {
> >  	u64 phys = hyp_pfn_to_phys(pfn);
> >  	u64 size = PAGE_SIZE * nr_pages;
> >  	void *virt = __hyp_va(phys);
> >  	int ret;
> >  
> > +	WARN_ON(prot & KVM_PGTABLE_PROT_X);
> 
> Should this actually just enforce that the permissions are
> KVM_PGTABLE_PROT_RW:
> 
> 	WARN_ON((prot & KVM_PGTABLE_PROT_RWX) != KVM_PGTABLE_PROT_RW);
> 
> ?
> 
> Since the motivation is about the memory type rather than the
> permissions, it would be best to preserve the current behaviour.

+1. I believe the current `WARN_ON(prot & KVM_PGTABLE_PROT_X);` check
would potentially allow "Read-only" or "Write-only" donations to slide
through silently.

> 
> Will

Thanks,
Praan
