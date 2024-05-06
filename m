Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1894B143867
	for <kvmarm@lists.linux.dev>; Mon,  6 May 2024 12:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714997569; cv=none; b=O/Cqbg/pu3/xocyFHRhN43BETAts9o6knDZ+IlluWP8qw6TTyCFeujpDcT/gCCW3jO/cdMSC8Qr3RiiLwmNPaZVFj0NCLehYi8ia/Y45xjewv18zXxnh5U9ae2WVJN94IOtN2i1EoAb5b7B3N/zUaIkKeZJGL71FN1EvXGZb0jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714997569; c=relaxed/simple;
	bh=q04s1HvnktcJyr1ZfLDdHVvrdmfLfNxlRmGKaPfRWpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=j7bMI59ICKIeLepEr4RMFEk+lvxUBFnBB9tBBQ+AntKtF91qNlifNsOztHiTRwGLBZ0vPbGCoz0jfO06k0wpfMo2DLu1/Bc+mCPeMoBgMafO9zyoNkSqvvX5dxTXgBv5DFCFg3VZjSxW/16LE9uqEQZsK2tLL2klcvPAY5NAZuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VY0ZR3KxwztT80;
	Mon,  6 May 2024 20:09:19 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 67E6D1800C7;
	Mon,  6 May 2024 20:12:43 +0800 (CST)
Received: from [10.67.110.108] (10.67.110.108) by
 kwepemd200013.china.huawei.com (7.221.188.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 6 May 2024 20:12:39 +0800
Message-ID: <91ebac93-099d-9e4a-537b-e2f2c3e7b521@huawei.com>
Date: Mon, 6 May 2024 20:12:38 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v3 1/8] arm64/sysreg: Add definitions for immediate
 versions of MSR ALLINT
To: Mark Rutland <mark.rutland@arm.com>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <tglx@linutronix.de>, <ardb@kernel.org>,
	<broonie@kernel.org>, <anshuman.khandual@arm.com>, <miguel.luis@oracle.com>,
	<joey.gouly@arm.com>, <ryan.roberts@arm.com>, <jeremy.linton@arm.com>,
	<ericchancf@google.com>, <kristina.martsenko@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<shijie@os.amperecomputing.com>, <akpm@linux-foundation.org>,
	<bhe@redhat.com>, <horms@kernel.org>, <mhiramat@kernel.org>,
	<rmk+kernel@armlinux.org.uk>, <shahuang@redhat.com>,
	<takakura@valinux.co.jp>, <dianders@chromium.org>, <swboyd@chromium.org>,
	<sumit.garg@linaro.org>, <frederic@kernel.org>, <reijiw@google.com>,
	<akihiko.odaki@daynix.com>, <ruanjinjie@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
References: <20240415064758.3250209-1-liaochang1@huawei.com>
 <20240415064758.3250209-2-liaochang1@huawei.com>
 <ZjUKMWPknEhLYoK8@FVFF77S0Q05N>
From: "Liao, Chang" <liaochang1@huawei.com>
In-Reply-To: <ZjUKMWPknEhLYoK8@FVFF77S0Q05N>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200013.china.huawei.com (7.221.188.133)



