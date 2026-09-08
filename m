Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965104EE87D
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 10:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862977; cv=none; b=ZbXn5dv7r69WOrnuh7rCbmAJ3cP6FXloviIANl/52Y4BNgbMYwkAHV830CXWvZl0PozgjCxGMZqtyqq1+cnlcq3mw4RoajOWXj5T9lUnF4qNTXx8I4vM/NMQHwx6tW7oLuU6wOWlBclSuigAHBTmmQmNSuLn6J8+Hdl778RufQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862977; c=relaxed/simple;
	bh=S16BnqnQEXS6+rIFDP9X6Agn/1YPz0UFmu6f9UdNFgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XVBkHhlnYS3qv6j0ZH++VKGxcWQI3v0bA3ezsE8iQoMzQGIy4f6r0rVkyuyIY1YH2YK/WWo9azS2OozXN4yvDfvpkbbxM5JXikBOITMD4Kk7gPAIjwW2+B5+Og0+A7IMNBcLpffu3NT7DFw75dx62ctDz6liPcvnATGnfU9H5kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g2N35io+; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g2N35io+"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-482e067e908so3601983f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 03:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788862973; x=1789467773; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HAisO6OEJOG++OlGeDq7L3T84lbig4NarZZMlO0RsUg=;
        b=g2N35io+JWZK5KO0cPQMBONV0gKNIzX7pKZN969+BTRd4JBAV4rY3+KwkC2YJZVnVt
         bqCcAKnhf/jQSfPJZUaGHohzi1XQ0I+h7JF40khXqM87uJR8RSqawaIAQ1JwxWoN0mBP
         +Vad27+ZoK3C+s/HZ3nfRfIfV1byF9hmNumd3uxdYNbEgZbTptr0cSsfN1+eLP5OAHQB
         gahJWpeRADXhYYXcAWQSLQbdafycLCQkn6jopWM45dwgjTz+uWk+c7lzmDgPgAW8/Jiv
         0pSHV9u8gfo51pWC8SdfU+YFbuWIbdGVPB7r5Nu7OvwkmZO5LFjUdlNUZeJLq3BI9S0O
         iqSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788862973; x=1789467773;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HAisO6OEJOG++OlGeDq7L3T84lbig4NarZZMlO0RsUg=;
        b=GVcJxMXJpZq7rzCyQLHdZNySatYTcG0ZCkKovL3dpwKlBXV/Yr0aU1THfZTWwUVrCf
         Xf/fl/U+cBzHId0VqldPq2BSvIySYB900sWJJCu93aR35IgvkoismYLOT+nlunbCt9Gd
         E7dsZvgTjnZt6tCfArGJlxrkN72nVDmyMQkWO46j3XsTXUeCgb/32iFqxp29ND7st5bG
         VkgFwDfa3xLOCCeaqkhZy1cxXA6PKSNb1xUyX4ia07OkcJsJF5iXpB0kKwRB6RQoSFXh
         pviTffqRGs7Q8r09Lb5tk8Z6hiBqNtvd/KtFFU2cZvRRwxD++0hxZrwEgFHmh5QhHuSP
         6eRg==
X-Forwarded-Encrypted: i=1; AKwUvBwNkAsK/XKnSoBP3v73BVC9FX3VD0KeFEMNZjiz2Rmi2SQDgL4UlqTv8+faDO6AjJokjfwamRY=@lists.linux.dev
X-Gm-Message-State: AFuF++lboHwQhyoJRlLuARf/s3E8T0IjzQ9S1vvUjhHr4N/lJ5s4kFyK
	sgwgXYw3oF3DTSFKTv2Twx0GWMyE+mgAvTEYx01xfhqa+tfQSxdeHUVpPz6L6FD2MQ==
X-Gm-Gg: AYBFou0TGNeYKQV21RHfL5PveIB1PGGsbsTGrLcJGAkN8SC2Zq3oDrrRYKT96aF/sBj
	DcCTK8Ziy3gyAAnyDzBX+53mFDTDYt6V4SOULnN1RLHOIASZuwQCHJXKt5ZhmNrVbwRMl8803NQ
	Dkzv6+H/jFsOJFrG+Bs1xhx31u8fZU1r2rzsHNsElxpLi1wxgfm/TwhURZtLE4ZyC9hxk8MRLAL
	FZzYexswaX0HA1jWH8at180HeCnvWB1Zz9hesyk9ommZMdD056AIGu/eUOm9OpO7ZrRcl0ebZNx
	CWmwgmC73V3IzLDpA2n1vxUKxFZowrC3wMmeqr+glfXkEkkgFWbcKcowL50YAPk3SY5upA9U5yj
	mxwRWV/UNB6MNkKVjrY9qiuIWUnL4tkZ22j9JgDQag9CzJx7JhlvG3D3KjoWmztp4r2r7qedF8q
	Lo8WB23ufAAoynn2kEIW1ROXkfOvV+WFQyMVyIBJIzGIYUthglhbp6OmzdyJo4bahldMixbLq7r
	j1mt6xo6Afu87CtbKkztSpfjSDGjsyG
