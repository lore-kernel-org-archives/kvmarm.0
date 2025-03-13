Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA8D1F1927
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 19:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741893203; cv=none; b=b/ZGzk4o7Wi7D2oLr+eGPdv9tWT/sYJx5Gl2Ld9JVITHSteREjaHw7LF53T1y8Gg+tpfRxc0OYpGA7h8Tjg6frpH2XBG34wOct+HTZHq3Ci5vQ4GTEooubc8yvFGCWB8CR/yhL/eqE9udCUfmPj1i6yuigYC6WvJlNyJGkzRjyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741893203; c=relaxed/simple;
	bh=FtUI3xUhxfCo5TgFRn1lRnA7XfmVSLNMqAj1tPGSaBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g911rdwa570j29o56vHR/IxcLQ1opN2+NN/0TbkMnIlQRwyLYATb5Z9V4WGLJYVDpJOSSugKdbR+cujW8Iiu1HQ9IkQBkKmOc1IKsLuqzxuIn9bKwPouTivWOTBT5IvAJd5iQ7c9/PfUVN48KV91qG30J82F2OhacL6yHbiAp4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K4QNtLGa; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K4QNtLGa"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac25d2b2354so232074966b.1
        for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 12:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741893199; x=1742497999; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L3F+szF2XQGRywilPjvawnmOy3jehJGbZVMLTgFQTJw=;
        b=K4QNtLGaIxohAWaIsBtxgq/xw969YzhNHbNFNL/4xHxPlNTrm7WRNKGHB90qRhFijR
         EGsqyOCQUBxmFar8pZMSm3QuzaTHMVE8u0k/XWPs4X0zG84h9XNmozWOSMGUAbZdpTee
         noXqdCEzpUcGDxbEEnSdK8dh6sFcDgh9AT7wa5Te2ZlWoiNSepF7iVI5jj0wM1BLpxxA
         jHHJYQTVoE1dkFzzf6rIr6EOmu+PqQzL+bw6PYaIMOo1zdSssHARIHdvczFH9zAyfSwZ
         Dxqfy6U1z9AgoYMCj8pw7eSd+NLWPQ01gXzpNzOTcISgObZ4JCOd81AGpbKC777t7Vtf
         7hrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741893199; x=1742497999;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L3F+szF2XQGRywilPjvawnmOy3jehJGbZVMLTgFQTJw=;
        b=wMVSc1zGvxkr1LJTzZKYv4R2jqUd3whYeeF4QtFtYM6jPbTFKNvp1AJFfnKG8hOjXd
         sVRd9ZLZH8wrXnqxJcQ+wqUbVtTZnR8qqBZUSdIErFxnZk+bpmyFc2EYnFx8bk2v2Mo2
         chErCbnvuSxOZM/LfGP3XWFNONz9PNU+pkhdNwOnpWrqgPLgTLQUT+N791wqgjkuYfxo
         dJgzlBk9BKQ069bHeR4hHLoKMnSRty5NoGPV4Fa2OowYs8l3Wc5l9usD8tbkmPMkLy04
         OSgne5a2rclY0Li+sURwvX2wYGHvLVHtpLGUTpqU7h0I40fotglWULPaAzZb2/ZcCPC8
         NTNg==
X-Forwarded-Encrypted: i=1; AJvYcCWj4FCRagJgcm9cX5FuHJiDMEVIiekQcT4Dh+aB5gmkvluj8nLd5RKTTCxCMcCdvbSJN9vzbHk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzyQuc5VDz8KDMsEIzXLY1w2Obdt9jztqC5nz6GWE8Gm/ueQL3e
	xWi6Hikp+Rni7F5nyp1NeBEkInCzEHuLFCoVXM0mkFuEH09zKRs7Gs2gK8iWCw==
X-Gm-Gg: ASbGncumiUqsObCjOz8Fn95dGZEw872AlA+kJCE4tN0eeCDAOeepcUMCh5H7gEJMGmu
	vn1+D+jU4eawtG+FXgY5VjUFKIaWleLKklkEZxq15EY6mhMxi1MpHwzUfVBt5AZx41l26yAMS6j
	tk7wmDxGFiTk3Rdd5CdoyP2uA6XfgdF4cBLmEfG2Mjpbxpd5T0gHSx4xXsDWBg6s0gRnV3IctaH
	zW5fL1HkLggVCIYxNAgOELjUMUnPFMHeQK68mUcbWs1HucPUg47MAQ5F1RhUYPQ3yixhUoPWBMO
	Mkshqdy0FnGynf0/R/LsYusG08yjjr7lkvieIfDpXQBR3LU/EOSQ4wW6fNswQ0KidyiwrDUCGG6
	Swg1v5iqs/EtwOA==
X-Google-Smtp-Source: AGHT+IEanomM0uBClXIAdabeKJSIm41T83oGDtOVqnFsMRhIN+NlCFIyaB46i6op0dkiYwNIf1+dsA==
X-Received: by 2002:a17:907:9718:b0:abf:c20d:501a with SMTP id a640c23a62f3a-ac3290b6383mr73370666b.16.1741893198827;
        Thu, 13 Mar 2025 12:13:18 -0700 (PDT)
Received: from google.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3149ced82sm113262066b.123.2025.03.13.12.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 12:13:18 -0700 (PDT)
Date: Thu, 13 Mar 2025 19:13:14 +0000
From: Quentin Perret <qperret@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] KVM: arm64: Move hyp state to hyp_vmemmap
Message-ID: <Z9MuSsOQuTy1kAwK@google.com>
References: <20250227003310.367350-1-qperret@google.com>
 <20250227003310.367350-5-qperret@google.com>
 <Z8V6xOVCPp7OOX6g@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8V6xOVCPp7OOX6g@google.com>

On Monday 03 Mar 2025 at 09:47:48 (+0000), Vincent Donnefort wrote:
> [...]
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index 1a414288fe8c..955c431af5d0 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -194,16 +194,20 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >  
> >  	/*
> >  	 * Adjust the host stage-2 mappings to match the ownership attributes
> > -	 * configured in the hypervisor stage-1.
> > +	 * configured in the hypervisor stage-1, and make sure to propagate them
> > +	 * to the hyp_vmemmap state.
> >  	 */
> >  	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(ctx->old));
> >  	switch (state) {
> >  	case PKVM_PAGE_OWNED:
> > +		set_hyp_state(phys, PKVM_PAGE_OWNED);
> >  		return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
> >  	case PKVM_PAGE_SHARED_OWNED:
> > +		set_hyp_state(phys, PKVM_PAGE_SHARED_OWNED);
> >  		set_host_state(phys, PKVM_PAGE_SHARED_BORROWED);
> >  		break;
> >  	case PKVM_PAGE_SHARED_BORROWED:
> > +		set_hyp_state(phys, PKVM_PAGE_SHARED_BORROWED);
> >  		set_host_state(phys, PKVM_PAGE_SHARED_OWNED);
> >  		break;
> >  	default:
> 
> Are the SHARED_OWNED/SHARED_BORROWED still relevant since the introduction of
> "KVM: arm64: Don't map 'kvm_vgic_global_state' at EL2 with pKVM"? It doesn't
> seem we have any !OWNED pages in the hyp anymore at setup, do we?

That's a good point. I personally don't hate that we have this code here
for completeness though -- it's simple enough that maintaining it isn't
too bad, and if we were to add shared pages in the future it would 'just
work'. But no strong opinion. I guess we could also remove this code as
a separate clean-up, this isn't specific to this series.

Thanks!
Quentin
