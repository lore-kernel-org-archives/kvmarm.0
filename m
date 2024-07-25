Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C36223749
	for <kvmarm@lists.linux.dev>; Thu, 25 Jul 2024 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721931469; cv=none; b=nAajglZwg31f7OZ6+j2bHW8S80Be5oQu/Q4BgHiBLq/x9Npar88pfmMP6/UO5QJNUfmIKR04oCVQGDlwDmZWapq78G47fcqvPHuDm47oUhz5CR+m0qloo5jcH/D9Kyknw745qDZmnTuJFAZq/QRmru5xVFqz8EJrn9o6HFxMPbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721931469; c=relaxed/simple;
	bh=7TGdImb3lenZ6if5s4D0hbXhdDde95DNNoZfafPu3I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7WFEzGLbdHRB8lDymtOkBAuW4aAVqDQA9eqqzKZ/qEHgIweRYHrBRe4IABQWAnI/dcSXbCkCgIYnWPPZmy9JUwy35dPFhBNO1z3Ytb2n+W7Fmv/DfRchnWJZ6+JAS0hvTXnrng2zDgWRYzdzcN+22Wu4KhzF+Hnr/QvXqX0baQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S6V5l6X1; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S6V5l6X1"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70d19c525b5so124119b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 25 Jul 2024 11:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721931468; x=1722536268; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCU/39n/MEh1qJPI6jK5LfqbsxyFwdIdQzHQHHv611A=;
        b=S6V5l6X1POF44Aq+sDSizcekO+zVJBxu0xG5h9ovEUMlWpqlBXZ/sbQZ89YCShwAzS
         FPqQOiw8TkXKXbl/MAltN0Q+mfsKvPEX6NGv1pdclDPLlDX3LSKrQLPbeZH0sYFgj6jj
         k37F9wv4dXKXIyhtPht7Wuy+q/jqrYtqQstELh/5U/y8fiYAT0lab1USA6KRVcmeLl0d
         GFBiU7DROJ6z7RuYmPcHMF8j9CohuFZKwNDyTEdjbrx7pb/fLwEJ2/Idfd2AlbicF/a4
         i1fASztw5CJjbswS5J9WTq27abES0wRcGLiaYrXQ1Sykg1e6ROCzMQknMYxHYbGtBE+E
         85aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721931468; x=1722536268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCU/39n/MEh1qJPI6jK5LfqbsxyFwdIdQzHQHHv611A=;
        b=RC9iZunyEdWwp1rCKx+/EfiUSFl/+KTLPood3VFfQcRjxA5ti3o5/fqiea2kDVXHjf
         0pqcB+IVgOJZizce2Qzo2cJzqzrCCNfFasx6vu9MpIYVyv3WDr/Iuk1NlWxAb6CVhQTr
         vt6OhCVixDTVLqPByQV3V3lq0qeA9qLI2dfzx/n6JCFD+2MaBWSUYNcgyDdnrz+G21uh
         k0ijsWcbFv38N7S0o+YCY7/7TVFnXVARWlG7Mzm1XZ8UA8myNpKcpIFal1TjHt2Q47SR
         XJ0sgUicYMrYuaK95CR1sc9MRm+fnkHH6K/ofgjTH3WAfF2iVYnlOOmdtV3t/8SLsqI6
         je9g==
X-Forwarded-Encrypted: i=1; AJvYcCVAOL6XwaVy3IpQCL98TzYpiKnYW3U9pMmQg05D+k5KC2XxovRkMO/UxQ0aNBg/+PHLcrUbIE+rhS9z5tHTAB5gOUjOow8+
X-Gm-Message-State: AOJu0Yx4cdcAdPqjyKTNmR5RxD908IqiVkuVNqwyOZlV1goHQQNLR7KT
	I9eXM0Q2voZhepmv5ZZ0vL0P8dG55ueiFQ44r5vPuNFbCFhsF81TfyC19ivi4w==
X-Google-Smtp-Source: AGHT+IGgJJ2MHUDyfdNf8nuLsnVaCfQ9A96+ttKTHUsGKEKorXbwZR90OZ/UEb7mApStThubbs9AYw==
X-Received: by 2002:a05:6a00:2d8c:b0:70e:8070:f9d0 with SMTP id d2e1a72fcca58-70eae8d5c8amr3531836b3a.9.1721931466986;
        Thu, 25 Jul 2024 11:17:46 -0700 (PDT)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9f884c245sm1490390a12.50.2024.07.25.11.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jul 2024 11:17:46 -0700 (PDT)
Date: Thu, 25 Jul 2024 11:17:41 -0700
From: David Matlack <dmatlack@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 08/11] KVM: x86: Optimize kvm_{test_,}age_gfn a little
 bit
Message-ID: <ZqKWxfqRoJzUWroG@google.com>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-9-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724011037.3671523-9-jthoughton@google.com>

On 2024-07-24 01:10 AM, James Houghton wrote:
> Optimize both kvm_age_gfn and kvm_test_age_gfn's interaction with the

nit: Use () when referring to functions.

> shadow MMU by, rather than checking if our memslot has rmaps, check if
> there are any indirect_shadow_pages at all.

What is optimized by checking indirect_shadow_pages instead of
have_rmaps and what's the benefit? Smells like a premature optimization.

> 
> Also, for kvm_test_age_gfn, reorder the TDP MMU check to be first. If we
> find that the range is young, we do not need to check the shadow MMU.

This should be a separate commit since it's a logically distinct change
and no dependency on the other change in this commit (other than both
touch the same function).

Splitting the commits up will also make it easier to write more specific
short logs (instead of "optimize a little bit" :)

Also, the commit re-orders kvm_age_gfn() as well but the commit message
only mentions kvm_test_age_gfn(). No objection to keeping the two
functions consistent but it should be called out in the commit message.

> 
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7b93ce8f0680..919d59385f89 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1629,19 +1629,24 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
>  	__rmap_add(vcpu->kvm, cache, slot, spte, gfn, access);
>  }
>  
> +static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
> +{
> +	return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pages);
> +}
> +
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	bool young = false;
>  
> -	if (kvm_memslots_have_rmaps(kvm)) {
> +	if (tdp_mmu_enabled)
> +		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
> +
> +	if (kvm_has_shadow_mmu_sptes(kvm)) {
>  		write_lock(&kvm->mmu_lock);
>  		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
>  		write_unlock(&kvm->mmu_lock);
>  	}
>  
> -	if (tdp_mmu_enabled)
> -		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
> -
>  	return young;
>  }
>  
> @@ -1649,15 +1654,15 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	bool young = false;
>  
> -	if (kvm_memslots_have_rmaps(kvm)) {
> +	if (tdp_mmu_enabled)
> +		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
> +
> +	if (!young && kvm_has_shadow_mmu_sptes(kvm)) {

nit: A short comment here might be helpful to explain why young is
checked.

>  		write_lock(&kvm->mmu_lock);
>  		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
>  		write_unlock(&kvm->mmu_lock);
>  	}
>  
> -	if (tdp_mmu_enabled)
> -		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
> -
>  	return young;
>  }
>  
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 
