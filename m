Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E51212FAB
	for <kvmarm@lists.linux.dev>; Fri,  4 Apr 2025 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785261; cv=none; b=I8Oj/uaQxMV7FTTU12r/K4/Dd0YsgOOtzuvi7sdHWuqFU5GsL52rOGDypr6ccJGrK9xmsy9pJxndSKm8OkfqyMO76/GacvWyhL1llimjBIcftBjew7Hz/AVPcWuIrmjd3B+VYybB8sFep4mPhxquFDmAWiZH1RVoMRQJHKIBEWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785261; c=relaxed/simple;
	bh=kBOspWRNQ4BmOfPjA2PvOZq3vMDxXt5Q1YQqo0gJ9fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQbiFSAtbx2olXyXySk/L3gIcq7VFYf42qNA4RBrXXynhJhizghGcZSCt6HlXKUhPzgORuBn5dNTrRbQpyVaz/Iy0fqHY51JWoTHvUcREAq9gJlcIf0PRgw/l3fdecE+4z+uZk5G8uYJrKHy4RY49Q9Txmdzd0gLOwKe8fXtT6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zX2wJS7g; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zX2wJS7g"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-391342fc0b5so1784568f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Apr 2025 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743785257; x=1744390057; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YjzowwCzDt7F+kKBoh3+rUz7yp+YdCsAa/lYm8cjXDA=;
        b=zX2wJS7gdHYfaNaNTONa642w5XBpyPIa4IHjuO9kvH8fl6J/9PZIqtYnhJM/sZMN/J
         233/VXVWTahy4xVwxPfxeHaqHrQU30rGW/VQRByi/ukXfmWncWxdi29UaWl38oBrzGgd
         J8r5myo2JosNJ933YgWTdc869XHGF2libdzVRdIy8Ezvj66MEZlcmL/dKC+VZrBjvp+v
         R0DFnwGxrGaOb4nQzA+iNViU+nBa4hguLAOV+Dg9ADSq3h8FIRrb+mMYygAQdN9lOHLu
         ol41wNGPN895EkFP9tzhwNWegWzzvoQGZ4TA4hljny41L45l/mXGUkQKGwvYoYhz5phu
         KglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743785257; x=1744390057;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjzowwCzDt7F+kKBoh3+rUz7yp+YdCsAa/lYm8cjXDA=;
        b=OvfzM5yZsO8nFWudYj9SekFl1rshBp8zaWnXM2yDINp2ZzLq4YOSVVdv65jEfqk/t1
         E/zLbP5apEJh2th9dYk3JiFv8n+NAh3M06zwLB7MtD220OcXdUoNTA3wWUpZgEPCvRQu
         CjFMuEslovVaMxngt/wFuULTExlTgP5/gThQ8RGmrx09OdpFAi0n4uHsRvzZMxEQXMpN
         JvksFfga2a21JATLbO7/ZoVY8ut7DS+K5Z8JSf1UcKo9k3vbf3gNp0z/5I/PcN3//tgL
         QhoEqy9lpx0r5SGpMBNOn08Ue/yfmXV/7ga4IhLQDgtDUZ7tBPImZdglcXibWtwZPk1o
         d5Ww==
X-Forwarded-Encrypted: i=1; AJvYcCV3SWijECsVy+yv4vc3NZn5tj1yoOiDYsI/bpehtGy2eXfB8eKzZsacvgwc+e7wHE4IqKVhyNQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwcrNIZ6wdbPLmON7Bzf12GwatyX5obyzF/iADoO4nVhbIwaB2V
	fY9k6nlXeDx6fh6Mym0wGtOhCr4iUsa+j/USNln53e0EJ93QIofTZXQxadRBMQ==
X-Gm-Gg: ASbGncsmghH5MAJkml/k5jQhijnkrzDM+ZoTGRq+SN4veqYVLRJlJiLGXDuO2/95QdZ
	U+QT7frlVzagGIvoC1sqJajwE6nK9xwibSrpR4sgsAPMEL9JBiqmOzLLLAYu/wigJLL6q05TFFh
	TzkLyrzbbgJDT8wDZ2syIIoKqycGFIWdKlHTpGH2YCeEonRWyUEN3awVBif7RhnIbw8apocDgcx
	moZeAiXX2Cv97IUm+N1L3k0WvrUv87AAcBjrD9fOUwh9UIKPnQHG8cqjT5Uh6TakjGQrWlPI7BN
	k8ssVdoK+1qPvNeVY+rlKILbuj2yfumfBHxYjr2dgkd/uXcp119vKAhjAQm+G9GBCNNRN3K+fy5
	EwkNuhYI=
X-Google-Smtp-Source: AGHT+IFzHQAEkpFtCO+t1gRCJIagbYhnnjuyRaUGQM6bW98s2AD1DwEmZUlzJZcYV+93fHKKsfUsjA==
X-Received: by 2002:a5d:584a:0:b0:399:6dc0:f134 with SMTP id ffacd0b85a97d-39cba98b9c4mr4046259f8f.51.1743785257188;
        Fri, 04 Apr 2025 09:47:37 -0700 (PDT)
