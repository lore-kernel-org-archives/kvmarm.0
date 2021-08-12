Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD4A1C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:53:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 422C560FBF
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:53:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 422C560FBF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C067F407EC;
	Thu, 12 Aug 2021 05:53:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mrT-84NCsQsM; Thu, 12 Aug 2021 05:53:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDF7E407F4;
	Thu, 12 Aug 2021 05:53:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B56B4407F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:53:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KoJjSfP8dr8B for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 05:53:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7D4A407EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:53:46 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F3D160EB9;
 Thu, 12 Aug 2021 09:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628762024;
 bh=8XFM14K7kKN0l/+uki0YeLpUShrJFjJTlweUW//YX9Q=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=k9TYlALwCXVzH3+KaEt2QnWfDx4lBTVGzLXbtIhA9S+5ZdGElwQ5jOltSn7jpFSb6
 hYUsaGUJqWi1fuCHorBIET+c+9zW/5BzQyTBERYgeLuLdPlHzMFvq/lRukJcjudWih
 4MStLVfi4KVHLkpaUpYDrBrYIVh9odqyFPDMhqK/DOLEkezOj8FF3Ijh/8COy4vkEu
 ipfEwesSN+Cq5avEt1xO1p+wf8Nl9ommH1u9J7Y3/UwWSed6x6FpeKoUJNksKf+O1p
 f8o1Ax0tEAbj2K3fyUqK5DTW739ptxn9uTnaFn7KGVd4hi1JMAxnFyUUBwDBw0nk7A
 Xcn4KTfWoyI2w==
Date: Thu, 12 Aug 2021 10:53:39 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 13/15] KVM: arm64: Trap access to pVM restricted
 features
Message-ID: <20210812095338.GK5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-14-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-14-tabba@google.com>
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

On Mon, Jul 19, 2021 at 05:03:44PM +0100, Fuad Tabba wrote:
> Trap accesses to restricted features for VMs running in protected
> mode.
> 
> Access to feature registers are emulated, and only supported
> features are exposed to protected VMs.
> 
> Accesses to restricted registers as well as restricted
> instructions are trapped, and an undefined exception is injected
> into the protected guests, i.e., with EC = 0x0 (unknown reason).
> This EC is the one used, according to the Arm Architecture
> Reference Manual, for unallocated or undefined system registers
> or instructions.
> 
> Only affects the functionality of protected VMs. Otherwise,
> should not affect non-protected VMs when KVM is running in
> protected mode.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  3 ++
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 52 ++++++++++++++++++-------
>  2 files changed, 41 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 5a2b89b96c67..8431f1514280 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -33,6 +33,9 @@
>  extern struct exception_table_entry __start___kvm_ex_table;
>  extern struct exception_table_entry __stop___kvm_ex_table;
>  
> +int kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu);
> +int kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu);
> +
>  /* Check whether the FP regs were dirtied while in the host-side run loop: */
>  static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 36da423006bd..99bbbba90094 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -158,30 +158,54 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
>  		write_sysreg(pmu->events_host, pmcntenset_el0);
>  }
>  
> +/**
> + * Handle system register accesses for protected VMs.
> + *
> + * Return 1 if handled, or 0 if not.
> + */
> +static int handle_pvm_sys64(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) ?
> +			     kvm_handle_pvm_sys64(vcpu) :
> +			     0;
> +}

Why don't we move the kvm_vm_is_protected() check into
kvm_get_hyp_exit_handler() so we can avoid adding it to each handler
instead?

Either way:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
