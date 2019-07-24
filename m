Return-Path: <SRS0=vYaB=VV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90915C7618F
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 10:25:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1813821743
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 10:25:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=semihalf-com.20150623.gappssmtp.com header.i=@semihalf-com.20150623.gappssmtp.com header.b="isMSoHu2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1813821743
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=semihalf.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 787384A5AD;
	Wed, 24 Jul 2019 06:25:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered)
	header.i=@semihalf-com.20150623.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jU3S6jGd3wnU; Wed, 24 Jul 2019 06:25:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1EB84A585;
	Wed, 24 Jul 2019 06:25:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4235E4A54B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 06:25:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DFpUoZ2hC4L2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jul 2019 06:25:19 -0400 (EDT)
Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com
 [209.85.208.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5E5B4A549
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 06:25:18 -0400 (EDT)
Received: by mail-lj1-f193.google.com with SMTP id v18so43941329ljh.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 03:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=semihalf-com.20150623.gappssmtp.com; s=20150623;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=lVgQUcvm4B+F8VvCOUERbLT0MAHsxUXHeUnC9WycUQU=;
 b=isMSoHu2YU+lUjj7dYoP/XrIoOXdhan8V4yM3Ff5qJpv2d0Sy41w84glO50WGYuu9P
 f4VbsAN4DIba8Yq0qMDEuxUheuqY1apg0JbHovGYtsKapFbhi/HvGOryMvcACKq2BYbY
 Gw+twOR34/OW8hLhnf+niPEu13Cj8AaRoBFLO4urrBYAk/afWNok7KE7DwJfVhXAKwCt
 Dc3q1cufoG8VtZqypMgO7Ug/01DYbnX9BlxhZvGTLjm39xTaza8k++H0ORqKa2VAmLaj
 7ETPSSmPrQ17C6gNybCZ5V41F6xUP5DeaY50FbIMlAGUDVhxFPzASr21WS/aHOiYc8jq
 4svw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=lVgQUcvm4B+F8VvCOUERbLT0MAHsxUXHeUnC9WycUQU=;
 b=BwmthSwn6w4fkqQhdqyYjYZnD+iUFUEmCX4w7nhR6+/0FnIZ6rvUHgl9PEb5MDSbsp
 rHWYPTXlYp7wNKRiRgBFXbFr7iUQG36O3Q44EVC5atwh9gKV1xEu4UQv6hHUMrxq26qv
 cwHxTge1eO/DMtXjm826qwGVFEA8+Ep9Z1DqKAXSr1KPXOiOD5QKrp63MWwy+nDoSQ6d
 yaNQ4LSAzd16ZD+d+HpHT9a2pLrXO6tknnkLtVqumJbih2+UrDunFpz2YxiKZ+7INuIS
 j/MU1H/sUpYjoUpq9joRmEfhWaPUXU4Xj2jdxIXfrDtujd8VxQKsWZWxdW9uhyERgjpb
 IT0g==
X-Gm-Message-State: APjAAAUhZDxHsG6OuwIG6gQ8RnqojKFvN+ljGTNe6HTJ2u0i5VNAbZNb
 0wDDzP65DkEMBs7cmTw59os=
X-Google-Smtp-Source: APXvYqyfTmN6q3TXh7eU66xX8fgCBXe7LAqAkx7N/UvucuEIj5MiKFyl7z00ArH9NKjCJRB1t1ILDg==
X-Received: by 2002:a2e:9c9a:: with SMTP id x26mr22531946lji.47.1563963917430; 
 Wed, 24 Jul 2019 03:25:17 -0700 (PDT)
Received: from [192.168.1.102] ([83.68.95.66])
 by smtp.googlemail.com with ESMTPSA id s21sm8606519ljm.28.2019.07.24.03.25.16
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 24 Jul 2019 03:25:16 -0700 (PDT)
Subject: Re: [PATCH 43/59] KVM: arm64: nv: Trap and emulate AT instructions
 from virtual EL2
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-44-marc.zyngier@arm.com>
From: Tomasz Nowicki <tn@semihalf.com>
Message-ID: <0411c636-adbd-98d0-5191-2b073daaf68e@semihalf.com>
Date: Wed, 24 Jul 2019 12:25:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-44-marc.zyngier@arm.com>
Content-Language: en-US
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

On 21.06.2019 11:38, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> When supporting nested virtualization a guest hypervisor executing AT
> instructions must be trapped and emulated by the host hypervisor,
> because untrapped AT instructions operating on S1E1 will use the wrong
> translation regieme (the one used to emulate virtual EL2 in EL1 instead
> of virtual EL1) and AT instructions operating on S12 will not work from
> EL1.
> 
> This patch does several things.
> 
> 1. List and define all AT system instructions to emulate and document
> the emulation design.
> 
> 2. Implement AT instruction handling logic in EL2. This will be used to
> emulate AT instructions executed in the virtual EL2.
> 
> AT instruction emulation works by loading the proper processor
> context, which depends on the trapped instruction and the virtual
> HCR_EL2, to the EL1 virtual memory control registers and executing AT
> instructions. Note that ctxt->hw_sys_regs is expected to have the
> proper processor context before calling the handling
> function(__kvm_at_insn) implemented in this patch.
> 
> 4. Emulate AT S1E[01] instructions by issuing the same instructions in
> EL2. We set the physical EL1 registers, NV and NV1 bits as described in
> the AT instruction emulation overview.
> 
> 5. Emulate AT A12E[01] instructions in two steps: First, do the stage-1
> translation by reusing the existing AT emulation functions.  Second, do
> the stage-2 translation by walking the guest hypervisor's stage-2 page
> table in software. Record the translation result to PAR_EL1.
> 
> 6. Emulate AT S1E2 instructions by issuing the corresponding S1E1
> instructions in EL2. We set the physical EL1 registers and the HCR_EL2
> register as described in the AT instruction emulation overview.
> 
> 7. Forward system instruction traps to the virtual EL2 if the corresponding
> virtual AT bit is set in the virtual HCR_EL2.
> 
>    [ Much logic above has been reworked by Marc Zyngier ]
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>   arch/arm64/include/asm/kvm_arm.h |   2 +
>   arch/arm64/include/asm/kvm_asm.h |   2 +
>   arch/arm64/include/asm/sysreg.h  |  17 +++
>   arch/arm64/kvm/hyp/Makefile      |   1 +
>   arch/arm64/kvm/hyp/at.c          | 217 +++++++++++++++++++++++++++++++
>   arch/arm64/kvm/hyp/switch.c      |  13 +-
>   arch/arm64/kvm/sys_regs.c        | 202 +++++++++++++++++++++++++++-
>   7 files changed, 450 insertions(+), 4 deletions(-)
>   create mode 100644 arch/arm64/kvm/hyp/at.c
> 

[...]

> +
> +void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> +{
> +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> +	struct mmu_config config;
> +	struct kvm_s2_mmu *mmu;
> +
> +	/*
> +	 * We can only get here when trapping from vEL2, so we're
> +	 * translating a guest guest VA.
> +	 *
> +	 * FIXME: Obtaining the S2 MMU for a a guest guest is horribly
> +	 * racy, and we may not find it.
> +	 */
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +
> +	mmu = lookup_s2_mmu(vcpu->kvm,
> +			    vcpu_read_sys_reg(vcpu, VTTBR_EL2),
> +			    vcpu_read_sys_reg(vcpu, HCR_EL2));
> +
> +	if (WARN_ON(!mmu))
> +		goto out;
> +
> +	/* We've trapped, so everything is live on the CPU. */
> +	__mmu_config_save(&config);
> +
> +	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
> +	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
> +	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
> +	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
> +	write_sysreg(kvm_get_vttbr(mmu),		vttbr_el2);
> +	/* FIXME: write S2 MMU VTCR_EL2 */
> +	write_sysreg(config.hcr & ~HCR_TGE,		hcr_el2);

All below AT S1E* operations may initiate stage-1 PTW. And stage-1 table 
walk addresses are themselves subject to stage-2 translation.

So should we enable stage-2 translation here by setting HCR_VM bit?

> +
> +	isb();
> +
> +	switch (op) {
> +	case OP_AT_S1E1R:
> +	case OP_AT_S1E1RP:
> +		asm volatile("at s1e1r, %0" : : "r" (vaddr));
> +		break;
> +	case OP_AT_S1E1W:
> +	case OP_AT_S1E1WP:
> +		asm volatile("at s1e1w, %0" : : "r" (vaddr));
> +		break;
> +	case OP_AT_S1E0R:
> +		asm volatile("at s1e0r, %0" : : "r" (vaddr));
> +		break;
> +	case OP_AT_S1E0W:
> +		asm volatile("at s1e0w, %0" : : "r" (vaddr));
> +		break;
> +	default:
> +		WARN_ON(1);
> +		break;
> +	}
> +
> +	isb();
> +
> +	ctxt->sys_regs[PAR_EL1] = read_sysreg(par_el1);
> +
> +	/*
> +	 * Failed? let's leave the building now.
> +	 *
> +	 * FIXME: how about a failed translation because the shadow S2
> +	 * wasn't populated? We may need to perform a SW PTW,
> +	 * populating our shadow S2 and retry the instruction.
> +	 */
> +	if (ctxt->sys_regs[PAR_EL1] & 1)
> +		goto nopan;
> +
> +	/* No PAN? No problem. */
> +	if (!(*vcpu_cpsr(vcpu) & PSR_PAN_BIT))
> +		goto nopan;
> +
> +	/*
> +	 * For PAN-involved AT operations, perform the same
> +	 * translation, using EL0 this time.
> +	 */
> +	switch (op) {
> +	case OP_AT_S1E1RP:
> +		asm volatile("at s1e0r, %0" : : "r" (vaddr));
> +		break;
> +	case OP_AT_S1E1WP:
> +		asm volatile("at s1e0w, %0" : : "r" (vaddr));
> +		break;
> +	default:
> +		goto nopan;
> +	}
> +
> +	/*
> +	 * If the EL0 translation has succeeded, we need to pretend
> +	 * the AT operation has failed, as the PAN setting forbids
> +	 * such a translation.
> +	 *
> +	 * FIXME: we hardcode a Level-3 permission fault. We really
> +	 * should return the real fault level.
> +	 */
> +	if (!(read_sysreg(par_el1) & 1))
> +		ctxt->sys_regs[PAR_EL1] = 0x1f;
> +
> +nopan:
> +	__mmu_config_restore(&config);
> +
> +out:
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +}
> +
> +void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> +{
> +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> +	struct mmu_config config;
> +	struct kvm_s2_mmu *mmu;
> +	u64 val;
> +
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +
> +	mmu = &vcpu->kvm->arch.mmu;
> +
> +	/* We've trapped, so everything is live on the CPU. */
> +	__mmu_config_save(&config);
> +
> +	if (vcpu_el2_e2h_is_set(vcpu)) {
> +		write_sysreg_el1(ctxt->sys_regs[TTBR0_EL2],	SYS_TTBR0);
> +		write_sysreg_el1(ctxt->sys_regs[TTBR1_EL2],	SYS_TTBR1);
> +		write_sysreg_el1(ctxt->sys_regs[TCR_EL2],	SYS_TCR);
> +		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL2],	SYS_SCTLR);
> +
> +		val = config.hcr;
> +	} else {
> +		write_sysreg_el1(ctxt->sys_regs[TTBR0_EL2],	SYS_TTBR0);
> +		write_sysreg_el1(translate_tcr(ctxt->sys_regs[TCR_EL2]),
> +				 SYS_TCR);
> +		write_sysreg_el1(translate_sctlr(ctxt->sys_regs[SCTLR_EL2]),
> +				 SYS_SCTLR);
> +
> +		val = config.hcr | HCR_NV | HCR_NV1;
> +	}
> +
> +	write_sysreg(kvm_get_vttbr(mmu),		vttbr_el2);
> +	/* FIXME: write S2 MMU VTCR_EL2 */
> +	write_sysreg(val & ~HCR_TGE,			hcr_el2);

And here the same.

> +
> +	isb();
> +
> +	switch (op) {
> +	case OP_AT_S1E2R:
> +		asm volatile("at s1e1r, %0" : : "r" (vaddr));
> +		break;
> +	case OP_AT_S1E2W:
> +		asm volatile("at s1e1w, %0" : : "r" (vaddr));
> +		break;
> +	default:
> +		WARN_ON(1);
> +		break;
> +	}
> +
> +	isb();
> +
> +	/* FIXME: handle failed translation due to shadow S2 */
> +	ctxt->sys_regs[PAR_EL1] = read_sysreg(par_el1);
> +
> +	__mmu_config_restore(&config);
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +}

Thanks,
Tomasz

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
