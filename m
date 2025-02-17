Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEB2228CB5
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739817244; cv=none; b=H28DKx7c8gajG9pFxSb38zwc6Kl2X2hO0vwii2JXfZUNaC3uBM5Bzxtf+1zYcJWX9g3LJ3O/Oqx8ZUH3e449zqk+1SZaJZMuKzDp84+id0VeFw1KCEokuBsvcN7CiwjLOMBMDajM9iCHyciYUvScU+oEmG23anpkGUKMLKtA454=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739817244; c=relaxed/simple;
	bh=ILBaAqX3F9w010PLuWuV44v6GN11eQdALlwIlrA03j8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OhvjX22YnWAmPHVP6reoIriypwWGLieqHOLeuAicEn9zvTjZWsFwUVTlGMCzVob/WaS0bK9uU8KFdx5EmnaiVAYLKbbUdWGfLLbR5RMvkadq/gsFJiv5LVDsDiaj2gpK18I5PywohIcHvmcsxx6Q715vH0g/fwoSPX/ioDMV0qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DgelPW79; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DgelPW79"
Date: Mon, 17 Feb 2025 10:33:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739817239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bcPdxFcb33s5H/lSz7aod/XVRrgxob83VusfbdiS5+k=;
	b=DgelPW79Bi/qWwXp7/3P5Vj+fQJ/IZumavtumu1L/V518EDxoQCZcwNRBo8LyAEPQS1mPX
	fpLGAH6kR5EF4sA2y4UDBST4dGORS2iVnxk0e28M/P+ISRXDoOpKZtu/Rnl3+1K5wX/UaI
	wj8Kkw0ZXLaFpMqpcgVmxPweidZE540=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Contextualise the handling of PMCR_EL0.P
 writes
Message-ID: <Z7OBBUKeynOeHlS7@linux.dev>
References: <20250217112412.3963324-1-maz@kernel.org>
 <20250217112412.3963324-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217112412.3963324-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 17, 2025 at 11:24:12AM +0000, Marc Zyngier wrote:
> Contrary to what the comment says in kvm_pmu_handle_pmcr(),
> writing PMCR_EL0.P==1 has the following effects:
> 
> <quote>
> The event counters affected by this field are:
>   * All event counters in the first range.
>   * If any of the following are true, all event counters in the second
>     range:
>     - EL2 is disabled or not implemented in the current Security state.
>     - The PE is executing at EL2 or EL3.
> </quote>
> 
> where the "first range" represent the counters in the [0..HPMN-1]
> range, and the "second range" the counters in the [HPMN..MAX] range.
> 
> It so appears that writing P from EL2 should nuke all counters,
> and not just the "guest" view. Just do that, and nuke the misleading
> comment.
> 
> Reported-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
