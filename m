Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D463D332A;
	Mon, 31 Aug 2026 09:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788167651; cv=none; b=eJAK3R6UTbnmGteOvdkxssryUvrAyGAnA5ARzXr68rtnQZHP9D39BpZ7p0lJdtFmRXFmqYzs+9yn0b1cOXAK4zxoWF1gqcy3Ntil3e4vCfbEGefsZ+duINhXPEnVHXRaWuBK5dHVtvsmn9AKcrh2cxI9prpZSwTwT63gttJO9fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788167651; c=relaxed/simple;
	bh=AL3uThcJdp1luInazQc89WPTodOGk0jyjbGK+aiLN1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hM3byyLNjSYR6N8mCxrZUQOxzwredkf5AlHsy74h+lAAsJxtuAn9PcUF57EBex1vq/jSOvX+6a8YW9EJQbYC8skKctFVgvdchH6Lj5txVrlX6erL81BBqUof1uVIu0As8JLuPwgcMoO2Qli5aPBh5zK/m7m+krnAYKdBJfoXW+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=z/4U/nCa; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="z/4U/nCa"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FJPAlOlKc9ifbkif/SfhhU/etW4EPFaF/p7I1hn+g2M=;
	b=z/4U/nCamBjuzIzDI9pRbf4YbTla5RlQMKjjEm4j/8FMFEjgrVipf68rV0O9YY1zt8CLdLZrH
	pmaQ86GrTF34ELHubMoW1nmkx1yTZxcAUmq/XoCJp9dFiPi5hIehmgo+Ddf28XJ9vGgfbMy9o7N
	LsOpdFOWUt+7QTeul2+BqlI=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hYNLv5mWxzcbPG;
	Mon, 31 Aug 2026 17:03:19 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id B50D740561;
	Mon, 31 Aug 2026 17:14:01 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 31 Aug 2026 17:14:01 +0800
Message-ID: <020f407d-5c28-4af7-b88a-3e80ce06ff1e@huawei.com>
Date: Mon, 31 Aug 2026 17:14:00 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware
 dirty tracking
To: <sashiko-reviews@lists.linux.dev>
CC: <kvmarm@lists.linux.dev>, Oliver Upton <oupton@kernel.org>, Marc Zyngier
	<maz@kernel.org>, <kvm@vger.kernel.org>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-4-zhengtian10@huawei.com>
 <20260709111420.CFCF01F00A3A@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260709111420.CFCF01F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 7/9/2026 7:14 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Critical] kvm_pgtable_stage2_wrprotect() fails to clear the DBM bit, allowing hardware to silently bypass KVM's dirty page tracking.
