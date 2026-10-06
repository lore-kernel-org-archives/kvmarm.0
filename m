Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359A137F010;
	Tue,  6 Oct 2026 05:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791263361; cv=none; b=QOB8P9+OieLDUfc8gYGyqoOhlBqu3lxnG5uBBJrejhkRIYjMUtfRHwrt747tMZxKZTaSLVS0y7N4M2mqSOWbjtoY8AvIKfs6dsMPY+wMryGgcwnwCibVussH1HSJJM7YYfgCx+h/98Jt2GEh0EDbw3GUKVlMwPPBVabeOP04aDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791263361; c=relaxed/simple;
	bh=pucEWuti4eI8C1TIGnOlgVd8hOoodN55Yfj70uLt46Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jKoCqv7/O+Kf5HUSgChdUa40TS1HEvp0FrxppKASLKwwofclgVFc2vhefYI4eDeoQVHpMtXHE4z/T1zqAh32O3arXu09c7YMDonAhapkmaPys7q2lFT7WSl6z8posIRS2/LDLMr94qzAkHOZeUahHf8OGWRRrLwHdv0Y0YiDVDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ieN7Mhfm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ieN7Mhfm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD8A71595;
	Mon,  5 Oct 2026 22:09:10 -0700 (PDT)
Received: from [10.57.10.233] (unknown [10.57.10.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 346BC3F763;
	Mon,  5 Oct 2026 22:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791263354; bh=pucEWuti4eI8C1TIGnOlgVd8hOoodN55Yfj70uLt46Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ieN7Mhfm+583ckxOpzcQ0TPToOxynyRRUkZjdJtRAl0AohNUgC5EsQaW8hmhw+y6s
	 m4YIkSwSBHboyH6NXYPwiaKt84uTG6AQVkQoy7qfwZlUjJCxi32DDzHB8JZpZyr9R8
	 Feiu2FdOOHzqjNSLn1nMUW2N0kwJMmw6NOhpHQzQ=
Message-ID: <43bfa699-f35d-4f0a-bebd-3e955dd82112@arm.com>
Date: Tue, 6 Oct 2026 07:09:08 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 16/23] KVM: arm64: CCA: Add VCPU load/put for Realms
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
 <20261005090754.2140522-17-suzuki.poulose@arm.com>
 <fdc81d01-27df-4557-80bf-80d4527e4bf2@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <fdc81d01-27df-4557-80bf-80d4527e4bf2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Hi Gavin

On 06/10/2026 04:16, Gavin Shan wrote:
> On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
>> RMM controls the VCPU settings and most are hidden from the KVM, except
>> for the VGIC and timer bits.
>>
>> A later patch would add syncing the VCPU state into the Realm REC related
>> SMC parameters.

This is what you are looking for ^^^

>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/kvm/arm.c | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 6c81fec35ecec..294cea4cc8271 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -802,6 +802,13 @@ static void pkvm_vcpu_load(struct kvm_vcpu *vcpu)
>>                 &vcpu->arch.vgic_cpu.vgic_v3);
>>   }
>> +static void realm_vcpu_load(struct kvm_vcpu *vcpu)
>> +{
>> +    kvm_timer_vcpu_load(vcpu);
>> +    kvm_vgic_load(vcpu);
>> +    vcpu_set_wfx_traps(vcpu);
> 
> Why we need to call vcpu_set_wfx_traps(), which updates 'vcpu- 
>  >arch.hcr_el2'? I don't
> see how 'vcpu->arch.hcr_el2' is affects realm in RMM. Could you please 
> explain in the
> commit log.

See above.


Cheers
Suzuki

> 
>> +}
>> +
>>   void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   {
>>       vcpu->cpu = cpu;
>> @@ -854,6 +861,12 @@ static void pkvm_vcpu_put(struct kvm_vcpu *vcpu)
>>       kvm_vcpu_pmu_restore_host(vcpu);
>>   }
>> +static void realm_vcpu_put(struct kvm_vcpu *vcpu)
>> +{
>> +    kvm_timer_vcpu_put(vcpu);
>> +    kvm_vgic_put(vcpu);
>> +}
>> +
>>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>   {
>>       vcpu->arch.vcpu_ops->vcpu_put(vcpu);
>> @@ -2213,6 +2226,11 @@ static const struct kvm_vcpu_ops pkvm_vcpu_ops = {
>>       .vcpu_put = pkvm_vcpu_put,
>>   };
>> +static const struct kvm_vcpu_ops realm_vcpu_ops = {
>> +    .vcpu_load = realm_vcpu_load,
>> +    .vcpu_put = realm_vcpu_put,
>> +};
>> +
>>   #define KVM_VCPU_OPS(flavor, ops)        \
>>       [(flavor)] = &(ops)
> 
> Thanks,
> Gavin
> 
> 

