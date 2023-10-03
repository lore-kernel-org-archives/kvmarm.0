Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C1729415
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696352085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AEA4UEa1g2oq3JcBQNLhy9atPLV06mxTKsyGqlcJSvY=;
	b=Z7JY62+OUBsMDwL80nNlemd/+Fv9DzbYl+uUfZk37FfyfKj0qskYUX7JcSYh8RmILOVOLF
	IXCnMHDtQz83IHJQ56+ZcXecoA1ftlmox9vkcAnwb8osK5yekO2a/q5ld0M1RUJmnYU/me
	XrjTwRvSeoInrY4FJa9ZD3v0BqwBlBU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-0qW2LIgOOyqtjHpWClfrMA-1; Tue, 03 Oct 2023 12:54:43 -0400
X-MC-Unique: 0qW2LIgOOyqtjHpWClfrMA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-324810f3bfcso1870377f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Oct 2023 09:54:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696352083; x=1696956883;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AEA4UEa1g2oq3JcBQNLhy9atPLV06mxTKsyGqlcJSvY=;
        b=XWDLW4GzsY91sYwoDARK2who0wk3uDjxNzQnv9o7pRqZ7v3Or7rQXPI4bXkVI71k31
         CuLVPZB7WS0E0BOYeq5wX3+mfhgDrytNFTGWdGNLgh69AIX8SjS/AdZ18AiqxHUZP5Or
         XweoyWAbfTQYqz/bAxeCogT0v92+priQkGtdFXHSu4tw2uytfAAd/b9zw3oG8Z9Iwcor
         tPO9EVdj14Bm9DlVbPZUYCwO68+YQEEDuHvQ45e/o3A3e5RqSsTfp1FKXegRMRT+rxMr
         CkHs+whdbSKGNxxZYHBA4WPVnEuQD7VDg+PSGBYsWVqFeTUbdZsaIyjfese8ufi0nr1n
         FJPw==
X-Gm-Message-State: AOJu0Ywp0Gbd1A2nbIeXzGICn+58tAw+os19sL6R5tfAvc3I70omOtnq
	rHnpzQByBX4Jean4YWo3M+YIca6/Z8KlKUCeW+Nrpx0pH4ebOWmk/8mk7ASyUNxYH/nU7EaaLcn
	gbZDESBygn8RE1ugd
X-Received: by 2002:a5d:4d4f:0:b0:321:6339:f523 with SMTP id a15-20020a5d4d4f000000b003216339f523mr2507870wru.22.1696352082898;
        Tue, 03 Oct 2023 09:54:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlDv2gBqmNjvi8JNhQ5M3NWUTvo78ciQKNKG4gkmI0moK0OwgDXlqnMKPVIA5lvJAWxNQcww==
X-Received: by 2002:a5d:4d4f:0:b0:321:6339:f523 with SMTP id a15-20020a5d4d4f000000b003216339f523mr2507859wru.22.1696352082685;
        Tue, 03 Oct 2023 09:54:42 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id p9-20020a5d4589000000b00326dd5486dcsm1968179wrq.107.2023.10.03.09.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 09:54:42 -0700 (PDT)
Message-ID: <5e6665dc76663c9e7d1d47b3488184d5f23ce51f.camel@redhat.com>
Subject: Re: [PATCH v9 4/6] KVM: Migrate kvm_vcpu_map to __kvm_follow_pfn
From: Maxim Levitsky <mlevitsk@redhat.com>
To: David Stevens <stevensd@chromium.org>, Sean Christopherson
	 <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata
	 <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 03 Oct 2023 19:54:40 +0300
In-Reply-To: <20230911021637.1941096-5-stevensd@google.com>
References: <20230911021637.1941096-1-stevensd@google.com>
	 <20230911021637.1941096-5-stevensd@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

У пн, 2023-09-11 у 11:16 +0900, David Stevens пише:
> From: David Stevens <stevensd@chromium.org>
> 
> Migrate kvm_vcpu_map to __kvm_follow_pfn. Track is_refcounted_page so
> that kvm_vcpu_unmap know whether or not it needs to release the page.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  include/linux/kvm_host.h |  2 +-
>  virt/kvm/kvm_main.c      | 24 ++++++++++++++----------
>  2 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2ed08ae1a9be..b95c79b7833b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -294,6 +294,7 @@ struct kvm_host_map {
>  	void *hva;
>  	kvm_pfn_t pfn;
>  	kvm_pfn_t gfn;
> +	bool is_refcounted_page;
>  };
>  
>  /*
> @@ -1228,7 +1229,6 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn);
>  void kvm_set_pfn_dirty(kvm_pfn_t pfn);
>  void kvm_set_pfn_accessed(kvm_pfn_t pfn);
>  
> -void kvm_release_pfn(kvm_pfn_t pfn, bool dirty);
>  int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  			int len);
>  int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 235c5cb3fdac..913de4e86d9d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2886,24 +2886,22 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_page);
>  
> -void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
> -{
> -	if (dirty)
> -		kvm_release_pfn_dirty(pfn);
> -	else
> -		kvm_release_pfn_clean(pfn);
> -}
> -
>  int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
>  {
>  	kvm_pfn_t pfn;
>  	void *hva = NULL;
>  	struct page *page = KVM_UNMAPPED_PAGE;
> +	struct kvm_follow_pfn foll = {
> +		.slot = gfn_to_memslot(vcpu->kvm, gfn),
> +		.gfn = gfn,
> +		.flags = FOLL_WRITE,
> +		.allow_non_refcounted_struct_page = true,
> +	};
>  
>  	if (!map)
>  		return -EINVAL;
>  
> -	pfn = gfn_to_pfn(vcpu->kvm, gfn);
> +	pfn = __kvm_follow_pfn(&foll);
>  	if (is_error_noslot_pfn(pfn))
>  		return -EINVAL;
>  
> @@ -2923,6 +2921,7 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
>  	map->hva = hva;
>  	map->pfn = pfn;
>  	map->gfn = gfn;
> +	map->is_refcounted_page = foll.is_refcounted_page;
>  
>  	return 0;
>  }
> @@ -2946,7 +2945,12 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
>  	if (dirty)
>  		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
>  
> -	kvm_release_pfn(map->pfn, dirty);
> +	if (map->is_refcounted_page) {
> +		if (dirty)
> +			kvm_release_page_dirty(map->page);
> +		else
> +			kvm_release_page_clean(map->page);
> +	}
>  
>  	map->hva = NULL;
>  	map->page = NULL;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

