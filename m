Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3716817B41C
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 08:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720601676; cv=none; b=QwCpOU3X6rr9+HNKh61Y6xDthpCpeZsN/zuiAwkDQ8UAoYn78wlpsPfR9nFt1wrF1NBvxZemvFYhimfPu99ho58k4odM8IlpeK5uzhyXrqTDANpOvHGBlBfDHmuVIcpDBSNDt9hkMmyGcA293DhYeFiZZyfsO5rp5v2pC3BpmmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720601676; c=relaxed/simple;
	bh=JmHBrpDMagDavRXtU8xMvlEwi3yUfLh3jZjd30bdrW8=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CbU8dmFRqNbYlFSygNy+07FTCZHm8CzAx1SZ7Xse73GNePZgjj2sX+RtKsZv0M+LGAf7th1kwnkynvzPs7Nw+xZqhybqRYordKfqFEnrFyChWSv1A98DbXd5zUkXx0rLSrqkFDcM2mCfoJE3oX0d3yuj7wCd66QPzfYy+vFhYFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WJs462k8BzwWY0;
	Wed, 10 Jul 2024 16:49:42 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id F0803140257;
	Wed, 10 Jul 2024 16:54:24 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 10 Jul 2024 16:54:23 +0800
Subject: Re: [PATCH v2 2/3] KVM: arm64: vgic-its: Clear dte when mapd unmaps a
 device
To: Kunkun Jiang <jiangkunkun@huawei.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>, Eric Auger <eauger@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, <lishusen2@huawei.com>,
	<tangnianyao@huawei.com>
References: <20240704142319.728-1-jiangkunkun@huawei.com>
 <20240704142319.728-3-jiangkunkun@huawei.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <9714cd31-f72b-ddb6-4443-6244c44c0d96@huawei.com>
Date: Wed, 10 Jul 2024 16:54:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240704142319.728-3-jiangkunkun@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/7/4 22:23, Kunkun Jiang wrote:
> vgic_its_save_device_tables will traverse its->device_list to
> save dte for each device. vgic_its_restore_device_tables will
> traverse each entry of device table and check if it is valid.
> Restore if valid.
> 
> But when mapd unmaps a devices, we do not invalidate the
> corresponding dte. In the scenario of continuous save
> and restore, there may be a situation where a device's dte
> is not saved but is restored. This is unreasonable and may
> cause restore to fail. This patch clears the corresponding
> dte when mapd unmaps a device.
> 
> Co-developed-by: Shusen Li <lishusen2@huawei.com>
> Singed-off-by: Shusen Li <lishusen2@huawei.com>
  ^^^^^^

Please do fix the tag. checkpatch.pl should have complained about it
already if you run it.

Zenghui
