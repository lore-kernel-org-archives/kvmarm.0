Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4B7307206
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 03:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746502463; cv=none; b=NwPKEIZtEP7QMcwkkLJIMBsYF+bNXoydZPnmgyWsGVFWgcOJ2+5jlWDNJNx27e+76sTla4TqS0Xd8ydeNAbfo9pNr2eiBGOte9lvblANXKz1n9Nw0iNVgA/GscOM5TOoH6X6a3JThjAu5Kblv6Fym/IPNBRcdFz5EEI8vhdsWyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746502463; c=relaxed/simple;
	bh=YXxzwzUfShMmUTLeJNa4UxyS7JtYbIjaxIMf/MdcsGo=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=febvWiEHLvUa2XjUw1ul9+xL/DX+F8JArGsFN6oP7aWPblpDxv/u7NjzO4C8n56DVgRYs4RKajTEJQMpb6If2vExgPGRyD8n84Mayrw+E+4JvhME1FVmn2EHDZDhDVFEaIYGxl621UI7oFGYS5MDXiYKZ5qXsoSxUZCxKoPwKIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Zs3mq2C3BzyVKC;
	Tue,  6 May 2025 11:30:03 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 2974A180B5F;
	Tue,  6 May 2025 11:34:18 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 6 May 2025 11:34:16 +0800
Subject: Re: [PATCH] arm64: kvm: Replace ternary flags with str_on_off()
 helper
To: Seongsu Park <sgsu.park@samsung.com>
CC: <will@kernel.org>, <catalin.marinas@arm.com>, <suzuki.poulose@arm.com>,
	<joey.gouly@arm.com>, <oliver.upton@linux.dev>, <maz@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <cpgs@samsung.com>
References: <CGME20250415012410epcas1p42b48977934c21b5db0b19f4185f7a63c@epcas1p4.samsung.com>
 <1891546521.01744691102904.JavaMail.epsvc@epcpadp1new>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <112b336f-40ee-113b-2b10-4ba2f19573de@huawei.com>
Date: Tue, 6 May 2025 11:34:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <1891546521.01744691102904.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemk200017.china.huawei.com (7.202.194.83)

It'd better to write the subject as "KVM: arm64: Replace ..."

On 2025/4/15 9:24, Seongsu Park wrote:
> Replace repetitive ternary expressions with the str_on_off() helper
> function. This change improves code readability and ensures consistency
> in tracepoint string formatting
> 
> Signed-off-by: Seongsu Park <sgsu.park@samsung.com>
> ---
>  arch/arm64/kvm/trace_arm.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks,
Zenghui
