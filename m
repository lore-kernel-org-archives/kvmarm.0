Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69D2C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 11:38:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DB1A61184
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 11:38:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3DB1A61184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB1624B2B8;
	Wed,  6 Oct 2021 07:37:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x484MGP5UkBV; Wed,  6 Oct 2021 07:37:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 927CE4B29C;
	Wed,  6 Oct 2021 07:37:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82DB04B29C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 07:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IzxH2JYi9ZEi for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 07:37:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 755C44B297
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 07:37:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633520276;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=tLSJ+0G6GaESS3A8wROTGiXCvt9MmKxGWQIQfuIzv50=;
 b=PZou4TXLbMlhmkMfilag7ylf2LfKZGSdyyLP/c8Vu4YWo2uDFF2ZyUo1ukbm2A0g92uspw
 2ySyjkKTNGyaLY8YcyiCZSSl0AuYVKBVotlQ2S+neFPddyEfaO+JJq6yYZKv7YuFe4NIX/
 eSzUYZiW2/iu1Ge9uDFeILc99YYX7N4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-TngOT7_oPVWeyNLLlcHIHg-1; Wed, 06 Oct 2021 07:37:55 -0400
X-MC-Unique: TngOT7_oPVWeyNLLlcHIHg-1
Received: by mail-ed1-f71.google.com with SMTP id
 w6-20020a50d786000000b003dabc563406so2324846edi.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Oct 2021 04:37:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tLSJ+0G6GaESS3A8wROTGiXCvt9MmKxGWQIQfuIzv50=;
 b=J8qtmNnpodv4IBNyYHQ25TeWpWKdc3K8zeApWldsjOIgLADHyOia14T9Tm3ybQY4LE
 wrJYYw8JjQLgSKz71+ywM13OxhKk3YOJHqlf6rnFk4WhiSzqcr+gi6Hno5KIf9FbqJov
 WA8z5k/u2Q02maYQXIsGbstwnMeyfkPHssPHqA+GFFOqgdLMtpsSe8o01QN9K9Y2SzsC
 YXqRXnhVf7zs63XD4Ee9dDa/E35I99hxrkXaBdmGfyPjwcugkX7GJs6wLXTSduvPz7iE
 UOGffIqpGlb3iKWAML9ntrS/GiLdozjws/e+ZwJZQYnBuJnEciH65Xbd2k7a159v/Bfg
 pztg==
X-Gm-Message-State: AOAM530Ne3RNEJ66Tw5l41+Di7oHE6Sa8v1f3i5OKUs373te0kzniCy8
 PJD+wz2gLwgU04TWOisDKVpOxmBPu+GZ7/QWeraBGSZmKhpNWD0SjjEj9x03zX6KWeaLKHS4JWl
 Ip3HslV7HNyrMWYb7zK35Oxrm
X-Received: by 2002:a17:907:628d:: with SMTP id
 nd13mr32691153ejc.7.1633520274160; 
 Wed, 06 Oct 2021 04:37:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEEcX7nQiCt05CZwz558uZNZfwfw1lYcM5ACjQLLwDhsTkZqZlZFhhEMl7qA8+8LcuiVSErA==
X-Received: by 2002:a17:907:628d:: with SMTP id
 nd13mr32691131ejc.7.1633520273957; 
 Wed, 06 Oct 2021 04:37:53 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id dh16sm9840424edb.63.2021.10.06.04.37.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Oct 2021 04:37:53 -0700 (PDT)
Date: Wed, 6 Oct 2021 13:37:51 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <20211006113751.damskwaz7akpk5fc@gator.home>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-5-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211004174849.2831548-5-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Oct 04, 2021 at 06:48:37PM +0100, Marc Zyngier wrote:
> Introduce the infrastructure required to identify an IPA region
> that is expected to be used as an MMIO window.
> 
> This include mapping, unmapping and checking the regions. Nothing
> calls into it yet, so no expected functional change.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |   2 +
>  arch/arm64/include/asm/kvm_mmu.h  |   5 ++
>  arch/arm64/kvm/mmu.c              | 109 ++++++++++++++++++++++++++++++
>  3 files changed, 116 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f63ca8fb4e58..ba9781eb84d6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -125,6 +125,8 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
>  	/* Memory Tagging Extension enabled for the guest */
>  #define KVM_ARCH_FLAG_MTE_ENABLED			1
> +	/* Gues has bought into the MMIO guard extension */
> +#define KVM_ARCH_FLAG_MMIO_GUARD			2
>  	unsigned long flags;
>  
>  	/*
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 02d378887743..454a6265d45d 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -170,6 +170,11 @@ phys_addr_t kvm_mmu_get_httbr(void);
>  phys_addr_t kvm_get_idmap_vector(void);
>  int kvm_mmu_init(u32 *hyp_va_bits);
>  
> +/* MMIO guard */
> +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> +bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> +bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> +
>  static inline void *__kvm_vector_slot2addr(void *base,
>  					   enum arm64_hyp_spectre_vector slot)
>  {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1a94a7ca48f2..2470a55ca675 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1172,6 +1172,115 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  		kvm_set_pfn_accessed(pte_pfn(pte));
>  }
>  
> +/* Replace this with something more structured once day */

