Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0928D4968F0;
	Tue, 19 May 2026 10:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779185648; cv=none; b=CM4F9+JPjHLrFXMpWh8yHuLuDk2KJBqsrR4rHuyQ2LPSXm/W0tkITeviDw9MwHhGcY8klc/yDldWDFZ5if8PVbI6a5wJwwuiSSoawD3bMPG2ntHgbXyulU+pbtFKsMFMfpbDjEVUpLCfBC4QZwzb3zDPxxuv/plnXwIGIqq6GdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779185648; c=relaxed/simple;
	bh=ShfBiW+vq91XcTgWSa/la50XGXIbPtfnzFO4ifOfID4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rnkLuKRAoSR9Pmbf7lGAsO9jJBDLjKkWzKzoUNtW1BdsqazDEUZxVxhPnFe8fW3BH6AxjCrAD3T0APvVuustufewp7CSW9uMcAvMw6t7wiKrAzZpt7+Xn0Wz10T1ewgqv+drb7wzddTm5SCa805YRAdaEeStTVagCO4xrRuix2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WCodZuKB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WCodZuKB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 115AF2008;
	Tue, 19 May 2026 03:13:56 -0700 (PDT)
Received: from [10.57.21.217] (unknown [10.57.21.217])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97A693F85F;
	Tue, 19 May 2026 03:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779185641; bh=ShfBiW+vq91XcTgWSa/la50XGXIbPtfnzFO4ifOfID4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WCodZuKBHSvv0Lw3fiVNW9WTrXE9xTWRcDndU3xAfxrCnmh1baSZ9JZ66xgPSc+qB
	 TCRqox8LoUDgWZQ3zD+MpXFsov7Di1fQzBYbxn0svpwebaQ2WTmTuAaIsjVlRToUJS
	 GGa82phRLTPjd17dP+cJV0/D72gpzEOxokO9qGfU=
Message-ID: <6681f10b-0966-42e2-ae04-4e1aef47ec4d@arm.com>
Date: Tue, 19 May 2026 11:13:55 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 27/44] arm64: RMI: Set RIPAS of initial memslots
Content-Language: en-GB
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
 Alper Gun <alpergun@google.com>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-28-steven.price@arm.com> <yq5av7cjsonr.fsf@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <yq5av7cjsonr.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/05/2026 11:02, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> The memory which the realm guest accesses must be set to RIPAS_RAM.
>> Iterate over the memslots and set all gmem memslots to RIPAS_RAM.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>   
>   ...
>   
>> +static int set_ripas_of_protected_regions(struct kvm *kvm)
>> +{
>> +	struct kvm_memslots *slots;
>> +	struct kvm_memory_slot *memslot;
>> +	int idx, bkt;
>> +	int ret = 0;
>> +
>> +	idx = srcu_read_lock(&kvm->srcu);
>> +
>> +	slots = kvm_memslots(kvm);
>> +	kvm_for_each_memslot(memslot, bkt, slots) {
>> +		if (!kvm_slot_has_gmem(memslot))
>> +			continue;
>> +
>> +		ret = realm_init_ipa_state(kvm, memslot->base_gfn,
>> +					   memslot->npages);
>> +		if (ret)
>> +			break;
>> +	}
>> +	srcu_read_unlock(&kvm->srcu, idx);
>> +
>> +	return ret;
>> +}
>> +
>>   int kvm_arm_rmi_populate(struct kvm *kvm,
>>   			 struct kvm_arm_rmi_populate *args)
>>   {
>> @@ -890,6 +922,10 @@ int kvm_activate_realm(struct kvm *kvm)
>>   			return ret;
>>   	}
>>   
>> +	ret = set_ripas_of_protected_regions(kvm);
>> +	if (ret)
>> +		return ret;
>> +
>>   	ret = rmi_realm_activate(virt_to_phys(realm->rd));
>>   	if (ret)
>>   		return -ENXIO;
> 
> relam guest already does.
> 	for_each_mem_range(i, &start, &end) {
> 		if (rsi_set_memory_range_protected_safe(start, end)) {
> 			panic("Failed to set memory range to protected: %pa-%pa",
> 			      &start, &end);
> 		}
> 	}
> 
> if so why is host required to do this ?

Ideally this should be a call from the VMM (i.e., user). Irrespective of
what the guest does (which the host has no knowledge about), the VMM/
user is better aware of what to do for a given guest. We have done this
implicitly in the KVM as a start, to keep the initial implementation
simple. This could be moved out to the VMM as UABI, if there is
sufficient demand for it.

TL,DR: This should be a host/deployer decision, not the Guest. There
may other guest OS, which do not do RIPAS_RAM early enough.

Suzuki





