Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A25015250D
	for <kvmarm@lists.linux.dev>; Thu,  9 May 2024 14:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715263813; cv=none; b=D+xuOOsuSeQoGJW6Q1UuD3EM/BuRSFAc6hoqo3ajTw3+HNVphG+QwYDA6s5fTwegxskRinf0CKLzmpAjUSVkKcOMEd0klemI6VcLB3mue3k3yOJ1poDdK680jpVEyJ8RVD1M/W9CmMoXCKsKsMMMD69uQKxU4/Ds8Na4Aeufy6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715263813; c=relaxed/simple;
	bh=hQ5NVB+/LA6wujAxQ1ov4T3PucGFudV+Bt2WWI/AnlU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PcvYitnt/EDboy0u6OYbohHAjOfdJOM8MmLJZwSNYEWNSy+LDoqNpZeYSNOzYg/Xyc+xo1TQt9qyc+BLwPAMrrMIN6UM64uaWQGVH6hLEb4aDvkpq285dNRcEzZAvw95pOpiksbmBZbvaJyLe355yjxr3WcNu+J7vvh/fDPoUww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VZv2K3ByJztTYg;
	Thu,  9 May 2024 22:06:33 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id C1CDE1800CA;
	Thu,  9 May 2024 22:10:00 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 9 May 2024 22:09:59 +0800
Subject: Re: [PATCH v4 01/30] KVM: arm64: Initialize the kvm host data's
 fpsimd_state pointer in pKVM
To: Fuad Tabba <tabba@google.com>
CC: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <seanjc@google.com>, <alexandru.elisei@arm.com>,
	<catalin.marinas@arm.com>, <philmd@linaro.org>, <james.morse@arm.com>,
	<suzuki.poulose@arm.com>, <oliver.upton@linux.dev>, <mark.rutland@arm.com>,
	<broonie@kernel.org>, <joey.gouly@arm.com>, <rananta@google.com>,
	<smostafa@google.com>
References: <20240423150538.2103045-1-tabba@google.com>
 <20240423150538.2103045-2-tabba@google.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4ec3be32-476a-14f2-7826-2171df1c9f77@huawei.com>
Date: Thu, 9 May 2024 22:09:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240423150538.2103045-2-tabba@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Fuad,

On 2024/4/23 23:05, Fuad Tabba wrote:
> Since the host_fpsimd_state has been removed from kvm_vcpu_arch,
> it isn't pointing to the hyp's version of the host fp_regs in
> protected mode.
> 
> Initialize the host_data fpsimd_state point to the host_data's
> context fp_regs on pKVM initialization.
> 
> Fixes: 51e09b5572d6 ("KVM: arm64: Exclude host_fpsimd_state pointer from kvm_vcpu_arch")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 11 +++++++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c        |  1 +
>  3 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index 82b3d62538a6..20c3f6e13b99 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -54,6 +54,7 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
>  }
>  
>  void pkvm_hyp_vm_table_init(void *tbl);
> +void pkvm_host_fpsimd_state_init(void);
>  
>  int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
>  		   unsigned long pgd_hva);
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 26dd9a20ad6e..492b7fc2c0c7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -247,6 +247,17 @@ void pkvm_hyp_vm_table_init(void *tbl)
>  	vm_table = tbl;
>  }
>  
> +void pkvm_host_fpsimd_state_init(void)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < hyp_nr_cpus; i++) {
> +		struct kvm_host_data *host_data = per_cpu_ptr(&kvm_host_data, i);
> +
> +		host_data->fpsimd_state = &host_data->host_ctxt.fp_regs;

So we save the host FP/SIMD state in hypervisor's private host_ctxt when
guest accesses to FP/SIMD. Do we then need to save it into host VCPU's
process state and (if so,) how does that happen?

Could you please point me to that piece of code? Sorry I'm really not
familiar with the protected mode. ;-).

Thanks,
Zenghui
