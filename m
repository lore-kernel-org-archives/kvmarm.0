Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A43FC433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 09:30:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C35E964F55
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 09:30:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C35E964F55
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 324D14B2F6;
	Thu,  4 Feb 2021 04:30:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TkzcqDUXfhJs; Thu,  4 Feb 2021 04:30:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 036354B31D;
	Thu,  4 Feb 2021 04:30:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 856B24B2F6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 04:30:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wf-q1C13l8V4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 04:30:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30E414B2DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 04:30:12 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A01DA64F48;
 Thu,  4 Feb 2021 09:30:10 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l7axk-00BwvW-Bz; Thu, 04 Feb 2021 09:30:08 +0000
MIME-Version: 1.0
Date: Thu, 04 Feb 2021 09:30:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 06/21] arm64: Move VHE-specific SPE setup to
 mutate_to_vhe()
In-Reply-To: <20210203211319.GA19694@willie-the-truck>
References: <20210201115637.3123740-1-maz@kernel.org>
 <20210201115637.3123740-7-maz@kernel.org>
 <20210203211319.GA19694@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <a660fd06d43451b4693fbb65f2ee1b56@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, mark.rutland@arm.com, dbrazdil@google.com,
 alexandru.elisei@arm.com, ardb@kernel.org, jingzhangos@google.com,
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

Hi Will,

On 2021-02-03 21:13, Will Deacon wrote:
> Hi Marc,
> 
> On Mon, Feb 01, 2021 at 11:56:22AM +0000, Marc Zyngier wrote:
>> There isn't much that a VHE kernel needs on top of whatever has
>> been done for nVHE, so let's move the little we need to the
>> VHE stub (the SPE setup), and drop the init_el2_state macro.
>> 
>> No expected functional change.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Acked-by: David Brazdil <dbrazdil@google.com>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> ---
>>  arch/arm64/kernel/hyp-stub.S | 28 +++++++++++++++++++++++++---
>>  1 file changed, 25 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/arm64/kernel/hyp-stub.S 
>> b/arch/arm64/kernel/hyp-stub.S
>> index 373ed2213e1d..6b5c73cf9d52 100644
>> --- a/arch/arm64/kernel/hyp-stub.S
>> +++ b/arch/arm64/kernel/hyp-stub.S
>> @@ -92,9 +92,6 @@ SYM_CODE_START_LOCAL(mutate_to_vhe)
>>  	msr	hcr_el2, x0
>>  	isb
>> 
>> -	// Doesn't do much on VHE, but still, worth a shot
>> -	init_el2_state vhe
>> -
>>  	// Use the EL1 allocated stack, per-cpu offset
>>  	mrs	x0, sp_el1
>>  	mov	sp, x0
>> @@ -107,6 +104,31 @@ SYM_CODE_START_LOCAL(mutate_to_vhe)
>>  	mrs_s	x0, SYS_VBAR_EL12
>>  	msr	vbar_el1, x0
>> 
>> +	// Fixup SPE configuration, if supported...
>> +	mrs	x1, id_aa64dfr0_el1
>> +	ubfx	x1, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
>> +	mov	x2, xzr
>> +	cbz	x1, skip_spe
>> +
>> +	// ... and not owned by EL3
>> +	mrs_s	x0, SYS_PMBIDR_EL1
>> +	and	x0, x0, #(1 << SYS_PMBIDR_EL1_P_SHIFT)
>> +	cbnz	x0, skip_spe
>> +
>> +	// Let the SPE driver in control of the sampling
>> +	mrs_s	x0, SYS_PMSCR_EL1
>> +	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PCT_SHIFT)
>> +	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PA_SHIFT)
>> +	msr_s	SYS_PMSCR_EL1, x0
> 
> Why do we need to touch pmscr_el1 at all? The SPE driver should take 
> care of
> that, no? If you drop the pmscr_el1 accesses, I think you can drop the
> pmbidr_el1 check as well.

That's definitely a brain fart, and is what we need on the nVHE path,
not here. Doing the same thing twice isn't exactly helpful.

> And actually, then why even check dfr0? Doing the
> bic for the mdcr_el1.e2pb bits is harmless.
> 
>> +	mov	x2, #MDCR_EL2_TPMS
>> +
>> +skip_spe:
>> +	// For VHE, use EL2 translation and disable access from EL1
>> +	mrs	x0, mdcr_el2
>> +	bic	x0, x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
>> +	orr	x0, x0, x2
>> +	msr	mdcr_el2, x0
> 
> Doesn't this undo the setting of mdcr_el2.hpmn if SPE is not present or
> unavailable? (This wouldn't be an issue if we removed the skip_spe 
> paths
> altogether).

I don't think it does. We only clear the E2PB bits (harmless, as you 
point
out above), and OR something that is either 0 (no SPE) or MDCR_EL2_TPMS.
In any case, the HPMN bits are preserved (having been set during the 
nVHE
setup).

I think the following patch addresses the above issue, which I'll squash
with the original patch. Please shout if I missed anything.

Thanks,

         M.

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index aa7e8d592295..3e08dcc924b5 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -115,29 +115,9 @@ SYM_CODE_START_LOCAL(mutate_to_vhe)
  	mrs_s	x0, SYS_VBAR_EL12
  	msr	vbar_el1, x0

-	// Fixup SPE configuration, if supported...
-	mrs	x1, id_aa64dfr0_el1
-	ubfx	x1, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
-	mov	x2, xzr
-	cbz	x1, skip_spe
-
-	// ... and not owned by EL3
-	mrs_s	x0, SYS_PMBIDR_EL1
-	and	x0, x0, #(1 << SYS_PMBIDR_EL1_P_SHIFT)
-	cbnz	x0, skip_spe
-
-	// Let the SPE driver in control of the sampling
-	mrs_s	x0, SYS_PMSCR_EL1
-	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PCT_SHIFT)
-	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PA_SHIFT)
-	msr_s	SYS_PMSCR_EL1, x0
-	mov	x2, #MDCR_EL2_TPMS
-
-skip_spe:
-	// For VHE, use EL2 translation and disable access from EL1
+	// Use EL2 translations for SPE and disable access from EL1
  	mrs	x0, mdcr_el2
  	bic	x0, x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
-	orr	x0, x0, x2
  	msr	mdcr_el2, x0

  	// Transfer the MM state from EL1 to EL2

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
