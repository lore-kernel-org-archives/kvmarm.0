Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3696FC5
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 13:45:01 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PWGpt1NwwzKqGD;
	Tue,  7 Mar 2023 21:42:46 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 21:44:50 +0800
Subject: Re: [kvm-unit-tests PATCH v3 0/3] arm: Use gic_enable/disable_irq()
 macro to clean up code
To: Shaoqin Huang <shahuang@redhat.com>
CC: <kvmarm@lists.linux.dev>, Andrew Jones <andrew.jones@linux.dev>, Eric
 Auger <eric.auger@redhat.com>, "open list:ARM" <kvm@vger.kernel.org>
References: <20230303031148.162816-1-shahuang@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <a5222db6-2daf-49eb-3287-5ce28c01e7b2@huawei.com>
Date: Tue, 7 Mar 2023 21:44:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230303031148.162816-1-shahuang@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

On 2023/3/3 11:11, Shaoqin Huang wrote:
> Some tests still use their own code to enable/disable irq, use
> gic_enable/disable_irq() to clean up them.
> 
> The first patch fixes a problem which will disable all irq when use
> gic_disable_irq().
> 
> The patch 2-3 clean up the code by using the macro.

Series,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

and seems that gic_irq_unmask() in arm/pl031.c can also be replaced
by gic_enable_irq(pl031_irq).
