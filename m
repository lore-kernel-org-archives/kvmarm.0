Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F17F412BED
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789109121; cv=none; b=XdiN2NbRF4HXtuqr/HTONyxDjwoPLquIahGfpgf4cK+HN0P9MOOZ9If9Jq6OFknH8JEsEPoDWULyAcOwzeu9Fhs52PyuXBC2iQ8PLcU/FcsoBVqHRW+5m8B0EeK4VF26IqOQLbpyUYphchOZFHCCjjCcbODd/tMNxe+VW8oFEZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789109121; c=relaxed/simple;
	bh=W1lWyTR9TQELRjUZzDM3zaPLgGVyw3UieRYuB72Jvz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=l6zwe+lbI8qReLHdI4I7F91NRUVUd8Peeg0Qc+E3DqcFOvzc5XVYOCVQxTq/5Jc9Zq8thQhZGoCqawCCtP92DQc5q19MItRD9nAh3g3DqOK3oe1UaKQU5rtspmCgnCb91//tIaCZ+j3CEbmO019W5wimL6WaFhuK1MUXt33PzFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Qx9AWqzd; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Qx9AWqzd; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Qx9AWqzd";
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Qx9AWqzd"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SnNyIUKsorVAxqnwfpbUZwRMslljnk+vTb4CfKa2qOg=;
	b=Qx9AWqzdHat03JckLm3M8BwOru2v7x0iL94Pntu/72z8LkNpVGJ0CuQsvObLbQQZKy7qxI+f7
	POuCv4NaoAy2ApgQCxpmYgcqAwymFuufmDUhl++spML+a+SLlMEmg5rpQS//Ncrukr4XM5cLTau
	hBIxU4k/6aa13wBQtOpnpjM=
Received: from canpmsgout06.his.huawei.com (unknown [172.19.92.157])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4hh4l43cv7z1BFxK
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 14:44:00 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SnNyIUKsorVAxqnwfpbUZwRMslljnk+vTb4CfKa2qOg=;
	b=Qx9AWqzdHat03JckLm3M8BwOru2v7x0iL94Pntu/72z8LkNpVGJ0CuQsvObLbQQZKy7qxI+f7
	POuCv4NaoAy2ApgQCxpmYgcqAwymFuufmDUhl++spML+a+SLlMEmg5rpQS//Ncrukr4XM5cLTau
	hBIxU4k/6aa13wBQtOpnpjM=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hh4WT0hVGzRhQs;
	Fri, 11 Sep 2026 14:33:57 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 4382940579;
	Fri, 11 Sep 2026 14:44:50 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemk200008.china.huawei.com (7.202.194.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 14:44:48 +0800
Message-ID: <7500ec7f-5e65-408c-a4ed-3f7af161219b@huawei.com>
Date: Fri, 11 Sep 2026 14:44:47 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/40] arm_mpam: Reset when feature configuration bit
 unset
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
	<zengheng4@huawei.com>, <linux-doc@vger.kernel.org>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-3-ben.horgan@arm.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20260313144617.3420416-3-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/3/13 22:45, Ben Horgan 写道:
