Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D1B20D4E4
	for <kvmarm@lists.linux.dev>; Fri,  4 Apr 2025 17:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743786336; cv=none; b=Ur1oA08allVdAu8pXUxVtdrvjPoVKiZQF4b0rxz3khjw2wKdSerDPEe/ff6vuoDva0l7uwOhgXRAtGZjlK0dr3yi0ZMx3OITy7z2nxIzCDsU4XvfY2VKZbYQOMdU94prqaz0rJCRKHvEIaTJxPQAclqlrSYIHgsjVGetEywlXeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743786336; c=relaxed/simple;
	bh=iO8nNca6CjCJe5afrLQ0fcpI2xk8JQtBj1QNgWxRfkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUXcI+PjrNc9/nUbQewPq4z1snDqFWcN6xbQ/6ZAylR/dGYWJJu6bjGyfiu3GEFHcqIqvYnKYAXfq9nG3pAlMR1PKfX+DNPmZTdqwKdHG2pm425olIaIWN29aLzpCAsWEC54Z4igQwDBylG2Y/6hTAAKcH6tz14S7JPgf74Sl1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Up4KsWzM; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Up4KsWzM"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac2bb7ca40bso50275966b.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Apr 2025 10:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743786333; x=1744391133; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AwDqXCtOct8DsFXT3x26lNRUVVnIjXvE/cNDH38nXmY=;
        b=Up4KsWzMsOhixG+YugpaX5JnbzCjnT5IUx55yU/P/7RtX3S6baVRbWMksoAwBUpD/B
         LFX19gZXNrH5pQpSDup/g1AobAH0R7bbx6tnk3Vj75u/OiMNSZm5fGhreoW09J3MuFie
         bkXvDDx+xRhr9hnOhMBj1QvMt8sBFKCLQCbal64B1pAfpnyvNPRst9Gx8mIe6QvgS/iQ
         +GihVfCmD5rvOzCa4LeynN4nLKQ/KJldzEb8ZNXYQU2r2ZFZtgVaGcK8w6ZSfk/wFbMC
         WMVrz3HVFyLvdus5cD89i8YjzmaiztHpiK3sCzcFJLbAms06upSMgBOfDjaJ2wvAAKg5
         1yiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743786333; x=1744391133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AwDqXCtOct8DsFXT3x26lNRUVVnIjXvE/cNDH38nXmY=;
        b=ju6PSOATQQCYj2965/vy9bymeE38xVug1pq6/I4auv/XqzDMZ7b5SEep7fumlXhYPd
         55QIQoch9ZdgVtZaVUfSX2DbmiD4k5h7TfL24L884Au+dkmHCjz7HV3SKQsp1n1FHs9Z
         VYRLYwLddoxlLde5XDq5f5gRcqN+f9ARGp9ociZbvSAESIfY/tOarkQ/vcb+YHHwCdeR
         ef90n1vdp8G80mpcSn3b3FND587WMVZkugEgni2wv5BSZu7ywK6dCJLBgpt1g+u4TruG
         6Tqk9AvE/Ik9f1CrocYgbKLToQd9NgxRFKKKjzRd7SUzzqKImJWekYu9kR8CXpp8OIrC
         tiDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWW0Gj4VnXjm9EI5S7lu2GtIDUqbxSBKFIriPahCqU5DG8+3cXmxVFpVA938Kx2PVQq2X5Jf74=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1rQNOnQUUWnT/H9V608f4C10x7GAMbx7Hu1jw1hPGd2Hq4+qC
	RfHwVNE1U/u+qKGQ1YUcDdYlzFcYiYFGGOYK+qMu31M7TX1O9tXDMpXLuYA+lg==
