Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460A2242D8D;
	Tue, 20 May 2025 14:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747753133; cv=none; b=IaWU5gEFsKytzwRHqceE4ImFw9bhMdeKzEwz4Kd0Hi1Yg1OxwhaKRfwlB4UJBFzit59BD9UwWK82yOKjhNPH8xYvkDjdvUPyTMaTLnOpShzaZb21if2NOHfSvNDkd021fclxh6gk/O6c6ehTEd/148EvG14SU0N0BHkyNseKrkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747753133; c=relaxed/simple;
	bh=Uzx9aG9IvKdw8/oJA5KQYQfFxII9nEKITiq82lElzAU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=cnRF6MbUx1Ne89ZFl2UKjrseAj+22C+TfiW+uwXgvfQSsNEF/oJ7LlYB0Jc9NreCreUnVR9n1OLVLofmFcGgIxuxu7eTN8iqe8qQq8MbjG7mNJ2lkZhca+q7ILFATPcmghpuNmGrjOD47uSILt0nv1KfJVONSpTrJ+/6eIsEZGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D9F31516;
	Tue, 20 May 2025 07:58:37 -0700 (PDT)
Received: from [10.57.50.40] (unknown [10.57.50.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 70A563F6A8;
	Tue, 20 May 2025 07:58:47 -0700 (PDT)
Message-ID: <22a6cdd0-4fa3-4548-9c9f-ce8605694261@arm.com>
Date: Tue, 20 May 2025 15:58:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 20/43] arm64: RME: Runtime faulting of memory
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
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
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-21-steven.price@arm.com>
 <3a04995a-524c-4d07-8c8b-82930f9bca72@arm.com>
In-Reply-To: <3a04995a-524c-4d07-8c8b-82930f9bca72@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/05/2025 18:35, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 16/04/2025 14:41, Steven Price wrote:
>> At runtime if the realm guest accesses memory which hasn't yet been
>> mapped then KVM needs to either populate the region or fault the guest.
>>
>> For memory in the lower (protected) region of IPA a fresh page is
>> provided to the RMM which will zero the contents. For memory in the
>> upper (shared) region of IPA, the memory from the memslot is mapped
>> into the realm VM non secure.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>

>> +    } else {
>> +        map_level = 3;
>> +        map_size = RMM_PAGE_SIZE;
>> +    }
>> +
>> +    for (offset = 0; offset < size; offset += map_size) {
>> +        /*
>> +         * realm_map_ipa() enforces that the memory is writable,
> 
> The function names seems to be obsolete, please fix.

Doh, it is in arch/arm64/kvm/mmu.c, please ignore this comment.

Suzuki
