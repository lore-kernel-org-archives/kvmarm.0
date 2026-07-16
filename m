Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AD7435510;
	Thu, 16 Jul 2026 14:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212123; cv=none; b=rWVgDLxOA6q6xa/EWBEleR7N+9OQ3ZF6TY2yvfbSZdXRV4Relq0vNuR4tAytj1y0AVG0LVwLzLrceg9QwtEuFy+N5/PjvHuFvMaegQknjyws6kTPtV+zO07oNYUWej0PhqhqLS8GsRJ4wOVCyEnYwd4VWb45GEnVum8Cx9tubeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212123; c=relaxed/simple;
	bh=5Uk2PY4Lj++amnu52en5Z6jdDKcwXOAFZLyV3UpjbFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j09sqG9SXXGuAD/yim8ssw+Fq1WNki11ZUBTO5mO7nhEWtVuaAxW/lDkb/5jI/QkPpKpxE29OdsaCqOMJU+ioneTZZZe7wcEKRTjOo1AuGqxxSYm+pcE/Qj4XV8L8oUAnWgCHjMi0FNX2O3PCmv2azVSGYpxG3OMFD8cpqo7QUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hqvTWOjs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hqvTWOjs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 229C61476;
	Thu, 16 Jul 2026 07:28:36 -0700 (PDT)
Received: from [10.1.25.27] (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99EBF3F7B4;
	Thu, 16 Jul 2026 07:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784212120; bh=5Uk2PY4Lj++amnu52en5Z6jdDKcwXOAFZLyV3UpjbFc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hqvTWOjsQDjciD+fGSl4gJ/Sb43qq5h14HJ+xG3ZrpNdy8YxGCUEca4W4Pis/WcUd
	 jyLFHozV1f9XK+f0Bqda+eorV4GVAdincoOJZV+ylC3soy+d1fL8/L6mzm0Ww3tJd1
	 uAaP+Fu9KlC0NKuE3IflRdFef5KCcNw90lX5tJdE=
Message-ID: <aed16689-a3c6-4f6d-9b92-1d703ef85bc1@arm.com>
Date: Thu, 16 Jul 2026 15:28:38 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] firmware: arm_rmm: Add wrappers for direct RMI calls
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-3-steven.price@arm.com>
 <20260715144915.5771F1F000E9@smtp.kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260715144915.5771F1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/07/2026 15:49, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Uninitialized stack variable read in `rmi_granule_tracking_get` and `rmi_features` on systems without SMCCC conduit.
> --
> 
> --- Patch [2]: [PATCH 2/6] firmware: arm_rmm: Add wrappers for direct RMI calls ---
> commit 429eeeda61aa453a82790a92c189fa7325a46943
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Add wrappers for direct RMI calls
> 
> This commit adds inline wrapper functions for direct RMI calls to the Realm
> Management Monitor (RMM) via SMCCC, dealing with boilerplate and return codes.
> 
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> new file mode 100644
>> index 0000000000000..c038c1d685fad
>> --- /dev/null
>> +++ b/include/linux/arm-rmi-cmds.h
> 
> [ ... ]
> 
>> +static inline int rmi_granule_tracking_get(unsigned long start,
>> +					   unsigned long end,
>> +					   unsigned long *out_category,
>> +					   unsigned long *out_state,
>> +					   unsigned long *out_top)
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_TRACKING_GET, start, end, &res);
>> +
>> +	if (out_category)
>> +		*out_category = res.a1;
>> +	if (out_state)
>> +		*out_state = res.a2;
>> +	if (out_top)
>> +		*out_top = res.a3;
> 
> [Severity: Medium]
> Could this copy uninitialized stack memory into the caller's output pointers
> if the SMCCC conduit is unavailable?
> 
> When arm_smccc_1_1_invoke is executed on a platform without an active
> conduit, it falls back to __fail_smccc_1_1():
> 
> include/linux/arm-smccc.h:arm_smccc_1_1_invoke() {
>         ...
>         default:
>                 __fail_smccc_1_1(__VA_ARGS__);
>                 method = SMCCC_CONDUIT_NONE;
>                 break;
>         ...
> }
> 
> This fallback only initializes res.a0 to SMCCC_RET_NOT_SUPPORTED, leaving
> res.a1, res.a2, and res.a3 completely uninitialized.
> 
> Because these values are read unconditionally here, this could trigger KMSAN
> warnings or leak stack garbage into the output pointers. Should these
> assignments be gated behind a check that res.a0 == RMI_SUCCESS?

Well the caller shouldn't access these return values if the call fails -
and the conduit failure case is just wrong (the conduit can't change and
we won't detect the RMM without the conduit). But it might have a point
that KMSAN could report a warning. So I'll tidy these up to only set the
out parameters if the function completes successfully. The callers still
need to avoid accessing the variables if the function fails, but
hopefully static analysis/AI tooling/KMSAN would identify the correct
culprit in those cases.

Steve

>> +
>> +	return res.a0;
>> +}
> 
> [ ... ]
> 
>> +static inline int rmi_features(unsigned long index, unsigned long *out)
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
>> +
>> +	if (out)
>> +		*out = res.a1;
> 
> [Severity: Medium]
> Does this have the same uninitialized memory read issue when the SMCCC
> conduit is not supported?
> 
>> +	return res.a0;
>> +}
> 

