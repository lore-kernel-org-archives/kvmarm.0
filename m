Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33852F6160
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783870; cv=none; b=hGYhnxRkQhsG4x9hNMF1/WGNDRYthwBD9v9IPXuwaBWgIYE6wrmqgtYTwonipVQc4bjY9C9nCYCkdbBfxxVU6dc/bQO8RXSEnIuW4LrdZVhTFQfwvf2S1id0zIT9szx2S5qXe/Tlw104xDgECXPJrcKA4KBzySxYwNi3W5QIbmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783870; c=relaxed/simple;
	bh=dJoM8OOMt6arEJ9uw1r81fXCakiPDHhaniul2hBPWEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NuD8f0tMG0C34uGuTcC0u8IqmslG+G4l63YC7l7HUxj9paF4b4ZopxXcB8OXTvXcJ6Jsd/c/5cXH5K244n7iSMdN7MB2nLw0Hbyo+ttW68NuDhpq6Niblj6S+mr7/SdJsO/koyC5MPG7kDaw9kG1NgmCHhtN1FEvj7V9Kbjvw+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E77CD152B;
	Thu, 21 Aug 2025 06:44:19 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FB583F59E;
	Thu, 21 Aug 2025 06:44:26 -0700 (PDT)
Message-ID: <56e049d4-dc15-40e0-a3ba-62d45678780d@arm.com>
Date: Thu, 21 Aug 2025 14:44:25 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] KVM: arm64: Handle RASv1p1 registers
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Cornelia Huck <cohuck@redhat.com>
References: <20250817202158.395078-1-maz@kernel.org>
 <20250817202158.395078-3-maz@kernel.org>
 <95819606-ef3b-46e1-8201-1abf0219659f@arm.com> <87ect4kd7a.wl-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <87ect4kd7a.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 8/21/25 14:37, Marc Zyngier wrote:
> On Thu, 21 Aug 2025 14:13:52 +0100,
> Ben Horgan <ben.horgan@arm.com> wrote:
>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 82ffb3b3b3cf7..feb1a7a708e25 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -2697,6 +2697,18 @@ static bool access_ras(struct kvm_vcpu *vcpu,
>>>   	struct kvm *kvm = vcpu->kvm;
>>>     	switch(reg_to_encoding(r)) {
>>> +	case SYS_ERXPFGCDN_EL1:
>>> +	case SYS_ERXPFGCTL_EL1:
>>> +	case SYS_ERXPFGF_EL1:
>>> +	case SYS_ERXMISC2_EL1:
>>> +	case SYS_ERXMISC3_EL1:
>>> +		if (!(kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1) ||
>>> +		      (kvm_has_feat_enum(kvm, ID_AA64PFR0_EL1, RAS, IMP) &&
>>> +		       kvm_has_feat(kvm, ID_AA64PFR1_EL1, RAS_frac, RASv1p1)))) {
>>> +			kvm_inject_undefined(vcpu);
>>> +			return false;
>>> +		}
>>> +		break;
>>>   	default:
>>>   		if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
>>>   			kvm_inject_undefined(vcpu);
>> The default condition needs updating for the case when
>> ID_AA64PFR0_EL1.RAS = b10 otherwise access to the non-v1 specific RAS
>> registers will result in an UNDEF being injected.
> 
> I don't think so. The RAS field is described as such:
> 
> 	UnsignedEnum    31:28   RAS
> 	        0b0000  NI
>         	0b0001  IMP
> 	        0b0010  V1P1
> 	        0b0011  V2
> 	EndEnum
> 
> Since this is an unsigned enum, this checks for a value < IMP. Only
> RAS not being implemented is this condition satisfied, and an UNDEF
> injected.
> 
> Or am I missing something obvious here (I wouldn't be surprised...)?

No, you are indeed correct. I missed the difference between
kvm_has_feat_enum() and kvm_has_feat(). Sorry for the noise.

> 
> 	M.
> 

-- 
Thanks,

Ben

