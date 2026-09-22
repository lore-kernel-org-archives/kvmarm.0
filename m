Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E40C15372E0;
	Tue, 22 Sep 2026 23:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790121365; cv=none; b=cCwZrEwl+zb+qAHTQRYprcCsAKjW6j45V3wKh0ZXN4o6HJ9sYI60MesxD8MKyZjXVQ54P1LDH0qY8qeJvJlDgkY8nHDTq/mhLEQ4AhYSnKl8x94m2WuTyxLaaXNw0e+EO6qodhZhdJNCqRMoLBWq2r9EAI0Yvj+dpdGEsdyd/L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790121365; c=relaxed/simple;
	bh=G8e6M2uF5epg0mdfJRhXU7Czxsd8V/rsRUnhd2e/rrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eE1Hgs63N/n04Pc60L6lrPB5Lk34bFCdJYKO6djxLfSXqcQhCPwkcXy0K8QFjnb3vtTb52ay8k1+eeoN2AzrjuYRcQwrLVq7zuVfG9XOqHGvX01WYdALqByrOmxA33G1Qi5OhX1j4896Fx+p6G+cvB1p074h47OlMBpbVuSQRyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lXkRV98I; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lXkRV98I"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A988D1576;
	Tue, 22 Sep 2026 16:55:58 -0700 (PDT)
Received: from [10.57.9.113] (unknown [10.57.9.113])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF8233F86C;
	Tue, 22 Sep 2026 16:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790121362; bh=G8e6M2uF5epg0mdfJRhXU7Czxsd8V/rsRUnhd2e/rrY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lXkRV98IlCqEa2C1khLd5C/DO/ZTEFQkQu/n//GoWxoIScMUHPHfA23likhQx/JAJ
	 Co84JB7vhjPa8oK53a/9h+ii2RGG0r3oaFh9exwYqC+1a6NWsH+GwXXyAilBEt6a2V
	 kyJYdkk0MkYF/W59YXBGyRub4EhwgWIEmkA+3bz4=
Message-ID: <84e8bbc0-30de-4741-933c-c24337507edb@arm.com>
Date: Wed, 23 Sep 2026 00:55:53 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 10/20] KVM: arm64: Abstract out memory abort handling
Content-Language: en-GB
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-11-suzuki.poulose@arm.com>
 <20260922153826.000044fb@oss.qualcomm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260922153826.000044fb@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/09/2026 23:38, Jonathan Cameron wrote:
> On Sun, 20 Sep 2026 22:28:35 +0100
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> 
>> Move the memory abort handling under VM specific s2 operation.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Trivial comment + request to follow through on adding the local
> variable for kvm. I think the other places that can be used
> survive the other changes in this patch set.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index d97a4a1bca23f..cf293d09e940a 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
> 
> 
>> +static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>> +{
>> +	int ret;
>> +	struct kvm_vcpu *vcpu = s2fd->vcpu;
>> +
>> +	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
>> +			!kvm_is_write_fault(vcpu) &&
>> +			!kvm_vcpu_trap_is_exec_fault(vcpu));
>> +
>> +	if (kvm_slot_has_gmem(s2fd->memslot))
>> +		ret = gmem_abort(s2fd);
>> +	else
>> +		ret = user_mem_abort(s2fd);
>> +	return ret;
> 
> Personal preference but I'd just do
> 		return gmem_abort(s2fd);
> 	else
> 		return user_mem_abort(s2fd);

Ack

> 
> and save a couple of lines. I'd keep the else to make it clear it is
> an either / or choice rather than an if something true one.
> 
>> +}
>> +
>>   /* Resolve the access fault by making the page young again. */
>>   static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>>   {
>> @@ -2287,6 +2303,7 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
>>   int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>   {
>>   	struct kvm_s2_trans nested_trans, *nested = NULL;
>> +	struct kvm *kvm = vcpu->kvm;
> 
> If introducing this, also use it for the other places vcpu->kvm is used
> in this function.  Separate patch though to keep down noise.
> Looks like that's mostly to shorten the chain of dereferences in the
> locks.

Added a preparatory patch to convert the other users to a local "kvm"
variable.

Cheers
Suzuki

