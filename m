Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A941D633
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 15:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785856983; cv=none; b=DUfzj0z2e2oRVjQWlNjnwJI2vecNyEdpLzfMVw8dr3/rf9yeUVcKpudg1y1wQCq3RqCgr+hGSFPUcPYf9q7qNvLmDvJV1SQLNP7KKHk9dxvq+Nt/gNO7MD6zOzwLzsylMgTfllFw6C/8VO9w5xSizM2bKb0hCAgBjWrAjjlwsEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785856983; c=relaxed/simple;
	bh=ARPOQ+c6UDtO7LhU3svWeAQohZ9g6PrIcJqv4Q8q4tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QlJCP26ViLHyvNURPbHkv7BLaXaOFoxHW5xG+s+GJE5P5lcXxAkoNJTLMHGPPPiaBaX8hyxTXFe+S66vsjc75WsbHtu20JzYOmLcErB44loOS3vokIoi0m2NKuNwnjywp/YnUpSbrPdmEc+AkzUf1z2mMxg0VJNbHMnQYkGwb9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CTSHcsf3; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CTSHcsf3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495509b08ebso49155e9.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Aug 2026 08:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785856978; x=1786461778; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=57eVHha9yn05PRoBRgBz6lC7HiDLbzFyMEEXKt7qjx0=;
        b=CTSHcsf3CxaW0Skpcf+ra095rHF5mircUsCDnQP5tKHvDa4LE46Xp2trPcUmu0ylKp
         /uG1BNbj12RnmTtjqH9biPi8t6/fJ7Ks+utODtv/wQPyel83We7wMtleJ2xD7JJDPH1q
         3DOPz4Q92k/n4YVD1dSJo0ccIqNJ++eb5HrAi49UqHLTegP/A92x3JrCI9ZBKO0r+ZQl
         QMV7GsA5CoXOiRJOWcDdLawdXhN1u7HGx845bQ3dvUItCVcpke6Ms5zW+ywIbMzrTLyn
         O/oYfoye5bV7KjOWjNTS5sZFgzIcNVYp9pkcUBL0aqULha/kYYRVIxEaCTgrzz7vpMp4
         aewA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785856978; x=1786461778;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=57eVHha9yn05PRoBRgBz6lC7HiDLbzFyMEEXKt7qjx0=;
        b=cKvZEMX8mqr+il9KKDCsXEkhpXReKigXKnRDjX1ndtXVoH3iTHKQbhWKekx6crufIa
         pWm3YrzyY9syj3PO4KGXvdzlT7UgoJe/mLVEsGDJuS5WZ6ujWxua01d0d8hH+hTvblXf
         vDgMRmIxu+crr012UR5Iy+OyKY2GkuQYspKKAEjAxN+PAN9eQdaYuDl/MLzHlBIi7YIo
         0/I2izmsKHzfBXxtUh/XU8X3d6ojPRAnCPS10RKQe9hXGKG2HFEiu2hGTqxtr04BpgaY
         WUgNVdGC0MDsn6a20x99RHQZhorJINja2Ce1jWi/tJ2R0rWP0t0ibMOQQPkRrL8tW1G8
         53bw==
X-Forwarded-Encrypted: i=1; AHgh+Ro3gU8KsLO9KddjUk+HpKDfNgOPs2O9h2j5ytLqherF0g36z6hgzmQDjiAlZTv9fLzAbYb0Xw8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNW9uF/knj+A82uu/w1PbyvZPKaw6glSpRlXgGFb5+jwmE37j6
	cnbljyWmF3Y4cWamF0i8mKP/rth1/z72GHng9ciMFPx1ATuP8gtcTWJNdobPH8W7Ug==
X-Gm-Gg: AR+sD13nUMBe5Iqw0Yp9zhD1a78wRb4oOosWB6uOsNbD1h+7Sjd7AF7HyG8iyavZ4+N
	TK2r3rsOEf3dfk3OHYh5DkHuxtg7A1oKnfZTLmUVmEThy6ygjqG8N4wh8I8BY/q2x7sqQV9NAq2
	uTujWrfjoaED4ZDI3acNMPQt9XRe4ip0Md5sxlkiqpRaPQOn/tMoqLxXGhaHRmPVblLYSETBdRT
	370WRfqqx9svQ8nmvEWyOz21rgEn2mRZF2b8ZqrJNYEAss4rbjxGJxaZPW9gUIJUKvjNdV03fJk
	a0/FDEmwIyUp3OoXpFT3IfQk6UbthzHlsZKVowJ5bmdlcxzp+jvoB/Uk9sfAfnC3iNnd2crrVNv
	FMCGjOZmnhABnMVTtMgyYDIks/glCWrX/LHjPPMBIMWGGvjIOImq4nF003W4Tt74Uuabos9JOxX
	4UzuT5BFDLfTe392NVOuHty5vwd0C122KFWolHC6bM+fFcjWzcMKkm4mPLTlj9sxJYyka8q4aw0
	xeX32r+dBpQwyik55V3lL9REK1ZtFlo
X-Received: by 2002:a05:600c:4987:b0:495:51b1:3b7c with SMTP id 5b1f17b1804b1-4994a3818b8mr1298075e9.8.1785856977525;
        Tue, 04 Aug 2026 08:22:57 -0700 (PDT)
