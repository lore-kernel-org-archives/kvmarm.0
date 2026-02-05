Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF1843C058
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770310722; cv=none; b=OSGvimFnchlK+TMldesdY4Cz3dexhO9vL35LI7J1HlCUTXA4L+IoviqE4HW46eYgu2+Dr7JAwNJZRzrlhsMZ3hn2oP5EVZ8Zlp64sBF7j4zapBmgB76Uk2OVeP6Q/QL2U5WUkTV81avkrW91szfysGihjzQlWTntMvrRw6y3NRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770310722; c=relaxed/simple;
	bh=0sD21ZMl1XdB1JbjmApSTgXL90j3NRTsHeHpdf6pgew=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tYnlunARCe6xdw8Pf6wzwstkJJW9hTMcu+Yo1kpF5pIWllt+yv33jFEChRsTuaknIKGaPgWjaLkO60mqtDBtcVSkGaNeZSVd6tJ2YRXWfg1InS6ki8TuvOLVowZMZbDg8I4QprAj3JOxgOK2SjBiNl63QpnMuad42ijGyNh6WwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f6Ngx3F7DzJ467X;
	Fri,  6 Feb 2026 00:57:49 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 61C0540569;
	Fri,  6 Feb 2026 00:58:40 +0800 (CST)
Received: from localhost (10.48.151.164) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 5 Feb
 2026 16:58:38 +0000
Date: Thu, 5 Feb 2026 16:58:37 +0000
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
Subject: Re: [PATCH v4 28/41] arm_mpam: resctrl: Pick classes for use as mbm
 counters
Message-ID: <20260205165837.00007a46@huawei.com>
In-Reply-To: <20260203214342.584712-29-ben.horgan@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
	<20260203214342.584712-29-ben.horgan@arm.com>
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

On Tue, 3 Feb 2026 21:43:29 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> resctrl has two types of counters, NUMA-local and global. MPAM can only
> count global either using MSC at the L3 cache or in the memory controllers.
> When global and local equate to the same thing continue just to call it
> global.
> 
> Because the class or component backing the event may not be 'the L3', it is
> necessary for mpam_resctrl_get_domain_from_cpu() to search the monitor
> domains too. This matters the most for 'monitor only' systems, where 'the
> L3' control domains may be empty, and the ctrl_comp pointer NULL.
> 
> resctrl expects there to be enough monitors for every possible control and
> monitor group to have one. Such a system gets called 'free running' as the
> monitors can be programmed once and left running.  Any other platform will
> need to emulate ABMC.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Seems fine to me.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


