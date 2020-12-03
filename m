Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92296C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 16:50:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B749F20784
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 16:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B749F20784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D065A4B1B1;
	Thu,  3 Dec 2020 11:50:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NGaYioiS2LQk; Thu,  3 Dec 2020 11:50:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C3D4B181;
	Thu,  3 Dec 2020 11:50:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4004E4B177
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 11:49:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FC9X8zCzhd8w for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 11:49:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2BD94B16C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 11:49:57 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2856011D4;
 Thu,  3 Dec 2020 08:49:57 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 963473F575;
 Thu,  3 Dec 2020 08:49:54 -0800 (PST)
Subject: Re: [PATCH v6 0/2] MTE support for KVM guest
To: Mark Rutland <mark.rutland@arm.com>
References: <20201127152113.13099-1-steven.price@arm.com>
 <20201203160943.GG96754@C02TD0UTHF1T.local>
From: Steven Price <steven.price@arm.com>
Message-ID: <77e65f06-563b-3b30-ab36-9670e8cc03a4@arm.com>
Date: Thu, 3 Dec 2020 16:49:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201203160943.GG96754@C02TD0UTHF1T.local>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On 03/12/2020 16:09, Mark Rutland wrote:
> On Fri, Nov 27, 2020 at 03:21:11PM +0000, Steven Price wrote:
>> It's been a week, and I think the comments on v5 made it clear that
>> enforcing PROT_MTE requirements on the VMM was probably the wrong
>> approach. So since I've got swap working correctly without that I
>> thought I'd post a v6 which hopefully addresses all the comments so far.
>>
>> This series adds support for Arm's Memory Tagging Extension (MTE) to
>> KVM, allowing KVM guests to make use of it. This builds on the existing
>> user space support already in v5.10-rc4, see [1] for an overview.
> 
>>   arch/arm64/include/asm/kvm_emulate.h       |  3 +++
>>   arch/arm64/include/asm/kvm_host.h          |  8 ++++++++
>>   arch/arm64/include/asm/pgtable.h           |  2 +-
>>   arch/arm64/include/asm/sysreg.h            |  3 ++-
>>   arch/arm64/kernel/mte.c                    | 18 +++++++++++++-----
>>   arch/arm64/kvm/arm.c                       |  9 +++++++++
>>   arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 14 ++++++++++++++
>>   arch/arm64/kvm/mmu.c                       | 16 ++++++++++++++++
>>   arch/arm64/kvm/sys_regs.c                  | 20 +++++++++++++++-----
>>   include/uapi/linux/kvm.h                   |  1 +
>>   10 files changed, 82 insertions(+), 12 deletions(-)
> 
> I note that doesn't fixup arch/arm64/kvm/inject_fault.c, where in
> enter_exception64() we have:
> 
> | // TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
> 
> ... and IIUC when MTE is present, TCO should be set when delivering an
> exception, so I believe that needs to be updated to set TCO.

Well spotted! As you say TCO should be set when delivering an exception, 
so we need the following:

-       // TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
+       if (kvm_has_mte(vcpu->kvm))
+               new |= PSR_TCO_BIT;

> Given that MTE-capable HW does that unconditionally, this is going to be
> a mess for big.LITTLE. :/

I'm not sure I follow. Either all CPUs support MTE in which this isn't a 
problem, or the MTE feature just isn't exposed. We don't support a mix 
of MTE and non-MTE CPUs. There are several aspects of MTE which 
effective mean it's an all-or-nothing feature for the system.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
