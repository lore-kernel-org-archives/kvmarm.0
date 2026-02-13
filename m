Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDD6611E
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 03:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770953528; cv=none; b=dx9A2tQzZq82N0mJIiAVrlvQ61+UXd04ajvagDFjDF0DSzHf5dV3jU9bX2ESsbRE9PHr/9nbgoC3K4U/35lYh/cM3x2xlpui3usFQ4dvRiK6YlzBwpEs7iE9QaUJtEVoWzTEqxBZ4S8Z1GX8hUDClcjrfEbnbWL73XbCpMB0z+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770953528; c=relaxed/simple;
	bh=hY496p4yfyKaTWbnakLvDFLvspHDFM+Q4po34xBLG6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GV42VMDZCje3qWW8O6+xFjn7/IIqJiowrJRES4S1aCBcPt2y/vsDVlfCyxnmc3wwHzgmdsgXbq5M7DkKixghdPIXPvW2ardaJOBsS8ryHiMPj3FDY2UHQImTqpOfWc5Wa1JEGFZVAEYdTgyculNjczZ8HAjqtmnv/jy2zZVP3XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=D+vI6+z0; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="D+vI6+z0"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2jTLkivBK3JZE2lTS6lR4ksovwt/ATiOOgWVBIF+Ib0=;
	b=D+vI6+z0tAr2aLzikbeqrI3fmDv2U8aS8V1US5GQS1V44beT0mlsbRdQHE0H/OAwvsh8MiEQS
	93rBW2wJyPc86+tLeLbCG4ajX7Qh9mC9u/OCIaLXc3WM7lyJgGUxzWkwMn8F54Q0F3HtCOCQxb2
	ZdqmW6CBrhAoKJcG9F3ErCo=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4fByK61B9TzmV6s;
	Fri, 13 Feb 2026 11:27:22 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id 78F4040562;
	Fri, 13 Feb 2026 11:32:02 +0800 (CST)
Received: from [10.174.178.24] (10.174.178.24) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 13 Feb 2026 11:32:00 +0800
Message-ID: <fb50df25-0e0b-6a5f-e186-2997b5ce43f3@huawei.com>
Date: Fri, 13 Feb 2026 11:32:00 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 16/41] arm_mpam: resctrl: Implement
 resctrl_arch_reset_all_ctrls()
Content-Language: en-US
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>
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
	<linux-doc@vger.kernel.org>, Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-17-ben.horgan@arm.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20260203214342.584712-17-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf100008.china.huawei.com (7.202.181.222)



On 2026/2/4 5:43, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> We already have a helper for resetting an mpam class and component.  Hook
> it up to resctrl_arch_reset_all_ctrls() and the domain offline path.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Cc: Zeng Heng <zengheng4@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> Don't expose unlocked reset
> 
> Changes since v3:
> Don't use or expose mpam_reset_component_locked()

Already review this v4 patch, and confirm the removal of redundant
mpam_reset_component_locked() calls.

+ Reviewed-by: Zeng Heng <zengheng4@huawei.com>

However, I noticed another existing issue regarding the in_reset_state
flag setting, which will be discussed in another separate patch.
