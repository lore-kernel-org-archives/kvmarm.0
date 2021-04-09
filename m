Return-Path: <SRS0=dNnP=JG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C99FC433ED
	for <kvmarm@archiver.kernel.org>; Fri,  9 Apr 2021 08:59:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80174611AB
	for <kvmarm@archiver.kernel.org>; Fri,  9 Apr 2021 08:59:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80174611AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D42444B5BD;
	Fri,  9 Apr 2021 04:59:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9xLsLFg7Odcv; Fri,  9 Apr 2021 04:59:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD3F64B674;
	Fri,  9 Apr 2021 04:59:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D1764A4E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Apr 2021 04:59:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uQSpcjuzx9TM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Apr 2021 04:59:13 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 566E84B599
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Apr 2021 04:59:13 -0400 (EDT)
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FGsRF3G8zzWV6R;
 Fri,  9 Apr 2021 16:55:37 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 9 Apr 2021 16:59:09 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 16:59:08 +0800
Subject: Re: [PATCH v4 1/2] KVM: arm64: Move CMOs from user_mem_abort to the
 fault handlers
To: Quentin Perret <qperret@google.com>
References: <20210409033652.28316-1-wangyanan55@huawei.com>
 <20210409033652.28316-2-wangyanan55@huawei.com> <YHALa38PPQBceqF9@google.com>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <67c497cc-5a74-e431-a9bc-d05582998bbe@huawei.com>
Date: Fri, 9 Apr 2021 16:59:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YHALa38PPQBceqF9@google.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Quentin,

On 2021/4/9 16:08, Quentin Perret wrote:
> Hi Yanan,
>
> On Friday 09 Apr 2021 at 11:36:51 (+0800), Yanan Wang wrote:
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> +static void stage2_invalidate_icache(void *addr, u64 size)
>> +{
>> +	if (icache_is_aliasing()) {
>> +		/* Flush any kind of VIPT icache */
>> +		__flush_icache_all();
>> +	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
>> +		/* PIPT or VPIPT at EL2 */
>> +		invalidate_icache_range((unsigned long)addr,
>> +					(unsigned long)addr + size);
>> +	}
>> +}
>> +
> I would recommend to try and rebase this patch on kvmarm/next because
> we've made a few changes in pgtable.c recently. It is now linked into
> the EL2 NVHE code which means there are constraints on what can be used
> from there -- you'll need a bit of extra work to make some of these
> functions available to EL2.
I see, thanks for reminding me this.
I will work on kvmarm/next and send a new version later.

Thanks,
Yanan
>
> Thanks,
> Quentin
> .
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
