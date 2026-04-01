Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE453339B41
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 03:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775014514; cv=none; b=JfO9aziVCogPKFKY5IFtMHusnbM4ccBahTBqHLQO3Mh3RjoqQMsXxCsDLR3x+/V+RjEOachSrm5bmwzrxCjEhzNC7j2h1i/Luwa65soAZWDSwkdssG/okoeUPTqBAr4etH/Gfse9ypShZ2ulYRJiVQTJM6gXgWCgrjsmC3JdSIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775014514; c=relaxed/simple;
	bh=pHLdzIu+gjxC8ubRM8t7HQ1rx7VU+czt+7QSkF6RexQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qIoe3lx/qYYh4mn7rMNv3EpoTPI9bNz6QHh8XLBbrHcByXS+2igf7wJEPuOCuFIdN2M6/rO1ZopG2vMIeKmvQTQn9G0rTdVmBAwqrisdCTZtnoPe9qt+4AtTknjVApvpvMGOjSrbkyTtKLsuiQAorcZ0uMGlpxpRsImyK0THZIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TpU8p+ya; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TpU8p+ya"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78AB21684;
	Tue, 31 Mar 2026 20:35:06 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27EA33F915;
	Tue, 31 Mar 2026 20:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775014512; bh=pHLdzIu+gjxC8ubRM8t7HQ1rx7VU+czt+7QSkF6RexQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TpU8p+yaz5ZkoAfZgdhaDqiYu+XvtASRD0PAfFRXfNrZQqQ+OZMjavngUDyfTK49h
	 B1STbsN9GKYDvOEVSKo5p3c1WyLqRUre3IFXzsxQobU0oltK1V/dUyRlOyrKiuvVL4
	 VHB2f/gkee1m74OCIp8sCR5twGyxnPihUN7ePRI8=
Message-ID: <3e14049e-dc9d-46ae-91bd-6cca09245907@arm.com>
Date: Wed, 1 Apr 2026 09:05:06 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/30] KVM: arm64: Kill exec_fault from kvm_s2_fault
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-21-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-21-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/03/26 5:06 PM, Marc Zyngier wrote:
> Similarly to write_fault, exec_fault can be advantageously replaced
> by the kvm_vcpu_trap_is_exec_fault() predicate where needed.
> 
> Another one bites the dust...
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7dab0c3faa5bf..e8bda71e862b2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1711,7 +1711,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>  }
>  
>  struct kvm_s2_fault {
> -	bool exec_fault;
>  	bool writable;
>  	bool topup_memcache;
>  	bool mte_allowed;
> @@ -1857,7 +1856,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>  		fault->writable = false;
>  	}
>  
> -	if (fault->exec_fault && fault->s2_force_noncacheable)
> +	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && fault->s2_force_noncacheable)
>  		return -ENOEXEC;
>  
>  	/*
> @@ -1877,7 +1876,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>  	if (fault->writable)
>  		fault->prot |= KVM_PGTABLE_PROT_W;
>  
> -	if (fault->exec_fault)
> +	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
>  		fault->prot |= KVM_PGTABLE_PROT_X;
>  
>  	if (fault->s2_force_noncacheable)
> @@ -1984,7 +1983,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  		.logging_active = logging_active,
>  		.force_pte = logging_active,
>  		.prot = KVM_PGTABLE_PROT_R,
> -		.exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
>  		.topup_memcache = !perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu)),
>  	};
>  	void *memcache;

