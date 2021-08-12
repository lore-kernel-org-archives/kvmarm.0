Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD05C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:57:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C652460F57
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:57:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C652460F57
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53EA0407EF;
	Thu, 12 Aug 2021 05:57:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id suospwceeCQl; Thu, 12 Aug 2021 05:57:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62AFA49F8F;
	Thu, 12 Aug 2021 05:57:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF4094086A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:57:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4vtmPZGO3vNZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 05:57:52 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF260407EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:57:51 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED9960F57;
 Thu, 12 Aug 2021 09:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628762269;
 bh=HxmpIxZ8vP71X/haLXmLN6MBqTPWJ4X2U98Wz3faOco=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=qi3GtSC95NtI+T6MxxcNybLmWFslRHvRU4ZDmPgyAoXbqx4EgyXqEnLVndjdRYaUe
 /Wgt8tZ9n4FTy+sfler2nLtrTLmuML0Uoj/RttYKi+nE9x8SQJepidfJYmEemGOfgP
 UGRkBZqW/HX9AsEjDgBGf7hq1/A7IJsqTRL03YUn/hMtiY7hwctM+HqysiEQXlfqBJ
 ZHCWU+Qo1HSJE/NFdGC1ZsUTImBJZp7yHuEziSB43FNJN0XHeBIigL2okY/EjPR9ok
 sL1F0NCCNRHHUEcQ7PQ4eXre5RZGobzyfcWG5dsVno/9VK3AMkNHeTLHg4PxMHD8l1
 izwVzHr89iTrg==
Date: Thu, 12 Aug 2021 10:57:44 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 14/15] KVM: arm64: Handle protected guests at 32 bits
Message-ID: <20210812095743.GL5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-15-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-15-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jul 19, 2021 at 05:03:45PM +0100, Fuad Tabba wrote:
> Protected KVM does not support protected AArch32 guests. However,
> it is possible for the guest to force run AArch32, potentially
> causing problems. Add an extra check so that if the hypervisor
> catches the guest doing that, it can prevent the guest from
> running again by resetting vcpu->arch.target and returning
> ARM_EXCEPTION_IL.
> 
> Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> AArch32 systems")
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 8431f1514280..f09343e15a80 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -23,6 +23,7 @@
>  #include <asm/kprobes.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_fixed_config.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
> @@ -477,6 +478,29 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
>  	}
>  
> +	/*
> +	 * Protected VMs might not be allowed to run in AArch32. The check below
> +	 * is based on the one in kvm_arch_vcpu_ioctl_run().
> +	 * The ARMv8 architecture doesn't give the hypervisor a mechanism to
> +	 * prevent a guest from dropping to AArch32 EL0 if implemented by the
> +	 * CPU. If the hypervisor spots a guest in such a state ensure it is
> +	 * handled, and don't trust the host to spot or fix it.
> +	 */
> +	if (unlikely(is_nvhe_hyp_code() &&
> +		     kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
> +		     FIELD_GET(FEATURE(ID_AA64PFR0_EL0),
> +			       PVM_ID_AA64PFR0_ALLOW) <
> +			     ID_AA64PFR0_ELx_32BIT_64BIT &&
> +		     vcpu_mode_is_32bit(vcpu))) {
> +		/*
> +		 * As we have caught the guest red-handed, decide that it isn't
> +		 * fit for purpose anymore by making the vcpu invalid.
> +		 */
> +		vcpu->arch.target = -1;
> +		*exit_code = ARM_EXCEPTION_IL;
> +		goto exit;
> +	}

Would this be better off inside the nvhe-specific run loop? Seems like we
could elide fixup_guest_exit() altogether if we've detect that we're in
AArch32 state when we shouldn't be and it would keep the code off the shared
path.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
