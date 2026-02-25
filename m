Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897272DFA4A
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 11:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772018049; cv=none; b=mJDnEus+fudPYocQOyitP0TDE2UOXMtFPcw+RcI2Gbihri0aaSywTNBTbX4w09vZ54MweJ8nxVOy5BJmbb83NFl/dUGHFGDyGLnMFJX1bMEXSMwPsErMudMrwJBu5v3RJPG+bAgFljirvbAw++PZiYuU+x+8Z4UgNzkYCDqaoqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772018049; c=relaxed/simple;
	bh=+v+jKnSeSCg8P5XL6Byp/Gr3ZC4di/zIr58Vhezu4uw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UR1JD7XEyE4cr3XlBfhXNwx4aWELgVSnJoGfJFsNXXniWtXrxw7RnFiXnhFWNuKh44Uud242ebu7mwvdLjkUvkQMU0L3DM3z60bBX65SyZvP3EIbmXASK/9VKAPoKr75UYBb9hT5lZpltdX5/LV+4MqVscN+jT3q9ikoaDPFk3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fLX5G2kcpzHnH2q;
	Wed, 25 Feb 2026 19:13:22 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 2754940565;
	Wed, 25 Feb 2026 19:14:04 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 25 Feb
 2026 11:14:02 +0000
Date: Wed, 25 Feb 2026 11:14:01 +0000
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
Subject: Re: [PATCH v5 26/41] arm_mpam: resctrl: Add monitor initialisation
 and domain boilerplate
Message-ID: <20260225111401.00004ccd@huawei.com>
In-Reply-To: <20260224175720.2663924-27-ben.horgan@arm.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
	<20260224175720.2663924-27-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 24 Feb 2026 17:57:05 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> Add the boilerplate that tells resctrl about the mpam monitors that are
> available. resctrl expects all (non-telemetry) monitors to be on the L3 and
> so advertise them there and invent an L3 resctrl resource if required. The
> L3 cache itself has to exist as the cache ids are used as the domain
> ids.
> 
> Bring the resctrl monitor domains online and offline based on the cpus
> they contain.
> 
> Support for specific monitor types is left to later.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> New patch but mostly moved from the existing patches to
> separate the monitors from the controls and the boilerplate
> from the specific counters.
> Use l3->mon_capable in resctrl_arch_mon_capable() as
> resctrl_enable_mon_event() now returns a bool.

Just one trivial comment on short line wrap. I'm not that fussed though so
I don't mind if you only tidy that up if doing a v6.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 29efcad163e6..c14e59e8586d 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c

> +static int mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,
> +				     enum resctrl_event_id type)
> +{

...

> +
> +	/*
> +	 * num-rmid is the upper bound for the number of monitoring
> +	 * groups that can exist simultaneously, including the
> +	 * default monitoring group for each control group. Hence,
> +	 * advertise the whole rmid_idx space even though each
> +	 * control group has its own pmg/rmid space. Unfortunately,
> +	 * this does mean userspace needs to know the architecture
> +	 * to correctly interpret this value.
Trivial but that's an oddly short wrap.  Should be.
	 * num-rmid is the upper bound for the number of monitoring groups that
	 * can exist simultaneously, including the default monitoring group for
	 * each control group. Hence, advertise the whole rmid_idx space even 
	 * though each control group has its own pmg/rmid space. Unfortunately,
	 * this does mean userspace needs to know the architecture to correctly
	 * interpret this value.

The wonder of an email client with rulers :)

J
> +	 */
> +	l3->mon.num_rmid = resctrl_arch_system_num_rmid_idx();
> +
> +	if (resctrl_enable_mon_event(type, false, 0, NULL))
> +		l3->mon_capable = true;
> +
> +	return 0;
> +}

