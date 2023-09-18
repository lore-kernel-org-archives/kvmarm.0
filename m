Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980B51BDC5
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 11:16:33 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Rq2FG3jY9ztSSK;
	Mon, 18 Sep 2023 19:12:18 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 18 Sep 2023 19:16:29 +0800
Subject: Re: [PATCH] KVM: arm64: selftests: Add arch_timer_edge_cases selftest
To: Colton Lewis <coltonlewis@google.com>
CC: <kvm@vger.kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <ricarkol@google.com>,
	<kvmarm@lists.linux.dev>
References: <gsnt8r97ifsz.fsf@coltonlewis-kvm.c.googlers.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <9bf8d239-2851-087b-9608-0c776b721ed7@huawei.com>
Date: Mon, 18 Sep 2023 19:16:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <gsnt8r97ifsz.fsf@coltonlewis-kvm.c.googlers.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

Hi Colton,

On 2023/9/16 0:04, Colton Lewis wrote:
> It's been a few months with no comment on this. Can someone please
> review? There was no need to rebase from the original patch. It's all
> new code so there are no conflicts.
> 
> I understand it's a bigger patch, but I believe it all falls under the
> same functional umbrella.

Thanks for your efforts. I'd like to give it a go but this patch fails
to compile on the mainline kernel.

In file included from include/aarch64/delay.h:9,
                 from lib/aarch64/gic_v3.c:10:
include/aarch64/arch_timer.h: In function 'timer_get_tval':
include/aarch64/arch_timer.h:107:3: warning: implicit declaration of 
function 'GUEST_ASSERT_1'; did you mean 'GUEST_ASSERT_NE'? 
[-Wimplicit-function-declaration]
  107 |   GUEST_ASSERT_1(0, timer);
      |   ^~~~~~~~~~~~~~
      |   GUEST_ASSERT_NE

... and something like that. It'd be good if you could have a look.

Thanks,
Zenghui
