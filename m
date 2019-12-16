Return-Path: <SRS0=GAmw=2G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D26C43603
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 18:29:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2951320674
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 18:29:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2951320674
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 495564A65C;
	Mon, 16 Dec 2019 13:29:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qI+hEtmhuxbD; Mon, 16 Dec 2019 13:29:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27F3A4A588;
	Mon, 16 Dec 2019 13:29:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B2634A319
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 13:29:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p1tjkOMzZv2w for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Dec 2019 13:29:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4FE54A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 13:29:03 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2955C1007;
 Mon, 16 Dec 2019 10:29:03 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 088123F719;
 Mon, 16 Dec 2019 10:29:01 -0800 (PST)
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Re-check VMA on detecting a poisoned
 page
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-3-maz@kernel.org>
 <20191213092239.GB28840@e113682-lin.lund.arm.com>
From: James Morse <james.morse@arm.com>
Message-ID: <1723e51d-28a2-d2e5-e45a-12acc2991bcc@arm.com>
Date: Mon, 16 Dec 2019 18:29:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191213092239.GB28840@e113682-lin.lund.arm.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Christoffer,

On 13/12/2019 09:22, Christoffer Dall wrote:
> On Wed, Dec 11, 2019 at 04:56:49PM +0000, Marc Zyngier wrote:
>> When we check for a poisoned page, we use the VMA to tell userspace
>> about the looming disaster. But we pass a pointer to this VMA
>> after having released the mmap_sem, which isn't a good idea.
>>
>> Instead, re-check that we have still have a VMA, and that this
>> VMA still points to a poisoned page. If the VMA isn't there,
>> userspace is playing with our nerves, so lety's give it a -EFAULT
>> (it deserves it). If the PFN isn't poisoned anymore, let's restart
>> from the top and handle the fault again.

> If I read this code correctly, then all we use the VMA for is to find
> the page size used by the MMU to back the VMA, which we've already
> established in the vma_pagesize (and possibly adjusted to something more
> accurate based on our constraints in stage 2 which generated the error),
> so all we need is the size and a way to convert that into a shift.
> 
> Not being 100% confident about the semantics of the lsb bit we pass to
> user space (is it indicating the size of the mapping which caused the
> error or the size of the mapping where user space could potentially

Its the size of the hole that has opened up in the address map. The error was very likely
to be much smaller, but all we can do is unmap pages.
Transparent huge-pages are split up to minimise the impact. This code is for hugetlbfs
(?), whose pages are dedicated for that use, so don't get split.

arch/arm64/mm/fault.c::do_page_fault() has:
|	lsb = PAGE_SHIFT;
|	if (fault & VM_FAULT_HWPOISON_LARGE)
|		lsb = hstate_index_to_shift(VM_FAULT_GET_HINDEX(fault));
|
|	arm64_force_sig_mceerr(BUS_MCEERR_AR, (void __user *)addr, lsb,

(I assume its a shift because bytes in the signal union are precious)


> trigger an error?), or wheter we care enough at that level, could we
> consider something like the following instead?

> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 38b4c910b6c3..2509d9dec42d 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1592,15 +1592,9 @@ static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
>  }
>  
>  static void kvm_send_hwpoison_signal(unsigned long address,
> -				     struct vm_area_struct *vma)
> +				     unsigned long vma_pagesize)
>  {
> -	short lsb;
> -
> -	if (is_vm_hugetlb_page(vma))
> -		lsb = huge_page_shift(hstate_vma(vma));
> -	else
> -		lsb = PAGE_SHIFT;
> -
> +	short lsb = __ffs(vma_pagesize);
>  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
>  }
>  
> @@ -1735,7 +1729,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>  	if (pfn == KVM_PFN_ERR_HWPOISON) {
> -		kvm_send_hwpoison_signal(hva, vma);
> +		kvm_send_hwpoison_signal(hva, vma_pagesize);
>  		return 0;
>  	}
>  	if (is_error_noslot_pfn(pfn))

This changes the meaning, vma_pagesize is a value like 4K, not a shift like 12.

But yes, caching the shift value under the mmap_sem and passing it in is the
right-thing-to-do(tm). I have a patch which I'll post, once I remember how to test this thing!



Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
