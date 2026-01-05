Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840FD28725F
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 16:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767631027; cv=none; b=V1Gc3e3WkIjonInRX0XXrxhmw9omCvcmnDKRlN5f0uHsctcUAa+cz4duKJZx0xwx9bfvbmjE16FeMq/NAfy/RSPLOK4C2x+z7sgnfsX4q5hpceBN3NFr3dVgPlkwHAC0+p7fVCtzM/qg7BWNnHqkosJS0f0VQyelSA2DR7h22M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767631027; c=relaxed/simple;
	bh=EErNRIHka0BO075l5rGbqV68pFySKcZluidHmZJjJk4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omSBLgNQa4QJO6lY2od6StJ2VRJUcLPNUYA1sMdaPNDem01HAcFv5ZAqVWnhYDG8noVDc0+V5Y151L40zX4tMN99pCGa0DcNEcj7XlsPVeU55J2VNEItCY/OO4REyVAg68Di2Db21dSpEGU7cc8Fsggo9oha9tvY3oezWirfdOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlKg61DGVzJ46Bd;
	Tue,  6 Jan 2026 00:36:02 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id C41E040570;
	Tue,  6 Jan 2026 00:37:02 +0800 (CST)
Received: from localhost (10.126.174.38) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 5 Jan
 2026 16:37:01 +0000
Date: Mon, 5 Jan 2026 16:36:59 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v2 04/45] arm64/sysreg: Add MPAMSM_EL1 register
Message-ID: <20260105163659.000012f2@huawei.com>
In-Reply-To: <20251219181147.3404071-5-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-5-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:06 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> The MPAMSM_EL1 register determines the MPAM configuration for an SMCU. Add
> the register definition.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Matches the spec

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
>  arch/arm64/tools/sysreg | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 8921b51866d6..afbb55c9b038 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -5052,6 +5052,14 @@ Field	31:16	PARTID_D
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
>  Res0	63:11
>  Field	10	IS

