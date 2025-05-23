Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC351A2622
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 19:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748028667; cv=none; b=Sr/W1JoXt0c1U+6UU1YI6xnDsdcx2/wAr9vW/66NVg9CXqG8Cr0GHhWFJ0xFSByVVvRgdtpMqs/utAxoSrucH2NgqLb0hy5f+FrE7MYjA55Twm6bcRWYcGmr9bMwvmDoP4IrM5nQoPV6QHjeqLmOkBk3dL8uGmNOYk/VUAG7rTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748028667; c=relaxed/simple;
	bh=lOS/mOBhe35eB3FbcSV6YiRh9swtBE2b8LuWiCv5lWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ahqaA+dwaj1NwAhtPBKcr/ktHTDE5/KNSJQsnIhZ9YtCo//rnrkPieO7nBCQPHq9TMJ9EUqjVZ7h/lU4hn8NxuYtdg6hBcefS3iRExDPMJfgjUZmmMXdB1zrCJ7684WynuPgLt9LCSjDnUl+1T1xRv7SOikuPsbwn5sXuxqIlF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZpFteCkD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZpFteCkD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748028664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FTvdxciROz3xcyDGA7SqLlzzoP+BAXCOdB9KfOHNYyY=;
	b=ZpFteCkDNkAGtHfwuYIC931WDs0PwIGVTglBLa3DbimqSCB6GwQzUrI4aZtAz7yB2D7q7H
	TI3LQ33C9WcOCGv47fIAPEhiGIUT64BQKoZKXKH9+rn3WIY1QixTMMEe2gZ00ofXIGjPdf
	hxYhmmGug2AseM0TX22C+U9hqCuCQWA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-__ROUmL9PLy-w6RYeAvI5A-1; Fri, 23 May 2025 15:31:00 -0400
X-MC-Unique: __ROUmL9PLy-w6RYeAvI5A-1
X-Mimecast-MFC-AGG-ID: __ROUmL9PLy-w6RYeAvI5A_1748028659
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6f8e1d900e5so3713066d6.2
        for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 12:30:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748028659; x=1748633459;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FTvdxciROz3xcyDGA7SqLlzzoP+BAXCOdB9KfOHNYyY=;
        b=rfnanbhuhWPHL4GeHnbhX7cKthU4sKzL5e6YnV/SCSXnrtV2Jj4Y+Z8MIBNb33q/mY
         eD+3s1KOmNs1xJJHnVmw8fXdD7CmbtH8lJObHxKXJjUZbb0XQiYyAfnTVQGqBsqWKnZ/
         QIiTPk1cEhSFDobOeFDHeggDKnC4szEJ9BauBwKWu1Nbbf5Tdg7MdvdDLl99xBMgdeYE
         PjAIIHBrhb8dhY9/Y1OXIAf26SjC4HPoulLPzjIDCjIjbgTNOCoul9T2OK8T+hJ+DbCu
         pzuPCTCKqR55uodlMFgIEsgby6WcKfTsMsNLqe8N69OPzLcMeJaCYyh4q/UMy5FEZtC0
         9lng==
X-Forwarded-Encrypted: i=1; AJvYcCW2QZCTNRPhEFtlWzkl+/8O+npA+jnu+o1BE2bGvv1SZv5cqF7nKPF8jQsrLzsKEQfQ+8I8xQ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNJt1xXxWg5HNWLkGo5RzH9hf6hC9NmhUkpfr6gxk3gMIFVH63
	Sn9yr2wq4Nun85J2008lXGquoWK+zJyLJvxWdv1WQVdWZcHy6qUd0/RNB1D5hBRnRdq/WYNZAiC
	TzWTaCQ4HV4+zY0gITS12moe45YwLKZ/QtnAT0+8lqgyIp0mZu3+aKRMFeg==
