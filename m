Return-Path: <SRS0=mbOA=JJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E194AC433B4
	for <kvmarm@archiver.kernel.org>; Mon, 12 Apr 2021 02:22:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2231D6120C
	for <kvmarm@archiver.kernel.org>; Mon, 12 Apr 2021 02:22:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2231D6120C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91A704B75A;
	Sun, 11 Apr 2021 22:22:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0vrnHso+3c8A; Sun, 11 Apr 2021 22:22:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4023F4B75B;
	Sun, 11 Apr 2021 22:22:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E5194B758
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Apr 2021 22:22:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id idMcALBYdhdw for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Apr 2021 22:22:09 -0400 (EDT)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31B004B718
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Apr 2021 22:22:09 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FJXWB1570z9yYg;
 Mon, 12 Apr 2021 10:19:50 +0800 (CST)
Received: from [10.67.77.175] (10.67.77.175) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0;
 Mon, 12 Apr 2021 10:22:03 +0800
Subject: Re: [RFC] KVM: arm64: Support FEAT_CCIDX
To: Marc Zyngier <maz@kernel.org>
References: <1618042597-59294-1-git-send-email-zhangshaokun@hisilicon.com>
 <875z0ufori.wl-maz@kernel.org>
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <f605f8cd-71a4-7f4e-ffb7-7b5af738e85e@hisilicon.com>
Date: Mon, 12 Apr 2021 10:22:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <875z0ufori.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.67.77.175]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2021/4/10 17:54, Marc Zyngier wrote:
> On Sat, 10 Apr 2021 09:16:37 +0100,
> Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:
>>
>> CCSIDR_EL1 can be implemented as 64-bit format inferred by CCIDX field
>> in ID_AA64MMFR2_EL1. The bits of Numsets and Associativity are different
>> from the 32-bit format. Let's support this feature.
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 27 +++++++++++++++++++--------
>>  1 file changed, 19 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 52fdb9a015a4..0dc822cef20b 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -18,6 +18,7 @@
>>  
>>  #include <asm/cacheflush.h>
>>  #include <asm/cputype.h>
>> +#include <asm/cpufeature.h>
> 
> If you are going to add this (why?), at least add it in alphabetic order.

cpuid_feature_extract_unsigned_field will be used later.
It shall do in alphabetic order.

> 
>>  #include <asm/debug-monitors.h>
>>  #include <asm/esr.h>
>>  #include <asm/kvm_arm.h>
>> @@ -95,9 +96,9 @@ static u32 cache_levels;
>>  #define CSSELR_MAX 14
>>  
>>  /* Which cache CCSIDR represents depends on CSSELR value. */
>> -static u32 get_ccsidr(u32 csselr)
>> +static u64 get_ccsidr(u32 csselr)
>>  {
>> -	u32 ccsidr;
>> +	u64 ccsidr;
>>  
>>  	/* Make sure noone else changes CSSELR during this! */
>>  	local_irq_disable();
>> @@ -1275,12 +1276,16 @@ static bool access_csselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>  static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>  			  const struct sys_reg_desc *r)
>>  {
>> -	u32 csselr;
>> +	u32 csselr, ccidx;
>> +	u64 mmfr2;
>>  
>>  	if (p->is_write)
>>  		return write_to_read_only(vcpu, p, r);
>>  
>>  	csselr = vcpu_read_sys_reg(vcpu, CSSELR_EL1);
>> +	mmfr2 = read_sysreg_s(SYS_ID_AA64MMFR2_EL1);
>> +	ccidx = cpuid_feature_extract_unsigned_field(mmfr2,
>> +						     ID_AA64MMFR2_CCIDX_SHIFT);
> 
> What happens on an asymmetric system where only some of the CPUs have
> FEAT_CCIDX?

If other CPUs don't have FEAT_CCIDX, its value is 0b0000 while CCSIDR_EL1 is 32-bit format.

> 
>>  	p->regval = get_ccsidr(csselr);
>>  
>>  	/*
>> @@ -1295,8 +1300,13 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>  	 * geometry (which is not permitted by the architecture), they would
>>  	 * only do so for virtually indexed caches.]
>>  	 */
>> -	if (!(csselr & 1)) // data or unified cache
>> -		p->regval &= ~GENMASK(27, 3);
>> +	if (!(csselr & 1)) { // data or unified cache
>> +		if (ccidx)
>> +			p->regval &= ~(GENMASK(23, 3) | GENMASK(55, 32));
>> +		else
>> +			p->regval &= ~GENMASK(27, 3);
>> +	}
>> +
>>  	return true;
>>  }
>>  
>> @@ -2521,7 +2531,7 @@ static bool is_valid_cache(u32 val)
>>  static int demux_c15_get(u64 id, void __user *uaddr)
>>  {
>>  	u32 val;
>> -	u32 __user *uval = uaddr;
>> +	u64 __user *uval = uaddr;
> 
> What? Has the user API changed while I wasn't looking? Getting CCSIDR
> can only return a 32bit quantity on AArch32. In fact, CCSIDR is
> *always* 32bit, CCIDX or not. I have no idea what you are trying to do
> here, but at best you are now corrupting 32bit of userspace.
> 

Oops, I really missed this.

>>  
>>  	/* Fail if we have unknown bits set. */
>>  	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
>> @@ -2545,8 +2555,9 @@ static int demux_c15_get(u64 id, void __user *uaddr)
>>  
>>  static int demux_c15_set(u64 id, void __user *uaddr)
>>  {
>> -	u32 val, newval;
>> -	u32 __user *uval = uaddr;
>> +	u32 val;
>> +	u64 newval;
>> +	u64 __user *uval = uaddr;
> 
> Same brokenness.
> 
>>  
>>  	/* Fail if we have unknown bits set. */
>>  	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
> 
> What about CCSIDR2_EL1, which is mandatory when FEAT_CCSIDX is
> present? How about the AArch32 handling of that register? I don't
> think you have though this one through.

To be honest, AArch32 is not considered directly and I sent this only
as RFC. When I wrote some flush cache code using by set/way mode and
noticed that CCSIDR_EL1 is used here.

> 
> Another question is: why should we care at all? Why don't we drop all
> that and only implement a virtual cache topology? A VM shouldn't care
> at all about this, and we are already lying about the topology anyway.
> We could even get the VMM to set whatever stupid topology it wants for
> the sake of it (and to restore previously created VMs).

Got it,

Thanks for your detailed comments.
Shaokun

> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
