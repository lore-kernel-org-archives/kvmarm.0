Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A52336606C;
	Thu, 19 Mar 2026 15:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773933914; cv=none; b=P3xxM+PFzG7IpMsoPxPMcoyYZWD3sf7B3VQjpVXFeSbPAAuVQ43SglDFpjbIPyuJndr5TcYvNjw0NGvIFj3lBcwz1lj3xfM46/B1LWzNY6gzV9w05sp2H8FmdCAIxrizGCV4cc8BE7McODdMWUoT6hlaD9fqWyjDJDh31LOn8sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773933914; c=relaxed/simple;
	bh=RLooZ/HR5p7i0bDi8RKkEWym+5uMbalmbtBpRnRXpMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JqDPS/itmpVSp05lNj7KIT6pEPLi5K/9UkVdR2GODeeiQBwEPhlv7en8YS1YVZ7ZtZO2vCc8ocktuDzowmz2P7WsVR6EoblV7siCxcj92xm/AY7OqKZkXWhs4J54FeKagKjZ6ZFoYlH5gPcL2tQLT/zx98G9HJ1UHRQDdXbFyIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C3161A25;
	Thu, 19 Mar 2026 08:25:06 -0700 (PDT)
Received: from [10.1.35.24] (e122027.cambridge.arm.com [10.1.35.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8108A3F778;
	Thu, 19 Mar 2026 08:25:08 -0700 (PDT)
Message-ID: <3e917733-0272-4f2c-aa10-36364604fcbd@arm.com>
Date: Thu, 19 Mar 2026 15:25:06 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 13/48] kvm: arm64: Don't expose unsupported
 capabilities for realm guests
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
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
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-14-steven.price@arm.com>
 <56fb42ad-eada-40df-8c81-53cb7c0c310e@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <56fb42ad-eada-40df-8c81-53cb7c0c310e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 19/03/2026 14:09, Suzuki K Poulose wrote:
> On 18/03/2026 15:53, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> RMM v1.0 provides no mechanism for the host to perform debug operations
>> on the guest. So limit the extensions that are visible to an allowlist
>> so that only those capabilities we can support are advertised.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v10:
>>   * Add a kvm_realm_ext_allowed() function which limits which extensions
>>     are exposed to an allowlist. This removes the need for special casing
>>     various extensions.
>> Changes since v7:
>>   * Remove the helper functions and inline the kvm_is_realm() check with
>>     a ternary operator.
>>   * Rewrite the commit message to explain this patch.
>> ---
>>   arch/arm64/kvm/arm.c | 22 ++++++++++++++++++++++
>>   1 file changed, 22 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 9b17bdfaf0c2..ddbf080e4f55 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -357,6 +357,25 @@ static bool kvm_has_full_ptr_auth(void)
>>           (apa + api + apa3) == 1);
>>   }
>>   +static bool kvm_realm_ext_allowed(long ext)
>> +{
>> +    switch (ext) {
>> +    case KVM_CAP_IRQCHIP:
>> +    case KVM_CAP_ARM_PSCI:
>> +    case KVM_CAP_ARM_PSCI_0_2:
>> +    case KVM_CAP_NR_VCPUS:
>> +    case KVM_CAP_MAX_VCPUS:
>> +    case KVM_CAP_MAX_VCPU_ID:
>> +    case KVM_CAP_MSI_DEVID:
>> +    case KVM_CAP_ARM_VM_IPA_SIZE:
>> +    case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>> +    case KVM_CAP_ARM_PTRAUTH_GENERIC:
>> +    case KVM_CAP_ARM_RMI:
>> +        return true;
>> +    }
>> +    return false;
>> +}
>> +
>>   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   {
>>       int r;
>> @@ -364,6 +383,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>       if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, ext))
>>           return 0;
>>   +    if (kvm && kvm_is_realm(kvm) && !kvm_realm_ext_allowed(ext))
>> +        return 0;
>> +
> 
> We need a similar check in in kvm_vm_ioctl_enable_cap() to prevent
> enabling the filtered caps ? Otherwise looks good to me.

Indeed - thanks for spotting.

Thanks,
Steve

> Suzuki
> 
>>       switch (ext) {
>>       case KVM_CAP_IRQCHIP:
>>           r = vgic_present;
> 

