Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4572744F
	for <kvmarm@lists.linux.dev>; Thu, 26 Feb 2026 07:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772090280; cv=none; b=XuO8lXD6dgudGGzMhoeeT4XYoR+uip/4+CV/s0PB2UGsWqn5U3v+7AeVN3hXpfr6NbIMKbOmnjyLEP/hru3/XweY7JBpo5tvSxu51kvl/qoMcgLDV6ESrDOyaTcohqiI9PqNbjyK69FgtSIbNLiPPM7qwjn3NO9e+a1l4pX2fD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772090280; c=relaxed/simple;
	bh=PBpUk49sHqAa2Wdl6AJ3nH5Gq73C1CXyoTgSqfKH5DM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Nge075i2hd+QSeX5Dqkpc+LgGRrirKH/1TvzndEN5q0FHatuc+LdzlhQWOoSJtL+msJ5LeMAd5FKiJQ5oASBCpD96ecEbrogT/sGd1o6uwE0YGoPCK6fozum4/4Th9cYJxWPYGjwlNRkKz5JmpyrT62hUUOBuWnce5vDfU5uHbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=cqn7r/kD; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="cqn7r/kD"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pYiWW7tcxOkLs/yW8KRyu/TamuHfXhLBoKrJB1ns8oQ=;
	b=cqn7r/kDD6nSvMyzoJHVsclnaJDaagwxF5uVqaWajUzkOe1MN/utLqP3u6s0oEp25hWn+1mFp
	qQTe17XKwalxO2+n71GQlv+uAh+/+0CuqcrOmFkATKCfzg1VACq0udZfJdA/waR8KTG+A1/hN5f
	7BJEN8UaJ2EQGIIGp4JaMRQ=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fM2jV6NNCz1K9Ch;
	Thu, 26 Feb 2026 15:13:02 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id EA2D94048B;
	Thu, 26 Feb 2026 15:17:47 +0800 (CST)
Received: from [10.174.179.37] (10.174.179.37) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 26 Feb 2026 15:17:45 +0800
Message-ID: <9f051461-8704-23c0-234e-1c34cc84433f@huawei.com>
Date: Thu, 26 Feb 2026 15:17:45 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
Content-Language: en-US
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<jonathan.cameron@huawei.com>, <kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-doc@vger.kernel.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <9945d28e-f1f2-e11a-1481-8d80167d6f89@huawei.com>
 <b844c632-c8fc-48f1-b347-07f166019b22@arm.com>
 <28dbde39-5b21-5f2f-59f5-4500c8b0296d@huawei.com>
 <2f2410a0-69dd-4da5-bd84-d168ba6b0605@arm.com>
 <35bf397e-bf96-4c15-b905-2141020b7627@arm.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <35bf397e-bf96-4c15-b905-2141020b7627@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemf100008.china.huawei.com (7.202.181.222)



