Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58227C43603
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 09:26:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF1442077B
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 09:26:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF1442077B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4832F4A95B;
	Fri, 13 Dec 2019 04:26:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y6i57wTrxujr; Fri, 13 Dec 2019 04:26:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A4A14A98A;
	Fri, 13 Dec 2019 04:26:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DF194A541
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 04:25:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IFWq2oYTo9fB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 04:25:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E15B4A4E8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 04:25:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94A801FB;
 Fri, 13 Dec 2019 01:25:54 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 289AE3F52E;
 Fri, 13 Dec 2019 01:25:54 -0800 (PST)
Date: Fri, 13 Dec 2019 10:25:52 +0100
From: Christoffer Dall <christoffer.dall@arm.com>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Re-check VMA on detecting a poisoned
 page
Message-ID: <20191213092552.GC28840@e113682-lin.lund.arm.com>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-3-maz@kernel.org>
 <88f65ab4ac87f53534fbbfd2410d1cc5@www.loen.fr>
 <b0a2b074-b80f-84ee-bfaa-f81ab345b8c2@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b0a2b074-b80f-84ee-bfaa-f81ab345b8c2@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

Hi James,

On Thu, Dec 12, 2019 at 03:34:31PM +0000, James Morse wrote:
> Hi Marc,
> 
> On 12/12/2019 11:33, Marc Zyngier wrote:
> > On 2019-12-11 16:56, Marc Zyngier wrote:

[...]

> 
> (allocating from a kmemcache while holding current's mmap_sem. I don't want to think about
> it!)
> 
> Can we be lazier? We want the VMA to get the size of the poisoned mapping correct in the
> signal. The bug is that this could change when we drop the lock, before queuing the
> signal, so we report hwpoison on old-vmas:pfn with new-vmas:size.
> 
> Can't it equally change when we drop the lock after queuing the signal? Any time before
> the thread returns to user-space to take the signal gives us a stale value.
> 
> I think all that matters is the size goes with the pfn that was poisoned. If we look the
> vma up by hva again, we have to check if the pfn has changed too... (which you are doing)
> 
> Can we stash the size in the existing mmap_sem region, and use that in
> kvm_send_hwpoison_signal()? We know it matches the pfn we saw as poisoned.
> 
> The vma could be changed before/after we send the signal, but user-space can't know which.
> This is user-spaces' problem for messing with the memslots while a vpcu is running.
> 

(I should clearly have expanded this thread before I replied to the
original patch...)

> 
> How about (untested):
> -------------------------%<-------------------------
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 38b4c910b6c3..80212d4935bd 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1591,16 +1591,8 @@ static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned
> long size)
>         __invalidate_icache_guest_page(pfn, size);
>  }
> 
> -static void kvm_send_hwpoison_signal(unsigned long address,
> -                                    struct vm_area_struct *vma)
> +static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>  {
> -       short lsb;
> -
> -       if (is_vm_hugetlb_page(vma))
> -               lsb = huge_page_shift(hstate_vma(vma));
> -       else
> -               lsb = PAGE_SHIFT;
> -
>         send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
>  }
> 
> @@ -1673,6 +1665,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         struct kvm *kvm = vcpu->kvm;
>         struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>         struct vm_area_struct *vma;
> +       short stage1_vma_size;
>         kvm_pfn_t pfn;
>         pgprot_t mem_type = PAGE_S2;
>         bool logging_active = memslot_is_logging(memslot);
> 
> @@ -1703,6 +1696,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 vma_pagesize = PAGE_SIZE;
>         }
> 
> +       /* For signals due to hwpoison, we need to use the stage1 size */
> +       if (is_vm_hugetlb_page(vma))
> +               stage1_vma_size = huge_page_shift(hstate_vma(vma));
> +       else
> +               stage1_vma_size = PAGE_SHIFT;
> +

But (see my patch) as far as I can tell, this is already what we have in
vma_pagesize, and do we really have to provide the stage 1 size to user
space if the fault happened within a smaller boundary?  Isn't that just
providing more precise information to the user?


Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
