Return-Path: <SRS0=Brgg=X4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33146C10F14
	for <kvmarm@archiver.kernel.org>; Thu,  3 Oct 2019 11:10:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E59DA21D81
	for <kvmarm@archiver.kernel.org>; Thu,  3 Oct 2019 11:10:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E59DA21D81
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1454A78D;
	Thu,  3 Oct 2019 07:10:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 375BLenFZZvn; Thu,  3 Oct 2019 07:10:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 898574A791;
	Thu,  3 Oct 2019 07:10:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C55F24A78D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Oct 2019 07:10:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RsotZT-sov3j for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Oct 2019 07:10:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF8F44A789
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Oct 2019 07:10:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 649C31000;
 Thu,  3 Oct 2019 04:10:26 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4658B3F706;
 Thu,  3 Oct 2019 04:10:25 -0700 (PDT)
Subject: Re: [PATCH 3/5] arm64: KVM: Disable EL1 PTW when invalidating S2 TLBs
To: Marc Zyngier <maz@kernel.org>
References: <20190925111941.88103-1-maz@kernel.org>
 <20190925111941.88103-4-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <030bbc8c-2304-5941-afc0-53f5a66fb143@arm.com>
Date: Thu, 3 Oct 2019 12:10:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190925111941.88103-4-maz@kernel.org>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On 25/09/2019 12:19, Marc Zyngier wrote:
> When erratum 1319367 is being worked around, special care must
> be taken not to allow the page table walker to populate TLBs
> while we have the stage-2 translation enabled (which would otherwise
> result in a bizare mix of the host S1 and the guest S2).
> 
> We enforce this by setting TCR_EL1.EPD{0,1} before restoring the S2
> configuration, and clear the same bits after having disabled S2.


Some comment Nits...

> diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
> index eb0efc5557f3..4ef0bf0d76a6 100644
> --- a/arch/arm64/kvm/hyp/tlb.c
> +++ b/arch/arm64/kvm/hyp/tlb.c
> @@ -63,6 +63,22 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
>  static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
>  						  struct tlb_inv_context *cxt)
>  {
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
> +		u64 val;
> +
> +		/*
> +		 * For CPUs that are affected by ARM 1319367, we need to
> +		 * avoid a host Stage-1 walk while we have the guest's

> +		 * Stage-2 set in the VTTBR in order to invalidate TLBs.

Isn't HCR_EL2.VM==0 for all this? I think its the VMID that matters here:
| ... have the guest's VMID set in VTTBR ...

?


> +		 * We're guaranteed that the S1 MMU is enabled, so we can
> +		 * simply set the EPD bits to avoid any further TLB fill.
> +		 */
> +		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
> +		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
> +		write_sysreg_el1(val, SYS_TCR);
> +		isb();
> +	}
> +
>  	__load_guest_stage2(kvm);
>  	isb();
>  }
> @@ -100,6 +116,13 @@ static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
>  						 struct tlb_inv_context *cxt)
>  {
>  	write_sysreg(0, vttbr_el2);
> +
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
> +		/* Ensure stage-2 is actually disabled */

| Ensure the host's VMID has been written

?


> +		isb();
> +		/* Restore the host's TCR_EL1 */
> +		write_sysreg_el1(cxt->tcr, SYS_TCR);
> +	}
>  }


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
