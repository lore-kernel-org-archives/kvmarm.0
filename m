Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349C85437F5;
	Wed,  9 Sep 2026 11:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788953059; cv=none; b=CDf+b6GGwfEzyG1aA/UbF5RLzwALngtEQNAm3/4ITA3nocKknHobhGSuMEdLk9iaH7QM5mXhBO2HLDMWfqT0LjQ6bDxVrm0Hf70YStGA3jUTJjJkJwQ32Gnq/Md8DphXIxoMuIvur1yGyNi2p3NM+eRJuICN22PhiU9nrVST6xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788953059; c=relaxed/simple;
	bh=y74L0DLhbdt+Ower+oXr1Vl+Ik+e0ELSA4xWXm212qs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TwO3Wt6QJAi9JMxgXOtSaaiWEGB6mWxkGdO7YETieY0WI4P9MNQDTyqf4hbYemGzmGoDPJ9Aegp6GUkPGLaaeBoT1ncgcWLeIdVqZRTuVEuzCPd7x2dGrsEEKmyZPP7b6w0BfgNtSt7syDp0he+1dAGle5UwWy9JIThVDAjL7gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XNqERASC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XNqERASC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B23621691;
	Wed,  9 Sep 2026 04:24:10 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F8C13F528;
	Wed,  9 Sep 2026 04:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788953054; bh=y74L0DLhbdt+Ower+oXr1Vl+Ik+e0ELSA4xWXm212qs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XNqERASChp/Zp7Dp+uULGdCu5WA7QNGKEVyJWabIpdbt8Y78BBxn4OORUFIRldKuI
	 1cu+VTjUhYFKXb/5zHsKA3zVVIKksgKzB2m/zOGShHJqd4k8sZxmp2/sZBRIhZECs5
	 68eDhqzMxdiHZM71Q3QwzE6Oz5yh79foLy6c1Zxk=
Message-ID: <6c899477-40a9-443b-8f0a-0fb85beca3b3@arm.com>
Date: Wed, 9 Sep 2026 12:24:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 02/20] KVM: arm64: Avoid including linux/kvm_host.h in
 kvm_pgtable.h
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-3-suzuki.poulose@arm.com>
 <CA+EHjTzGeHCWV=ooEv-P79NNqTDi-A+7y5BFvZRR0z8RwavoeA@mail.gmail.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTzGeHCWV=ooEv-P79NNqTDi-A+7y5BFvZRR0z8RwavoeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/09/2026 12:22, Fuad Tabba wrote:
> On Tue, 8 Sept 2026 at 17:22, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> From: Steven Price <steven.price@arm.com>
>>
>> To avoid future include cycles, drop the linux/kvm_host.h include in
>> kvm_pgtable.h and include the lightweight headers required for the types
>> and inline helpers used there. Additionally provide a forward
>> declaration for struct kvm_s2_mmu as it's only used as a pointer in this
>> file.
>>
>> Both pgtable.c and kvm_pkvm.h relied on the indirect inclusion of
>> kvm_host.h, so make that explicit.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch in v13
> 
> Is this meant to be here (the "New in patch 13")?

Just trying to carry the legacy, but yes, you're right. I could remove
it. v13, is so ancient now :-)


> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers
Suzuki


> 
> Cheers,
> /fuad
> 
> 
>> ---
>>   arch/arm64/include/asm/kvm_pgtable.h | 6 +++++-
>>   arch/arm64/include/asm/kvm_pkvm.h    | 2 +-
>>   arch/arm64/kvm/hyp/pgtable.c         | 1 +
>>   3 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index 41a8687938eb6..c2e4b29e605fc 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -8,9 +8,13 @@
>>   #define __ARM64_KVM_PGTABLE_H__
>>
>>   #include <linux/bits.h>
>> -#include <linux/kvm_host.h>
>> +#include <linux/kvm_types.h>
>> +#include <linux/rbtree_types.h>
>> +#include <linux/rcupdate.h>
>>   #include <linux/types.h>
>>
>> +struct kvm_s2_mmu;
>> +
>>   #define KVM_PGTABLE_FIRST_LEVEL                -1
>>   #define KVM_PGTABLE_LAST_LEVEL         3
>>
>> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
>> index beea00e693a0a..54a618d887fa4 100644
>> --- a/arch/arm64/include/asm/kvm_pkvm.h
>> +++ b/arch/arm64/include/asm/kvm_pkvm.h
>> @@ -7,9 +7,9 @@
>>   #define __ARM64_KVM_PKVM_H__
>>
>>   #include <linux/arm_ffa.h>
>> +#include <linux/kvm_host.h>
>>   #include <linux/memblock.h>
>>   #include <linux/scatterlist.h>
>> -#include <asm/kvm_host.h>
>>   #include <asm/kvm_pgtable.h>
>>
>>   /* Maximum number of VMs that can co-exist under pKVM. */
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index b74dd5ce1efd3..f48253b9d88b5 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -8,6 +8,7 @@
>>    */
>>
>>   #include <linux/bitfield.h>
>> +#include <linux/kvm_host.h>
>>   #include <asm/kvm_pgtable.h>
>>   #include <asm/stage2_pgtable.h>
>>
>> --
>> 2.43.0
>>

