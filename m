Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BFFC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 09:29:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D549020890
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 09:29:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D549020890
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 574E74B17B;
	Wed, 27 May 2020 05:29:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f81946F6FuUa; Wed, 27 May 2020 05:29:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C754B10A;
	Wed, 27 May 2020 05:29:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B70CE4B0F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 05:29:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iur+VtIIUKJz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 05:29:01 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68C334B0FC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 05:29:01 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 0B8E0E4858C83D8465D0;
 Wed, 27 May 2020 17:28:58 +0800 (CST)
Received: from [10.173.221.230] (10.173.221.230) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 27 May 2020 17:28:51 +0800
Subject: Re: [RFC PATCH 2/7] KVM: arm64: Set DBM bit of PTEs if hw DBM enabled
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20200525112406.28224-1-zhukeqian1@huawei.com>
 <20200525112406.28224-3-zhukeqian1@huawei.com> <20200526114926.GD17051@gaia>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <01147c57-b45e-0a40-da9a-4a0e56aac78d@huawei.com>
Date: Wed, 27 May 2020 17:28:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200526114926.GD17051@gaia>
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org, Sean
 Christopherson <sean.j.christopherson@intel.com>,
 Peng Liang <liangpeng10@huawei.com>, Alexios Zavras <alexios.zavras@intel.com>,
 Mark Brown <broonie@kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Catalin,

On 2020/5/26 19:49, Catalin Marinas wrote:
> On Mon, May 25, 2020 at 07:24:01PM +0800, Keqian Zhu wrote:
>> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
>> index 1305e28225fc..f9910ba2afd8 100644
>> --- a/arch/arm64/include/asm/pgtable-prot.h
>> +++ b/arch/arm64/include/asm/pgtable-prot.h
>> @@ -79,6 +79,7 @@ extern bool arm64_use_ng_mappings;
>>  	})
>>  
>>  #define PAGE_S2			__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PAGE_S2_XN)
>> +#define PAGE_S2_DBM		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PAGE_S2_XN | PTE_DBM)
> 
> You don't need a new page permission (see below).
> 
>>  #define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_S2_XN)
>>  
>>  #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index e3b9ee268823..dc97988eb2e0 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1426,6 +1426,10 @@ static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
>>  	pte = pte_offset_kernel(pmd, addr);
>>  	do {
>>  		if (!pte_none(*pte)) {
>> +#ifdef CONFIG_ARM64_HW_AFDBM
>> +			if (kvm_hw_dbm_enabled() && !kvm_s2pte_dbm(pte))
>> +				kvm_set_s2pte_dbm(pte);
>> +#endif
>>  			if (!kvm_s2pte_readonly(pte))
>>  				kvm_set_s2pte_readonly(pte);
>>  		}
> 
> Setting the DBM bit is equivalent to marking the page writable. The
> actual writable pte bit (S2AP[1] or HAP[2] as we call them in Linux for
> legacy reasons) tells you whether the page has been dirtied but it is
> still writable if you set DBM. Doing this in stage2_wp_ptes()
> practically means that you no longer have read-only pages at S2. There
> are several good reasons why you don't want to break this. For example,
> the S2 pte may already be read-only for other reasons (CoW).
> 
Thanks, your comments help to solve the first problem in cover letter.

> I think you should only set the DBM bit if the pte was previously
> writable. In addition, any permission change to the S2 pte must take
> into account the DBM bit and clear it while transferring the dirty
> status to the underlying page. I'm not deeply familiar with all these
> callbacks into KVM but two such paths are kvm_unmap_hva_range() and the
> kvm_mmu_notifier_change_pte().
Yes, I agree.
> 
> 
>> @@ -1827,7 +1831,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  
>>  		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
>>  	} else {
>> -		pte_t new_pte = kvm_pfn_pte(pfn, mem_type);
>> +		pte_t new_pte;
>> +
>> +#ifdef CONFIG_ARM64_HW_AFDBM
>> +		if (kvm_hw_dbm_enabled() &&
>> +		    pgprot_val(mem_type) == pgprot_val(PAGE_S2)) {
>> +			mem_type = PAGE_S2_DBM;
>> +		}
>> +#endif
>> +		new_pte = kvm_pfn_pte(pfn, mem_type);
>>  
>>  		if (writable) {
>>  			new_pte = kvm_s2pte_mkwrite(new_pte);
> 
> That's wrong here. Basically for any fault you get, you just turn the S2
> page writable. The point of DBM is that you don't get write faults at
> all if you have a writable page. So, as I said above, only set the DBM
> bit if you stored a writable S2 pte (kvm_s2pte_mkwrite()).
Yeah, you are right. I will correct it in Patch v1.
> 

Thanks,
Keqian

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
