Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2737C2E1
	for <kvmarm@lists.linux.dev>; Mon, 17 Apr 2023 07:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681715931;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sYjR0xSbqdDLVGFhfaRMyfQHo9XMoXo9cPWRMiIiH+g=;
	b=ZblG4OjNc8pxQPHIvYtpfmczm8mPPddjc6rQrET4anQ94+aR2BTO3Pd46uU6Xz5BlROUBd
	SfxXG68vwO/jtVdBbporTx5LnOIai7QL+qWMb9zGjFMP5EEtjho8ye0qVgF5m/PI98pC12
	Aae0nrONdpaFGbLVbUrcHcd+E1GUMjU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-kwTEnIq2OM-jTP5XKovxbA-1; Mon, 17 Apr 2023 03:18:46 -0400
X-MC-Unique: kwTEnIq2OM-jTP5XKovxbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C27CA85A5A3;
	Mon, 17 Apr 2023 07:18:45 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD8F240C94A9;
	Mon, 17 Apr 2023 07:18:35 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 11/12] KVM: arm64: Split huge pages during
 KVM_CLEAR_DIRTY_LOG
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 reijiw@google.com, rananta@google.com, bgardon@google.com, ricarkol@gmail.com
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-13-ricarkol@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <a739a2bb-81bd-4e21-1b05-2fb740a86d91@redhat.com>
Date: Mon, 17 Apr 2023 15:18:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-13-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2

On 4/9/23 2:29 PM, Ricardo Koller wrote:
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
>   arch/arm64/kvm/mmu.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 16fa24f761152..50488daab0f4d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1094,8 +1094,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
>    * @mask:	The mask of pages at offset 'gfn_offset' in this memory
>    *		slot to enable dirty logging on
>    *
> - * Writes protect selected pages to enable dirty logging for them. Caller must
> - * acquire kvm->mmu_lock.
> + * Writes protect selected pages to enable dirty logging, and then
> + * splits them to PAGE_SIZE. Caller must acquire kvm->mmu_lock.
>    */
>   void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   		struct kvm_memory_slot *slot,
> @@ -1108,6 +1108,17 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
>   	stage2_wp_range(&kvm->arch.mmu, start, end);
> +
> +	/*
> +	 * Eager-splitting is done when manual-protect is set.  We
> +	 * also check for initially-all-set because we can avoid
> +	 * eager-splitting if initially-all-set is false.
> +	 * Initially-all-set equal false implies that huge-pages were
> +	 * already split when enabling dirty logging: no need to do it
> +	 * again.
> +	 */
> +	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +		kvm_mmu_split_huge_pages(kvm, start, end);
>   }
>  >   static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
> 

