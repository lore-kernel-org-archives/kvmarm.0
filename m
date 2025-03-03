Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D351D9A5F
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 09:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740992597; cv=none; b=Fz8EUs+UlETwr4EgJA6p1WwxKHnPsk+5dniA3mYBxt+g6shWTBYDvjtOYXPKFLYA+IuSoduEwbd7kjROolh0eqvuX+1+fXfDbTl6UR2Z8kBAQ3hwFM2Zsi3b+HISiLyFv3nDUMC7094b8gPXiBbykUfvbXNHbWcVcS8iA1SVz7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740992597; c=relaxed/simple;
	bh=idc8/NACOix78GnnSHuzlC9mQg3lcaqnvWb9GYuGSuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UorEGdrEg/8dONsKmKZhzpg65Hfeac8PhPuBtWJG31YJ5Q7mfqr3S5I01XnsoI5rTZ5lb16g/PHd15b8WnGANNBVXr2nd+U/K6eFDO7IN67+N/vJdBbPvCl/HO38SAxKwmTh/hnbw4hn90thndcygViRa+NgBQhfqc6VJPiZL8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IIYVb5Up; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IIYVb5Up"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-439a1e8ba83so39389175e9.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 01:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740992594; x=1741597394; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fnE1WKL8B2Bxfl1xiklk44H12/SEhBZrUiboyYR/TqM=;
        b=IIYVb5UpP6ms0YH+Ni9C8hYPKC1KTKgKqwKFULVEakMzZsIATsGYe6AX65t7amvLkc
         HgYAOmjZKLMIANHwWe/uXd8hC9Ze/49xfrov5Hd1mB0VUBvIZSCGanSfsxkGdJzLn/pi
         +LgmCIihkzb5lYDYk+3JwBQYJyIvNU1GFGRgQUw1d0xqVB+GKwv7OwjTeZ5iytKXyAXx
         /3/XicFd1ShMYXyZvyYuWaduhhd/ewInLOFYyqHg7HyiuAx+WGspHHX6vGtdiojxSs/d
         glNgv+G0ZCOKieTx6JaGS2Xwd4EgoNb+cXnluYpNF7tsLa2x5X0rwUGoUhcGTBy9YCcf
         L3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740992594; x=1741597394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fnE1WKL8B2Bxfl1xiklk44H12/SEhBZrUiboyYR/TqM=;
        b=sWmQLdiLpBvhaQV2Y6ntdOb40v7h01bUVP/qgbsPLPMskIRJx5C9QATggMviTm9dWU
         56Wny38DkqWaxgTMTZKgg3Sfelu0fvCuPwJZWLd46j9G5MJvsl2xDijY5ccoVIH20qAg
         519OZWJb6Mn8+u0iX1Upp3yW6tD4YllLcYHSd8pxLM9LcuBLItx247Kv5/lz67lpADRn
         +WVsUoXO0Ncqdrm6ijUi+KdY+ERxAtwL6BmCYxw3dCIF3lXJzOPsHXe8pWhRAPfBPELW
         GsJrBCtQRdw/GvS4P3FlovnAabsARTtBP8AmPGpN1ipnvEsphbhWUBbMnRp4LMEYS47c
         4BEA==
X-Forwarded-Encrypted: i=1; AJvYcCXNVHJZ/7ynlFM06IrJMJxDv3WdC56ALqvmZWZmDJjuAlKvoexMo3bnv8rz+0HKpBUdC/31DjI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy5LoVCea92XVPCl1+ZW+DVljXSzVwYgG/jf0tg+kj+BoUKCI8
	nNuW5qgcxR4F1s69oOfEmpq1eody91XQrwJeUYvVuWQLU1aZZz9TNbtxBI1v5Q==
X-Gm-Gg: ASbGncuI1JiHeHQ2gLMuqUhutv9yo71idRXs0VF2rWjKr5TYwmqmv1eEhdOU7GxOGs2
	C8d1r0Tolmpe4cjmb3IeyUg3yMtIiTQUWC1QS/R0a8Kyvw/JUTiYDhZvhRS0r2jiezexYpj5hsL
	kGVYzzNwoa8jpnpOFz/G0epkHL5R8/+qhhbqSCHzTBKwj10iPOlNscp7d1EvmYy4g1VrmLyxTqf
	4qkccwr8pmOBxeeX2LPwQjMLpjow1JuU0RRyxOjuCq80K8vzCcXZLdhG/77KkrZfsfWD/24jC2C
	oJC3o/2OskTddJQo5tAAuYewimZuI3TkWhRvbmMi9bmZmkDIm4Cgqijn3L0W+WmiO6R236DxVcE
	Cfm/1yX4kh6YU
X-Google-Smtp-Source: AGHT+IGmAnvr5WwwGoSHGFphkhVZV6m70wz82I4YVRSVF548RcAtlCMZxGhqjzzDdhfLipt7qPEkPw==
X-Received: by 2002:a05:600c:a45:b0:439:9537:e96b with SMTP id 5b1f17b1804b1-43bb60464acmr37468755e9.14.1740992593951;
        Mon, 03 Mar 2025 01:03:13 -0800 (PST)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43aba58713bsm186635635e9.34.2025.03.03.01.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 01:03:13 -0800 (PST)
Date: Mon, 3 Mar 2025 09:03:09 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Quentin Perret <qperret@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 2/9] KVM: arm64: Add a range to __pkvm_host_share_guest()
Message-ID: <Z8VwTf8nMvRNjgU_@google.com>
References: <20250228102530.1229089-1-vdonnefort@google.com>
 <20250228102530.1229089-3-vdonnefort@google.com>
 <Z8IJRpoQUoGazLku@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8IJRpoQUoGazLku@google.com>

On Fri, Feb 28, 2025 at 07:06:46PM +0000, Quentin Perret wrote:
> On Friday 28 Feb 2025 at 10:25:18 (+0000), Vincent Donnefort wrote:
> > +int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
> >  			    enum kvm_pgtable_prot prot)
> >  {
> >  	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> >  	u64 phys = hyp_pfn_to_phys(pfn);
> >  	u64 ipa = hyp_pfn_to_phys(gfn);
> >  	struct hyp_page *page;
> > +	u64 size;
> >  	int ret;
> >  
> >  	if (prot & ~KVM_PGTABLE_PROT_RWX)
> >  		return -EINVAL;
> >  
> > -	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
> 
> I'm not sure it is safe to drop this check here, see below.
> 
> > +	ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
> >  	if (ret)
> >  		return ret;
> >  
> >  	host_lock_component();
> >  	guest_lock_component(vm);
> >  
> > -	ret = __guest_check_page_state_range(vcpu, ipa, PAGE_SIZE, PKVM_NOPAGE);
> > +	ret = __guest_check_page_state_range(vm, ipa, size, PKVM_NOPAGE);
> >  	if (ret)
> >  		goto unlock;
> >  
> >  	page = hyp_phys_to_page(phys);
> 
> Phys really needs to be a valid memory address here for 'page' to be
> present in the vmemma -- dereference right below. So we can't rely on
> the check in __host_check_page_state_range() sadly ...

Haaa you're right. Sad to have this double check. Perhaps I won't use
__host_check_page_state_range() then.

> 
> > +	ret = __host_check_page_state_range(phys, size, page->host_state);
> > +	if (ret)
> > +		goto unlock;
> > +

[...]
