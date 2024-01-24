Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2FE17BA0
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 08:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706086483; cv=none; b=RravHBmTKQLAX8gY+eUBpIIyLjEEzhpG/BsFk8dAHuwHNWtQL4Wr7tbKn/JZa4CoMYC6HJKk7Z9Hjrfbh0EwZHOeZWU/rJqEmUAW8IemC5pw+OOjOGxrVuiUWIDfTGV/VA/A2iSppEaduDJ6f4QoaIp311NsMmBRCta0N6Y6Hxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706086483; c=relaxed/simple;
	bh=RKcY6o2EmT2TldIJVMSArsNWb0Cj+dV+4YmEBBgx3cs=;
	h=From:Subject:To:CC:Message-ID:Date:MIME-Version:Content-Type; b=k+HSBavb5ZFYyeyM4NUx74zuQZZCTDa7B0FM25CejTczNLPUR7XIFQwBgIAxDjYQ2HpDWU8QyNPXKVjWPeC3WVVdEaawneQPQfFgQkAGW41aNhNAYrK1E+otXXFApniNK2iYr9uRbzn2Q0ksuKDKDKj81RBsQXogJy9Zqtu+UgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4TKd6J5zdXzNlPK;
	Wed, 24 Jan 2024 16:53:44 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 986E218005E;
	Wed, 24 Jan 2024 16:54:37 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Jan 2024 16:54:36 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
Subject: [bug report] GICv4.1: doorbell interrupts will be lost in a corner
 case
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
CC: moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, "wanghaibin.wang@huawei.com"
	<wanghaibin.wang@huawei.com>
Message-ID: <4edc4d02-5c0b-a2e5-897a-7e60fbb0f3e3@huawei.com>
Date: Wed, 24 Jan 2024 16:54:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi all，

In chapter 8.5 ("Doorbells") of the GIC spec, the affinity of
doorbell interrupt is described like this:

> Doorbell interrupts target the Redistributor the vPE is
> currently mapped to, based on the previous VMAPP or VMOVP
> command for the vPE.
The doorbell interrupt here should refer to all types of
doorbell interrupt, right?

When GICv4.1 is enabled, the doorbell interrupt will be
truned on only when kvm handles WFI exit. There is a
corner case where will lost doorbell interrupt:
1. doorbell interrupt enabled
2. the cpu which the vPE is mapped to is manually offline
   through 'echo 0 > /sys/device/system/cpu/cpuX/online'
3. According to the description of chapter 8.5 ("Doorbells"),
   the doorbell interrupt coming at this time will still
   be sent to the offline cpu.Then the interrupt will be
   lost.

Should we add a cpu offline callback to handle the
doorbell interrupt mapped to this cpu?

If you have other solutions, please post them for discussion.

Looking forward to your reply.

Thanks,
Kunkun Jiang

