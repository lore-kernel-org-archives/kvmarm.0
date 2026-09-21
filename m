Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 173EF435534;
	Mon, 21 Sep 2026 08:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979161; cv=none; b=oLbcduPIaMkFD8tSCx41UDXIBI3aWyCDKlNjkfw1RIg+4V7SLnKk2ZNpUekatNIWs/HVJF0WwDGtAkNpx4VnT4ACIj0fcqDBx+JJxKy0fZYY8KAmrQ0palvom5ZwixE1bDSlHMLZGGgMI6OuDXaE6c85V+xu5hy7i6ov4y378HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979161; c=relaxed/simple;
	bh=F1GKTSeiXUlVKUqp6Q9vbjS3Uc0l15djbdskeSwtJ8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nbOF4go6t89biobsRqTos7gRSk4ilKosKSrfkeXHaQd0i8zefwCgT0j8L0j+/oUP0ouUV29DSzzK3XFralLmIRWkv0BbTtUJQ/hcfEcL4J54aHDPacpJ4o5+XaDgecNNUZ7BCwnYU0GnFeYVrls4MDHHgEG38ArtZl90wDsXoYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NNVG8xH8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NNVG8xH8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5A39175A;
	Mon, 21 Sep 2026 01:25:55 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B310C3F86C;
	Mon, 21 Sep 2026 01:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789979159; bh=F1GKTSeiXUlVKUqp6Q9vbjS3Uc0l15djbdskeSwtJ8o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NNVG8xH8uIPDUSe+4naNYfDrbMDxp8vOA8HUE2QGmkD02mvNYAA5fVFPX2u79DnLh
	 h697MIA1jxCiEenfQ+B6shQTbUm1DbfQmyRz2TA70GVrRCyM4pDBImkPaYUMSdBvhP
	 fPKczP7rlOeCj806PQtvnxAWyAZKfTd2dg7CQs4M=
Message-ID: <069ad06f-9e73-4160-b48e-823b3e88f5e4@arm.com>
Date: Mon, 21 Sep 2026 09:25:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 04/20] KVM: arm64: Avoid including linux/kvm_host.h in
 kvm_pgtable.h
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-5-suzuki.poulose@arm.com>
 <20260920213838.EDD9B1F00893@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260920213838.EDD9B1F00893@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/09/2026 22:38, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] kvm: missing includes in kvm_pgtable.h for FIELD_GET and others
> --
> 
> commit 0c7ef6102444f8add04f2e7e4854a331850bf438
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
> 
> This commit drops the linux/kvm_host.h include from kvm_pgtable.h to avoid
> future include cycles. It replaces it with lightweight headers for types
> and a forward declaration for struct kvm_s2_mmu, while making the dependency
> on kvm_host.h explicit in pgtable.c and kvm_pkvm.h.
> 
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
> 
> [Severity: Low]
> Does removing linux/kvm_host.h leave some macros used later in this header
> without their explicit includes?
> 
> For example, in kvm_get_parange_max(), the code relies on PAGE_SHIFT:
> 
>      if (kvm_lpa2_is_enabled() ||
>             (IS_ENABLED(CONFIG_ARM64_PA_BITS_52) && PAGE_SHIFT == 16))
> 
> In kvm_pte_to_phys(), the code relies on FIELD_GET:
> 
>      pa |= FIELD_GET(KVM_PTE_ADDR_51_50_LPA2, pte) << 50;
> 
> And in kvm_pte_to_pfn(), it uses __phys_to_pfn:
> 
>      return __phys_to_pfn(kvm_pte_to_phys(pte));
> 
> Should this file explicitly include <linux/bitfield.h>, <asm/page.h>, and
> <asm/memory.h> to prevent build fragilities when it is included in an
> isolated compilation unit?
> 

I have added these changes to the header files and built the kvm 
integration branch. So I will pick these suggestions.

Cheers
Suzuki


> [ ... ]
> 

