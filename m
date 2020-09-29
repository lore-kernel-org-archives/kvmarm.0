Return-Path: <SRS0=H5U9=DG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB10CC4727C
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 13:52:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF7B620848
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 13:52:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtOw9CNX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF7B620848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E1B74B1D9;
	Tue, 29 Sep 2020 09:52:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WQf0B+oN4xuB; Tue, 29 Sep 2020 09:52:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3FE34B1DA;
	Tue, 29 Sep 2020 09:52:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73FD44B1D8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 09:52:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UWRxOra9vFcW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2020 09:52:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45BEA4B0D4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 09:52:16 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DE014208FE;
 Tue, 29 Sep 2020 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601387535;
 bh=hQplG5p9tGOxcviNNQcl3I0N/iuuu8kEYoGGBZCS7rw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=RtOw9CNXbEM1K9LHxZ4EFc3LZJLlrLa7VRb9asVe7RwAf9yoa+M82lCzAExVAvfWe
 5wPJCQNm/Z8o5aKxZtm9zzWX0cwfWugVzP5sRqYc1KF9Pv0iQ744KMw6tl4ZIXxoXx
 3OPTNOgAkrC53rJ0l/GSYrPdu3xSCV71un138CDo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kNG3A-00FrSs-M2; Tue, 29 Sep 2020 14:52:13 +0100
MIME-Version: 1.0
Date: Tue, 29 Sep 2020 14:52:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH v3] KVM: arm64: Preserve PMCR immutable values across reset
In-Reply-To: <20200910164243.29253-1-graf@amazon.com>
References: <20200910164243.29253-1-graf@amazon.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <4f33899554e54e3c4485612394898864@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: graf@amazon.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com,
 mark.rutland@arm.com, eric.auger@redhat.com, drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu
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

On 2020-09-10 17:42, Alexander Graf wrote:
> We allow user space to set the PMCR register to any value. However,
> when time comes for a vcpu reset (for example on PSCI online), PMCR
> is reset to the hardware capabilities.
> 
> I would like to explicitly expose different PMU capabilities (number
> of supported event counters) to the guest than hardware supports.
> Ideally across vcpu resets.
> 
> So this patch adopts the reset path to only populate the immutable
> PMCR register bits from hardware when they were not initialized
> previously. This effectively means that on a normal reset, only the
> guest settable fields are reset, while on vcpu creation the register
> gets populated from hardware like before.
> 
> With this in place and a change in user space to invoke SET_ONE_REG
> on the PMCR for every vcpu, I can reliably set the PMU event counter
> number to arbitrary values.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 20ab2a7d37ca..28f67550db7f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -663,7 +663,14 @@ static void reset_pmcr(struct kvm_vcpu *vcpu,
> const struct sys_reg_desc *r)
>  {
>  	u64 pmcr, val;
> 
> -	pmcr = read_sysreg(pmcr_el0);
> +	/*
> +	 * If we already received PMCR from a previous ONE_REG call,
> +	 * maintain its immutable flags
> +	 */
> +	pmcr = __vcpu_sys_reg(vcpu, r->reg);
> +	if (!__vcpu_sys_reg(vcpu, r->reg))
> +		pmcr = read_sysreg(pmcr_el0);
> +
>  	/*
>  	 * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to 
> UNKNOWN
>  	 * except PMCR.E resetting to zero.

I'm afraid you may need a bit more than just this hack. At the moment,
although we can write junk into the shadow copy of PMCR_EL0, the reset
will make that behave correctly. With this patch, the junk sticks and
gets exposed to the guest.

You need at least a .set_user callback to the handling of PMCR_EL0
so that the value stored is legal, follows the architectural
behaviour, and matches the host capabilities.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
