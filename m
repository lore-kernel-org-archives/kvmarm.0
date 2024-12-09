Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C70A54918
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 02:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733710854; cv=none; b=YU6gIx8R7m35XY/vQxI3DI/LDKicj7vf/XOTvMOvoYF8y6AJy/19EyfhxkrRxREyiFSEgfdjqqk4HV8OJQcxImrI5U16bcSDHY8UrnkwZ0LZMD4CQTikYzNFFDZsQTUW0teZZqqZz2dhYa+oWjiFo2MWHtHrNXDX7vPfXnX2Sis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733710854; c=relaxed/simple;
	bh=7JscrbicuuLsVaCOffYdokD9BSe1ENYelILYWub8yNY=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DFdRaqWf+XCXEae36v3qx5GHVOMtD7xFOIHz4Bzxsm+JtwFkDj0lCDDxyvLu1ru1e69DL2JMPK2/R2AvVb19SzAURAybB1wSrNg84fkxTmEo01aVugI9at48WLT3fAUaxN7r26xt0Pkn0yoWvgnUNASNvzrmtp7709arwVm06to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y65Dt3Sm9z1JDw9
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 10:20:30 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 16BB51A0188
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 10:20:43 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 9 Dec 2024 10:20:42 +0800
Subject: Re: subscribe mailing list to learn recent kvm development, not robot
To: =?UTF-8?B?5p2O56GV?= <shilishuoya@gmail.com>
References: <CADTb_0MHZnoRLdCRp8VgCPGLmOOeOP9gd1Xtfr-KQ4UN3CMZmg@mail.gmail.com>
CC: <kvmarm@lists.linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5952b96e-c64a-2a90-97f1-63923b16e559@huawei.com>
Date: Mon, 9 Dec 2024 10:20:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CADTb_0MHZnoRLdCRp8VgCPGLmOOeOP9gd1Xtfr-KQ4UN3CMZmg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemk200017.china.huawei.com (7.202.194.83)

On 2024/12/8 17:11, 李硕 wrote:
> subscribe kvmarm shilishuoya@gmail.com

To subscribe the list, you need to send a email to
<kvmarm+subscribe@lists.linux.dev>, instead of the list itself. Look
at [1] for more information.

[1] https://lore.kernel.org/kvmarm/86edvbg3q7.wl-maz@kernel.org

Thanks,
Zenghui
