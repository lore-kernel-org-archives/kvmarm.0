Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A958EC07E95
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:34:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17E1B6128C
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:34:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17E1B6128C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EBC34B082;
	Mon, 19 Jul 2021 12:34:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UpzF-k-eh0bG; Mon, 19 Jul 2021 12:34:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 205934ACC9;
	Mon, 19 Jul 2021 12:34:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81B7E4066E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:34:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QFG5Kfudht-I for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:34:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 366484019D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:34:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B90D21FB;
 Mon, 19 Jul 2021 09:34:30 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC8B63F73D;
 Mon, 19 Jul 2021 09:34:28 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] KVM: arm64: Remove PMSWINC_EL0 shadow register
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210719123902.1493805-1-maz@kernel.org>
 <20210719123902.1493805-5-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c1a63908-b55c-bdf8-b8ba-5a43f2e99e1f@arm.com>
Date: Mon, 19 Jul 2021 17:35:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210719123902.1493805-5-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, Russell King <linux@arm.linux.org.uk>,
 Robin Murphy <robin.murphy@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 7/19/21 1:39 PM, Marc Zyngier wrote:
> We keep an entry for the PMSWINC_EL0 register in the vcpu structure,
> while *never* writing anything there outside of reset.
>
> Given that the register is defined as write-only, that we always
> trap when this register is accessed, there is little point in saving
> anything anyway.
>
> Get rid of the entry, and save a mighty 8 bytes per vcpu structure.
>
> We still need to keep it exposed to userspace in order to preserve
> backward compatibility with previously saved VMs. Since userspace
> cannot expect any effect of writing to PMSWINC_EL0, treat the
> register as RAZ/WI for the purpose of userspace access.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 -
>  arch/arm64/kvm/sys_regs.c         | 21 ++++++++++++++++++++-
>  2 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 41911585ae0c..afc169630884 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -185,7 +185,6 @@ enum vcpu_sysreg {
>  	PMCNTENSET_EL0,	/* Count Enable Set Register */
>  	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
>  	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
> -	PMSWINC_EL0,	/* Software Increment Register */
>  	PMUSERENR_EL0,	/* User Enable Register */
>  
>  	/* Pointer Authentication Registers in a strict increasing order. */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f22139658e48..a1f5101f49a3 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1286,6 +1286,20 @@ static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	return __set_id_reg(vcpu, rd, uaddr, true);
>  }
>  
> +static int set_wi_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		      const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	int err;
> +	u64 val;
> +
> +	/* Perform the access even if we are going to ignore the value */
> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));

I don't understand why the read still happens if the value is ignored. Just so KVM
preserves the previous behaviour and tells userspace there was an error?

> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
>  static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  		       const struct sys_reg_desc *r)
>  {
> @@ -1629,8 +1643,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
>  	{ PMU_SYS_REG(SYS_PMOVSCLR_EL0),
>  	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
> +	/*
> +	 * PM_SWINC_EL0 is exposed to userspace as RAZ/WI, as it was
> +	 * previously (and pointlessly) advertised in the past...
> +	 */
>  	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
> -	  .access = access_pmswinc, .reg = PMSWINC_EL0 },
> +	  .get_user = get_raz_id_reg, .set_user = set_wi_reg,

In my opinion, the call chain to return 0 looks pretty confusing to me, as the
functions seemed made for ID register accesses, and the leaf function,
read_id_reg(), tries to match this register with a list of ID registers. Since we
have already added a new function just for PMSWINC_EL0, I was wondering if adding
another function, something like get_raz_reg(), would make more sense.

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
