Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7407D2DECCB
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 11:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762254831; cv=none; b=QXeZ5Fuz+JFb+Lc2amZwHCMKnsFnbjeq23F1XiQdU4VxhkM1gSwrSZ1eh/tDhYSxo/1v6eDAvHj0cweyJ5jmFtQRxtRG3B0UdxrEixs0ZJStzapCjiMdpxqvIa3ipeBYiROHtnMrZbQSCgP+K6Dp3pta+gQdmnJfii2ENAQmHBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762254831; c=relaxed/simple;
	bh=4nVBl5r6hmuhvvbq9MpULBbT9ItrCt4YCDr9efMVybE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=eyRG0NN8BmdXnDI3D595Pjv9eQ+olcaZ3WEW5rfDjZTcV0EFLhwY+4Ro3q5kDzbIebf/WgAp1bYFtuLnjgahPctN1PlD5LC+ovJvrcx2+k4kq/9j5m3mteeM5cuCjS3DZLrMV8aF1OEobUt6ZgQZ9bkyhd0P8W1qrjEy6nPB2Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=zbnfA3Re; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="zbnfA3Re"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4nVBl5r6hmuhvvbq9MpULBbT9ItrCt4YCDr9efMVybE=;
	b=zbnfA3RezbrDNkzJJdE7pwbmng3YMVGS6Q5geiHWXqZ1ZZAgTPrgHz4KoS+Dys7sTiIwETiE4
	xIrEQ0x0B8NQ7+PNoNfBrnvPUrZXWlbVO/DkP0cZTQW2CKnXduyoyVVCdXp3EIWWfK+cpUfA5UX
	KJyEIVb/fmy0+I0Se2WiMKU=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4d15Q4535HzLlTr;
	Tue,  4 Nov 2025 19:12:12 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 06F0C1A016C;
	Tue,  4 Nov 2025 19:13:47 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 19:13:46 +0800
Subject: Re: [PATCH 03/33] irqchip/apple-aic: Spit out ICH_MIDR_EL2 value on
 spurious vGIC MI
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvm@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Christoffer
 Dall <christoffer.dall@arm.com>, Volodymyr Babchuk
	<Volodymyr_Babchuk@epam.com>
References: <20251103165517.2960148-1-maz@kernel.org>
 <20251103165517.2960148-4-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4dfdc1da-5b5f-26be-f318-4a30ab0db1cc@huawei.com>
Date: Tue, 4 Nov 2025 19:13:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251103165517.2960148-4-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk200017.china.huawei.com (7.202.194.83)

Subject: s/ICH_MIDR_EL2/ICH_MISR_EL2/

Thanks,
Zenghui
