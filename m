Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73D426F2A0
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768315605; cv=none; b=coUjpYdiwLJpX7Ak4o8MdEMwdOBY4B5ns0mWI3Wg2mwDhmIFHgSdujsIVjbb/FOV1W5ikRJRiVjOH52SxeaEWhdJras1cJsVD+8BEKgbP7ZJNIFjGu0LEFDsZRc5AycCGRyjlYo4zLwYFjUgyVYPf5h7iS1Spygs5a48RpsPgp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768315605; c=relaxed/simple;
	bh=VCbuO+RJ3ABLCOsIw1ZgtCERkhDuURt6rYlcpgk/Tzw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u0NOl6FY+Fw+aOqljHJTGjTqVU5N9tdhq10k20JZZDh3Vs7ba4cB+jZF10elDkczjsjNnJCz2ohYw2OK5YjsblSXOtQs32V/MY8TQDe5RtJs5GLnZnrr/IXyu3dOq9jNh5v98cloATvp2CBUDzJGX+0zHcfp1yhoISTzdsUt/dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4drBrx25g6zJ46D8;
	Tue, 13 Jan 2026 22:46:25 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 6D52B4056B;
	Tue, 13 Jan 2026 22:46:38 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 13 Jan
 2026 14:46:36 +0000
Date: Tue, 13 Jan 2026 14:46:35 +0000
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
Subject: Re: [PATCH v3 17/47] arm_mpam: resctrl: Implement
 resctrl_arch_reset_all_ctrls()
Message-ID: <20260113144635.00000755@huawei.com>
In-Reply-To: <20260112165914.4086692-18-ben.horgan@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
	<20260112165914.4086692-18-ben.horgan@arm.com>
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

On Mon, 12 Jan 2026 16:58:44 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> We already have a helper for resetting an mpam class and component.  Hook
> it up to resctrl_arch_reset_all_ctrls() and the domain offline path.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

There was a question from Zhengheng on v2 that doesn't seem to be addressed
and I'm not seeing a reply on list.  Maybe an email snafu?

https://lore.kernel.org/all/20260109034506.1176234-1-zengheng4@huawei.com/

Please +CC zhengheng on future versions if we need them!

Thanks,

Jonathan

> ---
> Changes since v2:
> Don't expose unlocked reset
> ---
>  drivers/resctrl/mpam_devices.c  |  4 ++--
>  drivers/resctrl/mpam_internal.h |  6 ++++++
>  drivers/resctrl/mpam_resctrl.c  | 15 +++++++++++++++
>  3 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index b81d5c7f44ca..0dd7f613f7a3 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -2544,7 +2544,7 @@ static void mpam_enable_once(void)
>  	       mpam_partid_max + 1, mpam_pmg_max + 1);
>  }
>  
> -static void mpam_reset_component_locked(struct mpam_component *comp)
> +void mpam_reset_component_locked(struct mpam_component *comp)
>  {
>  	struct mpam_vmsc *vmsc;
>  
> @@ -2568,7 +2568,7 @@ static void mpam_reset_component_locked(struct mpam_component *comp)
>  	}
>  }
>  
> -static void mpam_reset_class_locked(struct mpam_class *class)
> +void mpam_reset_class_locked(struct mpam_class *class)
>  {
>  	struct mpam_component *comp;
>  
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index e394ee78918a..f89ceaf7623d 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -393,6 +393,12 @@ extern u8 mpam_pmg_max;
>  void mpam_enable(struct work_struct *work);
>  void mpam_disable(struct work_struct *work);
>  
> +/* Reset all the RIS in a class under cpus_read_lock() */
> +void mpam_reset_class_locked(struct mpam_class *class);
> +
> +/* Reset all the RIS in a component under cpus_read_lock() */
> +void mpam_reset_component_locked(struct mpam_component *comp);
> +
>  int mpam_apply_config(struct mpam_component *comp, u16 partid,
>  		      struct mpam_config *cfg);
>  
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 1566d0c686e6..683bdd6989d4 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -169,6 +169,19 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
>  	return comp->comp_id;
>  }
>  
> +void resctrl_arch_reset_all_ctrls(struct rdt_resource *r)
> +{
> +	struct mpam_resctrl_res *res;
> +
> +	lockdep_assert_cpus_held();
> +
> +	if (!mpam_is_enabled())
> +		return;
> +
> +	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
> +	mpam_reset_class_locked(res->class);
> +}
> +
>  static void mpam_resctrl_domain_hdr_init(int cpu, struct mpam_component *comp,
>  					 struct rdt_domain_hdr *hdr)
>  {
> @@ -352,6 +365,8 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
>  			continue;
>  
>  		if (exposed_alloc_capable) {
> +			mpam_reset_component_locked(dom->ctrl_comp);
> +
>  			ctrl_d = &dom->resctrl_ctrl_dom;
>  			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
>  			if (ctrl_dom_empty)

