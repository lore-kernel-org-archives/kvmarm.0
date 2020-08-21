Return-Path: <SRS0=jF9t=B7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58246C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 17:02:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C937520702
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 17:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tpr14/v8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C937520702
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 425744C578;
	Fri, 21 Aug 2020 13:02:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5rZLYOywa0P7; Fri, 21 Aug 2020 13:02:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 268C34C57F;
	Fri, 21 Aug 2020 13:02:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 327BB4C57C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 13:02:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MRf6XIdtNuFV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Aug 2020 13:02:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0485F4C578
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 13:02:42 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CC71720702;
 Fri, 21 Aug 2020 17:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1598029361;
 bh=deOmS6g1GMzLJwxnsOTA3oAcmghq4CI89ncjWq0+Uvo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=tpr14/v8oH10AzXugrdjJhMTNIpwGKutzz+R1hArjsSapX6FZi58/7pIvIqbN8Zjc
 nU0+3OmLT6g4U7HnL8uyC55dC3OJBCxsRtrbm/F1R8DloPC4eFexJQ8ALr8Iy5SAhP
 Y+8wgrNv5qfORjAAYqSqt0S1nIg4vN5mOuK0bo1A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k9AR5-004y40-I1; Fri, 21 Aug 2020 18:02:40 +0100
MIME-Version: 1.0
Date: Fri, 21 Aug 2020 18:02:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
In-Reply-To: <20200821140525.GD6823@gaia>
References: <20200803193127.3012242-1-robh@kernel.org>
 <20200803193127.3012242-4-robh@kernel.org> <20200821120659.GB6823@gaia>
 <20200821121209.GB20833@willie-the-truck> <20200821122633.GC6823@gaia>
 <8c641833ff20d5a35981c456d4fe1d5a@kernel.org> <20200821140525.GD6823@gaia>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <4bc5ca546826da4682ec3b126052daea@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, will@kernel.org, robh@kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, ascull@google.com, julien.thierry.kdev@gmail.com,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Rob Herring <robh@kernel.org>, Will Deacon <will@kernel.org>,
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

On 2020-08-21 15:05, Catalin Marinas wrote:
> On Fri, Aug 21, 2020 at 01:45:40PM +0100, Marc Zyngier wrote:
>> On 2020-08-21 13:26, Catalin Marinas wrote:
>> > On Fri, Aug 21, 2020 at 01:12:10PM +0100, Will Deacon wrote:
>> > > On Fri, Aug 21, 2020 at 01:07:00PM +0100, Catalin Marinas wrote:
>> > > > On Mon, Aug 03, 2020 at 01:31:27PM -0600, Rob Herring wrote:
>> > > > > @@ -979,6 +980,14 @@
>> > > > >  		write_sysreg(__scs_new, sysreg);			\
>> > > > >  } while (0)
>> > > > >
>> > > > > +#define read_sysreg_par() ({						\
>> > > > > +	u64 par;							\
>> > > > > +	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
>> > > > > +	par = read_sysreg(par_el1);					\
>> > > > > +	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
>> > > > > +	par;								\
>> > > > > +})
>> > > >
>> > > > I was about to queue this up but one more point to clarify: can we get
>> > > > an interrupt at either side of the PAR_EL1 read and the handler do a
>> > > > device read, triggering the erratum? Do we need a DMB at exception
>> > > > entry/return?
>> > >
>> > > Disabling irqs around the PAR access would be simpler, I think
>> > > (assuming
>> > > this is needed).
>> >
>> > This wouldn't work if it interrupts a guest.
>> 
>> If we take an interrupt either side of the PAR_EL1 read and that we
>> fully exit, the saving of PAR_EL1 on the way out solves the problem.
>> 
>> If we don't fully exit, but instead reenter the guest immediately
>> (fixup_guest_exit() returns true), we'd need a DMB at that point,
>> at least because of the GICv2 proxying code which performs device
>> accesses on the guest's behalf.
> 
> If you are ok with the diff below, I can fold it in:
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h
> b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index ca88ea416176..8770cf7ccd42 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -420,7 +420,7 @@ static inline bool fixup_guest_exit(struct
> kvm_vcpu *vcpu, u64 *exit_code)
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
>  	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
>  	    handle_tx2_tvm(vcpu))
> -		return true;
> +		goto guest;
> 
>  	/*
>  	 * We trap the first access to the FP/SIMD to save the host context
> @@ -430,13 +430,13 @@ static inline bool fixup_guest_exit(struct
> kvm_vcpu *vcpu, u64 *exit_code)
>  	 * Similarly for trapped SVE accesses.
>  	 */
>  	if (__hyp_handle_fpsimd(vcpu))
> -		return true;
> +		goto guest;
> 
>  	if (__hyp_handle_ptrauth(vcpu))
> -		return true;
> +		goto guest;
> 
>  	if (!__populate_fault_info(vcpu))
> -		return true;
> +		goto guest;
> 
>  	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
>  		bool valid;
> @@ -451,7 +451,7 @@ static inline bool fixup_guest_exit(struct
> kvm_vcpu *vcpu, u64 *exit_code)
>  			int ret = __vgic_v2_perform_cpuif_access(vcpu);
> 
>  			if (ret == 1)
> -				return true;
> +				goto guest;
> 
>  			/* Promote an illegal access to an SError.*/
>  			if (ret == -1)
> @@ -467,12 +467,17 @@ static inline bool fixup_guest_exit(struct
> kvm_vcpu *vcpu, u64 *exit_code)
>  		int ret = __vgic_v3_perform_cpuif_access(vcpu);
> 
>  		if (ret == 1)
> -			return true;
> +			goto guest;
>  	}
> 
>  exit:
>  	/* Return to the host kernel and handle the exit */
>  	return false;
> +
> +guest:
> +	/* Re-enter the guest */
> +	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));
> +	return true;
>  }
> 
>  static inline bool __needs_ssbd_off(struct kvm_vcpu *vcpu)

Looks good to me!

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
