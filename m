Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECC9C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 10:48:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EEF922515
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 10:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EEF922515
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81CC04B309;
	Tue,  5 Jan 2021 05:48:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id va2UYcjfBvRA; Tue,  5 Jan 2021 05:48:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6697D4B30D;
	Tue,  5 Jan 2021 05:48:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41FB14B30D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 05:48:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YK61+JGAbKb5 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 05:48:29 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4647A4B309
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 05:48:29 -0500 (EST)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D98Mj740dz15nlp;
 Tue,  5 Jan 2021 18:47:29 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 18:48:18 +0800
Subject: Re: [PATCH] arm64/smp: Remove unused variable irq in
 arch_show_interrupts()
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210105092221.15144-1-zhukeqian1@huawei.com>
 <20210105100847.GB11802@gaia>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <ebbe8da6-bd81-f43c-8bda-cc302657d6f3@huawei.com>
Date: Tue, 5 Jan 2021 18:48:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210105100847.GB11802@gaia>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>
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



On 2021/1/5 18:08, Catalin Marinas wrote:
> On Tue, Jan 05, 2021 at 05:22:21PM +0800, Keqian Zhu wrote:
>> The local variable irq is added in commit a26388152531 ("arm64:
>> Remove custom IRQ stat accounting"), but forget to remove in
>> commit 5089bc51f81f ("arm64/smp: Use irq_desc_kstat_cpu() in
>> arch_show_interrupts()"). Just remove it.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> 
> I already queued a similar fix in arm64 for-next/fixes (it should appear
> in linux-next at some point).
> 
OK, I see. Thanks.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
