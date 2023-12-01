Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831B3171C2
	for <kvmarm@lists.linux.dev>; Fri,  1 Dec 2023 10:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from kwepemd500005.china.huawei.com (unknown [172.30.72.54])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ShV7863zjzSgt8;
	Fri,  1 Dec 2023 18:44:36 +0800 (CST)
Received: from [10.174.186.3] (10.174.186.3) by kwepemd500005.china.huawei.com
 (7.221.188.140) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1258.28; Fri, 1 Dec
 2023 18:48:55 +0800
Message-ID: <b6c14068-6ae2-4c25-8308-6ad506e51f74@huawei.com>
Date: Fri, 1 Dec 2023 18:48:54 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: fix MPIDR to vcpu index cache to support vcpu
 change at runtime
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<zhengchuan@huawei.com>, <xiexiangyou@huawei.com>, <liting8@huawei.com>
References: <20231128135402.1943-1-liting8@huawei.com>
 <87il5k8j1p.wl-maz@kernel.org>
From: "liting (Q)" <liting8@huawei.com>
In-Reply-To: <87il5k8j1p.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd500005.china.huawei.com (7.221.188.140)
X-CFilter-Loop: Reflected

On 2023/11/30 3:18, Marc Zyngier wrote:
> On Tue, 28 Nov 2023 13:54:02 +0000,
> l00313349 <liting8@huawei.com> wrote:
>> From: Ting Li <liting8@huawei.com>
>>
>> Consider vcpu change at runtime, for example online_vcpus is 8,
>> but only start 2 vcpu threads, MPIDR to vcpu index 0 may be overwrited
>> and vm hangs. When start other vcpu threads, cache will be outdated
>> and always get mismatch.
> If userspace creates two vcpus with the same vcpu_id, and therefore
> the same MPIDR value, that's userspace's problem. Don't do that.
>
> Why should we do anything else?
>
> 	M.
Hi Marc,
Thanks for your reply. Maybe you have misunderstanding about it.
The problem is not two vcpus with the same vcpu_id, but different vcpu_id
have the same MPIDR value in some situation such as vcpu hotplug.
In my case, total vcpu count is 8 but only start 2 vcpu at the beginning,
then vcpu_id 2-7 will get the same MPIDR value 0 with vcpu_id 0, so
index 0 will be overwrited to vcpu_id 7.
Please check, thanks.
Ting Li
