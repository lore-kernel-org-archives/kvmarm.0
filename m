Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17AF1DF74F
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 02:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790737068; cv=none; b=VJnqDb9fRxhibCdNr2hyj6Wz1FdzYvFaNTGzpS5Uc7yrEIk9ZwcN39AuUmceP1howZ0VJnYdPImshvnZKY3x17BOxCAqZswuaKOIxihut9F4PtvpNky0JObMEdCqkd6G5G3uPQCkHuADdR6SrLHbSOPWRzuopUcslHRiindcSk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790737068; c=relaxed/simple;
	bh=rp/fa2uhrTfZKpBLhFbKPrXCvV6jaxnedczZC9x4sTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IV98XFSsrZfj/YjhIPkejd2O4wJjP+8YNaKBYRPGxrMptTXpBSbCeN26XdXSTSpUJvHleSr8eGANb25MbZtDdgIvaRxZ5F5N3z0+kKZuG8AmWpe0NLGWUfY/dx1hZUISEk8T54f0YiHR6W0J7YcRRIrYwYvRpjKTYUh5wAX0lo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0lCB/uTY; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0lCB/uTY"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PtER5Ch5agf7GPvfInLQseCkLl2+EkQBBEjndL6mdYQ=;
	b=0lCB/uTYB7aCqVXW8PztZKfAa6OWU4z20mzjITJY31WXWXn+VD/TqSvCecQB7sVmw+jJQIVui
	hZWRTNr3yQbyGvwMZDm2ugYfQfEhS9ZdVfmClIhd3W8zhgVxw49QnOf2Kgo3x1WzToQcZ3B6eIl
	uNIxfa8sIll7qx7Dp53RqAE=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hvfYB2Bznz1T4Lb;
	Wed, 30 Sep 2026 10:45:34 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 59FE94057D;
	Wed, 30 Sep 2026 10:57:35 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 30 Sep 2026 10:57:34 +0800
Message-ID: <ff218960-c412-4283-aa41-b7af2a7048b8@huawei.com>
Date: Wed, 30 Sep 2026 10:57:33 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/15] KVM: arm64: Add KVM_PGTABLE_PROT_DIRTY
To: Oliver Upton <oupton@kernel.org>
CC: <maz@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <leo.bras@arm.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>,
	<caijian11@h-partners.com>, <liuyonglong@huawei.com>,
	<tangchengchang@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>, <mark.rutland@arm.com>,
	<seanjc@google.com>, <rdunlap@infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <skhan@linuxfoundation.org>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-3-zhengtian10@huawei.com> <arxZQwkLCLBnITzH@kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <arxZQwkLCLBnITzH@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/30/2026 8:35 AM, Oliver Upton wrote:
> On Tue, Sep 29, 2026 at 06:36:42PM +0800, Tian Zheng wrote:
>> @@ -731,8 +731,12 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>>   	if (prot & KVM_PGTABLE_PROT_R)
>>   		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
>>
>> -	if (prot & KVM_PGTABLE_PROT_W)
>> -		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>> +	if (prot & KVM_PGTABLE_PROT_W) {
>> +		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>> +
>> +		if (prot & KVM_PGTABLE_PROT_DIRTY)
>> +			attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>> +	}
> 
> Can you introduce the dirty state first? You're temporarily setting
> DBM+S2AP[1] as a workaround in the preceding patch.
> 
> Then we can have it encoded such that when FEAT_HAFDBS is implemented:
> 
> 	KVM_PGTABLE_PROT_W	=> KVM_PTE_LEAF_ATTR_HI_S2_DBM
> 	KVM_PGTABLE_PROT_DIRTY	=> KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W
> 
> And if FEAT_HAFDBS is *not* implemented:
> 
> 	KVM_PGTABLE_PROT_W	=> KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W
> 	KVM_PGTABLE_PROT_DIRTY	=> KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W
> 
> i.e. aliasing both to bit 7.
> 
> Thanks,
> Oliver
> 

Hi Oliver,

You're right, the intermediate DBM+S2AP[1] encoding is not worth
keeping. I'll introduce KVM_PGTABLE_PROT_DIRTY first, aliased to
S2AP[1] alongside PROT_W, with no behavior change. In the next
version I'll then switch the encoding so that:

- with FEAT_HAFDBS: PROT_W -> DBM, PROT_DIRTY -> S2AP[1]
- without FEAT_HAFDBS: both -> S2AP[1]

as you described.

Thanks,
Tian