On 2026/2/25 1:53, Ben Horgan wrote:
> Hi Zeng,
> 
>>>
>>> Resctrl mounting status:
>>>
>>> # cat schemata
>>> L2:4=ff;7=ff;10=ff;13=ff;16=ff;19=ff;22=ff;25=ff;29=ff;32=ff;35=ff;
>>> 38=ff;41=ff;44=ff;47=ff;50=ff;54=ff;57=ff;60=ff;63=ff;66=ff;69=ff;72=ff;
>>> 75=ff;79=ff;82=ff;85=ff;88=ff;91=ff;94=ff;97=ff;100=ff;104=ff;107=ff;
>>> 110=ff;113=ff;116=ff;119=ff;122=ff;125=ff;129=ff;132=ff;135=ff;138=ff;
>>> 141=ff;144=ff;147=ff;150=ff;154=ff;157=ff;160=ff;163=ff;166=ff;169=ff;
>>> 172=ff;175=ff;179=ff;182=ff;185=ff;188=ff;191=ff;194=ff;197=ff;200=ff;
>>> 204=ff;207=ff;210=ff;213=ff;216=ff;219=ff;222=ff;225=ff;229=ff;232=ff;
>>> 235=ff;238=ff;241=ff;244=ff;247=ff;250=ff;254=ff;257=ff;260=ff;263=ff;
>>> 266=ff;269=ff;272=ff;275=ff;279=ff;282=ff;285=ff;288=ff;291=ff;294=ff;
>>> 297=ff;300=ff
>>> L3:1=1ffff;26=1ffff;51=1ffff;76=1ffff;101=1ffff;126=1ffff;151=1ffff;
>>> 176=1ffff;201=1ffff;226=1ffff;251=1ffff;276=1ffff
>>>
>>> # ls mon_data/*/*
>>> mon_data/mon_L3_01/llc_occupancy   mon_data/mon_L3_151/llc_occupancy
>>> mon_data/mon_L3_226/llc_occupancy  mon_data/mon_L3_276/llc_occupancy
>>> mon_data/mon_L3_101/llc_occupancy  mon_data/mon_L3_176/llc_occupancy
>>> mon_data/mon_L3_251/llc_occupancy  mon_data/mon_L3_51/llc_occupancy
>>> mon_data/mon_L3_126/llc_occupancy  mon_data/mon_L3_201/llc_occupancy
>>> mon_data/mon_L3_26/llc_occupancy   mon_data/mon_L3_76/llc_occupancy
>>
>> Thanks for the extra details. These are as expected, right?

Yes, Both the resctrl mount functionality and the control domain count
are as expected.

>>
>>>
>>>>>
>>>>> Boot logs:
>>>>> [root@localhost ~]# dmesg | grep -i mpam
>>>>> [    0.000000] ACPI: MPAM 0x000000007FF35018 003024 (v01 HISI   HIP12
>>>>> 00000000 HISI 20151124)
>>>>> [    9.509852] mpam_msc mpam_msc.64: Merging features for
>>>>> vmsc:0xffff0800973cf5a0 |= ris:0xffff08009757ee90
>>>>> [    9.509859] mpam_msc mpam_msc.254: Merging features for
>>>>> class:0xffff08009736fe50 &= vmsc:0xffff080097628520
>>>>> [    9.509860] mpam:__props_mismatch:
>>>>> mpam_has_feature(mpam_feat_cpor_part, parent) = 1
>>>>> [    9.509864] mpam:__props_mismatch:
>>>>> mpam_has_feature(mpam_feat_cpor_part, child) = 0
>>>>> [    9.509866] mpam:__props_mismatch: parent->cpbm_wd = 8
>>>>> [    9.509869] mpam:__props_mismatch: child->cpbm_wd = 0
>>>>> [    9.509871] mpam:__props_mismatch: alias = 0
>>>>> [    9.509873] mpam:__props_mismatch: cleared cpor_part
>>
>> Do you know where this mismatch is happening? Is it expected?

I've rerun tests against the latest v5 and no longer see the
"__props_mismatch" messages. I'll post the newest boot log on the v5
thread soon.

My suspicion is that the MSC initialization refactoring in the MPAM 
driver between v3 and v5 inadvertently fixed the L2 initialization error
printing.

> 
> I have added some of James' debug patches at:
> https://gitlab.arm.com/linux-arm/linux-bh/-/tree/mpam_resctrl_glue_v5_debugfs?ref_type=heads
> 
> These are on top of a v5 of the series. They apply to older series
> as well.
> 
> The debugfs should then contain details of all the MSC which
> should help debugging.
> 
> It would be great if you were able to share that information, either on list or
> privately if needed.
> 
> You can snapshot the mpam debugfs using:
> 
> find /sys/kernel/debug/mpam -type f -exec sh -c 'echo {}; cat {}' \; > mpam_debugfs.txt

I've enabled MPAM debugfs locally on v5 and dumped the logs. The file is
over 100k, which would trigger corporate email security scans if sent
externally.

I've reviewed it briefly and the contents look as expected.


Best regards,
Zeng Heng
