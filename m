Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25466101F5
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Sfgwv4vfxzWhst;
	Tue, 28 Nov 2023 19:59:27 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 28 Nov 2023 20:00:09 +0800
Subject: Re: [for-4.19 0/2] backport "KVM: arm64: limit PMU version to PMUv3
 for ARMv8.1"
To: Greg KH <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <sashal@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<andrew.murray@arm.com>, <mark.rutland@arm.com>, <suzuki.poulose@arm.com>,
	<wanghaibin.wang@huawei.com>, <will@kernel.org>
References: <20231128074633.646-1-yuzenghui@huawei.com>
 <2023112831-preachy-unshaved-790d@gregkh>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <350d1f6f-953b-eac4-4e1b-9e59060c99bc@huawei.com>
Date: Tue, 28 Nov 2023 20:00:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2023112831-preachy-unshaved-790d@gregkh>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

On 2023/11/28 16:12, Greg KH wrote:
> On Tue, Nov 28, 2023 at 03:46:31PM +0800, Zenghui Yu wrote:
>> We need to backport patch #1 as well because it introduced a helper used
>> by patch #2.
>>
>> Andrew Murray (2):
>>   arm64: cpufeature: Extract capped perfmon fields
>>   KVM: arm64: limit PMU version to PMUv3 for ARMv8.1
> 
> We can not just take these in an old stable tree and not newer ones as
> that would mean you could upgrade and have a regression.  Please provide
> backports for all applicable stable trees and we will be glad to take
> them.

Thanks for the heads up! "for-5.4" patches sent now.

Zenghui
