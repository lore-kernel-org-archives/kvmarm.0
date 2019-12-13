Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2468C00454
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 21:28:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A54224682
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 21:28:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A54224682
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D3414A36B;
	Fri, 13 Dec 2019 13:59:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZJKNyLNdFopd; Fri, 13 Dec 2019 13:59:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48D864A65C;
	Fri, 13 Dec 2019 13:59:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B7424A541
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 13:59:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 75LcfypbDpXi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 13:59:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 400954A36B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 13:59:36 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C33DE106F;
 Fri, 13 Dec 2019 10:59:35 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD07C3F718;
 Fri, 13 Dec 2019 10:59:33 -0800 (PST)
Subject: Re: [PATCH 1/7] KVM: Pass mmu_notifier_range down to
 kvm_unmap_hva_range()
To: Marc Zyngier <maz@kernel.org>
References: <20191213182503.14460-1-maz@kernel.org>
 <20191213182503.14460-2-maz@kernel.org>
From: Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <c347df67-6cc3-9d5c-0dd9-72ebb8fa9712@arm.com>
Date: Fri, 13 Dec 2019 18:59:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213182503.14460-2-maz@kernel.org>
Content-Language: en-US
Cc: kvm-ppc@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, James Hogan <jhogan@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paul Mackerras <paulus@ozlabs.org>, linux-arm-kernel@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Hi Marc,


On 13/12/2019 18:24, Marc Zyngier wrote:
> kvm_unmap_hva_range() is currently passed both start and end
> fields from the mmu_notifier_range structure. As this struct
> now contains important information about the reason of the
> unmap (the event field), replace the start/end parameters
> with the range struct, and update all architectures.
> 
> No functionnal change.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>


> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 00268290dcbd..7c3665ad1035 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -158,7 +158,7 @@ static unsigned long long kvm_createvm_count;
>   static unsigned long long kvm_active_vms;
>   
>   __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> -		unsigned long start, unsigned long end, bool blockable)
> +		const struct mmu_notifier_range *range, bool blockable)
>   {
>   	return 0;
>   }
> @@ -415,7 +415,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>   	 * count is also read inside the mmu_lock critical section.
>   	 */
>   	kvm->mmu_notifier_count++;
> -	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end);
> +	need_tlb_flush = kvm_unmap_hva_range(kvm, range);
>   	need_tlb_flush |= kvm->tlbs_dirty;
>   	/* we've to flush the tlb before the pages can be freed */
>   	if (need_tlb_flush)
> @@ -423,8 +423,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>   
>   	spin_unlock(&kvm->mmu_lock);
>   
> -	ret = kvm_arch_mmu_notifier_invalidate_range(kvm, range->start,
> -					range->end,
> +	ret = kvm_arch_mmu_notifier_invalidate_range(kvm, range,
>   					mmu_notifier_range_blockable(range));

minor nit:

Since we now have the range passed on to the arch hooks, we could get
rid of the "blockable" too, as it is something you can deduce from the
range.

Otherwise looks good to me.

Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
