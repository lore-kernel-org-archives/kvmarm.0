Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A006F4A0F13;
	Tue, 22 Sep 2026 22:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790114958; cv=none; b=RFP8WYGmNlOAqStvE3GKCdBAhTCGIpkDrFKIYOCB9Ten2NL5gavKKO1PcuXiJBfvsZh8IAolw0IykGo5IMR4YK8bJ51R52/rd5cEkJDhuaBPVUTw9G1Kuuq1BKepZq31uFgsyH5g5JwuhSW9F6alXyM1wsJmO69+2A2fJgkguNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790114958; c=relaxed/simple;
	bh=LoWG5Bdx9GW8hSCm8uq7ODcJS1ns/SRbwzKLn1YrZL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EfIg31LjWvYnuuH73eiaQXz1AXJnPyloFvK6mjAXHg3RSv9ptNHcydx5EUpYZG6s+iAeeLNx2s7QN/OTSQxrYFnjvrqZfja2Z/J23E6RLb3DZJdrGtNZGRVQJU3VerI/UcaMXqochbs2/Pmm3cxgYtsdvYXm4qrCz0Cm/c+g1SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SsIhXisA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SsIhXisA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DE341576;
	Tue, 22 Sep 2026 15:09:06 -0700 (PDT)
Received: from [10.57.9.113] (unknown [10.57.9.113])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DE433F632;
	Tue, 22 Sep 2026 15:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790114949; bh=LoWG5Bdx9GW8hSCm8uq7ODcJS1ns/SRbwzKLn1YrZL8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SsIhXisAf8rJQwkEuQla6eDAwF3JKj+IVfN91G++RC+GjBElLTeFHlVNOORX4+IaQ
	 gUH+UO+jZWXv8J7/TlXnwZyYxok30jsLVHKBcZSTbVsCSivOffQA9N+Vvwi7Hb87CO
	 jc+8i+IHz0NnpUxPLTjPes5CyWvFi8tJu3HyfvKE=
Message-ID: <6cbfcb9c-209e-42a1-8ed3-de6d418de8e2@arm.com>
Date: Tue, 22 Sep 2026 23:09:04 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 06/20] KVM: arm64: Refactor the vcpu_load to allow for
 VM specific callbacks
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
 <20260920212845.707-7-suzuki.poulose@arm.com>
 <20260922125722.00006b2e@oss.qualcomm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260922125722.00006b2e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/09/2026 20:57, Jonathan Cameron wrote:
> On Sun, 20 Sep 2026 22:28:31 +0100
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> 
>> To keep the VCPU load/put handling cleaner with the different kinds of VM
>> types, we are about to introduce VM specific callbacks to do just the right
>> thing. In preparation for that, make some refactoring to add the change
>> easier.
>>
>> No functional changes intended. Based on a work by Marc Zyngier.
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Trivial stuff inline + maybe one blob that should be in previous patch?
> 

...

>> +
>> +static void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
>> +{
>> +	if (kvm_vcpu_should_clear_twe(vcpu))
>> +		vcpu->arch.hcr_el2 &= ~HCR_TWE;
>> +	else
>> +		vcpu->arch.hcr_el2 |= HCR_TWE;
>> +
>> +	if (kvm_vcpu_should_clear_twi(vcpu))
>> +		vcpu->arch.hcr_el2 &= ~HCR_TWI;
>> +	else
>> +		vcpu->arch.hcr_el2 |= HCR_TWI;
> 
> You could use FIELD_MODIFY() for these but maybe not worth it.
> 

...

>> @@ -772,7 +782,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>   		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
>>   
>>   		/* __pkvm_vcpu_put implies a sync of the state */
>> -		if (!kvm_vm_is_protected(vcpu->kvm))
>> +		if (kvm_vm_is_unprotected_pkvm(vcpu->kvm))
>>   			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> 
> Why in this patch?

I have moved it to the patch where we introduce the VM flavors, thanks!

Suzuki

> 
>>   	}
>>   
> 

