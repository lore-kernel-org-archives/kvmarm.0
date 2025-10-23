Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF63347FC3
	for <kvmarm@lists.linux.dev>; Thu, 23 Oct 2025 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761239769; cv=none; b=spbOTMolkxWGAo4zUSrhZMxN9czNbEVSPhl8JBMr7ZQivxID99ATCGYzEXh//sDMCKq+5RDnCtFFqN/L7v16Yln8Wdc/9tKTD2Myy4W/K3WQCdam5mu0kZIB+A9k5Rl3/uf+9h4bX+blt+3WzUEL9UDUXjDx0d2BH8F0lNtr/SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761239769; c=relaxed/simple;
	bh=3vjklBZDK91NfPPKB/m+mZXiuBD949DF/IdVW5vVnss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=db66UEGvB0XZy8Vu5UyZYX/4AYdBV5RB7nVDB2bVDLXwcO8ChI9ub5+FcUIk/veOaNmvood4TCdLKogZaHeQRv4a4FPZZQh0DdDiM8Tv5fKgFPFoTFukpdzWOXljrn0lHe1iS64Yq4+Kbu6+N09fjL6sqH997XbzccEtQXSfXB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e5KLS9kS; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e5KLS9kS"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-27c62320f16so10739045ad.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Oct 2025 10:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761239767; x=1761844567; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/DTN4f9sYvKKbqzH4zMTtt+lW5xHHb7Uewe/2Me0Lwc=;
        b=e5KLS9kSeEuY/o0KSHwnBTH/0lXlwylg4HqTDx/EBUrmtGPXnprh3zAO+P/BCyPK9h
         Xf96ARlssF9sJtIGFGoiEfdWQMRzMXWV0DMdkhMDndA6a7NDnbdPfOWhd/DIvF36mftC
         bKcPaPAcAvrwAGRx8cdvRP3OKIpHYUhw4tvEqhLhyGosPvMTVyyW9qAjwlZoXkrrdpK+
         DUyszV5v8QOmavlFTG6rYG5Wc6Zm9DJN2YHpD2KLZoJhHg8+QXrpJeAPnVMTCU8wcC61
         mr2HUbWqLy+2NOvFzRKVdZXp2JG2W34Yq1S7OijvMp70Y+OVAwPYlmzFvKb+6k/GxFoY
         wV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761239767; x=1761844567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/DTN4f9sYvKKbqzH4zMTtt+lW5xHHb7Uewe/2Me0Lwc=;
        b=CfAGf2++6x7H5nKRDxGqRqSMXQWI/SInO9nhy2jxE43PAOSJKveISU0qLjsz3n89mp
         6UJuwdIXc+SZQ3ls8LHIR1XprJSo/0Z0NPkgLscM3qBUMiK+nKUYLgXBGHZI3OpNa4R5
         P3rXfvj7yue9moXwjWo0LEGKAw4R+BZzA+Bb8XSaKJq7zbOqoWOCkhqIh9WDcWOefXqg
         IsdSFCX3742s8bquXQPVNVKusPU3NsVW1g9jhiyYbNtVAhORHyHZTPnGFD6pbtAYaaHW
         WCbTuVdpTtr6Rt3RNqLgyVSXMkkIs8WqKvFjo6OUaUmCCEeUBjVM+P5IamP2EGIGfI2Z
         KKwA==
X-Forwarded-Encrypted: i=1; AJvYcCXC6/GHwZrKDTfgyb+k7rj/C+2E8KhztNhcKnsWp6wkjb/NWOjlUj6b/98xykFeyv+sco7w2pY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYpk+z8tVp8CGdRNl5BbIvgfomcVOz/o57viCZTLYRTT6ANHcP
	tq9ulJTO4q9bHM9J0Wt7+oFt1Jw3SJy7dwRhC1x27L69W4FHfDvZnFa4P/P72Ns2EI2BNQLXc1S
	WYkKYig==
X-Google-Smtp-Source: AGHT+IHWPgGmZKfo+3ImlZCUG7AewIscdCvWipQB1xDHXcjZQxceHYcdCY71wfIfELDOVuODkQ3p+Aq3kE8=
X-Received: from pjkm11.prod.google.com ([2002:a17:90a:730b:b0:33b:e0b5:6112])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e88e:b0:267:da75:e0f
 with SMTP id d9443c01a7336-290c9c897bbmr312407025ad.11.1761239766935; Thu, 23
 Oct 2025 10:16:06 -0700 (PDT)
Date: Thu, 23 Oct 2025 10:16:05 -0700
In-Reply-To: <20251013151502.6679-3-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251013151502.6679-1-jackabt.amazon@gmail.com> <20251013151502.6679-3-jackabt.amazon@gmail.com>
Message-ID: <aPpi1c-8EpWuo87B@google.com>
Subject: Re: [PATCH v2 2/4] KVM: selftests: Fix unaligned mmap allocations
From: Sean Christopherson <seanjc@google.com>
To: Jack Thomson <jackabt.amazon@gmail.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	isaku.yamahata@intel.com, roypat@amazon.co.uk, kalyazin@amazon.co.uk, 
	jackabt@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 13, 2025, Jack Thomson wrote:
> From: Jack Thomson <jackabt@amazon.com>
> 
> When creating a VM using mmap with huge pages, and the memory amount does
> not align with the underlying page size. The stored mmap_size value does
> not account for the fact that mmap will automatically align the length
> to a multiple of the underlying page size. During the teardown of the
> test, munmap is used. However, munmap requires the length to be a
> multiple of the underlying page size.

What happens when selftests use the wrong map_size?  E.g. is munmap() silently
failing?  If so, then I should probably take this particular patch through
kvm-x86/gmem, otherwise it means we'll start getting asserts due to:

  3223560c93eb ("KVM: selftests: Define wrappers for common syscalls to assert success")

If munmap() isn't failing, then that begs the question of what this patch is
actually doing :-)

> Update the vm_mem_add method to ensure the mmap_size is aligned to the
> underlying page size.
> 
> Signed-off-by: Jack Thomson <jackabt@amazon.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index c3f5142b0a54..b106fbed999c 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1051,7 +1051,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  	/* Allocate and initialize new mem region structure. */
>  	region = calloc(1, sizeof(*region));
>  	TEST_ASSERT(region != NULL, "Insufficient Memory");
> -	region->mmap_size = mem_size;
>  
>  #ifdef __s390x__
>  	/* On s390x, the host address must be aligned to 1M (due to PGSTEs) */
> @@ -1060,6 +1059,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  	alignment = 1;
>  #endif
>  
> +	alignment = max(backing_src_pagesz, alignment);
> +	region->mmap_size = align_up(mem_size, alignment);
> +
> +	TEST_ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
> +
>  	/*
>  	 * When using THP mmap is not guaranteed to returned a hugepage aligned
>  	 * address so we have to pad the mmap. Padding is not needed for HugeTLB
> @@ -1067,12 +1071,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  	 * page size.
>  	 */
>  	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
> -		alignment = max(backing_src_pagesz, alignment);
> -
> -	TEST_ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
> -
> -	/* Add enough memory to align up if necessary */
> -	if (alignment > 1)
>  		region->mmap_size += alignment;
>  
>  	region->fd = -1;
> -- 
> 2.43.0
> 
