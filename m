Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58C3340D81
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761817205; cv=none; b=HUyJi80EiBTs6Le2H2clt57dQWv2gxEO71QRfa6EbOCxeIKfnMHag9cq5Y4GpLfHiZbJe8kebcCWF7ZaLBuM87C631h7idWmKiydp4bkn5H7PU+YaItCfQ7SBuzZYzeNPrrgcG9QJrwCyMf/D1ZrcXyUq0x2Ja+LGfPYedCNA6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761817205; c=relaxed/simple;
	bh=J7vpmPrh2gMytn7a+gjFIJgRs7WpZP9xn/iSjhMYlow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uaAWnl/sHmA1mMlznTxF6AMqxWfBLSp9wqsOmTlmLYYuXCSXNAnhV+5iZxlB/+EQ2dSY1B2m7A3mSF7s+Sv34sL1Ma2eOgFUKmiAfwFxAsE+zy+2qTg1G4IadTDU1d7S8lBJsWNSVo2YzkjCWLW43fowWE0IP2Og/nRNJKih/1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B2101063;
	Thu, 30 Oct 2025 02:39:55 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABE833F673;
	Thu, 30 Oct 2025 02:40:01 -0700 (PDT)
Message-ID: <bec72117-93f1-490e-bc35-0ab247aaed1c@arm.com>
Date: Thu, 30 Oct 2025 09:40:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] KVM: arm64: selftests: Remove
 ARM64_FEATURE_FIELD_BITS and its last user
To: Oliver Upton <oliver.upton@linux.dev>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 shuah@kernel.org
References: <20251014102108.2442391-1-ben.horgan@arm.com>
 <20251014102108.2442391-3-ben.horgan@arm.com> <aQJ8so_oAXfeyxn_@linux.dev>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aQJ8so_oAXfeyxn_@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 10/29/25 20:45, Oliver Upton wrote:
> Hi Ben,
> 
> On Tue, Oct 14, 2025 at 11:21:07AM +0100, Ben Horgan wrote:
>> ARM64_FEATURE_FIELD_BITS is set to 4 but not all ID register fields are 4
>> bits. See for instance ID_AA64SMFR0_EL1. The last user of this define,
>> ARM64_FEATURE_FIELD_BITS, is the set_id_regs selftest. Its logic assumes
>> the fields aren't a single bits; assert that's the case and stop using the
>> define. As there are no more users, ARM64_FEATURE_FIELD_BITS is removed.
>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>>  arch/arm64/include/asm/sysreg.h                 | 2 --
>>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 8 ++++++--
>>  2 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 6455db1b54fd..d9aa76d08e13 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -1129,8 +1129,6 @@
>>  #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
>>  #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
>>  
>> -#define ARM64_FEATURE_FIELD_BITS	4
>> -
>>  #ifdef __ASSEMBLY__
>>  
>>  	.macro	mrs_s, rt, sreg
> 
> You can send this diff as a separate patch. Selftests actually uses the
> definition from tools/arch/arm64/include/asm/sysreg.h, so you'll want to
> drop that definition along with the change to set_id_regs.

Thanks for the pointers. I'll do as you suggest.

> 
> Thanks,
> Oliver
> 

-- 
Thanks,

Ben

