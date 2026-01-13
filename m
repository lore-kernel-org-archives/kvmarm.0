Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B478B2E8DE3
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 15:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316785; cv=none; b=hyxQuxg4dDXC5zG/PKL80RJHtrKpRj7DuvldMGOUYW7KdDGRFnzLAmLMepszzKGftp99+sfCPEt50Ycj7mio2PwR+RyZEyjf7OnPGfAjzSt5YnmTjjFEm5R3UqWq7yCT9ujfKgk9BR7OAI/57MxPDONDguZ/fYbirtqiPgSY6wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316785; c=relaxed/simple;
	bh=xReIy5MJhHpWl6HB0ZFWLieRi6OMaYiKLaD3+3YmNMQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tl/QKFjMQdfeOY9D/Sd6sUKeKxIup0KDqX2boGkrMtImkG+bEI6jaOD87/0Eo4jfzcrLFYNFMqHJSRAWJD3N/I9xteWEmwcNqd88uHGe4VO9WQ2eGFtsZrd0Oda7IT0DCnxdiX65v4etsqvmH7uTdB0UIiHeSd/ADbXyqVpLvl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4drCHh1ktVzJ46F1;
	Tue, 13 Jan 2026 23:06:08 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 67A8140539;
	Tue, 13 Jan 2026 23:06:21 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 13 Jan
 2026 15:06:19 +0000
Date: Tue, 13 Jan 2026 15:06:18 +0000
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
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	Zeng Heng <zengheng4@huawei.com>
Subject: Re: [PATCH v3 27/47] arm_mpam: resctrl: Add support for 'MB'
 resource
Message-ID: <20260113150618.00003829@huawei.com>
In-Reply-To: <20260112165914.4086692-28-ben.horgan@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
	<20260112165914.4086692-28-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 12 Jan 2026 16:58:54 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> resctrl supports 'MB', as a percentage throttling of traffic somewhere
> after the L3. This is the control that mba_sc uses, so ideally the class
> chosen should be as close as possible to the counters used for mba_local.
> 
> MB's percentage control should be backed either with the fixed point
> fraction MBW_MAX or bandwidth portion bitmaps. The bandwidth portion
> bitmaps is not used as its tricky to pick which bits to use to avoid
> contention, and may be possible to expose this as something other than a
> percentage in the future.
> 
> CC: Zeng Heng <zengheng4@huawei.com>
> Co-developed-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

