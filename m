Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAC22C08C5
	for <kvmarm@lists.linux.dev>; Sat, 25 Oct 2025 10:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761386792; cv=none; b=JoxWMGhgILgE7O2oisAmwTBKrdLCTbApJoxgRP0WHFNECBdKbmiBp3fAvknMRiQsoorr4UkrFc+q0AFAzfCxrWKEhA7ri3DJgdYmQX9TeXD9qIS+lVtVawHP9e1ddrhEPazzn9OZSDy7pGUZRbf1qEkQTHz/sEhntFimOcwXPeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761386792; c=relaxed/simple;
	bh=AuWPnxtiA7WJZGtpuWoJMkrMCtUsDktvnjiWFqDASX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nkk/kxdbfJ6YikbarKJjmqzoGPHgpxKCyNt2JBrI7H1neAy5zEpjEicNYV5NlCokEsJly4M90H3+tjVQDH/JoXvMnPb4sCDv/ynmcRbjpa5mCjGtMnoAYfj6H/qQndthHw/LeEF4GpCmOtI1WkX5hF6mAqM2tPnIx3e5x2ZlnLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4ctwPZ1W7Tz1T4KD;
	Sat, 25 Oct 2025 18:05:22 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 90803180B4A;
	Sat, 25 Oct 2025 18:06:20 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:06:20 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:06:19 +0800
Message-ID: <752915f0-1085-b32e-f94c-c6c68dfa6cd4@hisilicon.com>
Date: Sat, 25 Oct 2025 18:06:19 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 7/7] kselftest/arm64: Add HWCAP test for FEAT_{LS64,
 LS64_V}
Content-Language: en-US
To: Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	"Zhou Wang" <wangzhou1@hisilicon.com>
References: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
 <20251024090819.4097819-8-wangzhou1@hisilicon.com>
 <e40ce220-e857-4ecf-985b-40407f99fcb3@app.fastmail.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <e40ce220-e857-4ecf-985b-40407f99fcb3@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/10/25 0:18, Arnd Bergmann wrote:
> On Fri, Oct 24, 2025, at 11:08, Zhou Wang wrote:
> 
>> +static void ls64_sigill(void)
>> +{
>> +	struct sigaction ign, old;
>> +	char src[64] __aligned(64) = { 1 };
>> +
>> +	/*
>> +	 * LS64, LS64_V require target memory to be Device/Non-cacheable (if
>> +	 * FEAT_LS64WB not supported) and the completer supports these
>> +	 * instructions, otherwise we'll receive a SIGBUS. Since we are only
>> +	 * testing the ABI here, so just ignore the SIGBUS and see if we can
>> +	 * execute the instructions without receiving a SIGILL. Restore the
>> +	 * handler of SIGBUS after this test.
>> +	 */
>> +	ign.sa_sigaction = ignore_signal;
>> +	ign.sa_flags = SA_SIGINFO | SA_RESTART;
>> +	sigemptyset(&ign.sa_mask);
>> +	sigaction(SIGBUS, &ign, &old);
>> +
>> +	register void *xn asm ("x8") = src;
>> +	register u64 xt_1 asm ("x0");
>> +	register u64 __maybe_unused xt_2 asm ("x1");
>> +	register u64 __maybe_unused xt_3 asm ("x2");
>> +	register u64 __maybe_unused xt_4 asm ("x3");
>> +	register u64 __maybe_unused xt_5 asm ("x4");
>> +	register u64 __maybe_unused xt_6 asm ("x5");
>> +	register u64 __maybe_unused xt_7 asm ("x6");
>> +	register u64 __maybe_unused xt_8 asm ("x7");
>> +
>> +	/* LD64B x0, [x8] */
>> +	asm volatile(".inst 0xf83fd100" : "=r" (xt_1) : "r" (xn));
> 
> Relying on the __maybe_unused register declaration seems a little
> fragile, can you change this so that the inline asm specifies
> all of the registers correctly as input/output arguments?

Seems we can remove xt_2 ... xt8, but add x1 ... x7 to asm clobber list,
something like:

    asm volatile(".inst 0xf83fd100" : "=r" (xt_1) : "r" (xn)
                 : "x1", "x2", "x3", "x4", "x5", "x6", "x7");

>> +static void ls64_v_sigill(void)
>> +{
>> +	struct sigaction ign, old;
>> +	char dst[64] __aligned(64);
>> +
>> +	/* See comment in ls64_sigill() */
>> +	ign.sa_sigaction = ignore_signal;
>> +	ign.sa_flags = SA_SIGINFO | SA_RESTART;
>> +	sigemptyset(&ign.sa_mask);
>> +	sigaction(SIGBUS, &ign, &old);
>> +
>> +	register void *xn asm ("x8") = dst;
>> +	register u64 xt_1 asm ("x0") = 1;
>> +	register u64 __maybe_unused xt_2 asm ("x1") = 2;
>> +	register u64 __maybe_unused xt_3 asm ("x2") = 3;
>> +	register u64 __maybe_unused xt_4 asm ("x3") = 4;
>> +	register u64 __maybe_unused xt_5 asm ("x4") = 5;
>> +	register u64 __maybe_unused xt_6 asm ("x5") = 6;
>> +	register u64 __maybe_unused xt_7 asm ("x6") = 7;
>> +	register u64 __maybe_unused xt_8 asm ("x7") = 8;
>> +	register u64 st   asm ("x9");
>> +
>> +	/* ST64BV x9, x0, [x8] */
>> +	asm volatile(".inst 0xf829b100" : "=r" (st) : "r" (xt_1), "r" (xn));
>> +
>> +	sigaction(SIGBUS, &old, NULL);
> 
> Is ST64BV expected to cause SIGBUS here, or should it return the
> 0xffffffffffffffff output to indicate an unsupported memory area?

I think it should return 0xffffffffffffffff without an exception,
will modify above test codes in next version.

Best,
Zhou

> 
>      Arnd
> .
