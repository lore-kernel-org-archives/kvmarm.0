Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793146322;
	b=SNIFdvSJjVk+/EST6kCwCKxtAVxGQBt80YQ1wURE+x/buEin8oSL5ZZb3S1crBL6CKy7
	 IuoI7jS3bcCZSctzyRoIfGvGM8X6JrLflh05lAF3BU68QvYoHO3pR+H3XTO04HoL5o8lW
	 d9MiWCourLs7sn4joJ3ggKjrPAWgRam8vFQgXB5tmdDbQrVOYQbkcF5fG9RQACaGhMuQe
	 hUt/c9cmzjDHpSTaYHsryy8omwnIBcXE7REftLKdXnmRX3Gc12OGJCcKS+3u4XnkhgjWV
	 jtXdHqJQF4GlfvGnVCmBHcaspIXJ9of2KK+WX0g7pA28A8/CFx/xfrjErKbcjJFxWxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793146322;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+o/Jezqz4HVBNzci1q7oB9zR4EjyM0MvcXJlOshr7WU=;
	b=1lX8GhV2cNy9Zu0Z9T7dHQtWuxSrmhCicea1EnRymsmdpniT0fflxJvhHwbcGFh65eWW
	 k21oSiXQFuNqx+Yf2/p7fibNBKGjSPxI3fZWnDugTiSvWiuqjRtyf+eeKJzTme8e1m2PZ
	 g3wQsIWKKadQEDz/U61hXduo/38KtV+eBhMGf7uuSwUZBMcO0gktpAkwKiB7VK/Ylx9JM
	 RP5TVwWTSqZxbq79NQzRsLJr+BlZjmVZATUKOwJmrHMIwz3uWmModkosl+b+kYYsoy0N9
	 7MK3JoLpJ+72/eU95RbHKMk/UbWQb4g+ExnSUI/5GjeJ9Gd5TLPzIUcsiwETd8h3Uig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PG1MtLKU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038BC606A31A
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 00:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PG1MtLKU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749C91F01825;
	Wed, 28 Oct 2026 00:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793146321;
	bh=+o/Jezqz4HVBNzci1q7oB9zR4EjyM0MvcXJlOshr7WU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PG1MtLKU3TH3/acn+1lJTwBJq0Sv2rkNb6ffQC/pJrUuIxUrsH93IfG/urmyQW/N5
	 8su4Ob+HV+N8q0iZ2WyiZPW0zp7HTKdlpr7rlRykxZJ6jqIboKMHhe5ZomOklZ0d75
	 RcmEemghZfEhFwK2bBYNPgRwx5h0g8Hb63U3kEfYkZY/bG2rOp/xGKCzxBQB0QgjKM
	 4DG87str/ikZMBrwkntHSp52pVQ5XRaQ7uWYXTo+qJ4+oFlu6sCu1nbyRJrKOqtXyK
	 SyudzwtoQVu9kQp/DtPv+OsnGnWNiqCHzYDRbUZabdycupCiqqTXYMOmvAujFUSd66
	 VErW+/MwipAEA==
Date: Tue, 27 Oct 2026 17:12:00 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm64: Don't let a guest overwrite HCRX_EL2.MCE2
Message-ID: <auE90LmMMmac8J1s@kernel.org>
References: <20261026082633.2515820-1-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026082633.2515820-1-maz@kernel.org>

Hey,

On Mon, Oct 26, 2026 at 08:26:33AM +0000, Marc Zyngier wrote:
> FEAT_MOPS is fun. CPUs are allowed to implement any of two ways to
> perform the memory copy, and the hypervisor is in charge of hiding
> the difference between implementation when the vcpu migrates from
> one to another. This is unhelpfully signalled with an exception,
> which KVM diligently handles.
> 
> Today, we don't really make a good job of it in the sense that
> if L1 also has the trap bit set, we don't forward the trap as
> the architecture would require us to do.
> 
> But there is no good reason to forward this to the L1 guest if
> L2 generates the "I'm on the wrong implementation". KVM can fix
> it up in place and return to L2 directly, as if the physical CPU
> was able to implement both options.
> 
> Conversely, allowing L1 to clear HCRX_EL2.MCE2 is counter-productive,
> and violates the abstraction that KVM aims to give.

What abstraction? :-)

At least in the non-nested case we can blame the VMM since it's
responsible for scheduling vCPUs on the right pCPUs in a heterogeneous
system.

There is a subtlety here where if the VMM does the right thing with
sched affinities then a MOPS exception taken from L2 is definitely the
L1's fault and architecturally visible.

But oh well. We're obviously oriented towards presenting a homogeneous
set of vCPUs and anything else works by accident.

> Implement this behaviour by never allowing the guest's view of
> HCRX_EL2.MCE2 to make it into the HW, and document that KVM is in
> charge of the A/B handling.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver
