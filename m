Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B280FC2D0DB
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 17:55:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3BBE622314
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 17:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IooBH/8j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BBE622314
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFCCF4AC88;
	Mon, 20 Jan 2020 12:55:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QaPcutOKX8Jr; Mon, 20 Jan 2020 12:55:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07C284ACB8;
	Mon, 20 Jan 2020 12:55:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 173284A95D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 12:55:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KCE3vrM7Ib9i for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 12:55:21 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CABD64A7F0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 12:55:20 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B0D3022314;
 Mon, 20 Jan 2020 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579542919;
 bh=8bOHTYRbLS8txTcPyDaCdCmZAjMXTNyGIy7MeklFyyo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=IooBH/8jTScBInV0AEkiGiZPHkboAsYt5L7M/D6YY5IM/A5GHtwHCFvFW6h6fS1hO
 MILodesfftr3jl1l9b3vUTu0IOwhH83ttRmdEwthgTdy16iwvhETgYA5tJ2bCKpQUR
 fLtoxYBMxKEgi+yRkJ6X4B+kTm4/2NENGmjlJ13Y=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1itbGf-000KpS-NS; Mon, 20 Jan 2020 17:55:17 +0000
MIME-Version: 1.0
Date: Mon, 20 Jan 2020 17:55:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v3 2/3] KVM: arm64: limit PMU version to ARMv8.4
In-Reply-To: <20200102123905.29360-3-andrew.murray@arm.com>
References: <20200102123905.29360-1-andrew.murray@arm.com>
 <20200102123905.29360-3-andrew.murray@arm.com>
Message-ID: <336acb6b88c2df5e6114e6f8811687e4@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

On 2020-01-02 12:39, Andrew Murray wrote:
> ARMv8.5-PMU introduces 64-bit event counters, however KVM doesn't yet
> support this. Let's trap the Debug Feature Registers in order to limit
> PMUVer/PerfMon in the Debug Feature Registers to PMUv3 for ARMv8.4.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/sysreg.h |  4 ++++
>  arch/arm64/kvm/sys_regs.c       | 36 +++++++++++++++++++++++++++++++--
>  2 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h 
> b/arch/arm64/include/asm/sysreg.h
> index 6e919fafb43d..1b74f275a115 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -672,6 +672,10 @@
>  #define ID_AA64DFR0_TRACEVER_SHIFT	4
>  #define ID_AA64DFR0_DEBUGVER_SHIFT	0
> 
> +#define ID_DFR0_PERFMON_SHIFT		24
> +
> +#define ID_DFR0_EL1_PMUVER_8_4		5
> +
>  #define ID_ISAR5_RDM_SHIFT		24
>  #define ID_ISAR5_CRC32_SHIFT		16
>  #define ID_ISAR5_SHA2_SHIFT		12
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9f2165937f7d..61b984d934d1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -668,6 +668,37 @@ static bool
> pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
>  	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_ER |
> ARMV8_PMU_USERENR_EN);
>  }
> 
> +static bool access_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +				   struct sys_reg_params *p,
> +				   const struct sys_reg_desc *rd)
> +{
> +	if (p->is_write)
> +		return write_to_read_only(vcpu, p, rd);
> +
> +	/* Limit guests to PMUv3 for ARMv8.4 */
> +	p->regval = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> +	p->regval = cpuid_feature_cap_signed_field_width(p->regval,
> +						ID_AA64DFR0_PMUVER_SHIFT,
> +						4, ID_DFR0_EL1_PMUVER_8_4);
> +
> +	return p->regval;

If feels very odd to return the register value in place of a something
that actually indicates whether we should update the PC or not. I have
no idea what is happening here in this case.

> +}
> +
> +static bool access_id_dfr0_el1(struct kvm_vcpu *vcpu, struct 
> sys_reg_params *p,
> +			       const struct sys_reg_desc *rd)
> +{
> +	if (p->is_write)
> +		return write_to_read_only(vcpu, p, rd);
> +
> +	/* Limit guests to PMUv3 for ARMv8.4 */
> +	p->regval = read_sanitised_ftr_reg(SYS_ID_DFR0_EL1);
> +	p->regval = cpuid_feature_cap_signed_field_width(p->regval,
> +						ID_DFR0_PERFMON_SHIFT,
> +						4, ID_DFR0_EL1_PMUVER_8_4);
> +
> +	return p->regval;

Same here.

> +}
> +
>  static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params 
> *p,
>  			const struct sys_reg_desc *r)
>  {
> @@ -1409,7 +1440,8 @@ static const struct sys_reg_desc sys_reg_descs[] 
> = {
>  	/* CRm=1 */
>  	ID_SANITISED(ID_PFR0_EL1),
>  	ID_SANITISED(ID_PFR1_EL1),
> -	ID_SANITISED(ID_DFR0_EL1),
> +	{ SYS_DESC(SYS_ID_DFR0_EL1), access_id_dfr0_el1 },

How about the .get_user and .set_user accessors that were provided by
ID_SANITISED and that are now dropped? You should probably define a
new wrapper that allows you to override the .access method.

> +
>  	ID_HIDDEN(ID_AFR0_EL1),
>  	ID_SANITISED(ID_MMFR0_EL1),
>  	ID_SANITISED(ID_MMFR1_EL1),
> @@ -1448,7 +1480,7 @@ static const struct sys_reg_desc sys_reg_descs[] 
> = {
>  	ID_UNALLOCATED(4,7),
> 
>  	/* CRm=5 */
> -	ID_SANITISED(ID_AA64DFR0_EL1),
> +	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), access_id_aa64dfr0_el1 },
>  	ID_SANITISED(ID_AA64DFR1_EL1),
>  	ID_UNALLOCATED(5,2),
>  	ID_UNALLOCATED(5,3),

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
