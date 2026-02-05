Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EC03A9620
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770310512; cv=none; b=qKTzu1a3h4ShTXh/QdUEB003rOLBleY+5e7z+yp+reQ/rt9hTUMXrmFym8V/lcnOWsa9uUlwvgXAKAAfMwvSH5LYAa2uCuv9Z75fSE4nq0kWQAByLpSaF0lnRuPISWpa493dIX2aeaxZePq+f8bH1OAymnbuwpAX+NhsEjUTwSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770310512; c=relaxed/simple;
	bh=Ga4hFHlLuwtyT6EVFY9BlvvKOD94jyY/UmQNDNqpEWE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rRL5I6JQpw/4W803QnSg4Ccq1+D9oWexBiSCeVaELYIZTnMkSEVc1mE/9z/wYbHWMkEsHw7TaWOpGm6Q9A2m2hOXOLLZNa9x0m3rxMeCu39FSgQAqBUzXC5kYBzUeZcGRqxITo8MrOAADSfZV1QDumGnGRuR12BuOH2pZnMHJpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f6Nbt3fykzJ468h;
	Fri,  6 Feb 2026 00:54:18 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 6EC8B40569;
	Fri,  6 Feb 2026 00:55:09 +0800 (CST)
Received: from localhost (10.48.151.164) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 5 Feb
 2026 16:55:07 +0000
Date: Thu, 5 Feb 2026 16:55:05 +0000
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
	<zengheng4@huawei.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 27/41] arm_mpam: resctrl: Add support for csu
 counters
Message-ID: <20260205165505.000075a2@huawei.com>
In-Reply-To: <20260203214342.584712-28-ben.horgan@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
	<20260203214342.584712-28-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 3 Feb 2026 21:43:28 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> resctrl exposes a counter via a file named llc_occupancy. This isn't really
> a counter as its value goes up and down, this is a snapshot of the cache
> storage usage monitor.
> 
> Add some picking code which will only find an L3. The resctrl counter
> file is called llc_occupancy but we don't check it is the last one as
> it is already identified as L3.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Co-developed-by: Dave Martin <dave.martin@arm.com>
> Signed-off-by: Dave Martin <dave.martin@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Allow csu counters however many partid or pmg there are
> else if -> if
> reduce scope of local variables
> drop has_csu
> 
> Changes since v2:
> return -> break so works for mbwu in later patch
> add for_each_mpam_resctrl_mon
> return error from mpam_resctrl_monitor_init(). It may fail when is abmc
> allocation introduced in a later patch.
> Squashed in patch from Dave Martin:
> https://lore.kernel.org/lkml/20250820131621.54983-1-Dave.Martin@arm.com/
> 
> Changes since v3:
> resctrl_enable_mon_event() signature update
> Restrict the events considered
> num-rmid update
> Use raw_smp_processor_id()
> Tighten heuristics:
>  Make sure it is the L3
>  Please shout if this means the counters aren't exposed on any platforms
I'm guessing that you mean on platforms where they were under previous version
of the heuristic?  I'll leave zhengheng to comment on that for our platforms.

> Drop tags due to change in policy/rework
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Doesn't really matter as it's the bit after --- , but what's a SoB doing here?

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
