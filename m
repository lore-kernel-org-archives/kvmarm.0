Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0185D42AA2
	for <kvmarm@lists.linux.dev>; Thu,  5 Sep 2024 03:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725505974; cv=none; b=d6PKHqHcSkcIupUaiONicYbqKR40fAfLid/ApNdabRjDK19m18QhG2kxPKTEJeartPmrze5fcJvqfGrt6V5pEP4NZy8APxGx8nzq7mdyKYhlG17+dHUgZ5bbD7Ox27//Lv8fxTsop50P02ZiPc081lvE8X+SQlAHKHMhHyTlysw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725505974; c=relaxed/simple;
	bh=nlq6tis2udYlSUQbvpvE1LGYV6izF24lO62tQql4nXQ=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HHWCWBT21hLSfySo0XAWox+miN5LPkubnML16AOUmB+VLj5R5K8HQZvGGC/bUDutCsSpeVmsNItW1fSPlCaorUXtA1VacsaPHfAkF47u7ojqoYpbYkJpJZd7ZjE7i8SDZ4sxJjyFIBDi0mbuh7N7B09+LYYA9+7LjzK2T4lEvi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wzkth4hsMz1j84T;
	Thu,  5 Sep 2024 11:12:28 +0800 (CST)
Received: from kwepemd500014.china.huawei.com (unknown [7.221.188.63])
	by mail.maildlp.com (Postfix) with ESMTPS id AB7AF1A016C;
	Thu,  5 Sep 2024 11:12:49 +0800 (CST)
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemd500014.china.huawei.com (7.221.188.63) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 5 Sep 2024 11:12:49 +0800
Subject: Re: Question on get random long worse in VM than on host
To: Ard Biesheuvel <ardb@kernel.org>
CC: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
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
From: Tangnianyao <tangnianyao@huawei.com>
Message-ID: <bdf1471e-56aa-893c-0336-81828c8cb5c1@huawei.com>
Date: Thu, 5 Sep 2024 11:12:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGyJSwD=ok=Ag11mMh3d6onQkN0b_-iVwVDdyrwk5rj6Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemd500014.china.huawei.com (7.221.188.63)



On 9/3/2024 23:04, Ard Biesheuvel wrote:
> On Tue, 3 Sept 2024 at 03:39, Tangnianyao <tangnianyao@huawei.com> wrote:
>>
>>
>> On 9/3/2024 5:26, Ard Biesheuvel wrote:
>>> On Sat, 31 Aug 2024 at 10:14, Marc Zyngier <maz@kernel.org> wrote:
>>>> On Sat, 31 Aug 2024 08:56:23 +0100,
>>>> Ard Biesheuvel <ardb@kernel.org> wrote:
>>>>> As for RNDR/RNDRRS vs TRNG: the former is not a raw entropy source, it
>>>>> is a DRBG (or CSPRNG) which provides cryptographically secure random
>>>>> numbers whose security strength is limited by the size of the seed.
>>>>> TRNG does not have this limitation in principle, although non-p KVM
>>>>> happily seeds it from the kernel's entropy pool, which has the same
>>>>> limitation in practice.
>>>> Is that something we should address? I assume that this has an impact
>>>> on the quality of the provided random numbers?
>>>>
>>> To be honest, I personally find the distinction rather theoretical - I
>>> think it will be mostly the FIPS fetishists who may object to the
>>> seeding of a DRBG of security strength 'n' from the kernel entropy
>>> pool without proving that the sample has 'n' bits of entropy.
>>>
>>> For pKVM, the concern was that the untrusted host could observe and
>>> manipulate the entropy and therefore the protected guest's entropy
>>> source, which is why the hypervisor relays TRNG SMCCC calls directly
>>> to the secure firmware in that case. The quality of the entropy was
>>> never a concern here.
>>>
>>> .
>>>
>> Thank you for reply.
>>
>> In case that EL3 firmware not support SMCCC TRNG, host and guest can only
>> get randomness from DRBG-based RNDRRS, right?
>>
> There are other, non-architected ways too to get entropy and/or
> randomness. There are many hardware random number generator
> peripherals that the OS can drive directly, and there are vendor
> specific EL3 services too that a system might use.
>
> RNDR/RNDRRS does not exist yet in practical terms - there are very few
> SOCs that actually implement that used in the field.
>
>> In this case, guest get DRBG-based randomness via HVC and host, but the
>> randomness returned by host kvm is not really backed by EL3 SMCCC TRNG,
>> and actually get from DRBG-based RNDRRS.
>> Is this hvc process is redundancy?
>>
> I don't understand this question. How the host obtains its entropy
> and/or randomness and how the guest does it are completely separate
> concerns.
>
> .
>

Process is different between host and guest in arch/arm64, arch_get_random_seed_longs.
(1) In host , smccc_trng_available is false, it get randomness from RNDRRS.

(2) In guest, smccc_trng_available is true, because kvm emulate it. Guest use smccc trng
and hvc, and trap to host kvm. Then in host call stack:
kvm_smccc_call_handler
kvm_trng_call
kvm_trng_do_rnd
get_random_long
...
arch_get_random_seed_longs

host get randomness as (1) and return random u64 to guest.
So the randomness guest finally get is from RNDRRS too.
Can we let guest get randomness directly from RNDRRS, not using hvc first?
The process for guest like (1):
1) kvm not emulated smccc trng for guest
2) guest check smccc trng, and get smccc_trng_available=false
3) guest get randomness from RNDRRS

Thanks.





