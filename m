Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45904C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 08:32:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 04BB220809
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 08:32:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04BB220809
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96F9B4B918;
	Tue, 28 Jul 2020 04:32:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8qeIaictxsu1; Tue, 28 Jul 2020 04:32:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B42B4B858;
	Tue, 28 Jul 2020 04:32:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84F2E4B826
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 04:32:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N3GY+SgqajCu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 04:32:21 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 087474B80D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 04:32:21 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id EAE10C5F6EF27B9C20CC;
 Tue, 28 Jul 2020 16:32:15 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 16:32:07 +0800
Subject: Re: [PATCH v2 0/8] KVM: arm64: Support HW dirty log based on DBM
To: Marc Zyngier <maz@kernel.org>
References: <20200702135556.36896-1-zhukeqian1@huawei.com>
 <e120ec04-24d5-f1cb-3aa2-8baf3d6da1db@huawei.com>
 <015847afd67e8bd4f8a158b604854838@kernel.org>
 <4eee3e4c-db73-c4ce-ca3d-d665ee87d66a@huawei.com>
 <87mu43xy94.wl-maz@kernel.org>
 <884bd32d-c8ba-6237-82f6-1769a83289f5@huawei.com>
 <2a81b2a0e1bd1e7523760a8074b9ec6e@kernel.org>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <ae2636df-2db9-ce8c-6a5f-d307d5a503f0@huawei.com>
Date: Tue, 28 Jul 2020 16:32:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <2a81b2a0e1bd1e7523760a8074b9ec6e@kernel.org>
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

Hi Marc,

On 2020/7/28 15:52, Marc Zyngier wrote:
> On 2020-07-28 03:11, zhukeqian wrote:
>> Hi Marc,
> 
> [...]
> 
>>> But you are still reading the leaf entries of the PTs, hence defeating
>>> any sort of prefetch that the CPU could do for you. And my claim is
>>> that reading the bitmap is much faster than parsing the PTs. Are you
>>> saying that this isn't the case?
>> I am confused here. MMU DBM just updates the S2AP[1] of PTs, so dirty
>> information
>> is not continuous. The smallest granularity of read instruction is one
>> byte, we must
>> read one byte of each PTE to determine whether it is dirty. So I think
>> the smallest
>> reading amount is 512 bytes per 2MB.
> 
> Which is why using DBM as a way to implement dirty-logging doesn't work.
> Forcing the vcpu to take faults in order to update the dirty bitmap
> has the benefit of (a) telling you exactly what page has been written to,
> (b) *slowing the vcpu down*.
> 
> See? no additional read, better convergence ratio because you are not
> trying to catch up with a vcpu running wild. You are in control of the
> dirtying rate, not the vcpu, and the information you get requires no
> extra work (just set the corresponding bit in the dirty bitmap).
OK, in fact I have considered some of these things before. You are right, DBM dirty logging
is not suitable for guest with high dirty rate which even causes Qemu throttling. It only
reduce side-effect of migration on guest with low dirty rate.

I am not meaning to push this defective patch now, instead I am trying to find a software
approach to solve hardware drawback. However, currently we do not have a perfect approach.

> 
> Honestly, I think you are looking at the problem the wrong way.
> DBM at S2 is not a solution to anything, because the information is
> way too sparse, and  it doesn't solve the real problem, which is
> the tracking of dirty pages caused by devices.
> 
> As I said twice before, I will not consider these patches without
> a solution to the DMA problem, and I don't think DBM is part of
> that solution.
For that ARM SMMU HTTU do not have PML like feature, so the behavior of dirty log sync will
be very similar with which of the MMU DBM. My original idea is that we can support MMU DBM
firstly and then support SMMU HTTU based on MMU DBM.

Sure, we can leave this patch here and hope we can pick it up at future if hardware is ready :-) .
Many thanks for your review ;-) .

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
