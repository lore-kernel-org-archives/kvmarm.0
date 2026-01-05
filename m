Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED4E2DECD2
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 17:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767635523; cv=none; b=kZ2SALm7nW7R7mNflI09HzksJhWcvVZHvPbt2xobfBUJ+Sg7jAwJz/7AWon9ZjpYjjAILi5nB8r4PunP1Wrcklu3Pf+b166P9ZtnAq+VBjCDGyvOeDUVqPqAzITBX+SrIwZcf7IIF2m6eKrRbnEVziPm6DIAqEcDCf8cKvjbh5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767635523; c=relaxed/simple;
	bh=LBaqNOUvJUDb1AE/QeN7ujW6aayBLriDnr/e6s426pk=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SuoPYmtwrJDrwQHSpkjzFH25jODuvJcvqHSTgR6Ty4EQ0Zp3U39GV2G6+9uCKVic2tqbQzGYo6LwZBiuo2QZmPLVXXhRJjtfOJvJvymvn9iGA+1HTNtSEMmFw5VhhQFfwPD1RgAwgFbiHnWqwys0MKcechj7eoX9SRA1EZayWHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlMLj6533zJ46Bv;
	Tue,  6 Jan 2026 01:51:57 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 211424057E;
	Tue,  6 Jan 2026 01:51:58 +0800 (CST)
Received: from localhost (10.126.174.38) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 5 Jan
 2026 17:51:56 +0000
Date: Mon, 5 Jan 2026 17:51:54 +0000
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
Subject: Re: [PATCH v2 18/45] arm_mpam: resctrl: Implement
 resctrl_arch_reset_all_ctrls()
Message-ID: <20260105175154.00002041@huawei.com>
In-Reply-To: <20251219181147.3404071-19-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-19-ben.horgan@arm.com>
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

On Fri, 19 Dec 2025 18:11:20 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> We already have a helper for resetting an mpam class and component.  Hook
> it up to resctrl_arch_reset_all_ctrls() and the domain offline path.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
I left all the context as my one comment on this is I don't see a reason
to expose mpam_reset_class()  Only the _locked() variant ever seems to be
used outside of mpam_devices.c

> ---
>  drivers/resctrl/mpam_devices.c  |  6 +++---
>  drivers/resctrl/mpam_internal.h |  7 +++++++
>  drivers/resctrl/mpam_resctrl.c  | 15 +++++++++++++++
>  3 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 303aacfcb9d6..4f5d908d02a9 100644
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
> @@ -2580,7 +2580,7 @@ static void mpam_reset_class_locked(struct mpam_class *class)
>  		mpam_reset_component_locked(comp);
>  }
>  
> -static void mpam_reset_class(struct mpam_class *class)
> +void mpam_reset_class(struct mpam_class *class)
>  {
>  	cpus_read_lock();
>  	mpam_reset_class_locked(class);
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 554e4887ba81..b9a739abb101 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -389,6 +389,13 @@ extern u8 mpam_pmg_max;
>  void mpam_enable(struct work_struct *work);
>  void mpam_disable(struct work_struct *work);
>  
> +/* Reset all the RIS in a class, optionally while holding cpus_read_lock() */
> +void mpam_reset_class_locked(struct mpam_class *class);
> +void mpam_reset_class(struct mpam_class *class);

Not clear from this patch why we need to expose mpam_reset_class()

> +
> +/* Reset all the RIS in a component under cpus_read_lock() */
> +void mpam_reset_component_locked(struct mpam_component *comp);
> +
>  int mpam_apply_config(struct mpam_component *comp, u16 partid,
>  		      struct mpam_config *cfg);
>  
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index bc4f1c80eab5..d32e87002457 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -167,6 +167,19 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
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
> @@ -353,6 +366,8 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
>  
>  		ctrl_dom_empty = true;
>  		if (exposed_alloc_capable) {
> +			mpam_reset_component_locked(dom->ctrl_comp);
> +
>  			ctrl_d = &dom->resctrl_ctrl_dom;
>  			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
>  			if (ctrl_dom_empty)

