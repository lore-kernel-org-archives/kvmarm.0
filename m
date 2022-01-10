Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE3DC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 10:48:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8514B13A;
	Mon, 10 Jan 2022 05:48:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FquiA16PQbuX; Mon, 10 Jan 2022 05:48:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2968A4B149;
	Mon, 10 Jan 2022 05:48:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34DDC4B139
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 05:48:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Hrp6J9XmXJd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 05:48:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D98A14B137
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 05:48:35 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44BDEED1;
 Mon, 10 Jan 2022 02:48:35 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 75DFC3F5A1;
 Mon, 10 Jan 2022 02:48:32 -0800 (PST)
Date: Mon, 10 Jan 2022 10:48:41 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: mixed-width check should be skipped for
 uninitialized vCPUs
Message-ID: <YdwPCcZWD8Uc1eej@monolith.localdoman>
References: <20220110054042.1079932-1-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220110054042.1079932-1-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Hi Reiji,

On Sun, Jan 09, 2022 at 09:40:41PM -0800, Reiji Watanabe wrote:
> vcpu_allowed_register_width() checks if all the VCPUs are either
> all 32bit or all 64bit.  Since the checking is done even for vCPUs
> that are not initialized (KVM_ARM_VCPU_INIT has not been done) yet,
> the non-initialized vCPUs are erroneously treated as 64bit vCPU,
> which causes the function to incorrectly detect a mixed-width VM.
> 
> Fix vcpu_allowed_register_width() to skip the check for vCPUs that
> are not initialized yet.
> 
> Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/reset.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 426bd7fbc3fd..ef78bbc7566a 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -180,8 +180,19 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
>  	if (kvm_has_mte(vcpu->kvm) && is32bit)
>  		return false;
>  
> +	/*
> +	 * Make sure vcpu->arch.target setting is visible from others so
> +	 * that the width consistency checking between two vCPUs is done
> +	 * by at least one of them at KVM_ARM_VCPU_INIT.
> +	 */
> +	smp_mb();

From ARM DDI 0487G.a, page B2-146 ("Data Memory Barrier (DMB)"):

"The DMB instruction is a memory barrier instruction that ensures the relative
order of memory accesses before the barrier with memory accesses after the
barrier."

I'm going to assume from the comment that you are referring to completion of
memory accesses ("Make sure [..] is visible from others"). Please correct me if
I am wrong. In this case, DMB ensures ordering of memory accesses with regards
to writes and reads, not *completion*.  Have a look at
tools/memory-model/litmus-tests/MP+fencewmbonceonce+fencermbonceonce.litmus for
the classic message passing example as an example of memory ordering.
Message passing and other patterns are also explained in ARM DDI 0487G.a, page
K11-8363.

I'm not saying that your approach is incorrect, but the commit message should
explain what memory accesses are being ordered relative to each other and why.

Thanks,
Alex

> +
>  	/* Check that the vcpus are either all 32bit or all 64bit */
>  	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> +		/* Skip if KVM_ARM_VCPU_INIT is not done for the vcpu yet */
> +		if (tmp->arch.target == -1)
> +			continue;
> +
>  		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
>  			return false;
>  	}
> 
> base-commit: df0cc57e057f18e44dac8e6c18aba47ab53202f9
> -- 
> 2.34.1.575.g55b058a8bb-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
