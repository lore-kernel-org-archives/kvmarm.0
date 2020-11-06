Return-Path: <SRS0=uq+A=EM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D80DC2D0A3
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 10:54:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7873B2072E
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 10:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WThvWAsg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7873B2072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEC754B83B;
	Fri,  6 Nov 2020 05:54:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N1hBTbvv99l0; Fri,  6 Nov 2020 05:54:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 492E64B83E;
	Fri,  6 Nov 2020 05:54:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BF1C4B835
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 05:54:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w2-6eUkRaRsP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2020 05:54:35 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 526024B831
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 05:54:35 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EF03D20724;
 Fri,  6 Nov 2020 10:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604660074;
 bh=OnTmyL0jGfWHius5cIOnjkdLCJl2+U5PH7ORvDNG+NI=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=WThvWAsgUak++vYWiIrwyBjo77fcNOCS3jrGoXZwUy6qsIWOTyVJJMS276U59Wjs0
 VR1pwkfN1pl3eFwHQhg6po8IiZmYDpMMcuBkgTPkI68ZsAJpnmQS64hb8vzaiFB54F
 kF16b9KRsHShzdtWQ39eVnBwwZtIJSJj65MJneTs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kazO3-008A1C-D0; Fri, 06 Nov 2020 10:54:31 +0000
MIME-Version: 1.0
Date: Fri, 06 Nov 2020 10:54:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Rename access_amu() to undef_access()
In-Reply-To: <20201105225020.GE8842@willie-the-truck>
References: <20201103171445.271195-1-maz@kernel.org>
 <20201103171445.271195-3-maz@kernel.org>
 <20201105225020.GE8842@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <48655b6266c39555edc614274d1d9877@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 liangpeng10@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 2020-11-05 22:50, Will Deacon wrote:
> On Tue, Nov 03, 2020 at 05:14:44PM +0000, Marc Zyngier wrote:
>> The only thing that access_amu() does is to inject an UNDEF exception,
>> so let's rename it to the clearer undef_access(). We'll reuse that
>> for some other system registers.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 28 ++++++++++++++--------------
>>  1 file changed, 14 insertions(+), 14 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 61789027b92b..fafaa81bf1f6 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1038,8 +1038,8 @@ static bool access_pmuserenr(struct kvm_vcpu 
>> *vcpu, struct sys_reg_params *p,
>>  	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
>>  	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
>> 
>> -static bool access_amu(struct kvm_vcpu *vcpu, struct sys_reg_params 
>> *p,
>> -			     const struct sys_reg_desc *r)
>> +static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params 
>> *p,
>> +			 const struct sys_reg_desc *r)
>>  {
>>  	kvm_inject_undefined(vcpu);
> 
> This seems to be identical to trap_ptrauth(). Shall we give it the same
> treatment?

Yes. MTE is also doing the same thing, so let's grind them all.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
