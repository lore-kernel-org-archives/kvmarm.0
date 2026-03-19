Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DD73C3C01
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 12:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773924912; cv=none; b=P4BLtcS9wjCx9s2JVvF67q24mBmVPnMCTlrp9ufzndHXMVSExQ9RiVNsFM2d4qNuJ6R/P9cWlcEXOJdsEm4AhRz5Dx5A9YnCktFXVo+HvZBUGEKiJ6kQZphQB9ZRqO4hDvcnJ41/lJLeBHsjcwI6c6pFR0vWGEFJ9hFosYi0diM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773924912; c=relaxed/simple;
	bh=ACwPpgwUlwEwnD5R0IprMNE/Bv72ilDjglXKZ7NQR2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=K42zJMpkX9PXDw18R831M+89APMu5YTzeKlr3uSPI3berPoyhV1XH0d9fcRPUm9jn1fUeljVi4YL++50yg8URjz+BN2mLHaYGmBHU/gG/fYgdo4z84nI7BjRLq9xXaVQdJGVRot7/pInF6PEJRivrjiKV3H58T94uqqSV9fBHxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fc5Bg0c56z1prjs;
	Thu, 19 Mar 2026 20:50:03 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 950754056B;
	Thu, 19 Mar 2026 20:55:05 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 19 Mar 2026 20:55:05 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 19 Mar 2026 20:55:04 +0800
Message-ID: <4bbf64ef-e629-3908-b37f-d99c6639be2c@hisilicon.com>
Date: Thu, 19 Mar 2026 20:54:51 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Question about ARM KVM stage2 contiguous bit support for
 contiguous hugetlb
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<tangnianyao@huawei.com>, jiangkunkun <jiangkunkun@huawei.com>, "xuwei (O)"
	<xuwei5@huawei.com>, "Zengtao (B)" <prime.zeng@hisilicon.com>
References: <704b6126-f1ad-4d8a-5709-a12e4c8c79ca@hisilicon.com>
 <87qzpocgol.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <87qzpocgol.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2026/3/13 15:49, Marc Zyngier wrote:
> On Fri, 13 Mar 2026 07:09:40 +0000,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> And do we have any plan to support this?
> 
> Not really.
> 
> Configurations that are looking at extracting the best possible
> performance use large mappings at S2 (hugetlbfs). I'm not convinced
> that there is a strong use-case for dealing with the contiguous hint
> at S2 when backed by anonymous memory. If you're not under memory

We want use 64KB basic page, in this case we have 2M cont PTE and 512M
block page. However, the latter may waste more memory.

> pressure, THP already gives you the uplift you want. If you are under
> memory pressure, you're unlikely to get the contiguity you want.
> 
> Additionally, dealing with the contiguous hint is a real pain.
> 
> If you are undertaking this work, please make sure to provide
> reproducible benchmarks and results that show a definite improvement
> on the majority of workloads.

We have a initial test in hardware emulator, for lmbench lat_mem_rd 1G
256 stride，the cost of virtualization will change from 17% -> 3%, we do
the test using a VM with 4 vCPU / 8GB memory in 64KB basic page / 2M
contiguous hugetlb system.

Will do more tests in the real chip.

Best,
Zhou

> 
> Thanks,
> 
> 	M.
> 
