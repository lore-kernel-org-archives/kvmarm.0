Return-Path: <SRS0=cDTT=YQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCBCCA9EB6
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 09:29:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32D2821872
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 09:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32D2821872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93AEF4A8EB;
	Wed, 23 Oct 2019 05:29:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oubuMCz1t3B2; Wed, 23 Oct 2019 05:29:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60DEE4A95B;
	Wed, 23 Oct 2019 05:29:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8999E4A8EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Oct 2019 05:29:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P99lM9-DI-MD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Oct 2019 05:29:30 -0400 (EDT)
Received: from foss.arm.com (unknown [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFA284A8D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Oct 2019 05:29:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92F5932B;
 Wed, 23 Oct 2019 02:29:09 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CDE23F718;
 Wed, 23 Oct 2019 02:29:08 -0700 (PDT)
Date: Wed, 23 Oct 2019 11:29:07 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 01/15] KVM: Reinstall old memslots if arch preparation
 fails
Message-ID: <20191023092907.GD2652@e113682-lin.lund.arm.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191022003537.13013-2-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Mon, Oct 21, 2019 at 05:35:23PM -0700, Sean Christopherson wrote:
> Reinstall the old memslots if preparing the new memory region fails
> after invalidating a to-be-{re}moved memslot.
> 
> Remove the superfluous 'old_memslots' variable so that it's somewhat
> clear that the error handling path needs to free the unused memslots,
> not simply the 'old' memslots.
> 
> Fixes: bc6678a33d9b9 ("KVM: introduce kvm->srcu and convert kvm_set_memory_region to SRCU update")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  virt/kvm/kvm_main.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67ef3f2e19e8..9afd706dc038 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -924,7 +924,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	unsigned long npages;
>  	struct kvm_memory_slot *slot;
>  	struct kvm_memory_slot old, new;
> -	struct kvm_memslots *slots = NULL, *old_memslots;
> +	struct kvm_memslots *slots;
>  	int as_id, id;
>  	enum kvm_mr_change change;
>  
> @@ -1032,7 +1032,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		slot = id_to_memslot(slots, id);
>  		slot->flags |= KVM_MEMSLOT_INVALID;
>  
> -		old_memslots = install_new_memslots(kvm, as_id, slots);
> +		/*
> +		 * We can re-use the old memslots, the only difference from the
> +		 * newly installed memslots is the invalid flag, which will get
> +		 * dropped by update_memslots anyway.  We'll also revert to the
> +		 * old memslots if preparing the new memory region fails.
> +		 */
> +		slots = install_new_memslots(kvm, as_id, slots);
>  
>  		/* From this point no new shadow pages pointing to a deleted,
>  		 * or moved, memslot will be created.
> @@ -1042,13 +1048,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		 *	- kvm_is_visible_gfn (mmu_check_roots)
>  		 */
>  		kvm_arch_flush_shadow_memslot(kvm, slot);
> -
> -		/*
> -		 * We can re-use the old_memslots from above, the only difference
> -		 * from the currently installed memslots is the invalid flag.  This
> -		 * will get overwritten by update_memslots anyway.
> -		 */
> -		slots = old_memslots;
>  	}
>  
>  	r = kvm_arch_prepare_memory_region(kvm, &new, mem, change);
> @@ -1062,15 +1061,17 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	}
>  
>  	update_memslots(slots, &new, change);
> -	old_memslots = install_new_memslots(kvm, as_id, slots);
> +	slots = install_new_memslots(kvm, as_id, slots);
>  
>  	kvm_arch_commit_memory_region(kvm, mem, &old, &new, change);
>  
>  	kvm_free_memslot(kvm, &old, &new);
> -	kvfree(old_memslots);
> +	kvfree(slots);
>  	return 0;
>  
>  out_slots:
> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> +		slots = install_new_memslots(kvm, as_id, slots);
>  	kvfree(slots);
>  out_free:
>  	kvm_free_memslot(kvm, &new, &old);
> -- 
> 2.22.0

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
