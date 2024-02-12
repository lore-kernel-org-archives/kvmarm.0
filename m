Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4688C3A8E0
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 14:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707747713; cv=none; b=ROcx5z3kJQB2cBAQK5IbM6CRFH8cMvUJdF6xVj9TjT3dyFm197F7ze4MYXlNCwcNvtEQc93d5dIKRs2jtSHpMZpYQvmt94Ch98QR+pFylaPgr05NtOgu3aY37vwE+PRw3OQ5JCw5JvA3xaOJ3uqIri5WoV9KcQ+N3iuKM1b/0kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707747713; c=relaxed/simple;
	bh=pYowmjwv8SCbaVw3Pq2KsThTy38KOhWUhTuMVFSrc7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ZamUXGfoUI+PDh/ehVaHTRHS/fDmEovYDMMNiIHu9ZjbHxfP5NO4wDE2ImiU5tqeMICKLJydv1hXSGcrMjsUAUAi1hMamAWH+IOeoTw85qOV7Q6JFM1IqnB43BaU1kAHCVRylBL8x2G0WwyweYvwGD7jRdghpF0R5sWJRyfnVfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=T028dim3; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="T028dim3"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240212142148euoutp024c7b79b3dd83495f6af437b3146ef590~zI34aE4hy3189131891euoutp02T
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 14:21:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240212142148euoutp024c7b79b3dd83495f6af437b3146ef590~zI34aE4hy3189131891euoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707747708;
	bh=ZrClZs8vH6AfAh63wxV/+o45/0iih5wzyyG+6gSdhTw=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=T028dim3WFCVNg2bNiEaJgdT9t5GWPxPeHLxQrqfl6PKx10gnwesTvUdG7/ZNWX9w
	 J/QOPU2J/1cIAv6GRQN7vAHhzndhurhjEA6ugomni253wvzGy9s8YQPvy9QtQjVZpv
	 p5R/JaW0ALNcOS4CbINsfHDUxVlKATnTeh/QGGZw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240212142147eucas1p2aeafc158cc385ddd6d248b0cf798cf93~zI34E-LFc0044700447eucas1p2d;
	Mon, 12 Feb 2024 14:21:47 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 54.68.09814.B792AC56; Mon, 12
	Feb 2024 14:21:47 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240212142147eucas1p24fcfcc765b8dbae412ab1d6d0e3c7e6c~zI33hUl7d2412024120eucas1p2j;
	Mon, 12 Feb 2024 14:21:47 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240212142147eusmtrp2adc588f84330167042ad55df8b9fe961~zI33gmduX1475014750eusmtrp2-;
	Mon, 12 Feb 2024 14:21:47 +0000 (GMT)
X-AuditID: cbfec7f4-711ff70000002656-c2-65ca297bb464
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 3B.5E.10702.B792AC56; Mon, 12
	Feb 2024 14:21:47 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240212142146eusmtip255c6b3c38edf2106d26b6415f276e807~zI32wdaGg3204932049eusmtip2f;
	Mon, 12 Feb 2024 14:21:46 +0000 (GMT)