X-Gm-Gg: ASbGncuMiV2Ldd9xl40b1Az4mOj2IdOlsBSGEVWuYKvrNs2zZkQwjytx5R4if3xGWDV
	83ApPM2jmdnzeVjbNPVfkII+FZxfgCQeGJFd2gp2gvGyeEgFNLPXdAxnETJRwLkoSRJkX5U9S2k
	vYKmUBFRhbiboznT1ke69rhNWvZyw+U3B3/9krB9569ScNJJVl1goiJBad6tM0uX0kOe5aBYKd2
	3JdJ5tCEdSIZegGHgLI4++OJFc6PhZw314QdSTyFekoswgNJOej63kkWnrzbnJJXvWQdXs1udST
	QElSWJk14h/Q
X-Received: by 2002:a05:6214:1d23:b0:6e6:6964:ca77 with SMTP id 6a1803df08f44-6fa9d29c58dmr11208176d6.28.1748028659044;
        Fri, 23 May 2025 12:30:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFd+qzCAswhS3iuiKWeZE50Wf+7n1+LX7vli2jZxIWG36wkuD8DiM8xlaNuqX/4ezVASlQWyA==
X-Received: by 2002:a05:6214:1d23:b0:6e6:6964:ca77 with SMTP id 6a1803df08f44-6fa9d29c58dmr11207166d6.28.1748028658328;
        Fri, 23 May 2025 12:30:58 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f8b08ac5ddsm118552726d6.44.2025.05.23.12.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 May 2025 12:30:57 -0700 (PDT)
Message-ID: <9ffc7686-0dc0-4978-8cd8-f12a1c148b63@redhat.com>
Date: Fri, 23 May 2025 15:30:52 -0400
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/5] KVM: arm64: New function to determine hardware
 cache management support
To: ankita@nvidia.com, jgg@nvidia.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, shahuang@redhat.com, lpieralisi@kernel.org,
 david@redhat.com
Cc: aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 kjaju@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
 acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
 danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com,
 dnigam@nvidia.com, alex.williamson@redhat.com, sebastianene@google.com,
 coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
 ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
 linux-mm@kvack.org, tabba@google.com, qperret@google.com, seanjc@google.com,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
References: <20250523154445.3779-1-ankita@nvidia.com>
 <20250523154445.3779-3-ankita@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250523154445.3779-3-ankita@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _2xd-QcgId8txUpxG1UCJo1nIPyD3Tv38U_F04SeK4c_1748028659
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/23/25 11:44 AM, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The hardware supports safely mapping PFNMAP as cacheable if it
> is capable of managing cache. This can be determined by the presence
> of FWB (Force Write Back) and CACHE_DIC feature.
> 
> When FWB is not enabled, the kernel expects to trivially do cache
> management by flushing the memory by linearly converting a kvm_pte to
> phys_addr to a KVA. The cache management thus relies on memory being
> mapped. Since the GPU device memory is not kernel mapped, exit when
> the FWB is not supported. Similarly, ARM64_HAS_CACHE_DIC allows KVM
> to avoid flushing the icache and turns icache_inval_pou() into a NOP.
> So the cacheable PFNMAP is contingent on these two hardware features.
> 
> Introduce a new function to make the check for presence of those
> features.
> 
> CC: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>   arch/arm64/kvm/mmu.c     | 12 ++++++++++++
>   include/linux/kvm_host.h |  2 ++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 305a0e054f81..124655da02ca 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1287,6 +1287,18 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   	kvm_nested_s2_wp(kvm);
>   }
>   
> +/**
> + * kvm_arch_supports_cacheable_pfnmap() - Determine whether hardware
> + *      supports cache management.
> + *
> + * Return: True if FWB and DIC is supported.
> + */
> +bool kvm_arch_supports_cacheable_pfnmap(void)
> +{
> +	return cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) &&
> +	       cpus_have_final_cap(ARM64_HAS_CACHE_DIC);
> +}
> +
>   static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>   {
>   	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 291d49b9bf05..3750d216d456 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1231,6 +1231,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
>   /* flush memory translations pointing to 'slot' */
>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   				   struct kvm_memory_slot *slot);
> +/* hardware support cache management */
> +bool kvm_arch_supports_cacheable_pfnmap(void);
>   
Won't this cause a build warning on non-ARM builds, b/c there is no
resolution of this function for the other arch's?
Need #ifdef or default-rtn-0 function for arch's that don't have this function?

>   int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
>   		       struct page **pages, int nr_pages);

