Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD2963A
	for <kvmarm@lists.linux.dev>; Thu,  9 Feb 2023 06:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675924169;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QlYX3NFGK/iEEZ/mvkWFWopRA7ZdWOPwg+O9hZr+ePo=;
	b=FBg/wLBdfZcm3ObyaZadLYG8b4mnRgMsdAt3dR482gFl/2ar5MIRqx/gY+1kAN6RdEkWzT
	9BXSTeoxXVwenziEpM2qj/Y2uXhIBpvS23GFCgoESojYg+6rQcgscpIKVD/7KIXfDAnXUg
	hbL00N6SaR+y/5pr0S+uhqNIO2j5gKY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-6wXm-My-OvWF79NSibuOKA-1; Thu, 09 Feb 2023 01:29:25 -0500
X-MC-Unique: 6wXm-My-OvWF79NSibuOKA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB6243C025C2;
	Thu,  9 Feb 2023 06:29:24 +0000 (UTC)
Received: from [10.64.54.63] (vpn2-54-63.bne.redhat.com [10.64.54.63])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6925A492B00;
	Thu,  9 Feb 2023 06:29:18 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 11/12] KVM: arm64: Split huge pages during
 KVM_CLEAR_DIRTY_LOG
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 reijiw@google.com, rananta@google.com, bgardon@google.com, ricarkol@gmail.com
References: <20230206165851.3106338-1-ricarkol@google.com>
 <20230206165851.3106338-12-ricarkol@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <5be91738-093c-a416-6b04-4503d3689333@redhat.com>
Date: Thu, 9 Feb 2023 17:29:15 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230206165851.3106338-12-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9

Hi Ricardo,

On 2/7/23 3:58 AM, Ricardo Koller wrote:
> This is the arm64 counterpart of commit cb00a70bd4b7 ("KVM: x86/mmu:
> Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG"),
> which has the benefit of splitting the cost of splitting a memslot
> across multiple ioctls.
> 
> Split huge pages on the range specified using KVM_CLEAR_DIRTY_LOG.
> And do not split when enabling dirty logging if
> KVM_DIRTY_LOG_INITIALLY_SET is set.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f6fb2bdaab71..da2fbd04fb01 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1084,8 +1084,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
>    * @mask:	The mask of pages at offset 'gfn_offset' in this memory
>    *		slot to enable dirty logging on
>    *
> - * Writes protect selected pages to enable dirty logging for them. Caller must
> - * acquire kvm->mmu_lock.
> + * Splits selected pages to PAGE_SIZE and then writes protect them to enable
> + * dirty logging for them. Caller must acquire kvm->mmu_lock.
>    */
>   void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   		struct kvm_memory_slot *slot,
> @@ -1098,6 +1098,13 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
>   	stage2_wp_range(&kvm->arch.mmu, start, end);
> +
> +	/*
> +	 * If initially-all-set mode is not set, then huge-pages were already
> +	 * split when enabling dirty logging: no need to do it again.
> +	 */
> +	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +		kvm_mmu_split_huge_pages(kvm, start, end);
>   }
>   
>   static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
> @@ -1884,7 +1891,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   		 * this when deleting, moving, disabling dirty logging, or
>   		 * creating the memslot (a nop). Doing it for deletes makes
>   		 * sure we don't leak memory, and there's no need to keep the
> -		 * cache around for any of the other cases.
> +		 * cache around for any of the other cases. Keeping the cache
> +		 * is useful for succesive KVM_CLEAR_DIRTY_LOG calls, which is
> +		 * not handled in this function.
>   		 */
>   		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>   	}
> 

s/succesive/successive

Thanks,
Gavin

