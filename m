Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7AA3D9031;
	Fri, 10 Apr 2026 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775833951; cv=none; b=JN7IF0idlqi/wV6U6V5yWrCMrXc8KhARo0Kg5m4CqXWy6P46A250zCbgYPpRp/jMYhMk96HmadUjcaDxsJljcFF+Ft2bZtIdOFh1SewPAw2oEFXj4XA6VICJtCxC7WtQ11WvIbIVyrUyU3NIINvMSWOWHmalsDfvgh/tYC77DYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775833951; c=relaxed/simple;
	bh=MHY1zIuJTnMcvfLgjeNfhsvhJAzG+2Wf6PamZxvC1Z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pWuwX/Au8gEJEHK6ze+fkJO65R3Bx1C4++1NJKvGQZG2GWbuEU4AsKdq0OGPvNJwPfbMfYGePbF6P8SVjTHj7LI5KHP8tY0YBtso7GW4vYC6S1yGmSg3hgxOZXhkYLIec5D7EpBs8coOdJi4UEaYBPXV8oZ0WKTPO2iVhXZBqP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KbYyqzXW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KbYyqzXW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74A191CE2;
	Fri, 10 Apr 2026 08:12:23 -0700 (PDT)
Received: from [10.1.29.18] (e122027.cambridge.arm.com [10.1.29.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2AF33FAA1;
	Fri, 10 Apr 2026 08:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775833949; bh=MHY1zIuJTnMcvfLgjeNfhsvhJAzG+2Wf6PamZxvC1Z4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KbYyqzXWMyZfA146oUepWmaULNpw1iRK3IFrwgwK/Pt9Q7Vg6r2pVVPexEvHtPggd
	 RrDq6AKUkx1X/M74yv/SwXGgEPPa2VsiIHzOU5USCOpbBpuv09GQeQGeUCnxmLdCP1
	 oJhB9X5X0eqNF+iBUC7Bx1yBmu4qXcN3zkOaAudE=
Message-ID: <22f3b6f0-cde1-4aa3-83b7-8477d74e7a3c@arm.com>
Date: Fri, 10 Apr 2026 16:12:23 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 37/48] arm64: RMI: Prevent Device mappings for Realms
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
 <20260318155413.793430-38-steven.price@arm.com>
 <20260319102734.GC3942350@e124191.cambridge.arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260319102734.GC3942350@e124191.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/03/2026 10:27, Joey Gouly wrote:
> On Wed, Mar 18, 2026 at 03:54:01PM +0000, Steven Price wrote:
>> Physical device assignment is not supported by RMM v1.0, so it
> 
> But we're targetting 2.0 now!

Whoops ;) In my head it's still "in the future" but I guess the "future" 
is now!

I'll update this to say:

    Physical device assignment is not yet supported. RMM v2.0 does add the
    relevant APIs, but device assignment is a big topic so will be handled
    in a future patch series. For now prevent device mappings when the guest
    is a realm.

Thanks,
Steve

> I guess just change it to something about device support being a later feature.
> 
> Thanks,
> Joey
> 
>> doesn't make much sense to allow device mappings within the realm.
>> Prevent them when the guest is a realm.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes from v6:
>>  * Fix the check in user_mem_abort() to prevent all pages that are not
>>    guest_memfd() from being mapped into the protected half of the IPA.
>> Changes from v5:
>>  * Also prevent accesses in user_mem_abort()
>> ---
>>  arch/arm64/kvm/mmu.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index ad1300f366df..7d7caab8f573 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1222,6 +1222,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>>  	if (is_protected_kvm_enabled())
>>  		return -EPERM;
>>  
>> +	/* We don't support mapping special pages into a Realm */
>> +	if (kvm_is_realm(kvm))
>> +		return -EPERM;
>> +
>>  	size += offset_in_page(guest_ipa);
>>  	guest_ipa &= PAGE_MASK;
>>  
>> @@ -1965,6 +1969,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  		return 1;
>>  	}
>>  
>> +	/*
>> +	 * For now we shouldn't be hitting protected addresses because they are
>> +	 * handled in private_memslot_fault(). In the future this check may be
>> +	 * relaxed to support e.g. protected devices.
>> +	 */
>> +	if (vcpu_is_rec(vcpu) &&
>> +	    kvm_gpa_from_fault(kvm, fault_ipa) == fault_ipa)
>> +		return -EINVAL;
>> +
>>  	if (nested)
>>  		adjust_nested_fault_perms(nested, &prot, &writable);
>>  
>> -- 
>> 2.43.0
>>
>>

