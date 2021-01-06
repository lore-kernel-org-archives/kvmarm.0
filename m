Return-Path: <SRS0=pXP7=GJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F4BC433DB
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 06:55:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78EA123101
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 06:55:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78EA123101
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD3144B30A;
	Wed,  6 Jan 2021 01:55:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MDGLUaSfiHV6; Wed,  6 Jan 2021 01:55:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3754B2FC;
	Wed,  6 Jan 2021 01:55:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E49D74B2D3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 01:55:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MM1p3SR1-K+5 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jan 2021 01:55:49 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDB6D4B2BD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 01:55:48 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D9g8z4lfjzhwZb;
 Wed,  6 Jan 2021 14:54:59 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Wed, 6 Jan 2021 14:55:36 +0800
Subject: Re: [PATCH v2 0/8] KVM: arm64: Support HW dirty log based on DBM
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
References: <20200702135556.36896-1-zhukeqian1@huawei.com>
 <e120ec04-24d5-f1cb-3aa2-8baf3d6da1db@huawei.com>
 <015847afd67e8bd4f8a158b604854838@kernel.org>
 <4eee3e4c-db73-c4ce-ca3d-d665ee87d66a@huawei.com>
 <87mu43xy94.wl-maz@kernel.org>
 <884bd32d-c8ba-6237-82f6-1769a83289f5@huawei.com>
 <2a81b2a0e1bd1e7523760a8074b9ec6e@kernel.org>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <fd26654b-8258-061c-2a69-90b961c1c71b@huawei.com>
Date: Wed, 6 Jan 2021 14:55:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <2a81b2a0e1bd1e7523760a8074b9ec6e@kernel.org>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu
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

Hi Marc, Catalin,

I'd like to propose a new dirty tracking solution that combines hardware based
dirty tracking (DBM) and software based dirty tracking (memory abort). Hope to
get your opinions about it.

The core idea is that we do not enable hardware dirty at start (do not add DBM bit).
When a arbitrary PT occurs fault, we execute soft tracking for this PT and enable
hardware tracking for its *nearby* PTs (e.g. Add DBM bit for nearby 16PTs). Then when
sync dirty log, we have known all PTs with hardware dirty enabled, so we do not need
to scan all PTs.

We may worry that when dirty rate is over-high we still need to scan too much PTs.
We mainly concern the VM stop time. With Qemu dirty rate throttling, the dirty memory
is closing to the VM stop threshold, so there is a little PTs to scan after VM stop.

It has the advantages of hardware tracking that minimizes side effect on vCPU,
and also has the advantages of software tracking that controls vCPU dirty rate.
Moreover, software tracking helps us to scan PTs at some fixed points, which
greatly reduces scanning time. And the biggest benefit is that we can apply this
solution for dma dirty tracking.

Thanks,
Keqian


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
> 
> Honestly, I think you are looking at the problem the wrong way.
> DBM at S2 is not a solution to anything, because the information is
> way too sparse, and  it doesn't solve the real problem, which is
> the tracking of dirty pages caused by devices.
> 
> As I said twice before, I will not consider these patches without
> a solution to the DMA problem, and I don't think DBM is part of
> that solution.
> 
> Thanks,
> 
>         M.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
