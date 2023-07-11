Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA20C3C28
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 04:55:37 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R0T711s6BzVhnf;
	Tue, 11 Jul 2023 12:54:21 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 11 Jul 2023 12:55:31 +0800
Subject: Re: [PATCH v2 2/4] KVM: arm64: Remove pointless check for changed
 init target
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20230710193140.1706399-1-oliver.upton@linux.dev>
 <20230710193140.1706399-3-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <94303255-70b7-a8a7-a370-24e8e81994c5@huawei.com>
Date: Tue, 11 Jul 2023 12:55:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230710193140.1706399-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/7/11 3:31, Oliver Upton wrote:
> At any time there is only a single valid value for KVM_ARM_VCPU_INIT,
> depending on the current CPU implementation. In all likelihood, this
> will be the generic ARMv8 target.
> 
> Drop the pointless check for a changed target value between calls to
> KVM_ARM_VCPU_INIT and instead rely on the check against
> kvm_target_cpu().
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
