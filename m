Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C62E7F
	for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 06:39:03 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.56])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QGPyl4pNyzpWMf;
	Wed, 10 May 2023 14:20:15 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 14:21:27 +0800
Subject: Re: [PATCH] KVM: arm64: vgic: Add Apple M2 PRO/MAX cpus to the list
 of broken SEIS implementations
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton
	<oliver.upton@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>
References: <20230501182141.39770-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <9d00b09a-044b-55c6-9596-dd04d5b0ca19@huawei.com>
Date: Wed, 10 May 2023 14:21:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230501182141.39770-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/5/2 2:21, Marc Zyngier wrote:
> Unsurprisingly, the M2 PRO is also affected by the SEIS bug, so add it
> to the naughty list. And since M2 MAX is likely to be of the same ilk,
> flag it as well.
> 
> Tested on a M2 PRO mini machine.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
