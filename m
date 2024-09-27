Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF8518CC01
	for <kvmarm@lists.linux.dev>; Fri, 27 Sep 2024 12:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440238; cv=none; b=UFd45/3IxPNmfV12pwJF7bHlKtWhBu04ZBonjoezrhz8E1Dd7G6x0uLQOvmHSaTqcCUK4oeG2yxeowHhqhOzdMHXRLGz0CkwS4Uh32LAAkIkBoYvvAoTZhJ/pV4t7Hdim7fj1sZkTIn5p0c9eK2JmfTDDtVGJiecmZqTeTZGp/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440238; c=relaxed/simple;
	bh=3Pn9eA1WNvxj7KUL7ubzyUfODv2qFAQBlZ/vrM5V+PU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=X4WFLWwydlP4w0wQxQn23Cr45uNMWOqyAUOAlVe1SzonedCYStOG7eegs+lHeylIL5S4GB7qzxg1O+v2x36VGfjjLJh/ldCOfmzsfZPv/6zfhMbV7AjRO89fws77oaeMarR/QygDo/hhMvw7J2NQUz+FsDw0JrNd5xjwtmkQL3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XFV9k2JpdzWf3d;
	Fri, 27 Sep 2024 20:28:10 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 71EA618010A;
	Fri, 27 Sep 2024 20:30:28 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 27 Sep 2024 20:30:27 +0800
Subject: Re: [PATCH] KVM: arm64: Another reviewer reshuffle
To: Marc Zyngier <maz@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon
	<will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
References: <20240927104956.1223658-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <17304d38-d435-2e97-9e5e-329b4479bbca@huawei.com>
Date: Fri, 27 Sep 2024 20:30:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240927104956.1223658-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/9/27 18:49, Marc Zyngier wrote:
> It has been a while since James had any significant bandwidth to
> review KVM/arm64 patches. But in the meantime, Joey has stepped up
> and did a really good job reviewing some terrifying patch series.
> 
> Having talked with the interested parties, it appears that James
> is unlikely to have time for KVM in the near future, and that Joey
> is willing to take more responsibilities.
> 
> So let's appoint Joey as an official reviewer, and give James some
> breathing space, as well as my personal thanks. I'm sure he will
> be back one way or another!

With my thanks to James :-)

> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Joey Gouly <joey.gouly@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 878dcd23b3317..fe2028b5b250f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12270,7 +12270,7 @@ F:	virt/kvm/*
>  KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
>  M:	Marc Zyngier <maz@kernel.org>
>  M:	Oliver Upton <oliver.upton@linux.dev>
> -R:	James Morse <james.morse@arm.com>
> +R:	Joey Gouly <joey.gouly@arm.com>
>  R:	Suzuki K Poulose <suzuki.poulose@arm.com>
>  R:	Zenghui Yu <yuzenghui@huawei.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)

Acked-by: Zenghui Yu <yuzenghui@huawei.com>

Welcome!
