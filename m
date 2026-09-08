Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E483E3A5449
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 10:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863218; cv=none; b=g/VJODGiudcJgxYKfCIhBRB26V4D6M3GKxVrSp119Hqni1M6TkJc3EkARf7Z30hh1JA/6zm9YZKQjuXIPHPovBv6EfUca5IuZqpylaHTMN27ObdK5zOyD10fI4637l8ARF5u7mqOiVZzQP44NqfQJuk7fFXTbnhVdxVC5+OsIYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863218; c=relaxed/simple;
	bh=nDv53VU3UCb+uulWzv6ctC1KYfW0oCKNeYQCl/o0Eo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBSz70f68IRRLS5n4psfV44/TCEFVXXKt/rLmrrMBWzRkfGZ3t6DoDBgJUQwRJ33tH5PJftF9s5JNQZODPi79MmwO15fmdSAL02C8nvGiwWMa+mRYEjhawu2w+fn8xM+1LlH9r/uZPRl20cqlcBUYTnxtvm4KaXm6J4H3axLcKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nakQvip6; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nakQvip6"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49b8eeb3ff2so42020495e9.2
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 03:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788863215; x=1789468015; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TFpNp3ZqO7N2Q9SVPtLMBf2AYYHJ1sRkpIuyR1lzdHQ=;
        b=nakQvip6OsQaV3i2JwWsdqvkv2l6Bs6X0AX7ViB2YRm7egJiNMz1iMjhRdPyEtn2U3
         8aiEncYtSJVXhOZ7YGE0gSzjuSD2LD8J+gD6yjWTDL9FVXqONSWzmEEbbkhUipCMZWzG
         2/D+4Q/DXS1/rH2A2PB0oQfOHxK0/QSQtMvvmAOQWlo2YgAJRLDkG2szhnKRYzM0y4jZ
         f0v8lT89MlaRksjJptv5xidLcuJCi5CZDJRbiTy8fY7qLBsKpuX93Eoh+FHI6icPDbm9
         nEfrd5x8X1N+fHz8h29RPmMV5d1zBv+a/1APqzLUn9D8hj/5H6GaMMbKGZBgk6D9A/s6
         XmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788863215; x=1789468015;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFpNp3ZqO7N2Q9SVPtLMBf2AYYHJ1sRkpIuyR1lzdHQ=;
        b=M3yZS8IE8SH9y+9V2UJhw0VrHQC26n0DfJ9s4Mo3bRIY7Fovglc//uftDNHNNR2iUn
         gps8+MdWA9RcjhsYgmJUx6y3ZnPVR7lJqVeVuIIccW2r3n3QG396Nia14K+782rsQM3d
         SDz2IRFJVyIc/rqT7Qxk+N8mT8eAw3yJOsxlimtmPI+/zK56DgZBC8u1RTNHeelq1Vpj
         Mst0g8iIQAlFEMo64LQxWXRSkXFtuXGtAbCkph8OaWkbeb58LaVZk2/GzLXuFfG9f77t
         A4pQtDUaJ9aEWJZk4eECmCsXI2DmE9fSVezUxkSbfh+OWzGNtNYRumfaBQ6OYBN+mUoU
         sH2w==
X-Forwarded-Encrypted: i=1; AKwUvBzfQA11Fs6Vmcd3M3LvTvxkVSz5piHOkWZpO0LrlY8g2YFt9ETtiiDAJTuSDX8soV4l7IecYrQ=@lists.linux.dev
X-Gm-Message-State: AFuF++lR4+Y/SQGOhU4QnVLZIiUWT3a+FDtHRqZXjnlbxq5rVvtsPOhK
	0swA3JqN6xHdyvua2Q3BFpRCTzjqbKgIniHnRaKehAQTfeIB+1Whf9H9ChsxhRPw4Q==
