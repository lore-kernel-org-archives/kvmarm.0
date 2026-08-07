Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20AD3FA5EC;
	Fri,  7 Aug 2026 10:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097570; cv=none; b=F9ecrLhhcT3glagq2WJe9L54+B4DRgnYZ2HSmdvZH+WXDsJ4c9vF1Xk5YKvzig3uzhONyNmLXP9Stp8IGbvzPqPoD991FI3WRzaOBgB5bXRls13pDla+M7znbPwVC5URJnPwy0DptSdA0HxQeC0DGBo2BhNqzffA1jEgwHjgawI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097570; c=relaxed/simple;
	bh=RCjEnEVGvnPhNyVz+L0gppAUU0iJNEMsCr6Uit3ezoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zx/AEaq7+TS2YtItD9Or4TSO2eLeZbX65CUXF+dGPDGhRDruMxz+dQgeJ9tATDjTld6oYmawzhQopsZZOUxdhleorOAya9aQgiHFLo31tLRavyQYoFIUfqn19jQWOP63fCYs1ZjyX5yzLQd4nukOCqhIbLaoEB2NcJapAZo3ANQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RxcFF9v8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RxcFF9v8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B8FB1516;
	Fri,  7 Aug 2026 03:12:37 -0700 (PDT)
Received: from [10.57.40.157] (unknown [10.57.40.157])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 389683F9A2;
	Fri,  7 Aug 2026 03:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786097561; bh=RCjEnEVGvnPhNyVz+L0gppAUU0iJNEMsCr6Uit3ezoM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RxcFF9v8HQg/UXJUre/Po0mVBjk1Q+BuwXj0dOswBiiMFJKfkVMFZdDGim2VLPy7O
	 yWZcoh7+WGEY+nwEVOJP8ugA5VfOQPBj/xE8od5N9Qzs5CYocAPEZN+wTd4Smy6xHC
	 xPZb4plN5N3J556tMiN/owCKTPJWfiLp3i/UUA5U=
Message-ID: <92b81b5a-933b-4b4f-b889-7f9ec68d53a5@arm.com>
Date: Fri, 7 Aug 2026 11:12:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 24/45] KVM: arm64: Expose support for private memory
Content-Language: en-GB
To: Ackerley Tng <ackerleytng@google.com>, Steven Price
 <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-25-steven.price@arm.com>
 <CAEvNRgE5O4FcNQDHwh+DWsHH7gLs3qzm+L4ZQ9FHkt=WoTV2Hw@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CAEvNRgE5O4FcNQDHwh+DWsHH7gLs3qzm+L4ZQ9FHkt=WoTV2Hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/08/2026 17:02, Ackerley Tng wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> Select KVM_GENERIC_MEMORY_ATTRIBUTES and provide the necessary support
>> functions.
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v14:
>>   * Switch to guest_memfd in-place memory conversion and drop support
>>     for KVM_VM_MEMORY_ATTRIBUTES.
>>
>> [...snip...]
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 15d42d1993bb..146c52f867c0 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -1510,6 +1510,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>>
>>   #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
>>
>> +#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
>> +
> 
> Perhaps related to Fuad's question about pKVM and CCA state: would
> conditioning this on is_realm mess up pKVM?

Not really. The comment is about unifiying the conditions which
both pKVM and Realm selects. Right now, only CCA uses guest_memfd.
When pkvm comes along to use guest_memfd, this could be something
like:

kvm->arch.needs_private_mem  (set by both pKVM and Realm) ?

Cheers
Suzuki


> 
>>   int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>>   bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>>
>> --
>> 2.43.0

