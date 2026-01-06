Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307BD33A9DD
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 19:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728813; cv=none; b=t117u8gKkHd7mBL0k43Odm0X0v9cdZEyHBbhJyMm1tIOTe/3c2UzlGGu+rE7yaPZwXPzzjxgDY3kafgPsOgoGB30AltA5SsKn3A43jR9JUuIeAcRByHnOHz+iCyWgX/11JoBgpLJZJ0SP8OEEDIz/f6w+PTwyDm+8RCfkEGF+kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728813; c=relaxed/simple;
	bh=KuSdBZ9CI3H4fvaeuI0u6Uz4UfBd8FAZf6zVOAwDu9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PzjX24Num9BNyU/hOibzwQs3Hgkf21hQe8fUP/FD5zNFTUHAKqRQ94t3biMbXYhOByCDtcGdCgAua3XoVUgKHa6XJbF4edkHts8gEDEoqRTlklTqumiPNRpEMJ5y0dLx3odXlgJmUnJ5eicldKhT2qlwGtE0I/EX0pvEd2zT/vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QFd1srFz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QFd1srFz"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34cc88eca7eso2606085a91.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 11:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767728811; x=1768333611; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZriMaEA+mukSvHum14D+f4jkgVLElfimaxrHlh88e8w=;
        b=QFd1srFz0h6z/+F31SrbnLlXOdGeymN/92xs/7+Zt0rybvYZM580BnaU89DRfpkTaK
         5ISn4NqKrQu3BlJb1qFTrkYrHzKgMnFyQ2mlaa5E0DsXocxHoYvaS3wVo8heGAavZEO5
         UoB3GfskFH4BKdUvFEnsCYHrbdRaVZvxzRCQNNZfYysG4Ey+Z3RgSWat1lNj7//odQzB
         i9Do7OLM2wXW1Kqadd8fUzGgzft8HyjUKzb5L1HoPP2IeSxWLGIhTgn+y6YQmmRhggqK
         1W/V4qXTvg9rngze2jumx50tNuV28lgQmCaacAe83ROZRkunvqmpThIZX700/DAVOx8X
         Y35A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767728811; x=1768333611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZriMaEA+mukSvHum14D+f4jkgVLElfimaxrHlh88e8w=;
        b=Nf3qHuhqzQnK6pojPlvhimmEWw77kwTu5HGhWSkoWQxwvObpaMucaOELNn4dMalEEO
         X4hL0OxublT93WKtiOkbDLPE1b/MXROY06ot4vqXju8AH44HRBPXJK5bKyqdurS9/72Y
         nrb6wlDITupChWC/h0IJm5NALjtaFO+5pc/Q51oHFu+rbSS6Aloe2QZpCAssOkrCSuYn
         ubH2gvFJQUy5IqEA6VdyEV2O0rexmVPJinN8k/E5s8qK8mtCfwyBquN45XiquV50H9XZ
         UB+MDn5CcpAMevWtM/MlUuGSJiOqxPF8y+OVyN4wz41Ys8sHmBnjasmRP2HlGB7dGgeA
         ckNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn4ld2E6U3a4OPSI/cy2k4pNICYKM50WOuNH9ix5yDfYkusivPUQ/QHRg6uk0z8VFB0HFJQt8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTOazo1D7y9iC1eRg7KDeHWt72Q211vtIDuoIGUbSalhLuJUG5
	PfsF+VQ0eAQeOIgWCJgEAJP+NkABHJi7qKeac7a98GlPtNW6ZlCT9cbgvQ2g++lIeJFtL3qBWxN
	4SrsCfg==
X-Google-Smtp-Source: AGHT+IGZby64OMYDLsQncM6OFaUmrTDXzxVCp6nfZzSkjGTInUpS7Y2UQJcRJ5iTle12BuWLNTTKOzutkWY=
X-Received: from pjbbj19.prod.google.com ([2002:a17:90b:893:b0:34c:a40f:705a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c87:b0:34c:a35d:de16
 with SMTP id 98e67ed59e1d1-34f68c282c6mr196827a91.11.1767728811460; Tue, 06
 Jan 2026 11:46:51 -0800 (PST)
Date: Tue, 6 Jan 2026 11:46:49 -0800
In-Reply-To: <20260106092425.1529428-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com> <20260106092425.1529428-5-tabba@google.com>
Message-ID: <aV1mqQtALFIUBHVM@google.com>
Subject: Re: [PATCH v3 4/5] KVM: selftests: Move page_align() to shared header
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 06, 2026, Fuad Tabba wrote:
> To avoid code duplication, move page_align() to the shared `kvm_util.h`
> header file.
> 
> No functional change intended.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h    | 5 +++++
>  tools/testing/selftests/kvm/lib/arm64/processor.c | 5 -----
>  tools/testing/selftests/kvm/lib/riscv/processor.c | 5 -----
>  3 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 81f4355ff28a..dabbe4c3b93f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -1258,6 +1258,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
>  	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
>  }
>  
> +static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)

Maybe vm_page_align()?  So that it's a bit more obvious when reading call sites
that the alignment is done with respect to the guest's "base" page size, not the
host's page size.

> +{
> +	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> +}
> +
>  /*
>   * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
>   * to allow for arch-specific setup that is common to all tests, e.g. computing
> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> index 607a4e462984..143632917766 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -21,11 +21,6 @@
>  
>  static vm_vaddr_t exception_handlers;
>  
> -static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> -{
> -	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> -}
> -
>  static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
>  {
>  	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> index d5e8747b5e69..f8ff4bf938d9 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -26,11 +26,6 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
>  	return !ret && !!value;
>  }
>  
> -static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> -{
> -	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
> -}
> -
>  static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
>  {
>  	return ((entry & PGTBL_PTE_ADDR_MASK) >> PGTBL_PTE_ADDR_SHIFT) <<
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
