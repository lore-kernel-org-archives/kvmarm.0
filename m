Return-Path: <SRS0=uVDJ=WE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19287C433FF
	for <kvmarm@archiver.kernel.org>; Thu,  8 Aug 2019 15:49:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A47E82173E
	for <kvmarm@archiver.kernel.org>; Thu,  8 Aug 2019 15:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A47E82173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 081EB4A588;
	Thu,  8 Aug 2019 11:49:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x-k7RZvoqA7y; Thu,  8 Aug 2019 11:49:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFA1D4A57B;
	Thu,  8 Aug 2019 11:49:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBCB14A57A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Aug 2019 11:49:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nh3w2pGG-H85 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Aug 2019 11:49:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC9B24A53D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Aug 2019 11:49:48 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 593D01596;
 Thu,  8 Aug 2019 08:49:48 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 A5E283F706; Thu,  8 Aug 2019 08:49:46 -0700 (PDT)
Subject: Re: [PATCH 9/9] arm64: Retrieve stolen time as paravirtualized guest
To: Steven Price <steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-10-steven.price@arm.com> <20190804105353.5e9824dc@why>
 <dc8a1e56-7b52-cc8f-265d-27eb5f458613@arm.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <7108a70b-dafd-507b-8509-f4a092ef24af@kernel.org>
Date: Thu, 8 Aug 2019 16:49:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <dc8a1e56-7b52-cc8f-265d-27eb5f458613@arm.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 08/08/2019 16:29, Steven Price wrote:
> On 04/08/2019 10:53, Marc Zyngier wrote:
>> On Fri,  2 Aug 2019 15:50:17 +0100
>> Steven Price <steven.price@arm.com> wrote:
>>
>>> Enable paravirtualization features when running under a hypervisor
>>> supporting the PV_TIME_ST hypercall.
>>>
>>> For each (v)CPU, we ask the hypervisor for the location of a shared
>>> page which the hypervisor will use to report stolen time to us. We set
>>> pv_time_ops to the stolen time function which simply reads the stolen
>>> value from the shared page for a VCPU. We guarantee single-copy
>>> atomicity using READ_ONCE which means we can also read the stolen
>>> time for another VCPU than the currently running one while it is
>>> potentially being updated by the hypervisor.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>  arch/arm64/kernel/Makefile |   1 +
>>>  arch/arm64/kernel/kvm.c    | 155 +++++++++++++++++++++++++++++++++++++

[...]

>>> +static int __init kvm_guest_init(void)
>>> +{
>>> +	int ret = 0;
>>> +
>>> +	if (!has_kvm_steal_clock())
>>> +		return 0;
>>> +
>>> +	ret = kvm_arm_init_stolen_time();
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	pv_ops.time.steal_clock = kvm_steal_clock;
>>> +
>>> +	static_key_slow_inc(&paravirt_steal_enabled);
>>> +	if (steal_acc)
>>> +		static_key_slow_inc(&paravirt_steal_rq_enabled);
>>> +
>>> +	pr_info("using stolen time PV\n");
>>> +
>>> +	return 0;
>>> +}
>>> +early_initcall(kvm_guest_init);
>>
>> Is there any reason why we wouldn't directly call into this rather than
>> using an initcall?
> 
> I'm not sure where the direct call would go - any pointers?

I'd be temped to say arch/arm64/kernel/time.c:time_init(), provided that
there is no issue with the CPU hotplug lock (I remember hitting that a
while ago).

	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
