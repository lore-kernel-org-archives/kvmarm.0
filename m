Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793328845;
	b=mathi8aMJuLww/CBo5aCQ6MVOUakdpUtkwxQvz/4xjigiDdxukLvR4rbHnTJvvkmrMFB
	 w3Jk4DBF13J83x+SkV5XgmiE+XpuOcmCQGoMQJM/gQ5cJIWZYhxMvBUpjgbNminDwKYMv
	 +twAObJwHQ6uKtMOgmn9pBJc99NjdoQaMa+4qazHWNNSRHxnNDl7scQDLMJoVyWegsm+1
	 g+ZW9fW+L8XurnA2jzoPG0jn2hp64DZxcsJBSkUJpSVue2b/RZo/Jnf2d0knXUTOICso3
	 1LV5KSDw4w23Wbj5C+xmqtxM5Ol2QkzNyJfLT5xw6S6vOnON27t5VS4cSI0SVzzWXLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793328845;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=R32rGPcJuG+1kCDhnHECP/PCqav9h3by8BHulE0myn4=;
	b=N/Q63FDHvIv94c/aWalg9kY2fFNLZLLwGqkizQ1TLO7kICzbNoET6UlrURbjGxKPrzc0
	 RFu1r9smzMuEe6//OD2Rf0cDcb/n5TXZa0gHay/8oOEw5nXEQIDFiHbr/NATR8gA7sx6J
	 QhsKcTvpBvkeTa3ql2vsd0NR+tc48S27HcodGonrVFdsT4zuSbbhcsdrfFV4qkPygUY+3
	 UYWgdbN83Tgi8XmTjRZYEyZQjvjFfXq2Zj9ZPxBWVloDxPp9iXmoFAUok23gXJCW266CP
	 JHiqABKAgvH9UHZ80UxCYSYKFe874aA/zmlUMyOXlgimVoxCW8dQ0+uqpINHbjrj/Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b="Unh/wbOF";
	arc=none smtp.remote-ip=113.46.200.225
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AECB606A31C
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 02:54:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AECB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Unh/wbOF
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=R32rGPcJuG+1kCDhnHECP/PCqav9h3by8BHulE0myn4=;
	b=Unh/wbOFJAII1gDiU/F8veoDlAxf3h+Pjvdy/1dOAIZPRYuocBY31he/5knqTdGoGovtmcwML
	XvQdJ+ueqPeQKCYaPPM0bZ1ZSGqYTs/EZxNqO4WTd4Q0zQ6D1+1LbnP+1BqJJmbgBiSkzqj+XeS
	EvdUwJ1ckbq1VmqrXfnldKM=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jG5K16Mmmz1K9D6;
	Fri, 30 Oct 2026 10:53:57 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 7CE2B40565;
	Fri, 30 Oct 2026 10:53:59 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 30 Oct 2026 10:53:58 +0800
Message-ID: <a301e884-f6d1-4082-8551-8d8a17276dc3@huawei.com>
Date: Fri, 30 Oct 2026 10:53:57 +0800
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/15] KVM: arm64: Add support for FEAT_HDBSS
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
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
 <20260929103655.85107-7-zhengtian10@huawei.com> <at-X_hFbsBU_Dsgr@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <at-X_hFbsBU_Dsgr@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 10/27/2026 2:12 AM, Leonardo Bras wrote:
> On Tue, Sep 29, 2026 at 06:36:46PM +0800, Tian Zheng wrote:
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 32102c3912fa..12fa37328dd2 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -2158,6 +2158,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
>>   	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
>>   }
>>
>> +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int scope)
>> +{
>> +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, scope);
>> +}
>> +
> 

Hi leo,

> IIUC you run this on every cpu in the system, to make sure it's matching
> the feature. Is there any chance the kernel is in EL2 only on some of the
> cpus here?
> 

It's impossible for the system to have only some CPUs in EL2 and others
  not.

> If not, maybe we can run it on system_supports_hdbss() instead, which would
> be easier for the user to understand it only runs in EL2, on top of not
> needing the above.
> 

However, The question is whether a cap should mean "this system can use
the feature" or "this hardware supports the feature". If the cap only
tracks hardware support, users may be confused when the hardware
supports HDBSS but the system runs in nVHE mode — they would mistakenly
believe they can use the feature.

So I think we should keep is_kernel_in_hyp_mode() in has_vhe_hdbss(),
and add a comment in system_supports_hdbss() explaining this.

Does that work for you? Looking forward to your reply.

Thanks,
Tian


