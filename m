Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0AAA3AEF20;
	Wed, 15 Jul 2026 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132583; cv=none; b=YWOOmtmkD43jAmR/Tb2BfHFoty1k6U9mqcocQm9c7efqwk9z0xZD+e/nPn1cpLPOas0bB2n8cm8lfygRIbKMFtVpqPjuIUE0bEW7WiXEJmRqzmyhDxu1BhBvKoufCVz+pxnjpi6ffa9+9HewMN8MEpkt8/LRRMfQNE3QIw0TdZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132583; c=relaxed/simple;
	bh=dg77XYklUbXh45Il0P/FqtiHFSzucVJ/8GhQ8vvAZAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qS9lrG28YFTE+fKyG2WEPMBNfbBUzttOFsX3/5T+mEMPrZKdh2oT+HGMkI0A4cfgvGiEAv8BL36I0xAFDlZJQb7dxrP7n7BzQqPLxNLrVJgTQkp9DylkeJOJxDbdNtLrpQgA9rAsuUG6gGLKxyAv7U8f7ZRZ90X+4KjTF8AJa/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jnIcFnKk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jnIcFnKk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB73F1477;
	Wed, 15 Jul 2026 09:22:55 -0700 (PDT)
Received: from [10.1.25.27] (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F1FC3F7B4;
	Wed, 15 Jul 2026 09:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784132580; bh=dg77XYklUbXh45Il0P/FqtiHFSzucVJ/8GhQ8vvAZAw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jnIcFnKknQfFhH/ZSe16W7ygZ9aJlcMZzJmgb3/8BP5WJF38k0YQoe95evutPHZCY
	 wtUNge/F7+Qy/lksFoWFKTY9/JKrf9epMGp7oRwIUwWJ0gGWRvpL9pVmGLNcqUrn0X
	 oRgyjpzuCWM/MidzjoMBBdY108Dll4cKxIVKehFg=
Message-ID: <ca802162-43b7-478f-9d12-ee7bdc4c2088@arm.com>
Date: Wed, 15 Jul 2026 17:22:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 02/37] KVM: arm64: Avoid including linux/kvm_host.h in
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
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-3-steven.price@arm.com> <871pd45jmn.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <871pd45jmn.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/07/2026 16:59, Marc Zyngier wrote:
> On Wed, 15 Jul 2026 15:28:04 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> To avoid future include cycles, drop the linux/kvm_host.h include in
>> kvm_pgtable.h and include the lightweight headers required for the types and
>> inline helpers used there. Additionally provide a forward declaration for
>> struct kvm_s2_mmu as it's only used as a pointer in this file.
>>
>> Both pgtable.c and kvm_pkvm.h relied on the indirect inclusion of
>> kvm_host.h, so make that explicit.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch in v13
>> ---
>>  arch/arm64/include/asm/kvm_pgtable.h | 6 +++++-
>>  arch/arm64/include/asm/kvm_pkvm.h    | 2 +-
>>  arch/arm64/kvm/hyp/pgtable.c         | 1 +
>>  3 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index 41a8687938eb..c2e4b29e605f 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -8,9 +8,13 @@
>>  #define __ARM64_KVM_PGTABLE_H__
>>  
>>  #include <linux/bits.h>
>> -#include <linux/kvm_host.h>
>> +#include <linux/kvm_types.h>
>> +#include <linux/rbtree_types.h>
>> +#include <linux/rcupdate.h>
>>  #include <linux/types.h>
>>  
>> +struct kvm_s2_mmu;
>> +
>>  #define KVM_PGTABLE_FIRST_LEVEL		-1
>>  #define KVM_PGTABLE_LAST_LEVEL		3
>>  
>> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
>> index 74fedd9c5ff0..a0f7a699d690 100644
>> --- a/arch/arm64/include/asm/kvm_pkvm.h
>> +++ b/arch/arm64/include/asm/kvm_pkvm.h
>> @@ -9,7 +9,7 @@
>>  #include <linux/arm_ffa.h>
>>  #include <linux/memblock.h>
>>  #include <linux/scatterlist.h>
>> -#include <asm/kvm_host.h>
>> +#include <linux/kvm_host.h>
> 
> nit: please keep the include directives in alphabetical order.

Ack.

Thanks,
Steve

> 	M.
> 