> To indicate that the configuration, of the controls used by resctrl, in a
> RIS need resetting to driver defaults the reset flags in mpam_config are
> set. However, these flags are only ever set temporarily at RIS scope in
> mpam_reset_ris() and hence mpam_cpu_online() will never reset these
> controls to default. As the hardware reset is unknown this leads to unknown
> configuration when the control values haven't been configured away from the
> defaults.
> 
> Use the policy that an unset feature configuration bit means reset. In this
> way the mpam_config in the component can encode that it should be in reset
> state and mpam_reprogram_msc() will reset controls as needed.
> 
> Fixes: 09b89d2a72f3 ("arm_mpam: Allow configuration to be applied and restored during cpu online")
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> This goes back to the initial feature configuration policy that James
> used in the MPAM base driver rfc but I unfortunately
> suggested him to change it.
> ---
>  drivers/resctrl/mpam_devices.c | 40 ++++++++++------------------------
>  1 file changed, 12 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index 0fd6590a9b5c..ff861291bd4e 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -1364,17 +1364,15 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
>  		__mpam_intpart_sel(ris->ris_idx, partid, msc);
>  	}
>  
> -	if (mpam_has_feature(mpam_feat_cpor_part, rprops) &&
> -	    mpam_has_feature(mpam_feat_cpor_part, cfg)) {
> -		if (cfg->reset_cpbm)
> -			mpam_reset_msc_bitmap(msc, MPAMCFG_CPBM, rprops->cpbm_wd);
> -		else
> +	if (mpam_has_feature(mpam_feat_cpor_part, rprops)) {
> +		if (mpam_has_feature(mpam_feat_cpor_part, cfg))
>  			mpam_write_partsel_reg(msc, CPBM, cfg->cpbm);
> +		else
> +			mpam_reset_msc_bitmap(msc, MPAMCFG_CPBM, rprops->cpbm_wd);
>  	}
>  
> -	if (mpam_has_feature(mpam_feat_mbw_part, rprops) &&
> -	    mpam_has_feature(mpam_feat_mbw_part, cfg)) {
> -		if (cfg->reset_mbw_pbm)
> +	if (mpam_has_feature(mpam_feat_mbw_part, rprops)) {
> +		if (mpam_has_feature(mpam_feat_mbw_part, cfg))
>  			mpam_reset_msc_bitmap(msc, MPAMCFG_MBW_PBM, rprops->mbw_pbm_bits);

This condition is written backwards, but it looks like it has already
been fixed later.

Otherwise, LGTM
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>

>  		else
>  			mpam_write_partsel_reg(msc, MBW_PBM, cfg->mbw_pbm);
> @@ -1384,16 +1382,14 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
>  	    mpam_has_feature(mpam_feat_mbw_min, cfg))
>  		mpam_write_partsel_reg(msc, MBW_MIN, 0);
>  
> -	if (mpam_has_feature(mpam_feat_mbw_max, rprops) &&
> -	    mpam_has_feature(mpam_feat_mbw_max, cfg)) {
> -		if (cfg->reset_mbw_max)
> -			mpam_write_partsel_reg(msc, MBW_MAX, MPAMCFG_MBW_MAX_MAX);
> -		else
> +	if (mpam_has_feature(mpam_feat_mbw_max, rprops)) {
> +		if (mpam_has_feature(mpam_feat_mbw_max, cfg))
>  			mpam_write_partsel_reg(msc, MBW_MAX, cfg->mbw_max);
> +		else
> +			mpam_write_partsel_reg(msc, MBW_MAX, MPAMCFG_MBW_MAX_MAX);
>  	}
>  
> -	if (mpam_has_feature(mpam_feat_mbw_prop, rprops) &&
> -	    mpam_has_feature(mpam_feat_mbw_prop, cfg))
> +	if (mpam_has_feature(mpam_feat_mbw_prop, rprops))
>  		mpam_write_partsel_reg(msc, MBW_PROP, 0);
>  
>  	if (mpam_has_feature(mpam_feat_cmax_cmax, rprops))
> @@ -1491,16 +1487,6 @@ static int mpam_save_mbwu_state(void *arg)
>  	return 0;
>  }
>  
> -static void mpam_init_reset_cfg(struct mpam_config *reset_cfg)
> -{
> -	*reset_cfg = (struct mpam_config) {
> -		.reset_cpbm = true,
> -		.reset_mbw_pbm = true,
> -		.reset_mbw_max = true,
> -	};
> -	bitmap_fill(reset_cfg->features, MPAM_FEATURE_LAST);
> -}
> -
>  /*
>   * Called via smp_call_on_cpu() to prevent migration, while still being
>   * pre-emptible. Caller must hold mpam_srcu.
> @@ -1508,14 +1494,12 @@ static void mpam_init_reset_cfg(struct mpam_config *reset_cfg)
>  static int mpam_reset_ris(void *arg)
>  {
>  	u16 partid, partid_max;
> -	struct mpam_config reset_cfg;
> +	struct mpam_config reset_cfg = {};
>  	struct mpam_msc_ris *ris = arg;
>  
>  	if (ris->in_reset_state)
>  		return 0;
>  
> -	mpam_init_reset_cfg(&reset_cfg);
> -
>  	spin_lock(&partid_max_lock);
>  	partid_max = mpam_partid_max;
>  	spin_unlock(&partid_max_lock);

