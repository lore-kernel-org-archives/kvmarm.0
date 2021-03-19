Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB366C433C1
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 16:51:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46AF561963
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 16:51:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46AF561963
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB0B44B666;
	Fri, 19 Mar 2021 12:51:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Os78cNh6SVnu; Fri, 19 Mar 2021 12:51:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 072D94B65D;
	Fri, 19 Mar 2021 12:51:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6F04B623
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:51:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J5sJ9TI2gIah for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 12:51:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC5F64B437
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:51:49 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A1A3C61942;
 Fri, 19 Mar 2021 16:51:48 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lNILi-002f1c-HM; Fri, 19 Mar 2021 16:51:46 +0000
MIME-Version: 1.0
Date: Fri, 19 Mar 2021 16:51:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 05/11] arm64: sve: Provide a conditional update
 accessor for ZCR_ELx
In-Reply-To: <20210319164236.GH5619@sirena.org.uk>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-6-maz@kernel.org>
 <20210319164236.GH5619@sirena.org.uk>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <45a7868d83eaaef2e5d0f6e730c9c8f2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: broonie@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, dave.martin@arm.com,
 daniel.kiss@arm.com, will@kernel.org, catalin.marinas@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 ascull@google.com, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will@kernel.org>, dave.martin@arm.com,
 linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On 2021-03-19 16:42, Mark Brown wrote:
> On Thu, Mar 18, 2021 at 12:25:26PM +0000, Marc Zyngier wrote:
> 
>> A common pattern is to conditionally update ZCR_ELx in order
>> to avoid the "self-synchronizing" effect that writing to this
>> register has.
>> 
>> Let's provide an accessor that does exactly this.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> 
>> +#define sve_cond_update_zcr_vq(val, reg)		\
>> +	do {						\
>> +		u64 __zcr = read_sysreg_s((reg));	\
>> +		u64 __new = __zcr & ~ZCR_ELx_LEN_MASK;	\
>> +		__new |= (val) & ZCR_ELx_LEN_MASK;	\
>> +		if (__zcr != __new)			\
>> +			write_sysreg_s(__new, (reg));	\
>> +	} while (0)
>> +
> 
> Do compilers actually do much better with this than with a static
> inline like the other functions in this header?  Seems like something
> they should be figuring out.

It's not about performance or anything of the sort: in most cases
where we end-up using this, it is on the back of an exception.
So performance is the least of our worries.

However, the "reg" parameter to read/write_sysreg_s() cannot
be a variable, because it is directly fed to the assembler.
If you want to use functions, you need to specialise them per
register. At this point, I'm pretty happy with a #define.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
