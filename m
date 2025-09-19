Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E0D15E90
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 10:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758276381; cv=none; b=YFE35ouk37jALfPUVhteC91UUE0yi3wpHbgE3yj36gv7QEKrL9ocRnS0UkDjk/94flLDFdr79EV2EG7vrVwEt+h6FsZBbWbPHQPAvzQLIByyqlrZh2j5tPTZELz6loIweM+SybyYGCw+4rpoopjoMdRtjwOwUwUVeeFizhxLDuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758276381; c=relaxed/simple;
	bh=pGotopC/5Jk7V4SNfZ9mLDWTas1twe3tpwHA4hMtewU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8EtvKv+muwWBu3Z2IPYMd4IBR33BTfgKFl8lr3EhAIaqWAIlJF9nouPpBjaKQcdaV2sXtcXA7ubsUAWxeOH1/qwmxgPlstqT6T6Vw9atiINvYm+9cKYeiFM9Gzzs+4Uplg5K3DneXUSt5A4TeInTHaCAbeerIwaE2uB3CBGOIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=exUaZg+C; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="exUaZg+C"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45b9a856dc2so13136005e9.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 03:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758276378; x=1758881178; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UAZLPCCH0EgC7m1vhKAbHLebwwq6tBL7BsLJTj4U7Qk=;
        b=exUaZg+CJnbaPd6ZriGhnnQquZrM5cbdXdGZoKMebtcL6B0jeChLzLW8xKM16TvPVx
         PXLZNKlDhvSz9mhROSq6eXVbHSaI5havjZzWPlwdreIgeQDSAz8PmA95uKoFH/QBdaOY
         fWZ17R16wB6NkIFigy+XyZUf7SqwrEBP9+AbOMhOHChqT46l4IuBk4FUowq5zoxbgpEg
         gjPHuGpQdFkJcDeI3upJ7rtrnhUpw7/Mn7jC2SmdlcKZlVX6iHi4e6ZNZZbf1+3qYX7Q
         /q0pyBwIcym8R5g1K7/QRl/WJWgHtsVIYJgutRitGvWmjUK9Gb9YIi2cDtziIvFCX877
         vK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758276378; x=1758881178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UAZLPCCH0EgC7m1vhKAbHLebwwq6tBL7BsLJTj4U7Qk=;
        b=d16fWQ02/sgCOnZP8A6JdgL6x36J4jlndKOJTfaqMspvbGJ8efU+c/lAFX5pGBuWM+
         l9BOC2+h9lwuLoh5NQ5Ead8ziggMdHmUELDSSA/UJgAV8DJKdl4PK/WCAbeLofSCOK0Q
         sugTttYx/dUwiFXrE8cpR0rCyyFndbxOP1fKHCycanZnohWi+0Qc8rVvFACUM5r0vHAG
         rnyvCrcLAVS6P++hw4RZECPKfjJ+se5F+jJKOnxhXcC+Ov+XgoT1i8UsR++0sOR4eHYB
         gGoJ/toS5W3YEr/MpbH3jFEnqH1lXyEdaDzbEIyxinOW3FL7FZSNyMzTZz0na7SJaKO3
         iNfg==
X-Forwarded-Encrypted: i=1; AJvYcCXIXBu3M9easTYIWRDM55mt/e2ndKS57EcxlbKAyZdnoswnjLEE/foiUkDIGFnq15Sw72Cjr5A=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAsFG9tWZt7WN6Yw20hLDfaJGdZZcSlUXQv2hUH6cMc+McbpeK
	PxZ786ZlRoYCq/Ss938E/lMlSauA4hVvZXzWjhNblz4/udiSH8+ZcsYf3ReLzW6a9Q==
X-Gm-Gg: ASbGnctnbaY3yb+xAhNU3BNl1E13IWmmWD8bVNJYBt3LKzpO2Js3vhPIiXjd9lPJWG/
	gM0/b3hp+2p3Ew+xXj+i/YRDnEy9kjgUEaLY89liYC1mqLLWr0CgAv6Lpdrs5epPlAXIDDIzb88
	7s/VzNjF6Eu2sjOP2eurMimxeVHXoXzw39wlbh8ra0nuHbGm9NBKiJiE6Zvv7DICVjCzuteBV03
	WOwkWoyYO0/w1NYmc2EQOyL6yD1IBt/5ANxVVrnk3A9QJQZaJ5K7T34fhAHLLhAA85aLTTHrazN
	LSsTIP3C8M0Dl6cJbB45KdY9thtA6g3ucd4aXt1Jq3PWXLWDi6Np8moezSS8jT4g64SGob1ysw7
	DeZ3KmNESEjbuIcT4ta+qiN6RY9Px3B/x29G/4Dqkqhe3gmIH1+MG5aRLifGzSnpHPw==
