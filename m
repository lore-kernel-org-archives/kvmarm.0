Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E867D21ABC1
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 03:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930332; cv=none; b=RU7j7dp0adw34kluYkYTmGdIFqKvG3aIV6ifD4otoxkhZWIAqFPhe1129LIkigu/kX9gHTc5ah27wOhKuoXdAzaTnwsJQmwV+1jW3HzedMw8Bidk4/LpwzWES2deLvDSJ8dxPU9vBzmBRa/9vnTrC/TkSBpeGSrPlc7O6uT/PvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930332; c=relaxed/simple;
	bh=DtInEWBY805sHdM2oU6iiGiHXUFY+iqX3HSQwiaZ6Yc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eo7y4Z0fiMLDNLpmXOcffmOd+pIyK0mb1S6TEc7zV1mgCEgZe25DJdPCwWxMMPfW7e42XXo1Oy4xKLO0qRkqjzQvm/8WnY0+MttDA9d2H9S6K9tS8Kgp2qYDM/a/M/ZuriqxQRh8W0aYbT5QcSXlkzHXslFd5Dm9GtMEtQeLTwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=f22OE+b1; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="f22OE+b1"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Td4RsK7CWz0wGv8RlhRHVePEqykvscOGnUjIqYpdWXE=;
	b=f22OE+b1dV2Mq491uS22OBl91IE0jaAmzuoGrGG1HQrC2PkODeR7UoNErHluN81G2A9KVSIzO
	lpgJFIN2NFwl8az/d2EAbTrdruXsICMXQdgNSiuCH3JCBJdvZV2RtqM/zMYVVLXmdfFtF8vQyzd
	uteXvOFqPUxp2eIrcCb7XMw=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dnSJb6Jfdz12LhH;
	Fri,  9 Jan 2026 11:42:23 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E7F140363;
	Fri,  9 Jan 2026 11:45:27 +0800 (CST)
Received: from huawei.com (10.50.87.109) by kwepemf100008.china.huawei.com
 (7.202.181.222) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 9 Jan
 2026 11:45:25 +0800
From: Zeng Heng <zengheng4@huawei.com>
To: <jonathan.cameron@huawei.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <ben.horgan@arm.com>,
	<carl@os.amperecomputing.com>, <catalin.marinas@arm.com>, <corbet@lwn.net>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<joey.gouly@arm.com>, <kobak@nvidia.com>, <kvmarm@lists.linux.dev>,
	<lcherian@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <maz@kernel.org>, <oupton@kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <suzuki.poulose@arm.com>,
	<tan.shaopeng@fujitsu.com>, <will@kernel.org>, <xhao@linux.alibaba.com>,
	<wangkefeng.wang@huawei.com>, <zengheng4@huawei.com>
Subject: Re: [PATCH v2 18/45] arm_mpam: resctrl: Implement resctrl_arch_reset_all_ctrls()
Date: Fri, 9 Jan 2026 11:45:06 +0800
Message-ID: <20260109034506.1176234-1-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260105175154.00002041@huawei.com>
References: <20260105175154.00002041@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf100008.china.huawei.com (7.202.181.222)

> From: James Morse <james.morse@arm.com>
> Date: Fri, 5 Dec 2025 21:58:32 +0000
> Subject: [PATCH v2 18/45] arm_mpam: resctrl: Implement resctrl_arch_reset_all_ctrls()
>
> We already have a helper for resetting an mpam class and component.  Hook
> it up to resctrl_arch_reset_all_ctrls() and the domain offline path.
>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>  drivers/resctrl/mpam_devices.c  |  6 +++---
>  drivers/resctrl/mpam_internal.h |  7 +++++++
>  drivers/resctrl/mpam_resctrl.c  | 15 +++++++++++++++
>  3 files changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index bc4f1c80eab..d32e8700245 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -353,6 +366,8 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
>
>  		ctrl_dom_empty = true;
>  		if (exposed_alloc_capable) {
> +			mpam_reset_component_locked(dom->ctrl_comp);
> +
>  			ctrl_d = &dom->resctrl_ctrl_dom;
>  			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
>  			if (ctrl_dom_empty)

mpam_cpu_offline() already directly calls mpam_reset_ris() to reset the
MPAM MSC that is about to go offline. So why here still need
mpam_resctrl_offline_cpu() to invoke mpam_reset_component_locked(),
which ends up calling mpam_reset_ris() again?

Please point it out if I might have overlooked anything, thank you.


Best Regards,
Zeng Heng
