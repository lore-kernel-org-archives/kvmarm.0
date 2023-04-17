Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5FB1848
	for <kvmarm@lists.linux.dev>; Mon, 17 Apr 2023 06:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681713911;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hw0lo4S/BSYWvBeEieVBPD6pSrAARHRfbdz0FIMjuSU=;
	b=I57wldO5So3mEqoxU+NGiw8Cy01a4foftbA35H29LxmYYMemtLmO/HGLhBCqJLGJC0MRW0
	hjM1SVzwwmGrCnqE6v1KTRcPQ/OYvpWCkqYUSbi2hZz//4ZGB36c1H0ybgcqmnurDu3yMa
	BsCXGySpYJ5swlKeyQk0CjgY81SqQXs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-_VaQdAs5OWugQtEGu5dUIQ-1; Mon, 17 Apr 2023 02:45:03 -0400
X-MC-Unique: _VaQdAs5OWugQtEGu5dUIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C4FF8828C6;
	Mon, 17 Apr 2023 06:45:02 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE1631121314;
	Mon, 17 Apr 2023 06:44:50 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com, Shaoqin Huang <shahuang@redhat.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-8-ricarkol@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <30cc2bbf-3815-9910-aee8-943a4be83cbb@redhat.com>
Date: Mon, 17 Apr 2023 14:44:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-8-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

On 4/9/23 2:29 PM, Ricardo Koller wrote:
> Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd() into it. A
> future commit will add some more things to do inside of
> kvm_uninit_stage2_mmu().
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_mmu.h | 1 +
>   arch/arm64/kvm/mmu.c             | 7 ++++++-
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 083cc47dca086..7d173da5bd51c 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -168,6 +168,7 @@ void __init free_hyp_pgds(void);
>   
>   void stage2_unmap_vm(struct kvm *kvm);
>   int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
> +void kvm_uninit_stage2_mmu(struct kvm *kvm);
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>   int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   			  phys_addr_t pa, unsigned long size, bool writable);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 37d7d2aa472ab..a2800e5c42712 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -767,6 +767,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	return err;
>   }
>   
> +void kvm_uninit_stage2_mmu(struct kvm *kvm)
> +{
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +}
> +
>   static void stage2_unmap_memslot(struct kvm *kvm,
>   				 struct kvm_memory_slot *memslot)
>   {
> @@ -1855,7 +1860,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
>   
>   void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   {
> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +	kvm_uninit_stage2_mmu(kvm);
>   }
>   
>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> 