Received: from google.com (63.235.189.35.bc.googleusercontent.com. [35.189.235.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49949fcb0c5sm87206685e9.4.2026.08.04.08.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 08:22:56 -0700 (PDT)
Date: Tue, 4 Aug 2026 15:22:52 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com,
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org,
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
	perlarsen@google.com, qperret@google.com, rananta@google.com,
	smostafa@google.com, suzuki.poulose@arm.com, tglx@kernel.org,
	vdonnefort@google.com, bgrzesik@google.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH 02/14] KVM: arm64: Track host-unmapped MMIO regions in a
 static array
Message-ID: <anIDzEogJepLfIOc@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-3-sebastianene@google.com>
 <CA+EHjTwDkgF5GV-k_VZ_nXbmUmwrAXaQJ5sFsk2tgr8LL3j4DA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwDkgF5GV-k_VZ_nXbmUmwrAXaQJ5sFsk2tgr8LL3j4DA@mail.gmail.com>

On Thu, Mar 12, 2026 at 07:05:16PM +0000, Fuad Tabba wrote:
> Hi Sebastian,
> 
> On Tue, 10 Mar 2026 at 12:49, Sebastian Ene <sebastianene@google.com> wrote:
> >
> > Introduce a registry to track protected MMIO regions that are unmapped
> > from the host stage-2 page tables. These regions are stored in a
> > fixed-size array and their ownership is donated to the hypervisor during
> > initialization to ensure host-exclusion and persistent tracking.
> >
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pkvm.h     | 10 ++++++++++
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  3 +++
> >  arch/arm64/kvm/hyp/nvhe/setup.c       | 25 +++++++++++++++++++++++++
> >  3 files changed, 38 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index 757076ad4ec9..48ec7d519399 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -17,6 +17,16 @@
> >
> >  #define HYP_MEMBLOCK_REGIONS 128
> >
> > +#define PKVM_PROTECTED_REGS_NUM        8
> > +
> > +struct pkvm_protected_reg {
> > +       u64 start_pfn;
> > +       size_t num_pages;
> > +};
> > +
> > +extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
> > +extern unsigned int kvm_nvhe_sym(num_protected_reg);
> > +
> >  int pkvm_init_host_vm(struct kvm *kvm);
> >  int pkvm_create_hyp_vm(struct kvm *kvm);
> >  bool pkvm_hyp_vm_is_created(struct kvm *kvm);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 0808367c52e5..7c125836b533 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -23,6 +23,9 @@
> >
> >  struct host_mmu host_mmu;
> >
> > +struct pkvm_protected_reg pkvm_protected_regs[PKVM_PROTECTED_REGS_NUM];
> > +unsigned int num_protected_reg;
> > +
> >  static struct hyp_pool host_s2_pool;
> >
> >  static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index 90bd014e952f..ad5b96085e1b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -284,6 +284,27 @@ static int fix_hyp_pgtable_refcnt(void)
> >                                 &walker);
> >  }
> >
> > +static int unmap_protected_regions(void)
> 
> I think the name of this function is confusing. It's not really
> unmapping, it's donating the regions to hyp. Maybe
> donate_protected_regions() or claim_protected_mmio_regions to reflect
> that we are doing an ownership transfer?

I renamed it to donate_protected_mmio_regions to make it more clear in
regards to what it does. 

> 
> > +{
> > +       struct pkvm_protected_reg *reg;
> > +       int i, ret, j = 0;
> 
> Please don't interleave the iterators with ret. Moreover, you can
> define ret inside the loop below. Also, you don't need to initialze j.
> 
> > +
> > +       for (i = 0; i < num_protected_reg; i++) {
> > +               reg = &pkvm_protected_regs[i];
> > +               for (j = 0; j < reg->num_pages; j++) {
> > +                       ret = __pkvm_host_donate_hyp_mmio(reg->start_pfn + j);
> > +                       if (ret)
> > +                               goto err_setup;
> > +               }
> > +       }
> > +
> > +       return 0;
> > +err_setup:
> > +       for (j = j - 1; j >= 0; j--)
> > +               __pkvm_hyp_donate_host_mmio(reg->start_pfn + j);
> 
> This rolls back the regions only for the latest `i` iteration, not all
> the `i` iterations.
>

I re-wrote this bit since the last version of the
__pkvm_host_donate_hyp_mmio accepts a size as well.

> How about (not tested):
> 
> +    err_setup:
> +       while (j--)
> +           __pkvm_hyp_donate_host_mmio(reg->start_pfn + j);
> +
> +       while (i--) {
> +           reg = &pkvm_protected_regs[i];
> +           for (j = reg->num_pages - 1; j >= 0; j--)
> +               __pkvm_hyp_donate_host_mmio(reg->start_pfn + j);
> +       }
> 
> Thanks,
> /fuad
> 

Cheers,
Sebastian

> 
> > +       return ret;
> > +}
> > +
> >  void __noreturn __pkvm_init_finalise(void)
> >  {
> >         struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
> > @@ -324,6 +345,10 @@ void __noreturn __pkvm_init_finalise(void)
> >         if (ret)
> >                 goto out;
> >
> > +       ret = unmap_protected_regions();
> > +       if (ret)
> > +               goto out;
> > +
> >         ret = hyp_ffa_init(ffa_proxy_pages);
> >         if (ret)
> >                 goto out;
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >
