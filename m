Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA9078F4F
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767710280; cv=none; b=Cr8ft5hXrk3CUq6SNHo4dhQWjF0i+ADEySvBTD4eOztMOnyqGb/jGDutsd426zMCj4oBpfQIk0/4zZaNdbhbR/PoeKPQizlF6raclrVwg5XFM8ZlrDFAfPO381HTe4ffPWuMA+zt6Ok3HLlGAYL1j+alI+JMHnfXH85XLFiCZvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767710280; c=relaxed/simple;
	bh=ZIpw7DGuumGa1FD7GXVFkr+3tTtl45NsJhEhEzPwX6Y=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bpMndmlkJfmq24VMRogCFxdnUn7qaHQnqVeHmXP17CW587jf5YeuSjV5kYSrdN72Mlc57hHdWZy3X21RWOqd9ecFm+83Xov1HZfOFkhvBBu3teAXIX2GCopbHcuu76Yz1lPDDok6BJoXrYM0Y1EjBtxa3WkNbFMOW9Ow5H0bAUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlv0L0LzDzJ46fN;
	Tue,  6 Jan 2026 22:37:54 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id B743E4057F;
	Tue,  6 Jan 2026 22:37:55 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 14:37:54 +0000
Date: Tue, 6 Jan 2026 14:37:52 +0000
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
Subject: Re: [PATCH v2 33/45] arm_mpam: resctrl: Allow resctrl to allocate
 monitors
Message-ID: <20260106143752.00000600@huawei.com>
In-Reply-To: <20251219181147.3404071-34-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-34-ben.horgan@arm.com>
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

On Fri, 19 Dec 2025 18:11:35 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> When resctrl wants to read a domain's 'QOS_L3_OCCUP', it needs to allocate
> a monitor on the corresponding resource. Monitors are allocated by class
> instead of component.
> 
> MBM monitors are much more complicated, if there are enough monitors, they
> will be pre-allocated and free-running. If ABMC is in use instead then
> 'some' are pre-allocated in a different way, and need assigning.
> 
> Add helpers to allocate a CSU monitor. These helper return an out of range
> value for MBM counters.
> 
> Allocating a montitor context is expected to block until hardware resources

monitor

> become available. This only makes sense for QOS_L3_OCCUP as unallocated MBM
> counters are losing data.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> USE_RMID_IDX -> USE_PRE_ALLOCATED in comment
> Remove unnecessary arch_mon_ctx = NULL
As with some other patches, I'm not taking the time at this point to dig
into all the interactions with resctl as others will cover that much better
than me.

Too much to get done :( 

With that in mind.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

J
