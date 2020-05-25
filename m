Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC20CC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 15:45:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 343732078B
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 15:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jaImQu0p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 343732078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE5B14B1F3;
	Mon, 25 May 2020 11:44:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sXBegHS9CdS3; Mon, 25 May 2020 11:44:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA8144B1F9;
	Mon, 25 May 2020 11:44:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E91C54B1F0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 11:44:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BQi40DuNTdvS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 11:44:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C68D44B170
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 11:44:56 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A22992071C;
 Mon, 25 May 2020 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590421495;
 bh=r8OCSimYRde1NwHA/0Q7MB3/3zxYFYjrUXrzd9tKjr8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=jaImQu0pAsogF1OmK8r3Cbbzn3J1P85LmElRGOIs0VgCmyozC8RrwHIJ+DIMyUnqi
 NK2HPQuQAhIlUiOnqaBmX54A14oy1kBZO0SYrzxnu7F/qhagrMQENb5MLd6dYplEBc
 L86U2sMjEGtzOnzFmM953wVFfjZpoYxQR8Q8TczU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jdFHZ-00FCGg-VI; Mon, 25 May 2020 16:44:54 +0100
MIME-Version: 1.0
Date: Mon, 25 May 2020 16:44:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [RFC PATCH 0/7] kvm: arm64: Support stage2 hardware DBM
In-Reply-To: <20200525112406.28224-1-zhukeqian1@huawei.com>
References: <20200525112406.28224-1-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <4b8a939172395bf38e581634abecf925@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, sean.j.christopherson@intel.com,
 julien.thierry.kdev@gmail.com, broonie@kernel.org, tglx@linutronix.de,
 akpm@linux-foundation.org, alexios.zavras@intel.com,
 wanghaibin.wang@huawei.com, zhengxiang9@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Alexios Zavras <alexios.zavras@intel.com>, Mark Brown <broonie@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
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

On 2020-05-25 12:23, Keqian Zhu wrote:
> This patch series add support for stage2 hardware DBM, and it is only
> used for dirty log for now.
> 
> It works well under some migration test cases, including VM with 4K
> pages or 2M THP. I checked the SHA256 hash digest of all memory and
> they keep same for source VM and destination VM, which means no dirty
> pages is missed under hardware DBM.
> 
> However, there are some known issues not solved.
> 
> 1. Some mechanisms that rely on "write permission fault" become 
> invalid,
>    such as kvm_set_pfn_dirty and "mmap page sharing".
> 
>    kvm_set_pfn_dirty is called in user_mem_abort when guest issues 
> write
>    fault. This guarantees physical page will not be dropped directly 
> when
>    host kernel recycle memory. After using hardware dirty management, 
> we
>    have no chance to call kvm_set_pfn_dirty.

Then you will end-up with memory corruption under memory pressure.
This also breaks things like CoW, which we depend on.

> 
>    For "mmap page sharing" mechanism, host kernel will allocate a new
>    physical page when guest writes a page that is shared with other 
> page
>    table entries. After using hardware dirty management, we have no 
> chance
>    to do this too.
> 
>    I need to do some survey on how stage1 hardware DBM solve these 
> problems.
>    It helps if anyone can figure it out.
> 
> 2. Page Table Modification Races: Though I have found and solved some 
> data
>    races when kernel changes page table entries, I still doubt that 
> there
>    are data races I am not aware of. It's great if anyone can figure 
> them out.
> 
> 3. Performance: Under Kunpeng 920 platform, for every 64GB memory, KVM
>    consumes about 40ms to traverse all PTEs to collect dirty log. It 
> will
>    cause unbearable downtime for migration if memory size is too big. I 
> will
>    try to solve this problem in Patch v1.

This, in my opinion, is why Stage-2 DBM is fairly useless.
 From a performance perspective, this is the worse possible
situation. You end up continuously scanning page tables, at
an arbitrary rate, without a way to evaluate the fault rate.

One thing S2-DBM would be useful for is SVA, where a device
write would mark the S2 PTs dirty as they are shared between
CPU and SMMU. Another thing is SPE, which is essentially a DMA
agent using the CPU's PTs.

But on its own, and just to log the dirty pages, S2-DBM is
pretty rubbish. I wish arm64 had something like Intel's PML,
which looks far more interesting for the purpose of tracking
accesses.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
