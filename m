Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9850481B7
	for <kvmarm@lists.linux.dev>; Fri,  6 Sep 2024 03:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725594149; cv=none; b=ItYYVnUlKyygIsWP7BzOBj7/MxA3CODiizWmvU31f/cjR4TXGmnk710swd1xjrnFItGNhsbzsHjKkqxNWKrqPrhUWI/d9H0a6yV8/5Sh8o5JQGocAXay+uOMKcSG9VpPoBZyP6qKVZ1oiN5jp1u+oMyaAL9e7PaWW5e1Fmav2wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725594149; c=relaxed/simple;
	bh=67agWqRSWlpl7/YZQPYu04e7zBkj4X10k7JrAXCAYwI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=e6nRENKUlyUEdZyQ3sq7iNg/u+a3O2rfJP/OOBouldo+z9Sw7toUKr7ciXrdtGzaMn+/1UieR+EYDCH6kUXuCIdmOX3RSP5GQ16z7nXekbiUYcaUW3velOQ2V8NH0Qks7I/Syv3ALSBnwjbUwBoRfToDM5ipihIAgk6aq1aRN6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4X0MQm2T7Zz1HJFX;
	Fri,  6 Sep 2024 11:38:56 +0800 (CST)
Received: from kwepemd500014.china.huawei.com (unknown [7.221.188.63])
	by mail.maildlp.com (Postfix) with ESMTPS id A9A071A0170;
	Fri,  6 Sep 2024 11:42:25 +0800 (CST)
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemd500014.china.huawei.com (7.221.188.63) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 6 Sep 2024 11:42:24 +0800
Subject: Re: Question on get random long worse in VM than on host
To: Marc Zyngier <maz@kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
	<oliver.upton@linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <kvmarm@lists.linux.dev>, "guoyang (C)"
	<guoyang2@huawei.com>
References: <214e37e9-7aba-1e61-f63f-85cb10c9a878@huawei.com>
 <86zfotuoio.wl-maz@kernel.org>
 <CAMj1kXGocnZPe4EfzsB6xd2QZacp-a45R5f5f6FDpVtVEXCcGQ@mail.gmail.com>
 <86y14dun1f.wl-maz@kernel.org>
 <CAMj1kXF3JrDs=xvRmvTxS9du1F-gjSVe5qVZrPO5JLT5ho0riA@mail.gmail.com>
 <f39ccb21-cc28-b878-bf5e-e81e378a299e@huawei.com>
 <CAMj1kXGyJSwD=ok=Ag11mMh3d6onQkN0b_-iVwVDdyrwk5rj6Q@mail.gmail.com>
 <bdf1471e-56aa-893c-0336-81828c8cb5c1@huawei.com>
 <86jzfqv7iq.wl-maz@kernel.org>
From: Tangnianyao <tangnianyao@huawei.com>
Message-ID: <7530d60c-7419-fa86-57c1-9f52dc479598@huawei.com>
Date: Fri, 6 Sep 2024 11:42:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86jzfqv7iq.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd500014.china.huawei.com (7.221.188.63)



On 9/5/2024 16:17, Marc Zyngier wrote:
> [...]
>> Process is different between host and guest in arch/arm64, arch_get_random_seed_longs.
>> (1) In host , smccc_trng_available is false, it get randomness from RNDRRS.
>>
>> (2) In guest, smccc_trng_available is true, because kvm emulate it. Guest use smccc trng
>> and hvc, and trap to host kvm. Then in host call stack:
>> kvm_smccc_call_handler
>> kvm_trng_call
>> kvm_trng_do_rnd
>> get_random_long
>> ...
>> arch_get_random_seed_longs
>>
>> host get randomness as (1) and return random u64 to guest.
>> So the randomness guest finally get is from RNDRRS too.
>> Can we let guest get randomness directly from RNDRRS, not using hvc first?
>> The process for guest like (1):
>> 1) kvm not emulated smccc trng for guest
>> 2) guest check smccc trng, and get smccc_trng_available=false
>> 3) guest get randomness from RNDRRS
> I think I gave you the answer to this in my first reply [1].
>
> 	M.
>
> [1] https://lore.kernel.org/all/86zfotuoio.wl-maz@kernel.org/
>

Thank you Marc, I've missed this email.
Userspace should control  whether expose TRNG to guest.

Thanks.
Nianyao

