Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B585F391842;
	Mon, 13 Jul 2026 07:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783928508; cv=none; b=a3rVIgTDBkjJZbPflrisSGEmgOnYtEPocvDlQXeJXTjHf9kP25J3neidNIlGyrG6boM1iTl2qYlrL/WyWJUVU7ETOhQ5Y1o1S6P/Fq8S4y/BfBAJkC4msbJb0GwQIAnaOpbiA6shoVQzt2Si6PRUyAfuj5rsDOhrZ2WPDWKGkAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783928508; c=relaxed/simple;
	bh=/ITXAz95pyVQuTVE04oN+8dtzC/HQwUWpGMhdh0LL7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8daeZptQNWyfMijb+hu8N2IezSWDJiibHZNF+YUHt1nQieWYzKDaQpw9IjccFhX321b/6IYcWyJtWY8W7Fpo0cSToNeZ9T7wl/Ky+2HZshdv5PVklpy/zDG9/8e0VO10ilGHVAUv85Yb1dZZ7Re+pnvODFM0MBAjp0tk9kKqvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iogtmhqp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iogtmhqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F25B1F000E9;
	Mon, 13 Jul 2026 07:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783928505;
	bh=FEJ5fjqsqgZR9DwKBl35hnhLDdYSJgMQMJxBh2HovUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iogtmhqpAw5JpgL6uL8HH34fouldnGXX7dp9fbAxTWiuX4Na5u+o0uIjzmbTPwhy1
	 PuriTzlBRAnp2hYXcLH4lorCYwv3OVRiajgG0UCuRafhmHj0tR04D049PqZUoKQyHT
	 kZK/bggWGynH+SlUhVfxON2ksGRHkwAYN7siruOt56V23sjpiPId7QtC5nu+X3OrKh
	 cl0l9aqOu/bB0BWEAdl0YameoHoa5HLpTkTY81D/F3I39+4LP0w5gY9UaS1Gmns6g1
	 iZFRLJWpT26ArG8xkOqu7Q7UumJ/qu/ghBM/SHLMz6PGUPXz4PqXtJgRhQqICeM6lq
	 I1h714SiT0QXQ==
Date: Mon, 13 Jul 2026 00:41:43 -0700
From: Oliver Upton <oupton@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
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
Subject: Re: [PATCH v8 09/11] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
Message-ID: <alSWtwHVfYh0zdPy@kernel.org>
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
 <20260710-hybrid-v8-9-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-hybrid-v8-9-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>

On Fri, Jul 10, 2026 at 08:15:03PM +0900, Akihiko Odaki wrote:
> @@ -813,6 +842,15 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
>  	if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
>  		return;
>  
> +	/*
> +	 * IMPDEF PMUv3 traps are non-architectural, and KVM cannot assume a
> +	 * uniform PMUv3-compatible arm_pmu is available on all CPUs.
> +	 */
> +	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS)) {
> +		kvm_info("Non-architectural PMU, tainting kernel\n");
> +		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
> +	}
> +

This is an unrelated change, and really the taint should be added with the
.cpu_enable() for this capability. That's the point where we flip the
magic bit.

> +void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu, int last_cpu)
> +{
> +	if (!kvm_pmu_fixed_counters_only(vcpu->kvm) || vcpu->cpu == last_cpu || last_cpu == -1)
										^~~~~~~~~~~~~~

Does this do anything other than avoid a spurious reload on the first KVM_RUN?

Thanks,
Oliver
