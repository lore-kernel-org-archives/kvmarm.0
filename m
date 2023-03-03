Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B4A1FB3
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 09:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677834924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LNqEuEiEzWe2jgeg251D+2ct+/tYWoRur835TeYZSMU=;
	b=f0lZoO/YTQyT1e9lg4NGX7cAlboC/Twg72EcSq6wnS/a8w9of+FJO5nUCZFbJfIuxhr5Pc
	/kG/a8hetWTckUzDAfFcxIPljGZS39/j9SkWdZEQ+Ptd9EwkXmSLb8ZgQ8BgqxZtKPSDSV
	s0dXbRlhOTnbnDvWxGwKtsbR2XP0SVw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-Ql0FQEPjPJS-h8Gg5cY2qQ-1; Fri, 03 Mar 2023 04:15:23 -0500
X-MC-Unique: Ql0FQEPjPJS-h8Gg5cY2qQ-1
Received: by mail-qt1-f198.google.com with SMTP id l2-20020ac87242000000b003bfecc6d046so1125236qtp.17
        for <kvmarm@lists.linux.dev>; Fri, 03 Mar 2023 01:15:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677834922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LNqEuEiEzWe2jgeg251D+2ct+/tYWoRur835TeYZSMU=;
        b=lWy+4Em0wjOFItPevh0WHCQ4N0zLM11ZciYiBMPOLSYKwW9Qk7ZFfW+U6VfO+SiT1P
         sYtKo+gNe+4PQpy5ey2XGP5pbBCXULju2V+uG6cMyO2VjavtqPuTBfzTd6tXg5FvWD6/
         xGMFJuC5XWhovn5+t/n2rsbk9bUt7C0u4jlIblVtLvv0oGkU7QpD12gJ5T2c0tuOeGog
         y2C4PucIYyMFG48ceFDLIu8UJmvRYpf0YnloqPZhOH7ctw5a50oePM4dNFSZ4/OT7omn
         Wc70HfFPJUktJQnGRqw33vDCfwh7YbLHeJQEPpCpEJ3oSxs7BDUHDCxyLbn1WGNsli78
         qI8A==
X-Gm-Message-State: AO0yUKVMGm1L92E+EIDx+llhpdMfwMeKZZOw+TV6IPfuWU+L0ZpWWT+a
	w89Z0cHjI4jEwevP8SCFoH1C6PxujvDvzqpKqDO+GjPBtyvV7NdoSfnwUukfduZSNvTVOq/1NWg
	TOZG1ovvUq31xRLS8
X-Received: by 2002:a05:622a:4c7:b0:3bf:be4b:8094 with SMTP id q7-20020a05622a04c700b003bfbe4b8094mr2370062qtx.0.1677834922671;
        Fri, 03 Mar 2023 01:15:22 -0800 (PST)
X-Google-Smtp-Source: AK7set+UeqoMKcIosUwwAvK/fDenT1tjSie9A46dCLMPQhkR6X0C2i0/CIvJ1yTjWhB+gyCFHQ8ZSg==
X-Received: by 2002:a05:622a:4c7:b0:3bf:be4b:8094 with SMTP id q7-20020a05622a04c700b003bfbe4b8094mr2370041qtx.0.1677834922456;
        Fri, 03 Mar 2023 01:15:22 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q28-20020a05620a2a5c00b007422fd3009esm1402815qkp.20.2023.03.03.01.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:15:22 -0800 (PST)
Message-ID: <be0df523-188d-d12a-a819-fbcb9b88b31e@redhat.com>
Date: Fri, 3 Mar 2023 17:15:14 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-8-ricarkol@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-8-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/23 05:09, Ricardo Koller wrote:
> Export kvm_are_all_memslots_empty(). This will be used by a future
> commit when checking before setting a capability.
> 
> No functional change intended.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   include/linux/kvm_host.h | 2 ++
>   virt/kvm/kvm_main.c      | 2 +-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4f26b244f6d0..8c5530e03a78 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -991,6 +991,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
>   	return RB_EMPTY_ROOT(&slots->gfn_tree);
>   }
>   
> +bool kvm_are_all_memslots_empty(struct kvm *kvm);
> +
>   #define kvm_for_each_memslot(memslot, bkt, slots)			      \
>   	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
>   		if (WARN_ON_ONCE(!memslot->npages)) {			      \
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9c60384b5ae0..3940d2467e1b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4604,7 +4604,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   	return -EINVAL;
>   }
>   
> -static bool kvm_are_all_memslots_empty(struct kvm *kvm)
> +bool kvm_are_all_memslots_empty(struct kvm *kvm)
>   {
>   	int i;
>   

-- 
Shaoqin