one day

> +#define MMIO_NOTE	(('M' << 24 | 'M' << 16 | 'I' << 8 | 'O') << 1)

Would it be better to have kvm_pgtable_stage2_annotate() shift its
inputs (<< 1) instead of requiring all annotations to remember that
requirement? Although the owner id is shifted 2 bits, but I'm not
sure why.

> +
> +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	struct kvm_mmu_memory_cache *memcache;
> +	struct kvm_memory_slot *memslot;
> +	struct kvm *kvm = vcpu->kvm;
> +	int ret, idx;
> +
> +	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &kvm->arch.flags))
> +		return false;
> +
> +	/* Must be page-aligned */
> +	if (ipa & ~PAGE_MASK)
> +		return false;
> +
> +	/*
> +	 * The page cannot be in a memslot. At some point, this will
> +	 * have to deal with device mappings though.
> +	 */
> +	idx = srcu_read_lock(&kvm->srcu);
> +	mutex_lock(&kvm->slots_arch_lock);
> +	memslot = gfn_to_memslot(kvm, ipa >> PAGE_SHIFT);
> +	if (memslot) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Guest has direct access to the GICv2 virtual CPU interface */
> +	if (irqchip_in_kernel(kvm) &&
> +	    kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
> +	    ipa == kvm->arch.vgic.vgic_cpu_base) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	memcache = &vcpu->arch.mmu_page_cache;
> +	if (kvm_mmu_topup_memory_cache(memcache,
> +				       kvm_mmu_cache_min_pages(kvm))) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	spin_lock(&kvm->mmu_lock);
> +	ret = kvm_pgtable_stage2_annotate(vcpu->arch.hw_mmu->pgt,
> +					  ipa, PAGE_SIZE, memcache,
> +					  MMIO_NOTE);
> +	spin_unlock(&kvm->mmu_lock);
> +
> +out:
> +	mutex_unlock(&kvm->slots_arch_lock);
> +	srcu_read_unlock(&kvm->srcu, idx);
> +	return ret == 0;

I guess the callers need this to return a boolean? Just seems odd that
pains were taken above to set ret to EINVAL/ENOMEM just to translate
that to true/false here though.

> +}
> +
> +static bool __check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	kvm_pte_t pte = 0;
> +	u32 level = 0;
> +	int ret;
> +
> +	lockdep_assert_held(&vcpu->kvm->mmu_lock);
> +
> +	ret = kvm_pgtable_get_leaf(vcpu->arch.hw_mmu->pgt, ipa, &pte, &level);
> +	VM_BUG_ON(ret);
> +	VM_BUG_ON(level >= KVM_PGTABLE_MAX_LEVELS);
> +
> +	/* Must be a PAGE_SIZE mapping with our annotation */
> +	return (BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level)) == PAGE_SIZE &&
> +		pte == MMIO_NOTE);
> +}
> +
> +bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	bool ret;
> +
> +	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
> +		return false;
> +
> +	/* Keep the PT locked across the two walks */
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +
> +	ret = __check_ioguard_page(vcpu, ipa);
> +	if (ret)		/* Drop the annotation */
> +		kvm_pgtable_stage2_unmap(vcpu->arch.hw_mmu->pgt,
> +					 ALIGN_DOWN(ipa, PAGE_SIZE), PAGE_SIZE);

How about

 if (ret) {
         /* Drop the annotation */
         kvm_pgtable_stage2_unmap(vcpu->arch.hw_mmu->pgt,
                                  ALIGN_DOWN(ipa, PAGE_SIZE), PAGE_SIZE);
 }

to be a bit easier to read.

> +
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +	return ret;
> +}
> +
> +bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	bool ret;
> +
> +	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
> +		return true;
> +
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +	ret = __check_ioguard_page(vcpu, ipa & PAGE_MASK);
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +
> +	if (!ret)
> +		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
> +
> +	return ret;
> +}
> +
>  /**
>   * kvm_handle_guest_abort - handles all 2nd stage aborts
>   * @vcpu:	the VCPU pointer
> -- 
> 2.30.2
>

Besides the nits

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
