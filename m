Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6893F3BB9EE
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279892; cv=none; b=LRO/nwWM9Mp53xSfOUkCE65LLD9N4egOxi0TAD8Evl3l9QhTik/noZoZ4iGfUdJ74sPSi5WWw1rrr6les53JFG9bx1JKAhmrY/XLYjVZ+Nzh3nZeKSt6KUXU47E68OX2L3ub/f1fdeqgQlpBlaGFLy9o4nEAI8KbXd7htSaEHSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279892; c=relaxed/simple;
	bh=So4tW2iTltCRNMM/xapQFRULY+mcrXmEfStcZS1JCPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iy2kc8es9ZdWLez3ajCelOAds6iqE5u0vldo/Tyh+9XVelYr7i1/VD4MFcojgy7MLT57OGVnFcQkiSgPoVSB/X1s+ETwYdSE6/LeWKMkXnwZolC0Cbe6HO5V0iNbXBejQgeALLkU5M6EvirAD+lKO5Dm/8pyFsalh9iGd/Be7mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4D6214BF;
	Mon, 23 Mar 2026 08:31:24 -0700 (PDT)
Received: from [192.168.178.23] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7AF243F694;
	Mon, 23 Mar 2026 08:31:29 -0700 (PDT)
Message-ID: <703ba291-aa21-46ec-8ba1-6b18a133bf9e@arm.com>
Date: Mon, 23 Mar 2026 16:31:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v6 6/6] arm64: Handle virtio endianness reset when
 running nested
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Sascha Bischoff <Sascha.Bischoff@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>
References: <20260211131249.399019-1-andre.przywara@arm.com>
 <20260211131249.399019-7-andre.przywara@arm.com>
 <86ms1fbcfq.wl-maz@kernel.org>
Content-Language: en-US
From: Andre Przywara <andre.przywara@arm.com>
In-Reply-To: <86ms1fbcfq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 2/11/26 15:08, Marc Zyngier wrote:
> On Wed, 11 Feb 2026 13:12:49 +0000,
> Andre Przywara <andre.przywara@arm.com> wrote:
>>
>> From: Marc Zyngier <maz@kernel.org>
>>
>> When running an EL2 guest, we need to make sure we don't sample
>> SCTLR_EL1 to work out the virtio endianness, as this is likely
>> to be a bit random.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>   arm64/include/kvm/kvm-cpu-arch.h |  5 ++--
>>   arm64/kvm-cpu.c                  | 47 +++++++++++++++++++++++++-------
>>   2 files changed, 40 insertions(+), 12 deletions(-)
>>
>> diff --git a/arm64/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
>> index 1af394a..85646ad 100644
>> --- a/arm64/include/kvm/kvm-cpu-arch.h
>> +++ b/arm64/include/kvm/kvm-cpu-arch.h
>> @@ -10,8 +10,9 @@
>>   #define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
>>   #define ARM_CPU_ID		3, 0, 0, 0
>>   #define ARM_CPU_ID_MPIDR	5
>> -#define ARM_CPU_CTRL		3, 0, 1, 0
>> -#define ARM_CPU_CTRL_SCTLR_EL1	0
>> +#define SYS_SCTLR_EL1		3, 4, 1, 0, 0
>> +#define SYS_SCTLR_EL2		3, 4, 1, 0, 0
> 
> Sascha pointed out this howler of a bug last time: SCTLR_EL1 and EL2
> have the same encoding here, which is obviously wrong.

Argh, indeed, I now remember, this was probably in the category of 
"that's a no brainer, what's next ..." so I missed actually fixing it.
Done now, apologies for that.

> 
> This is definitely introducing a regression on EL1 guests.
> 
>> +#define SYS_HCR_EL2		3, 4, 1, 1, 0
>>   
>>   struct kvm_cpu {
>>   	pthread_t	thread;
>> diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
>> index 5e4f3a7..35e1c63 100644
>> --- a/arm64/kvm-cpu.c
>> +++ b/arm64/kvm-cpu.c
>> @@ -12,6 +12,7 @@
>>   
>>   #define SCTLR_EL1_E0E_MASK	(1 << 24)
>>   #define SCTLR_EL1_EE_MASK	(1 << 25)
>> +#define HCR_EL2_TGE		(1 << 27)
>>   
>>   static int debug_fd;
>>   
>> @@ -408,7 +409,8 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
>>   {
>>   	struct kvm_one_reg reg;
>>   	u64 psr;
>> -	u64 sctlr;
>> +	u64 sctlr, bit;
>> +	u64 hcr = 0;
>>   
>>   	/*
>>   	 * Quoting the definition given by Peter Maydell:
>> @@ -419,8 +421,9 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
>>   	 * We first check for an AArch32 guest: its endianness can
>>   	 * change when using SETEND, which affects the CPSR.E bit.
>>   	 *
>> -	 * If we're AArch64, use SCTLR_EL1.E0E if access comes from
>> -	 * EL0, and SCTLR_EL1.EE if access comes from EL1.
>> +	 * If we're AArch64, determine which SCTLR register to use,
>> +	 * depending on NV being used or not. Then use either the E0E
>> +	 * bit for EL0, or the EE bit for EL1/EL2.
>>   	 */
>>   	reg.id = ARM64_CORE_REG(regs.pstate);
>>   	reg.addr = (u64)&psr;
>> @@ -430,16 +433,40 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
>>   	if (psr & PSR_MODE32_BIT)
>>   		return (psr & COMPAT_PSR_E_BIT) ? VIRTIO_ENDIAN_BE : VIRTIO_ENDIAN_LE;
>>   
>> -	reg.id = ARM64_SYS_REG(ARM_CPU_CTRL, ARM_CPU_CTRL_SCTLR_EL1);
>> +	if (vcpu->kvm->cfg.arch.nested_virt) {
>> +		reg.id = ARM64_SYS_REG(SYS_HCR_EL2);
>> +		reg.addr = (u64)&hcr;
>> +		if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
>> +			die("KVM_GET_ONE_REG failed (HCR_EL2)");
>> +	}
>> +
>> +	switch (psr & PSR_MODE_MASK) {
>> +	case PSR_MODE_EL0t:
>> +		if (hcr & HCR_EL2_TGE)
>> +			reg.id = ARM64_SYS_REG(SYS_SCTLR_EL2);
>> +		else
>> +			reg.id = ARM64_SYS_REG(SYS_SCTLR_EL1);
>> +		bit = SCTLR_EL1_E0E_MASK;
>> +		break;
> 
> And this is also buggy, as I pointed out in my review of v5 -- I even
> provided a fix for it [1].

Right, applied now.
v7 incoming.

Cheers,
Andre

> 
> 	M.
> 
> [1] https://lore.kernel.org/all/86jyx8b9l2.wl-maz@kernel.org/
> 