Message-ID: <21e55530-7d66-4aff-a78d-4bffd55310d1@samsung.com>
Date: Mon, 12 Feb 2024 15:21:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/10] arm64: cpufeature: Detect HCR_EL2.NV1 being
 RES0
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, Catalin
	Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
	Rutland <mark.rutland@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>, Oliver
	Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <86eddh6auo.wl-maz@kernel.org>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se1BMcRT227t7uy3LbbOzR6KxnqGSSa6hJu/FRBhjZMhO3am0bebe8sxY
	I6pVI5LqFhW2Zafx2LLKIyPp4S3yKMrQkEh6jvK+ez367zvfd77fd86ZH4HJL0iciHBdNM3o
	NFoVLhVbK3rvu+1wvUVPaTKNoXq72hDVlp+EqMZSk4hqKbohpixvnkgo49OHIqoku1pCpfV+
	xKnM+npExb2YRj03nrPzG6guOFaA1HHlrRK1xZyIq/P0aZi68OQudXNhJgrAA6WzQmht+Gaa
	8fDdIA0rMG7b9H7k1oZjVzA9OuBkQAQBpBekWoMNSErIyVMIDh0txQ3I/nfRheD2q6mC0Ikg
	+fFlCS/whp7UTlwQTAjSD1aKhaIdwfH8WyK+S0b6QldxnM0hJsdCfXcFEngHqM5sEvNYQbpA
	Y12GHY8dyQBo3n3CxmOkEuqacmzvDCVHQceDasQHYGS7CPYnJdoexUlPMLQabLPak5PgxrcO
	XDC7wJ4LWRhvAHKPPXxOfvln7nlgLEnEBOwILZVFdgJ2hp8lfBpviEeQ+7XxT5GCQP+uDgld
	M+HFvT6cPxlGusLZSx4CPRusPZ9x4ZKD4VmrgzDEYDhkTccEWgYJ++RC9zjgKs/8i73+oAZL
	QSqu3124fvtz/dbh/ufmIrEZKekYNjKUZqfq6C3urCaSjdGFugdHRVrQ7591+0dlVzEytbS7
	lyERgcoQEJhqqKwmo4qWy0I027bTTFQQE6Ol2TI0nBCrlLKxIS60nAzVRNMRNL2JZv6qIsLe
	SS9SnPYKT1kBVUuueO92M35ZtzLWxXn1oHLuWhE3vaJk1T632MmBl/2bt6qPivC2J6raCHns
	IkZFeUpN46OyM73DHI3rUyNqR0lqlI87dD7TUvIXzul0en31baPfUj//7rr5pG7Z2rIhQXlu
	EwYEZ1Qv+HA3q35dvDltdMH5Bru8g4okr/Kbk/0/WbUHat+4FpKlPuYGjwBzkHXnoztPB7Tu
	PTKX/a5Mi4je7tx+uGpN6vfujhxfiw+ndZ2uV9AJF3PP5ZgDx1nY8Rd/MKr9ipbFGyPjtfFX
	HfqK2p6FDut7a1k+sqe5J33EmegEpjh5tmTn8Rl+ji/LN8/03rIwe31vgpXLUonZMI3nRIxh
	Nb8AGFK1hMgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t/xe7rVmqdSDSY+47L4+eU9o8X7ZT2M
	Fvf3LWeyeLXlMIvFpsfXWC2WXr/IZLFzzklWi6k/37BZzLx9m9Gi5Y6pxc2lG9gduD3WzFvD
	6NFy5C2rx6ZVnWweCxumMntsXlLv8WLzTMYAtig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMT
	Sz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jDVLKwteylXcm7eHuYGxX6qLkZNDQsBE4tvkz2xd
	jFwcQgJLGSWm3nnIBJGQkTg5rYEVwhaW+HOtiw3EFhJ4zyix+Ac3iM0rYCfxZUcLWA2LgKrE
	7a/HGCHighInZz5hAbFFBeQl7t+awQ5iCwv4Sdz50wVmMwuIS9x6Mh9sl4iAosSnCycZQY5g
	FvjMJPHk3VIWiIs6mST2vrgLNpVNwFCi6y3EFZwC2hKH/3xig5hkJtG1tYsRwpaXaN46m3kC
	o9AsJIfMQrJwFpKWWUhaFjCyrGIUSS0tzk3PLTbSK07MLS7NS9dLzs/dxAiM0m3Hfm7Zwbjy
	1Ue9Q4xMHIyHGCU4mJVEeC/NOJEqxJuSWFmVWpQfX1Sak1p8iNEUGBoTmaVEk/OBaSKvJN7Q
	zMDU0MTM0sDU0sxYSZzXs6AjUUggPbEkNTs1tSC1CKaPiYNTqoFpo4qWt06Ni1jc/Fmz19/f
	/l318urrtuu2i97sOWr91mBO1l8/+b1///35Vl6395S8zC7RDw9bNZ7fWu62s/C5i0s9jy3f
	sk97MhJf31ednVkmFMufJ2n8+8JFGb0GIW29U2e2TugXEjducHru/udTW6P9z1PrfPgCElR3
	lfzed/b8lq/nCgWkxf/MD5vI1d724c8vmSfP9jJvDvo0xeq62cYzh39yWarNP3xW3yf1+ieu
	qV9ceyIeOq1bUhGyUznrSkjFAk6DjDOBpzLe39wuZOFh4GM5I+zO97TgrOk2bKt0zz9x7ew/
	fL2jzOztjZ2PFtdMunvop5HjQtt5PrqxlcymKrmPwv3OFtjl/7psqMRSnJFoqMVcVJwIAOwn
	7nFbAwAA
X-CMS-MailID: 20240212142147eucas1p24fcfcc765b8dbae412ab1d6d0e3c7e6c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20240212124837eucas1p231da54bb0ff8d46d38c6c7e627e50172
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240212124837eucas1p231da54bb0ff8d46d38c6c7e627e50172
References: <20240122181344.258974-1-maz@kernel.org>
	<20240122181344.258974-7-maz@kernel.org>
	<CGME20240212124837eucas1p231da54bb0ff8d46d38c6c7e627e50172@eucas1p2.samsung.com>
	<e3cc70fb-16d9-4e4e-aa35-f0eb2baaf166@samsung.com>
	<86eddh6auo.wl-maz@kernel.org>

