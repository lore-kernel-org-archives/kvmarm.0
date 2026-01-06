Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4FE233149
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767712160; cv=none; b=RSc6jXZeI8i46OfyNLKX2y+mDZKCVTthoeEzQDFCOGkPx7/TPpdkdpaOKzJVASEPW+BVAQiJx/Aot6lDDtjA5GadR5bTClOuzZia0RLXmTNUedYE5KaXCRDCW8aGBklbKeslMblDP9qusvWd4uCW3AogK6kmjL9fGj+Z0Dtd4x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767712160; c=relaxed/simple;
	bh=VLDxT8b0UWtlbuOXC0YolSOK8Z20JQLPGrMeLewuo8A=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gcgw+AbqvW4UWsNVgvcrQKEPN30A/vEMWs/NICUQ8gKbOzXb5JDwHH53/WaHTnJFjOQTA4Ous17T7egk/emqMh3Xfjz65okVML+DzKgx0TfW/flH9KVK4KmSr8x8Yol8OAqHxIxzoZd93kC5e4crSZQkNTs9/Qkp/un4xCJjVCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlvhN685qzHnHBX;
	Tue,  6 Jan 2026 23:09:08 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3B2D940086;
	Tue,  6 Jan 2026 23:09:13 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 15:09:11 +0000
Date: Tue, 6 Jan 2026 15:09:07 +0000
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
	"Zeng Heng" <zengheng4@huawei.com>
Subject: Re: [PATCH v2 40/45] arm_mpam: Generate a configuration for min
 controls
Message-ID: <20260106150907.0000457b@huawei.com>
In-Reply-To: <20251219181147.3404071-41-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-41-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:42 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> MPAM supports a minimum and maximum control for memory bandwidth. The
> purpose of the minimum control is to give priority to tasks that are below
> their minimum value. Resctrl only provides one value for the bandwidth
> configuration, which is used for the maximum.
> 
> The minimum control is always programmed to zero on hardware that supports
> it.
> 
> Generate a minimum bandwidth value that is 5% lower than the value provided
> by resctrl. This means tasks that are not receiving their target bandwidth
> can be prioritised by the hardware.

I'm not sure this policy make sense in general as there will be bandwidth
heavy background tasks where we want to make sure they only use up to X%
of bandwidth, but don't care if they don't get that.  I guess maybe those
are always in the %5 or less category so maybe this policy is fine.
Ah well, can revisit later I guess as long as we keep this as the default
for any new controls.

> 
> For component reset reuse the same calculation so that the default is a
> value resctrl can set.
> 
> CC: Zeng Heng <zengheng4@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Most, maybe all the other cases have split test from implementation. I'd
probably do that here just for consistency.

A few things inline.

J



> ---
> Add reset_mbw_min
> Clear min cfg when setting max
> use mpam_extend_config on component reset
> ---
>  drivers/resctrl/mpam_devices.c      | 76 +++++++++++++++++++++++++++--
>  drivers/resctrl/mpam_internal.h     |  3 ++
>  drivers/resctrl/mpam_resctrl.c      |  2 +
>  drivers/resctrl/test_mpam_devices.c | 66 +++++++++++++++++++++++++
>  4 files changed, 142 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index c20b2757b86b..deea46c2a6c3 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -721,6 +721,13 @@ static void mpam_ris_hw_probe(struct mpam_msc_ris *ris)
>  			mpam_set_feature(mpam_feat_mbw_part, props);
>  
>  		props->bwa_wd = FIELD_GET(MPAMF_MBW_IDR_BWA_WD, mbw_features);
> +
> +		/*
> +		 * The BWA_WD field can represent 0-63, but the control fields it
> +		 * describes have a maximum of 16 bits.

I'm lost to why this only matters now!  Feels like that makes sense way earlier
in the series. Particularly as that detail confused me no end in the bandwidth
/ percent calculation patches.

> +		 */
> +		props->bwa_wd = min(props->bwa_wd, 16);
> +
>  		if (props->bwa_wd && FIELD_GET(MPAMF_MBW_IDR_HAS_MAX, mbw_features))
>  			mpam_set_feature(mpam_feat_mbw_max, props);
>  

> +static void mpam_extend_config(struct mpam_class *class, struct mpam_config *cfg)
> +{
> +	struct mpam_props *cprops = &class->props;
> +	u16 min, min_hw_granule, delta;
> +	u16 max_hw_value, res0_bits;

Probably makes sense to drag some of these into the scope below.

> +
> +	/*
> +	 * MAX and MIN should be set together. If only one is provided,
> +	 * generate a configuration for the other. If only one control
> +	 * type is supported, the other value will be ignored.
> +	 *
> +	 * Resctrl can only configure the MAX.
> +	 */
> +	if (mpam_has_feature(mpam_feat_mbw_max, cfg) &&
> +	    !mpam_has_feature(mpam_feat_mbw_min, cfg)) {
> +		/*
> +		 * Calculate the values the 'min' control can hold.
> +		 * e.g. on a platform with bwa_wd = 8, min_hw_granule is 0x00ff
> +		 * because those bits are RES0. Configurations of this value
> +		 * are effectively zero. But configurations need to saturate
> +		 * at min_hw_granule on systems with mismatched bwa_wd, where
> +		 * the 'less than 0' values are implemented on some MSC, but
> +		 * not others.
> +		 */
> +		res0_bits = 16 - cprops->bwa_wd;
> +		max_hw_value = ((1 << cprops->bwa_wd) - 1) << res0_bits;
> +		min_hw_granule = ~max_hw_value;
> +
> +		delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
> +		if (cfg->mbw_max > delta)
> +			min = cfg->mbw_max - delta;
> +		else
> +			min = 0;
> +
> +		cfg->mbw_min = max(min, min_hw_granule);
> +		mpam_set_feature(mpam_feat_mbw_min, cfg);
> +	}
> +}
> +
>