X-Google-Smtp-Source: AGHT+IH7j5nrNszhPGZwafEQxw3v7iML2APU56b+3QSFjy1ZCXsWbsqVwmzYYDNqTZhcotIDu8aX+Q==
X-Received: by 2002:a05:600c:468a:b0:45d:cfee:7058 with SMTP id 5b1f17b1804b1-467ea89da77mr24405135e9.22.1758276378163;
        Fri, 19 Sep 2025 03:06:18 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f6695a9dsm81189215e9.24.2025.09.19.03.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 03:06:17 -0700 (PDT)
Date: Fri, 19 Sep 2025 11:06:14 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Quentin Perret <qperret@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, sebastianene@google.com,
	keirf@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Validate input range for pKVM mem transitions
Message-ID: <aM0rFlaVKRkNxQPS@google.com>
References: <20250918180050.2000445-1-vdonnefort@google.com>
 <cf3v4dn233bf6y74ythiqulwfnshcdmddsdx3iqcenqjos5cct@zkcw7g5ieei7>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf3v4dn233bf6y74ythiqulwfnshcdmddsdx3iqcenqjos5cct@zkcw7g5ieei7>

On Fri, Sep 19, 2025 at 09:52:20AM +0000, Quentin Perret wrote:
> On Thursday 18 Sep 2025 at 19:00:49 (+0100), Vincent Donnefort wrote:
> > There's currently no verification for host issued ranges in most of the
> > pKVM memory transitions. The subsequent end boundary might therefore be
> > subject to overflow and could evade the later checks.
> > 
> > Close this loophole with an additional range_is_valid() check on a per
> > public function basis.
> > 
> > host_unshare_guest transition is already protected via
> > __check_host_shared_guest(), while assert_host_shared_guest() callers
> > are already ignoring host checks.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 8957734d6183..b156fb0bad0f 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -443,6 +443,11 @@ static bool range_is_memory(u64 start, u64 end)
> >  	return is_in_mem_range(end - 1, &r);
> >  }
> >  
> > +static bool range_is_valid(u64 start, u64 end)
> > +{
> > +	return start < end;
> > +}
> > +
> >  static inline int __host_stage2_idmap(u64 start, u64 end,
> >  				      enum kvm_pgtable_prot prot)
> >  {
> > @@ -776,6 +781,9 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
> >  	void *virt = __hyp_va(phys);
> >  	int ret;
> >  
> > +	if (!range_is_valid(phys, phys + size))
> > +		return -EINVAL;
> > +
> >  	host_lock_component();
> >  	hyp_lock_component();
> >  
> > @@ -804,6 +812,9 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
> >  	u64 virt = (u64)__hyp_va(phys);
> >  	int ret;
> >  
> > +	if (!range_is_valid(phys, phys + size))
> > +		return -EINVAL;
> > +
> >  	host_lock_component();
> >  	hyp_lock_component();
> >  
> > @@ -887,6 +898,9 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages)
> >  	u64 size = PAGE_SIZE * nr_pages;
> 
> It occurred to me that this can also overflow, so perhaps fold that
> calculation into your helper as well to be on the safe?

I believe this is currently fine everywhere because nr_pages is solely used for
size computation. But happy to use nr_pages as a range_is_valid() argument
(instead of end) to verify size as well. That'll surely be more future-proof.

Let me respin that.

> 
> Thanks,
> Quentin
> 
> >  	int ret;
> >  
> > +	if (!range_is_valid(phys, phys + size))
> > +		return -EINVAL;
> > +
> >  	host_lock_component();
> >  	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
> >  	if (!ret)
> > @@ -902,6 +916,9 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
> >  	u64 size = PAGE_SIZE * nr_pages;
> >  	int ret;
> >  
> > +	if (!range_is_valid(phys, phys + size))
> > +		return -EINVAL;
> > +
> >  	host_lock_component();
> >  	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED);
> >  	if (!ret)
> > @@ -949,6 +966,9 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
> >  	if (ret)
> >  		return ret;
> >  
> > +	if (!range_is_valid(phys, phys + size))
> > +		return -EINVAL;
> > +
> >  	ret = check_range_allowed_memory(phys, phys + size);
> >  	if (ret)
> >  		return ret;
> > 
> > base-commit: 8b789f2b7602a818e7c7488c74414fae21392b63
> > -- 
> > 2.51.0.470.ga7dc726c21-goog
> > 
