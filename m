Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13DAC63697
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:58:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38A2524654
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:58:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38A2524654
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 686A94B488;
	Thu, 19 Nov 2020 11:58:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xcCJnNcQbVUN; Thu, 19 Nov 2020 11:58:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 144134B4AF;
	Thu, 19 Nov 2020 11:58:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02E9B4B48C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:58:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b0xq4fYSeTWC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 11:58:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D779B4B488
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:58:18 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66CBC1396;
 Thu, 19 Nov 2020 08:58:18 -0800 (PST)
Received: from [192.168.2.21] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4318D3F718;
 Thu, 19 Nov 2020 08:58:17 -0800 (PST)
From: James Morse <james.morse@arm.com>
Subject: Re: [RFC PATCH v3 01/16] KVM: arm64: Initialize VCPU mdcr_el2 before
 loading it
To: Alexandru Elisei <alexandru.elisei@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
 <20201027172705.15181-2-alexandru.elisei@arm.com>
Message-ID: <2058bc39-b2ea-602e-8e94-6caf470151ec@arm.com>
Date: Thu, 19 Nov 2020 16:58:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201027172705.15181-2-alexandru.elisei@arm.com>
Content-Language: en-GB
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alex,

On 27/10/2020 17:26, Alexandru Elisei wrote:
> When a VCPU is created, the kvm_vcpu struct is initialized to zero in
> kvm_vm_ioctl_create_vcpu(). On VHE systems, the first time
> vcpu.arch.mdcr_el2 is loaded on hardware is in vcpu_load(), before it is
> set to a sensible value in kvm_arm_setup_debug() later in the run loop. The
> result is that KVM executes for a short time with MDCR_EL2 set to zero.
> 
> This is mostly harmless as we don't need to trap debug and SPE register
> accesses from EL1 (we're still running in the host at EL2), but we do set
> MDCR_EL2.HPMN to 0 which is constrained unpredictable according to ARM DDI
> 0487F.b, page D13-3620; the required behavior from the hardware in this
> case is to reserve an unkown number of registers for EL2 and EL3 exclusive
> use.
> 
> Initialize mdcr_el2 in kvm_vcpu_vcpu_first_run_init(), so we can avoid the
> constrained unpredictable behavior and to ensure that the MDCR_EL2 register
> has the same value after each vcpu_load(), including the first time the
> VCPU is run.


> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 7a7e425616b5..22ee448aee2b 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -68,6 +68,59 @@ void kvm_arm_init_debug(void)

> +static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu, u32 host_mdcr)
> +{
> +	bool trap_debug = !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
> +
> +	/*
> +	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access
> +	 * to the profiling buffer.
> +	 */
> +	vcpu->arch.mdcr_el2 = host_mdcr & MDCR_EL2_HPMN_MASK;
> +	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
> +				MDCR_EL2_TPMS |
> +				MDCR_EL2_TPMCR |
> +				MDCR_EL2_TDRA |
> +				MDCR_EL2_TDOSA);

> +	if (vcpu->guest_debug) {
> +		/* Route all software debug exceptions to EL2 */
> +		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW)
> +			trap_debug = true;
> +	}

This had me confused for a while... could you hint that this is when the guest is being
'external' debugged by the VMM? (its clear-er before this change)


Thanks,

James


> +	/* Trap debug register access */
> +	if (trap_debug)
> +		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
> +
> +	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
> +}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
