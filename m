Return-Path: <SRS0=diMM=3E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A448C33CB1
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 14:14:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA2022467C
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 14:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfVjmj7K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA2022467C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EBC54B13B;
	Wed, 15 Jan 2020 09:14:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3wkqoCvtl4sG; Wed, 15 Jan 2020 09:14:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3E504B159;
	Wed, 15 Jan 2020 09:14:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61CFA4B141
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 09:14:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id atKk1m2KE+Ci for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jan 2020 09:14:13 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DACC94B120
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 09:14:12 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B7CDC24679;
 Wed, 15 Jan 2020 14:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579097651;
 bh=CaXoAkqOajL0kmg6h715f9PHn0XAZVLVKqsyXgOXacM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=IfVjmj7KSiyixL26Y39CJZiiWPKnwpOP90yCrThZ4afM3dMYPowazyc4h9gC+j/q/
 AW95yu14rcNeC/TEWOUi3I0du1tfRtRn00bWjyiSecTPMTfwJDnMJG09iFY87NdN1S
 yZ3p6nWb+/NtCMwUmPpa43pUBiyDYqjj1Lq8ET1I=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1irjQw-0000fF-2L; Wed, 15 Jan 2020 14:14:10 +0000
MIME-Version: 1.0
Date: Wed, 15 Jan 2020 14:14:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 0/6] KVM: arm64: VCPU preempted check support
In-Reply-To: <20200113121240.GC3260@willie-the-truck>
References: <20191226135833.1052-1-yezengruan@huawei.com>
 <20200113121240.GC3260@willie-the-truck>
Message-ID: <b1d23a82d6a7caa79a99597fb83472be@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, yezengruan@huawei.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 virtualization@lists.linux-foundation.org, james.morse@arm.com,
 linux@armlinux.org.uk, suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com,
 catalin.marinas@arm.com, mark.rutland@arm.com, steven.price@arm.com,
 daniel.lezcano@linaro.org, peterz@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: daniel.lezcano@linaro.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 peterz@infradead.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
 steven.price@arm.com, kvmarm@lists.cs.columbia.edu,
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

On 2020-01-13 12:12, Will Deacon wrote:
> [+PeterZ]
> 
> On Thu, Dec 26, 2019 at 09:58:27PM +0800, Zengruan Ye wrote:
>> This patch set aims to support the vcpu_is_preempted() functionality
>> under KVM/arm64, which allowing the guest to obtain the VCPU is
>> currently running or not. This will enhance lock performance on
>> overcommitted hosts (more runnable VCPUs than physical CPUs in the
>> system) as doing busy waits for preempted VCPUs will hurt system
>> performance far worse than early yielding.
>> 
>> We have observed some performace improvements in uninx benchmark 
>> tests.
>> 
>> unix benchmark result:
>>   host:  kernel 5.5.0-rc1, HiSilicon Kunpeng920, 8 CPUs
>>   guest: kernel 5.5.0-rc1, 16 VCPUs
>> 
>>                test-case                |    after-patch    |   
>> before-patch
>> ----------------------------------------+-------------------+------------------
>>  Dhrystone 2 using register variables   | 334600751.0 lps   | 
>> 335319028.3 lps
>>  Double-Precision Whetstone             |     32856.1 MWIPS |     
>> 32849.6 MWIPS
>>  Execl Throughput                       |      3662.1 lps   |      
>> 2718.0 lps
>>  File Copy 1024 bufsize 2000 maxblocks  |    432906.4 KBps  |    
>> 158011.8 KBps
>>  File Copy 256 bufsize 500 maxblocks    |    116023.0 KBps  |     
>> 37664.0 KBps
>>  File Copy 4096 bufsize 8000 maxblocks  |   1432769.8 KBps  |    
>> 441108.8 KBps
>>  Pipe Throughput                        |   6405029.6 lps   |   
>> 6021457.6 lps
>>  Pipe-based Context Switching           |    185872.7 lps   |    
>> 184255.3 lps
>>  Process Creation                       |      4025.7 lps   |      
>> 3706.6 lps
>>  Shell Scripts (1 concurrent)           |      6745.6 lpm   |      
>> 6436.1 lpm
>>  Shell Scripts (8 concurrent)           |       998.7 lpm   |       
>> 931.1 lpm
>>  System Call Overhead                   |   3913363.1 lps   |   
>> 3883287.8 lps
>> ----------------------------------------+-------------------+------------------
>>  System Benchmarks Index Score          |      1835.1       |      
>> 1327.6
> 
> Interesting, thanks for the numbers.
> 
> So it looks like there is a decent improvement to be had from targetted 
> vCPU
> wakeup, but I really dislike the explicit PV interface and it's already 
> been
> shown to interact badly with the WFE-based polling in 
> smp_cond_load_*().
> 
> Rather than expose a divergent interface, I would instead like to 
> explore an
> improvement to smp_cond_load_*() and see how that performs before we 
> commit
> to something more intrusive. Marc and I looked at this very briefly in 
> the
> past, and the basic idea is to register all of the WFE sites with the
> hypervisor, indicating which register contains the address being spun 
> on
> and which register contains the "bad" value. That way, you don't bother
> rescheduling a vCPU if the value at the address is still bad, because 
> you
> know it will exit immediately.
> 
> Of course, the devil is in the details because when I say "address", 
> that's
> a guest virtual address, so you need to play some tricks in the 
> hypervisor
> so that you have a separate mapping for the lockword (it's enough to 
> keep
> track of the physical address).
> 
> Our hacks are here but we basically ran out of time to work on them 
> beyond
> an unoptimised and hacky prototype:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy
> 
> Marc -- how would you prefer to handle this?

Let me try and rebase this thing to a modern kernel (I doubt it applies 
without
conflicts to mainline). We can then have discussion about its merit on 
the list
once I post it. It'd be good to have a pointer to the benchamrks that 
have been
used here.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
