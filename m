Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92342C11DE
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 15:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774626289; cv=none; b=KBmFrtJXOdLnUXXRASSu136onY10pNekmi5r2d5i4H1HMo73ELfq3MSxtEyj6piz+T5VvLb+sZrpj+h58iXE+CMXFyglKPJiqLEhTa9N/SVdyW52X/+EbbN8aGjA/iau1Hb6z+t0ZrGcdtoPDid5+3zEK7wyuCx9qdGpMOLrKnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774626289; c=relaxed/simple;
	bh=gYyaxvQ4I4LDpFFA8rjENTkcbOL6GQqU7RWhk1r/eV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VgKaoU6LpAWkjGvcm1oPK/uhgbKck7Top2ORXMsSESA+Bn48Uoqic0DvMokYi+3URQ+oPG/mMFcXOqIyU/tpHVoIDKAgi7EmrRIwz2t3da1W0xs7SGCblgObJzaiW+tA2jZHO4sKTNX/a7DfSw0y719y/VfjYumvscV+p4GqbI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WHeQx+2o; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WHeQx+2o"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45FFF35E6;
	Fri, 27 Mar 2026 08:44:41 -0700 (PDT)
Received: from [10.1.196.96] (eglon.cambridge.arm.com [10.1.196.96])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4C313F99C;
	Fri, 27 Mar 2026 08:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774626287; bh=gYyaxvQ4I4LDpFFA8rjENTkcbOL6GQqU7RWhk1r/eV0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WHeQx+2odybSQ9W+vmVFdjHEtHFJQiSxqT+I3tNHIzK45869BfJvc2bVpZBNd+HVf
	 EomQqhZjbSzRZzb7jU4NR7U8PS+3gLbRvhw6FGUm/VfFygEk2chAa/68+icUChKDgB
	 V+lEHEdMxfjJAS04EZbv0aM3fhyDhGljAeuM9o50=
Message-ID: <51b3ac37-0da6-4006-be1b-5fedcf24af0f@arm.com>
Date: Fri, 27 Mar 2026 15:44:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 21/40] arm_mpam: resctrl: Hide CDP emulation behind
 CONFIG_EXPERT
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
 <20260313144617.3420416-22-ben.horgan@arm.com>
Content-Language: en-GB
From: James Morse <james.morse@arm.com>
In-Reply-To: <20260313144617.3420416-22-ben.horgan@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ben,

On 13/03/2026 14:45, Ben Horgan wrote:
> When CDP is not enabled, the 'rmid_entry's in the limbo list,
> rmid_busy_llc, map directly to a (PARTID,PMG) pair and when CDP is enabled
> the mapping is to two different pairs.

> As the limbo list is reused between
> mounts and CDP disabled on unmount this can lead to stale mapping and the
> limbo handler will then make monitor reads with potentially out of range
> PARTID.

Bother - I missed that!


> This may then cause an MPAM error interrupt and the driver will
> disable MPAM.

... and that's why it's not a problem on x86 because the RMID range is unaffected by CDP,
whereas MPAM works on a combined value.


> No problems are expected if you just mount the resctrl file system
> once with CDP enabled and never unmount it.

(guess how it was tested!)


> Hide CDP emulation behind CONFIG_EXPERT to protect the unwary.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Adding this ugliness in the hope of avoiding patch churn and extra
> reviewer work. I am looking into the resctrl changes needed to fix this.

Makes sense - people can still use this if they're aware of the limitation, and it sounds
like you've got a plan to fix it properly. We just don't want it enabled in distros until
then.


> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 903d1a0f564f..cab3e9ccb5c7 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -82,6 +82,18 @@ int resctrl_arch_set_cdp_enabled(enum resctrl_res_level rid, bool enable)
>  	u32 partid_i = RESCTRL_RESERVED_CLOSID, partid_d = RESCTRL_RESERVED_CLOSID;
>  	int cpu;
>  
> +	if (!IS_ENABLED(CONFIG_EXPERT) && enable) {
> +		/*
> +		 * If the resctrl fs is mounted more than once, sequentially,
> +		 * then CDP can lead to the use of out of range PARTIDs.
> +		 */
> +		pr_warn("CDP not supported\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (enable)
> +		pr_warn("CDP is an expert feature and may cause MPAM to malfunction.\n");
> +
>  	/*
>  	 * resctrl_arch_set_cdp_enabled() is only called with enable set to
>  	 * false on error and unmount.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
