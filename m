Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4797F10FB
	for <kvmarm@lists.linux.dev>; Sun, 15 Jan 2023 11:32:47 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.54])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NvtJS3qbRz16Mc5;
	Sun, 15 Jan 2023 19:31:04 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sun, 15 Jan 2023 19:32:43 +0800
Subject: Re: [PATCH v2] KVM: arm64: vgic-v3: Use kstrtobool() instead of
 strtobool()
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
CC: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
References: <f546e636c6d2bbcc0d8c4191ab98ce892fce4584.1673702763.git.christophe.jaillet@wanadoo.fr>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d3e91900-eb88-2e25-a32e-dc5667939b98@huawei.com>
Date: Sun, 15 Jan 2023 19:32:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f546e636c6d2bbcc0d8c4191ab98ce892fce4584.1673702763.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/1/14 21:26, Christophe JAILLET wrote:
> strtobool() is the same as kstrtobool().
> However, the latter is more used within the kernel.
> 
> In order to remove strtobool() and slightly simplify kstrtox.h, switch to
> the other function name.
> 
> While at it, include the corresponding header file (<linux/kstrtox.h>)
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
