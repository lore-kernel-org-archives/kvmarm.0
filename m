Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E8C45BFD
	for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 18:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717093753; cv=none; b=d9xv2YNzYjBqdj8/uGlfLLcMf46OhJVS/T3Ry6/BBdyydNqDAczUvXif2k9qTVQoCT6NhJ5bbQo1B3weD+eLm7ERBrqHxWBqTz2acnUjy3Ucp2s8Tc9fAV7V9kkTg98w5mgv+tBKI7o+Xnz50ppw/CobFzdi/Sz87A6yp/7KVqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717093753; c=relaxed/simple;
	bh=p5tfEDgwn3gLscRn2VV7qSazxZgGwkmNuXJUGLPcxYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsBCGx3XhtZYghr2xyBCz6tNO3w/PqREpZ9HuAXJN8zctnlwT8UT09daP6t7JQxr/oVwp3vHIeeDWuNiKsJiMiJXUPThO7O6HRf5K3mNbj5Je27eLlEcrtex9Ri9fLx+RfuPuOvs8rAknAX2VMX0LWnyciAklZ0fYVvkp/ssPBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AEipEeXu; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AEipEeXu"
X-Envelope-To: tabba@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717093747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PeAgmjn5IEACX7K92jA1NBjW3rCZLJV/wTFP7BhdnP8=;
	b=AEipEeXuRQWm2QfZLSln2k5InoPtxiwJh9ixoVfo8HZc5WlDZg4phE73B2SBMH0G89WOwt
	ywkFpR4blrEHUOWV5MO+Q1DtOzVMiK4UW/KYekuDHf053xnanjtFYiP+/TgqeWdRavbZjB
	cLRnH1/kejXB0ktmiJOIymNN34KKeAc=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: qperret@google.com
X-Envelope-To: seanjc@google.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: philmd@linaro.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: broonie@kernel.org
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: rananta@google.com
X-Envelope-To: yuzenghui@huawei.com
Date: Thu, 30 May 2024 11:29:00 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 00/11] KVM: arm64: Fix handling of host fpsimd/sve
 state in protected mode
Message-ID: <ZljFbNcVgYb5Q7KH@linux.dev>
References: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 28, 2024 at 01:59:03PM +0100, Fuad Tabba wrote:
> Changes since v2 [1]
> - Rebased on Linux 6.10-rc1 (1613e604df0c)
> - Apply suggestions/fixes suggested for V2 (Marc)
> - Add an isb() to __hyp_sve_restore_guest()
> - Squash patch that introduces kvm_host_sve_max_vl with following
>   patch, since it's used there
> - Some refactoring and tidying up
> - Introduce and use sve_cond_update_zcr_vq_isb(), which only does
>   an isb() if ZCR is updated (RFC, next to last patch)
> - Remove sve_cond_update_zcr_vq_*, since it's not likely to help
>   much (RFC, last patch)
> 
> With the KVM host data rework [2], handling of fpsimd and sve
> state in protected mode is done at hyp. For protected VMs, we
> don't want to leak any guest state to the host, including whether
> a guest has used fpsimd/sve.
> 
> To complete the work started with the host data rework, in
> regards to protected mode, ensure that the host's fpsimd context
> and its sve context are restored on guest exit, since the rework
> has hidden the fpsimd/sve state from the host.
> 
> This patch series eagerly restores the host fpsimd/sve state on
> guest exit when running in protected mode, which happens only if
> the guest has used fpsimd/sve. This means that the saving of the
> state is lazy, similar to the behavior of KVM in other modes, but
> the restoration of the host state is eager.
> 
> The last two patches are not essential to this patch series, and
> the last one undoes the next-to-last. Please consider only one
> (or neither) of these two patches for inclusion.

For patches 1-7 (with the unnecessary isb()'s addressed):

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

I think we can do without the rest of the series for 6.10.

I also tested this on Neoverse V2.

-- 
Thanks,
Oliver
