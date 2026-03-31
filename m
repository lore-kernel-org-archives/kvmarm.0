Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1588E2EA16A
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 10:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774952343; cv=none; b=NtNCvf5ZKSYekBFnYANWANHCd2+aEPfqKPYsxHanPFhFKSbFs0kYugBPNo0roSt/1F0wQt9RGgBaMNpybGjDtV8+42T4fW0E5xV4fhfQ7JlKmagxlM2Sj4uWST7rqKXnjIYvA98bUmkEpkRGvTB4cxfgWEIfn2YX2XjnhuqLCeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774952343; c=relaxed/simple;
	bh=LNkgaBupfNB4ugKnElfoJ44h22XXJr16J30q723B68I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfpryBcfzyPukBWlGAXsUjNBDTCrD0OWvsNkQr5raTM8c5hgyHzD8zwyxZUStf1By3GEATCzUffcIp8zGNcyy+wi3emVqEeTNP4jeUD9SsigNBE8YaJOfR9VJKa+P3NLq/lT7Kwg5chfWtCnfNL4V/alE1BEm0sIKJ+dtCRkoOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dW4blMzh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dW4blMzh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78351493B;
	Tue, 31 Mar 2026 03:18:55 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33DA53F7D8;
	Tue, 31 Mar 2026 03:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774952341; bh=LNkgaBupfNB4ugKnElfoJ44h22XXJr16J30q723B68I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dW4blMzh3hdGi0O/UAif71kYDtd9vMsbyLB53ph6vLXiQZkmRV/HJvfXfeRxwTEJG
	 VH/zVYXnni6n7T0IKeGEoD7fbWZ2ZrQSNzyRZehAfykH5TnJZcPP4bH55GKQQxSSdB
	 1E/htMhOcv4ljlwhSqdPrbTcgAlmCQN4SCnmembY=
Date: Tue, 31 Mar 2026 11:18:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: Don't populate TPIDR_EL2 in finalise_el2()
Message-ID: <acufjq_3NZGdv0hN@J2N7QTR9R3>
References: <20260330152927.26300-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330152927.26300-1-will@kernel.org>

On Mon, Mar 30, 2026 at 04:29:26PM +0100, Will Deacon wrote:
> When running with VHE, TPIDR_EL2 is only used for the percpu offset once
> the ARM64_HAS_VIRT_HOST_EXTN capability has been detected, at which
> point cpu_copy_el2regs() will populate its contents from TPIDR_EL1.
> 
> Remove the redundant initialisation of TPIDR_EL2 from finalise_el2().

It wasn't clear to me how this worked for both the boot CPU and
secondaries, since they both call finalise_el2(). How about a slightly
more elaborate commit message, e.g.

| Currently, it is not necessary for __finalise_el2() to configure
| TPIDR_EL2:
|
| * The hyp stub code does not consume the value of TPIDR_EL2.
|
| * On the boot cpu, TPIDR_EL1 is used for the percpu offset until the
|   ARM64_HAS_VIRT_HOST_EXTN cpucap is detected and boot alternatives
|   are patched. Before boot alternatives are patched,
|   cpu_copy_el2regs() will copy TPIDR_EL1 into TPIDR_EL2. It is not
|   necessary for __finalise_el2() to initialise TPIDR_EL2 before this.
|
| * Secondary CPUs are brought up after boot alternatives have been
|   patched, and __secondary_switched() will initialize TPIDR_EL2 in
|   'init_cpu_task', after finalise_el2() calls __finalise_el2()
|
| * KVM hyp code which may consume TPIDR_EL2 is brought up after all
|   secondaries have been booted, once TPIDR_El2 has been configured on
|   all CPUs.
|
| Remove the redundant initialisation from __finalise_el2().

> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
> 
> I spotted this by inspection as part of an ill-fated (abandoned) attempt
> at repurposing tpidr_elx for something else.
> 
>  arch/arm64/kernel/hyp-stub.S | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 085bc9972f6b..8b8614c0b9a5 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -105,11 +105,9 @@ SYM_CODE_START_LOCAL(__finalise_el2)
>  	msr_hcr_el2 x0
>  	isb
>  
> -	// Use the EL1 allocated stack, per-cpu offset
> +	// Use the EL1 allocated stack
>  	mrs	x0, sp_el1
>  	mov	sp, x0
> -	mrs	x0, tpidr_el1
> -	msr	tpidr_el2, x0
>  
>  	// FP configuration, vectors
>  	mrs_s	x0, SYS_CPACR_EL12
> -- 
> 2.53.0.1018.g2bb0e51243-goog
> 
