Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8911AC230
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718890359; cv=none; b=Zt6xrI3ywm92DcqOgSV5x0CWD+7cFULJ2qKp0djaGPvD/RBzlRRZTwxi9b71Ah/QkaF5Wj4gRW4f98+NErYn+RLqWLnOGs19WLPx4dwZHfx+GFuvoBBhehffxRj88dj1Jqe/zxuZ2ibfPVUxe2iwUFBhKAWMlTIzkl1iDnlNZV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718890359; c=relaxed/simple;
	bh=7w0hWpjx910CIu7mERo9lzB+qj3IfVuDqIkUujkGc2w=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BPZ8DO9xeZCfHZTUYhGldw+gKEbrj59ejmw3hUuBzlaiuZ2snsPQkplg4mKl5u/mgiC+eLGGqhhl5/77e5q7VZSdn8v3QHN69C5EaBCC5n4obOJ2JnW4vHushmbbOp2MUsukIhkMiqvcdcTKn2N4rOnPcvUL723vE1A+ds//vvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4W4hBn2TTkz1N8NV;
	Thu, 20 Jun 2024 21:28:17 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id A9F11180064;
	Thu, 20 Jun 2024 21:32:33 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 21:32:32 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-its: clear dte when mapd unmaps a device
To: Eric Auger <eauger@redhat.com>, Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <wanghaibin.wang@huawei.com>,
	<lishusen2@huawei.com>
References: <20240613093811.710-1-jiangkunkun@huawei.com>
 <86v82ckimh.wl-maz@kernel.org>
 <8f9d74fc-f9d9-43ac-a387-91ff804cfaf1@redhat.com>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <480900e7-4894-4fc9-5671-f29523f2672a@huawei.com>
Date: Thu, 20 Jun 2024 21:32:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8f9d74fc-f9d9-43ac-a387-91ff804cfaf1@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Eric,

On 2024/6/19 1:18, Eric Auger wrote:
>> Also, is the device table the only one that is subject to this
>> 'reload' problem? How about the Collection table?
> The collection table is not indexed by the collection ID and when saving
> we end up writing an invalid dummy entry to close the recording. So I
> don't think we have the same problem there.
I'm a little confused here. In the current Linux, there is no implementation
of mapc unmaps a cte. But should this scenario be considered in vgic-its?
> For ITT I think we have the same issue on restore because the restore
> scans the table until it gets a first valid entry and then chain on next
> item. If we have stale entries this looks like the same issue.
Thanks for your reply. I added a patch to fix it.
https://lore.kernel.org/kvmarm/20240620130650.1279-4-jiangkunkun@huawei.com/

Thanks,
Kunkun Jiang
