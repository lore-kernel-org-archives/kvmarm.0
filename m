Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475CAC43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 11:58:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96C3E2100A
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 11:58:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MweCyFFM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96C3E2100A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4AF64B21E;
	Fri, 18 Sep 2020 07:58:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dU6x3d8t7AAo; Fri, 18 Sep 2020 07:58:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1DE64B223;
	Fri, 18 Sep 2020 07:58:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E67254B21E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 07:58:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Q7nn67oIKU5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 07:58:29 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D367F4B21D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 07:58:28 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A7EED2100A;
 Fri, 18 Sep 2020 11:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600430307;
 bh=TpvsNRIT0A6VtxEhgI5MhD7WAEWs8qrYhkK4T++wnP4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=MweCyFFMa++URq9mDUFNihVj7Vn8UJNHq5rPnvhtRln3QswuX+9z3bnLYnb+Eu7G3
 P7o0kuxSCd1yg1lH5h/+yoJ6ZaBNrRdX3F9VZlxFN3F9u66hEsWGGf8f9nbu0AdDFy
 Nr7yApqARdgFx0m+TO+rpa325DWaKqY/RU5ZE64E=
Date: Fri, 18 Sep 2020 12:58:22 +0100
From: Will Deacon <will@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 08/11] kvm: arm64: Create separate instances of
 kvm_host_data for VHE/nVHE
Message-ID: <20200918115821.GA31096@willie-the-truck>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-9-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200916173439.32265-9-dbrazdil@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
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

On Wed, Sep 16, 2020 at 06:34:36PM +0100, David Brazdil wrote:
> Host CPU context is stored in a global per-cpu variable `kvm_host_data`.
> In preparation for introducing independent per-CPU region for nVHE hyp,
> create two separate instances of `kvm_host_data`, one for VHE and one
> for nVHE.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  arch/arm64/kernel/image-vars.h    | 1 -
>  arch/arm64/kvm/arm.c              | 5 ++---
>  arch/arm64/kvm/hyp/nvhe/switch.c  | 3 +++
>  arch/arm64/kvm/hyp/vhe/switch.c   | 3 +++
>  arch/arm64/kvm/pmu.c              | 8 ++++----
>  6 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 905c2b87e05a..5d8c63f5e97e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -565,7 +565,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
>  
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>  
> -DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
> +DECLARE_KVM_HYP_PER_CPU(kvm_host_data_t, kvm_host_data);
>  
>  static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
>  {
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 59d12a0b4622..80da861b8180 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -67,7 +67,6 @@ KVM_NVHE_ALIAS(kvm_patch_vector_branch);
>  KVM_NVHE_ALIAS(kvm_update_va_mask);
>  
>  /* Global kernel state accessed by nVHE hyp code. */
> -KVM_NVHE_ALIAS(kvm_host_data);
>  KVM_NVHE_ALIAS(kvm_vgic_global_state);
>  
>  /* Kernel constant needed to compute idmap addresses. */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3bdc2661d276..7af9809fa193 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -46,7 +46,6 @@
>  __asm__(".arch_extension	virt");
>  #endif
>  
> -DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
>  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
>  
>  /* The VMID used in the VTTBR */
> @@ -1308,7 +1307,7 @@ static void cpu_hyp_reset(void)
>  
>  static void cpu_hyp_reinit(void)
>  {
> -	kvm_init_host_cpu_context(&this_cpu_ptr(&kvm_host_data)->host_ctxt);
> +	kvm_init_host_cpu_context(&this_cpu_ptr_hyp(kvm_host_data)->host_ctxt);
>  
>  	cpu_hyp_reset();
>  
> @@ -1543,7 +1542,7 @@ static int init_hyp_mode(void)
>  	for_each_possible_cpu(cpu) {
>  		kvm_host_data_t *cpu_data;
>  
> -		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
> +		cpu_data = per_cpu_ptr_hyp(kvm_host_data, cpu);

I stand by my earlier comment to add _sym here, given that the ampersand
gets dropped from the argument.

So assuming you do that in the earlier patch:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
