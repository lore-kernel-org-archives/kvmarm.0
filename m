Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD66F182
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 00:18:41 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id ge21-20020a17090b0e1500b002308aac5b5eso7078050pjb.4
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 16:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x/7PdMLaXHDLj7F9Rrke1LN37FEe/EfG9IrL310L28c=;
        b=3AJs34FF4z9joiTglEW9N708pFeB6Q1kRuQLot/tfpr7fCw6b1cL/2BJTrickstHMb
         /7go1Unah0q3BGWipACDJirygqsIS4UtKLUh4hr2h3SWYPTzQgPkfvIBGwX1sw1uKOc7
         J/zXzItkXOjynvnnhYLeM1IKCWP6sw6v6junt54etpXFYxkTxN/b24eeVHvKaH9Phghr
         m7DLzDP8ygWGvjdRSYGwXETsNgK9NzzkJf9yEjMFfWctMhNX6THpDoK5sKxyN9fFwS3y
         ON5LK+RGaatjXNqwY8uuXnFqVKd/DpMAx6MeQ1oPOqsRel2reOF2HOgjNx558shhb3sc
         BfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x/7PdMLaXHDLj7F9Rrke1LN37FEe/EfG9IrL310L28c=;
        b=m62Uo1o3FUWPIe5G2C7T9/YGNJfm4B3l4XHAeCwNi/xzcoW8OnjvQYi4/EqPZdZ9QE
         CUHZdQZdxt+ocDTkxuLj1i6E0/QL1FyrMly2mz1ZV8sKGnHI636POIBElKli19wa0xQq
         VU+ZJVku020udt6xnrD4AyBD1jEdQAnTgcOA3WLTEbq+cyEWOGQmoQW7vVM/eSCvq24L
         gGp/IUupf/ULqS7m/OzGmMvwDVOT52/WSD6z6XMnATGZv816XORzU0pDb8trzT41nQXC
         gsVQD2YZoNGxeCfCCbeaKoiyty1OtUQ9cX0/+ubVeuNLsxeoLpjDYRsMrLf9JfCHvTxr
         350A==
X-Gm-Message-State: AO0yUKUIaAWrIyTvq617G1+6aryr0kOLfxm6RWuEKf5yV0ML0unAyM8E
	8WdQ/XuYO1mx/+C8H9vs7099cQ==
X-Google-Smtp-Source: AK7set/eMsMrMib/fk7JUw8VBrW4I8GlRLeRPxf2i6pzofN+yWrUHjH/Wnz/gcV2qORq3rr54xd1PQ==
X-Received: by 2002:a17:902:d2ce:b0:198:b284:c2ca with SMTP id n14-20020a170902d2ce00b00198b284c2camr908523plc.51.1675729121162;
        Mon, 06 Feb 2023 16:18:41 -0800 (PST)
Received: from ?IPV6:2400:4050:a840:1e00:4457:c267:5e09:481b? ([2400:4050:a840:1e00:4457:c267:5e09:481b])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c24c00b00188fc6766d6sm7455321plg.219.2023.02.06.16.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 16:18:40 -0800 (PST)
Message-ID: <264d1607-8c10-3ef7-7b8b-83b8b3a1cc11@daynix.com>
Date: Tue, 7 Feb 2023 09:18:37 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH] KVM: arm64: Mark some VM-scoped allocations as
 __GFP_ACCOUNT
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20230206235229.4174711-1-oliver.upton@linux.dev>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20230206235229.4174711-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2023/02/07 8:52, Oliver Upton wrote:
> Generally speaking, any memory allocations that can be associated with a
> particular VM should be charged to the cgroup of its process.
> Nonetheless, there are a couple spots in KVM/arm64 that aren't currently
> accounted:
> 
>   - the ccsidr array containing the virtualized cache hierarchy
> 
>   - the cpumask of supported cpus, for use of the vPMU on heterogeneous
>     systems
> 
> Go ahead and set __GFP_ACCOUNT for these allocations.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
> 
>   Applies to github.com/oupton/linux kvm-arm64/virtual-cache-geometry
> 
>   arch/arm64/kvm/arm.c      | 2 +-
>   arch/arm64/kvm/sys_regs.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9c5573bc4614..3619f1e472f5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -146,7 +146,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	if (ret)
>   		goto err_unshare_kvm;
>   
> -	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
> +	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL_ACCOUNT)) {
>   		ret = -ENOMEM;
>   		goto err_unshare_kvm;
>   	}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6a742af8010f..5dc13d02721e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -160,7 +160,7 @@ static int set_ccsidr(struct kvm_vcpu *vcpu, u32 csselr, u32 val)
>   		if (val == get_ccsidr(vcpu, csselr))
>   			return 0;
>   
> -		ccsidr = kmalloc_array(CSSELR_MAX, sizeof(u32), GFP_KERNEL);
> +		ccsidr = kmalloc_array(CSSELR_MAX, sizeof(u32), GFP_KERNEL_ACCOUNT);
>   		if (!ccsidr)
>   			return -ENOMEM;
>   

Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>
