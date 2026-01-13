Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012D42D876B
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316526; cv=none; b=ROhZ1YCGMZNCbCnctZzbwDbyxiNDZk0aZ44ciEyDW93ZtX9Ip9xlfmVotl64a5jPxvCcFr2KGEp8BZkzG354agtAbQzkIi0B+dd4j1wNKUJ+psKLHYArACDGwBQuwSxL4MwR0V3JK848rv2SvNJStKAYWRA5muT3hwsSrGTzCW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316526; c=relaxed/simple;
	bh=dTpe5VcLny/9y5sdTY1q+xvCTg79RaoTX4ZaiK+jxXU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S7ibTDGuqWe8AVdReWYSwCGBHHXVab1EeaeGByFwfIjX99FTJJxm+0Cl2OeHMO40jvo4p6byE5jdax21jHBvUrDMEgkAjswSO1eza7xOxx8sg/VdQ5LpramVNn554Yb/31qxM0kLuoEfZKmMNivgShWzrxlaIn7einXV/zN1f6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4drCBc4l2JzHnGgg;
	Tue, 13 Jan 2026 23:01:44 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id C655740584;
	Tue, 13 Jan 2026 23:02:02 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 13 Jan
 2026 15:02:01 +0000
Date: Tue, 13 Jan 2026 15:01:59 +0000
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
Subject: Re: [PATCH v3 26/47] arm_mpam: resctrl: Wait for cacheinfo to be
 ready
Message-ID: <20260113150159.000053f7@huawei.com>
In-Reply-To: <20260112165914.4086692-27-ben.horgan@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
	<20260112165914.4086692-27-ben.horgan@arm.com>
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

On Mon, 12 Jan 2026 16:58:53 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> In order to calculate the rmid realloc threshold the size of the cache
> needs to be known. Cache domains will also be named after the cache id. So
> that this information can be extracted from cacheinfo we need to wait for
> it to be ready. The cacheinfo information is populated in device_initcall()
> so we wait for that.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> [horgan: split out from another patch]
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> This is moved into it's own patch to allow all uses of cacheinfo to be
> valid when they are introduced.

I don't mind the patch but I'm not entirely following this comment. Is
the point that previously there was a sneaky user before this was added in
the series?

Anyhow, that's not in the patch itself so
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
