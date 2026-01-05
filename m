Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A302FE057
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 17:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767635198; cv=none; b=nLEDomgB+dy+bPZ2u1P1enblnEAfcImQn7D67Vq25/7HcsNngjGj6JTfmxZ3P/f6T+Z4Qd8h/7an/HWrzSjmO/7NeeM0VQzZiSZFXMPz2WuEBG5ggwBEoCYyex8vEAQfg0njAPR8kXSKD1m1MjPz7q/nK0rYiD0en92l1bfXNko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767635198; c=relaxed/simple;
	bh=PEqFxzJkA2/T98OQFyFmA9eNU8M90235oPRonXoqIFc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkK5MO3u3YQ2r3TdW7d2xSHziUKB6vDzdKKdWcHIJZvgTkLof5cKJLev1oy0AfnGw17L39jNcvzZNa2hMnlGYratwW/b6IHnz3pQh88z3Gow4Bsii+ccU/dne7735mHp+udea5fLdW6y3zEp4hn/YQkq6gXhV/7eFG7dyAoQAUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlMDV6BWjzJ46CZ;
	Tue,  6 Jan 2026 01:46:34 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 2405D40086;
	Tue,  6 Jan 2026 01:46:35 +0800 (CST)
Received: from localhost (10.126.174.38) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 5 Jan
 2026 17:46:33 +0000
Date: Mon, 5 Jan 2026 17:46:31 +0000
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
Subject: Re: [PATCH v2 17/45] arm_mpam: resctrl: Pick the caches we will use
 as resctrl resources
Message-ID: <20260105174631.000043f3@huawei.com>
In-Reply-To: <20251219181147.3404071-18-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-18-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:19 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> Systems with MPAM support may have a variety of control types at any point
> of their system layout. We can only expose certain types of control, and
> only if they exist at particular locations.
> 
> Start with the well-known caches. These have to be depth 2 or 3 and support
> MPAM's cache portion bitmap controls, with a number of portions fewer than
> resctrl's limit.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Note that I'm far from familiar with all the details of the resctl side
of things so assuming that will be well covered by other reviewers!

Jonathan

> ---
> Changes since rfc:
> Jonathan:
> Remove brackets
> Compress debug message
> Use temp var, r
> ---
>  drivers/resctrl/mpam_resctrl.c | 90 +++++++++++++++++++++++++++++++++-
>  1 file changed, 88 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 5481d9cc69d9..bc4f1c80eab5 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -60,10 +60,95 @@ struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
>  	return &mpam_resctrl_controls[l].resctrl_res;
>  }
>  
> +static bool cache_has_usable_cpor(struct mpam_class *class)
> +{
> +	struct mpam_props *cprops = &class->props;
> +
> +	if (!mpam_has_feature(mpam_feat_cpor_part, cprops))
> +		return false;
> +
> +	/* resctrl uses u32 for all bitmap configurations */
> +	return class->props.cpbm_wd <= 32;
> +}


