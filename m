Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4B91FCA
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 13:13:45 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id b12so2640018edd.6
        for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 06:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6jud7Ls3+0knS57eOkqU3aPXs8XYGaLsC/MSEs6EmMo=;
        b=coB5F5xlLS4ZGJBOq74G9Z7uo7MjBZy+xChFNFzoqe+qjUjBYjA4yG1TWEBHfNf4J1
         mcdzCmwZ0+4mnlL09NJuhBUcMzD/vWbDQ0eJak2pQOQ6rdEccapzTYCXSbCn6AAj6Qiq
         LNkUvDPQkbCCPKiXSonDd3/hYnygASrQyv1O1MR6gKEOmrBxy2KpnZWWbHDMZLUi/99d
         0VgU3srN3IvjP2tmS6krA4c6Lw0mFYaB8+J6sA/FfR3/G7B2S4THT6CQSwIaIerUdMrK
         AYrpNORcotEHf07jXdHVZLpktcyh0+MWOwlfTrhBESUzQ2kjXbTWRkBQAYcbtYUxMetE
         RBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jud7Ls3+0knS57eOkqU3aPXs8XYGaLsC/MSEs6EmMo=;
        b=kv7KORDh4ssxvNpFvDF9KnljUMvbE/1DJp6TsJZqHCzuH7ABE/l4kiP0IH7q7cdApk
         OizN3k10w+ipBqBerckB5JJl/PwPzSt1xqWCKWgQx/1hmRD10fATL8IqKIduMr6Mpm6o
         YGygZr1kaHdDc1UVHBL8GalQaaMc0KswnKos5dHYCdczoFNTjxgek9/CYPKVBx6e10kD
         3ph7HpGKjzScjUg4vGuj2+O83lQOrk8ABGFTUS610NK5I/aE1F0SBl3h9zGzhh/5U7hl
         gPhn9B+YH5XvyoN4exlV7upZ/HBaYfDgFqUaunO7slR7C9RVPHlg4mtki1R2tkgdxBXK
         MVjw==
X-Gm-Message-State: ACrzQf0/rZ224W9Znd9qjHm4GvcdzMNlbHfZjCfuFION9+ygFRXkR5Sv
	9AeHOLc32DXhnJCEepkKx6gRTQ==
X-Google-Smtp-Source: AMsMyM4WOdSgzl4SwTvaEe8U3ZIL/v1D5C65H+zxttEDUG8sVMzVnwecQoBMQyCHWGwQXYvykKJQfw==
X-Received: by 2002:a05:6402:4312:b0:45c:c1e9:9dc8 with SMTP id m18-20020a056402431200b0045cc1e99dc8mr45490978edc.154.1666876423719;
        Thu, 27 Oct 2022 06:13:43 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id qo14-20020a170907874e00b00773f3cb67ffsm810765ejc.28.2022.10.27.06.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 06:13:42 -0700 (PDT)
Date: Thu, 27 Oct 2022 13:13:38 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 20/25] KVM: arm64: Return guest memory from EL2 via
 dedicated teardown memcache
Message-ID: <Y1qEAokfFPcLaWiq@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-21-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020133827.5541-21-will@kernel.org>

On Thursday 20 Oct 2022 at 14:38:22 (+0100), Will Deacon wrote:
> +static void
> +teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
> +{
> +	size = PAGE_ALIGN(size);
> +	memset(addr, 0, size);
> +
> +	for (void *start = addr; start < addr + size; start += PAGE_SIZE)
> +		push_hyp_memcache(mc, start, hyp_virt_to_phys);
> +
> +	unmap_donated_memory_noclear(addr, size);
> +}
> +
>  int __pkvm_teardown_vm(pkvm_handle_t handle)
>  {
> +	struct kvm_hyp_memcache *mc;
>  	struct pkvm_hyp_vm *hyp_vm;
>  	unsigned int idx;
>  	size_t vm_size;
> @@ -552,7 +565,8 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
>  	hyp_spin_unlock(&vm_table_lock);
>  
>  	/* Reclaim guest pages (including page-table pages) */
> -	reclaim_guest_pages(hyp_vm);
> +	mc = &hyp_vm->host_kvm->arch.pkvm.teardown_mc;
> +	reclaim_guest_pages(hyp_vm, mc);
>  	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->nr_vcpus);
>  
>  	/* Push the metadata pages to the teardown memcache */
> @@ -561,11 +575,11 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
>  	for (idx = 0; idx < hyp_vm->nr_vcpus; ++idx) {
>  		struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vm->vcpus[idx];
>  
> -		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
> +		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
>  	}
>  
>  	vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
> -	unmap_donated_memory(hyp_vm, vm_size);
> +	teardown_donated_memory(mc, hyp_vm, vm_size);

We should move the unpinning of the host's kvm struct down here as 'mc'
here is part of it. Otherwise nothing prevents the host from unsharing
the pages and donating them, etc. Probably hard to exploit but still
worth fixing IMO.

Thanks,
Quentin

>  	return 0;
