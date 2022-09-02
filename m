Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC450C38145
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 14:47:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59CA041173;
	Fri,  2 Sep 2022 10:47:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xUW6OBmZHohb; Fri,  2 Sep 2022 10:47:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB12410FF;
	Fri,  2 Sep 2022 10:47:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97269410DE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 10:47:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nEnhv97cq4NV for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 10:47:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 552724966F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 10:47:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FCD7D6E;
 Fri,  2 Sep 2022 07:47:48 -0700 (PDT)
Received: from [10.57.45.3] (unknown [10.57.45.3])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BE413F766;
 Fri,  2 Sep 2022 07:47:39 -0700 (PDT)
Message-ID: <aa621adb-d5ec-2c90-be1b-cf3d048afa0a@arm.com>
Date: Fri, 2 Sep 2022 15:47:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 5/7] KVM: arm64: unify the tests for VMAs in memslots
 when MTE is enabled
Content-Language: en-GB
To: Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-6-pcc@google.com>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <20220810193033.1090251-6-pcc@google.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Cornelia Huck <cohuck@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>
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

On 10/08/2022 20:30, Peter Collingbourne wrote:
> Previously we allowed creating a memslot containing a private mapping that
> was not VM_MTE_ALLOWED, but would later reject KVM_RUN with -EFAULT. Now
> we reject the memory region at memslot creation time.
> 
> Since this is a minor tweak to the ABI (a VMM that created one of
> these memslots would fail later anyway), no VMM to my knowledge has
> MTE support yet, and the hardware with the necessary features is not
> generally available, we can probably make this ABI change at this point.
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 750a69a97994..d54be80e31dd 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1073,6 +1073,19 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>  	}
>  }
>  
> +static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
> +{
> +	/*
> +	 * VM_SHARED mappings are not allowed with MTE to avoid races
> +	 * when updating the PG_mte_tagged page flag, see
> +	 * sanitise_mte_tags for more details.
> +	 */
> +	if (vma->vm_flags & VM_SHARED)
> +		return false;
> +
> +	return vma->vm_flags & VM_MTE_ALLOWED;
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>  			  unsigned long fault_status)
> @@ -1249,9 +1262,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	}
>  
>  	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
> -		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
> -		if ((vma->vm_flags & VM_MTE_ALLOWED) &&
> -		    !(vma->vm_flags & VM_SHARED)) {
> +		/* Check the VMM hasn't introduced a new disallowed VMA */
> +		if (kvm_vma_mte_allowed(vma)) {
>  			sanitise_mte_tags(kvm, pfn, vma_pagesize);
>  		} else {
>  			ret = -EFAULT;
> @@ -1695,12 +1707,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  		if (!vma)
>  			break;
>  
> -		/*
> -		 * VM_SHARED mappings are not allowed with MTE to avoid races
> -		 * when updating the PG_mte_tagged page flag, see
> -		 * sanitise_mte_tags for more details.
> -		 */
> -		if (kvm_has_mte(kvm) && vma->vm_flags & VM_SHARED) {
> +		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
>  			ret = -EINVAL;
>  			break;
>  		}

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
