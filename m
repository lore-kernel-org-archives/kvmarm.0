Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503683D76
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 15:13:39 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R06tf1PVkzTmPj;
	Mon, 10 Jul 2023 23:12:26 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 23:13:35 +0800
Subject: Re: [PATCH 4/4] KVM: arm64: Always return generic v8 as the preferred
 target
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Jing Zhang
	<jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>
References: <20230623194258.2648987-1-oliver.upton@linux.dev>
 <20230623194258.2648987-5-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <23bdb1d7-4153-594b-75e7-3452385f81a6@huawei.com>
Date: Mon, 10 Jul 2023 23:13:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230623194258.2648987-5-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

Hi Oliver,

On 2023/6/24 3:42, Oliver Upton wrote:
> Userspace selecting an implementation-specific vCPU target has been
> completely useless for a very long time. Let's go whole hog and start
> returning the generic v8 target across all implementations as the
> preferred target.
> 
> Uphold the pre-existing behavior by tolerating either the generic target
> or an implementation-specific target if the vCPU happens to be running
> on one of the lucky few parts.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

I love the idea.

Acked-by: Zenghui Yu <yuzenghui@huawei.com>

> ---
>  arch/arm64/kvm/arm.c   | 3 ++-
>  arch/arm64/kvm/guest.c | 4 +---
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3fa63fdbbf34..5a3b8b2e779b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1250,7 +1250,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>  {
>  	int ret;
>  
> -	if (init->target != kvm_target_cpu())
> +	if (init->target != KVM_ARM_TARGET_GENERIC_V8 &&
> +	    init->target != kvm_target_cpu())
>  		return -EINVAL;

I can see that user-space can now select GENERIC_V8 or CORTEX_A53 (for
example) between two KVM_ARM_VCPU_INIT calls on an A53 host, which was
forbidden before this change. I don't think it's a big deal though.

Thanks,
Zenghui
