Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7463E958C;
	Thu, 19 Mar 2026 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773936147; cv=none; b=SbeveFUq46ZFg+eC4w0n/ySMB14bGgZyEY4c1lzQtJBV/2UIrHOeEFKk/Gv9bNEvXutwi2oxYcTjNf2GIlXp/ADq8cowFem2F0J0VIGcQw7X7icjPs8Ow9gdLeBfO6ZLQXfeGZB3w70Xwz61umfxifGnL7bbfMIsmQV/8JfYAP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773936147; c=relaxed/simple;
	bh=m/gjQlYB+hLSfdVp59u4Wyf2AMcQ/gjJRogO5vmkwIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OIAxfes4C7FSmKrCCSKXxYJc5WJl+9myXwgqnOMox8IxNuAMk01VN73yz5YhLZub00e08uBM3gqNviRTBrxYt0CgAPB/DCEVuO7IAe0c6mUIUWVgADQ/wmhNJ5pDZvfxFP2LLGQmSLSSVYz2Y7Be0mDlcm+6/XunUdNWBiNhnDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA1BB1477;
	Thu, 19 Mar 2026 09:02:19 -0700 (PDT)
Received: from [10.1.35.24] (e122027.cambridge.arm.com [10.1.35.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AA213F778;
	Thu, 19 Mar 2026 09:02:20 -0700 (PDT)
Message-ID: <a4a822dd-8b77-4a42-a366-230324d0585f@arm.com>
Date: Thu, 19 Mar 2026 16:02:18 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 36/48] arm64: RMI: Always use 4k pages for realms
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-37-steven.price@arm.com>
 <20260319102454.GB3942350@e124191.cambridge.arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260319102454.GB3942350@e124191.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/03/2026 10:24, Joey Gouly wrote:
> Hi,
> 
> On Wed, Mar 18, 2026 at 03:54:00PM +0000, Steven Price wrote:
>> Guest_memfd doesn't yet natively support huge pages, and there are
>> currently difficulties for a VMM to manage huge pages efficiently so for
>> now always split up mappings to PTE (4k).
>>
>> The two issues that need progressing before supporting huge pages for
>> realms are:
>>
>>  1. guest_memfd needs to be able to allocate from an appropriate
>>     allocator which can provide huge pages.
>>
>>  2. The VMM needs to be able to repurpose private memory for a shared
>>     mapping when the guest VM requests memory is transitioned. Because
>>     this can happen at a 4k granularity it isn't possible to
>>     free/reallocate while huge pages are in use. Allowing the VMM to
>>     mmap() the shared portion of a huge page would allow the huge page
>>     to be recreated when the memory is unshared and made protected again.
>>
>> These two issues are not specific to realms and don't affect the realm
>> API, so for now just break everything down to 4k pages in the RMM
>> controlled stage 2. Future work can add huge page support without
>> changing the uAPI.
> 
> The commit title/message mention 4K, but should probably say PAGE_SIZE or
> something now that RMM isn't fixed to 4K.

Indeed - this is all PAGE_SIZE not 4k any more. Also hopefully the
reasons for this patch are also going to disappear soon. (2) above isn't
really very true any more (we do support mmap() from guest_memfd).

Thanks,
Steve

> Thanks,
> Joey
> 
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v7:
>>  * Rewritten commit message
>> ---
>>  arch/arm64/kvm/mmu.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 73c18c2861a2..ad1300f366df 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1761,11 +1761,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	write_fault = kvm_is_write_fault(vcpu);
>>  
>>  	/*
>> -	 * Realms cannot map protected pages read-only
>> +	 * Realms cannot map protected pages read-only, also force PTE mappings
>> +	 * for Realms.
>>  	 * FIXME: It should be possible to map unprotected pages read-only
>>  	 */
>> -	if (vcpu_is_rec(vcpu))
>> +	if (vcpu_is_rec(vcpu)) {
>>  		write_fault = true;
>> +		force_pte = true;
>> +	}
>>  
>>  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>>  	VM_WARN_ON_ONCE(write_fault && exec_fault);
>> -- 
>> 2.43.0
>>
>>