Received: from google.com (35.157.34.34.bc.googleusercontent.com. [34.34.157.35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c3020d975sm4848736f8f.75.2025.04.04.09.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 09:47:36 -0700 (PDT)
Date: Fri, 4 Apr 2025 17:47:33 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Quentin Perret <qperret@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 2/9] KVM: arm64: Add a range to
 __pkvm_host_share_guest()
Message-ID: <Z_ANJQXw7maV8TlT@google.com>
References: <20250306110038.3733649-1-vdonnefort@google.com>
 <20250306110038.3733649-3-vdonnefort@google.com>
 <Z-6o0zcLa4Aw0N6R@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-6o0zcLa4Aw0N6R@google.com>

On Thu, Apr 03, 2025 at 03:27:15PM +0000, Quentin Perret wrote:
> On Thursday 06 Mar 2025 at 11:00:31 (+0000), Vincent Donnefort wrote:
> > +int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
> >  			    enum kvm_pgtable_prot prot)
> >  {
> >  	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> >  	u64 phys = hyp_pfn_to_phys(pfn);
> >  	u64 ipa = hyp_pfn_to_phys(gfn);
> > +	enum pkvm_page_state state;
> >  	struct hyp_page *page;
> > +	u64 size;
> >  	int ret;
> >  
> >  	if (prot & ~KVM_PGTABLE_PROT_RWX)
> >  		return -EINVAL;
> >  
> > -	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
> > +	ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = check_range_allowed_memory(phys, phys + size);
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
> > -	page = hyp_phys_to_page(phys);
> > -	switch (page->host_state) {
> > +	state = hyp_phys_to_page(phys)->host_state;
> > +	for_each_hyp_page(phys, size, page) {
> > +		if (page->host_state != state) {
> > +			ret = -EPERM;
> > +			goto unlock;
> > +		}
> > +	}
> > +
> > +	switch (state) {
> >  	case PKVM_PAGE_OWNED:
> > -		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_OWNED));
> > +		WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED));
> >  		break;
> >  	case PKVM_PAGE_SHARED_OWNED:
> > -		if (page->host_share_guest_count)
> > -			break;
> > -		/* Only host to np-guest multi-sharing is tolerated */
> > -		WARN_ON(1);
> > -		fallthrough;
> > +		for_each_hyp_page(phys, size, page) {
> > +			/* Only host to np-guest multi-sharing is tolerated */
> > +			if (WARN_ON(!page->host_share_guest_count)) {
> > +				ret = -EPERM;
> > +				goto unlock;
> > +			}
> > +		}
> > +		break;
> >  	default:
> >  		ret = -EPERM;
> >  		goto unlock;
> >  	}
> >  
> > -	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> > +	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
> >  				       pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
> >  				       &vcpu->vcpu.arch.pkvm_memcache, 0));
> > -	page->host_share_guest_count++;
> > +	__host_update_share_guest_count(phys, size, true);
> 
> So we're walking the entire phys range 3 times;
> 
> 	1. to check the host_state is consistent with that of the first
> 	page;
> 
> 	2. to set the state to SHARED_OWNED or to check the
> 	host_share_guest_count;
> 
> 	3. and then again here to update the host share guest count
> 
> I feel like we could probably remove at least one loop with a pattern
> like so:
> 
> 	for_each_hyp_page(phys, size, page) {
> 		switch (page->state) {
> 		case PKVM_PAGE_OWNED:
> 			continue;
> 		case PKVM_PAGE_SHARED_BORROWED:
> 			if (page->host_shared_guest_count)
> 				continue;
> 			fallthrough;
> 		default;
> 			ret = -EPERM;
> 			goto unlock;
> 		}
> 	}
> 
> 	for_each_hyp_page(phys, size, page) {
> 		page->host_state = PKVM_PAGE_SHARED_OWNED;
> 		page->host_share_guest_count++;
> 	}
> 
> That would also tolerate a mix of OWNED and SHARED_OWNED page in the
> range, which I'm not sure is needed but it doesn't cost us anything to
> support so ... :-)
> 
> Wdyt?

That sounds good, I'll drop __host_update_share_guest_count at the same
time to fold it directly into the share/unshare functions.

> 
> >  unlock:
> >  	guest_unlock_component(vm);
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 930b677eb9b0..00fd9a524bf7 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -361,7 +361,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  		return -EINVAL;
> >  
> >  	lockdep_assert_held_write(&kvm->mmu_lock);
> > -	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, prot);
> > +	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, 1, prot);
> >  	if (ret) {
> >  		/* Is the gfn already mapped due to a racing vCPU? */
> >  		if (ret == -EPERM)
> > -- 
> > 2.48.1.711.g2feabab25a-goog
> > 
