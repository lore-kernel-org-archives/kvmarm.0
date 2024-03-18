Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0FFA2A
	for <kvmarm@lists.linux.dev>; Mon, 18 Mar 2024 10:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710757877; cv=none; b=oKb/wlvZmG6CJ6jo/nMDsvxlzm7BvUGZt1BbNFV0fBQEsEPKgeoTgp6lTvrlGfN+I5aifM/lcZwiIgiOwiZjRLdKtAN1kWi2sIFmsOSX71Hpk2AZGuKTY4Ms5lYUXPUONyFwWF9jz+ZDx5SPr6Fh9fny2CUhRVCQhNljgxZTdvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710757877; c=relaxed/simple;
	bh=NeyLNWAIyDQ0JUE+fLAY1CNq7XcVqi8QrWGhOCgZKXU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Y+qV3vTF2y2zTjrH8cn+kA6Ag98ptNcNJdT85h9YT7rlAcwXzJzBHf4T70a1/nCudx40YqB3HTYdoKcOjm1nPDu5ojyMz6TAce+42MYQvm4SK44IS6Kkriy8JRnJzI0Dnt+b5yn6r9hRsAWKQg53pvXNe2w7tkc5r+FnfDWxIpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Tyrfm1LsrzXjHQ;
	Mon, 18 Mar 2024 18:28:32 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id B1A1D140259;
	Mon, 18 Mar 2024 18:31:05 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 18 Mar 2024 18:31:04 +0800
Subject: Re: [PATCH] KVM: arm64: Change back kvm fault condition to
 translation
To: Marc Zyngier <maz@kernel.org>
CC: Wujie Duan <wjduan@linx-info.com>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>
References: <20240318100249.220897-1-wjduan@linx-info.com>
 <864jd3269g.wl-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <14f40fcd-6951-5c86-b6b6-da5735105dc1@huawei.com>
Date: Mon, 18 Mar 2024 18:31:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <864jd3269g.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/3/18 18:17, Marc Zyngier wrote:
> Subject: [PATCH] KVM: arm64: Fix out-of-IPA space translation fault handling
> 
> Commit 11e5ea5242e3 ("KVM: arm64: Use helpers to classify exception
> types reported via ESR") tried to abstract the translation fault
> check when handling an out-of IPA space condition, but incorrectly
> replaced it with a permission fault check.
> 
> Restore the previous translation fault check.
> 
> Fixes: 11e5ea5242e3 ("KVM: arm64: Use helpers to classify exception types reported via ESR")
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Wujie Duan <wjduan@linx-info.com>
> Cc:stable@vger.kernel.org

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
