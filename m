Return-Path: <SRS0=bs2E=2C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03171C43603
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 11:33:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82FA020663
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 11:33:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82FA020663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE9484AEB8;
	Thu, 12 Dec 2019 06:33:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yuh18j6ziyWd; Thu, 12 Dec 2019 06:33:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB0254ACC4;
	Thu, 12 Dec 2019 06:33:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB844AC80
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 06:33:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eaOEKyB0BM95 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Dec 2019 06:33:32 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0C4F4A535
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 06:33:32 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ifMio-0000Lx-CN; Thu, 12 Dec 2019 12:33:30 +0100
To: <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>, <james.morse@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Re-check VMA on detecting a poisoned
 page
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Thu, 12 Dec 2019 11:33:30 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191211165651.7889-3-maz@kernel.org>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-3-maz@kernel.org>
Message-ID: <88f65ab4ac87f53534fbbfd2410d1cc5@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2019-12-11 16:56, Marc Zyngier wrote:
> When we check for a poisoned page, we use the VMA to tell userspace
> about the looming disaster. But we pass a pointer to this VMA
> after having released the mmap_sem, which isn't a good idea.
>
> Instead, re-check that we have still have a VMA, and that this
> VMA still points to a poisoned page. If the VMA isn't there,
> userspace is playing with our nerves, so lety's give it a -EFAULT
> (it deserves it). If the PFN isn't poisoned anymore, let's restart
> from the top and handle the fault again.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/mmu.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 0b32a904a1bb..f73393f5ddb7 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1741,9 +1741,30 @@ static int user_mem_abort(struct kvm_vcpu
> *vcpu, phys_addr_t fault_ipa,
>
>  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>  	if (pfn == KVM_PFN_ERR_HWPOISON) {
> -		kvm_send_hwpoison_signal(hva, vma);
> -		return 0;
> +		/*
> +		 * Search for the VMA again, as it may have been
> +		 * removed in the interval...
> +		 */
> +		down_read(&current->mm->mmap_sem);
> +		vma = find_vma_intersection(current->mm, hva, hva + 1);
> +		if (vma) {
> +			/*
> +			 * Recheck for a poisoned page. If something changed
> +			 * behind our back, don't do a thing and take the
> +			 * fault again.
> +			 */
> +			pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
> +			if (pfn == KVM_PFN_ERR_HWPOISON)
> +				kvm_send_hwpoison_signal(hva, vma);
> +
> +			ret = 0;
> +		} else {
> +			ret = -EFAULT;
> +		}
> +		up_read(&current->mm->mmap_sem);
> +		return ret;
>  	}
> +
>  	if (is_error_noslot_pfn(pfn))
>  		return -EFAULT;

Revisiting this, I wonder if we're not better off just holding the 
mmap_sem
for a bit longer. Something like:

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0b32a904a1bb..87d416d000c6 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1719,13 +1719,13 @@ static int user_mem_abort(struct kvm_vcpu 
*vcpu, phys_addr_t fault_ipa,
  	if (vma_pagesize == PMD_SIZE ||
  	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
  		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
-	up_read(&current->mm->mmap_sem);
-
  	/* We need minimum second+third level pages */
  	ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
  				     KVM_NR_MEM_OBJS);
-	if (ret)
+	if (ret) {
+		up_read(&current->mm->mmap_sem);
  		return ret;
+	}

  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
  	/*
@@ -1742,8 +1742,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, 
phys_addr_t fault_ipa,
  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
  	if (pfn == KVM_PFN_ERR_HWPOISON) {
  		kvm_send_hwpoison_signal(hva, vma);
+		up_read(&current->mm->mmap_sem);
  		return 0;
  	}
+
+	up_read(&current->mm->mmap_sem);
+
  	if (is_error_noslot_pfn(pfn))
  		return -EFAULT;


James, what do you think?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
