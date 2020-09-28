Return-Path: <SRS0=JNaZ=DF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F306BC2D0A8
	for <kvmarm@archiver.kernel.org>; Mon, 28 Sep 2020 11:53:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EFD72074A
	for <kvmarm@archiver.kernel.org>; Mon, 28 Sep 2020 11:53:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlhtVwXA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EFD72074A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55ABF4B1D8;
	Mon, 28 Sep 2020 07:53:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HW7rHAiLVfSl; Mon, 28 Sep 2020 07:53:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87CD54B1DC;
	Mon, 28 Sep 2020 07:53:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 704864B1D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Sep 2020 07:52:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zdp4Km78lV7T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Sep 2020 07:52:57 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71D6A4B1D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Sep 2020 07:52:57 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 000D32073A;
 Mon, 28 Sep 2020 11:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601293976;
 bh=a1vnj/lOL92jucvsZifddmqgkqyT39OHtF9OtdEHg40=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=QlhtVwXAfAu9/R1RhHAv//UrM/DsOcG8H9+jPUmeQ2cnk655soEAKSo8bJJBKMCnq
 H8vENJWKIMfPJC91vmtoqQ2U+cI/rZKvB6iYd0kVF8IeJ6TRe6Cp8VDtRtaP2UbYgq
 LyPihnhOX64DsxMhVx783ReUSvASKv+pM1dWQh3I=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kMriA-00FT5q-4e; Mon, 28 Sep 2020 12:52:54 +0100
MIME-Version: 1.0
Date: Mon, 28 Sep 2020 12:52:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Hide unsupported MPAM from the guest
In-Reply-To: <20200926094809.f5boi5c3bnptsa7x@kamzik.brq.redhat.com>
References: <20200925160102.118858-1-james.morse@arm.com>
 <20200926094809.f5boi5c3bnptsa7x@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <d334762f56f97c4735168558dd1a5e11@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, james.morse@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 catalin.marinas@arm.com, will@kernel.org, anshuman.khandual@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

On 2020-09-26 10:48, Andrew Jones wrote:
> On Fri, Sep 25, 2020 at 05:01:02PM +0100, James Morse wrote:
>> Commit 011e5f5bf529 ("arm64/cpufeature: Add remaining feature bits in
>> ID_AA64PFR0 register") proactively added published features to the
>> cpufeature id registers.
>> 
>> If the platform supports these features, they are visible in the
>> sanitised ID registers that are exposed to KVM guests. This is a
>> problem as KVM doesn't support MPAM.
>> 
>> The hardware reset behaviour of MPAM is to be disabled at EL3. It
>> is unlikely anyone would ship a platform without firmware support,
>> the necessary initialisation has been upstream in the TF-A project
>> for over a year.
>> 
>> Firmware configures the EL2 registers to trap EL1 and EL0 access
>> to EL2. As KVM doesn't support MPAM, it doesn't change these
>> registers. Booting an MPAM capable kernel as a guest of mainline
>> causes KVM to take an unknown trap from an EL1 guest, and inject
>> an undef in response:
>> host:
>> | kvm [126]: Unsupported guest sys_reg access at: ffff800010093f24 
>> [00000005]
>> |  { Op0( 3), Op1( 0), CRn(10), CRm( 5), Op2( 0), func_read },
>> 
>> guest:
>> | ------------[ cut here ]------------
>> | kernel BUG at arch/arm64/kernel/traps.c:409!
>> | Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
>> | Modules linked in:
>> | CPU: 0 PID: 1 Comm: swapper/0 Not tainted 
>> 5.6.0-rc1-00152-g570fa7e2d2ad #11605
>> | Hardware name: linux,dummy-virt (DT)
>> | pstate: 00000005 (nzcv daif -PAN -UAO)
>> | pc : do_undefinstr+0x2ec/0x310
>> | lr : do_undefinstr+0x2f8/0x310
>> ...
>> 
>> This is a tad unfair on the guest as KVM said it supported the
>> feature. Mask out the MPAM feature.
>> 
>> Fixes: 011e5f5bf529 ("arm64/cpufeature: Add remaining feature bits in
>> ID_AA64PFR0 register")
>> Cc: <stable@vger.kernel.org>
>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> 
>> ---
>> I'll be back at rc1 with the minimal KVM support to ensure the traps
>> are enabled and handled islently.
>> ---
>>  arch/arm64/kvm/sys_regs.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 077293b5115f..f736791f37ca 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1131,6 +1131,7 @@ static u64 read_id_reg(const struct kvm_vcpu 
>> *vcpu,
>>  		if (!vcpu_has_sve(vcpu))
>>  			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
>>  		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
>> +		val &= ~(0xfUL << ID_AA64PFR0_MPAM_SHIFT);
>>  	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
>>  		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
>>  			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
>> --
>> 2.28.0
>> 
> 
> Hi James,
> 
> Thanks for this fix
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> but, going forward, I think we need a more robust solution to CPU 
> feature
> additions in order to avoid these types of issues. Our current approach 
> is
> to patch KVM to hide features from the guest as we introduce support to
> the [guest] kernel. IOW, we have to remember to maintain a guest CPU
> feature reject-list. And, since that's error-prone, we should do 
> regular
> audits of the reject-list to ensure it's complete. It would be better 
> to
> have an accept-list (all features masked by default) and then only 
> expose
> features as we add the KVM support.

I have started doing that for the NV series [1], as our virtual CPU is 
much
more limited than the HW it runs on. It shouldn't be hard to turn this 
into
something more generic.

However, it doesn't say anything about the traps that can occur as the
architecture grows new extensions. The current position is to always
inject an UNDEF (exactly what James is doing here), but it isn't obvious
to me that it is always the right thing to do. We should probably drop 
the
dmesg screaming and convert it to a trace...

> Maybe we should introduce KVM masks
> for each ID register? Also, regarding the current implementation, do 
> you
> know if a recent audit has been conducted to ensure (now with MPAM) 
> that
> the current feature hiding is complete?

I doubt it is. The number of additions up to ARMv8.6 is huge, and 
someone
would need to carefully comb it and test it on FVP with all the possible
architectural knobs turned in various ways...

Thanks,

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/nv-5.10-WIP&id=1669f02ebf8e0aa932549d9487ed6b4258351943
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
