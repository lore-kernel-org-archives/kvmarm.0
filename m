Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C34A18C02E
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 04:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774846674; cv=none; b=jLcOyJoDhHbryu/E2Fn1bKqj3EtQc2tVkp3Th5wXta8GDWfZmhd1DBobFUQud/COr+C7oK1hyQnY0C+5lrO6H7WIBmwe0D1vDqom4k6LhSy5ut8NvwNPxUgNQAZFnLNKiMoMxU0HifWgX1QAWyPco8ChhT35/jiV/OK/iplpepo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774846674; c=relaxed/simple;
	bh=QaLFBPGPcR9DUZ8VRQyMuGIuOhU4fJIFDEX7tp7QiuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tTUkzfn0VlrXv3fo1QWNOPGdGioHAQmqbjnnWSopohtvG+gl0V7sIYboU+eXZIfgeFbSkxKDbkz04S8bwjgnm5Wo0eDMTQWWPc9HVIEMaZAeZ9qu7DlyPxjzp2EfUzdrH3ifeuis4LAV7wZsTzkBibDSQbp5//vLI3wlT5aX2EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vV3xvxKG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vV3xvxKG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A57931C2B;
	Sun, 29 Mar 2026 21:57:45 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 745763F915;
	Sun, 29 Mar 2026 21:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774846671; bh=QaLFBPGPcR9DUZ8VRQyMuGIuOhU4fJIFDEX7tp7QiuA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vV3xvxKG1nY/L7ne/t/EU5usEAdqjd/SQdX7SFtzF920hbTP5O3CQpdnNk02bR6r5
	 5GscpPsBhu2DvYGZ/Bfwo67cAB9SsdQqv2U35zpc9/oArHDaQ6iK/kmut+jkt9Bgvt
	 JkWREKPXgYOG8wfhQfgKTiWYWWk2jQToqOCi8iwY=
Message-ID: <849e40d3-f77b-45ba-bf03-744e8a306b2b@arm.com>
Date: Mon, 30 Mar 2026 10:27:45 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/30] KVM: arm64: Isolate mmap_read_lock inside new
 kvm_s2_fault_get_vma_info() helper
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-5-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-5-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/03/26 5:05 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Extract the VMA lookup and metadata snapshotting logic from
> kvm_s2_fault_pin_pfn() into a tightly-scoped sub-helper.
> 
> This refactoring structurally fixes a TOCTOU (Time-Of-Check to
> Time-Of-Use) vulnerability and Use-After-Free risk involving the vma
> pointer. In the previous layout, the mmap_read_lock is taken, the vma is
> looked up, and then the lock is dropped before the function continues to
> map the PFN. While an explicit vma = NULL safeguard was present, the vma
> variable was still lexically in scope for the remainder of the function.
> 
> By isolating the locked region into kvm_s2_fault_get_vma_info(), the vma
> pointer becomes a local variable strictly confined to that sub-helper.
> Because the pointer's scope literally ends when the sub-helper returns,
> it is not possible for the subsequent page fault logic in
> kvm_s2_fault_pin_pfn() to accidentally access the vanished VMA,
> eliminating this bug class by design.

Makes sense.

> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5079a58b65b14..1f2c2200ccd8d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1740,7 +1740,7 @@ struct kvm_s2_fault {
>  	vm_flags_t vm_flags;
>  };
>  
> -static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
> +static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  {
>  	struct vm_area_struct *vma;
>  	struct kvm *kvm = fault->vcpu->kvm;
> @@ -1774,9 +1774,6 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
>  
>  	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
>  
> -	/* Don't use the VMA after the unlock -- it may have vanished */
> -	vma = NULL;
> -
>  	/*
>  	 * Read mmu_invalidate_seq so that KVM can detect if the results of
>  	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
> @@ -1788,6 +1785,17 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
>  	fault->mmu_seq = kvm->mmu_invalidate_seq;
>  	mmap_read_unlock(current->mm);
>  
> +	return 0;
> +}
> +
> +static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
> +{
> +	int ret;
> +
> +	ret = kvm_s2_fault_get_vma_info(fault);
> +	if (ret)
> +		return ret;
> +
>  	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
>  				       fault->write_fault ? FOLL_WRITE : 0,
>  				       &fault->writable, &fault->page);

