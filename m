Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907843EDADD
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767020; cv=none; b=EdqpBPdNB2n+o0utmtveQc0K+WCkd0RjuICmEAIZjwh3azflb0tlLE6UTJF9xmaulYLhAfH4b7sU56Z9+9yZ0TI2qo4P1rxrdmyAp7OZaiAyGzajBUycNwJRuj3JLwwJbD37E17VXdScZAeSQT0e31OrLMYFNo+8civx3J97tMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767020; c=relaxed/simple;
	bh=e8JLDBokqD8c6xgseKI7FrDediQiizDI/u2nArMKW98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=shfjPGxET88l2u/xmCMMeNhxg0F3UEfqmR8wUrodeiI+6if3cJtvZ0k18MFycvy9nlF86XntzUG2WSGZ421ST3HGPeacURB8OOHm6c9cqMg0nOFU71lV+q6wxWtM7AKyjd+sbEUd2GL3f9Sm4QEMtUfo4vrtfIag8B9j9RD2Lfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C35171477;
	Tue, 17 Mar 2026 10:03:31 -0700 (PDT)
Received: from [10.57.20.100] (unknown [10.57.20.100])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80E293F778;
	Tue, 17 Mar 2026 10:03:36 -0700 (PDT)
Message-ID: <65fd6905-f753-41cd-8ce5-c788ef67e748@arm.com>
Date: Tue, 17 Mar 2026 17:03:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/17] KVM: arm64: More user_mem_abort() rework
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260316175451.1866175-1-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260316175451.1866175-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/03/2026 17:54, Marc Zyngier wrote:
> Piqued by Fuad's initial set of patches[1] splitting user_mem_abort()
> into more "edible" functions, I've added my on take on top of it with
> a few goals in mind:
> 
> - contextualise the state by splitting kvm_s2_fault into more granular
>    structures
> 
> - reduce the amount of state that is visible and/or mutable by any
>    single function
> 
> - reduce the number of variable that simply cache state that is
>    already implicitly available (and often only a helper away)
> 
> I find the result reasonably attractive, and throwing it at a couple
> of machines didn't result in anything out of the ordinary.

Indeed a very nice cleanup both of you ! Thanks for making this
pleasing to the eyes and easier to reason about.

FWIW:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> 
> For those interested, I have stashed a branch at [2], and I'd
> appreciate some feedback on the outcome.
> 
> [1] https://lore.kernel.org/all/20260306140232.2193802-1-tabba@google.com/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=hack/user_mem_abort-rework
> 
> Marc Zyngier (17):
>    KVM: arm64: Kill fault->ipa
>    KVM: arm64: Make fault_ipa immutable
>    KVM: arm64: Move fault context to const structure
>    KVM: arm64: Replace fault_is_perm with a helper
>    KVM: arm64: Constrain fault_granule to kvm_s2_fault_map()
>    KVM: arm64: Kill write_fault from kvm_s2_fault
>    KVM: arm64: Kill exec_fault from kvm_s2_fault
>    KVM: arm64: Kill topup_memcache from kvm_s2_fault
>    KVM: arm64: Move VMA-related information to kvm_s2_fault_vma_info
>    KVM: arm64: Kill logging_active from kvm_s2_fault
>    KVM: arm64: Restrict the scope of the 'writable' attribute
>    KVM: arm64: Move kvm_s2_fault.{pfn,page} to kvm_s2_vma_info
>    KVM: arm64: Replace force_pte with a max_map_size attribute
>    KVM: arm64: Move device mapping management into kvm_s2_fault_pin_pfn()
>    KVM: arm64: Directly expose mapping prot and kill kvm_s2_fault
>    KVM: arm64: Simplify integration of adjust_nested_*_perms()
>    KVM: arm64: Convert gmem_abort() to struct kvm_s2_fault_desc
> 
>   arch/arm64/kvm/mmu.c | 428 ++++++++++++++++++++++---------------------
>   1 file changed, 223 insertions(+), 205 deletions(-)
> 

