Return-Path: <SRS0=phmX=MT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10656C432BE
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 18:11:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E02D60F59
	for <kvmarm@archiver.kernel.org>; Tue, 27 Jul 2021 18:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9E02D60F59
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EA404A534;
	Tue, 27 Jul 2021 14:11:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F0Cdtx67GOFM; Tue, 27 Jul 2021 14:11:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 372DA4A5A0;
	Tue, 27 Jul 2021 14:11:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4D14A531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 14:11:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id goK6voy-iq5I for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Jul 2021 14:11:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94A4A4A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jul 2021 14:11:14 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99D7C60E08;
 Tue, 27 Jul 2021 18:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627409473;
 bh=Ur9pPprRGIm8RpSOIFYLtAZgxXBn8A4m1Hk9iN9rkZc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=e/ICnhp6aRMvqV04av0WLSCRwkFNQARS2FeYE73O8FFruDTT08mE1JSXZRCFs9oGE
 er58B9wzWaHOMFVXzixU1Cpzxc4HLo8nXU5ZVCbrAwtsB4WvrBLEBVg1S8Y/4UUsxT
 WX5J+1jZA/oiK9jV2Uy55Efn9cAKule7OT2mBjrixbZfAlr8WE7+nC4ufK1ldFNVd6
 SET5afmktu2rLx5qD8oIt15eXdgWbIaBS0a7bLNSY02wrzeU0giD99SlI2+HM3hDql
 Z6Kb/5pXpTKND+qlOZEFh7NpLyWNuTOA1RBiDrEASbAdtd2Toti/IFGZchJnWldb2K
 Pzslq2gLCrdXA==
Date: Tue, 27 Jul 2021 19:11:08 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <20210727181107.GC19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-5-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Jul 15, 2021 at 05:31:47PM +0100, Marc Zyngier wrote:
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
>  arch/arm64/kvm/mmu.c              | 115 ++++++++++++++++++++++++++++++
>  3 files changed, 122 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4add6c27251f..914c1b7bb3ad 100644
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
> index b52c5c4b9a3d..f6b8fc1671b3 100644
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
> index 3155c9e778f0..638827c8842b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1120,6 +1120,121 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  		kvm_set_pfn_accessed(pte_pfn(pte));
>  }
>  
> +#define MMIO_NOTE	('M' << 24 | 'M' << 16 | 'I' << 8 | '0')

Although this made me smile, maybe we should carve up the bit space a bit
more carefully ;) Also, you know somebody clever will "fix" that typo to
'O'!

Quentin, as the other user of this stuff at the moment, how do you see the
annotation space being allocated? Feels like we should have some 'type'
bits which decide how to parse the rest of the entry.

> +
> +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	struct kvm_mmu_memory_cache *memcache;
> +	struct kvm_memory_slot *memslot;
> +	int ret, idx;
> +
> +	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
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
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	memslot = gfn_to_memslot(vcpu->kvm, ipa >> PAGE_SHIFT);
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);

What does this memslot check achieve? A new memslot could be added after
you've checked, no?

> +/* Assumes mmu_lock taken */

You can use a lockdep assertion for that!

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
