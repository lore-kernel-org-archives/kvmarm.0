Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB7A8F55
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 09:32:28 +0000 (UTC)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.54])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RrqpH2JPXzNnpY;
	Thu, 21 Sep 2023 17:28:39 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 21 Sep 2023 17:32:25 +0800
Subject: Re: [PATCH v2 10/11] KVM: arm64: vgic-v3: Optimize affinity-based SGI
 injection
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvm@vger.kernel.org>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Joey Gouly
	<joey.gouly@arm.com>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>
References: <20230920181731.2232453-1-maz@kernel.org>
 <20230920181731.2232453-11-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <66586d70-2138-7c6d-8565-f7e25d85d5e4@huawei.com>
Date: Thu, 21 Sep 2023 17:32:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230920181731.2232453-11-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

On 2023/9/21 2:17, Marc Zyngier wrote:
> Our affinity-based SGI injection code is a bit daft. We iterate
> over all the CPUs trying to match the set of affinities that the
> guest is trying to reach, leading to some very bad behaviours
> if the selected targets are at a high vcpu index.
> 
> Instead, we can now use the fact that we have an optimised
> MPIDR to vcpu mapping, and only look at the relevant values.
> 
> This results in a much faster injection for large VMs, and
> in a near constant time, irrespective of the position in the
> vcpu index space.
> 
> As a bonus, this is mostly deleting a lot of hard-to-read
> code. Nobody will complain about that.
> 
> Suggested-by: Xu Zhao <zhaoxu.35@bytedance.com>
> Tested-by: Joey Gouly <joey.gouly@arm.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Probably update the comment on top of vgic_v3_dispatch_sgi() to reflect
the new approach.

| * If the interrupt routing mode bit is not set, we iterate over all 
VCPUs to
| * check for matching ones. If this bit is set, we signal all, but not the
| * calling VCPU.

Zenghui
