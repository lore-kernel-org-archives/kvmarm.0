Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B2FC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 14:41:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D8E5720899
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 14:41:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8E5720899
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27F4E4B16F;
	Wed, 27 May 2020 10:41:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eg8akO9PZGte; Wed, 27 May 2020 10:41:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E14404B1BB;
	Wed, 27 May 2020 10:41:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F33894B16F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 10:41:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DSrPfMFH39J9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 10:41:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 927434B141
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 10:41:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC2EC30E;
 Wed, 27 May 2020 07:41:43 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.7.129])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70C2D3F6C4;
 Wed, 27 May 2020 07:41:40 -0700 (PDT)
Date: Wed, 27 May 2020 15:41:33 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 26/26] KVM: arm64: Parametrize exception entry with a
 target EL
Message-ID: <20200527144133.GA59947@C02TD0UTHF1T.local>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-27-maz@kernel.org>
 <20200519104457.GA19548@C02TD0UTHF1T.local>
 <db34b0fbd58275a0a2a0c9108b9507d6@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <db34b0fbd58275a0a2a0c9108b9507d6@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, May 27, 2020 at 10:34:09AM +0100, Marc Zyngier wrote:
> HI Mark,
> 
> On 2020-05-19 11:44, Mark Rutland wrote:
> > On Wed, Apr 22, 2020 at 01:00:50PM +0100, Marc Zyngier wrote:
> > > -static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
> > > +static void enter_exception(struct kvm_vcpu *vcpu, unsigned long
> > > target_mode,
> > > +			    enum exception_type type)
> > 
> > Since this is all for an AArch64 target, could we keep `64` in the name,
> > e.g enter_exception64? That'd mirror the callers below.
> > 
> > >  {
> > > -	unsigned long sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> > > -	unsigned long old, new;
> > > +	unsigned long sctlr, vbar, old, new, mode;
> > > +	u64 exc_offset;
> > > +
> > > +	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
> > > +
> > > +	if      (mode == target_mode)
> > > +		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
> > > +	else if ((mode | 1) == target_mode)
> > > +		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
> > 
> > It would be nice if we could add a mnemonic for the `1` here, e.g.
> > PSR_MODE_SP0 or PSR_MODE_THREAD_BIT.
> 
> I've addressed both comments as follows:
> 
> diff --git a/arch/arm64/include/asm/ptrace.h
> b/arch/arm64/include/asm/ptrace.h
> index bf57308fcd63..953b6a1ce549 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -35,6 +35,7 @@
>  #define GIC_PRIO_PSR_I_SET		(1 << 4)
> 
>  /* Additional SPSR bits not exposed in the UABI */
> +#define PSR_MODE_THREAD_BIT	(1 << 0)
>  #define PSR_IL_BIT		(1 << 20)
> 
>  /* AArch32-specific ptrace requests */
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index 3dbcbc839b9c..ebfdfc27b2bd 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -43,8 +43,8 @@ enum exception_type {
>   * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout,
> from
>   * MSB to LSB.
>   */
> -static void enter_exception(struct kvm_vcpu *vcpu, unsigned long
> target_mode,
> -			    enum exception_type type)
> +static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long
> target_mode,
> +			      enum exception_type type)
>  {
>  	unsigned long sctlr, vbar, old, new, mode;
>  	u64 exc_offset;
> @@ -53,7 +53,7 @@ static void enter_exception(struct kvm_vcpu *vcpu,
> unsigned long target_mode,
> 
>  	if      (mode == target_mode)
>  		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
> -	else if ((mode | 1) == target_mode)
> +	else if ((mode | PSR_MODE_THREAD_BIT) == target_mode)
>  		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
>  	else if (!(mode & PSR_MODE32_BIT))
>  		exc_offset = LOWER_EL_AArch64_VECTOR;
> @@ -126,7 +126,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool
> is_iabt, unsigned long addr
>  	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
>  	u32 esr = 0;
> 
> -	enter_exception(vcpu, PSR_MODE_EL1h, except_type_sync);
> +	enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
> 
>  	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
> 
> @@ -156,7 +156,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>  {
>  	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
> 
> -	enter_exception(vcpu, PSR_MODE_EL1h, except_type_sync);
> +	enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
> 
>  	/*
>  	 * Build an unknown exception, depending on the instruction

Thanks; that all looks good to me, and my R-b stands!

Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
