Return-Path: <SRS0=1n5P=4H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF29FC34047
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 09:46:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 747362465D
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 09:46:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jy8hMAFn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 747362465D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DFCC4AED7;
	Wed, 19 Feb 2020 04:46:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n2rZ5qBzDGRk; Wed, 19 Feb 2020 04:46:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C6DF4AEE0;
	Wed, 19 Feb 2020 04:46:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEED84A95D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 04:46:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qmNd-PMYgh6p for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Feb 2020 04:46:14 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D02764AED7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 04:46:14 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 827582465D;
 Wed, 19 Feb 2020 09:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582105573;
 bh=l2TiWhrUXaBuX2+2Pq1CuvcDwByg8tH8hEVRAgq5hpQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Jy8hMAFnB3XFRvcNLvZhdJXbWEmXZdU7Unqf0eGMIV144a2MOFvhbu9venyIdOvj2
 rkgtkUGH02+MrcibimIvj0Kz6a78iEs0Xqp7hHDVaUNJnek0JfdS6VAMHSotnFhp4n
 zhlGK8eUbxmurWOYi8DySyeD13APjhPpWQ2NSYgc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j4Lvn-006TMB-TE; Wed, 19 Feb 2020 09:46:11 +0000
MIME-Version: 1.0
Date: Wed, 19 Feb 2020 09:46:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 3/5] kvm: arm64: Limit PMU version to ARMv8.1
In-Reply-To: <eb0294ef-5ad2-9940-2d59-b92220948ffc@arm.com>
References: <20200216185324.32596-1-maz@kernel.org>
 <20200216185324.32596-4-maz@kernel.org>
 <eb0294ef-5ad2-9940-2d59-b92220948ffc@arm.com>
Message-ID: <c0a848e3ababff4ee9ecaa4b246d5875@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, peter.maydell@linaro.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On 2020-02-18 17:43, James Morse wrote:
> Hi Marc,
> 
> On 16/02/2020 18:53, Marc Zyngier wrote:
>> Our PMU code is only implementing the ARMv8.1 features, so let's
>> stick to this when reporting the feature set to the guest.
> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 682fedd7700f..06b2d0dc6c73 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1093,6 +1093,11 @@ static u64 read_id_reg(const struct kvm_vcpu 
>> *vcpu,
>>  				 FEATURE(ID_AA64ISAR1_GPA) |
>>  				 FEATURE(ID_AA64ISAR1_GPI));
>>  		break;
>> +	case SYS_ID_AA64DFR0_EL1:
>> +		/* Limit PMU to ARMv8.1 */
> 
> Not just limit, but upgrade too! (force?)
> This looks safe because ARMV8_PMU_EVTYPE_EVENT always includes the
> extra bits this added, and the register is always trapped.

That's definitely not what I intended! Let me fix that one.

> The PMU version is also readable via ID_DFR0_EL1.PerfMon, should that
> be sanitised to be the same? (I don't think we've hidden an aarch64
> feature that also existed in aarch32 before).

Indeed, yet another oversight. I'll fix that too.

> Regardless:
> Reviewed-by: James Morse <james.morse@arm.com>

You're way too kind! ;-)

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
