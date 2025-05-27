Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D011F4CBB
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 13:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748351118; cv=none; b=NKas8erAJmeRwXati7dhfHyaBoArEJk2S60npkxxrVgZ/LzjPjuoY1Mg23B0oV3cUQLcIJ/tVWXLekiEoJ4DvdWP+TifrOfN0T3LZq/9CYpw/xbLKjGPEGVTnm9XS+UtFdu11Gvst1b4VJ1WhAjorvrhdwmnV7b6dpmoo84pnyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748351118; c=relaxed/simple;
	bh=cFA/dkYyvc3X1Y7GQyzohC1dFXVFvAzkHJAS97M1O70=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SZELsK8GAGDESec1olI72vZezGXdJbDyIltv8RrsJhI2d63XsKuz0BSLSUq0Ya7EUNqE+XkJzx25x+9z/eL9Xq5ln08p5MnRutpuPf1sjgVz1gP5q0JHXl3LJK01BAQYfjnushF+aUu6VhdVEwI3Mg539lVBanW/mWDwJv7K5BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4b6CVm4T0kz13Lsf;
	Tue, 27 May 2025 21:03:28 +0800 (CST)
Received: from kwepemg100001.china.huawei.com (unknown [7.202.181.18])
	by mail.maildlp.com (Postfix) with ESMTPS id D126C140134;
	Tue, 27 May 2025 21:05:11 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 kwepemg100001.china.huawei.com (7.202.181.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 27 May 2025 21:05:11 +0800
Message-ID: <86bcc70b-f41f-45d3-967e-c6190c6ceadd@huawei.com>
Date: Tue, 27 May 2025 21:05:10 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Make HCX writable from userspace
To: Oliver Upton <oliver.upton@linux.dev>
CC: <maz@kernel.org>, <yuzenghui@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <wangzhou1@hisilicon.com>,
	<shameerali.kolothum.thodi@huawei.com>, <liuyonglong@huawei.com>,
	<jiangkunkun@huawei.com>
References: <20250325121126.1380681-1-yangjinqian1@huawei.com>
 <Z-LX5H5mjGyTQ9N4@linux.dev>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <Z-LX5H5mjGyTQ9N4@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemg100001.china.huawei.com (7.202.181.18)


> Hi Jinqian,
>
> On Tue, Mar 25, 2025 at 08:11:26PM +0800, Jinqian Yang wrote:
>> Allow userspace to modify guest visible value for HCX in
>> ID_AA64MMFR1_EL1.
>>
>> Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
>
> This is fine, but I would rather we handle all the features like FEAT_HCX
> instead of a trickle of one-off patches.
>
> So, could you please:
>
> - Identify all of the features that describe an *EL2* feature which
>   we've exposed to non-nested VMs
>
> - Implement patch(es) to make those fields writable (i.e. allow them to
>   be downgraded)
>
> - Add corresponding test cases to the set_id_regs selftest
>
> Thanks,
> Oliver
>
Hi Oliver，

Thanks for the detailed explantation!

During our testing of cross-generation live migration, we encountered
an issue that requires applying the patch. The problem arises when two
chips have inconsistent FEAT_HCX. To ensure consistent virtual machine
behavior before and after migration, we need to make FEAT_HCX writable,
thereby aligning the feature flags across source and destination hosts.


Above is the context of this patch. I will revise this patch following your
suggestions, but I need to confirm: does the term *EL2* feature specifically
refer to capabilities related to ​​HCRX_EL2​​ and ​​HCR_EL2​​?

Jinqian


>> ---
>>  arch/arm64/kvm/sys_regs.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 82430c1e1dd0..b105f156bdf6 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -2666,7 +2666,6 @@ static const struct sys_reg_desc 
>> sys_reg_descs[] = {
>>                      ID_AA64MMFR0_EL1_TGRAN16_2 |
>>                      ID_AA64MMFR0_EL1_ASIDBITS)),
>>      ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
>> -                    ID_AA64MMFR1_EL1_HCX |
>>                      ID_AA64MMFR1_EL1_TWED |
>>                      ID_AA64MMFR1_EL1_XNX |
>>                      ID_AA64MMFR1_EL1_VH |
>> -- 
>> 2.33.0
>>
>
