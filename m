Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBE52C19E
	for <kvmarm@lists.linux.dev>; Mon, 18 Mar 2024 09:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710754438; cv=none; b=OIRaA3pYoWf6U8a1YeSsZK6yeO7MeSAN6jRq9uvtOKnW9y9BEJwHw6SyFNtki622e23+X8KzP/c5QU2lkam9SHCZtKwPnpI+WlD7bRCoeyBlLOt4q9JdB9yf+9d6UVFOfYTLWr7uofNAhb2Zu8Htlju7OSA+aU7PUwj/wK3fhy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710754438; c=relaxed/simple;
	bh=tKN0NbIMQSCIWJiX8+5RRW98gy1cwfnl9Kh+moGMtU4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DOQ1ws/hsyJJ7e5NNOaPP0ruW4DPpgQCz4vvyHGV/i7v01kQeh1rD0DQmKxjrPNCU6UZP22OaWo8927/QnOQf3ZgWpW56O33jS3+oEamYz4IDgH9MsFTXx+awDx3XjN1AFmiwZJgnNZT2AjiAFC3P+viMGrAoG3p3AqWyh5x33E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TyqPZ28Tdz1xrd6;
	Mon, 18 Mar 2024 17:32:02 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id E8E441A016C;
	Mon, 18 Mar 2024 17:33:52 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 18 Mar 2024 17:33:51 +0800
Subject: Re: [PATCH] Change back kvm fault condition to translation
To: Marc Zyngier <maz@kernel.org>
CC: Wujie Duan <wjduan@linx-info.com>, Ard Biesheuvel <ardb@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<kvmarm@lists.linux.dev>
References: <20240318053708.192770-1-wjduan@linx-info.com>
 <865xxj29n8.wl-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ec589d2d-db95-3e98-6c35-0c4a2232013d@huawei.com>
Date: Mon, 18 Mar 2024 17:33:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <865xxj29n8.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/3/18 17:04, Marc Zyngier wrote:
> [+Ard]
> 
> On Mon, 18 Mar 2024 05:37:08 +0000,
> Wujie Duan <wjduan@linx-info.com> wrote:
>>
>> Condition should be esr_fsc_is_translation_fault
> 
> Could you please write a full commit message, and not something that
> requires the reviewer to reverse-engineer the issue? Description of
> the problem, the commit it fixes, a Cc stable tag, this sort of
> things.

And also Cc the kvmarm list, a proper patch subject (starting with
"KVM: arm64:").

> Otherwise, this looks embarrassingly correct. Ard?

I tend to agree. ;-)

Zenghui
