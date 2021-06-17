Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3211C2B9F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 06:48:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D5CB611CA
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 06:48:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D5CB611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2A904B080;
	Thu, 17 Jun 2021 02:48:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id utY3VEk2aEIr; Thu, 17 Jun 2021 02:48:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA4A34A524;
	Thu, 17 Jun 2021 02:48:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 703834A3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 02:48:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HK5QTAg5qtSj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 02:48:36 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E220F40895
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 02:48:35 -0400 (EDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5CDx0683zXgkX;
 Thu, 17 Jun 2021 14:43:29 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 14:48:31 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 14:48:30 +0800
Subject: Re: [PATCH v6 1/4] KVM: arm64: Introduce cache maintenance callbacks
 for guest stage-2
To: Marc Zyngier <maz@kernel.org>
References: <20210616095200.38008-1-wangyanan55@huawei.com>
 <20210616095200.38008-2-wangyanan55@huawei.com>
 <87eed2lzcc.wl-maz@kernel.org>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <8340be12-cc80-8c2a-3597-ecba05eaf35a@huawei.com>
Date: Thu, 17 Jun 2021 14:48:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87eed2lzcc.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
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

On 2021/6/16 21:21, Marc Zyngier wrote:
> Hi Yanan,
>
> On Wed, 16 Jun 2021 10:51:57 +0100,
> Yanan Wang <wangyanan55@huawei.com> wrote:
>> To prepare for performing guest CMOs in the fault handlers in pgtable.c,
>> introduce two cache maintenance callbacks in struct kvm_pgtable_mm_ops.
>>
>> The new callbacks are specific for guest stage-2, so they will only be
>> initialized in 'struct kvm_pgtable_mm_ops kvm_s2_mm_ops'.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_pgtable.h | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index c3674c47d48c..302eca32e0af 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -44,6 +44,11 @@ typedef u64 kvm_pte_t;
>>    *			in the current context.
>>    * @virt_to_phys:	Convert a virtual address mapped in the current context
>>    *			into a physical address.
>> + * @flush_dcache:	Clean data cache for a guest page address range before
>> + *			creating the corresponding stage-2 mapping.
> Please don't reintroduce the word 'flush'. We are really trying to
> move away from it as it doesn't describe what we want to do.
I agree with this. I intended to make the names short and laconic, but this
missed the information about the callback's actual behaviors.
> Here this
> should be 'clean_invalidate_dcache' which, despite being a mouthful,
> describe accurately what we expect it to do.
Sure, I will change the name as you suggested.
> The comment is also missing the invalidate part, and we shouldn't
> assume that this is only used for S2 mapping.
Ok, will refine the comment. I think something like"Clean and invalidate the
date cache for the specified memory address range" may be generic enough.
>> + * @flush_icache:	Invalidate instruction cache for a guest page address
>> + *			range before creating or updating the corresponding
>> + *			stage-2 mapping.
> Same thing here; this should be 'invalidate_icache', and the comment
> cleaned up.
Thanks, I will also correct this part.

Besides the callback names and comments, is there anything else that still
needs some adjustment in the other three patches? :)

Regards,
Yanan
.
>>    */
>>   struct kvm_pgtable_mm_ops {
>>   	void*		(*zalloc_page)(void *arg);
>> @@ -54,6 +59,8 @@ struct kvm_pgtable_mm_ops {
>>   	int		(*page_count)(void *addr);
>>   	void*		(*phys_to_virt)(phys_addr_t phys);
>>   	phys_addr_t	(*virt_to_phys)(void *addr);
>> +	void		(*flush_dcache)(void *addr, size_t size);
>> +	void		(*flush_icache)(void *addr, size_t size);
>>   };
>>   
>>   /**
> Thanks,
>
> 	M.
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
