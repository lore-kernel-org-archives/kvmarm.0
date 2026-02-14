Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D6C1FE44A
	for <kvmarm@lists.linux.dev>; Sat, 14 Feb 2026 01:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032562; cv=none; b=VBY1WT5oO9SKjPkFRXEMW4qkKEIveU3Mi9gkYVtOQg3ljGX0PUVDABsJ/h2pSbHj3qC0O0OTldYX8jKwBNaOta8IsjRGSAxawoUz3aKcuXOSxIBhB+gYS4r0hIhPKacvwSaLJPsW5rZPtNxuX6m3mxvHGmwgycPAOr2VDfFI7u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032562; c=relaxed/simple;
	bh=WqT7HQJrNkciRSOEKTi+E3dLbZfVlfnk0TOEif4sBuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JegtmgyJDSjTcItSxM33Hpn1nKdiOdnvlNx9OsgCMqQXGT4QWudY61hHWwYFShlI2d3a3X0pRxCmc0HVa58AtO5+HFnUG15sbs96WuEZU24HKG+wvoCnJhZmhuEwhr3H9VP3dzgIG/VE7jZH5gsoHbW3dGcIedSoeCp6rF9Rdz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=aXNITjpH; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="aXNITjpH"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iCaOLyOM/ce+PSXs51w6zIINx7guZVIzO8XfZ84+jzM=;
	b=aXNITjpHV/qO31Mcq15Pt7+OkeoEPKqMbyVY9y2CiY+oqgrFRx534sHucxxJE8r2hkz1WkTkr
	881DRPq7KQNG4q+32hDOszG2/OQjPhygA6NdUGJoNT4N42i5rspaOZtgb5ciXpQioDzecyGURly
	zchhIYlyoocOkfWpcOXkkiQ=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fCWXm10jVznTVP;
	Sat, 14 Feb 2026 09:24:24 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F89B4056C;
	Sat, 14 Feb 2026 09:29:11 +0800 (CST)
Received: from [10.174.178.24] (10.174.178.24) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Sat, 14 Feb 2026 09:29:09 +0800
Message-ID: <f78657e3-7981-ab16-29f7-9daf4de3d42b@huawei.com>
Date: Sat, 14 Feb 2026 09:29:08 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 38/41] arm_mpam: Add workaround for T241-MPAM-4
Content-Language: en-US
To: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>, Ben Horgan
	<ben.horgan@arm.com>
CC: "amitsinght@marvell.com" <amitsinght@marvell.com>,
	"baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
	"dave.martin@arm.com" <dave.martin@arm.com>, "david@kernel.org"
	<david@kernel.org>, "dfustini@baylibre.com" <dfustini@baylibre.com>,
	"fenghuay@nvidia.com" <fenghuay@nvidia.com>, "gshan@redhat.com"
	<gshan@redhat.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"kobak@nvidia.com" <kobak@nvidia.com>, "lcherian@marvell.com"
	<lcherian@marvell.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "punit.agrawal@oss.qualcomm.com"
	<punit.agrawal@oss.qualcomm.com>, "quic_jiles@quicinc.com"
	<quic_jiles@quicinc.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "rohit.mathew@arm.com" <rohit.mathew@arm.com>,
	"scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
	"sdonthineni@nvidia.com" <sdonthineni@nvidia.com>, "xhao@linux.alibaba.com"
	<xhao@linux.alibaba.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-39-ben.horgan@arm.com>
 <OSZPR01MB879872E55F0625D737AD06578B61A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <OSZPR01MB879872E55F0625D737AD06578B61A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf100008.china.huawei.com (7.202.181.222)

Hi Shaopeng,

On 2026/2/13 15:02, Shaopeng Tan (Fujitsu) wrote:
> Hello Ben, Fenghua
> 
>> From: Shanker Donthineni <sdonthineni@nvidia.com>
>>
>> In the T241 implementation of memory-bandwidth partitioning, in the absence
>> of contention for bandwidth, the minimum bandwidth setting can affect the
>> amount of achieved bandwidth. Specifically, the achieved bandwidth in the
>> absence of contention can settle to any value between the values of
>> MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.  Also, if MPAMCFG_MBW_MIN is set
>> zero (below 0.78125%), once a core enters a throttled state, it will never
>> leave that state.
>>
>> The first issue is not a concern if the MPAM software allows to program
>> MPAMCFG_MBW_MIN through the sysfs interface. This patch ensures program
>> MBW_MIN=1 (0.78125%) whenever MPAMCFG_MBW_MIN=0 is programmed.
>>
>> In the scenario where the resctrl doesn't support the MBW_MIN interface via
>> sysfs, to achieve bandwidth closer to MBW_MAX in the absence of contention,
>> software should configure a relatively narrow gap between MBW_MIN and
>> MBW_MAX. The recommendation is to use a 5% gap to mitigate the problem.
> 
> I have a question regarding the MBW_MIN values.
> Are there any cases where the sum of all MBW_MIN values from different control groups exceeds 100%?
> And if so, is it acceptable for it to exceed 100%?"
> 
> Best regards,
> Shaopeng TAN
> 


Per the ARM MPAM architecture specification: "A PARTID that has used
less than MIN is given preferential access to bandwidth."

MBW_MIN is not a guaranteed bandwidth allocation. Instead, it serves as
a priority threshold: when a partid's memory bandwidth usage falls below
the configured MBW_MIN value, its priority for memory bandwidth access
is elevated.

Therefore, it is acceptable for the sum of MBW_MIN values across
different control groups to exceed 100%. There is no requirement
for these values to add up to 100% or less.

Hope this clarifies the behavior.


Best regards,
Zeng Heng
