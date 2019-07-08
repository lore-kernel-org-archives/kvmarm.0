Return-Path: <SRS0=Gv/P=VF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D06AC606A7
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jul 2019 09:28:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC41C20651
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jul 2019 09:28:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC41C20651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DBC84A536;
	Mon,  8 Jul 2019 05:28:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NFGE-o5haO5J; Mon,  8 Jul 2019 05:28:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FFAC4A503;
	Mon,  8 Jul 2019 05:28:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEE654A503
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jul 2019 05:28:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8e577AIEDn+I for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jul 2019 05:28:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD2FA4A502
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jul 2019 05:28:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29858360;
 Mon,  8 Jul 2019 02:28:28 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18C103F246;
 Mon,  8 Jul 2019 02:28:26 -0700 (PDT)
Date: Mon, 8 Jul 2019 10:28:24 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Initialise host's MPIDRs by reading the
 actual register
Message-ID: <20190708102824.01670aed@donnerap.cambridge.arm.com>
In-Reply-To: <20190706101311.15500-1-marc.zyngier@arm.com>
References: <20190706101311.15500-1-marc.zyngier@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Sat, 6 Jul 2019 11:13:11 +0100
Marc Zyngier <marc.zyngier@arm.com> wrote:

Hi,

> As part of setting up the host context, we populate its
> MPIDR by using cpu_logical_map(). It turns out that contrary
> to arm64, cpu_logical_map() on 32bit ARM doesn't return the
> *full* MPIDR, but a truncated version.
> 
> This leaves the host MPIDR slightly corrupted after the first
> run of a VM, since we won't correctly restore the MPIDR on
> exit. Oops.
> 
> Since we cannot trust cpu_logical_map(), let's adopt a different
> strategy. We move the initialization of the host CPU context as
> part of the per-CPU initialization (which, in retrospect, makes
> a lot of sense), and directly read the MPIDR from the HW. This
> is guaranteed to work on both arm and arm64.

Many thanks for the quick patch, it indeed fixes it for me on the Midway.
Also briefly tested on arm64, still works.

Patch looks good to me, but I think we can loose the inclusion of
smp_plat.h, which the original patch introduced.
We might want to replace it with asm/cputype.h, the provider of
read_cpuid_mpidr(). It worked without it, though, as one of the headers
pulled it in.

> Reported-by: Andre Przywara <Andre.Przywara@arm.com>

Tested-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> Fixes: 32f139551954 ("arm/arm64: KVM: Statically configure the host's view of MPIDR")
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 5 ++---
>  arch/arm64/include/asm/kvm_host.h | 5 ++---
>  virt/kvm/arm/arm.c                | 3 ++-
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index e74e8f408987..df515dff536d 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -147,11 +147,10 @@ struct kvm_host_data {
>  
>  typedef struct kvm_host_data kvm_host_data_t;
>  
> -static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt,
> -					     int cpu)
> +static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
>  {
>  	/* The host's MPIDR is immutable, so let's set it up at boot time */
> -	cpu_ctxt->cp15[c0_MPIDR] = cpu_logical_map(cpu);
> +	cpu_ctxt->cp15[c0_MPIDR] = read_cpuid_mpidr();
>  }
>  
>  struct vcpu_reset_state {
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d9770daf3d7d..d1167fe71f9a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -484,11 +484,10 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>  
>  DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
>  
> -static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt,
> -					     int cpu)
> +static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
>  {
>  	/* The host's MPIDR is immutable, so let's set it up at boot time */
> -	cpu_ctxt->sys_regs[MPIDR_EL1] = cpu_logical_map(cpu);
> +	cpu_ctxt->sys_regs[MPIDR_EL1] = read_cpuid_mpidr();
>  }
>  
>  void __kvm_enable_ssbs(void);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index bd5c55916d0d..f149c79fd6ef 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1332,6 +1332,8 @@ static void cpu_hyp_reset(void)
>  
>  static void cpu_hyp_reinit(void)
>  {
> +	kvm_init_host_cpu_context(&this_cpu_ptr(&kvm_host_data)->host_ctxt);
> +
>  	cpu_hyp_reset();
>  
>  	if (is_kernel_in_hyp_mode())
> @@ -1569,7 +1571,6 @@ static int init_hyp_mode(void)
>  		kvm_host_data_t *cpu_data;
>  
>  		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
> -		kvm_init_host_cpu_context(&cpu_data->host_ctxt, cpu);
>  		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
>  
>  		if (err) {

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
