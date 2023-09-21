Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9943B8F55
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 09:16:46 +0000 (UTC)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RrqV41BkXzrS48;
	Thu, 21 Sep 2023 17:14:36 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 21 Sep 2023 17:16:43 +0800
Subject: Re: [PATCH v2 06/11] KVM: arm64: Use vcpu_idx for invalidation
 tracking
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvm@vger.kernel.org>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Joey Gouly
	<joey.gouly@arm.com>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>
References: <20230920181731.2232453-1-maz@kernel.org>
 <20230920181731.2232453-7-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ce3a9022-0d4e-ad8d-8a32-a9759f718ab3@huawei.com>
Date: Thu, 21 Sep 2023 17:16:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230920181731.2232453-7-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

On 2023/9/21 2:17, Marc Zyngier wrote:
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 872679a0cbd7..23c22dbd1969 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -438,9 +438,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	 * We might get preempted before the vCPU actually runs, but
>  	 * over-invalidation doesn't affect correctness.
>  	 */
> -	if (*last_ran != vcpu->vcpu_id) {
> +	if (*last_ran != vcpu->vcpu_idx) {
>  		kvm_call_hyp(__kvm_flush_cpu_context, mmu);
> -		*last_ran = vcpu->vcpu_id;
> +		*last_ran = vcpu->vcpu_idx;
>  	}
>  
>  	vcpu->cpu = cpu;

Isn't the original code (using vcpu_id) enough to detect a different
previously run VCPU? What am I missing?

Thanks,
Zenghui
