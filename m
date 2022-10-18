Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0664C64
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 13:42:14 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id l16-20020a05600c4f1000b003c6c0d2a445so12222288wmq.4
        for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 06:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zJkCAiJHLxUZwzr5tFQxyP5W2DnDI9cvMk9vr73FdTQ=;
        b=cH/a18bj2gfE2DhWLyxpNZsuWatw0ThunY35SY43PqJhoyct4SliXvj6pUNgT8bZiv
         wMCc4GO8EaWqiXlj4mMYt2yRE39Az6OBsR+NdNXOo34k9MtwPtJt493q46vlXpYluy9L
         9aAnKYuffQO3HPs+Q3SDyaqWO9+u+ud1f8YklGI4um083sOSdMxQEAsNMLzZ3daeCRnH
         kPTma0lgo6jg0IzCUNkbV0hA4OyxiUlRE9jRbZm6PRDkAaB/s/KroN7PFy06Ujbae5GN
         AwFzvTrFVI34wA8UCMxxZhrEBT3RjVHMRc3vbBr8c6vaF0midgWER6A4Luo7DTDi5Xta
         iFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zJkCAiJHLxUZwzr5tFQxyP5W2DnDI9cvMk9vr73FdTQ=;
        b=4rmSyBKcFGp2TMnYtAaietoJuVZNItnBCfpF1pZ7vQxsVxX47JLl9AAO94p5QyqcSf
         Hb4kEhwOoNDcBOYj99ciZL1uiFYAP4PdqBlJgy4XXV+2YihEXICjEfc+dGEM3tRP2qMy
         vtg5jT9x3IHb14ZnwYk75ksc7tPPlqFAQ256+wk51pF5pSqEa4ByObexBHPv0G1NUSNd
         ZEwMlWE3R+noD84mQFPbVzy5L8Ljs1PeL1toW00PPmH8ux41OiRS1LrOxkVFDn3YZEvJ
         Z3t2Ad/If5xHodflppOGUPFYZy2vj4OZbaOxjibf1SjrZdzdk9h9pP6d50rX8DvYoG8v
         rIQw==
X-Gm-Message-State: ACrzQf3lwCuS76L+QOP6Q3fwFoLpRbNM4sSy2sBymAAdjMElWoPklXDy
	VElcyUn3wKGVembBvVKUnBRi++hyiY3XrZhudhs=
X-Google-Smtp-Source: AMsMyM7wCcbFf1zbh8Y5oHXV6AXBJ9PTPQ4114zKrWFWrMnafOFFV6P9gV4VERIFsDKqkmc71bs9wQ==
X-Received: by 2002:a05:600c:1f16:b0:3c7:cf:8e72 with SMTP id bd22-20020a05600c1f1600b003c700cf8e72mr851015wmb.88.1666100533284;
        Tue, 18 Oct 2022 06:42:13 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id t15-20020a5d49cf000000b0022e32f4c06asm11172895wrs.11.2022.10.18.06.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 06:42:12 -0700 (PDT)
Message-ID: <4c9e1602-25e4-6489-e4da-3b1b7fda5302@linaro.org>
Date: Tue, 18 Oct 2022 15:42:08 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 07/25] KVM: arm64: Prevent the donation of no-map pages
Content-Language: en-US
To: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc: Sean Christopherson <seanjc@google.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, James Morse
 <james.morse@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Quentin Perret <qperret@google.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 kernel-team@android.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-8-will@kernel.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-8-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Will & Quentin,

On 17/10/22 13:51, Will Deacon wrote:
> From: Quentin Perret <qperret@google.com>
> 
> Memory regions marked as "no-map" in the host device-tree routinely
> include TrustZone carevouts and DMA pools. Although donating such pages

Typo "carve-outs"?

> to the hypervisor may not breach confidentiality, it could be used to
> corrupt its state in uncontrollable ways. To prevent this, let's block
> host-initiated memory transitions targeting "no-map" pages altogether in
> nVHE protected mode as there should be no valid reason to do this in
> current operation.
> 
> Thankfully, the pKVM EL2 hypervisor has a full copy of the host's list
> of memblock regions, so we can easily check for the presence of the
> MEMBLOCK_NOMAP flag on a region containing pages being donated from the
> host.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c | 22 ++++++++++++++++------
>   1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index c30402737548..a7156fd13bc8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -193,7 +193,7 @@ struct kvm_mem_range {
>   	u64 end;
>   };

>   bool addr_is_memory(phys_addr_t phys)
>   {
>   	struct kvm_mem_range range;
>   
> -	return find_mem_range(phys, &range);
> +	return !!find_mem_range(phys, &range);
> +}
> +
> +static bool addr_is_allowed_memory(phys_addr_t phys)
> +{
> +	struct memblock_region *reg;
> +	struct kvm_mem_range range;
> +
> +	reg = find_mem_range(phys, &range);
> +
> +	return reg && !(reg->flags & MEMBLOCK_NOMAP);
>   }
>   
>   static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
> @@ -346,7 +356,7 @@ static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot pr
>   static int host_stage2_idmap(u64 addr)
>   {
>   	struct kvm_mem_range range;
> -	bool is_memory = find_mem_range(addr, &range);
> +	bool is_memory = !!find_mem_range(addr, &range);

We don't replace by addr_is_allowed_memory() because we still use
&range, OK.

>   	enum kvm_pgtable_prot prot;
>   	int ret;
>   
> @@ -424,7 +434,7 @@ static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
>   	struct check_walk_data *d = arg;
>   	kvm_pte_t pte = *ptep;
>   
> -	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
> +	if (kvm_pte_valid(pte) && !addr_is_allowed_memory(kvm_pte_to_phys(pte)))
>   		return -EINVAL;

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
