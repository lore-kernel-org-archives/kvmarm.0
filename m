Return-Path: <SRS0=jAo2=DJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E9AC4363D
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 14:31:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8EAA4206A4
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 14:31:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VvWkwXpJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EAA4206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E38BA4B639;
	Fri,  2 Oct 2020 10:31:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WjNyJMm2-jRE; Fri,  2 Oct 2020 10:31:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6BAB4B632;
	Fri,  2 Oct 2020 10:31:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62B2E4B627
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 10:31:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nqPtX0fOERsR for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2020 10:31:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B6954B5BF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 10:31:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1601649065;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=6w0V8EWUZL7+ka00V8gnHTVP9p//YAdOcs3LvFlyo4Y=;
 b=VvWkwXpJK73XNCv4wV+9kF+BOVlidXVQeGkG+tnz9XL/IJtEQP50S9am2aKyuOKAyVrdEp
 ZbiDW9Jky0L+ZaedVh7RNYVhphD9Fjg0rsWDPNagIsJRCUNjcELv5bS4wWJVEDc9hlP5uE
 8dlo0tXraHav5IgBa9/5m7COG4s2Kvs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-Pkq3nWpoON6r4qTB-DF20w-1; Fri, 02 Oct 2020 10:31:00 -0400
X-MC-Unique: Pkq3nWpoON6r4qTB-DF20w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 070B48015B0;
 Fri,  2 Oct 2020 14:30:57 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.110])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1ADD35D9D3;
 Fri,  2 Oct 2020 14:30:52 +0000 (UTC)
Date: Fri, 2 Oct 2020 16:30:50 +0200
From: Andrew Jones <drjones@redhat.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 2/2] arm64: kvm: Introduce MTE VCPU feature
Message-ID: <20201002143050.zamkpmqysy6k5ngl@kamzik.brq.redhat.com>
References: <20200925093607.3051-1-steven.price@arm.com>
 <20200925093607.3051-3-steven.price@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200925093607.3051-3-steven.price@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
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

On Fri, Sep 25, 2020 at 10:36:07AM +0100, Steven Price wrote:
> Add a new VM feature 'KVM_ARM_CAP_MTE' which enables memory tagging
> for a VM. This exposes the feature to the guest and automatically tags
> memory pages touched by the VM as PG_mte_tagged (and clears the tags
> storage) to ensure that the guest cannot see stale tags, and so that the
> tags are correctly saved/restored across swap.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  3 +++
>  arch/arm64/include/asm/kvm_host.h    |  3 +++
>  arch/arm64/kvm/arm.c                 |  9 +++++++++
>  arch/arm64/kvm/mmu.c                 | 15 +++++++++++++++
>  arch/arm64/kvm/sys_regs.c            |  6 +++++-
>  include/uapi/linux/kvm.h             |  1 +
>  6 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 49a55be2b9a2..4923a566ae6e 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -79,6 +79,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>  	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
>  	    vcpu_el1_is_32bit(vcpu))
>  		vcpu->arch.hcr_el2 |= HCR_TID2;
> +
> +	if (vcpu->kvm->arch.mte_enabled)
> +		vcpu->arch.hcr_el2 |= HCR_ATA;
>  }
>  
>  static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4f4360dd149e..1379300c1487 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -110,6 +110,9 @@ struct kvm_arch {
>  	 * supported.
>  	 */
>  	bool return_nisv_io_abort_to_user;
> +
> +	/* Memory Tagging Extension enabled for the guest */
> +	bool mte_enabled;
>  };
>  
>  struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 46dc3d75cf13..624edca0a1fa 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -87,6 +87,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = 0;
>  		kvm->arch.return_nisv_io_abort_to_user = true;
>  		break;
> +	case KVM_CAP_ARM_MTE:
> +		if (!system_supports_mte() || kvm->created_vcpus)
> +			return -EINVAL;
> +		r = 0;
> +		kvm->arch.mte_enabled = true;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -206,6 +212,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		 */
>  		r = 1;
>  		break;
> +	case KVM_CAP_ARM_MTE:
> +		r = system_supports_mte();
> +		break;
>  	default:
>  		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
>  		break;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ba00bcc0c884..befb9e1f0aa6 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1949,6 +1949,21 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (vma_pagesize == PAGE_SIZE && !force_pte)
>  		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>  							   &pfn, &fault_ipa);
> +	if (system_supports_mte() && kvm->arch.mte_enabled && pfn_valid(pfn)) {

'system_supports_mte() && kvm->arch.mte_enabled' is redundant, but I
assume system_supports_mte() is there to improve the efficiency of the
branch, as it's using cpus_have_const_cap(). Maybe a helper like

 static inline bool kvm_arm_mte_enabled(struct kvm *kvm)
 {
   return system_supports_mte() && kvm->arch.mte_enabled;
 }

would allow both the more efficient branch and look less confusing
where it gets used.

> +		/*
> +		 * VM will be able to see the page's tags, so we must ensure
> +		 * they have been initialised.
> +		 */
> +		struct page *page = pfn_to_page(pfn);
> +		long i, nr_pages = compound_nr(page);
> +
> +		/* if PG_mte_tagged is set, tags have already been initialised */
> +		for (i = 0; i < nr_pages; i++, page++) {
> +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> +				mte_clear_page_tags(page_address(page));
> +		}
> +	}
> +
>  	if (writable)
>  		kvm_set_pfn_dirty(pfn);
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a655f172b5ad..5010a47152b4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1132,7 +1132,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
>  		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
>  	} else if (id == SYS_ID_AA64PFR1_EL1) {
> -		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
> +		if (!vcpu->kvm->arch.mte_enabled)
> +			val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
>  	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
>  		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
>  			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> @@ -1394,6 +1395,9 @@ static bool access_mte_regs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>  				   const struct sys_reg_desc *rd)
>  {
> +	if (vcpu->kvm->arch.mte_enabled)
> +		return 0;
> +
>  	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
>  }
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6d86033c4fa..87678ed82ab4 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1035,6 +1035,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_LAST_CPU 184
>  #define KVM_CAP_SMALLER_MAXPHYADDR 185
>  #define KVM_CAP_S390_DIAG318 186
> +#define KVM_CAP_ARM_MTE 188
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.20.1
> 
>

Besides the helper suggestion nit

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
