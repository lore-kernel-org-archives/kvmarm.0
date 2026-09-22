Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0EC5326D4
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 10:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072220; cv=none; b=dAexE8223Pi+rrKo6JcNgCMRL9Ss290rRMczTNqn21yN3w1w580TXQ5HkNWA9g/IVOil7cCHUoO+Hjf2p7M7Brqzr/qby7Qnj7/D11DH+OgYoUF5G2QkPG8ziBRmzO87fEPMay/1p3UCfI+OYMjOZu3qf/P/bBIqgtGzPJhxpSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072220; c=relaxed/simple;
	bh=yowkjDQZiCa1k53EvqaUcIWtcWp9zbgY0OAewgnoRPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WETcs/zo+mYulIzwyylX9Fkz8E37jCmSNYyHo/3VaFHowKSzrbP+MWVBl8qSzlZML8AC03n4l3n7UUbZ+hg2aM46ar1wbSPCZJq0g4750GUSw6D/WtAkQzwvYGb/Zk3t1kbYrvki/pSH5GkyOLoOwXLXUQyWI2k+4nt1Fe2JLbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hpwgS4KFZzRhXP;
	Tue, 22 Sep 2026 18:04:36 +0800 (CST)
Received: from kwepemk100011.china.huawei.com (unknown [7.202.194.59])
	by mail.maildlp.com (Postfix) with ESMTPS id E361B40561;
	Tue, 22 Sep 2026 18:16:37 +0800 (CST)
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemk100011.china.huawei.com (7.202.194.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 22 Sep 2026 18:16:37 +0800
Message-ID: <6975605e-6635-f3c6-39ee-8faaae6d9856@hisilicon.com>
Date: Tue, 22 Sep 2026 18:16:36 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC PATCH] KVM: arm64: Restrict CNTP_CVAL/CNTHP_CVAL save/reload
 when ptimer is used
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, Joey
 Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, <kvmarm@lists.linux.dev>, Nianyao Tang
	<tangnianyao@huawei.com>
References: <20260921111840.3000905-1-wangzhou1@hisilicon.com>
 <878q4u4u3a.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <878q4u4u3a.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk100011.china.huawei.com (7.202.194.59)

On 2026/9/21 21:22, Marc Zyngier wrote:
> On Mon, 21 Sep 2026 12:18:40 +0100,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> A guest's physical timer may be used in nested guest or directly used in
>> VHE mode. We can check above cases to avoid useless CNTP_CVAL/CNTHP_CVAL save
>> and reload.
> 
> Why useless? What cases?

I mean we do not use ptimer at least in current Linux kernel, however, for system
which has ECV_CNTPOFF capability, we have to handle related logic here.

So we can detect if ptimer is been used, if it is been used, then we run into the
related codes.

I am not familiar with the nested cases, so just not change related logic.

> 
>>
>> Use lazy detection to determine whether a non-nested VHE guest actually uses
>> the physical timer.
>>
>> timer_set_traps() initially traps CNTP_CTL_EL0 writes for non-nested guests.
>> On the first write that sets CNTP_CTL.ENABLE=1, the trap handler records
>> ptimer_used and clears the trap in CNTHCTL_EL2, allowing the guest direct
>> access thereafter.
> 
> I really don't want to go into these micro optimisation to paper over
> the bad state of the architecture.
> 
> The options are:
> 
> - Don't use any offset (offsets always set to 0), and there will not
>   be any trap

Do you mean that in non-nested case, we can make offset always be 0, so
related logic in __activate_traps/__deactivate_traps can be skipped?

> 
> - Use CNTPOFF, which will work just fine for an L1 guest, without
>   traps
> 
> - For nested guests, there is no solution that matches the
>   architecture (CNTPOFF doesn't nest), and you must trap.

I need more time to figure out how ptimer working in NV(both L1 and L2).

> 
> So where is the cost in your case?
> 
>>
>> A test result from KUT in HiSilicon HIP12 is:
>>
>>                     nopatch        patch
>>  hvc                758            624
>>  mmio_read_user     3647           3479
>>  mmio_read_vgic     949            817
>>  eoi                29             29
>>  ipi                2534           2302
>>  lpi                2684           2442
>>  timer_10ms         2393           2168
> 
> I don't know what these numbers are. There is no unit, no indication
> of how this is run (L1, L2, Ln...), no base kernel version...

The test system does not support NV，so we just run KUT in host based on
the kernel 7.3-rc3. The unit is ns.
> 
> Can you please explain what you are actually trying to do? Are you
> saying that accessing the physical timer (two registers) is that
> expensive?

Well, just as mentioned above, it seems ptimer is rarely used, but we have
to run related codes every time during VM in and out.

Best,
Zhou

> 
> Thanks,
> 
> 	M.
> 
