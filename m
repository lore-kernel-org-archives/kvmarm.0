Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2435510A3C
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 07:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4S9MB64ryfz15NcQ;
	Wed, 18 Oct 2023 14:58:06 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 18 Oct 2023 15:00:48 +0800
Subject: Re: [PATCH v2 2/5] KVM: arm64: Restore the stage-2 context in VHE's
 __tlb_switch_to_host()
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, Marc Zyngier
	<maz@kernel.org>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
 <20231012205422.3924618-3-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5563bffd-0b27-ac95-9e87-24f5b8c71fb7@huawei.com>
Date: Wed, 18 Oct 2023 15:00:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231012205422.3924618-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

On 2023/10/13 4:54, Oliver Upton wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> An MMU notifier could cause us to clobber the stage-2 context loaded on
> a CPU when we switch to another VM's context to invalidate. This isn't
> an issue right now as the stage-2 context gets reloaded on every guest
> entry, but is disastrous when moving __load_stage2() into the
> vcpu_load() path.
> 
> Restore the previous stage-2 context on the way out of a TLB
> invalidation if we installed something else. Deliberately do this after
> TGE=1 is synchronized to keep things safe in light of the speculative AT
> errata.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/vhe/tlb.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index f3f2e142e4f4..ef21153ce5fa 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -11,18 +11,25 @@
>  #include <asm/tlbflush.h>
>  
>  struct tlb_inv_context {
> -	unsigned long	flags;
> -	u64		tcr;
> -	u64		sctlr;
> +	struct kvm_s2_mmu	*mmu;
> +	unsigned long		flags;
> +	u64			tcr;
> +	u64			sctlr;
>  };
>  
>  static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
>  				  struct tlb_inv_context *cxt)
>  {
> +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>  	u64 val;
>  
>  	local_irq_save(cxt->flags);
>  
> +	if (vcpu && mmu != vcpu->arch.hw_mmu)
> +		cxt->mmu = mmu;

Shouldn't this be

cxt->mm = vcpu->arch.hw_mmu (the "previous" S2 context)?

Thanks,
Zenghui