X-Received: by 2002:a05:6000:260f:b0:485:8be8:b2ba with SMTP id ffacd0b85a97d-4858be8b4bcmr28419306f8f.49.1788862972857;
        Tue, 08 Sep 2026 03:22:52 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885bf3f0sm38852156f8f.33.2026.09.08.03.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 03:22:52 -0700 (PDT)
Date: Tue, 8 Sep 2026 11:22:49 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 08/20] KVM: arm64: Add a range to
 __pkvm_host_reclaim_page_guest()
Message-ID: <ap_h-WrHqbxiiAH7@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-9-vdonnefort@google.com>
 <ggblnclfadr4oy7i3d43okgedqqx3ak5edhxfrjhceh4763xyw@iyxtswi72edn>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ggblnclfadr4oy7i3d43okgedqqx3ak5edhxfrjhceh4763xyw@iyxtswi72edn>

On Mon, Sep 07, 2026 at 03:52:34PM +0100, Wei-Lin Chang wrote:
> On Mon, Aug 03, 2026 at 11:08:52AM +0100, Vincent Donnefort wrote:
> 
> [...]
> 
> > +int __pkvm_host_reclaim_page_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm);
> >  int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
> >  			    enum kvm_pgtable_prot prot);
> >  int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > index f04cea5ff389..0d17e59d5335 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > @@ -74,7 +74,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
> >  int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
> >  		     unsigned long vcpu_hva);
> >  
> > -int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
> > +int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn, u64 nr_pages);
> 
> I feel like __pkvm_host_reclaim_"page"_guest(),
> __pkvm_reclaim_dying_guest_"page"() aren't good names since they deal
> with multiple pages now.

We could argue that it is "huge" page, but then none of the other mem_protect
functions are using _page_ in their name.

> 
> [...]
> 
> >  
> > -static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep, u64 *physp)
> > +static int __get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa,
> > +				 kvm_pte_t *ptep, u64 *physp, s8 *levelp)
> >  {
> >  	kvm_pte_t pte;
> >  	u64 phys;
> > @@ -905,20 +906,32 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
> >  		return -EHWPOISON;
> >  	if (!kvm_pte_valid(pte))
> >  		return -ENOENT;
> > -	if (level != KVM_PGTABLE_LAST_LEVEL)
> > -		return -E2BIG;
> >  
> >  	phys = kvm_pte_to_phys(pte);
> > -	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
> > +	ret = check_range_allowed_memory(phys, phys + kvm_granule_size(level));
> >  	if (WARN_ON(ret))
> >  		return ret;
> >  
> >  	*ptep = pte;
> >  	*physp = phys;
> > +	*levelp = level;
> >  
> >  	return 0;
> >  }
> >  
> > +static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, u64 size,
> > +			       kvm_pte_t *ptep, u64 *physp)
> > +{
> > +	s8 level;
> > +	int ret;
> > +
> > +	ret = __get_valid_guest_pte(vm, ipa, ptep, physp, &level);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return kvm_granule_size(level) == size ? 0 : -E2BIG;
> > +}
> > +
> >  int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  {
> >  	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> > @@ -1001,7 +1014,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
> >  	host_lock_component();
> >  	guest_lock_component(vm);
> >  
> > -	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
> > +	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &phys);
> >  	if (ret)
> >  		goto unlock;
> >  
> > @@ -1033,7 +1046,7 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
> >  	host_lock_component();
> >  	guest_lock_component(vm);
> >  
> > -	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
> > +	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &phys);
> >  	if (ret)
> >  		goto unlock;
> >  
> > @@ -1285,6 +1298,14 @@ static void hyp_poison_page(phys_addr_t phys)
> >  	hyp_fixmap_unmap();
> >  }
> >  
> > +static void hyp_poison_range(phys_addr_t phys, u64 size)
> > +{
> > +	u64 offset;
> > +
> > +	for (offset = 0; offset < size; offset += PAGE_SIZE)
> > +		hyp_poison_page(phys + offset);
> > +}
> > +
> 
> I believe get_valid_guest_pte and hyp_poison_range changes/addition can
> be made into its own patch, focusing on small helpers?
> If so I believe it can make reviewing easier.
> 
> Thanks,
> Wei-Lin Chang
> 
> [...]

I am not a big fan of the "No functional change intended" changes, but it is
true that this commit is quite big. So if you believe this makes it easier to
review, then let's split it.

-- 
Vincent
