Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D827E12D21B
	for <kvmarm@lists.linux.dev>; Sat, 14 Feb 2026 10:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771065570; cv=none; b=VRLrz2wHY4IZZK0aZw8TYYf8f3oZ4pAQtUUlTvXqyaZ7Xp1zknj/0B/ZQOmk2ERuzMaQuWNR+nqRwwDQ7uODvJAqi2vqzxBXGV94C9w5jMmvfbI9OINQKwYcxZ4M056+6uWVHi083LpUbr1QV/3CvN5XvCMpjLsfdPmyxG2K4W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771065570; c=relaxed/simple;
	bh=sPLF10rviX5QHJ7fbUtvjirPLdN6bgK9xYaNad3VxTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uIuqfv4zDO2yfUO/KH8PJ37/sstK5Ui+5ziC5XUjiUMTDIeyMdeYn+qmLImNyeIsyMj4IOoeUHCDVw2NJrwhhYJCNAPXE4QWeXY4uzNm52GyN3Q4AXJ8h6SJ0yyZ37xFxMbbTkNUHgTHx1KyY7yTQnP3cRtQuNe/Dbt4FMAcxm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=jc9U3vIL; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="jc9U3vIL"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Aio7AlfN0KVfF8lobk6QM+7dDyABk4CAwfG+ZnLAkzc=;
	b=jc9U3vILCps8irJIgBbLwO0Msnvx/RfUhVEBfVKBpl2Np6+lMEeEohDQgUwXBAbhLixONm7u4
	YShoO/BK+gDXs/4kmLylbRTRxOlscHKfj+frt2mLDmxozKXzUQ2r28DhpQC0eDo4B7u6WFT95qF
	pUhKHTYLOfzz+ka6MU2LI34=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fCllt3c5RzpStx;
	Sat, 14 Feb 2026 18:34:50 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id C06F24056E;
	Sat, 14 Feb 2026 18:39:18 +0800 (CST)
Received: from [10.174.178.24] (10.174.178.24) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Sat, 14 Feb 2026 18:39:16 +0800
Message-ID: <d7de359e-9bf3-e41d-b00d-985ca7263ad8@huawei.com>
Date: Sat, 14 Feb 2026 18:39:16 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 18/41] arm_mpam: resctrl: Implement helpers to update
 configuration
Content-Language: en-US
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<jonathan.cameron@huawei.com>, <kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-doc@vger.kernel.org>, Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-19-ben.horgan@arm.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20260203214342.584712-19-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf100008.china.huawei.com (7.202.181.222)

Hi Ben,

On 2026/2/4 5:43, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> resctrl has two helpers for updating the configuration.
> resctrl_arch_update_one() updates a single value, and is used by the
> software-controller to apply feedback to the bandwidth controls, it has to
> be called on one of the CPUs in the resctrl:domain.
> 
> resctrl_arch_update_domains() copies multiple staged configurations, it can
> be called from anywhere.
> 
> Both helpers should update any changes to the underlying hardware.
> 
> Implement resctrl_arch_update_domains() to use
> resctrl_arch_update_one(). Neither need to be called on a specific CPU as
> the mpam driver will send IPIs as needed.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> list_for_each_entry -> list_for_each_entry_rcu
> return 0
> Restrict scope of local variables
> 
> Changes since v2:
> whitespace fix
> ---
>   drivers/resctrl/mpam_resctrl.c | 70 ++++++++++++++++++++++++++++++++++
>   1 file changed, 70 insertions(+)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index ecf00386edca..48d047510089 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -212,6 +212,76 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>   	}
>   }
>   
> +int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
> +			    u32 closid, enum resctrl_conf_type t, u32 cfg_val)
> +{
> +	u32 partid;
> +	struct mpam_config cfg;
> +	struct mpam_props *cprops;
> +	struct mpam_resctrl_res *res;
> +	struct mpam_resctrl_dom *dom;
> +
> +	lockdep_assert_cpus_held();
> +	lockdep_assert_irqs_enabled();
> +
> +	/*
> +	 * No need to check the CPU as mpam_apply_config() doesn't care, and
> +	 * resctrl_arch_update_domains() relies on this.
> +	 */
> +	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
> +	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
> +	cprops = &res->class->props;
> +
> +	partid = resctrl_get_config_index(closid, t);


As a victim, I must admit I cannot verify this feedback on my local
Kunpeng environment since MB functionality is not yet supported by the
driver. However, after careful consideration, I believe this is worth
bringing up for discussion.

Regarding the MB configuration flow, the partid conversion should
include the mpam_resctrl_hide_cdp() condition check. Here's the
rationale:

After resctrl parsing schemata update, MB configuration is set via
parse_bw() or rdtgroup_init_mba(), which stores the updated
configuration in dom->staged_config[CDP_NONE]. If the MB configuration
update directly uses t = CDP_NONE, it would result in MB obtaining the
wrong partid and cfg[partid].

The specific fix would be like:

-       partid = resctrl_get_config_index(closid, t);
+       if (mpam_resctrl_hide_cdp(r->rid))
+		/* The configuration of CDP_DATA is same as the CDP_CODE one. */
+               partid = resctrl_get_config_index(closid, CDP_DATA);
+       else
+               partid = resctrl_get_config_index(closid, t);

Similarly, in resctrl_arch_get_config() requires the same treatment to
ensure consistency.


Best regards,
and happy Lunar New Year!

Zeng Heng


> +	if (!r->alloc_capable || partid >= resctrl_arch_get_num_closid(r)) {
> +		pr_debug("Not alloc capable or computed PARTID out of range\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Copy the current config to avoid clearing other resources when the
> +	 * same component is exposed multiple times through resctrl.
> +	 */
> +	cfg = dom->ctrl_comp->cfg[partid]; > +
> +	switch (r->rid) {
> +	case RDT_RESOURCE_L2:
> +	case RDT_RESOURCE_L3:
> +		cfg.cpbm = cfg_val;
> +		mpam_set_feature(mpam_feat_cpor_part, &cfg);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return mpam_apply_config(dom->ctrl_comp, partid, &cfg);
> +}
> +
> +int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid)
> +{
> +	int err;
> +	struct rdt_ctrl_domain *d;
> +
> +	lockdep_assert_cpus_held();
> +	lockdep_assert_irqs_enabled();
> +
> +	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list) {
> +		for (enum resctrl_conf_type t = 0; t < CDP_NUM_TYPES; t++) {
> +			struct resctrl_staged_config *cfg = &d->staged_config[t];
> +
> +			if (!cfg->have_new_ctrl)
> +				continue;
> +
> +			err = resctrl_arch_update_one(r, d, closid, t,
> +						      cfg->new_ctrl);
> +			if (err)
> +				return err;
> +		}
> +	}
> +
> +	return 0;
> +}
