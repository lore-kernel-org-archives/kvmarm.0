Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED18F1FB3
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 09:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677834872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ElE1LjbREKSESr9EiwNTgI8SniA5dGYSmsKj5Ma/fSU=;
	b=bjy0bnmrzrDYDGDzFO8YGZ3uRXAzt50TVdh9wU/zTCU1+/o5ZQmaj2ceCp0bk/wrLm1hdo
	WTT6IfU73LLQdDXtK1bs5fzZQXoeKevL7KoPwlrC3K2S6/yIj+yk1L9dtfJ668ZaDAYqO4
	TzRZdmneRx/rysAC7WGbnuN2uxOVBBY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-oFt4rNN_P5GDozATfzgVRw-1; Fri, 03 Mar 2023 04:14:31 -0500
X-MC-Unique: oFt4rNN_P5GDozATfzgVRw-1
Received: by mail-qv1-f70.google.com with SMTP id jy22-20020a0562142b5600b005710b856106so1124575qvb.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Mar 2023 01:14:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677834871;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ElE1LjbREKSESr9EiwNTgI8SniA5dGYSmsKj5Ma/fSU=;
        b=aazdddwmX7hLBo85GbloqkYfS32cyun20VRbuIkgloLeRxzfvN4j/gVamd5NSI8nWq
         yrErIASQFzA88P3yDxVRar0vJNwVrEiguCddkkqsPyezPWoS8M51iw7OwdU8Fa6/CqOQ
         o8UKbuaKWmAZQoSK0igI09j0a+gFvznEt7j0B+wsme6GkNJPCuqDqwSUYOB9HRBFcYqa
         /T4C18R4RhKSfx9ixaknY2rKSv6GPdNC+czdx9gU99rHDYUOe2U+t23K4lkkiP0s0jpp
         4o+km3Zi3f+FoySVBfjv5VcPmFx586ZKKp6epUA+43ryhqkProl9h9H+2uczLXDLg23Q
         uWcQ==
X-Gm-Message-State: AO0yUKURU8I2J8JcCiEQ0RBAP+2n638urXu0RPhTB4i8886rQhpsAPhf
	CLEhSudEgbjli6mt7Adhh3lUz111xU6LlI5+hj8K0U47G1O9NojU4osbdfSCPfmqAD5xzwN5sav
	cf4vecmHB1/NEew4q
X-Received: by 2002:a05:622a:1753:b0:3bf:daa8:cacc with SMTP id l19-20020a05622a175300b003bfdaa8caccmr1890689qtk.3.1677834871085;
        Fri, 03 Mar 2023 01:14:31 -0800 (PST)
X-Google-Smtp-Source: AK7set+ExrTlvAdM0fij85zmPZ19kivkSvquwQopzeOB1lF6a91tW8NLVLGuWTzAYp6FLn0X26n1aA==
X-Received: by 2002:a05:622a:1753:b0:3bf:daa8:cacc with SMTP id l19-20020a05622a175300b003bfdaa8caccmr1890666qtk.3.1677834870790;
        Fri, 03 Mar 2023 01:14:30 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o62-20020a375a41000000b0073fe1056b00sm1338448qkb.55.2023.03.03.01.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:14:30 -0800 (PST)
Message-ID: <ed801052-008d-42e4-2c91-517783637c5f@redhat.com>
Date: Fri, 3 Mar 2023 17:14:22 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 05/12] KVM: arm64: Refactor
 kvm_arch_commit_memory_region()
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-6-ricarkol@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-6-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/23 05:09, Ricardo Koller wrote:
> Refactor kvm_arch_commit_memory_region() as a preparation for a future
> commit to look cleaner and more understandable. Also, it looks more
> like its x86 counterpart (in kvm_mmu_slot_apply_flags()).
> 
> No functional change intended.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/mmu.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9bd3c2cfb476..d2c5e6992459 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   				   const struct kvm_memory_slot *new,
>   				   enum kvm_mr_change change)
>   {
> +	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +
>   	/*
>   	 * At this point memslot has been committed and there is an
>   	 * allocated dirty_bitmap[], dirty pages will be tracked while the
>   	 * memory slot is write protected.
>   	 */
> -	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> +	if (log_dirty_pages) {
> +
> +		if (change == KVM_MR_DELETE)
> +			return;
> +
>   		/*
>   		 * If we're with initial-all-set, we don't need to write
>   		 * protect any pages because they're all reported as dirty.
>   		 * Huge pages and normal pages will be write protect gradually.
>   		 */
> -		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> -			kvm_mmu_wp_memory_region(kvm, new->id);
> -		}
> +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +			return;
> +
> +		kvm_mmu_wp_memory_region(kvm, new->id);
>   	}
>   }
>   

-- 
Shaoqin