X-Gm-Gg: AYBFou0DO1cM5oE8UEl8gdNzA5lPLorJwI92PvwweshhAiTXWt+9vMg0+bngSt63WV4
	wueKjQG42AqfQuPQEllnn04XoozhNewGd0fjbJb9YUhAc3/a+KuDegfzQquYb5+j3ALmjTGT0P/
	Wd50bqnj1YKste4GoSHch7gUUN4Rt/m86GXR63naN5Y0VY+6DgNmINO2VkVkFhxXeTSsVfYjPLp
	rh9H1gJ/ufsMFIRo9A8O0Fy3MBEHN+kgRWl7QIGVP5feHSUXw1Sh10Uaf6ZO6D8AFpGmwnY3hlU
	n92MNP8FEv3ysmsSxpWDec7wgqyA17HFSiN0p3ne7BKRdhUPuG2EvESzDonLGxgNBFbMMyFu6Wh
	axoieI7pzpDunkulunAufFMyBeXzUHqA6OLlqkSRBpNY/Cj+/KAdR9+lnHmU80vxKcX7FBya3Du
	5DH60sAckWKic/CmB20cFKmILSNICZGqLgr+rB4ajugqofepTbJQk4/RGYKMp0aYHYUYJEou8j/
	H9gY6IH1116SadU0u1uL/HUrUv6bw2yFw==
X-Received: by 2002:a05:600c:3e0a:b0:495:6e68:5df2 with SMTP id 5b1f17b1804b1-49cf8267a36mr365637045e9.12.1788863214324;
        Tue, 08 Sep 2026 03:26:54 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4859162f354sm27909246f8f.20.2026.09.08.03.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 03:26:53 -0700 (PDT)
Date: Tue, 8 Sep 2026 11:26:43 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 12/20] KVM: arm64: Handle huge mappings in
 __pkvm_host_force_reclaim_page_guest()
Message-ID: <ap_i40-JQnXf4w4O@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-13-vdonnefort@google.com>
 <yzeb47zjrxdsfztilng7n4e22fnsm4ncqjeqzmryc7sqncuqw6@pjtshmjxwelh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yzeb47zjrxdsfztilng7n4e22fnsm4ncqjeqzmryc7sqncuqw6@pjtshmjxwelh>

On Mon, Sep 07, 2026 at 05:52:35PM +0100, Wei-Lin Chang wrote:
> On Mon, Aug 03, 2026 at 11:08:56AM +0100, Vincent Donnefort wrote:
> 
> [...]
> 
> > -static void hyp_poison_page(phys_addr_t phys)
> > +static void __hyp_poison_page(void *addr, size_t size)
> >  {
> > -	void *addr = hyp_fixmap_map(phys);
> > -
> > -	memset(addr, 0, PAGE_SIZE);
> > +	memset(addr, 0, size);
> >  	/*
> >  	 * Prefer kvm_flush_dcache_to_poc() over __clean_dcache_guest_page()
> >  	 * here as the latter may elide the CMO under the assumption that FWB
> > @@ -1304,19 +1302,15 @@ static void hyp_poison_page(phys_addr_t phys)
> >  	 * host stage-2 and would otherwise lead to a malicious host potentially
> >  	 * being able to read the contents of newly reclaimed guest pages.
> >  	 */
> > -	kvm_flush_dcache_to_poc(addr, PAGE_SIZE);
> > -	hyp_fixmap_unmap();
> > +	kvm_flush_dcache_to_poc(addr, size);
> >  }
> >  
> >  static void hyp_poison_range(phys_addr_t phys, u64 size)
> >  {
> > -	u64 offset;
> > -
> > -	for (offset = 0; offset < size; offset += PAGE_SIZE)
> > -		hyp_poison_page(phys + offset);
> > +	__apply_guest_page(__hyp_va(phys), size, __hyp_poison_page);
> >  }
> 
> Patch 8 introduces hyp_poison_range(), and it is reimplemented in
> another way here. Maybe just do it this way in the first time?

Especially if I split it into a separate patch.

> 
> >  
> > -static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
> > +static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_hyp_vm **vm,
> >  				      u64 *gfn)
> >  {
> >  	enum pkvm_page_state state;
> > @@ -1344,34 +1338,43 @@ static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
> >  	if (ret)
> >  		return ret;
> >  
> > -	if (WARN_ON(level != KVM_PGTABLE_LAST_LEVEL))
> > -		return -EINVAL;
> > +	/* We only support either PAGE_SIZE or PMD_SIZE */
> > +	if (level < KVM_PGTABLE_LAST_LEVEL - 1)
> > +		return -E2BIG;
> >  
> > -	return host_stage2_decode_gfn_meta(pte, vm, gfn);
> > +	ret = host_stage2_decode_gfn_meta(pte, vm, gfn);
> > +	if (ret)
> > +		return ret;
> > +
> > +	*size = kvm_granule_size(level);
> > +
> > +	return 0;
> 
> This can also be moved into its own patch with get_valid_guest_pte(),
> hyp_poison_range() changes in my opinion.
> 
> Thanks,
> Wei-Lin Chang
> 
> [...]
