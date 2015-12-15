From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v7 01/19] ARM64: Move PMU register related defines to
 asm/pmu.h
Date: Tue, 15 Dec 2015 19:44:56 +0800
Message-ID: <566FFD38.7060803@linaro.org>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
 <1450169379-12336-2-git-send-email-zhaoshenglong@huawei.com>
 <566FFAB6.8060604@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8925241252
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 06:42:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eK9fgo8yzylg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2015 06:42:49 -0500 (EST)
Received: from mail-pa0-f49.google.com (mail-pa0-f49.google.com
 [209.85.220.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8595411F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 06:42:49 -0500 (EST)
Received: by mail-pa0-f49.google.com with SMTP id ur14so3686465pab.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 03:45:06 -0800 (PST)
In-Reply-To: <566FFAB6.8060604@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/15 19:34, Marc Zyngier wrote:
> On 15/12/15 08:49, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> To use the ARMv8 PMU related register defines from the KVM code,
>> we move the relevant definitions to asm/pmu.h header file.
>>
>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>   arch/arm64/include/asm/pmu.h   | 64 ++++++++++++++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/perf_event.c | 36 +-----------------------
>>   2 files changed, 65 insertions(+), 35 deletions(-)
>>   create mode 100644 arch/arm64/include/asm/pmu.h
>>
>> diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
>> new file mode 100644
>> index 0000000..4264ea0
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/pmu.h
>> @@ -0,0 +1,64 @@
>> +/*
>> + * Copyright (C) 2015 Linaro Ltd, Shannon Zhao
>
> Erm, not quite. You're simply moving existing code from one file to
> another. That doesn't change the copyright of said code, which reads:
>
>   * PMU support
>   *
>   * Copyright (C) 2012 ARM Limited
>   * Author: Will Deacon <will.deacon@arm.com>
>
> Please keep this mention in place.
>
Sure, will fix this. Thanks.

-- 
Shannon
