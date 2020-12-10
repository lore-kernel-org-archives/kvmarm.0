Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF99C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 11:16:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7344E23B85
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 11:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7344E23B85
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A29D64B1DF;
	Thu, 10 Dec 2020 06:16:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zoA6K19zHY14; Thu, 10 Dec 2020 06:16:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 617EA4B132;
	Thu, 10 Dec 2020 06:16:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B92354B132
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 06:16:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GP36SzgFelhC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 06:16:46 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 833AE4B12A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 06:16:46 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1823C23B85;
 Thu, 10 Dec 2020 11:16:45 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1knJwA-0003gm-VZ; Thu, 10 Dec 2020 11:16:43 +0000
MIME-Version: 1.0
Date: Thu, 10 Dec 2020 11:16:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Don't access PMCR_EL0 when no PMU is available
In-Reply-To: <41fab19e-1e6d-f39b-c0a8-d4a1e54fc9b9@arm.com>
References: <20201210083059.1277162-1-maz@kernel.org>
 <41fab19e-1e6d-f39b-c0a8-d4a1e54fc9b9@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <ce2301d5ca78e35cd05aca54b14e141a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kernel-team@android.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alex,

Thanks for looking at this.

On 2020-12-10 10:12, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 12/10/20 8:30 AM, Marc Zyngier wrote:
>> We reset the guest's view of PMCR_EL0 unconditionally, based on
>> the host's view of this register. It is however legal for an
>> imnplementation not to provide any PMU, resulting in an UNDEF.
>> 
>> The obvious fix is to skip the reset of this shadow register
>> when no PMU is available, sidestepping the issue entirely.
>> If no PMU is available, the guest is not able to request
>> a virtual PMU anyway, so not doing nothing is the right thing
>> to do!
>> 
>> It is unlikely that this bug can hit any HW implementation
>> though, as they all provide a PMU. It has been found using nested
>> virt with the host KVM not implementing the PMU itself.
>> 
>> Fixes: ab9468340d2bc ("arm64: KVM: Add access handler for PMCR 
>> register")
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index bc15246775d0..6c64d010102b 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -923,6 +923,10 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, 
>> const struct sys_reg_desc *r)
>>  {
>>  	u64 pmcr, val;
>> 
>> +	/* No PMU available, PMCR_EL0 may UNDEF... */
>> +	if (!kvm_arm_support_pmu_v3())
>> +		return;
>> +
> 
> reset_pmcr() is called from kvm_reset_vcpu()->kvm_reset_sys_regs().
> Before calling kvm_reset_sys_regs(), kvm_reset_vcpu() returns -EINVAL
> if the VCPU has the PMUv3 feature but the host doesn't have a PMU.
> 
> It looks to me like the undef can happen only when the VCPU feature
> isn't set and the hardware doesn't have a PMU.

Which is exactly what I describe in the commit message (NV without PMU).

> How about we change
> the test to check for kvm_vcpu_has_pmu() to avoid executing the extra
> instructions, which are not needed because the VM won't have a PMU?

I went down that road initially, and then realised that we need to
backport this as far back as 4.9 (the code was merged in 4.6).
I don't fancy backporting kvm_vcpu_has_pmu() and co...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
