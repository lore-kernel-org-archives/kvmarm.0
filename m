Return-Path: <SRS0=HYBR=UR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9306EC31E5B
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jun 2019 15:05:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5621421479
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jun 2019 15:05:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5621421479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2B934A4FB;
	Tue, 18 Jun 2019 11:05:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id moXqBzBNZ690; Tue, 18 Jun 2019 11:05:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 836B34A4FD;
	Tue, 18 Jun 2019 11:05:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24B804A4FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jun 2019 11:05:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aPZl6W4Eu+AL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jun 2019 11:05:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C8A04A47A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jun 2019 11:05:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27C852B;
 Tue, 18 Jun 2019 08:05:32 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EB583F718;
 Tue, 18 Jun 2019 08:05:31 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Skip more of the SError vaxorcism
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
References: <20190610163034.116151-1-james.morse@arm.com>
 <1d806015-bbad-c2dd-2ff6-2a5bdb73e117@arm.com>
From: James Morse <james.morse@arm.com>
Message-ID: <beb104a9-b7bb-399a-7f41-3072d5e0c001@arm.com>
Date: Tue, 18 Jun 2019 16:05:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1d806015-bbad-c2dd-2ff6-2a5bdb73e117@arm.com>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>
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

On 10/06/2019 17:58, Marc Zyngier wrote:
> On 10/06/2019 17:30, James Morse wrote:
>> During __guest_exit() we need to consume any SError left pending by the
>> guest so it doesn't contaminate the host. With v8.2 we use the
>> ESB-instruction. For systems without v8.2, we use dsb+isb and unmask
>> SError. We do this on every guest exit.
>>
>> Use the same dsb+isr_el1 trick, this lets us know if an SError is pending
>> after the dsb, allowing us to skip the isb and self-synchronising PSTATE
>> write if its not.
>>
>> This means SError remains masked during KVM's world-switch, so any SError
>> that occurs during this time is reported by the host, instead of causing
>> a hyp-panic.
> 
> Ah, that'd be pretty good.

I'll add a patch to re-mask it so this intent is clear, and the behaviour/performance
stuff is done in separate patches.


>> If you give gcc likely()/unlikely() hints in an if() condition, it
>> shuffles the generated assembly so that the likely case is immediately
>> after the branch. Lets do the same here.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> ---
>> This patch was previously posted as part of:
>> [v1] https://lore.kernel.org/linux-arm-kernel/20190604144551.188107-1-james.morse@arm.com/
>>
>>  arch/arm64/kvm/hyp/entry.S | 14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
>> index a5a4254314a1..c2de1a1faaf4 100644
>> --- a/arch/arm64/kvm/hyp/entry.S
>> +++ b/arch/arm64/kvm/hyp/entry.S
>> @@ -161,18 +161,24 @@ alternative_if ARM64_HAS_RAS_EXTN
>>  	orr	x0, x0, #(1<<ARM_EXIT_WITH_SERROR_BIT)
>>  1:	ret
>>  alternative_else
>> -	// If we have a pending asynchronous abort, now is the
>> -	// time to find out. From your VAXorcist book, page 666:
>> +	dsb	sy		// Synchronize against in-flight ld/st
>> +	mrs	x2, isr_el1
> 
> The CPU is allowed to perform a system register access before the DSB
> completes if it doesn't have a side effect. Reading ISR_EL1 doesn't have
> such side effect, so you could end-up missing the abort. An ISB after
> DSB should cure that,

... bother ...


> but you'll need to verify that it doesn't make
> things much worse than what we already have.

Retested with isb in both patches, and Robin's better assembly.

This still saves the self-synchronising pstate modification, (of which we'd need two if we
want to keep SError masked over the rest of world-switch)

On Xgene:
| 5.2.0-rc2-00006-g9b94314 mean:3215 stddev:45
| 5.2.0-rc2-00007-g5d37b0b mean:3176 stddev:30
| with this patch 1.23% faster

On Seattle:
| 5.2.0-rc2-00006-g9b9431445730 mean:4474 stddev:10
| 5.2.0-rc2-00007-g5d37b0b5dd65 mean:4410 stddev:27
| with this patch: 1.44% faster


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
