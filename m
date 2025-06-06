Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F45433A6
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749233682; cv=none; b=QWnGLZYcLlpsUj+ymMBpRS2IGTRzbemU26lhaJ63y9mA+Ze6CTR4G/4y4QW7/18pK+QYH22OeHWSoEFTN4FjRYkryiBAwbM0jjceNR9hbwLsp6wBr9yy5pxgYooVCaVel9+6Myv74uHrjextyTbJ9hqzSKUacnc1wEbAcZ9elN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749233682; c=relaxed/simple;
	bh=SjCd0Jkf33wyDVxQcPBEloOzNKGeAdLm4+GeA0r1Bac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQ9u4E+sOJemq8a8FTJTyO6KBka8eDEw6G8KoJypbD9hE3JuPjF3psAr8g+8OS+geUg2qH+lhR6RceLB8EZw42EDiOlDB6fVygdLRX6cjj1VDQLAtGAlz2K0uqSjxmJzlTi6MSB7e5KyypVvG/IdFJUJYLU7RlhTGj70OamMEyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RYonuZo5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RYonuZo5"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a59538b17so2412430a91.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 11:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749233680; x=1749838480; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VAUhjYxThgXkitpnjxyy0unZevW/6JACvYls6YdZBNI=;
        b=RYonuZo55GZi8rgV5fKiZw2SZy7YMRhc3+QZPYeTZZ7VAJk8e7hrSMU2+jjK8yj7sg
         roa9X9YFR/iL7xCID/zqJ2q/WWmuVw6KZjaPJRVhPnu2sbzUAZqM5M/h/SJNaG1km+BD
         31erWdYl9Na0TbjEP/gE/u0Tz+//y0dvj75GX9hiTNWk8lGYX6sQzfvYKlwuCdB0Lfdq
         aeSj/ptyWZ8dTSiPwx1Vcp4RA3XvzQBogBbAtcJzLcz6kl1Fc03JHde6tSTZUoHkxW/X
         EcOrFTO/6F+aV6dmN0xJXQPY3X3v90huGalmV1TswfaFJ3YuucpJ8+t0K1WydzjAxe3u
         B0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749233680; x=1749838480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VAUhjYxThgXkitpnjxyy0unZevW/6JACvYls6YdZBNI=;
        b=o+flGqMBZ0+zmtY7clx1T6fDEMOMNecENVfdipEpTzps9qvifEf39CwLvpH+ih4Tys
         TvyUMWGh0wGCV30V160vUxYL2V2QEiGLhvuU+HCM4HouFuwtbGjWsQr9UjHlu48+ig/q
         xeVY7xM3K507+jruIFfdMnp6mLf7fe+Zv/pJD5IPeVqPEXQcZdrwoHk+eCt9xb6RvWRU
         +wCFaQ58nSrqYwsBS/7NR4iSwzYmjqAzyMmPJPQgRktRKnEJ63P2z35Z1WGDQdV+4wsa
         Czc2NYDwDyX6xn5wA6ynxCDglM/mQaebpQoc+9dYcgFkrFDlegAQkWjgqoQyBJEIy7wL
         EJDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBDGQ0Fs0DL9nhkvwLTYVSQp7xKWM4095izHaEKbJDDNRYOmQV07aOHZSiwZFlotx9yo1Mkx8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOnpPVFN+Ag+AZAcuKXgXlJXQeCY9NoGBiBM3d0rfHJTqk0Qc9
	9WnP2CAyG1QbeidqD7YBwsBOdE8vZEqQlzNF67uR5XUAE247qN3/7T91vOLlrtIZArP5TCEl2d5
	dlkZLiQ==
X-Google-Smtp-Source: AGHT+IEVafAx0DEdokAbHZYNqcfLZrJvGcnddWO2nYwmoBUbnL46jnQNAcO/DBxC/1OVXbJIbbas3Y6XETw=
X-Received: from pjbpq14.prod.google.com ([2002:a17:90b:3d8e:b0:311:d79d:e432])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17c5:b0:30e:9349:2da2
 with SMTP id 98e67ed59e1d1-313472d24e5mr6030735a91.4.1749233680403; Fri, 06
 Jun 2025 11:14:40 -0700 (PDT)
Date: Fri, 6 Jun 2025 11:14:38 -0700
In-Reply-To: <20250524013943.2832-5-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250524013943.2832-1-ankita@nvidia.com> <20250524013943.2832-5-ankita@nvidia.com>
Message-ID: <aEMwDqxsDgfXcLKw@google.com>
Subject: Re: [PATCH v6 4/5] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
From: Sean Christopherson <seanjc@google.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, ryan.roberts@arm.com, shahuang@redhat.com, 
	lpieralisi@kernel.org, david@redhat.com, aniketa@nvidia.com, cjia@nvidia.com, 
	kwankhede@nvidia.com, kjaju@nvidia.com, targupta@nvidia.com, 
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com, 
	jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com, 
	udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com, 
	sebastianene@google.com, coltonlewis@google.com, kevin.tian@intel.com, 
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org, 
	gshan@redhat.com, linux-mm@kvack.org, ddutile@redhat.com, tabba@google.com, 
	qperret@google.com, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
Content-Type: text/plain; charset="us-ascii"

On Sat, May 24, 2025, ankita@nvidia.com wrote:
> @@ -1636,9 +1637,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
>  
> -	if ((vma->vm_flags & VM_PFNMAP) &&
> -	    !mapping_type_noncacheable(vma->vm_page_prot))
> -		return -EINVAL;
> +	if (vma->vm_flags & VM_PFNMAP) {
> +		/* Reject COW VM_PFNMAP */
> +		if (is_cow_mapping(vma->vm_flags))
> +			return -EINVAL;
> +
> +		/*
> +		 * If the VM_PFNMAP is set in VMA flags, do a KVM sanity
> +		 * check to see if pgprot mapping type is MT_NORMAL and a
> +		 * safely cacheable device memory.
> +		 */
> +		if (!mapping_type_noncacheable(vma->vm_page_prot))
> +			cacheable_devmem = true;
> +	}
>  
>  	/* Don't use the VMA after the unlock -- it may have vanished */
>  	vma = NULL;
> @@ -1671,10 +1682,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
>  		 * and must not be upgraded.
>  		 *
> -		 * In both cases, we don't let transparent_hugepage_adjust()
> +		 * Do not set device as the device memory is cacheable. Note
> +		 * that such mapping is safe as the KVM S2 will have the same
> +		 * Normal memory type as the VMA has in the S1.
>  		 * change things at the last minute.
>  		 */
> -		device = true;
> +		if (!cacheable_devmem)
> +			device = true;

I doubt this is correct.  "device" is used for more than just the memtype.  E.g.
hugepage adjustments, MTE, etc. all consult "device".  I.e. don't conflate device
with VM_PFNMAP.