在 2024/5/4 0:00, Mark Rutland 写道:
> On Mon, Apr 15, 2024 at 06:47:51AM +0000, Liao Chang wrote:
>> From: Mark Brown <broonie@kernel.org>
>>
>> Encodings are provided for ALLINT which allow setting of ALLINT.ALLINT
>> using an immediate rather than requiring that a register be loaded with
>> the value to write. Since these don't currently fit within the scheme we
>> have for sysreg generation add manual encodings like we currently do for
>> other similar registers such as SVCR.
>>
>> Since it is required that these immediate versions be encoded with xzr
>> as the source register provide asm wrapper which ensure this is the
>> case.
>>
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Liao Chang <liaochang1@huawei.com>
>> ---
>>  arch/arm64/include/asm/nmi.h    | 27 +++++++++++++++++++++++++++
>>  arch/arm64/include/asm/sysreg.h |  2 ++
>>  2 files changed, 29 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/nmi.h
> 
> We have helpers for manipulating PSTATE bits; AFAICT we only need the three
> lines below:
> 
> ----8<----
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 9e8999592f3af..5c209d07ae57e 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -94,18 +94,21 @@
>  
>  #define PSTATE_PAN                     pstate_field(0, 4)
>  #define PSTATE_UAO                     pstate_field(0, 3)
> +#define PSTATE_ALLINT                  pstate_field(1, 0)
>  #define PSTATE_SSBS                    pstate_field(3, 1)
>  #define PSTATE_DIT                     pstate_field(3, 2)
>  #define PSTATE_TCO                     pstate_field(3, 4)
>  
>  #define SET_PSTATE_PAN(x)              SET_PSTATE((x), PAN)
>  #define SET_PSTATE_UAO(x)              SET_PSTATE((x), UAO)
> +#define SET_PSTATE_ALLINT(x)           SET_PSTATE((x), ALLINT)
>  #define SET_PSTATE_SSBS(x)             SET_PSTATE((x), SSBS)
>  #define SET_PSTATE_DIT(x)              SET_PSTATE((x), DIT)
>  #define SET_PSTATE_TCO(x)              SET_PSTATE((x), TCO)
>  
>  #define set_pstate_pan(x)              asm volatile(SET_PSTATE_PAN(x))
>  #define set_pstate_uao(x)              asm volatile(SET_PSTATE_UAO(x))
> +#define set_pstate_allint(x)           asm volatile(SET_PSTATE_ALLINT(x))
>  #define set_pstate_ssbs(x)             asm volatile(SET_PSTATE_SSBS(x))
>  #define set_pstate_dit(x)              asm volatile(SET_PSTATE_DIT(x))
> ---->8---- 

Acked, I strongly prefer reusing existing helpers to introducing new ones.

> 
> The addition of <asm/nmi.h> and refrences to <linux/cpumask.h> and
> arm64_supports_nmi() don't seem like they should be part of this patch.

Agree, what about to remove the nmi.h completely in this patch?

Thanks.

> 
> Mark.
> 
>>
>> diff --git a/arch/arm64/include/asm/nmi.h b/arch/arm64/include/asm/nmi.h
>> new file mode 100644
>> index 000000000000..0c566c649485
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/nmi.h
>> @@ -0,0 +1,27 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2022 ARM Ltd.
>> + */
>> +#ifndef __ASM_NMI_H
>> +#define __ASM_NMI_H
>> +
>> +#ifndef __ASSEMBLER__
>> +
>> +#include <linux/cpumask.h>
>> +
>> +extern bool arm64_supports_nmi(void);
>> +
>> +#endif /* !__ASSEMBLER__ */
>> +
>> +static __always_inline void _allint_clear(void)
>> +{
>> +	asm volatile(__msr_s(SYS_ALLINT_CLR, "xzr"));
>> +}
>> +
>> +static __always_inline void _allint_set(void)
>> +{
>> +	asm volatile(__msr_s(SYS_ALLINT_SET, "xzr"));
>> +}
>> +
>> +#endif
>> +
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 9e8999592f3a..b105773c57ca 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -167,6 +167,8 @@
>>   * System registers, organised loosely by encoding but grouped together
>>   * where the architected name contains an index. e.g. ID_MMFR<n>_EL1.
>>   */
>> +#define SYS_ALLINT_CLR			sys_reg(0, 1, 4, 0, 0)
>> +#define SYS_ALLINT_SET			sys_reg(0, 1, 4, 1, 0)
>>  #define SYS_SVCR_SMSTOP_SM_EL0		sys_reg(0, 3, 4, 2, 3)
>>  #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
>>  #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
>> -- 
>> 2.34.1
>>

-- 
BR
Liao, Chang
