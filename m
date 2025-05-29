Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF23F4C9D
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 13:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748523671; cv=none; b=Dst7sgR1F2i/yZQafwbcybIx1LzMZC4uCrrsoJdYM2ZF8e+ldFm81Xeujz0EE6HNs4OsYL5XFCGxVu6X52kJgpUG97iZ82+GRS2fpS+XvVrqJoWHCBHqrvqvEffEFd9GPPyUqJamzhBDEtgrYJwLjGMf1o95LjmxquuK9K6XG0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748523671; c=relaxed/simple;
	bh=GSt+uxdfVKdpALCS8/HHvtKAhq8gGDFjchLCHCDqiJY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=uIQwh6rKLIxJdkgb4eTm8BKcr8eIHrPrG2SQVvxjfpUuGWJtLLI8idV/sQ4+YjQbsfhWMi0DlXkwPkqESCwql8KAujEXO84J0xqNs+OmouYsLH1sRXZ5NSDIUQLB3/xy/u+e14Z/y7NfM+7BcGfjJnYQTTefzUeCFRvX3Inm584=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4b7RK41q27zvRpQ;
	Thu, 29 May 2025 20:59:20 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E3131402EB;
	Thu, 29 May 2025 21:01:06 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 29 May 2025 21:01:05 +0800
Subject: Re: [bug report] KVM: arm64: vgic-its: Add debugfs interface to
 expose ITS tables
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: Jing Zhang <jingzhangos@google.com>, <kvmarm@lists.linux.dev>
References: <aDBylI1YnjPatAbr@stanley.mountain>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <220ce0f4-afa6-09e3-a05b-a3ba1ebb61be@huawei.com>
Date: Thu, 29 May 2025 21:01:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aDBylI1YnjPatAbr@stanley.mountain>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk200017.china.huawei.com (7.202.194.83)

Hi Dan,

On 2025/5/23 21:05, Dan Carpenter wrote:
> Hello Jing Zhang,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> Commit 30deb51a677b ("KVM: arm64: vgic-its: Add debugfs interface to
> expose ITS tables") from Feb 20, 2025, leads to the following Smatch
> complaint:
> 
>     arch/arm64/kvm/vgic/vgic-debug.c:501 vgic_its_debug_show()
>     warn: variable dereferenced before check 'ite' (see line 493)
> 
> arch/arm64/kvm/vgic/vgic-debug.c
>    492	
>    493		if (list_is_first(&ite->ite_list, &dev->itt_head)) {
>                                    ^^^^^^^^^^^^^
> This dereferences "ite"

could be a NULL pointer dereference if, e.g., *no* interrupt has been
mapped into an ITE (associated with this device).

> 
>    494			seq_printf(s, "\n");
>    495			seq_printf(s, "Device ID: 0x%x, Event ID Range: [0 - %llu]\n",
>    496				   dev->device_id, BIT_ULL(dev->num_eventid_bits) - 1);
>    497			seq_printf(s, "EVENT_ID    INTID  HWINTID   TARGET   COL_ID HW\n");
>    498			seq_printf(s, "-----------------------------------------------\n");
>    499		}
>    500	
>    501		if (ite && ite->irq && ite->collection) {
>                     ^^^
> So this check is too late.

So this definitely needs to be fixed. Thanks for the report!

Zenghui
