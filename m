Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6A13290AA;
	Thu, 21 May 2026 15:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779376278; cv=none; b=SKhBaRL11wTuHKnmTvMA3+nU3ODM1xBcSFfEXWCZeyzRsTJIc2sRoSE5YiUSKz8XPWs4N3hbgojWpl8gwClwnKJKGw/+h+jN7ZpfADWMn7FZucqcSxum5Os+3SkD5EflUda/JqXDjRJ8r0hgl/dNTJH8/vCfigDPEog5Omj9G3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779376278; c=relaxed/simple;
	bh=17SV5z5QGm0EPYvenc3ZyU1VB2Jpu5XaWYSZ8c+4UfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tOrBHC9e5mTwG6FVchhCaIvdRw55xmraNOSRFuCnJFty8Wv3bnjBt4819PhkPyP6Dz2INLpaPDTycvxH0PiD4D7+1imQoIRoDve2g0p7t1lnqeOAkIrhOOc/oZUbuvOvvVz5tFnF57FRfOT/rWFE/f5JmkmHisPjEs3FnOsi2Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q1fQaVqG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q1fQaVqG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9E3D3D45;
	Thu, 21 May 2026 08:11:10 -0700 (PDT)
Received: from [10.1.32.22] (e122027.cambridge.arm.com [10.1.32.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE6733F7B4;
	Thu, 21 May 2026 08:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779376275; bh=17SV5z5QGm0EPYvenc3ZyU1VB2Jpu5XaWYSZ8c+4UfI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q1fQaVqG1pgFhZuo/6+BbaCC5IHBqImNA7lInXrGxB8wBvwLmnlLQ4tqvV7BLJHNE
	 6qi1FGOJ5WLVEoMHlJxEy4ojbou8VB09apk1qIMu3NRf2grUfkrS4RVwe+TcJ9FkH6
	 HdytOzUEdPW3q554cDTWtfOGg391lFP/6QYGk71A=
Message-ID: <0ab59213-6bad-4062-a2b8-84fb2120f45d@arm.com>
Date: Thu, 21 May 2026 16:11:04 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 02/44] kvm: arm64: Avoid including linux/kvm_host.h in
 kvm_pgtable.h
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-3-steven.price@arm.com> <86ik8hvz2f.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86ik8hvz2f.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/05/2026 11:26, Marc Zyngier wrote:
> On Wed, 13 May 2026 14:17:10 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> To avoid future include cycles, drop the linux/kvm_host.h include in
>> kvm_pgtable.h and include two _types.h headers for the types that are
>> actually used. Additionally provide a forward declaration for struct
>> kvm_s2_mmu as it's only used as a pointer in this file.
>>
>> Both pgtable.c and kvm_pkvm.h relied on the indirect inclusion of
>> kvm_host.h, so make that explicit.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch in v13
>> ---
>>  arch/arm64/include/asm/kvm_pgtable.h | 5 ++++-
>>  arch/arm64/include/asm/kvm_pkvm.h    | 2 +-
>>  arch/arm64/kvm/hyp/pgtable.c         | 1 +
>>  3 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index 41a8687938eb..e4770ce2ccf6 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -8,9 +8,12 @@
>>  #define __ARM64_KVM_PGTABLE_H__
>>  
>>  #include <linux/bits.h>
>> -#include <linux/kvm_host.h>
>> +#include <linux/kvm_types.h>
>> +#include <linux/rbtree_types.h>
> 
> I'm surprised by this. Where is the rbtree_type.h requirement coming
> from?

struct kvm_pgtable has a "struct rb_root_cached" for pkvm_mappings.
There's definitely an argument that that's a bit ugly - but this seemed
the cleanest fix from a include perspective.

Thanks,
Steve

> 
> Thanks,
> 
> 	M.
> 

