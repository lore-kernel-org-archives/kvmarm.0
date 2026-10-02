Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19B04DEC2B;
	Fri,  2 Oct 2026 15:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790955782; cv=none; b=Duvh1h8mnyyEFmzMKWblPkk75Twyxku+ng9z8/lNN8lN2FR3wIO47Ss/a0mybGMVWQtfOHWOpNSyN97prZrFrP62cj2ukvCQ6db9aZxYVUlR0jnCyNiwW6sQzH3P3Dl1HFBcaycdIaVuJOmHYe0AQ8AcXRqptIIxlvC556K/oqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790955782; c=relaxed/simple;
	bh=r8+UnxmyfA5EDSuksv2pnxeyK5XiuiA24DSSA+ymriQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cve9XCq0OvziDnLfxZR7J8U5hPhSizaW4GVTgyxsHjiLzVweGXQkoxTPz/lDKoYYaLTxZYWyKfdpkK+rxvaLVtekejbeubQ4D6QYuGsHz2TVUVwUy6yPGz2/f9j8SvGI1z3EoBjn6Z/O9PQatZJAVT0wEYDVhEQ6LAEXvJURIT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dzh5F1AK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dzh5F1AK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AFC2169C;
	Fri,  2 Oct 2026 08:42:56 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 288203F882;
	Fri,  2 Oct 2026 08:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790955779; bh=r8+UnxmyfA5EDSuksv2pnxeyK5XiuiA24DSSA+ymriQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Dzh5F1AKrpbHWa673YlUnb+QaPBv+ryTwN2qA0v7GExcq5nJEtJAKOdiFHBJNPEFP
	 pFwajcDOxIV5F67JsKcpzvdtetsme/gidZj8IvCCmDJwCBdfv+qHhDNUFcqS9aqjss
	 UiKs9r9V+zuQQ5J1dugVGegGFqHZdLdg0ZgZZMCw=
Message-ID: <87659487-6a77-4b04-907a-859e1738395e@arm.com>
Date: Fri, 2 Oct 2026 16:42:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 05/23] KVM: arm64: Track the type of VM in kvm_arch
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 gshan@redhat.com, joey.gouly@arm.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-6-suzuki.poulose@arm.com>
 <CA+EHjTxtatPyGcyvEyR129cqUiAYcO_cxRVtwZO0ckZsOnD7TA@mail.gmail.com>
 <86se2o2rbs.wl-maz@kernel.org>
 <CA+EHjTwHuJ0u_TTP46zNFKFmBP124XHHLUVhkAUSyfhe92=41w@mail.gmail.com>
 <86pkxs2npx.wl-maz@kernel.org> <10563362-5964-4ef7-b5d7-fe1d67ce4adb@arm.com>
 <86mrsw2jrn.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86mrsw2jrn.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2026 16:40, Marc Zyngier wrote:
> On Fri, 02 Oct 2026 16:15:07 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 0f4e8b71fa85d..9ba86450fe4af 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -2624,7 +2624,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>    	hva_t hva, reg_end;
>>>    	int ret = 0;
>>>    -	if (kvm_vm_is_protected_pkvm(kvm)) {
>>> +	if (kvm_vm_is_protected(kvm)) {
>>
>> We have slightly different handling for Realms. The final code for this
>> looks like :
>>
>> 	if (kvm_vm_is_protected(kvm)) {
>> 		if (new &&
>> 		    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
>> 			return -EPERM;
>> 		}
>> 	}
>>
>> 	if (kvm_vm_is_protected_pkvm(kvm)) {
>> 		/* Cannot modify memslots once a pVM has run. */
>> 		if (pkvm_hyp_vm_is_created(kvm) &&
>> 		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
>> 			return -EPERM;
>> 		}
>> 	} else if (kvm_realm_is_created(kvm)) {
>> 		/*
>> 		 * Once the Realm is created, we cannot modify any slots that
>> 		 * could be providing private memory. i.e., guest_memfd backed
>> 		 * slots.
>> 		 * TODO: Handle trusted device private memory slots
>> 		 */
>> 		if (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new))
>> 			return -EPERM;
>> 	}
>>
>>
>> Of course we could invert the checks to detect vm_is_protected_pkvm()
> 
> This is how I expect this stuff to be written.
> 
> 	if (kvm_vm_is_protected(kvm) && new &&
> 	    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY))
> 		return -EPERM;
> 
> 	switch (kvm->vm_flavor) {
> 	case VM_PROTECTED_PKVM:
> 		/* Cannot modify memslots once a pVM has run. */
> 		if (pkvm_hyp_vm_is_created(kvm) &&
> 		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
> 			return -EPERM;
> 		break;
> 	case VM_CCA:
> 		/*
> 		 * Once the Realm is created, we cannot modify any slots that
> 		 * could be providing private memory. i.e., guest_memfd backed
> 		 * slots.
> 		 * TODO: Handle trusted device private memory slots
> 		 */
> 		if (kvm_realm_is_created(kvm) &&
> 		    (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new)))
> 			return -EPERM;
> 		break;
> 	default:
> 		break;
> 	}
> 

Yep, we can do that.

Cheers
Suzuki


> We have an enumeration. Make use of it. And the whole "is_created"
> crap needs to be sorted one way or another.
> 
> 	M.
> 

