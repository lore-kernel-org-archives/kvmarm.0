Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38172F6574
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 07:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770968297; cv=none; b=cdOz8Q1fnA1I2AqCM3QTM2IdktFVJPmKov6mxAviViqR4pxB/n4ybzQgKLncysYIytdl2FfCj44zL7zd2fNqZROotoL9vaM5OONuDJMqAhdDTH83GqCDc1lmRHSCVGc6lMzZ1dTosj4nIyQYUBWNtizcx4/HHYNwCQ6HKPmcBGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770968297; c=relaxed/simple;
	bh=/HeYhyYwJRRJLTIKHtGEbLuPj76p0PK7NZ6IU59g8pQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iKoW9g+NDTnQcr+UlJXXAuUORn4F1o2WFdnNaCJEZRciXGGHepQwKQqp87p6XpE7UUXxT9M10qx50Ey3oS6ACwBIhbzbJJJp4k5mK25ewSeofqHlT3qU7PIz+bGOrpuPhLUVejoYjsWhDVA6eC0WM8hvdHMKUEfxB5rmjBRAcnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Y+Zykvrw; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Y+Zykvrw"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cAsv5Wg51HBTuXeIYLmLeU0ms61JfhJ7RQ1pNMzxiTU=;
	b=Y+ZykvrwAJsx9tSz/7z2h69mpygkv8r5n3ase9G3rqJHGAFmkS4Uc6H0A9rcvuesGe/DD5hE5
	QJiAv4ERai0VxEOaxGz251dS8YDI07N3i9p5grMNPd3/l7lT7bc95GNRkCuAf/qYa5F8Slwq26U
	xgfl3bF3EugDHCyJulrCbMU=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fC3nP6N3XzpSx7;
	Fri, 13 Feb 2026 15:33:45 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F2162021A;
	Fri, 13 Feb 2026 15:38:12 +0800 (CST)
Received: from [10.174.178.24] (10.174.178.24) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 13 Feb 2026 15:38:10 +0800
Message-ID: <f6f865bc-319c-8944-9989-4fd83a59d4b8@huawei.com>
Date: Fri, 13 Feb 2026 15:38:09 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 26/41] arm_mpam: resctrl: Add support for 'MB' resource
Content-Language: en-US
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <kobak@nvidia.com>,
	<lcherian@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <peternewman@google.com>,
	<punit.agrawal@oss.qualcomm.com>, <quic_jiles@quicinc.com>,
	<reinette.chatre@intel.com>, <rohit.mathew@arm.com>,
	<scott@os.amperecomputing.com>, <sdonthineni@nvidia.com>,
	<tan.shaopeng@fujitsu.com>, <xhao@linux.alibaba.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <corbet@lwn.net>,
	<maz@kernel.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-doc@vger.kernel.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-27-ben.horgan@arm.com>
 <20260205165018.0000089c@huawei.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20260205165018.0000089c@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemf100008.china.huawei.com (7.202.181.222)

Hi Ben,

On 2026/2/6 0:50, Jonathan Cameron wrote:
> On Tue, 3 Feb 2026 21:43:27 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> From: James Morse <james.morse@arm.com>
>>
>> resctrl supports 'MB', as a percentage throttling of traffic from the
>> L3. This is the control that mba_sc uses, so ideally the class chosen
>> should be as close as possible to the counters used for mbm_total. If
>> there is a single L3 and the topology of the memory matches then the
>> traffic at the memory controller will be equivalent to that at egress of
>> the L3. If these conditions are met allow the memory class to back MB.
>>
>> MB's percentage control should be backed either with the fixed point
>> fraction MBW_MAX or bandwidth portion bitmaps. The bandwidth portion
>> bitmaps is not used as its tricky to pick which bits to use to avoid
>> contention, and may be possible to expose this as something other than a
>> percentage in the future.
> 
> I'm very curious to know whether this heuristic is actually useful on many
> systems or whether many / most of them fail this 'shape' heuristic.
> 

The current MPAM driver has restrictions that limit MB control support.
For example, on some systems, the MPAM memory class MSCs are not located
at the L3 cache but rather at the memory controller (e.g., Mata). In
such cases, MB control and mbm_total bandwidth monitoring cannot be
enabled.

I'm unsure whether the community would welcome and be willing to review
a patch series supporting such systems. Of course, the changes would
involve minor refactoring in the resctrl common layer.

Any feedback would be greatly appreciated.


Best Regards,
Zeng Heng
