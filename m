Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200FC1879
	for <kvmarm@lists.linux.dev>; Mon,  8 Jul 2024 02:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720404133; cv=none; b=eLVdQfIjiMAtTyCD61p48wYJiYhq02Rldlzw3CASaB6YGlKxxWtTBQ6Seqa1J+hYkl3L/rdFqJOwQkO9ApIrnQKlarW9kp3NtPvtFs5r+IZ1g0khGcA9wbLts3i+noa0BXfPo0hYK3L4Y1vUbyW/H+bKWvh89wVSuEk/bsuPJo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720404133; c=relaxed/simple;
	bh=UZDZrlSP7/QdDQHoliOTVBazrZJQYxlDlAH1qse8axQ=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Yz1eHHm1JZoJ5gMCpHqWEmGmJywt1W2tznqsT6se/1WLNb7fzRA2zuuDMBWAduEItZL6DEUtrdL2++aWXYOACOEjBfoRavj9EaLGNPilB/9H+Lhry6PysDVoBT32Lc5mKMPXGIGaCgw+oKVnFM51XFElknm75cwdDQchR6Yd30o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WHS294lFQzQkl2;
	Mon,  8 Jul 2024 09:58:09 +0800 (CST)
Received: from kwepemd500014.china.huawei.com (unknown [7.221.188.63])
	by mail.maildlp.com (Postfix) with ESMTPS id D85AB18006C;
	Mon,  8 Jul 2024 10:02:02 +0800 (CST)
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemd500014.china.huawei.com (7.221.188.63) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 8 Jul 2024 10:02:02 +0800
Subject: Re: [PATCH 0/3] irqchip/gic-v4: Fix VMAPP/VMOVP races
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "guoyang (C)" <guoyang2@huawei.com>,
	jiangkunkun <jiangkunkun@huawei.com>, wangwudi <wangwudi@hisilicon.com>
References: <20240705093155.871070-1-maz@kernel.org>
From: Tangnianyao <tangnianyao@huawei.com>
Message-ID: <ce1c797f-1b00-2f14-de1d-b3524acf3c1f@huawei.com>
Date: Mon, 8 Jul 2024 10:02:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240705093155.871070-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd500014.china.huawei.com (7.221.188.63)



On 7/5/2024 17:31, Marc Zyngier wrote:
> In 20240701072305.4129823-1-tangnianyao@huawei.com, Nianyao reports
> a number of possible races that can trigger on GICv4 implementations
> using the ITSList feature.
>
> These races involve concurrent VMOVP and VMAPP, the former happening
> on vcpu load, while the latter is triggered on the first device being
> MAPTI'd on a given ITS for this particular guest.
>
> The main issue is that we want to establish the affinity at VMAPP time,
> while vcpu_load wants to set the affinity where the vcpu actually runs.
> Lock ordering constraints mean that we can't lock the VPE on VMAPP,
> so things are modified without any lock. What could possibly go wrong?
>
> THe fix is a bit involved, and relies on 3 things:
>
> - Making sure that the initial affinity of a VPE is fixed at activate
>   time, which is done early in the life of the vcpup, before it can run.
>
> - Add a per-VM lock that can be taken instead of the global vmovp_lock,
>   paving the way for a more manageable lock order.
>
> - Take the per-VPE lock whenever modifying the VPE affinity, as expected
>   everywhere else in the code.
>
> With that, VMAPP and VMOVP can now run concurrently and still lead to
> sensible results.
>
> Marc Zyngier (3):
>   irqchip/gic-v4: Always configure affinity on VPE activation
>   irqchip/gic-v4: Substitute vmovp_lock for a per-VM lock
>   irqchip/gic-v4: Make sure a VPE is locked when VMAPP is issued
>
>  drivers/irqchip/irq-gic-v3-its.c   | 48 ++++++++++++++----------------
>  include/linux/irqchip/arm-gic-v4.h |  8 +++++
>  2 files changed, 30 insertions(+), 26 deletions(-)
>

I've tested this patch series. It works.

Tested-by: Nianyao Tang <tangnianyao@huawei.com>
