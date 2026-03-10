Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC042AD3D
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 03:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773113016; cv=none; b=G+YOquLTX+xvEEn+GBcJ94LXOMSyabR3TaWfGf4yL0lGEwah21puV2jkDwCl8MozcXZf6DqYME/IIbsgnFEh++m2cO3TA12lo1XzvtmA/MKbJNRWt2b+EUT4ptXmqqUZzd0mdD9rNe5D0UsKum9j6Im9wI0CMwU+Q/PPmUMOy9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773113016; c=relaxed/simple;
	bh=+t/J1XOsAaxgVbbDdD1c/zWt7xTXoMlNp3nGiFEgIDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=owT0iBBCdfbi4GXFTOpc/HLvbdd4U2VZa51j1ccfEOvjmQuiOh73LiN9OFFm6MdRYWDdAChl5A90N4mDK3bi5ctCodBzJp0QsvfyuS6lLkPWcgnAyDhmEmrh7XxF+eAplbhqyyg7Cf4P73KCQifq/VWmU9zCQpDwWSe3qrdczyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=AAya+XVr; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="AAya+XVr"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kbl1GuBV78eycC1jHqRBmTAj3PiiMREwP/FsZOaQ8N8=;
	b=AAya+XVr2pkgKguJ77tN58qWtp1064/0IaQZZP/M4JT+BZLM2G9Bqx/AHhQgAUbUBf4xNu8Ba
	htIR3H9uMil8GhIfcI8T3RMBUaJWr4znqwmQfHqgq/t0jqP4gFyjt6vDYs6oKMhtj9ze7+irQZn
	sBwJ1iUwFPWpYVRXMKI2fDQ=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fVJwY3HK2znTZ4;
	Tue, 10 Mar 2026 11:17:49 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id E860540565;
	Tue, 10 Mar 2026 11:23:25 +0800 (CST)
Received: from [10.174.179.37] (10.174.179.37) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 10 Mar 2026 11:23:23 +0800
Message-ID: <7a5d23e0-1e43-bcf2-c114-b3785834df5e@huawei.com>
Date: Tue, 10 Mar 2026 11:23:23 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 31/41] arm_mpam: resctrl: Add resctrl_arch_rmid_read()
 and resctrl_arch_reset_rmid()
Content-Language: en-US
To: Ben Horgan <ben.horgan@arm.com>, James Morse <james.morse@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <jonathan.cameron@huawei.com>,
	<kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-doc@vger.kernel.org>, Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-32-ben.horgan@arm.com>
 <96ffc81d-3f37-7f48-f9f4-6a58da3e0f99@huawei.com>
 <b95077d7-c036-4a8f-8e42-8f1dc0288075@arm.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <b95077d7-c036-4a8f-8e42-8f1dc0288075@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf100008.china.huawei.com (7.202.181.222)

Hi Ben,

On 2026/3/10 0:30, Ben Horgan wrote:
> Hi Zeng,
> 
> On 3/7/26 09:29, Zeng Heng wrote:
>> Hi Ben,
>>
>> On 2026/2/25 1:57, Ben Horgan wrote:
>>> From: James Morse <james.morse@arm.com>
>>>
>>> resctrl uses resctrl_arch_rmid_read() to read counters. CDP emulation
>>> means
>>> the counter may need reading in three different ways. The same goes for
>>> reset.
>>>
>>> The helpers behind the resctrl_arch_ functions will be re-used for the
>>> ABMC
>>> equivalent functions.
>>>
>>> Add the rounding helper for checking monitor values while we're here.
>>>
>>> Tested-by: Gavin Shan <gshan@redhat.com>
>>> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>>> Tested-by: Peter Newman <peternewman@google.com>
>>> Tested-by: Zeng Heng <zengheng4@huawei.com>
>>> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>>> Signed-off-by: James Morse <james.morse@arm.com>
>>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>>> ---
>>
>> [...]
>>
>>> +
>>> +static int read_mon_cdp_safe(struct mpam_resctrl_mon *mon, struct
>>> mpam_component *mon_comp,
>>> +                 enum mpam_device_features mon_type,
>>> +                 int mon_idx, u32 closid, u32 rmid, u64 *val)
>>> +{
>>> +    if (cdp_enabled) {
>>
>> While reviewing the resctrl limbo handling code, I noticed a issue in
>> __check_limbo() that could lead to premature RMID release when CDP is
>> enabled.
>>
>> In __check_limbo(), RMIDs in limbo state undergo L3 occupancy checks
>> before being released. This check is performed via
>> resctrl_arch_rmid_read(), on arm64 MPAM, which relies on the cdp_enabled
>> state to determine to check which PARTID.
>>
>> The concern arises in the following scenario: Filesystem is mounted with
>> CDP enabled. During normal operation, some RMIDs enter limbo. On umount,
>> cdp_enabled is reset to false. __check_limbo() may then run and perform
>> L3 checks with cdp_enabled = false. This could cause RMIDs to be
>> incorrectly released from limbo while still effectively busy after
>> remount.
> 
> I think a stale limbo list cause more problems than that. If you mount
> with cdp disabled, cause some rmids to be dirty, unmount and then
> remount with cdp enabled then you may have some of the entries in upper
> half marked as busy but when the limbo code checks them it ends up using
> an out of range partid and may trigger an mpam error interrupt.
> 
> To avoid a stale list we could disable the limbo checking at unmount and
> at remount remake the bitmap. This would involve some resctrl changes
> which I will have a further look into. For now, to avoid the dependency
> without a lot of patch churn in this series I think we can hide the cdp
> enablement behind CONFIG_EXPERT. Does that sound ok to you?
> 
> Thanks,
> 
> Ben
> 

Confirmed. Toggling between non-CDP and CDP mount modes leads to
out-of-range PARTID hardware errors and memory access violations. This
can cause MPAM to halt by provoking mpam_broken_work.

I agreed properly fixing this will require resctrl modifications to
handle the limbo state across mount cycles. Hiding CDP behind
CONFIG_EXPERT is acceptable as a short-term mitigation to prevent users
from hitting this bug accidentally.


Best regards,
Zeng Heng
