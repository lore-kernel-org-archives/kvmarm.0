Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92807502790;
	Thu, 15 Oct 2026 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072361; cv=none; b=jyBXK3qUJYreMw2LrHa5qMtKsVnRnfPoPOz39splazlebznpmMV/XG18ua50YYWcSoFhJetoG+AAgBhNFB+krc2yibi/qUi9bqAH2baW2bTkj9gJK++0rULa7KQBU8OhQZLboYQc47tnTPHj0irzIL7mFqyWO62g87WdCjrgb9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072361; c=relaxed/simple;
	bh=lM8I6XMgtga5rEJHpuQE8iYplL3DUg/t6mdAX+UUjTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=plboAfeVIuUP2sxnfAoFhO88rQ6ZZXB77Yz6bwu5z4l2H/LQJuQHThbmyaEAGcN2kHjRz2/P2GpI7o1VuBLmozOfd2l/dSItNiw9pYq3lXoW0AZApIJAa0j3O6Py+BOrCZk5I53PoGaZuQXeyl6sOVDuxQhrk42BTaTlNxT1lTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBlTG4fc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBlTG4fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DA31F000C4;
	Thu, 15 Oct 2026 13:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072360;
	bh=WexMx0NdQtACdoNVOcVRGmD1v7W6mupsTgB/BNVDo3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JBlTG4fcR8atMqAzu6ODrsR+hmw5RneGrNwKtdbF2X4w0yqrJXK2TF1Ui1NJCKV4i
	 ODLQscogYLzxf+qF7LX7O4LU1Yf47VVOn5O838jzd03qS0sTI7me74v9ohSjBpaBfx
	 6KftC/0NtIuJTTTW3FlQIPWkXc1DDXwJikPl02nS+hXr4OAwzgvVWt/UWOdz8ok6ly
	 LOR7f4Ldmvjtc8PJb1sl/xJ3xQw4USYXSbeJAj+PBmeNtB/gSwkJ5zXRGiC5Euvt39
	 zKGclzfv/VyIHh1etV/kyg8lqiyHxRudsnb5LOtu8EnjStkaIQphgVHUcmu+JWHm0X
	 78k62krQfKYqQ==
Date: Thu, 15 Oct 2026 14:52:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 02/28] arm64/sysreg: Define MDCR_EL2.E2PB values
Message-ID: <atDUMAe0QGP_4swk@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-3-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-3-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:05:57PM +0100, Alexandru Elisei wrote:
> KVM will make use of the different values for MDCR_EL2.E2PB, document them.

As with 1/28, using [0] to check the definition of the register.

>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Looks correct, a couple small nits below, with those addressed:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/tools/sysreg | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a11a968eb707..4485736a4f49 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -4045,7 +4045,12 @@ Field	17	HPMD
>  Res0	16
>  Field	15	EnSPM
>  Field	14	TPMS
> -Field	13:12	E2PB
> +UnsignedEnum	13:12 E2PB

MEGA NIT: Shouldn't there be a tab rather than a space after '13:12'? :)

> +	0b00	EL2

So broadly - this means EL2 owns the profiling buffer right?

This seems to align with the document (which is very verbose, obviously :):

"If EL2 is implemented and enabled in the Profiling Buffer owning Security
state, then the Profiling Buffer owning Exception level is EL2. Otherwise,
the Profiling Buffer owning Exception level is EL1 and, Profiling is
prohibited at EL2."

"If EL2 is implemented and enabled in the current Security state, then
accesses to Profiling Buffer System registers at EL1 are trapped to EL2,
unless the access generates a higher priority exception."

> +	0b01	RESERVED

NIT: Hmm, it seems to be the convention to just omit entries that are
missing from the definition in the docs? So is this needed?

I see a couple named ones, e.g. in CTR_EL0.L1Ip:

	# This was named as VPIPT in the ARM but now documented as reserved
	0b00	RESERVED_VPIPT
	# This is named as AIVIVT in the ARM but documented as reserved
	0b01	RESERVED_AIVIVT

Which have comments explaining why, i.e. they were defined before but are
now reserved.

> +	0b10	EL1_TRAP

Again my understanding - EL1 owns the profiling buffer, but EL1 sysreg
accesses trap to EL2?

Seems to align with docs:

"Profiling Buffer owning Exception level is EL1. Profiling is prohibited at
EL2."

"If EL2 is implemented and enabled in the current Security state, then
accesses to Profiling Buffer System registers at EL1 are trapped to EL2,
unless the access generates a higher priority exception."

> +	0b11	EL1

And finally - EL1, traps to EL1 too right?

Again seems to align with docs:

"Profiling Buffer owning Exception level is EL1. Profiling is prohibited at
EL2."

"Accesses to Profiling Buffer System registers at EL1 are not trapped by
this mechanism."

> +EndEnum
>  Field	11	TDRA
>  Field	10	TDOSA
>  Field	9	TDA
> --
> 2.43.0
>
>

All LGTM!

--
Cheers, Lorenzo

[0]:https://support.arm.com/documentation/ddi0601/2026-09/AArch64-Registers/MDCR-EL2--Monitor-Debug-Configuration-Register--EL2-?lang=en
