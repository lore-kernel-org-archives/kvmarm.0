Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C521C4708D
	for <kvmarm@archiver.kernel.org>; Wed,  4 Jan 2023 03:33:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B50944BA7A;
	Tue,  3 Jan 2023 22:33:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a3drsW8yX0Np; Tue,  3 Jan 2023 22:33:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 353124BB06;
	Tue,  3 Jan 2023 22:33:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 913E44BA77
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 22:33:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uottYm0oP8EE for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 22:33:37 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67ED64BA7A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 22:33:37 -0500 (EST)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.57])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Nmw7x31pRzJprj;
 Wed,  4 Jan 2023 11:29:33 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 4 Jan 2023 11:33:31 +0800
Subject: Re: [PATCH] MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
To: Marc Zyngier <maz@kernel.org>
References: <20230103123933.3234865-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <562bdac0-2330-1ca0-0d06-8c279fd10c32@huawei.com>
Date: Wed, 4 Jan 2023 11:33:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20230103123933.3234865-1-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
