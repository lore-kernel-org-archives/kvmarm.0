Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7803470EB1
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 08:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788943059; cv=none; b=nCiHJsrbHiLAWZYs4eexBUzaFlmdODRj9pWm0AjYD+jH+1uU/Om0VtwUgauWBwDsMXlBHWkyr/2FV/y0Oj18Cv674EPDIlqzlPGcjvpBre0x0Q8wk1ZX9geSdo+xJS+5gOvqYhDAMnBJs2V+5V3638cAkzpGXRe5U7UNtC9f6d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788943059; c=relaxed/simple;
	bh=5Khv5cvFHTYed7owHSHPM50HghIbRqn856W0Ep0FFSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=akOcOoKXQA1zRiH0ceUkAKsc/h4cgJCmSuJlfW8HK6w9obOFRCu+ZUQiq0fwErtnE6NS+mEp4xyBHR1CHHqNalC3mWS97lXpVNlDtHJ3Qlh7NuHmj1mFm/Bd2sf+lGwQDILdUzXIM9pa5cmVOI6S31Y2GFkkkso2D7gIENqDfpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ar1f3E10; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ar1f3E10"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1pfvM1MtV/hEUXdiJQuW5WMua3sDTwevcTlKJNlMLb8=;
	b=ar1f3E10IzlZjI03rCT4/ytOZSrsk/JVr3e/EeTYS4rKxSwybt7QHeSGTf/+w8+Qo+3fsasjS
	9ycP+GmlILKqSLdR63PKtNwqDIhf4FFu0xxqJHUq52K/8Y+g56g7Xn2C6Mgsy6myaluQi4wL2SF
	7VcHFp88IzuV5nowyC3dE+c=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hfv6P5sh0zRhQs;
	Wed,  9 Sep 2026 16:26:37 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id D1BD140561;
	Wed,  9 Sep 2026 16:37:29 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemk200008.china.huawei.com (7.202.194.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 9 Sep 2026 16:37:28 +0800
Message-ID: <07d77598-bc02-4c73-824b-6d320d158c6b@huawei.com>
Date: Wed, 9 Sep 2026 16:37:19 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/40] arm64/sysreg: Add MPAMSM_EL1 register
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
	<zengheng4@huawei.com>, <linux-doc@vger.kernel.org>, Shaopeng Tan
	<tan.shaopeng@jp.fujitsu.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-4-ben.horgan@arm.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20260313144617.3420416-4-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/3/13 22:45, Ben Horgan 写道:
> The MPAMSM_EL1 register determines the MPAM configuration for an SMCU. Add
> the register definition.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>  arch/arm64/tools/sysreg | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 9d1c21108057..1287cb1de6f3 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -5172,6 +5172,14 @@ Field	31:16	PARTID_D
>  Field	15:0	PARTID_I
>  EndSysreg
>  
> +Sysreg	MPAMSM_EL1	3	0	10	5	3
> +Res0	63:48
> +Field	47:40	PMG_D
> +Res0	39:32
> +Field	31:16	PARTID_D
> +Res0	15:0
> +EndSysreg
> +
>  Sysreg	ISR_EL1	3	0	12	1	0

Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

>  Res0	63:11
>  Field	10	IS

