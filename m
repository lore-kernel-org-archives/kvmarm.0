Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA08C636C9
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:31:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8409E61246
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:31:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8409E61246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16C264B116;
	Wed, 21 Jul 2021 12:31:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vzNyGIsKUMIj; Wed, 21 Jul 2021 12:31:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 829AC4B114;
	Wed, 21 Jul 2021 12:31:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 144754B10E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:31:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vqLF7w-xJvML for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 12:31:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC7164B0C5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:31:45 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94EDF60FF3;
 Wed, 21 Jul 2021 16:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1626885104;
 bh=b+eyZKwXabnVt+UjMV9OoFipdi6nkiIvKOjz34qdmyU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Q/Kp5r04BDGIq0tKftkH8+P/tDazAi/vkiZ2bx3TbNLkTUpGZ5KqFK6XlqETvPGWs
 tECA1E08WuXB81889LUTDQAPms55KzycEkQi3Eiz6UsRKYAYF6eaO9+7d+QXM9v4ge
 yeFk1WMgoR/sKFTjLAq56pZ48rr823kk70dDlUfCnIYBMV1Q5snj42ZeIRsyYV6Dxw
 f45/atVNb/rrxq0QpBqxh+7FzLsE5zq14324k7tKcq2NjGZbE4gQIOZjFP6841Pnih
 7mQBBxS1XMuXc4BAh+t6nxG8cPh9v7Uz2CcXsVu8WYRj7RMu2feJqqJWYvA2Hid+mK
 b42QWSiMRdL9Q==
Date: Wed, 21 Jul 2021 17:31:39 +0100
From: Will Deacon <will@kernel.org>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 3/3] kvm/arm: Align the VMID allocation with the arm64
 ASID one
Message-ID: <20210721163138.GD11003@willie-the-truck>
References: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
 <20210616155606.2806-4-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210616155606.2806-4-shameerali.kolothum.thodi@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: jean-philippe@linaro.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
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

[+Quentin]

On Wed, Jun 16, 2021 at 04:56:06PM +0100, Shameer Kolothum wrote:
> From: Julien Grall <julien.grall@arm.com>
> 
> At the moment, the VMID algorithm will send an SGI to all the CPUs to
> force an exit and then broadcast a full TLB flush and I-Cache
> invalidation.
> 
> This patch use the new VMID allocator. The
> benefits are:
>     - CPUs are not forced to exit at roll-over. Instead the VMID will be
>     marked reserved and the context will be flushed at next exit. This
>     will reduce the IPIs traffic.
>     - Context invalidation is now per-CPU rather than broadcasted.
>     - Catalin has a formal model of the ASID allocator.
> 
> With the new algo, the code is now adapted:
>     - The function __kvm_flush_vm_context() has been renamed to
>     __kvm_tlb_flush_local_all() and now only flushing the current CPU
>     context.
>     - The call to update_vmid() will be done with preemption disabled
>     as the new algo requires to store information per-CPU.
>     - The TLBs associated to EL1 will be flushed when booting a CPU to
>     deal with stale information. This was previously done on the
>     allocation of the first VMID of a new generation.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h      |   4 +-
>  arch/arm64/include/asm/kvm_host.h     |   6 +-
>  arch/arm64/include/asm/kvm_mmu.h      |   3 +-
>  arch/arm64/kvm/Makefile               |   2 +-
>  arch/arm64/kvm/arm.c                  | 115 +++++++-------------------
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c    |   6 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |   3 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c         |  10 +--
>  arch/arm64/kvm/hyp/vhe/tlb.c          |  10 +--
>  arch/arm64/kvm/mmu.c                  |   1 -
>  10 files changed, 52 insertions(+), 108 deletions(-)

[...]

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 75a7e8071012..d96284da8571 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -70,9 +70,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>  void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
>  
>  struct kvm_vmid {
> -	/* The VMID generation used for the virt. memory system */
> -	u64    vmid_gen;
> -	u32    vmid;
> +	atomic64_t id;

Maybe a typedef would be better if this is the only member of the structure?

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 4b60c0056c04..a02c4877a055 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -106,8 +106,7 @@ int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool)
>  	mmu->pgd_phys = __hyp_pa(host_kvm.pgt.pgd);
>  	mmu->arch = &host_kvm.arch;
>  	mmu->pgt = &host_kvm.pgt;
> -	mmu->vmid.vmid_gen = 0;
> -	mmu->vmid.vmid = 0;
> +	atomic64_set(&mmu->vmid.id, 0);

I think this is the first atomic64 use in the EL2 object, which may pull in
some fatal KCSAN instrumentation. Quentin, have you run into this before?

Might be simple just to zero-initialise mmu for now, if it isn't already.

> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index 83dc3b271bc5..42df9931ed9a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -140,10 +140,10 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
>  	__tlb_switch_to_host(&cxt);
>  }
>  
> -void __kvm_flush_vm_context(void)
> +void __kvm_tlb_flush_local_all(void)
>  {
> -	dsb(ishst);
> -	__tlbi(alle1is);
> +	dsb(nshst);
> +	__tlbi(alle1);
>  
>  	/*
>  	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
> @@ -155,7 +155,7 @@ void __kvm_flush_vm_context(void)
>  	 *
>  	 */
>  	if (icache_is_vpipt())
> -		asm volatile("ic ialluis");
> +		asm volatile("ic iallu" : : );
>  
> -	dsb(ish);
> +	dsb(nsh);

Hmm, I'm wondering whether having this local stuff really makes sense for
VMIDs. For ASIDs, where rollover can be frequent and TLBI could result in
IPI on 32-bit, the local option was important, but here rollover is less
frequent, DVM is relied upon to work and the cost of a hypercall is
significant with nVHE.

So I do think you could simplify patch 2 slightly to drop the
flush_pending and just issue inner-shareable invalidation on rollover.
With that, it might also make it straightforward to clear active_asids
when scheduling out a vCPU, which would solve the other problem I mentioned
about unnecessarily reserving a bunch of the VMID space.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
