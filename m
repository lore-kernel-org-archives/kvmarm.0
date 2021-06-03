Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B873C47082
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 12:35:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE78461242
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 12:35:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE78461242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 349B54B0C0;
	Thu,  3 Jun 2021 08:35:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aqSW049JAR1n; Thu,  3 Jun 2021 08:35:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 855114B0E5;
	Thu,  3 Jun 2021 08:35:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED0CC4B0D8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 08:35:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aw1k-1l5ka4b for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 08:35:07 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE18A4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 08:35:06 -0400 (EDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fwldb544qz6tsl;
 Thu,  3 Jun 2021 20:32:03 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:35:01 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:34:59 +0800
Subject: Re: [PATCH v5 4/6] KVM: arm64: Provide invalidate_icache_range at
 non-VHE EL2
To: Marc Zyngier <maz@kernel.org>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-5-wangyanan55@huawei.com>
 <875yyw1s73.wl-maz@kernel.org>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <4169bbfc-0b63-5d2f-9ac5-27bea3e7ea46@huawei.com>
Date: Thu, 3 Jun 2021 20:34:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <875yyw1s73.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2021/6/2 18:22, Marc Zyngier wrote:
> On Thu, 15 Apr 2021 12:50:30 +0100,
> Yanan Wang <wangyanan55@huawei.com> wrote:
>> We want to move I-cache maintenance for the guest to the stage-2
>> page table code for performance improvement. Before it can work,
>> we should first make function invalidate_icache_range available
>> to non-VHE EL2 to avoid compiling or program running error, as
>> pgtable.c is now linked into the non-VHE EL2 code for pKVM mode.
>>
>> In this patch, we only introduce symbol of invalidate_icache_range
>> with no real functionality in nvhe/cache.S, because there haven't
>> been situations found currently where I-cache maintenance is also
>> needed in non-VHE EL2 for pKVM mode.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/kvm/hyp/nvhe/cache.S | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
>> index 36cef6915428..a125ec9aeed2 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/cache.S
>> +++ b/arch/arm64/kvm/hyp/nvhe/cache.S
>> @@ -11,3 +11,14 @@ SYM_FUNC_START_PI(__flush_dcache_area)
>>   	dcache_by_line_op civac, sy, x0, x1, x2, x3
>>   	ret
>>   SYM_FUNC_END_PI(__flush_dcache_area)
>> +
>> +/*
>> + *	invalidate_icache_range(start,end)
>> + *
>> + *	Ensure that the I cache is invalid within specified region.
>> + *
>> + *	- start   - virtual start address of region
>> + *	- end     - virtual end address of region
>> + */
>> +SYM_FUNC_START(invalidate_icache_range)
>> +SYM_FUNC_END(invalidate_icache_range)
> This is a good indication that something is really wrong.
>
> If you were to provide cache management callbacks as part of the
> mm_ops themselves (or a similar abstraction), you wouldn't have to do
> these things.
Yes, we definitely don't need this work if we do that.

Thanks,
Yanan
>
> 	M.
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
