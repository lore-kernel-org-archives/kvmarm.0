Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A451E2458
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 17:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712855332; cv=none; b=prs8wBxuENMlCiDFKnNO6QBgDI1ogFL5OEfBY5pk/nSdba/6T1HRdkFHfz88PrO86ntHahiVcVtsu48QKE0Co1HlTKmK2f9RGiPY8ev/SQPBdZ+jrTVoPcny+fI6s6wlOoT7yj+MDMdLdJHYYOuT21u1WRVBeTDgmVB26nX8NyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712855332; c=relaxed/simple;
	bh=osOLzVNRJUx7/kwh0j8ShhoMeBYb2lNqWbY8A8z5eUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uaKY+8B8T4aI2vVruTyZa17sTFTbXzC8K2U+/Q4om2WGNn66byym3Nah3BRhdCAk9zc5Ibiw7rAaWuMh5oV3/ICj9i7j5wv4WQLnYY7uPRmuDyzSiAWHEKi0I4ovA3RLFakj7C1TAdIwMoGFS51dXk3d2qDSWKB7tW2GEbkUo34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=fail smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nTtMRKpj; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nTtMRKpj"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e4266673bbso701115ad.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 10:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712855330; x=1713460130; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vEGKpy4oX/yIMuuLIeB2ya0zq8zO1o7RbrrJFAy2vfY=;
        b=nTtMRKpjX1vKSGQiVcL8sRd3qDKQXBcuDHdEHO9zz05AnvjNhyNKJYV+2NL70Zs2b/
         QNq1JweO+JQxBB/23LY9z+QmgU5zNiezMM3iENokYIM+FtOE1kS2HvEawD/J3w1VIRZv
         bLAMym9uDFP1cLMzoNO3WNLFJVyNWCGSc/O/i1zNk2p3mZc5lTYDSG3TcmQFrAvdieGf
         ln43OBUnAgvfX3JDPLQXDAajBISzA9n23h/OgH9OiGAArW7YXcT9DkExWS9wKF2D6c0h
         ATQszjltqFUzb3OGZpDGW+r7TIs6tzNgdPk1FiMi3OQcC1uPZXvBn1TtWwsu1VrBU4Yi
         HKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712855330; x=1713460130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vEGKpy4oX/yIMuuLIeB2ya0zq8zO1o7RbrrJFAy2vfY=;
        b=KjLt0eDzTX4m+J0Mt7gEtUpXY34lcKxnpQLT1cTLlZ/moKqBnAWP6hSMs8FqbXio2k
         vUJSViSoqbHL+ImgQQGIsZeVKOoXedMjAxkLGMh747veQPeKM1xbR+BCzAGq6SxSci90
         PiBTtt58gpjJOK1HYobflAlp4RhHVR/XYEi2HGgh7moHXuyDROBlXuddawbFDI81+95+
         WuGttP0PtoPTVqRKyW/dWDI7VfIRhwdBnI1mkSt7HJ7HC4h73Q1/nnbB7idOZFHNKOYN
         7OqMd66sgNd6MPpAsEGmWYcjybRHuIYOj3kcBd3dvm4r1TwfeRJxQxVopnskxgYppMRD
         eBSw==
X-Forwarded-Encrypted: i=1; AJvYcCVoJX5H78nhHLb3zfohyUTyJsAXCUx1PF6g0Av1lOTIGE1sJoTotZ1NsdMaaswXwi1YR33cDnjqJIFkYPLrSUFb+ehfCrIX
X-Gm-Message-State: AOJu0YztKs50a4XAVCDV2cqsHFokTIQit0SqwMqmmcVbjxbwZYOBiNJZ
	nbCnwS8oUU5TIwuPoU8RE2EjMj/1l7DVqdWyJlsDIhQKrDgRvviKrcuVBhJyRg==
X-Google-Smtp-Source: AGHT+IGIo+XHhfBaNNvx2FZS3Opjx6zyO4INlV5oeLFS8dMFPff/iA2HmfQk0TnetdunGtVsGaac0w==
X-Received: by 2002:a17:902:d303:b0:1e0:bae4:48f9 with SMTP id b3-20020a170902d30300b001e0bae448f9mr88599plc.32.1712855329667;
        Thu, 11 Apr 2024 10:08:49 -0700 (PDT)
Received: from google.com (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with ESMTPSA id a5-20020a1709027d8500b001e197cee600sm1413805plm.3.2024.04.11.10.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:08:49 -0700 (PDT)
Date: Thu, 11 Apr 2024 10:08:44 -0700
From: David Matlack <dmatlack@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhao <yuzhao@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Rientjes <rientjes@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
Message-ID: <ZhgZHJH3c5Lb5SBs@google.com>
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-6-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401232946.1837665-6-jthoughton@google.com>

On 2024-04-01 11:29 PM, James Houghton wrote:
> Only handle the TDP MMU case for now. In other cases, if a bitmap was
> not provided, fallback to the slowpath that takes mmu_lock, or, if a
> bitmap was provided, inform the caller that the bitmap is unreliable.
> 
> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 14 ++++++++++++++
>  arch/x86/kvm/mmu/mmu.c          | 16 ++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c      | 10 +++++++++-
>  3 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3b58e2306621..c30918d0887e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2324,4 +2324,18 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
>   */
>  #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
>  
> +#define kvm_arch_prepare_bitmap_age kvm_arch_prepare_bitmap_age
> +static inline bool kvm_arch_prepare_bitmap_age(struct mmu_notifier *mn)
> +{
> +	/*
> +	 * Indicate that we support bitmap-based aging when using the TDP MMU
> +	 * and the accessed bit is available in the TDP page tables.
> +	 *
> +	 * We have no other preparatory work to do here, so we do not need to
> +	 * redefine kvm_arch_finish_bitmap_age().
> +	 */
> +	return IS_ENABLED(CONFIG_X86_64) && tdp_mmu_enabled
> +					 && shadow_accessed_mask;
> +}
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 992e651540e8..fae1a75750bb 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1674,8 +1674,14 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	bool young = false;
>  
> -	if (kvm_memslots_have_rmaps(kvm))
> +	if (kvm_memslots_have_rmaps(kvm)) {
> +		if (range->lockless) {
> +			kvm_age_set_unreliable(range);
> +			return false;
> +		}

If a VM has TDP MMU enabled, supports A/D bits, and is using nested
virtualization, MGLRU will effectively be blind to all accesses made by
the VM.

kvm_arch_prepare_bitmap_age() will return true indicating that the
bitmap is supported. But then kvm_age_gfn() and kvm_test_age_gfn() will
return false immediately and indicate the bitmap is unreliable because a
shadow root is allocate. The notfier will then return
MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE.

Looking at the callers, MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE is never
consumed or used. So I think MGLRU will assume all memory is
unaccessed?

One way to improve the situation would be to re-order the TDP MMU
function first and return young instead of false, so that way MGLRU at
least has visibility into accesses made by L1 (and L2 if EPT is disable
in L2). But that still means MGLRU is blind to accesses made by L2.

What about grabbing the mmu_lock if there's a shadow root allocated and
get rid of MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE altogether?

	if (kvm_memslots_have_rmaps(kvm)) {
		write_lock(&kvm->mmu_lock);
		young |= kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
		write_unlock(&kvm->mmu_lock);
	}

The TDP MMU walk would still be lockless. KVM only has to take the
mmu_lock to collect accesses made by L2.

kvm_age_rmap() and kvm_test_age_rmap() will need to become bitmap-aware
as well, but that seems relatively simple with the helper functions.