>>   	if (!kvm_lpa2_is_enabled())
>>   		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
>> @@ -753,9 +757,13 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
>>
>>   	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R)
>>   		prot |= KVM_PGTABLE_PROT_R;
>> -	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
>> +	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM) {
>>   		prot |= KVM_PGTABLE_PROT_W;
>>
>> +		if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
>> +			prot |= KVM_PGTABLE_PROT_DIRTY;
>> +	}
>> +
>>   	switch (FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, pte)) {
>>   	case 0b00:
>>   		prot |= KVM_PGTABLE_PROT_PX | KVM_PGTABLE_PROT_UX;
>> @@ -1288,7 +1296,6 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>>   int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>>   {
>>   	return stage2_update_leaf_attrs(pgt, addr, size, 0,
>> -					KVM_PTE_LEAF_ATTR_HI_S2_DBM |
>>   					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>>   					NULL, NULL,
>>   					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
>> @@ -1368,8 +1375,12 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>>   	if (prot & KVM_PGTABLE_PROT_R)
>>   		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
>>
>> -	if (prot & KVM_PGTABLE_PROT_W)
>> -		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>> +	if (prot & KVM_PGTABLE_PROT_W) {
>> +		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>> +
>> +		if (prot & KVM_PGTABLE_PROT_DIRTY)
>> +			set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>> +	}
>>
>>   	if (prot & KVM_PGTABLE_PROT_X) {
>>   		ret = stage2_set_xn_attr(prot, &xn);
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 2d44cd6a5aed..698a87e85a6d 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1221,7 +1221,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>>   	struct kvm_pgtable *pgt = mmu->pgt;
>>   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
>>   				     KVM_PGTABLE_PROT_R |
>> -				     (writable ? KVM_PGTABLE_PROT_W : 0);
>> +				     (writable ?
>> +				      (KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY) :
>> +				      0);
>>
>>   	if (is_protected_kvm_enabled())
>>   		return -EPERM;
>> @@ -1587,7 +1589,7 @@ static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nest
>>   						       enum kvm_pgtable_prot prot)
>>   {
>>   	if (!kvm_s2_trans_writable(nested))
>> -		prot &= ~KVM_PGTABLE_PROT_W;
>> +		prot &= ~(KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY);
>>   	if (!kvm_s2_trans_readable(nested))
>>   		prot &= ~KVM_PGTABLE_PROT_R;
>>
>> @@ -1658,7 +1660,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>>   	}
>>
>>   	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
>> -		prot |= KVM_PGTABLE_PROT_W;
>> +		prot |= KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY;
>>
>>   	if (s2fd->nested)
>>   		prot = adjust_nested_fault_perms(s2fd->nested, prot);
>> @@ -1690,10 +1692,17 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>>   	}
>>
>>   out_unlock:
>> +	/*
>> +	 * Dirty the folio for any write-permitting mapping: hardware can
>> +	 * promote a writable-clean entry to writable-dirty without a VM
>> +	 * exit, so a clean release could lose a guest write at reclaim.
>> +	 * The dirty bitmap is only marked for mappings installed dirty,
>> +	 * or pre-copy would treat every writable page as dirty.
>> +	 */
>>   	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
>>   	kvm_fault_unlock(kvm);
>>
>> -	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
>> +	if ((prot & KVM_PGTABLE_PROT_DIRTY) && !ret)
>>   		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
>>
>>   	return ret != -EAGAIN ? ret : 0;
>> @@ -1993,11 +2002,14 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>>
>>   	*prot = KVM_PGTABLE_PROT_R;
>>
>> -	if (s2vi->map_writable && (s2vi->device ||
>> -				   !memslot_is_logging(s2fd->memslot) ||
>> -				   kvm_is_write_fault(s2fd->vcpu)))
>> +	if (s2vi->map_writable) {
>>   		*prot |= KVM_PGTABLE_PROT_W;
>>
>> +		if (s2vi->device || !memslot_is_logging(s2fd->memslot) ||
>> +		    kvm_is_write_fault(s2fd->vcpu))
>> +			*prot |= KVM_PGTABLE_PROT_DIRTY;
>> +	}
>> +
>>   	if (s2fd->nested)
>>   		*prot = adjust_nested_fault_perms(s2fd->nested, *prot);
>>
>> @@ -2028,7 +2040,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>>   			    void *memcache)
>>   {
>>   	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>> -	bool writable = prot & KVM_PGTABLE_PROT_W;
>> +	bool dirty = prot & KVM_PGTABLE_PROT_DIRTY;
>>   	struct kvm *kvm = s2fd->vcpu->kvm;
>>   	struct kvm_pgtable *pgt;
>>   	long perm_fault_granule;
>> @@ -2091,7 +2103,11 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>>   	}
>>
>>   out_unlock:
>> -	kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
>> +	/*
>> +	 * Speculative folio dirtying: W, not DIRTY, per the contract
>> +	 * documented in kvm_release_faultin_page().
>> +	 */
>> +	kvm_release_faultin_page(kvm, s2vi->page, !!ret, prot & KVM_PGTABLE_PROT_W);
>>   	kvm_fault_unlock(kvm);
>>
>>   	/*
>> @@ -2099,7 +2115,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>>   	 * making sure we adjust the canonical IPA if the mapping size has
>>   	 * been updated (via a THP upgrade, for example).
>>   	 */
>> -	if (writable && !ret) {
>> +	if (dirty && !ret) {
>>   		phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
>>   		ipa &= ~(mapping_size - 1);
>>   		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
>> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
>> index b0cb8d84a9e9..a1251e252b4f 100644
>> --- a/arch/arm64/kvm/ptdump.c
>> +++ b/arch/arm64/kvm/ptdump.c
>> @@ -45,6 +45,12 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
>>   		.set	= "W",
>>   		.clear	= " ",
>>   	},
>> +	{
>> +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>> +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>> +		.set	= "D",
>> +		.clear	= "C",
>> +	},
>>   	{
>>   		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
>>   		.val	= 0b00UL << __bf_shf(KVM_PTE_LEAF_ATTR_HI_S2_XN),
>> --
>> 2.43.0
>>

