Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B4B7C
	for <kvmarm@lists.linux.dev>; Wed,  4 Jan 2023 03:33:42 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.57])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Nmw7x31pRzJprj;
	Wed,  4 Jan 2023 11:29:33 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 4 Jan 2023 11:33:31 +0800
Subject: Re: [PATCH] MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
	<linux-arm-kernel@lists.infradead.org>
References: <20230103123933.3234865-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <562bdac0-2330-1ca0-0d06-8c279fd10c32@huawei.com>
Date: Wed, 4 Jan 2023 11:33:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230103123933.3234865-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
Message-ID: <20230104033331.LMyr1S7FyG_l554H2l-G5VuItxwpxzYM_B1x7s8GuUs@z>

On 2023/1/3 20:39, Marc Zyngier wrote:
> Zenghui has been around for quite some time, and has been instrumental
> in reviewing the GICv4/4.1 KVM support. I'm delighted that he's agreed
> to help with the patch review in a more official capacity!
> 
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f61eb221415b..551544d877a3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11359,6 +11359,7 @@ R:	James Morse <james.morse@arm.com>
>  R:	Alexandru Elisei <alexandru.elisei@arm.com>
>  R:	Suzuki K Poulose <suzuki.poulose@arm.com>
>  R:	Oliver Upton <oliver.upton@linux.dev>
> +R:	Zenghui Yu <yuzenghui@huawei.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  L:	kvmarm@lists.linux.dev
>  L:	kvmarm@lists.cs.columbia.edu (deprecated, moderated for non-subscribers)

Acked-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks Marc!
