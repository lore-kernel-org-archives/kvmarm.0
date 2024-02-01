Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82B18664F
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795357; cv=none; b=T8kUltAG3ZNVjKe5ALjd/HkS7V4Vv1QFqXu0BtgQ7LZ2ReVtNM5E1k4tE27H1qZ8FZD6L9uT9OoSaAEKFaVZFyWFBfZG+GNz/OmSZwW6if+3Ev+2tTVo+OttciacGp4QGB1UcAHLwN5SAyKppokFtIQxIfw1vZNlS0esUUutFPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795357; c=relaxed/simple;
	bh=bOId8USkLcb/U8KoLOJVOiQcwBkApRk2r63Q2Znl8io=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Rzi4jPExx9rlODGj3uDuX0ZKyzDKWqlZD7J6qTPwwWpNoikZF9t7OHDwRpuFLp8LacRb39eqOQQ1zTFFSqpzCJEsYTMHxbgTayw+rr8KS9f+2sxxxnjTv68TaYHWoHomE6W8uOEoE5eOw+esSEQPo3UWAidCa1/HR4MfFxiD68g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TQgGF0hGdz1xn42;
	Thu,  1 Feb 2024 21:48:05 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 4294D1400D4;
	Thu,  1 Feb 2024 21:49:06 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 1 Feb 2024 21:49:05 +0800
Subject: Re: [PATCH 00/10] KVM: arm64: fix many kernel-doc warnings
To: Randy Dunlap <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver
 Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>
References: <20240117230714.31025-1-rdunlap@infradead.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e875f1c6-2e1e-632a-3db0-5a21aa73f20f@huawei.com>
Date: Thu, 1 Feb 2024 21:49:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240117230714.31025-1-rdunlap@infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/1/18 7:07, Randy Dunlap wrote:
> Fix a bunch of kernel-doc warnings in arch/arm64/kvm/.
> 
>  [PATCH 01/10] KVM: arm64: debug: fix kernel-doc warnings
>  [PATCH 02/10] KVM: arm64: guest: fix kernel-doc warnings
>  [PATCH 03/10] KVM: arm64: hyp/aarch32: fix kernel-doc warnings
>  [PATCH 04/10] KVM: arm64: vhe: fix a kernel-doc warning
>  [PATCH 05/10] KVM: arm64: mmu: fix a kernel-doc warning
>  [PATCH 06/10] KVM: arm64: PMU: fix kernel-doc warnings
>  [PATCH 07/10] KVM: arm64: sys_regs: fix kernel-doc warnings
>  [PATCH 08/10] KVM: arm64: vgic-init: fix a kernel-doc warning
>  [PATCH 09/10] KVM: arm64: vgic-its: fix kernel-doc warnings
>  [PATCH 10/10] KVM: arm64: vgic: fix a kernel-doc warning

All look good to me,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks!
