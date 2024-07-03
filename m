Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A8B135414
	for <kvmarm@lists.linux.dev>; Wed,  3 Jul 2024 07:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719990552; cv=none; b=h8SOlQLb71JmQzoGj/ImrSErXSBM5YTKEdz/d/FWrEY6URdkyst5tGBQguWqdlwhZWo/MGmKQbwVSnfB4Uv8O87RRfzb3VbIDQwwEJ22Xv1h4bv+3YbQOSR0zhZpWwQsiQNVwxZNHig3/IhiXunyAnsgt8D4qf1+M2M5+WXxb6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719990552; c=relaxed/simple;
	bh=Sn5dLtaquFdDRY3PwqiBJOhjXpdj+nusVgSTVeu7z2Y=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cIHLjPIlmFD6dPKmjvOWOMrPhTrda9S7kbEEMWIiSloxQon2FY68KnpNhVzjen6JL07+bXSiby/xAl5Pl8Zz2fp4acQhLpu4i6cPEGVAHNgRe/p3BxAwKBcDnl1OjrT4/3B4ldtyNxWMYQYNLkwtEze2xa+9PpN+JVv1fBEYh7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WDW4X5hdXz1X4RM;
	Wed,  3 Jul 2024 15:05:00 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 3736114037E;
	Wed,  3 Jul 2024 15:09:07 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 3 Jul 2024 15:09:05 +0800
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU introspection
 test if missing
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
CC: <pbonzini@redhat.com>, <thuth@redhat.com>, <kvm@vger.kernel.org>,
	<qemu-arm@nongnu.org>, <linux-arm-kernel@lists.infradead.org>,
	<christoffer.dall@arm.com>, <maz@kernel.org>, Anders Roxell
	<anders.roxell@linaro.org>, Andrew Jones <andrew.jones@linux.dev>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, "open
 list:ARM" <kvmarm@lists.linux.dev>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
 <20240702163515.1964784-2-alex.bennee@linaro.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8c11996c-b36d-e560-cdeb-e543ee478a54@huawei.com>
Date: Wed, 3 Jul 2024 15:09:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240702163515.1964784-2-alex.bennee@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/7/3 0:35, Alex Bennée wrote:
> The test for number of events is not a substitute for properly
> checking the feature register. Fix the define and skip if PMUv3 is not
> available on the system. This includes emulator such as QEMU which
> don't implement PMU counters as a matter of policy.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Anders Roxell <anders.roxell@linaro.org>
> ---
>  arm/pmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 9ff7a301..66163a40 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
>  #define ID_AA64DFR0_PERFMON_MASK  0xf
>  
>  #define ID_DFR0_PMU_NOTIMPL	0b0000
> -#define ID_DFR0_PMU_V3		0b0001
> +#define ID_DFR0_PMU_V3		0b0011

Why? This is a macro used for AArch64 and DDI0487J.a (D19.2.59, the
description of the PMUVer field) says that

"0b0001	Performance Monitors Extension, PMUv3 implemented."

while 0b0011 is a reserved value.

Thanks,
Zenghui
