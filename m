From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] arm/arm64: Introduce mmu_disable
Date: Fri, 3 Jul 2015 19:42:58 +0200
Message-ID: <5596C9A2.6050304@redhat.com>
References: <1435257911-9715-1-git-send-email-drjones@redhat.com>
 <1435257911-9715-2-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B341579ED
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 13:31:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pqbhuZoxvL31 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 13:31:41 -0400 (EDT)
Received: from mail-wg0-f47.google.com (mail-wg0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D308579EB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 13:31:40 -0400 (EDT)
Received: by wgck11 with SMTP id k11so93592363wgc.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jul 2015 10:43:00 -0700 (PDT)
In-Reply-To: <1435257911-9715-2-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 25/06/2015 20:45, Andrew Jones wrote:
> Allow unit test cpus to disable the MMU. Why not? We want the
> test framework to be as flexible as possible. Callers will have
> to deal with the cache coherency fallout... Cache flush support
> is still forthcoming to the framework though.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/cstart.S          | 9 +++++++++
>  arm/cstart64.S        | 8 ++++++++
>  lib/arm/asm/mmu-api.h | 1 +
>  lib/arm/mmu.c         | 8 ++++++++
>  4 files changed, 26 insertions(+)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 2b7f8f3d200ef..3943867d2f219 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -159,6 +159,15 @@ asm_mmu_enable:
>  
>  	mov     pc, lr
>  
> +.globl asm_mmu_disable
> +asm_mmu_disable:
> +	/* SCTLR */
> +	mrc	p15, 0, r0, c1, c0, 0
> +	bic	r0, #CR_M
> +	mcr	p15, 0, r0, c1, c0, 0
> +	isb
> +	mov     pc, lr
> +
>  /*
>   * Vector stubs
>   * Simplified version of the Linux kernel implementation
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index cdda13c17af9e..44cff32d0f18e 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -146,6 +146,14 @@ asm_mmu_enable:
>  
>  	ret
>  
> +.globl asm_mmu_disable
> +asm_mmu_disable:
> +	mrs	x0, sctlr_el1
> +	bic	x0, x0, SCTLR_EL1_M
> +	msr	sctlr_el1, x0
> +	isb
> +	ret
> +
>  /*
>   * Vectors
>   * Adapted from arch/arm64/kernel/entry.S
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index 68dc707d67241..c46c4b08b14cc 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -4,6 +4,7 @@ extern pgd_t *mmu_idmap;
>  extern bool mmu_enabled(void);
>  extern void mmu_set_enabled(void);
>  extern void mmu_enable(pgd_t *pgtable);
> +extern void mmu_disable(void);
>  extern void mmu_enable_idmap(void);
>  extern void mmu_init_io_sect(pgd_t *pgtable, unsigned long virt_offset);
>  extern void mmu_set_range_sect(pgd_t *pgtable, unsigned long virt_offset,
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 732000a8eb088..5966b408cb455 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -35,6 +35,14 @@ void mmu_enable(pgd_t *pgtable)
>  	mmu_set_enabled();
>  }
>  
> +extern void asm_mmu_disable(void);
> +void mmu_disable(void)
> +{
> +	struct thread_info *ti = current_thread_info();
> +	cpumask_clear_cpu(ti->cpu, &mmu_enabled_cpumask);
> +	asm_mmu_disable();
> +}
> +
>  void mmu_set_range_ptes(pgd_t *pgtable, unsigned long virt_offset,
>  			unsigned long phys_start, unsigned long phys_end,
>  			pgprot_t prot)
> 

Applied, thanks.

Paolo
