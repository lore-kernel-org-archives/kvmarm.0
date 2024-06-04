Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470E484FC5
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 19:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717528671; cv=none; b=EnAA3PpJI96g5uC75i411R6kq7q5SYPN2xtBli6HfzLrZj3YzJ7Um4029MU2/wSXfzF/5ZireJvV+6z7K6ZuiUqQw3NtbP8Jvo+hxL5uhdu1J3PgoNE92FCQHX8e5767dTJKjSJVtzSY5F+iLMtQnStDJi+Pjtst0gsq0P0E90g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717528671; c=relaxed/simple;
	bh=KRAztcWiZ8YpnDUFZntL/bepzxhmQz1if9fPwSufqBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lKAQuPLHUjIqXlL9zHbRhbS4/UOXGF/wbynm97lI5lj6ePWrs4TOO7+jnKftx/KG+Cuug0pThL7t4WX+9ltu0XQHl+U4XDvb8hCm+riWCZhQiWjjg0GZLD2FQLq5lIvdaCCo8OLVyox+ivOkopL28e3Wc0jVkxnjcPoEVvaVIU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XRYRl1tQ; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XRYRl1tQ"
X-Envelope-To: broonie@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717528667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nZG8z3Pz30/HG+CdbBQquLuRRuC2lKE2oX6hSJa2byY=;
	b=XRYRl1tQjiEWpAEy4yfhRu68yQvlO6M4RRLsRJNr0eOvOvyihYYGmh2i7UG2GjGxHwAN+Q
	Be/6+g3n+rSrRAXBPqIOsAgjN20rCOs7SIuzVAMj2u27mVUvtinb4WCQslkAZ62lPcKNM6
	W9zJZyqEFvL6zzB1ctSqXV5udBm+CCk=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Tue, 4 Jun 2024 12:17:41 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix confusion in documentation for pKVM SME
 assert
Message-ID: <Zl9oVUriFDYbLFW8@linux.dev>
References: <20240604-kvm-arm64-sme-assert-v1-1-5d98348d00f8@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604-kvm-arm64-sme-assert-v1-1-5d98348d00f8@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hi,

On Tue, Jun 04, 2024 at 07:47:01PM +0100, Mark Brown wrote:
> As raised in the review comments for the original patch the assert and
> comment added in afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are
> disabled in protected mode") are bogus. The comments says that we check
> that we do not have SME enabled for a pKVM guest but the assert actually
> checks to see if the host has anything set in SVCR which is unrelated to
> the guest features or state, regardless of if those guests are protected
> or not.
> 
> What I believe the check is actually intended to validate is that we do
> not enter the pKVM hypervisor with SME enabled since the pKVM hypervisor
> does not yet understand SME and is therefore unable to save or restore
> host state with SME enabled, indeed attempting to save SVE state would
> fault if streaming mode is enabled on a system without FA64 due to FFR.
> Update the comment to reflect this.

The added context likely isn't necessary in what winds up getting
applied. Can this just directly state the WARN_ON() exists b/c the
protected mode hypervisor doesn't know how to manage SME state?

> Fixes: afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are disabled in protected mode")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 521b32868d0d..f720ba47b85c 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -92,8 +92,9 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  	}
>  
>  	/*
> -	 * If normal guests gain SME support, maintain this behavior for pKVM
> -	 * guests, which don't support SME.
> +	 * The pKVM hypervisor does not yet understand how to save or
> +	 * restore SME state for the host so double check that if we
> +	 * are running with pKVM we have disabled SME.
>  	 */
>  	WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
>  		read_sysreg_s(SYS_SVCR));

While we're here, this should be WARN_ON_ONCE() or WARN_RATELIMIT() if
we _really_ want some spam. But a single WARN ought to be enough.

It'd be a good idea to also document why we're testing for SME state
twice on the KVM_RUN path, as any WARN() in the hyp code is currently
fatal. I'm guessing Fuad meant to have a non-fatal way of getting some
debug information out.

-- 
Thanks,
Oliver
