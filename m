Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4FF2727F3
	for <kvmarm@lists.linux.dev>; Fri,  2 Jan 2026 16:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767372845; cv=none; b=GhfWep4c8Av0kqRisfM9yfRTd/oEeJvVYvYyFQnAqOOWcVDW4RQ9lEinFKpx1N7JJeXJC2g/4Y37uTXAJ4wEvgiLKApBTOJjCvrQWHxFOE8yrMe8SBdBbEh09VtqMdEbvxSw6dUIXm3eCmCks/VzKU21XcuvOg7AzZRnKWU7978=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767372845; c=relaxed/simple;
	bh=JtRgiIz4qm7QwkSobh9knxZkbdl4ppeJJ0eoR86dqEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IsZvO8DyLKRV3wssQ1j5Fvz+vjWyoOXXRcMcPSejriC4Id/MSYOkA9jouq3EQBwalDrKb8d+tZ9TQMU5e1JvuRJkF5VmtLNRkjUHfuDYkxH6rXhSAXm2Z4kCRFJOquKhoMeMDvkRXDBmP96xEZ3AcxbKZzwkSF6vqGfkuyJuVx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l8nGBsb6; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l8nGBsb6"
Date: Fri, 2 Jan 2026 16:53:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767372839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VquIGlMG22FiqzSomuVxO3pJuNTPu1MzbM7EM1lJb+o=;
	b=l8nGBsb6lcyGITzO1rS8L7sOEvvbDsF0q1xzPBnA1VBVgO2qsGxHHVFzHuTMKoxJA8/fIc
	ZPY6yVO7dLnhsu3KIQ46bH0iqlkuMomJ7RJeWsJOcx0dqFyiBfmubRB78b7n2QyK+kWXGV
	aJ8HKdAX2Zlj2vRx+JXzi/VwQhF1NO0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 08/21] KVM: selftests: Add a "struct kvm_mmu_arch
 arch" member to kvm_mmu
Message-ID: <zeiyns2xhtw76xtmn3so2jiyvcakszb5p2p6fak3dm62szzxon@rxkwn7peicen>
References: <20251230230150.4150236-1-seanjc@google.com>
 <20251230230150.4150236-9-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230230150.4150236-9-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 30, 2025 at 03:01:37PM -0800, Sean Christopherson wrote:
> Add an arch structure+field in "struct kvm_mmu" so that architectures can
> track arch-specific information for a given MMU.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h     | 2 ++
>  tools/testing/selftests/kvm/include/kvm_util.h                | 2 ++
>  tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h | 1 +
>  tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h     | 1 +
>  tools/testing/selftests/kvm/include/s390/kvm_util_arch.h      | 1 +
>  tools/testing/selftests/kvm/include/x86/kvm_util_arch.h       | 2 ++
>  6 files changed, 9 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
> index b973bb2c64a6..4a2033708227 100644
> --- a/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
> +++ b/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
> @@ -2,6 +2,8 @@
>  #ifndef SELFTEST_KVM_UTIL_ARCH_H
>  #define SELFTEST_KVM_UTIL_ARCH_H
>  
> +struct kvm_mmu_arch {};
> +
>  struct kvm_vm_arch {
>  	bool	has_gic;
>  	int	gic_fd;
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 39558c05c0bf..c1497515fa6a 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -92,6 +92,8 @@ struct kvm_mmu {
>  	bool pgd_created;
>  	uint64_t pgd;
>  	int pgtable_levels;
> +
> +	struct kvm_mmu_arch arch;
>  };
>  
>  struct kvm_vm {
> diff --git a/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h b/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
> index e43a57d99b56..d5095900e442 100644
> --- a/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
> +++ b/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
> @@ -2,6 +2,7 @@
>  #ifndef SELFTEST_KVM_UTIL_ARCH_H
>  #define SELFTEST_KVM_UTIL_ARCH_H
>  
> +struct kvm_mmu_arch {};
>  struct kvm_vm_arch {};
>  
>  #endif  // SELFTEST_KVM_UTIL_ARCH_H
> diff --git a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
> index e43a57d99b56..d5095900e442 100644
> --- a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
> +++ b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
> @@ -2,6 +2,7 @@
>  #ifndef SELFTEST_KVM_UTIL_ARCH_H
>  #define SELFTEST_KVM_UTIL_ARCH_H
>  
> +struct kvm_mmu_arch {};
>  struct kvm_vm_arch {};
>  
>  #endif  // SELFTEST_KVM_UTIL_ARCH_H
> diff --git a/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h b/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
> index e43a57d99b56..d5095900e442 100644
> --- a/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
> +++ b/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
> @@ -2,6 +2,7 @@
>  #ifndef SELFTEST_KVM_UTIL_ARCH_H
>  #define SELFTEST_KVM_UTIL_ARCH_H
>  
> +struct kvm_mmu_arch {};
>  struct kvm_vm_arch {};
>  
>  #endif  // SELFTEST_KVM_UTIL_ARCH_H
> diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> index 972bb1c4ab4c..456e5ca170df 100644
> --- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> +++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> @@ -10,6 +10,8 @@
>  
>  extern bool is_forced_emulation_enabled;
>  
> +struct kvm_mmu_arch {};
> +
>  struct kvm_vm_arch {
>  	vm_vaddr_t gdt;
>  	vm_vaddr_t tss;
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
