Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD46E442B1D;
	Fri, 31 Jul 2026 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785516633; cv=none; b=di9TgH3cFq82xIypRU10Cpic5i5QL9BNT7VVPkzUHUCz5b3E84+bMG83oHiwr/o3uvmvpo7gICsl/iMJAI0zI9i75QBE81EPCvzLf4U6vP332RiReDP1jpA4KmgFpOt/Cq8lOBAOCkRzK2yE0SI/Wxh9pz4V1966U9ur3oN3GvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785516633; c=relaxed/simple;
	bh=9c9PLUvH30dXfqYjdoYJIcXUdiGZ2eaDs8yIsaJP7TI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aH1ReI0r8yu/bbKO5Vej0qRh+uEpICNbRxgpuc+AnzZE6NiWOjBPwBUwfvPq5v0nH3COWqlzeVwngfpjEiZ8XmynBeeWnafpancEy2fapbeONvdFIwdECG43yO8xkEKUO3j7Vmyqf29jQcUbj2FyAKn1t5HMWyhernPbG+hyP8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktjZOL+3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktjZOL+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549B51F00AC4;
	Fri, 31 Jul 2026 16:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785516631;
	bh=mui2xF2dMnnZlOxVw1sqBdljvZlHXe1/8LY8aJH8dmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ktjZOL+33rXXoNXWdQqK2fF+kEpvn/4+xFqH3E0+OSfLdgMRayoVE8HPAiD/0Karr
	 yxtT9894SpC0LShGmt6g9XJXdKJQPfCV0cuHdDBygmrBcRE0DgcJM0dCd/5M7sol8k
	 5tVBuhXOhBWHpqVTtQ5LbRcaD/orXFdLQQJyDoQ3EcyyyJeCEvzon3AIhWhQQKTTNj
	 Xc3QE15C1ZsD3SS/RKpaBggJFUk5LmkjgcTah1CxRfwHBYH/wfYCG1b/b8tfZ3lMD0
	 XNGOGsNL7PIchyyR/56hNkPJud9nAEFwZSqlB4B60u40U02tvfPAOrzoZIfr6hlwjO
	 R6PEda4JvZLjw==
Date: Fri, 31 Jul 2026 17:50:22 +0100
From: Will Deacon <will@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 04/11] arm64: errata: Require Apple IMPDEF PMUv3 traps
 on all CPUs
Message-ID: <amzSTp3cUCMuwJKf@google.com>
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
 <20260710-hybrid-v8-4-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-hybrid-v8-4-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>

On Fri, Jul 10, 2026 at 08:14:58PM +0900, Akihiko Odaki wrote:
> KVM relies on ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS as a system-wide
> precondition for PMUv3 emulation on affected Apple CPUs. A local CPU
> erratum is too weak for that: once the workaround is enabled, a late CPU
> that misses it may still be onlined.
> 
> Make the workaround an all-early-CPU capability instead. The matcher is
> still local because it depends on MIDR_EL1, but the capability is only
> advertised if all early CPUs match, and late CPUs that miss it are
> rejected once the capability is enabled.
> 
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> ---
>  arch/arm64/kernel/cpu_errata.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 476a37c82108..14ce49d693c4 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -964,7 +964,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  	{
>  		.desc = "Apple IMPDEF PMUv3 Traps",
>  		.capability = ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS,
> -		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
> +		.type = ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,

I always get tangled in knots with this code, but does this correctly
handle the case where the boot/early CPUs don't have the impdef PMU
feature but late-onlined CPUs do? I'm not sure we configure the traps
correctly in that case but this is all gloriously undocumented.

Will
