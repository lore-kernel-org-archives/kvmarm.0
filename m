Return-Path: <SRS0=T6xz=FI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 950B4C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 06:09:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE7EE22581
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 06:09:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE7EE22581
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED1254B24E;
	Fri,  4 Dec 2020 01:08:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id exXH0CA4N0sd; Fri,  4 Dec 2020 01:08:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0A984B286;
	Fri,  4 Dec 2020 01:08:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A24B64B24E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 01:08:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y5+K5eHG7udt for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2020 01:08:55 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C2E64B21E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 01:08:55 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CnMhY5W3czhmTV;
 Fri,  4 Dec 2020 14:08:29 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Dec 2020 14:08:26 +0800
Subject: Re: [PATCH v2 1/2] KVM: arm64: Some fixes of PV-time interface
 document
To: Marc Zyngier <maz@kernel.org>
References: <20200817110728.12196-1-zhukeqian1@huawei.com>
 <20200817110728.12196-2-zhukeqian1@huawei.com>
 <3eddcebd87f09c1d48bf43e1b43ce390@kernel.org>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <c1e3c3c7-a86d-f64f-cd18-3a0788d9938e@huawei.com>
Date: Fri, 4 Dec 2020 14:08:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <3eddcebd87f09c1d48bf43e1b43ce390@kernel.org>
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Steven Price <steven.price@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 2020/12/3 23:04, Marc Zyngier wrote:
> On 2020-08-17 12:07, Keqian Zhu wrote:
>> Rename PV_FEATURES to PV_TIME_FEATURES.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>> Reviewed-by: Steven Price <steven.price@arm.com>
>> ---
>>  Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/arm/pvtime.rst
>> b/Documentation/virt/kvm/arm/pvtime.rst
>> index 687b60d..94bffe2 100644
>> --- a/Documentation/virt/kvm/arm/pvtime.rst
>> +++ b/Documentation/virt/kvm/arm/pvtime.rst
>> @@ -3,7 +3,7 @@
>>  Paravirtualized time support for arm64
>>  ======================================
>>
>> -Arm specification DEN0057/A defines a standard for paravirtualised time
>> +Arm specification DEN0057/A defines a standard for paravirtualized time
>>  support for AArch64 guests:
> 
> nit: I do object to this change (some of us are British! ;-).
Oh, I will pay attention to this. Thanks!

Keqian
> 
>         M.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
