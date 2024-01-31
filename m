Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908D013E20A
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 23:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706742233; cv=none; b=NijasT7GYsiKR0c4g5fjSl3MuT0ONaUSf0BSUBpX24EUneOGh9S1b+5kfBo6WjiUBwt57TRV0OqPCeOyztUxE+wSAEZVes//U5gnjPXD7kEE2xh5qf1OOk/R/Um7NKHcx+5GLw4CTu6SyV2f9OwBuGE9KnftEj4vi2PymHz8U4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706742233; c=relaxed/simple;
	bh=r+gw0hlTKtdohBZj+zXKIzyuXhBHBMj2XAt/CW5yWgQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ArMiohcQ0DJ8XAoGUScIqHZnqoA+IBEtmSOrC6qgzGfOvof3PSRKnd9O0JuYZ7Yu72o5dMl6gX3oUyJvwv3zEWB4DbFuoQEbspppzB3PhrJN31IsnWmtbNmep8yR+4zvz9YGrRUUZnATSdB6xC+NLTIiFEnzpOLaXN6/kbs/aj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pe2noesU; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pe2noesU"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6040597d005so6064507b3.2
        for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 15:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706742230; x=1707347030; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DZwweSSUYQvO/z20yvIqcaNFaLAc1RqILCFOCkMXbPM=;
        b=pe2noesUdcawgBDe14LaF2UqNllK2K1yKEFuoZVcW0cKOQl0y02HZQVt2l7+sf2Ip9
         JvKPtIdu/PmoC9cijcFPq7hW/ETuEBCzuO+CkXFms67EGNMoWyeYQwtnbjdnIDkzA1Sr
         Ldw6Amdl5JP07igpQdBkBB1LhkOm/bjX4vNE4kd2bN0tGYKogAfHueQonbHgCDANo05L
         yIdcDRdzO6N4SHHqlmQ+d2LfsK6OzwLF1Ve+BLpV7oa6s8aw0GphK2rL30ZSQdMyd8of
         +YsGg7cH7CgRt6Gi8MrZLPHXHwVaEGANpYnvIa11UFnsMMhbviVrOVA7LIrf1GlKlkZK
         ZboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706742230; x=1707347030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DZwweSSUYQvO/z20yvIqcaNFaLAc1RqILCFOCkMXbPM=;
        b=QN1MiBPQ6ghuzH79rKlVq7g9yrBKfa5VH3E8Eb3A2AfUXQfeNWSeqDFJ4iZ5Ajm1eO
         WTYFF7F5tC5pE2xL48rR7RMjWc452GRFPC37LZLu7mVflIGtgDKkKck0lzjn/bJI5xwb
         zPJUuyxIcRyWpu/KC76Pyh3ALbeQ9GeQft+bOMQu6n1+xDkxcAmfcqJXSmzlhXUVUq7t
         TlO0ZKB2FsNKBoPjbuM7+KG2GM729orp5iF4MmkESB13NLSKi6GzsEaCG8ScYovu0oE4
         7aXMJUfUEMrAvbr6RaufRclGa/xEMZE6RO7VH3IR0Lroc5Zdeqa5JQnVGlc54ROBjF8L
         hGeg==
X-Gm-Message-State: AOJu0YwOX0YVVRwTpvLyPdCHthTryZ5kD76Uxbf9XqMMJ4PoKdrS4uRT
	X8pv7D6Kaz1Ig9Pf5zru1RudASkq9JvYksAtFxJaKk3inEsYSQR5T9cMhIsToIg0huzFeAl+LI/
	VAQ==
X-Google-Smtp-Source: AGHT+IFJbItnQs4Y8jmKkE5kxYlZxxDLejMwZjXJSJ/Pnb1uodzlMpEbl5+L7dgh/lCtAx5a7aAZSZtZzuc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:dd6:b0:5fc:43cb:cb1e with SMTP id
 db22-20020a05690c0dd600b005fc43cbcb1emr691136ywb.10.1706742230591; Wed, 31
 Jan 2024 15:03:50 -0800 (PST)
Date: Wed, 31 Jan 2024 15:03:48 -0800
In-Reply-To: <20231102155111.28821-3-guang.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231102155111.28821-1-guang.zeng@intel.com> <20231102155111.28821-3-guang.zeng@intel.com>
Message-ID: <ZbrR1BJROP4O9eGx@google.com>
Subject: Re: [RFC PATCH v1 2/8] KVM: selftests: x86: Support guest running on
 canonical linear-address organization
From: Sean Christopherson <seanjc@google.com>
To: Zeng Guang <guang.zeng@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Zeng Guang wrote:
> Setup execution environment running on 64-bit linear addresses for
> user and supervisor mode.
> 
> Define the linear address based on 48-bit canonical format in which
> bits 63:47 of the address are identical. All addresses to system data
> structure are shifted to supervisor-mode address space.
> 
> Extend page table mapping for supervisor mode to same guest physical
> address. This allows guest in supervisor mode can run in the
> corresponding canonical linear address space.
> 
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  |  6 ++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  6 ++--
>  .../selftests/kvm/lib/x86_64/processor.c      | 28 ++++++++++++-------
>  3 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 25bc61dac5fb..00f7337a520a 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -1256,4 +1256,10 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>  #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
>  #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
>  
> +/*
> + * X86 kernel linear address defines
> + */
> +#define KERNEL_LNA_OFFSET 0xffff800000000000

Please don't make up acronyms, I can more or less glean what LNA is from the
context _here_, but in other usage I would truly have no idea.

> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 9f4b8c47edce..6f4295a13d00 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -227,6 +227,13 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
>  void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
>  {
>  	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
> +
> +	/*
> +	 * Map same paddr to kernel linear address space. Make execution
> +	 * environment supporting running both in user and kernel mode.
> +	 */
> +	if (!(vaddr & BIT_ULL(63)))
> +		__virt_pg_map(vm, (uint64_t)KERNEL_ADDR(vaddr), paddr, PG_LEVEL_4K);

I really don't like the idea of piling hacks on top of selftests' misguided
infrastructure.  Letting tests control virtual addresses is all kinds of stupid.
Except for ARM's ucall_arch_init(), I don't think there's a single user of
virt_map() that _needs_ a specific address, e.g. most tests just identity map
the GPA.

So rather than fudge things by stuffing two mappings, which is wasteful for 99%
of mappings and will likely be a maintenance nightmare, I think we should go
straight to getting x86's kernel mappings setup correctly from time zero.

From KUT experience, using USER mappings for kernel accesses is explosions waiting
to happen due to SMAP and SMEP.  And expecting developers to remember to sprinkle
KERNEL_ADDR() everywhere is not remotely maintainable.

In other words, give virt_arch_pg_map() (or ideally, the common virt_map()) over
picking the virtual address, and then plumb in information as to whether the
allocation is USER vs. SUPERVISOR.
