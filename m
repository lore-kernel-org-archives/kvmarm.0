Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97133C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 09:50:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E788F64F58
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 09:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E788F64F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62B4D4B2DA;
	Thu,  4 Feb 2021 04:50:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LvMqef7Spa9P; Thu,  4 Feb 2021 04:50:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 459414B323;
	Thu,  4 Feb 2021 04:50:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65F4B4B303
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 04:50:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mJktZLft-3AK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 04:50:05 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57B2B4B2DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 04:50:05 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1C02664D9F;
 Thu,  4 Feb 2021 09:50:04 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l7bGz-00Bxau-V2; Thu, 04 Feb 2021 09:50:02 +0000
MIME-Version: 1.0
Date: Thu, 04 Feb 2021 09:50:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v6 06/21] arm64: Move VHE-specific SPE setup to
 mutate_to_vhe()
In-Reply-To: <20210204093427.GB20244@willie-the-truck>
References: <20210201115637.3123740-1-maz@kernel.org>
 <20210201115637.3123740-7-maz@kernel.org>
 <20210203211319.GA19694@willie-the-truck>
 <a660fd06d43451b4693fbb65f2ee1b56@kernel.org>
 <20210204093427.GB20244@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <12b87236475ec3e03d78dae620530c60@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
 dbrazdil@google.com, ardb@kernel.org, jingzhangos@google.com,
 pajay@qti.qualcomm.com, psodagud@codeaurora.org, sramana@codeaurora.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 2021-02-04 09:34, Will Deacon wrote:
> On Thu, Feb 04, 2021 at 09:30:08AM +0000, Marc Zyngier wrote:

[...]

>> I think the following patch addresses the above issue, which I'll 
>> squash
>> with the original patch. Please shout if I missed anything.
>> 
>> Thanks,
>> 
>>         M.
>> 
>> diff --git a/arch/arm64/kernel/hyp-stub.S 
>> b/arch/arm64/kernel/hyp-stub.S
>> index aa7e8d592295..3e08dcc924b5 100644
>> --- a/arch/arm64/kernel/hyp-stub.S
>> +++ b/arch/arm64/kernel/hyp-stub.S
>> @@ -115,29 +115,9 @@ SYM_CODE_START_LOCAL(mutate_to_vhe)
>>  	mrs_s	x0, SYS_VBAR_EL12
>>  	msr	vbar_el1, x0
>> 
>> -	// Fixup SPE configuration, if supported...
>> -	mrs	x1, id_aa64dfr0_el1
>> -	ubfx	x1, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
>> -	mov	x2, xzr
>> -	cbz	x1, skip_spe
>> -
>> -	// ... and not owned by EL3
>> -	mrs_s	x0, SYS_PMBIDR_EL1
>> -	and	x0, x0, #(1 << SYS_PMBIDR_EL1_P_SHIFT)
>> -	cbnz	x0, skip_spe
>> -
>> -	// Let the SPE driver in control of the sampling
>> -	mrs_s	x0, SYS_PMSCR_EL1
>> -	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PCT_SHIFT)
>> -	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PA_SHIFT)
>> -	msr_s	SYS_PMSCR_EL1, x0
>> -	mov	x2, #MDCR_EL2_TPMS
>> -
>> -skip_spe:
>> -	// For VHE, use EL2 translation and disable access from EL1
>> +	// Use EL2 translations for SPE and disable access from EL1
>>  	mrs	x0, mdcr_el2
>>  	bic	x0, x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
>> -	orr	x0, x0, x2
>>  	msr	mdcr_el2, x0
> 
> Looks a tonne better, thanks! Be nice if somebody could test it for us.

SPE-equipped machines are the silicon equivalent of hen's teeth...

Alex, any chance you could give this a go?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
