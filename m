Return-Path: <SRS0=OVIf=MH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F22C07E96
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 09:30:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 388A6613B5
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 09:30:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 388A6613B5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7A9F4A418;
	Thu, 15 Jul 2021 05:30:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R0qHaixvtoBL; Thu, 15 Jul 2021 05:30:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EC674B0AC;
	Thu, 15 Jul 2021 05:30:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8454B0A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 05:30:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LU75w+CwhiX6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jul 2021 05:30:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C01004B092
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 05:30:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60D1E6D;
 Thu, 15 Jul 2021 02:30:27 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 53E593F774;
 Thu, 15 Jul 2021 02:30:26 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: arm64: nVHE: Remove unneeded isb() when
 modifying PMSCR_EL1
To: Will Deacon <will@kernel.org>
References: <20210714095601.184854-1-alexandru.elisei@arm.com>
 <20210714095601.184854-6-alexandru.elisei@arm.com>
 <20210714182036.GA32475@willie-the-truck>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <17eead71-5db4-403c-eff0-e45d9b9f7a31@arm.com>
Date: Thu, 15 Jul 2021 10:31:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210714182036.GA32475@willie-the-truck>
Content-Language: en-US
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On 7/14/21 7:20 PM, Will Deacon wrote:
> On Wed, Jul 14, 2021 at 10:56:01AM +0100, Alexandru Elisei wrote:
>> According to ARM DDI 0487G.a, page D9-2930, profiling is disabled when
>> the PE is executing at a higher exception level than the profiling
>> buffer owning exception level. This is also confirmed by the pseudocode
>> for the StatisticalProfilingEnabled() function.
>>
>> During the world switch and before activating guest traps, KVM executes
>> at EL2 with the buffer owning exception level being EL1 (MDCR_EL2.E2PB =
>> 0b11). As a result, profiling is already disabled when draining the
>> buffer, making the isb() after the write to PMSCR_EL1 unnecessary.
>>
>> CC: Will Deacon <will@kernel.org>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> index 7d3f25868cae..fdf0e0ba17e9 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> @@ -33,7 +33,6 @@ static void __debug_save_spe(u64 *pmscr_el1)
>>  	/* Yes; save the control register and disable data generation */
>>  	*pmscr_el1 = read_sysreg_s(SYS_PMSCR_EL1);
>>  	write_sysreg_s(0, SYS_PMSCR_EL1);
>> -	isb();
> Hmm, but we still need an ISB somewhere between clearing pmscr_el1 and
> mdcr_el2.e2pb, right? Where does that occur?

Yes, we do need an ISB to make sure we don't start profiling using the EL2&0
translation regime, but with a buffer pointer programmed by the host at EL1 which
is most likely not even mapped at EL2.

When I wrote the patch, I reasoned that the ISB in
__sysreg_restore_state_nvhe->__sysreg_restore_el1_state and the isb from
__load_stage2 will make sure that PMSCR_EL1 is cleared before the change to the
buffer owning regime.

As I was double checking that just now, I realized that *both* ISBs are executed
only if the system has ARM64_WORKAROUND_SPECULATIVE_AT. No ISB gets executed when
the workaround is not needed. We could make the ISB here depend on the system not
having the workaround, but it looks to me like there's little to be gained from
that (just one less ISB when the workaround is applied), at the expense of making
the code even more difficult to reason about.

My preference would be to drop this patch.

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
