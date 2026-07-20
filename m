Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789113D300D
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 09:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538628; cv=none; b=CKyElCDqIX3uP3qd4yltkN1eFfZa0FJp1HxupwVcyuchI/SyrUeY2SvnP/00bhG6aBveRibmM8FO2RyJ+vrViXQzSvPOqa2X4sk9bkGzEIUiTFB+dOxhC343+iGC67ELrm0QC2y/rZgbL8o1Kd/br72sEE3gGrTObt/NGSo3YE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538628; c=relaxed/simple;
	bh=UlymmXv5O50hqNpgc22rBOAaQC6RejWBv57yspEHDBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=utRevB1Rv6eArRGLe6pzEhk5DAk0tAHMFt0C53SI31FJIQWJcNgJNEnBVzbzcYilFLKKQWn8pP0lbsWYtqkAtSRxSz0TYH2ryOKNrjL/uDbAYOl9nXi6uZNTB+/Bl41FmQLa++psxnn+Y2metPIitOCFqDDIH72FntSIvEcc4xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OJsRm18A; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OJsRm18A"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95B242B;
	Mon, 20 Jul 2026 02:10:21 -0700 (PDT)
Received: from [10.164.19.57] (unknown [10.164.19.57])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB0A63F86F;
	Mon, 20 Jul 2026 02:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784538625; bh=UlymmXv5O50hqNpgc22rBOAaQC6RejWBv57yspEHDBs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OJsRm18AeNkXZJo3jbFuyTjOn5r8W3CeHjdK2jeME3loZaeVu6UivvZnY1ulkiEc6
	 jDMYcwEhD71Qsi81IIYGJ7Kc3HHSkPnbvAON+Sq3Ao8FFZQMitITksOkMe8kYfo0TV
	 3TsrCcuWVZ4vvGfo+Rc+VM2SiUBMfceWulUh8o6A=
Message-ID: <4a598a6c-496f-441c-b268-a725f9ee8090@arm.com>
Date: Mon, 20 Jul 2026 14:40:18 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: ptdump: Flush the last region
To: Marc Zyngier <maz@kernel.org>
Cc: Wei-Lin Chang <weilin.chang@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Sebastian Ene <sebastianene@google.com>,
 Vincent Donnefort <vdonnefort@google.com>
References: <20260717231233.2299068-1-weilin.chang@arm.com>
 <ad52d1ee-04cb-42d7-b50c-dfb3d28db5df@arm.com> <868q76f2wy.wl-maz@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <868q76f2wy.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 20/07/26 2:33 pm, Marc Zyngier wrote:
> On Mon, 20 Jul 2026 09:53:29 +0100,
> Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 18/07/26 4:42 am, Wei-Lin Chang wrote:
>>> Currently the stage-2 ptdump calls note_page() at each leaf entry visit.
>>> This simply misses the output of the last region, because note_page()
>>> only dumps output when it detects a change in level/prot, or when the
>>> walk enters a next marker section. The last region in the guest IPA
>>> space with the same level/prot is not dumped since there is no change
>>> after it.
>>>
>>> To dump the final region, manually issue a note_page() call with address
>>> BIT(ia_bits) (end of guest IPA space) and level == -1 to trigger a level
>>> change after the last region. Additionally treat level == -1 as a last
>>> flushing note_page() call and avoid dumping the name of the next marker
>>> for this case.
>>>
>>> Fixes: 7c4f73548ed1 ("KVM: arm64: Register ptdump with debugfs on guest creation")
>>> Reported-by: Sashiko AI <sashiko-bot@kernel.org>
>>> Closes: https://lore.kernel.org/kvmarm/20260630122758.891011F00A3A@smtp.kernel.org/
>>> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
>>> ---
>>>  arch/arm64/kvm/ptdump.c | 8 +++++---
>>>  arch/arm64/mm/ptdump.c  | 5 +++--
>>>  2 files changed, 8 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
>>> index c9140e22abcf..4096e4a92fae 100644
>>> --- a/arch/arm64/kvm/ptdump.c
>>> +++ b/arch/arm64/kvm/ptdump.c
>>> @@ -155,11 +155,13 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
>>>  		.seq		= m,
>>>  	};
>>>  
>>> -	write_lock(&kvm->mmu_lock);
>>> +	guard(write_lock)(&kvm->mmu_lock);
>>
>> The guard clause change has nothing to do with the fix I think? Although the change
>> is small and the fix is for a recent commit so maybe we don't care having this
>> in the same patch - not sure how strict kvm reviewers are about this : )
>>
> 
> Look at the quality spaghetti code this would otherwise result in:
> 
> 	write_lock();
> 	ret = kvm_pgtable_walk();
> 	if (ret) {
> 		write_unlock();
> 		return ret;
> 	}
> 	note_page_flush();
> 	write_unlock();
> 
> 	return 0;
> 
> How is that better? So it has *everything* to do with the fix.
> 
> And FWIW, the policy for KVM is that we don't do lock->guard
> conversions as a separate patches. Only when we need to change the
> code, and as part of the patch that changes that code.  Which is
> exactly what is happening here.

I agree, thanks.


> 
>>
>>>  	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
>>> -	write_unlock(&kvm->mmu_lock);
>>> +	if (ret)
>>> +		return ret;
>>> +	note_page(&st->parser_state.ptdump, BIT(mmu->pgt->ia_bits), -1, 0);
>>>  
>>> -	return ret;
>>> +	return 0;
>>>  }
>>>  
>>>  static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
>>> diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
>>> index ab9899ca1e5f..fed4e4407e0e 100644
>>> --- a/arch/arm64/mm/ptdump.c
>>> +++ b/arch/arm64/mm/ptdump.c
>>> @@ -194,6 +194,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
>>>  	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
>>>  	struct ptdump_pg_level *pg_level = st->pg_level;
>>>  	static const char units[] = "KMGTPE";
>>> +	bool flush = level == -1;
>>
>> Can we do something similar to what S1 ptdump does (note_page_flush in ptdump_walk_pgd).
> 
> See Mark's email.
> 
> 	M.
> 

