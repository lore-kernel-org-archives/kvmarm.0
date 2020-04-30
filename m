Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DB7C8300A
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 09:16:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C2EE2137B
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 09:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkSkySpd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C2EE2137B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06D604B405;
	Thu, 30 Apr 2020 05:16:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TTHX2MdDEZeA; Thu, 30 Apr 2020 05:16:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE6414B52E;
	Thu, 30 Apr 2020 05:16:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4706F4B403
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 05:16:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fC1ZFsISlFd5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 05:16:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4188B4B405
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 05:16:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 085BA2137B;
 Thu, 30 Apr 2020 09:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588238165;
 bh=ZD3GewpH6XoWQC75apsQplyXgLr4vmSrblW7tvPlipc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=QkSkySpdq/DpTJocgJrrXPQxg8LJpnv+mNnL7dz9tS8lgROrDQulSfnbq+tRV/hG8
 LQ/0WXEPy6Oe7kuQ83haGtZIdgVbL43fOSoTTDt/RiTAEpuNeZErLnw2CzsFUSE5in
 3FBl7iSt9ibSap1/o5sxzGpnWgUQLpd1ANfy40lE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jU5IZ-007ycL-EO; Thu, 30 Apr 2020 10:16:03 +0100
MIME-Version: 1.0
Date: Thu, 30 Apr 2020 10:16:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2] arm64: Unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
In-Reply-To: <20200429212120.GC8604@willie-the-truck>
References: <20200422161346.67325-1-ascull@google.com>
 <20200429212120.GC8604@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <5f391a75142a8ae2263e52d37d73526d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, ascull@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 james.morse@arm.com, suzuki.poulose@arm.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On 2020-04-29 22:21, Will Deacon wrote:
> Hi Andrew,
> 
> On Wed, Apr 22, 2020 at 05:13:46PM +0100, Andrew Scull wrote:
>> Errata 1165522, 1319367 and 1530923 each allow TLB entries to be
>> allocated as a result of a speculative AT instruction. In order to
>> avoid mandating VHE on certain affected CPUs, apply the workaround to
>> both the nVHE and the VHE case for all affected CPUs.
>> 
>> Signed-off-by: Andrew Scull <ascull@google.com>
>> CC: Marc Zyngier <maz@kernel.org>
>> CC: James Morse <james.morse@arm.com>
>> CC: Suzuki K Poulose <suzuki.poulose@arm.com>
>> CC: Will Deacon <will@kernel.org>
>> CC: Steven Price <steven.price@arm.com>
>> ---
>> * From v1 <20200327143941.195626-1-ascull@google.com>:
>>   - Restored registers in VHE path
> 
> This largely looks good to me, but I don't understand these bits:
> 
>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index 8a1e81a400e0..651820f537fb 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
>> @@ -138,7 +138,7 @@ static void __hyp_text 
>> __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>> 
>>  	write_sysreg(val, cptr_el2);
>> 
>> -	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE)) {
>> +	if (cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> 
> It seems like you consistently replace cpus_have_final_cap() with
> cpus_have_const_cap(), but I can't figure out why that's required.

Seems like a bad conflict resolution. We definitely want to keep the
final_cap checks for anything that will run at EL2, and probably
everywhere else (if capabilities are not final by the time we hit KVM,
we have bigger problems to solve).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
