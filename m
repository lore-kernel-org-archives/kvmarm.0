Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E65320A38
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 11:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767698484; cv=none; b=GEYAt8MnROJx7/JlRyn51XAhpIwpjAL9ioDUhmOWc6UuwbKAh/D8xmKm78ZWGSw7Xz75+aQdgb0NDSrRzKD3JP/KWMg1FOpOX2V0tHl3P1jzCGXivBxLYgyFychaSMA73zfnLWnGqQuVXytGbGn5qhs4WAEfnQAP17B6WsZJrl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767698484; c=relaxed/simple;
	bh=dm+c0VGqDDZYVDDeqv6HFJGBjF2J8XgkgskXoa95uO0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=caHOhoorwprIqh3u+4QmbVe0z1lAxnxsLZAfc14k6WKxtcFi1jukkRkFWkya9SPEUZGtI/sE6f1VA2BJlkxcnvWTegH8CnZXpX/GDzoBUTcmt5iUJJWKwiCTuU74D9Hr4bUSdBYO0RjLb/rFgjHHb3OL6FyFzG3Fg/JzAzEsiqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlpdT23LWzJ470f;
	Tue,  6 Jan 2026 19:21:17 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id B9C0340570;
	Tue,  6 Jan 2026 19:21:18 +0800 (CST)
Received: from localhost (10.48.155.65) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 11:21:17 +0000
Date: Tue, 6 Jan 2026 11:21:15 +0000
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
Subject: Re: [PATCH v2 23/45] arm_mpam: resctrl: Add rmid index helpers
Message-ID: <20260106112115.00000201@huawei.com>
In-Reply-To: <20251219181147.3404071-24-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-24-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:25 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> Because MPAM's pmg aren't identical to RDT's rmid, resctrl handles some
> data structures by index. This allows x86 to map indexes to RMID, and MPAM
> to map them to partid-and-pmg.
> 
> Add the helpers to do this.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
one comment inline.
I messed around with GENMASK + field_prep()/field_get() - new
versions of these with no need for runtime constant masks, but
it ended up as not that much more readable than what you have here.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
> Changes since rfc:
> Use ~0U instead of ~0 in lhs of left shift
> ---
>  drivers/resctrl/mpam_resctrl.c | 28 ++++++++++++++++++++++++++++
>  include/linux/arm_mpam.h       |  3 +++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 4275b1a85887..bdbc5504964b 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -120,6 +120,34 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
>  	return mpam_partid_max + 1;
>  }
>  
> +u32 resctrl_arch_system_num_rmid_idx(void)
> +{
> +	u8 closid_shift = fls(mpam_pmg_max);
> +	u32 num_partid = resctrl_arch_get_num_closid(NULL);
> +
> +	return num_partid << closid_shift;

Given I think you restrict mpam_pmg_max to be power of 2 elsewhere,
doesn't this end up the same as something like
	return mpam_pmg_max * resctrl_arch_get_num_closid(NULL);
Maybe its worth keeping it in the form you have here as
it sort of provides documentation for how you pack those IDs

> +}

