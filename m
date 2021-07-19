Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A678C6377E
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:56:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7590660E0C
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:56:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7590660E0C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0E3B4B088;
	Mon, 19 Jul 2021 12:56:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J4yfJwPiodXP; Mon, 19 Jul 2021 12:56:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C32A54B08D;
	Mon, 19 Jul 2021 12:56:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C31124B088
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:56:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id posCqjx8d9Kp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:56:42 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9305E4A193
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:56:42 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6FD8A60FE9;
 Mon, 19 Jul 2021 16:56:41 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m5WZL-00EIvl-Ek; Mon, 19 Jul 2021 17:56:39 +0100
MIME-Version: 1.0
Date: Mon, 19 Jul 2021 17:56:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Remove PMSWINC_EL0 shadow register
In-Reply-To: <c1a63908-b55c-bdf8-b8ba-5a43f2e99e1f@arm.com>
References: <20210719123902.1493805-1-maz@kernel.org>
 <20210719123902.1493805-5-maz@kernel.org>
 <c1a63908-b55c-bdf8-b8ba-5a43f2e99e1f@arm.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <f2b655d0977cde5483716f58ba2ab739@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandre.chartre@oracle.com, robin.murphy@arm.com, drjones@redhat.com,
 linux@arm.linux.org.uk, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Russell King <linux@arm.linux.org.uk>, Robin Murphy <robin.murphy@arm.com>,
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

Hi Alex,

On 2021-07-19 17:35, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 7/19/21 1:39 PM, Marc Zyngier wrote:
>> We keep an entry for the PMSWINC_EL0 register in the vcpu structure,
>> while *never* writing anything there outside of reset.
>> 
>> Given that the register is defined as write-only, that we always
>> trap when this register is accessed, there is little point in saving
>> anything anyway.
>> 
>> Get rid of the entry, and save a mighty 8 bytes per vcpu structure.
>> 
>> We still need to keep it exposed to userspace in order to preserve
>> backward compatibility with previously saved VMs. Since userspace
>> cannot expect any effect of writing to PMSWINC_EL0, treat the
>> register as RAZ/WI for the purpose of userspace access.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/kvm_host.h |  1 -
>>  arch/arm64/kvm/sys_regs.c         | 21 ++++++++++++++++++++-
>>  2 files changed, 20 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h 
>> b/arch/arm64/include/asm/kvm_host.h
>> index 41911585ae0c..afc169630884 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -185,7 +185,6 @@ enum vcpu_sysreg {
>>  	PMCNTENSET_EL0,	/* Count Enable Set Register */
>>  	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
>>  	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
>> -	PMSWINC_EL0,	/* Software Increment Register */
>>  	PMUSERENR_EL0,	/* User Enable Register */
>> 
>>  	/* Pointer Authentication Registers in a strict increasing order. */
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index f22139658e48..a1f5101f49a3 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1286,6 +1286,20 @@ static int set_raz_id_reg(struct kvm_vcpu 
>> *vcpu, const struct sys_reg_desc *rd,
>>  	return __set_id_reg(vcpu, rd, uaddr, true);
>>  }
>> 
>> +static int set_wi_reg(struct kvm_vcpu *vcpu, const struct 
>> sys_reg_desc *rd,
>> +		      const struct kvm_one_reg *reg, void __user *uaddr)
>> +{
>> +	int err;
>> +	u64 val;
>> +
>> +	/* Perform the access even if we are going to ignore the value */
>> +	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
> 
> I don't understand why the read still happens if the value is ignored.
> Just so KVM
> preserves the previous behaviour and tells userspace there was an 
> error?

If userspace has given us a duff pointer, it needs to know about it.

>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>> +}
>> +
>>  static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params 
>> *p,
>>  		       const struct sys_reg_desc *r)
>>  {
>> @@ -1629,8 +1643,13 @@ static const struct sys_reg_desc 
>> sys_reg_descs[] = {
>>  	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
>>  	{ PMU_SYS_REG(SYS_PMOVSCLR_EL0),
>>  	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
>> +	/*
>> +	 * PM_SWINC_EL0 is exposed to userspace as RAZ/WI, as it was
>> +	 * previously (and pointlessly) advertised in the past...
>> +	 */
>>  	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
>> -	  .access = access_pmswinc, .reg = PMSWINC_EL0 },
>> +	  .get_user = get_raz_id_reg, .set_user = set_wi_reg,
> 
> In my opinion, the call chain to return 0 looks pretty confusing to me, 
> as the
> functions seemed made for ID register accesses, and the leaf function,
> read_id_reg(), tries to match this register with a list of ID
> registers. Since we
> have already added a new function just for PMSWINC_EL0, I was
> wondering if adding
> another function, something like get_raz_reg(), would make more sense.

In that case, I'd rather just kill get_raz_id_reg() and replace it with
this get_raz_reg(). If we trat something as RAZ, who cares whether it is
an idreg or not?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
