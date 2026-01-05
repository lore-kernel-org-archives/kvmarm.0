Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAFD33AD87
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 17:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767634961; cv=none; b=mz/vMSbbrDWBJtMNYTf2WhXApjl08vpGwn0B2gP9Dsf982oNfPLTnHjz22x1cT6qZbKmQace37zET9IyW5x7c8+Zz9VYld3vc5Md8R20QL4JlLzjY3UtErrZvJ8e7tu7XnHiTZhJyb7mGntCp2voQR0AS0ZANSaYUT8TCTTiDZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767634961; c=relaxed/simple;
	bh=rNIrp7cJ4mWBCfnlRZ2/zU5msLgJCSRD8s1xbpNqFMY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WSEgNeOposTNDuFjCVzGW0AJYX5p+sLRmWc5UqXhAAZPeBzuaRhcBC3r1ckQA/FdozlEs9z35amVvbxUhi4h9i/f9/YeQb0BM7Zh3ExmBaIJTKzkVljcEUY7AwpM2jafoswwQ6Rf95bIu1xueGlURuBlJobpOnFz20lfUSqezxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlM7w1RF4zJ46BK;
	Tue,  6 Jan 2026 01:42:36 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 7566940086;
	Tue,  6 Jan 2026 01:42:36 +0800 (CST)
Received: from localhost (10.126.174.38) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 5 Jan
 2026 17:42:34 +0000
Date: Mon, 5 Jan 2026 17:42:33 +0000
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
Subject: Re: [PATCH v2 16/45] arm_mpam: resctrl: Sort the order of the
 domain lists
Message-ID: <20260105174233.00004df8@huawei.com>
In-Reply-To: <20251219181147.3404071-17-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-17-ben.horgan@arm.com>
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

On Fri, 19 Dec 2025 18:11:18 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> resctrl documents that the domains appear in numeric order in the schemata
> file. This means a little more work is needed when bringing a domain
> online.
> 
> Add the support for this, using resctrl_find_domain() to find the point to
> insert in the list.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
I guess this was split out to try and make previous patch easier to read.
I'm not sure I'd bother in this particular case as those TODOs were
ugly, but anyhow LGTM

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  drivers/resctrl/mpam_resctrl.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 4beeeded00ff..5481d9cc69d9 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -117,6 +117,21 @@ static bool mpam_resctrl_offline_domain_hdr(unsigned int cpu,
>  	return false;
>  }
>  
> +static void mpam_resctrl_domain_insert(struct list_head *list,
> +				       struct rdt_domain_hdr *new)
> +{
> +	struct rdt_domain_hdr *err;
> +	struct list_head *pos = NULL;
> +
> +	lockdep_assert_held(&domain_list_lock);
> +
> +	err = resctrl_find_domain(list, new->id, &pos);
> +	if (WARN_ON_ONCE(err))
> +		return;
> +
> +	list_add_tail_rcu(&new->list, pos);
> +}
> +
>  static struct mpam_resctrl_dom *
>  mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  {
> @@ -154,8 +169,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  		ctrl_d = &dom->resctrl_ctrl_dom;
>  		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &ctrl_d->hdr);
>  		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
> -		/* TODO: this list should be sorted */
> -		list_add_tail_rcu(&ctrl_d->hdr.list, &r->ctrl_domains);
> +		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
>  		err = resctrl_online_ctrl_domain(r, ctrl_d);
>  		if (err) {
>  			dom = ERR_PTR(err);
> @@ -169,8 +183,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  		mon_d = &dom->resctrl_mon_dom;
>  		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &mon_d->hdr);
>  		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
> -		/* TODO: this list should be sorted */
> -		list_add_tail_rcu(&mon_d->hdr.list, &r->mon_domains);
> +		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
>  		err = resctrl_online_mon_domain(r, mon_d);
>  		if (err) {
>  			dom = ERR_PTR(err);

