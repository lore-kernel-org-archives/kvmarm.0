Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EF4C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jan 2022 12:12:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A3794A49C;
	Thu, 13 Jan 2022 07:12:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mOZWERpydxpe; Thu, 13 Jan 2022 07:12:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0725649F58;
	Thu, 13 Jan 2022 07:12:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAAB249F55
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 07:12:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WLh26Bg+vubN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jan 2022 07:12:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77A4549F54
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 07:12:00 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C6CDED1;
 Thu, 13 Jan 2022 04:11:59 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BB763F774;
 Thu, 13 Jan 2022 04:11:57 -0800 (PST)
Date: Thu, 13 Jan 2022 12:12:04 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 05/69] KVM: arm64: Allow preservation of the S2 SW bits
Message-ID: <YeAXFOR1wf3LekrQ@monolith.localdoman>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-6-maz@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

On Mon, Nov 29, 2021 at 08:00:46PM +0000, Marc Zyngier wrote:
> The S2 page table code has a limited use the SW bits, but we are about
> to need them to encode some guest Stage-2 information (its mapping size
> in the form of the TTL encoding).
> 
> Propagate the SW bits specified by the caller, and store them into
> the corresponding entry.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 8cdbc43fa651..d69e400b2de6 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1064,9 +1064,6 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  	u32 level;
>  	kvm_pte_t set = 0, clr = 0;
>  
> -	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
> -		return -EINVAL;
> -
>  	if (prot & KVM_PGTABLE_PROT_R)
>  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
>  
> @@ -1076,6 +1073,10 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  	if (prot & KVM_PGTABLE_PROT_X)
>  		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
>  
> +	/* Always propagate the SW bits */
> +	clr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_SW, 0xf);

Nitpick: isn't that the same as:

	clr |= KVM_PTE_LEAF_ATTR_HI_SW;

which looks more readable to me.

> +	set |= prot & KVM_PTE_LEAF_ATTR_HI_SW;

Checked stage2_attr_walker() callbak, first it clears the bits in clr, then
sets the bits in set, so this looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> +
>  	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
>  	if (!ret)
>  		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