X-Gm-Gg: ASbGncsPsVbiUT2MW+obMkYEJEP8lO+HALZLGPr9qq5syC1B7zhRBJ32xvrWDFVr8+G
	WpRiw5k+QKZ+tfS4A8AE1rv48cEratbNhJY+nX0uvC6MzWfruVJ3wQUtbNzSAfduGX/zxIhChW7
	1hKlEiTfKj0yPzWuEk51B13OxtOWe7KTFzHz7IUuWvmgFOQYqTrW/akTPt3CWx25fbeY7xzqmx3
	HWy0Z6DuKbd6RQJgQ3hj4yw7BLpqOr/laBj9+zSJAbly8qTuhvw7aNLTvhF+OJrAeA01cepJVZr
	u7LDrY9lw9+Co5KbsaSJ6OsnxwtRIOrZXJ6xPR7HftoaRuAvBXoWvAP4MTQKCOKff3bmj8kgaN7
	lJYiApWA=
X-Google-Smtp-Source: AGHT+IHNmd6B42CvAAoOrmSaCgMaRG/rblZajqIa3A/ogW1Y5oG4oBfPNhJiyFRf09FleJPZU3ziJA==
X-Received: by 2002:a17:907:9693:b0:ac3:3e43:3b2b with SMTP id a640c23a62f3a-ac7d1878c0amr443601366b.18.1743786332804;
        Fri, 04 Apr 2025 10:05:32 -0700 (PDT)
Received: from google.com (35.157.34.34.bc.googleusercontent.com. [34.34.157.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c0184d0dsm280758066b.130.2025.04.04.10.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 10:05:32 -0700 (PDT)
Date: Fri, 4 Apr 2025 18:05:28 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Quentin Perret <qperret@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 3/9] KVM: arm64: Add a range to
 __pkvm_host_unshare_guest()
Message-ID: <Z_ARWDH60WayM0MP@google.com>
References: <20250306110038.3733649-1-vdonnefort@google.com>
 <20250306110038.3733649-4-vdonnefort@google.com>
 <Z-6p49EcsZKid7L1@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-6p49EcsZKid7L1@google.com>

On Thu, Apr 03, 2025 at 03:31:47PM +0000, Quentin Perret wrote:
> On Thursday 06 Mar 2025 at 11:00:32 (+0000), Vincent Donnefort wrote:
> > @@ -1012,51 +1011,52 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
> >  		return ret;
> >  	if (!kvm_pte_valid(pte))
> >  		return -ENOENT;
> > -	if (level != KVM_PGTABLE_LAST_LEVEL)
> > +	if (kvm_granule_size(level) != size)
> >  		return -E2BIG;
> >  
> > -	state = guest_get_page_state(pte, ipa);
> > -	if (state != PKVM_PAGE_SHARED_BORROWED)
> > -		return -EPERM;
> > +	ret = __guest_check_page_state_range(vm, ipa, size, PKVM_PAGE_SHARED_BORROWED);
> > +	if (ret)
> > +		return ret;
> 
> Given that hard rely on kvm_granule_size(level) == size above, we should
> be guaranteed that the PTE covers the entire range we're interested in.
> So is there a point in starting a new page-table walk here? Could we
> just keep guest_get_page_state() directly?

Ha yes, the walk wouldn't do anything more than what we can with that PTE!

> 
> >  
> >  	phys = kvm_pte_to_phys(pte);
> > -	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
> > +	ret = check_range_allowed_memory(phys, phys + size);
> >  	if (WARN_ON(ret))
> >  		return ret;
> >  
> > -	page = hyp_phys_to_page(phys);
> > -	if (page->host_state != PKVM_PAGE_SHARED_OWNED)
> > -		return -EPERM;
> > -	if (WARN_ON(!page->host_share_guest_count))
> > -		return -EINVAL;
> > +	for_each_hyp_page(phys, size, page) {
> > +		if (page->host_state != PKVM_PAGE_SHARED_OWNED)
> > +			return -EPERM;
> > +		if (WARN_ON(!page->host_share_guest_count))
> > +			return -EINVAL;
> > +	}
> >  
> >  	*__phys = phys;
> >  
> >  	return 0;
> >  }
