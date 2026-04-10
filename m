Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E523D9DCE;
	Fri, 10 Apr 2026 15:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775833943; cv=none; b=Zalv2Dle7N131Q4rHUFwbEfWCbyp69/xs9DzatvYq65x4add9JyGc5RtaklDh10RKkT/PJ2PfYlQFvZk6x86UHv5XSjY1xbb8/IFbqCcm0IncLoS+RLPUNxPzywkTZwWFwP5Oq71ELN2lrR2/c0wwKJZ/+UhLT/l/zkSC1WNPTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775833943; c=relaxed/simple;
	bh=Z3/vCYjcdpqPdGORHJhUiFd/20/A6QH4krFtsE3EYz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AnwkOFc4e7imKhc3T3d9Ghq3PhSyuRGiU2y4+Jd8eR+Z2OrYqfo7Y6Ue7Yobdp/UOnS/SpnmOb6TGkzzQQV13qYAkLgMa5B61MtPP/VP8Id6D2EXYmZBn+HsADdFc0/WK5LELuPdwdgCM2mWWHWB44I1LGkmttVFbDcqks6gle8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gTVVmSPS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gTVVmSPS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 362FD3543;
	Fri, 10 Apr 2026 08:12:15 -0700 (PDT)
Received: from [10.1.29.18] (e122027.cambridge.arm.com [10.1.29.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF6133FAA1;
	Fri, 10 Apr 2026 08:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775833940; bh=Z3/vCYjcdpqPdGORHJhUiFd/20/A6QH4krFtsE3EYz8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gTVVmSPSK8xsHhPN98jfG1N/gYPdZDSUhNH07m9nQWei/I+xKMJF8lQiV1AgubR7n
	 LvonLCsQ/nSrDlsw2B86r0pNNMLlBy36J63eESa7GLSbcDTaak4OTsi+pRa2YJ1XmC
	 G/Gy8PgjLP3Cd6yIj9pXwCgeEs0nvz6/piCJi0Tc=
Message-ID: <6f7c7d29-19ef-4d6e-8627-834b77202490@arm.com>
Date: Fri, 10 Apr 2026 16:12:15 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 32/48] arm64: Don't expose stolen time for realm
 guests
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
 <20260318155413.793430-33-steven.price@arm.com>
 <4a2ab5b0-dec6-4ee2-8790-f27c2501f653@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <4a2ab5b0-dec6-4ee2-8790-f27c2501f653@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 30/03/2026 11:52, Suzuki K Poulose wrote:
> On 18/03/2026 15:53, Steven Price wrote:
>> It doesn't make much sense as a realm guest wouldn't want to trust the
>> host. It will also need some extra work to ensure that KVM will only
>> attempt to write into a shared memory region. So for now just disable
>> it.
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v7:
>>   * Update the documentation to add a note about stolen time being
>>     unavailable in a realm.
>> ---
>>   Documentation/virt/kvm/api.rst | 3 +++
>>   arch/arm64/kvm/arm.c           | 5 ++++-
>>   2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/
>> api.rst
>> index bc180c853faf..70911fe6d435 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -9240,6 +9240,9 @@ is supported, than the other should as well and
>> vice versa.  For arm64
>>   see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
>>   For x86 see Documentation/virt/kvm/x86/msr.rst "MSR_KVM_STEAL_TIME".
>>   +Note that steal time accounting is not available when a guest is
>> running
>> +within a Arm CCA realm (machine type KVM_VM_TYPE_ARM_REALM).
>> +
>>   8.25 KVM_CAP_S390_DIAG318
>>   -------------------------
>>   diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 61182eb0cf70..7d92ddb06460 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -469,7 +469,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>           r = system_supports_mte();
>>           break;
>>       case KVM_CAP_STEAL_TIME:
>> -        r = kvm_arm_pvtime_supported();
>> +        if (kvm_is_realm(kvm))
>> +            r = 0;
>> +        else
>> +            r = kvm_arm_pvtime_supported();
> 
> Could this be handled in kvm_realm_ext_allowed() ?

Indeed it is already handled there. I'm not sure how I missed that, but
this patch is completely unnecessary now. Stolen time was an extension
that I knew about (having added it in the first place) and needed
disabling because it's implemented with the assumption that the host can
write into the guest.

In theory with some extra work it could be supported in a realm guest,
but it requires some extra plumbing to ensure the structures end up in
shared memory. My intention is that this can be revisited once the basic
CCA support is in.

Thanks,
Steve

> Suzuki
> 
> 
>>           break;
>>       case KVM_CAP_ARM_EL1_32BIT:
>>           r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
> 

