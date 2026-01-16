Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97777332EBA
	for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 11:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768564653; cv=none; b=HcCcIXSoEzwfJkwsLYzE0fXPuGPVmveUKJij7xp0zHafl+5kxe5gza06kItdVl2zpgJbBxaVVptjD+poe7EttBAilkVsjvVgraBOPXup+RoajnYcQzu+eUhPn8Dc0rbDNXBBT6YExdLzOTtIRRFBjPEUErFYFavZmVrV8PPI6v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768564653; c=relaxed/simple;
	bh=SKnRf9JLyc8Pd7m/TOJfHbLxu6+wxbvNwtz00TcKeE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JgRYoPnyir+VUBtsfmnsYUJrukgnTdFQ+Q2G3sSH5NIxca4zPLkYoBqhEaW+ARuxs/vMBALME/uXR9BIXYcuzi76Tn+Y6JPYw9ohoXu+BR6zeLyQmAcdy0ZWNeHBYq0DTsUE/cD9xVHDZqQjRSl6Oa2mWfCVm1VuVnQK/9iDpaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 649971515;
	Fri, 16 Jan 2026 03:57:25 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 55D763F694;
	Fri, 16 Jan 2026 03:57:28 -0800 (PST)
Date: Fri, 16 Jan 2026 11:57:25 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	peternewman@google.com, punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com, reinette.chatre@intel.com,
	rohit.mathew@arm.com, scott@os.amperecomputing.com,
	sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com, will@kernel.org, corbet@lwn.net,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 02/47] arm_mpam: Use non-atomic bitops when modifying
 feature bitmap
Message-ID: <aWonpc52-BMzcx8Q@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-3-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112165914.4086692-3-ben.horgan@arm.com>

On Mon, Jan 12, 2026 at 04:58:29PM +0000, Ben Horgan wrote:
> In the test__props_mismatch() kunit test we rely on the struct mpam_props
> being packed to ensure memcmp doesn't consider packing. Making it packed
> reduces the alignment of the features bitmap and so breaks a requirement
> for the use of atomics. As we don't rely on the set/clear of these bits
> being atomic, just make them non-atomic.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> Add comment (Jonathan)
> ---
>  drivers/resctrl/mpam_internal.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 17cdc3080d58..e8971842b124 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -200,8 +200,12 @@ struct mpam_props {
>  } PACKED_FOR_KUNIT;
>  
>  #define mpam_has_feature(_feat, x)	test_bit(_feat, (x)->features)
> -#define mpam_set_feature(_feat, x)	set_bit(_feat, (x)->features)
> -#define mpam_clear_feature(_feat, x)	clear_bit(_feat, (x)->features)
> +/*
> + * The non-atomic get/set operations are used because if struct mpam_props is
> + * packed, the alignment requirements for atomics aren't met.
> + */
> +#define mpam_set_feature(_feat, x)	__set_bit(_feat, (x)->features)
> +#define mpam_clear_feature(_feat, x)	__clear_bit(_feat, (x)->features)

After discussing privately, I can see how test__props_mismatch() can
end up with unaligned atomics on the mmap_props::features array. Happy to
pick it up for 6.19 (probably the first patch as well, though that's
harmless).

Is there a Fixes tag here for future reference?

-- 
Catalin