> - [Medium] VTCR_EL2.HD is never set, rendering the hardware auto-DBM feature inactive.
> - [Medium] DBM is never enabled for VMs running under protected KVM (pKVM) because the hypervisor initializes stage-2 page tables with flags=0.
> --
> 
> --- Patch [3]: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware dirty tracking ---
> commit abb55a98f1d8a61624044b5be480dccd88753db2
> Author: Tian Zheng <zhengtian10@huawei.com>
> KVM: arm64: Add auto DBM support for hardware dirty tracking
> 
> This patch introduces support for the ARMv8.1 Dirty Bit Modifier (DBM)
> attribute in KVM. It allows hardware to automatically promote write-clean
> pages to write-dirty without trapping to EL2. The DBM behavior is controlled
> via a new page-table level flag KVM_PGTABLE_S2_DBM.
> 
> [ ... ]
> 
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index 91a7dfad66866..21ec456ecc411 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -1367,9 +1381,26 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>>   	if (prot & KVM_PGTABLE_PROT_R)
>>   		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
>>   
>> -	if (prot & KVM_PGTABLE_PROT_W)
>> +	if (prot & KVM_PGTABLE_PROT_W) {
>>   		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>>   
>> +		/*
>> +		 * No DEVICE filter needed here: relax_perms is only called
>> +		 * on FSC_PERM faults. Device pages always get full RW from
>> +		 * initial mapping and are never write-protected during
>> +		 * migration, so they never trigger a permission fault.
>> +		 */
>> +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
>> +			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>> +	} else {
>> +		/*
>> +		 * Clear DBM on W→RO downgrade to prevent hardware from
>> +		 * silently upgrading RO+DBM back to W+dirty, which would
>> +		 * bypass KVM's write tracking and cause data corruption.
>> +		 */
>> +		clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>> +	}
> 
> [Severity: Critical]
> The commit message mentions clearing DBM on W->RO downgrade. Should this logic
> be in kvm_pgtable_stage2_wrprotect() instead?
> 
> kvm_pgtable_stage2_relax_perms() is used for resolving permission faults, not
> for bulk W->RO downgrades. Meanwhile, kvm_pgtable_stage2_wrprotect() clears
> the KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W bit but misses clearing the newly introduced
> DBM bit:
> 
> arch/arm64/kvm/hyp/pgtable.c:kvm_pgtable_stage2_wrprotect() {
>      ...
>      return stage2_update_leaf_attrs(pgt, addr, size, 0,
>                                      KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>                                      NULL, NULL,
>                                      KVM_PGTABLE_WALK_IGNORE_EAGAIN);
> }
> 
> If DBM remains set on a read-only PTE, won't hardware with HDBSS enabled
> automatically upgrade the PTE back to writable upon a guest write, bypassing
> the stage-2 permission fault and causing data corruption during live migration?
> 
> [ ... ]
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index e086c01a9325e..346efed6e6050 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1014,6 +1014,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>   	if (err)
>>   		goto out_free_pgtable;
>>   
>> +	if (system_supports_hdbss())
>> +		pgt->flags |= KVM_PGTABLE_S2_DBM;
>> +
> 

This is addressed in v5, but I want to clarify the logic:

The key distinction is between block entries (level <
KVM_PGTABLE_LAST_LEVEL) and level-3 pages:

- For block entries, we do strip DBM during write-protect. This ensures
lazy split triggers on the first write fault, as HDBSS only supports
page-granular tracking and cannot handle block-level hardware upgrades.

- For level-3 pages, we do not clear DBM. Clearing DBM would disable
hardware auto-dirtying, which defeats the purpose of HDBSS.

So in stage2_attr_walker(), the write-protect path now behaves as:

- Block entries -> RO (DBM=0, S2AP_W=0): forces fault to trigger split

- Level-3 pages -> WC (DBM=1, S2AP_W=0): re-arms HDBSS tracking on next
write

This preserves hardware dirty tracking for page-granular mappings while
ensuring blocks are properly split before any write is allowed.

> [Severity: Medium]
> Are we missing the corresponding VTCR_EL2.HD update?
> 
> The architectural requirement for the hardware to interpret the DBM bit is
> that VTCR_EL2.HD must be 1. kvm_get_vtcr() in arch/arm64/kvm/hyp/pgtable.c
> does not appear to include the VTCR_EL2_HD bit, which would mean VTCR_EL2.HD
> remains 0 and the hardware will ignore the DBM bit.
> 

False positive. kvm_arm_enable_hdbss_global() already set VTCR_EL2_HD
together with VTCR_EL2_HDBSS and VTCR_EL2_HA.

> [Severity: Medium]
> Also, does this logic properly enable DBM for protected VMs?
> 
> In pKVM mode, the host's pgt is merely a dummy structure. The actual stage-2
> page tables for protected VMs are initialized at EL2 via
> pkvm_guest_prepare_stage2() calling __kvm_pgtable_stage2_init() in
> arch/arm64/kvm/hyp/nvhe/mem_protect.c, which unconditionally passes 0 for the
> flags parameter. Will this cause KVM_PGTABLE_S2_DBM to be ignored in the
> actual page table used for pKVM?
> 
>>   	mmu->pgt = pgt;
>>   	if (is_protected_kvm_enabled())
>>   		return 0;
> 

In v5, KVM_PGTABLE_S2_DBM is removed and DBM is set unconditionally in
stage2_set_prot_attr(). pKVM support is out of scope for this series --
we target VHE only and leave pKVM as future work.

Thanks!
Tian


