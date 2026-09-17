Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71495208CE;
	Thu, 17 Sep 2026 16:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663679; cv=none; b=JSRIIaMQZyUFrX47oYtV0zGbVBjdEc/cEP+mIs+JVv+tVtF2uzNj/Zg1iAPgjPDBS0TMiegOlcxW41L8mUnvCXDGsf8gFTrkwmaoTulHOM4LqYVafoMztckvoTKGHdRwc+b6o9GVOjYO77ZB0J5OLqbcYIjUsMmOI0E2bIu5dW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663679; c=relaxed/simple;
	bh=OVTdVYW4tByjiVxyCkYDgohXJD20Howf0MtVHvJ6joI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KFiZJawwQEL2xKI2qUQeIdZdjB856yBU0Q69Z1yAxwFi0cg2jM20+7+Kg0VJ4BuJCrx9FwsusLI57oadMl09T7zNTMG3xiCSwbKEhkW1OUG8iyFsVUPGIK6hKbnE1d+F49XCTl62DRMPoi0SysYh/ftj0CXQiziIUQMM/lYZESk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CH5gFber; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CH5gFber"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 922AE143D;
	Thu, 17 Sep 2026 09:47:53 -0700 (PDT)
Received: from [10.57.6.197] (unknown [10.57.6.197])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 363063F86F;
	Thu, 17 Sep 2026 09:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789663677; bh=OVTdVYW4tByjiVxyCkYDgohXJD20Howf0MtVHvJ6joI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CH5gFberx7XfLcBWrdd12V63FKFULCygnd+iN6kj21c1iX60i0RQgUrQDusLX1rO/
	 IfcdlzzsNuv+gxVhAuRFPn3N1a3z94Z40B3Zm8ua9Ub0KB+1voRiDzpJI/MNqBIWP3
	 P6YMK8IMn5yM1C/VhSlFo+js0w1pfmZTyp2pAbvo=
Message-ID: <d51bbcf4-f396-4009-994a-ef335d8963c8@arm.com>
Date: Thu, 17 Sep 2026 17:47:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 11/23] KVM: arm64: Use kvm_vm_is_unprotected() for
 !kvm_vm_is_protected()
Content-Language: en-GB
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-12-suzuki.poulose@arm.com>
 <CA+EHjTzOR7xczcb1HbUAi3H7K8ta=pFcdjxJb7UixZEh7QS-Eg@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTzOR7xczcb1HbUAi3H7K8ta=pFcdjxJb7UixZEh7QS-Eg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/09/2026 12:47, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Tue, 15 Sep 2026 17:01:29 +0100, Suzuki K Poulose
> <suzuki.poulose@arm.com> wrote:
> [...]
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> [...]
>> @@ -490,7 +490,7 @@ static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exception_index)
>>   {
>>           int exception_code = ARM_EXCEPTION_CODE(exception_index);
>>
>> -        if (!is_protected_kvm_enabled() || kvm_vm_is_protected(vcpu->kvm))
>> +        if (!kvm_vm_is_unprotected_pkvm(vcpu->kvm))
>>                   return;
> 
> Could the two pKVM-only helpers keep the static key in front? With
> `is_protected_kvm_enabled() &&` inside kvm_vm_is_unprotected_pkvm()
> and kvm_vm_is_protected_pkvm(), as kvm_vm_is_protected() had it before
> patch 5, the boot-patched branch skips the load again for every user.
> This runs on every exit: the old test is a cpucap, so on a host
> without pKVM the function returns straight away, while the new one
> loads vcpu->kvm->arch.vm_flavor on every host. The wide
> kvm_vm_is_protected() can't have it, since Realms run without pKVM.

Ack

Suzuki

> 
> Cheers,
> /fuad