On 12.02.2024 15:00, Marc Zyngier wrote:
> On Mon, 12 Feb 2024 12:48:35 +0000,
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>> On 22.01.2024 19:13, Marc Zyngier wrote:
>>> A variant of FEAT_E2H0 not being implemented exists in the form of
>>> HCR_EL2.E2H being RES1 *and* HCR_EL2.NV1 being RES0 (indicating that
>>> only VHE is supported on the host and nested guests).
>>>
>>> Add the necessary infrastructure for this new CPU capability.
>>>
>>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>> This patch landed recently in linux-next as commit da9af5071b25 ("arm64:
>> cpufeature: Detect HCR_EL2.NV1 being RES0"). I found that it causes a
>> following regression in the CPU hot-plug operation:
>>
>> # for i in /sys/devices/system/cpu/cpu[1-9]; do echo 1 >$i/online; done
>> ------------[ cut here ]------------
>> kernel BUG at arch/arm64/kernel/cpufeature.c:1468!
>> Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
>> Modules linked in: dw_hdmi_cec dw_hdmi_i2s_audio crct10dif_ce
>> snd_soc_simple_card rockchip_saradc industrialio_triggered_buffer
>> hantro_vpu kfifo_buf snd_soc_simple_card_utils rockchip_thermal
>> phy_rockchip_naneng_combphy display_connector gpio_ir_recv v4l2_vp9
>> v4l2_h264 v4l2_mem2mem dwmac_rk videobuf2_dma_contig stmmac_platform
>> videobuf2_memops videobuf2_v4l2 stmmac rockchipdrm videodev
>> snd_soc_rockchip_i2s_tdm snd_soc_rk817 pcs_xpcs panfrost rtc_rk808
>> rk805_pwrkey analogix_dp rk817_charger spi_rockchip_sfc dw_mipi_dsi
>> videobuf2_common dw_hdmi drm_shmem_helper mc gpu_sched
>> drm_display_helper ahci_dwc ip_tables x_tables ipv6
>> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.8.0-rc1+ #14563
>> Hardware name: Hardkernel ODROID-M1 (DT)
>> pstate: 800001c9 (Nzcv dAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : __read_sysreg_by_encoding+0x38c/0x390
>> lr : read_scoped_sysreg+0x4c/0x70
>> ...
>> Call trace:
>>    __read_sysreg_by_encoding+0x38c/0x390
>>    read_scoped_sysreg+0x4c/0x70
>>    has_nv1+0x18/0x48
>>    verify_local_cpu_caps+0x54/0x124
>>    check_local_cpu_capabilities+0x28/0x208
>>    secondary_start_kernel+0xb0/0x154
>>    __secondary_switched+0xb8/0xbc
>> Code: d53802f3 17ffff3b d5380253 17ffff39 (d4210000)
>> ---[ end trace 0000000000000000 ]---
>> Kernel panic - not syncing: Attempted to kill the idle task!
>> SMP: stopping secondary CPUs
>> Kernel Offset: disabled
>> CPU features: 0x1,80000000,80050295,2100721b
>> Memory Limit: none
>> ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---
>>
>> It looks that some additional checks are needed for the CPU hot-plug case.
> Nah, that's much simpler.
>
> I simply missed a spot where ID_AA64MMFR4_EL1 must be handled (it is
> getting annoying that we have more than a single place where these
> "read all the ID registers" are handled).
>
> Can you please give the following a go? If that works for you (it does
> for me here), I'll post an actual fix (plus another fix for another
> buglet I just noticed).

Works fine now.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Thanks,
>
> 	M.
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 0f29ac43c7a2..2f8958f27e9e 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1456,6 +1456,7 @@ u64 __read_sysreg_by_encoding(u32 sys_id)
>   	read_sysreg_case(SYS_ID_AA64MMFR1_EL1);
>   	read_sysreg_case(SYS_ID_AA64MMFR2_EL1);
>   	read_sysreg_case(SYS_ID_AA64MMFR3_EL1);
> +	read_sysreg_case(SYS_ID_AA64MMFR4_EL1);
>   	read_sysreg_case(SYS_ID_AA64ISAR0_EL1);
>   	read_sysreg_case(SYS_ID_AA64ISAR1_EL1);
>   	read_sysreg_case(SYS_ID_AA64ISAR2_EL1);
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

