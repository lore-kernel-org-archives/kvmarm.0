Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FBC1A9F94
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763044858; cv=none; b=QthVnyiXatc2V+QXeXM/DY8l8SdTDZMWaIInDAPh5hoyq7fEJ6U1O1xEakzHHxs4tNSWPMXvOIXjrn/39YrQk1Q/KGBC9rJzJeVC58npdgs6bi4l66/AxjljB/qE3CBrkJJKBu6tlimf54FEsDNpZhRHml1yniNYxuPxbPIeKyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763044858; c=relaxed/simple;
	bh=LBB7BJCw9tCeG7al8YGASEOaLivHsVdQ3A0oXzMXoAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GEEvBiNifsGK/X5WWwYdfwpkiPED9mnrjXADkONWtYHJFUSEF2/d99wWRP4Yr12rSOIgI1MSab2OWjIN6946qUNxTE7Enb3g+681XoyX3DOnbvwlIORjUIl56k2BFMdLL1s4zGzoDagTWJtzDJEOG/Aqv4Zh+0a6niZp0P8Tk3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4d6jZj5MJjzmV6h;
	Thu, 13 Nov 2025 22:39:09 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 222741400CB;
	Thu, 13 Nov 2025 22:40:50 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Nov 2025 22:40:49 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Nov 2025 22:40:49 +0800
Message-ID: <b1407660-9b69-7e21-328a-0f969fffa554@hisilicon.com>
Date: Thu, 13 Nov 2025 22:40:48 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v7 5/7] arm64: Add support for FEAT_{LS64, LS64_V}
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>,
	<xuwei5@huawei.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-6-wangzhou1@hisilicon.com>
 <861pm4vn02.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <861pm4vn02.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/11/11 19:15, Marc Zyngier wrote:
> On Fri, 07 Nov 2025 07:21:25 +0000,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> From: Yicong Yang <yangyicong@hisilicon.com>
>>
>> Armv8.7 introduces single-copy atomic 64-byte loads and stores
>> instructions and its variants named under FEAT_{LS64, LS64_V}.
>> These features are identified by ID_AA64ISAR1_EL1.LS64 and the
>> use of such instructions in userspace (EL0) can be trapped. In
>> order to support the use of corresponding instructions in userspace:
>> - Make ID_AA64ISAR1_EL1.LS64 visbile to userspace
>> - Add identifying and enabling in the cpufeature list
>> - Expose these support of these features to userspace through HWCAP3
>>   and cpuinfo
>>
>> ld64b/st64b (FEAT_LS64) and st64bv (FEAT_LS64_V) is intended for
>> special memory (device memory) so requires support by the CPU, system
>> and target memory location (device that support these instructions).
>> The HWCAP3_{LS64, LS64_V} implies the support of CPU and system (since
>> no identification method from system, so SoC vendors should advertise
>> support in the CPU if system also support them).
> 
> But this doesn't mean that the system actually supports this. It is
> also trivial for EL0 to spoof a PASID using ST64BV, by populating the
> bottom 32bit with whatever it wants (hiding ST64BV0 doesn't prevent
> this).

I am confused here, we enable FEAT_LS64 and FEAT_LS64V in this patch,
so only LD64B/ST64B/ST64BV are involved.

Sending the value of ACCDATA(maybe a PASID) is defined in ST64BV0, which
is not enabled currently.

If a bad system implements ST64BV wrongly, isn't the fault of this bad
system?

Best,
Zhou

> 
> In all honestly, I'm starting to think that we cannot safely expose
> this to userspace, at least not without strong guarantees coming from
> the system itself.
> 
> Thanks,
> 
> 	M.
> 
