Return-Path: <SRS0=uL1D=U6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9061DC06510
	for <kvmarm@archiver.kernel.org>; Mon,  1 Jul 2019 08:03:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 182FD20673
	for <kvmarm@archiver.kernel.org>; Mon,  1 Jul 2019 08:03:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 182FD20673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77F2D4A4C1;
	Mon,  1 Jul 2019 04:03:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bAeWEbm3VzwQ; Mon,  1 Jul 2019 04:03:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31A4F4A49F;
	Mon,  1 Jul 2019 04:03:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75B964A49F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jul 2019 04:03:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LR8mgBj2+cAz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Jul 2019 04:03:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F400940A52
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jul 2019 04:03:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41CA72B;
 Mon,  1 Jul 2019 01:03:11 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECB0D3F718;
 Mon,  1 Jul 2019 01:03:09 -0700 (PDT)
Subject: Re: [PATCH 38/59] KVM: arm64: nv: Unmap/flush shadow stage 2 page
 tables
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-39-marc.zyngier@arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <d17216b4-59c7-5993-85d0-6ee7aa532852@arm.com>
Date: Mon, 1 Jul 2019 09:03:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-39-marc.zyngier@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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



On 21/06/2019 10:38, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Unmap/flush shadow stage 2 page tables for the nested VMs as well as the
> stage 2 page table for the guest hypervisor.
> 
> Note: A bunch of the code in mmu.c relating to MMU notifiers is
> currently dealt with in an extremely abrupt way, for example by clearing
> out an entire shadow stage-2 table. This will be handled in a more
> efficient way using the reverse mapping feature in a later version of
> the patch series.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h    |  3 +++
>  arch/arm64/include/asm/kvm_nested.h |  3 +++
>  arch/arm64/kvm/nested.c             | 39 +++++++++++++++++++++++++++
>  virt/kvm/arm/arm.c                  |  4 ++-
>  virt/kvm/arm/mmu.c                  | 42 +++++++++++++++++++++++------
>  5 files changed, 82 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 32bcaa1845dc..f4c5ac5eb95f 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -163,6 +163,8 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>  			   void __iomem **haddr);
>  int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>  			     void **haddr);
> +void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
> +			    phys_addr_t addr, phys_addr_t end);
>  void free_hyp_pgds(void);
>  
>  void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
> @@ -171,6 +173,7 @@ int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  			  phys_addr_t pa, unsigned long size, bool writable);
> +void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
>  
>  int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 052d46d96201..3b415bc76ced 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -48,6 +48,9 @@ extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
>  extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
>  				    struct kvm_s2_trans *trans);
>  extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
> +extern void kvm_nested_s2_wp(struct kvm *kvm);
> +extern void kvm_nested_s2_clear(struct kvm *kvm);
> +extern void kvm_nested_s2_flush(struct kvm *kvm);
>  int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>  extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>  extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 023027fa2db5..8880033fb6e0 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -456,6 +456,45 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
>  	return kvm_inject_nested_sync(vcpu, esr_el2);
>  }
>  
> +/* expects kvm->mmu_lock to be held */
> +void kvm_nested_s2_wp(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (kvm_s2_mmu_valid(mmu))
> +			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(kvm));
> +	}
> +}
> +
> +/* expects kvm->mmu_lock to be held */
> +void kvm_nested_s2_clear(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (kvm_s2_mmu_valid(mmu))
> +			kvm_unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
> +	}
> +}
> +
> +/* expects kvm->mmu_lock to be held */
> +void kvm_nested_s2_flush(struct kvm *kvm)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (kvm_s2_mmu_valid(mmu))
> +			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(kvm));
> +	}
> +}
> +
>  /*
>   * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
>   * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 4e3cbfa1ecbe..bcca27d5c481 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1005,8 +1005,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>  	 * Ensure a rebooted VM will fault in RAM pages and detect if the
>  	 * guest MMU is turned off and flush the caches as needed.
>  	 */
> -	if (vcpu->arch.has_run_once)
> +	if (vcpu->arch.has_run_once) {
>  		stage2_unmap_vm(vcpu->kvm);
> +		kvm_nested_s2_clear(vcpu->kvm);

The comment above kvm_nested_s2_clear() states that kvm->mmu_lock needs
to be taken, but in this state it isn't (stage2_unmap_vm() acquies the
lock and releases it).

Cheers,

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
