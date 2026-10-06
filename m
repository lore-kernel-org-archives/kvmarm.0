Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E6C2F8E99;
	Tue,  6 Oct 2026 05:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791264366; cv=none; b=kdtO7i3oPmShhLoPHE4I12/Vs0FqK0lx9bjFAlCTj95ChM0B3zEpBdzpFYQnbqMqJmst/yQYtM0BWjfkEynnkjbrgKxF4vo8aS3piFJ/pEbpWMUcSKDD3yQI3LXIeo/riVxVBBPc1bvGZmuxNRzGfNiExIEN9RdeHFgA15+LQxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791264366; c=relaxed/simple;
	bh=T27n/CS63jvcAJPIpOTMHb6o5n0o35jyMs3J5GrsRf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OK4sSEE3lXy1a+oO/0K2T67tO3OkxRJFbKwuVdAMOI8H0SP7ZOAfcViXOaPlQip94xu/X3NInDmiKFlT2hmNn3luYZddwhU9Xux8EFCUVNtpfA/vq7Y9wBSvctGXknTJEFrN6eKMg9j7WQ4oBEHlD/OkZY9xZv0mULfhfiGTFzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZOHKzYey; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZOHKzYey"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9664C143D;
	Mon,  5 Oct 2026 22:25:59 -0700 (PDT)
Received: from [10.57.10.233] (unknown [10.57.10.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 047533F763;
	Mon,  5 Oct 2026 22:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791264363; bh=T27n/CS63jvcAJPIpOTMHb6o5n0o35jyMs3J5GrsRf0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZOHKzYeyr5pX4PXgwPjbv5swyyCShOtBM3F7PorhIUACLRNa6afD1gd34KGVUSMvH
	 yLeH9ABhsdHbazhWnOJyZOKqaqIJpYxADcWkcM6mFFw8TPBJCbMKFzVVINsbqd8vR9
	 rV+VBMmlOlhIWlwrbiUTNkzXXfJkUZ5+22UDGmVk=
Message-ID: <32f0b0f6-bea4-49b1-a735-f9786cfc6e52@arm.com>
Date: Tue, 6 Oct 2026 07:25:57 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 13/23] KVM: arm64: Abstract out memory abort handling
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-14-suzuki.poulose@arm.com>
 <d8bdfcaf-3b4f-4ab1-9b73-597c60bbb60b@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <d8bdfcaf-3b4f-4ab1-9b73-597c60bbb60b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06/10/2026 04:07, Gavin Shan wrote:
> On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
>> Move the memory abort handling under VM specific s2 operation.
>>
>> Tested-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v21:
>>   - Rename protected_vm_mem_abort => protected_pkvm_mem_abort for 
>> consistency
>>     with the other callbacks.
>> ---
>>   arch/arm64/include/asm/kvm_host.h |  2 ++
>>   arch/arm64/kvm/mmu.c              | 33 ++++++++++++++++++-------------
>>   2 files changed, 21 insertions(+), 14 deletions(-)
>>
> 
> One nitpick below. In either way:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks Gavin !

...

>> +static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>> +{
>> +    struct kvm_vcpu *vcpu = s2fd->vcpu;
>> +
>> +    VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
>> +            !kvm_is_write_fault(vcpu) &&
>> +            !kvm_vcpu_trap_is_exec_fault(vcpu));
>> +
>> +    if (kvm_slot_has_gmem(s2fd->memslot))
>> +        return gmem_abort(s2fd);
>> +    else
>> +        return user_mem_abort(s2fd);
>> +}
> 
> The "if...else" block is moved from kvm_handle_guest_abort(), but it 
> might be
> clearer if we have:
> 
>      if (kvm_slot_has_gmem(s2fd->memslot))
>          return gmem_abort(s2fd);
> 
>      return user_mem_abort(s2fd);

This was chosen based on another review comment. So, lets stick with 
this now.

Cheers
Suzuki
