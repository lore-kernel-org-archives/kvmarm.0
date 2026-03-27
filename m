Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8CE303A32
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 16:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774628515; cv=none; b=MWvFQ/ZyUJ/qS/fHDX049vsbhRn6WxfovcddlWBlYqXDJMvsDzz+O875MSCPMG3r8qXwwsaRJBBsbcy72JBoHZtHkxKxLpUGoGlLqSryGzZrR5dunGTjia06s3JyeZ2CJKfoBE7rFUWGfD1B5Jw0TlR5GPA8WBylvwFFzMJ99/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774628515; c=relaxed/simple;
	bh=rLD7D9hB1vO0sLYUWoaxiGJUNxnpjdOsHR7xPwiNSSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Eh+zH8RUQnuKfWMGS3sTAKbep+wjUdfCA+/+kP/US6Xla2N0dRzwLh7eTmwDSJJhKg7w0vF6U/v3CMIFlQW7lcFu7pSZiq+S2RL8KCgFAkaqzp/x3Jjhi2wEcDwAX7BgNFZ+lSPwLX0biuBYlgaQgn2e6RXbeGny/79Bawdyb3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WTF7+ykA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WTF7+ykA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1519935DA;
	Fri, 27 Mar 2026 09:21:47 -0700 (PDT)
Received: from [10.1.196.96] (eglon.cambridge.arm.com [10.1.196.96])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97B473F905;
	Fri, 27 Mar 2026 09:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774628513; bh=rLD7D9hB1vO0sLYUWoaxiGJUNxnpjdOsHR7xPwiNSSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WTF7+ykAX6sFkGCxVe4cCl1XX1yEyhecilKZP9eHWygbi8E6UJul45MEkX5osViHT
	 W4gwwyJaY1GKdrKh3aZBJQ0Fgm+87LVJR4T4avKhzuuSUykzsGzmia/9+wJVfNDHSs
	 LSg6891x++zHlA+u6CoJp0XIRcjq/Q1HQP4APU8k=
Message-ID: <27047c27-9479-4aed-937e-04db108526d7@arm.com>
Date: Fri, 27 Mar 2026 16:21:17 +0000
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
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-3-ben.horgan@arm.com>
Content-Language: en-GB
From: James Morse <james.morse@arm.com>
In-Reply-To: <20260313144617.3420416-3-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ben,

On 13/03/2026 14:45, Ben Horgan wrote:
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

After this, nothing reads/writes these explicit reset flags so they can be removed from
struct mpam_config.

(I'll do this locally)


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
>  		else
>  			mpam_write_partsel_reg(msc, MBW_PBM, cfg->mbw_pbm);

Reviewed-by: James Morse <james.morse@arm.com>


Thanks!

James
