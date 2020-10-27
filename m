Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02264C4363A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 18:49:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 524CB207E8
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 18:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0kIH8+b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 524CB207E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A33E64B4A0;
	Tue, 27 Oct 2020 14:49:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kXohIJ32JR9c; Tue, 27 Oct 2020 14:49:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CF654B48D;
	Tue, 27 Oct 2020 14:49:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 831E74B48D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 14:49:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T-Q8nCGgMkqc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 14:49:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 549514B479
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 14:49:19 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0140E207DE;
 Tue, 27 Oct 2020 18:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603824558;
 bh=LLymolsV5F+QRaC0FUrOgoIM2iN9acO1HLn3U7GULqo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=S0kIH8+bpUOP2U6vMAP5XdSfhj8o1rc//xLX5Ob5XSAF320XeyJzGX52t+s111mcV
 nQTHeLiSyu1Jt1UNSKkOCEsI8RLquSH9Stc5m1f1SpqZOaCCo5B9KyRjPzrkvdyULp
 GYe/SGjoB0u3P7NwdvBHl/qEbEq2sBSWAY2D1jlo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kXU1z-004ueD-PK; Tue, 27 Oct 2020 18:49:15 +0000
MIME-Version: 1.0
Date: Tue, 27 Oct 2020 18:49:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 07/11] KVM: arm64: Inject AArch64 exceptions from HYP
In-Reply-To: <cf4dc11c-fb9f-ee01-a93a-c1c0a721aa19@arm.com>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-8-maz@kernel.org>
 <cf4dc11c-fb9f-ee01-a93a-c1c0a721aa19@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <6ce42c66606e3d41a30fafbf66aa49a5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com,
 will@kernel.org, qperret@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
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

Hi James,

On 2020-10-27 17:41, James Morse wrote:
> Hi Marc,
> 
> On 26/10/2020 13:34, Marc Zyngier wrote:
>> Move the AArch64 exception injection code from EL1 to HYP, leaving
>> only the ESR_EL1 updates to EL1. In order to come with the differences
> 
> (cope with the differences?)

Yes, much better!

>> between VHE and nVHE, two set of system register accessors are 
>> provided.
>> 
>> SPSR, ELR, PC and PSTATE are now completely handled in the hypervisor.
> 
> 
>> diff --git a/arch/arm64/kvm/hyp/exception.c 
>> b/arch/arm64/kvm/hyp/exception.c
>> index 6533a9270850..cd6e643639e8 100644
>> --- a/arch/arm64/kvm/hyp/exception.c
>> +++ b/arch/arm64/kvm/hyp/exception.c
>> @@ -11,7 +11,167 @@
>>   */
>> 
>>  #include <hyp/adjust_pc.h>
>> +#include <linux/kvm_host.h>
>> +#include <asm/kvm_emulate.h>
>> +
>> +#if defined (__KVM_NVHE_HYPERVISOR__)
>> +/*
>> + * System registers are never loaded on the CPU until we actually
>> + * restore them.
>> + */
>> +static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, 
>> int reg)
>> +{
>> +	return __vcpu_sys_reg(vcpu, reg);
>> +}
>> +
>> +static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 
>> val, int reg)
>> +{
>> +	 __vcpu_sys_reg(vcpu, reg) = val;
>> +}
>> +
>> +static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
>> +{
>> +	write_sysreg_el1(val, SYS_SPSR);
>> +}
>> +#elif defined (__KVM_VHE_HYPERVISOR__)
>> +/* On VHE, all the registers are already loaded on the CPU */
>> +static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, 
>> int reg)
>> +{
>> +	u64 val;
> 
>> +	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
>> +		return val;
> 
> As has_vhe()'s behaviour changes based on these KVM preprocessor 
> symbols, would:
> |	if (has_vhe() && __vcpu_read_sys_reg_from_cpu(reg, &val))
> |		return val;
> 
> let you do both of these with only one copy of the function?

Indeed that's better. Even better, let's move the has_vhe() into
__vcpu_read_sys_reg_from_cpu(), as that's the only case this is
used for.

Further cleanup could involve a new helper that would gate the
test of vcpu->sysregs_loaded_on_cpu with has_vhe() too, as this
definitely is a VHE-only feature.

> 
> 
>> +	return __vcpu_sys_reg(vcpu, reg);
>> +}
>> +
>> +static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 
>> val, int reg)
>> +{
>> +	if (__vcpu_write_sys_reg_to_cpu(val, reg))
>> +		return;
>> +
>> +	 __vcpu_sys_reg(vcpu, reg) = val;
>> +}
> 
> 
>> +static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
>> +{
>> +	write_sysreg_el1(val, SYS_SPSR);
>> +}
> 
> This one doesn't look like it needs duplicating.

Spot on again, thanks!

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
