Return-Path: <SRS0=vYaB=VV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9F3C7618B
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 13:56:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 33F6121926
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 13:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=semihalf-com.20150623.gappssmtp.com header.i=@semihalf-com.20150623.gappssmtp.com header.b="NwZd6yqT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33F6121926
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=semihalf.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AFF84A5BD;
	Wed, 24 Jul 2019 09:56:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered)
	header.i=@semihalf-com.20150623.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6KbxGUnY80D7; Wed, 24 Jul 2019 09:56:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 367884A5B1;
	Wed, 24 Jul 2019 09:56:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F16734A5B1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 09:56:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VBYKEb6mUCOm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jul 2019 09:56:36 -0400 (EDT)
Received: from mail-lj1-f195.google.com (mail-lj1-f195.google.com
 [209.85.208.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D3454A5A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 09:56:36 -0400 (EDT)
Received: by mail-lj1-f195.google.com with SMTP id i21so44625351ljj.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 06:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=semihalf-com.20150623.gappssmtp.com; s=20150623;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=54j3Rj1BXvYBjlVWokMkDuv8Oaagn4PllYy8yHElvpY=;
 b=NwZd6yqTUcteXpUZ0IGi33Soy/VPvyQzZ//L8nseZ2jkBr5cmxpituFU0uUN8X0zGy
 nwKaovJdV3763+hbbhbIArizrT86nxgiRscQKYUZiJ8WAr+3Y//LRvVDMXe9da6vmYSJ
 EU7GkkUGBUdRaT9bCIQkCHjyc5wH95o/ONyNMlbLoOz7XfRn9Q5YM8CRer0ziB+/ewXv
 TjClo7gCgUcE/jVq55UyQGOfZiYpEOnZuIckWX84vzCDOHpcBcXHIyx+pQkgruC55JTf
 88883q5PF/LlRsx4mh6kR1p1MiJqzAHWpCd4otRMU64nY0tiA0z3XRDb9/OY+69RB0fe
 R/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=54j3Rj1BXvYBjlVWokMkDuv8Oaagn4PllYy8yHElvpY=;
 b=iqlgCqFt8kELIibqpV68Qc8n7HeIlpda4Acyz8LcaA680Cru3PgF1wY0Hbj7StNGyB
 GNyWcqA86uEDYppZxuxvKngpnRjSBjsHwjUQy2kFZiEK+H6IqlRVQ3QHdgNJ+31vpfUJ
 3sJZ9q39wQDQHONnJsueAbRrcoxHjlL87GJcZkAlNU8OGsaFrOQJCyj8ZiFjojXTHdmx
 IK2qCvDcOuVImt0+DZYg6/llKPyaDYoFpWTMCpNzf3WFg3NGA1f3CZy7wU4o+NKmGv1f
 snxUR0icab628w6Yc+LD9+ErauD44Wd1srztd1OlTLOpy8U0QHwCuIUUBUxeLsFQnkTq
 oIPQ==
X-Gm-Message-State: APjAAAUkTaRYFUXSyQzF7MH4iF1l8vXb64zNMnfhI32VzQRhL0RKVCkA
 EnUd+0G3jkMOFQaRiciU4Rw=
X-Google-Smtp-Source: APXvYqxO6yaPyMuq/MsVLMDvTjMxjWahFQFdCvdqAa57e+Yug9UF5euQajKuVL6dDDPv1F8dFEhYvw==
X-Received: by 2002:a2e:8396:: with SMTP id x22mr44283342ljg.135.1563976595050; 
 Wed, 24 Jul 2019 06:56:35 -0700 (PDT)
Received: from [192.168.1.9] ([83.68.95.66])
 by smtp.googlemail.com with ESMTPSA id r17sm8675692ljc.85.2019.07.24.06.56.33
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 24 Jul 2019 06:56:34 -0700 (PDT)
Subject: Re: [PATCH 43/59] KVM: arm64: nv: Trap and emulate AT instructions
 from virtual EL2
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-44-marc.zyngier@arm.com>
 <0411c636-adbd-98d0-5191-2b073daaf68e@semihalf.com>
 <327dfc0e-e7c9-0d18-2615-1db5b05121f4@arm.com>
From: Tomasz Nowicki <tn@semihalf.com>
Message-ID: <5b4719fc-d189-41fa-cb64-9a731a80bf7e@semihalf.com>
Date: Wed, 24 Jul 2019 15:56:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <327dfc0e-e7c9-0d18-2615-1db5b05121f4@arm.com>
Content-Language: en-GB
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

On 24.07.2019 14:39, Marc Zyngier wrote:
> On 24/07/2019 11:25, Tomasz Nowicki wrote:
>> On 21.06.2019 11:38, Marc Zyngier wrote:
>>> From: Jintack Lim <jintack.lim@linaro.org>
>>>
>>> When supporting nested virtualization a guest hypervisor executing AT
>>> instructions must be trapped and emulated by the host hypervisor,
>>> because untrapped AT instructions operating on S1E1 will use the wrong
>>> translation regieme (the one used to emulate virtual EL2 in EL1 instead
>>> of virtual EL1) and AT instructions operating on S12 will not work from
>>> EL1.
>>>
>>> This patch does several things.
>>>
>>> 1. List and define all AT system instructions to emulate and document
>>> the emulation design.
>>>
>>> 2. Implement AT instruction handling logic in EL2. This will be used to
>>> emulate AT instructions executed in the virtual EL2.
>>>
>>> AT instruction emulation works by loading the proper processor
>>> context, which depends on the trapped instruction and the virtual
>>> HCR_EL2, to the EL1 virtual memory control registers and executing AT
>>> instructions. Note that ctxt->hw_sys_regs is expected to have the
>>> proper processor context before calling the handling
>>> function(__kvm_at_insn) implemented in this patch.
>>>
>>> 4. Emulate AT S1E[01] instructions by issuing the same instructions in
>>> EL2. We set the physical EL1 registers, NV and NV1 bits as described in
>>> the AT instruction emulation overview.
>>>
>>> 5. Emulate AT A12E[01] instructions in two steps: First, do the stage-1
>>> translation by reusing the existing AT emulation functions.  Second, do
>>> the stage-2 translation by walking the guest hypervisor's stage-2 page
>>> table in software. Record the translation result to PAR_EL1.
>>>
>>> 6. Emulate AT S1E2 instructions by issuing the corresponding S1E1
>>> instructions in EL2. We set the physical EL1 registers and the HCR_EL2
>>> register as described in the AT instruction emulation overview.
>>>
>>> 7. Forward system instruction traps to the virtual EL2 if the corresponding
>>> virtual AT bit is set in the virtual HCR_EL2.
>>>
>>>     [ Much logic above has been reworked by Marc Zyngier ]
>>>
>>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>>> ---
>>>    arch/arm64/include/asm/kvm_arm.h |   2 +
>>>    arch/arm64/include/asm/kvm_asm.h |   2 +
>>>    arch/arm64/include/asm/sysreg.h  |  17 +++
>>>    arch/arm64/kvm/hyp/Makefile      |   1 +
>>>    arch/arm64/kvm/hyp/at.c          | 217 +++++++++++++++++++++++++++++++
>>>    arch/arm64/kvm/hyp/switch.c      |  13 +-
>>>    arch/arm64/kvm/sys_regs.c        | 202 +++++++++++++++++++++++++++-
>>>    7 files changed, 450 insertions(+), 4 deletions(-)
>>>    create mode 100644 arch/arm64/kvm/hyp/at.c
>>>
>>
>> [...]
>>
>>> +
>>> +void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>>> +{
>>> +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
>>> +	struct mmu_config config;
>>> +	struct kvm_s2_mmu *mmu;
>>> +
>>> +	/*
>>> +	 * We can only get here when trapping from vEL2, so we're
>>> +	 * translating a guest guest VA.
>>> +	 *
>>> +	 * FIXME: Obtaining the S2 MMU for a a guest guest is horribly
>>> +	 * racy, and we may not find it.
>>> +	 */
>>> +	spin_lock(&vcpu->kvm->mmu_lock);
>>> +
>>> +	mmu = lookup_s2_mmu(vcpu->kvm,
>>> +			    vcpu_read_sys_reg(vcpu, VTTBR_EL2),
>>> +			    vcpu_read_sys_reg(vcpu, HCR_EL2));
>>> +
>>> +	if (WARN_ON(!mmu))
>>> +		goto out;
>>> +
>>> +	/* We've trapped, so everything is live on the CPU. */
>>> +	__mmu_config_save(&config);
>>> +
>>> +	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
>>> +	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
>>> +	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
>>> +	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
>>> +	write_sysreg(kvm_get_vttbr(mmu),		vttbr_el2);
>>> +	/* FIXME: write S2 MMU VTCR_EL2 */
>>> +	write_sysreg(config.hcr & ~HCR_TGE,		hcr_el2);
>>
>> All below AT S1E* operations may initiate stage-1 PTW. And stage-1 table
>> walk addresses are themselves subject to stage-2 translation.
>>
>> So should we enable stage-2 translation here by setting HCR_VM bit?
> 
> Hopefully that's already the case, otherwise nothing works. Have you
> verified that it is actually clear at this stage?

Yes, HCR_EL2.VM is clear at this stage (cleared during guest exit when 
deactivating traps). The weird thing is that my Fastmodel is still 
working with HCR_EL2.VM=0 here and this path is being exercised.

Thanks,
Tomasz

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
