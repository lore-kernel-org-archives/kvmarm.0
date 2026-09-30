Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14F337EFE7
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 02:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790736281; cv=none; b=EHN2wMTo6LDp9Gt33kxOuDSZd3Pt6cfHMDpOtWDWuHUOlJlbuxiLJ7DXkVylBW+qgAR/RcoV92kM0BvLM6H04PoiMdkzodr9Hdh3CWZKWaTeAuna5laGp5vVbM6/I90/HjlPG5JmuoRoeZmMTjqvR9lOW4b2HKkT35Jdx2h+tZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790736281; c=relaxed/simple;
	bh=Udv85l8OgC1W16Wl/3Z22cE260FFgJNFTdbeKkuyDBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LDNk9mkE8/JPcPQxRziuB9nFelpdbC+lsD4I+ZODmhzZcw+/6n1xjZpFGuNWHjx+ChskOhURzrgfQC+l/7cOOlT1GKyOyzyKw/3qMV5bw0FY72LSDekO4MuGE+6+/NersG10N+M7xGHh5XTYUPWzV8adf8qMFw4cjQ9ne/Gfoj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0YbAQnMD; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0YbAQnMD"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nu5ZaCtb+a/PsIAKfQUdrIHwtBUiHyWKKOnEg6MdREo=;
	b=0YbAQnMDvcVwdnz1Vzs/oN4/O2AuEgf1TO/pgmAKKlZo1i/+XGY5g4ohRwYZldoufBNmVHDCy
	MlRY3pcYWYxSiOTokrxTozKa+Qr3C9Qcy0ZloP5cglfmKJb2N5Q+SCMX7lSU363DLSBcdDePqTo
	/8/oPEr4RsXwkaOjrop2rS4=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hvfFs1p3dz1prLV;
	Wed, 30 Sep 2026 10:32:17 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 6EA5B40538;
	Wed, 30 Sep 2026 10:44:28 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 30 Sep 2026 10:44:27 +0800
Message-ID: <8ca88576-651a-4b7f-91ff-2cb2359aa79e@huawei.com>
Date: Wed, 30 Sep 2026 10:44:26 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/15] KVM: arm64: pgtables: Change write bit from
 S2AP_W to DBM
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
 <20260929103655.85107-2-zhengtian10@huawei.com> <arxW4PUY3qqRkogl@kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <arxW4PUY3qqRkogl@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/30/2026 8:25 AM, Oliver Upton wrote:
> Hi Tian,
> 
> On Tue, Sep 29, 2026 at 06:36:41PM +0800, Tian Zheng wrote:
>> From: Leonardo Bras <leo.bras@arm.com>
>>
>> As a first step of changing the encoding for the Stage2 PTE descriptor,
>> introduce the DBM bit, and adapt every usage of writable to use the DBM
>> bit (51) instead of S2AP[1]/Dirty bit (7).
>>
>> With DBM as the write permission bit and S2AP[1] as the dirty state,
>> the encoding follows the FEAT_S2PIE principle of managing permissions
>> and dirty state independently.
>>
>> For this step, we convert usages of RW(Dirty) -> WD(DBM|Dirty): every
>> writable mapping sets both bits, read-only mappings clear both, and no
>> behaviour changes.
>>
>> Link: https://lore.kernel.org/all/20260901171558.2674031-2-leo.bras@arm.com/
>> Signed-off-by: Leonardo Bras <leo.bras@arm.com>
>> [zhengtian: keep the nested walker reading writability from S2AP[1]
>> alone, document why, and reword the commit message]
>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_pgtable.h | 3 +++
>>   arch/arm64/kvm/hyp/pgtable.c         | 7 ++++---
>>   arch/arm64/kvm/nested.c              | 5 +++++
>>   arch/arm64/kvm/ptdump.c              | 4 ++--
>>   4 files changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index 41a8687938eb..37baa86d6fd8 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -93,10 +93,13 @@ typedef u64 kvm_pte_t;
>>
>>   #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
>>
>> +#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
>> +
>>   #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
>>
>>   #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
>>   					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
>> +					 KVM_PTE_LEAF_ATTR_HI_S2_DBM | \
>>   					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
>>
>>   /* pKVM invalid pte encodings */
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index b74dd5ce1efd..50f4d3a74f77 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -732,7 +732,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>>   		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
>>
>>   	if (prot & KVM_PGTABLE_PROT_W)
>> -		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>> +		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> 
> Hmm... I'd actually like to see this structured where the "write" bit
> could either be S2AP_W or DBM depending on if the system supports
> FEAT_HAFDBS. Look at how HVHE is handled for selecting the right AP
> encoding for the hyp stage-1 page tables.
> 

Hi Oliver,

Thanks for the suggestion. I missed the case where FEAT_HAFDBS is not
supported. Systems without the feature should keep the original
encoding, with S2AP[1] as the write permission bit. I'll follow the HVHE
pattern to select between the two encodings in the next version.

Thanks!
Tian

>> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
>> index 69899797dbad..b0cb8d84a9e9 100644
>> --- a/arch/arm64/kvm/ptdump.c
>> +++ b/arch/arm64/kvm/ptdump.c
>> @@ -40,8 +40,8 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
>>   		.clear	= " ",
>>   	},
>>   	{
>> -		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>> -		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>> +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_DBM,
>> +		.val	= KVM_PTE_LEAF_ATTR_HI_S2_DBM,
>>   		.set	= "W",
>>   		.clear	= " ",
>>   	},
>> --
>> 2.43.0
>>

