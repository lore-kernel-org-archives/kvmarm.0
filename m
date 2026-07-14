Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617AE2DB7BD
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 07:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784015090; cv=none; b=aKS1YvwmweRkVa/Kbh8wYfbHzd2B+17WQbHGqDKz6f9CggnmS7KwKyixUv9HvyteQJqfxB5468Chh9gflu0LS5pZymK8PLeRZziUcLgGUF0+Hj4sIpxMI9Z5l5weuvDpqku1aNgSucjnn5jG/7+D6HbUjCq98OoGbHrqXSIdNpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784015090; c=relaxed/simple;
	bh=gNmDA+j97lwltB6SuTd1FUyC9Z1PkdbNRHR8QCmc10c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mmWA1jHS/5/5sCWyKwX06crcUdFTR9Sj2Lt/DHgMp42rnqq5r7Kkr0STAilIrY0h3NVZ7s4XLc65dJPJQX9Rurepu8QqoD3ECVoeZkewtd5q8vf2sxz33dyOBANnOnqmeesIgvSy+PjUJOUR3rUWKP6N71VABfaCD34w5NC9+pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=vM7p8iW1; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="vM7p8iW1"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TUiylXdPKQWTFaCKjfbDnIPpvDYGHdhOWO3Oma0tcpE=;
	b=vM7p8iW12ECzFUqZ2VaGoCVxgDIBKhEVqw+EyC6L0k37PhvQeK0mcO5IZuw6uJ+urHlYTNxws
	M2G9X4Wrzd10tG0IgDdWyYxrCp6gi3lML4fWOUltJM9mRkOmyrxFunc3DhGCwSC28fiLFP84ZUA
	nRqbV/ZolIJ1zcJIHq97fR8=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gzrgh2rK0z1T4gk;
	Tue, 14 Jul 2026 15:35:28 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 75E8340572;
	Tue, 14 Jul 2026 15:44:37 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 14 Jul 2026 15:44:36 +0800
Message-ID: <e01b9a9d-9f38-44ab-acfc-069f143863d6@huawei.com>
Date: Tue, 14 Jul 2026 15:44:37 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware
 dirty tracking
To: Marc Zyngier <maz@kernel.org>
CC: Leonardo Bras <leo.bras@arm.com>, <oupton@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>,
	<caijian11@h-partners.com>, <liuyonglong@huawei.com>, <yezhenyu2@huawei.com>,
	<yubihong@huawei.com>, <linuxarm@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-4-zhengtian10@huawei.com>
 <alTJOy8Sv4aAp_9y@LeoBrasDK>
 <8f949334-3ce7-44f4-b6da-f08a4126affd@huawei.com>
 <86zezunifl.wl-maz@kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <86zezunifl.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)


On 7/14/2026 3:23 PM, Marc Zyngier wrote:
> On Tue, 14 Jul 2026 02:14:45 +0100,
> Tian Zheng <zhengtian10@huawei.com> wrote:
>>
>> On 7/13/2026 7:17 PM, Leonardo Bras wrote:
>>> On Thu, Jul 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
>>>> The DBM (Dirty Bit Modifier) attribute, introduced in ARMv8.1, enables
>>>> hardware to automatically promote write-clean pages to write-dirty. This
>>>> prevents the guest from being trapped in EL2 due to missing write
>>>> permissions.
>>>>
>>>> In this design, DBM is controlled by the page-table level flag
>>>> KVM_PGTABLE_S2_DBM rather than per-PTE software flags. DBM is
>>>> automatically set for writable non-device pages when the page-table has
>>>> KVM_PGTABLE_S2_DBM flag, which is determined at MMU init time based on
>>>> hardware capability.
>>>>
>>>> The DBM bit is set in stage2_set_prot_attr() for initial mappings and
>>>> hugepage splitting, and directly manipulated in
>>>> kvm_pgtable_stage2_relax_perms() when removing write-protection. On
>>>> W->RO downgrade, DBM is cleared to prevent hardware from silently
>>>> upgrading RO+DBM back to W+dirty, which would bypass KVM's write
>>>> tracking.
>>>>
>>>> kvm_pgtable_stage2_pte_prot() does not extract the DBM bit back into
>>>> enum kvm_pgtable_prot because DBM is a page-table policy determined by
>>>> pgt->flags, not a per-PTE property. Callers should check
>>>> pgt->flags & KVM_PGTABLE_S2_DBM instead.
>>>>
>>>> This ensures DBM is consistently applied across all PTEs, including
>>>> during hugepage splitting where child PTEs inherit DBM from the parent
>>>> block entry via the pgt->flags mechanism.
>>>>
>>>> Safety: DBM bit is only interpreted by hardware when VTCR_EL2.HD=1.
>>>> When HDBSS is not enabled (HD=0), ARM architecture guarantees hardware
>>>> completely ignores DBM bit in PTEs.
>>>>
>>>> Co-developed-by: Eillon <yezhenyu2@huawei.com>
>>>> Signed-off-by: Eillon <yezhenyu2@huawei.com>
>>>> Co-developed-by: Leonardo Bras <leo.bras@arm.com>
>>>> Signed-off-by: Leonardo Bras <leo.bras@arm.com>
>>> Hello Tian,
>>>
>>> Have you added the above tags due to this patch being based on the below?
>>> https://lore.kernel.org/all/20260629111820.1873540-2-leo.bras@arm.com/
>>>
>>> Thanks!
>>> Leo
>> Hi Leo,
>>
>>
>> Yes, I added your Signed-off-by because the DBM-related code in this patch
> You really can't do that. Only Leo can give his SoB, you can't forge
> it yourself.
>
>> is based on your implementation in:
>>
>> https://lore.kernel.org/all/20260629111820.1873540-2-leo.bras@arm.com/
> Then take the patch as is, and add to it as a separate patch. Or work
> out in private with Leo whether he's happy with a Co-dev. But never do
> that unilaterally.
>
> Thanks,
>
> 	M.
Got it, thanks for the clarification, Marc.

I'm sorry about that — I'll remove them in the next version.
Instead, I'll mention the reference in the commit message with a link to 
Leo's original patch:

Based on Leonardo Bras's patch:
https://lore.kernel.org/all/20260629111820.1873540-2-leo.bras@arm.com/
