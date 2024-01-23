Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F6182D81
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 19:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706039366; cv=none; b=a3Yk8TMT64cJCTyClvFH1yNbTif0DyXMrzDS0EtJY5Npqe3ZtjSniF7xo3ChthX9MXpZ0LObB6z6uKMjarmjSSm9NQqcTi7ojdgmW3Ayn2dvca5hpyfHqBXGYOEwGId6Up/NKXtb+E38jCvgWzCZI5V0mjeIxLTsuBWunFRnaJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706039366; c=relaxed/simple;
	bh=5a50XFyy6hbMzQLCzCl9kkt/qQbAxlHL862YhlOKj08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XaE2PdjSxPVmZRaBhFc3MsL65PXwksOhICSWI8EyI3n4hRVaGvtTpoZzzqnFKzEiAOWoMRfMq03LQHPXKxp2Yv+w9S7A5gF1wTxi6HH4SuqrZMyiJEoMxsNkwCRt+jK2evZFQniSF+jLSbdp03cApahhvK5FDBDuF2F43aGJ4fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OZjAbReJ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OZjAbReJ"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-337cc8e72f5so4319841f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 11:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706039362; x=1706644162; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4qE28dlWF6DGyTTPmng9ihaceKW+IRRh93UPoev7s84=;
        b=OZjAbReJYEt7q9LAyn88qSuJvjoRNAUyU6ZFmwrrqQoY4zyitzj2w6JR1c01rpKftu
         +vnYRdyi7r0QxnrYYofburgMP+UKiSKvmNoGfKNbA/ta5tdWXMx4NfKxda8o75ZpJjPN
         IaquvCSlrjrHSGSguAqvJypV+g7mAZSTdoNfd/XsGtoau5tQNieCznP9BEI6FFTVvuEe
         KTTBBH9KwvPNQbk0tuwbd0eo1p1EUWErIKmlO1cR8rS7hD2t8+EWvx5A6EUGNuQ5sDqx
         pXuRQmLTdMcPnbjfliKY3cNEK6CO8ygTYeTgj+FfNBTXFMnMeHP6QSZ3MTc3OaPIKyaz
         NFxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706039362; x=1706644162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qE28dlWF6DGyTTPmng9ihaceKW+IRRh93UPoev7s84=;
        b=oaf750wCN+BuZgCVLlsPZsIjDKVz9z6ARz+K6itortuCqHklTd7ofOZgnCzJxCJNP2
         uEb0mRQpI9cwqwRxWjo722wsik0V7WUJhKQsQvg4dgLioV09QQ+kxTvrUDxsoW+MoeHo
         cydrl/dU8r3uSvFO0IhssKI7GIujiRWlt0gRL/GoaYC1S9U9xbakQnQtDtGt3ayaMtQJ
         jxufzbNlsNBZhFwB2rwnoTFEl2/oFT59CzJV7i8LRMXAN3t2xby8lfEgBrhrRnuMXVQF
         uRlEJDtVoWT26rOT87MQ++RBVET07pJGBRTRdcx52jLC6xoqLHuRyJFl+iMEF/eGaOpB
         hkyw==
X-Gm-Message-State: AOJu0Yw0JyhjS5bZ6Hfo6xh4DzGDtecGyUJhDC2rbbSB7lZYLsrvKU6R
	gpA5x2LMzo/iJsLoh85aJ73zOmMC+tiqWumF4CpnSpJucZRQamg4NcnUukGawqc=
X-Google-Smtp-Source: AGHT+IFumTc9KtJ/kCVLcF8NzAKi14YhOjo/H7kRpM6sr9VqFP25QaURtKyQ3GiPFue0ZdupifoJrg==
X-Received: by 2002:adf:f70f:0:b0:337:c93d:fe44 with SMTP id r15-20020adff70f000000b00337c93dfe44mr2726111wrp.58.1706039362497;
        Tue, 23 Jan 2024 11:49:22 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id e30-20020a5d595e000000b00339237a2752sm10844430wri.33.2024.01.23.11.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 11:49:22 -0800 (PST)
Date: Tue, 23 Jan 2024 19:49:31 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, smostafa@google.com, dbrazdil@google.com,
	ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 12/45] KVM: arm64: pkvm: Unify
 pkvm_pkvm_teardown_donated_memory()
Message-ID: <20240123194931.GB40099@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-13-jean-philippe@linaro.org>
 <ZaVCTuM7KDSWqqaE@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaVCTuM7KDSWqqaE@google.com>

Hi Seb,

On Mon, Jan 15, 2024 at 02:33:50PM +0000, Sebastian Ene wrote:
> >  int __pkvm_teardown_vm(pkvm_handle_t handle)
> >  {
> >  	size_t vm_size, last_ran_size;
> > @@ -813,19 +802,18 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
> >  		vcpu_mc = &hyp_vcpu->vcpu.arch.pkvm_memcache;
> >  		while (vcpu_mc->nr_pages) {
> >  			addr = pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt);
> > -			push_hyp_memcache(mc, addr, hyp_virt_to_phys);
> > -			unmap_donated_memory_noclear(addr, PAGE_SIZE);
> > +			pkvm_teardown_donated_memory(mc, addr, 0);
> 
> Here we probably need to pass PAGE_SIZE as an argument instead of "0"
> to make sure that we clear out the content of the page before tearing it
> down.

But since it's replacing unmap_donated_memory_noclear(), would that be a
change of behavior?  That would be a separate patch because this one is
just trying to refactor things.

Thanks,
Jean

> 
> >  		}
> >  
> > -		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
> > +		pkvm_teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
> >  	}
> >  
> >  	last_ran_size = pkvm_get_last_ran_size();
> > -	teardown_donated_memory(mc, hyp_vm->kvm.arch.mmu.last_vcpu_ran,
> > -				last_ran_size);
> > +	pkvm_teardown_donated_memory(mc, hyp_vm->kvm.arch.mmu.last_vcpu_ran,
> > +				     last_ran_size);
> >  
> >  	vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
> > -	teardown_donated_memory(mc, hyp_vm, vm_size);
> > +	pkvm_teardown_donated_memory(mc, hyp_vm, vm_size);
> >  	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
> >  	return 0;
> >  
> > -- 
> > 2.39.0
> >
> 
> Thanks,
> Seb
