Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723A21CCECB
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 01:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725327575; cv=none; b=OwO0pQusZVYsQqi84Oi/yCLwYRz03ohHg7P/0jaxXCFOcg9sg0qhuFFXt969nk9AbPmNjd49eggB6Ai6zzowp4WcRe17k4u8/YxtjhJM7B5ewoecsYvcKA8Gg04YMLjpNPmbOn+hI/vwlzyhXUqowyxD7h/pSIeApoXbeq60hAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725327575; c=relaxed/simple;
	bh=LL6M0VGps9bxHr0h0YDPbvCH572z7TJmICMta0V0Rcw=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NGkay4EePCqL0BT8o6HbakqIoinOifBxTval9zmoVfN9IbXz9ZNKW/2EKDZyLPMW+oPGmRI/bf+Gi/94+vKi39XsPeHoCnwx0KmjqRBrxHD4vJvcw1EExtQI91OP80HZ6X8vq+aWGX4JqtE1eIiAT8HI327TcTLG2nb1WHmJ/mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WySvv17xsz1j7wn;
	Tue,  3 Sep 2024 09:39:07 +0800 (CST)
Received: from kwepemd500014.china.huawei.com (unknown [7.221.188.63])
	by mail.maildlp.com (Postfix) with ESMTPS id 82E511A0188;
	Tue,  3 Sep 2024 09:39:25 +0800 (CST)
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemd500014.china.huawei.com (7.221.188.63) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 3 Sep 2024 09:39:24 +0800
Subject: Re: Question on get random long worse in VM than on host
To: Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>
CC: Will Deacon <will@kernel.org>, <oliver.upton@linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, "guoyang (C)" <guoyang2@huawei.com>
References: <214e37e9-7aba-1e61-f63f-85cb10c9a878@huawei.com>
 <86zfotuoio.wl-maz@kernel.org>
 <CAMj1kXGocnZPe4EfzsB6xd2QZacp-a45R5f5f6FDpVtVEXCcGQ@mail.gmail.com>
 <86y14dun1f.wl-maz@kernel.org>
 <CAMj1kXF3JrDs=xvRmvTxS9du1F-gjSVe5qVZrPO5JLT5ho0riA@mail.gmail.com>
From: Tangnianyao <tangnianyao@huawei.com>
Message-ID: <f39ccb21-cc28-b878-bf5e-e81e378a299e@huawei.com>
Date: Tue, 3 Sep 2024 09:39:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAMj1kXF3JrDs=xvRmvTxS9du1F-gjSVe5qVZrPO5JLT5ho0riA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd500014.china.huawei.com (7.221.188.63)



On 9/3/2024 5:26, Ard Biesheuvel wrote:
> On Sat, 31 Aug 2024 at 10:14, Marc Zyngier <maz@kernel.org> wrote:
>> On Sat, 31 Aug 2024 08:56:23 +0100,
>> Ard Biesheuvel <ardb@kernel.org> wrote:
>>> As for RNDR/RNDRRS vs TRNG: the former is not a raw entropy source, it
>>> is a DRBG (or CSPRNG) which provides cryptographically secure random
>>> numbers whose security strength is limited by the size of the seed.
>>> TRNG does not have this limitation in principle, although non-p KVM
>>> happily seeds it from the kernel's entropy pool, which has the same
>>> limitation in practice.
>> Is that something we should address? I assume that this has an impact
>> on the quality of the provided random numbers?
>>
> To be honest, I personally find the distinction rather theoretical - I
> think it will be mostly the FIPS fetishists who may object to the
> seeding of a DRBG of security strength 'n' from the kernel entropy
> pool without proving that the sample has 'n' bits of entropy.
>
> For pKVM, the concern was that the untrusted host could observe and
> manipulate the entropy and therefore the protected guest's entropy
> source, which is why the hypervisor relays TRNG SMCCC calls directly
> to the secure firmware in that case. The quality of the entropy was
> never a concern here.
>
> .
>

Thank you for reply.

In case that EL3 firmware not support SMCCC TRNG, host and guest can only
get randomness from DRBG-based RNDRRS, right?

In this case, guest get DRBG-based randomness via HVC and host, but the
randomness returned by host kvm is not really backed by EL3 SMCCC TRNG,
and actually get from DRBG-based RNDRRS.
Is this hvc process is redundancy?

Thanks.
