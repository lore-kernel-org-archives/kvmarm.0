Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0901C3F30
	for <kvmarm@lists.linux.dev>; Tue,  6 Aug 2024 12:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722947955; cv=none; b=Vy82wtnN/nv0Lxr77e+4iWUrDmJ70y5yL8yAkPSv+SgTPxfTigrrOueA9xrEwGEbZh7mxRkz8XI/+XjjAWsMJ9SYI0Iy0Lv2pcL6ladR0WDJcmmLaDa04riTANbs5I/rmpt2ydlfHnri/7EJ3lxZtPQ/+zKH8VgHE2+hbRJDKu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722947955; c=relaxed/simple;
	bh=HX8macLD4W6eLAeksBC+hPhEd3r4zlNwPqvc21C0Eto=;
	h=Subject:From:To:CC:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LJ8orZQkBWqtayxyrXBTXzFOTsefuH81FVXZ49G6aQvdRCdUCvVyo9gCiKBeK/3JoUm1BgM31mH8CuYgG+uyGNQ3KF0tPBu3ZGWqwwctmw7X1jOiGAqTR6UM357GiMSTTGBiY2h417B5C90ci24THMNGi9qmPbrKsqLUm2fZS3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WdXrF0BwVzfZPr;
	Tue,  6 Aug 2024 20:37:17 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 6A10B1800A0;
	Tue,  6 Aug 2024 20:39:10 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 20:39:09 +0800
Subject: Re: [PATCH v3 05/19] KVM: arm64: vgic-debug: Use an xarray mark for
 debug iterator
From: Zenghui Yu <yuzenghui@huawei.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Eric Auger
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
 <20240422200158.2606761-6-oliver.upton@linux.dev>
 <d034a9b8-34ae-923e-8e68-09d2de3cf079@huawei.com>
Message-ID: <178f30f7-edfd-78c5-f392-43cef1ef9baf@huawei.com>
Date: Tue, 6 Aug 2024 20:39:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d034a9b8-34ae-923e-8e68-09d2de3cf079@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/8/6 17:23, Zenghui Yu wrote:
> The following diff seems work for me.
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-debug.c 
> b/arch/arm64/kvm/vgic/vgic-debug.c
> index 6faa1d16c9ce..f56f74c8cf54 100644
> --- a/arch/arm64/kvm/vgic/vgic-debug.c
> +++ b/arch/arm64/kvm/vgic/vgic-debug.c
> @@ -41,11 +41,16 @@ static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
>  		return;
>  	}
>  
> +	iter->intid++;

[*]

> +	if (iter->intid == VGIC_NR_PRIVATE_IRQS &&
> +	    ++iter->vcpu_id < iter->nr_cpus)
> +		iter->intid = 0;
> +
>  	/*
>  	 * Let the xarray drive the iterator after the last SPI, as the iterator
>  	 * has exhausted the sequentially-allocated INTID space.
>  	 */
> -	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS - 1)) {
> +	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS)) {
>  		if (iter->lpi_idx < iter->nr_lpis)
>  		    xa_find_after(&dist->lpi_xa, &iter->intid,

Just noticed that it's wrong to increase intid before xa_find_after(),
which would break the LPI case. Let me have a think...

Zenghui
