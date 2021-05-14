Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28709C433ED
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 14:07:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A20E161463
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 14:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A20E161463
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FBEE4B996;
	Fri, 14 May 2021 10:07:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bwfe22aaZIJ1; Fri, 14 May 2021 10:07:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BABAB4B97C;
	Fri, 14 May 2021 10:07:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EB494B97A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 10:07:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9jmlgmPvXq1E for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 May 2021 10:07:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA6D4B5A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 10:07:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E13C51763;
 Fri, 14 May 2021 07:07:48 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92C273F718;
 Fri, 14 May 2021 07:07:47 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] KVM: arm64: Commit pending PC adjustemnts before
 returning to userspace
To: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
References: <20210514104042.1929168-1-maz@kernel.org>
 <20210514104042.1929168-3-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c28efbe5-a269-fbf4-2a7e-b905386457bd@arm.com>
Date: Fri, 14 May 2021 15:08:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210514104042.1929168-3-maz@kernel.org>
Content-Language: en-US
Cc: stable@vger.kernel.org, kernel-team@android.com
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

On 5/14/21 11:40 AM, Marc Zyngier wrote:
> KVM currently updates PC (and the corresponding exception state)
> using a two phase approach: first by setting a set of flags,
> then by converting these flags into a state update when the vcpu
> is about to enter the guest.
>
> However, this creates a disconnect with userspace if the vcpu thread
> returns there with any exception/PC flag set. In this case, the exposed
> context is wrong, as userpsace doesn't have access to these flags

Nitpick: s/userpsace/userspace

> (they aren't architectural). It also means that these flags are
> preserved across a reset, which isn't expected.
>
> To solve this problem, force an explicit synchronisation of the
> exception state on vcpu exit to userspace. As an optimisation
> for nVHE systems, only perform this when there is something pending.
>
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org # 5.11
> ---
>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>  arch/arm64/kvm/arm.c               | 10 ++++++++++
>  arch/arm64/kvm/hyp/exception.c     |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |  8 ++++++++
>  4 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index d5b11037401d..5e9b33cbac51 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -63,6 +63,7 @@
>  #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
>  #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
>  #define __KVM_HOST_SMCCC_FUNC___pkvm_mark_hyp			20
> +#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			21
>  
>  #ifndef __ASSEMBLY__
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 1cb39c0803a4..c4fe2b71f429 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -897,6 +897,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  
>  	kvm_sigset_deactivate(vcpu);
>  
> +	/*
> +	 * In the unlikely event that we are returning to userspace
> +	 * with pending exceptions or PC adjustment, commit these
> +	 * adjustments in order to give userspace a consistent view of
> +	 * the vcpu state.
> +	 */
> +	if (unlikely(vcpu->arch.flags & (KVM_ARM64_PENDING_EXCEPTION |
> +					 KVM_ARM64_INCREMENT_PC)))
> +		kvm_call_hyp(__kvm_adjust_pc, vcpu);
> +
>  	vcpu_put(vcpu);
>  	return ret;
>  }
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 0812a496725f..11541b94b328 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -331,8 +331,8 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  }
>  
>  /*
> - * Adjust the guest PC on entry, depending on flags provided by EL1
> - * for the purpose of emulation (MMIO, sysreg) or exception injection.
> + * Adjust the guest PC (and potentially exception state) depending on
> + * flags provided by the emulation code.
>   */
>  void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index f36420a80474..1632f001f4ed 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -28,6 +28,13 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
>  	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
>  }
>  
> +static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> +
> +	__kvm_adjust_pc(kern_hyp_va(vcpu));
> +}
> +
>  static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
>  {
>  	__kvm_flush_vm_context();
> @@ -170,6 +177,7 @@ typedef void (*hcall_t)(struct kvm_cpu_context *);
>  
>  static const hcall_t host_hcall[] = {
>  	HANDLE_FUNC(__kvm_vcpu_run),
> +	HANDLE_FUNC(__kvm_adjust_pc),
>  	HANDLE_FUNC(__kvm_flush_vm_context),
>  	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
>  	HANDLE_FUNC(__kvm_tlb_flush_vmid),

I'm guessing that the comment mentioned in the cover letter should be in this
patch, right? Or is the changelog from the cover letter stale?

Regardless, I trust your judgement regarding the comment and the patch looks correct:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
