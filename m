Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71926346FB9
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 03:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762832606; cv=none; b=AC6WAiqzY8xdBGCdj9ixHy9OveUJ2aAOnCR659wbUkI7PVHTxy0hgdKJ80opAE0K92DdoZ7plDssWVuokV6J10oSXmTqmbkEqxBLzAzBq6117A049LPklflcOwOB9r7jY5Cu1zTSFqaAwPr/igRVUxHD21DDeM1mOwBaDKSWKRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762832606; c=relaxed/simple;
	bh=MMwzfR5H1pUi2uy+y+0jbPsBuQQ+6oF24mA9QDCKNfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FHOHJlF4RSjw8/1AA3AEubjs7oLpTed5lpDZ4jitnPqQ/YRDY+FTkq1Wg20nho2teEzXUFxeq6zp/QuMTaBGdnn7w11DobkmNwcN1dnz3dq3OwmDuS31YJgBeLuhFaFKiXkH7rv5rWNUC9HarNOhoPY1nwUDZzL0+vuoFsloYNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4d5C534bS2z12LDN;
	Tue, 11 Nov 2025 11:41:43 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id DBDE41401F0;
	Tue, 11 Nov 2025 11:43:15 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 11:43:15 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 11:43:14 +0800
Message-ID: <43558551-5ebc-0987-efdd-880021e7f906@hisilicon.com>
Date: Tue, 11 Nov 2025 11:43:14 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v7 6/7] KVM: arm64: Enable FEAT_{LS64, LS64_V} in the
 supported guest
Content-Language: en-US
To: Oliver Upton <oupton@kernel.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <arnd@arndb.de>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-7-wangzhou1@hisilicon.com>
 <aQ5APpLg0Elv4YoH@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <aQ5APpLg0Elv4YoH@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/11/8 2:53, Oliver Upton wrote:
> Hi Zhou,
> 
> On Fri, Nov 07, 2025 at 03:21:26PM +0800, Zhou Wang wrote:
>> From: Yicong Yang <yangyicong@hisilicon.com>
>>
>> Using FEAT_{LS64, LS64_V} instructions in a guest is also controlled
>> by HCRX_EL2.{EnALS, EnASR}. Enable it if guest has related feature.
>>
>> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> 
> The ordering of this patch is incorrect as patch #5 has the side-effect
> of exposing ID_AA64ISAR1_EL1.LS64 to KVM guests. This one should come
> first instead.
Hi Oliver,

I got this point, will change the order in next version.

Thanks,
Zhou

> 
> Thanks,
> Oliver
> 
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index bab967d65715..29291e25ecfd 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -695,6 +695,12 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>>  
>>  		if (kvm_has_sctlr2(kvm))
>>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_SCTLR2En;
>> +
>> +		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64))
>> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnALS;
>> +
>> +		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
>> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
>>  	}
>>  }
>>  #endif /* __ARM64_KVM_EMULATE_H__ */
>> -- 
>> 2.33.0
>>
>>
> 
> .
