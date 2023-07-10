Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370662F2F
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 15:33:55 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4R06wz5JczztRBX;
	Mon, 10 Jul 2023 23:14:27 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 23:17:24 +0800
Subject: Re: [PATCH 3/4] KVM: arm64: Replace vCPU target with a configuration
 flag
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Jing Zhang
	<jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>
References: <20230623194258.2648987-1-oliver.upton@linux.dev>
 <20230623194258.2648987-4-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d96c5806-5fb7-eaca-c3ae-5c06f693ad9a@huawei.com>
Date: Mon, 10 Jul 2023 23:17:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230623194258.2648987-4-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/6/24 3:42, Oliver Upton wrote:
> The value of kvm_vcpu_arch::target has been used to determine if a vCPU
> has actually been initialized. Storing this as an integer is needless at
> this point, as KVM doesn't do any microarch-specific emulation in the
> first place. Instead, all we care about is whether or not the vCPU has
> been initialized.
> 
> Delete the field in favor of a vCPU configuration flag indicating if
> KVM_ARM_VCPU_INIT has completed for the vCPU.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

[...]

> @@ -1259,7 +1257,7 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>  	if (ret)
>  		return ret;
>  
> -	if (vcpu->arch.target == -1)
> +	if (!vcpu_get_flag(vcpu, VCPU_INITIALIZED))

if (!kvm_vcpu_initialized(vcpu)) ?

Regardless,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
