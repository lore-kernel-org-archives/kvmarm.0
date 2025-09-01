Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71FA35977
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 10:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756724165; cv=none; b=JAiwOas9OlufHgwzxhq21sehCmUsLrrouiguK0auZI31dG3tADnlxt3j3XwC3kORnJ5MJsTJyvBLVglxsiYEFiOicGGmIbJibCzsRHtvNYysgYiodW9719Ru3hS3SR/Dd+4cSBpnqSwcCl4N9Rk/i7DBXpKr8yY7Fgyw+JTiO6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756724165; c=relaxed/simple;
	bh=P9BPZdFHZ5XKGE6FgGHc5F57wdaBOrCqpoJYDaNxEhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hbp6MZz/lH3cXuP+mYWFq0+HxU2akF+LQG6pSVoJyxQX9Fg7mUfCQ3jFjMefjo4CJ+KuUvel4WUOwoyx3FAYA49hnsApw4f08NZ+yKs4dLZ3GlfghodKe9R09/YRld/o4ken/crc3fs/BEKRAZ/lcYkF4g7Qn4To/MaPHPKkb/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cFm0T5B8hz13NJQ;
	Mon,  1 Sep 2025 18:52:09 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 8E225180486;
	Mon,  1 Sep 2025 18:55:58 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Sep 2025 18:55:58 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Sep 2025 18:55:57 +0800
Message-ID: <fc7763d5-bed6-ace6-ace8-a50c031cab36@hisilicon.com>
Date: Mon, 1 Sep 2025 18:55:49 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 0/4] Add workaround for HIP10/HIP10C erratum 162200802
Content-Language: en-US
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <tangnianyao@huawei.com>,
	<wangwudi@hisilicon.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
References: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/8/25 10:39, Zhou Wang wrote:
> As the discussion from V1 series, V2 series firstly adds GICD.num_LPIs
> writable support, then add HiSilicon erratum 162200802.
> 
> Erratum number should be 162200802, make a mistake in V1, so fix it as
> well.
> 
> Zhou Wang (4):
>   KVM: arm64: Allow userspace to write GICD_TYPER.num_LPIs
>   KVM: arm64: selftests: Add test for GICD.num_LPIs
>   Documentation: KVM: arm64: Add GICD_TYPER.num_LPIs writable
>     description
>   ARM64: errata: Add workaround for HIP10/HIP10C erratum 162200802

Hi Marc and Oliver,

As the discussion in V1 series, this series firstly adds GICD.num_LPIs
writable support, then add erratum patch.

If this series is OK, I will prepare QEMU related patch.

BTW v1 is https://lore.kernel.org/all/20250626124142.2035110-1-wangzhou1@hisilicon.com/

Best,
Zhou

> 
>  Documentation/arch/arm64/silicon-errata.rst   |  2 ++
>  .../virt/kvm/devices/arm-vgic-v3.rst          |  6 ++++
>  arch/arm64/Kconfig                            | 12 +++++++
>  arch/arm64/include/asm/cputype.h              |  4 +++
>  arch/arm64/kernel/cpu_errata.c                | 15 +++++++++
>  arch/arm64/kvm/vgic/vgic-init.c               |  9 +++++
>  arch/arm64/kvm/vgic/vgic-its.c                |  9 +++--
>  arch/arm64/kvm/vgic/vgic-kvm-device.c         |  1 +
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 22 +++++++++++++
>  arch/arm64/tools/cpucaps                      |  1 +
>  include/kvm/arm_vgic.h                        |  1 +
>  include/linux/irqchip/arm-gic-v3.h            |  1 +
>  tools/testing/selftests/kvm/arm64/vgic_init.c | 33 +++++++++++++++++++
>  .../selftests/kvm/include/arm64/gic_v3.h      |  2 ++
>  14 files changed, 116 insertions(+), 2 deletions(-)
> 
