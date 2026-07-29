Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75AB2DA749;
	Wed, 29 Jul 2026 03:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785296535; cv=none; b=c9HnoQztm8ErWkmnyv5Gb1VH3PYz1m/kQYbfGdhp/AcyY+6Hc/bUzQKeiAdqt6BDvR4wa5U7u5TszcMibRvaH5Ha/9Z2VLLR+rpBXCrirKPZGRDqAcHPwAS1TmriaCBU8SEpZMfGRqqr7MrceOZsITZLdqUARHCRBLT3QdijLY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785296535; c=relaxed/simple;
	bh=8wwVpJ9g/7h3n+EsWis/QJ70zqtw1SfxQS3ZZq3GzlM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bi/QXboydwJvQeHZfke/1RPWg9XTz5d5qHbPq48zVR6UhUld4oLF9l1jVvl5GdjnZ39Fk3bhSPDEKD9uoBlgKKdQZZdkn67VkoRRBA43w0xSQ9eShDmW4GrRIxeqrTIcy1mlJid/fTpsgR5+111v2VE5UfG/kS4rozwpVA9yxXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2FaCuma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2FaCuma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0940A1F000E9;
	Wed, 29 Jul 2026 03:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296534;
	bh=2JTo64uYd/0VmuRvQLaI7/q1+/xIenMBQsQYLKsuNoU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z2FaCuma1YJYFbXIYDiYZ7c69smSW1u1A6StTX91gyTnrCNfTJYWPxn8wncdVO/eZ
	 xAN2FPmFv0Fx9bvZd+giOY8Xm0/T4hzcFy6R1c6K+EC2jyyZLuC802d6/iPQYoPjAa
	 XPLZ++cgqDyAU3IvSHhPSV/WSRHaxsDbcmaKU6Eq2blh0vIlETDQz63navRdHKTjgJ
	 hjymCIIfn1pxtAmr80zXeKsij/OVud9hCiBUiQ6VeQP/W4F1CYuJUEpVv56afft0g9
	 Iv4HTNt29yMin4keN1/yPTD3EY+GdKRYh/EWuchQUjvSrV0TvNVFTZSfFvyQ+vXe2O
	 HDtG2/+qj1l0A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] arm64: errata: Add NXP iMX8QM workaround for A53 cache
 coherency issue
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGVuZyBGYW4gKE9TUyk=?= <peng.fan@oss.nxp.com>
Cc: Frank.Li@kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, imx@lists.linux.dev, kvmarm@lists.linux.dev
In-Reply-To: <20260729-imx8qm-cache-coherency-v1-1-c9864e280437@nxp.com>
References: <20260729-imx8qm-cache-coherency-v1-1-c9864e280437@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 03:42:13 +0000
Message-Id: <20260729034214.0940A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Unconditional upgrade of local TLB flushes to global broadcast (`v=
malle1is`), resulting in unsynchronized broadcast DVM messages.
- [High] The workaround for user-space IC IVAU silently swallows faults for=
 invalid or kernel addresses.
--

--- Patch [1]: [PATCH] arm64: errata: Add NXP iMX8QM workaround for A53 cac=
he coherency issue ---
commit 2862fd74023d9e9e12c6a2745e844dc84b6cf1f7
Author: Peng Fan <peng.fan@nxp.com>

arm64: errata: Add NXP iMX8QM workaround for A53 cache coherency issue

According to NXP errata document IMX8_1N94W, the i.MX8QuadMax SoC suffers
from a cache coherency issue (ERR050104). The workaround includes downgradi=
ng
targeted TLBI operations to broadcast-all variants, upgrading IC IVAU to
IC IALLUIS, and disabling KVM.

Link: https://lore.kernel.org/all/20230420112952.28340-1-iivanov@suse.de/

> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/t=
lbflush.h
> index 14a78ac0f8009..87843e602127e 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
[ ... ]
> @@ -580,23 +584,27 @@ static __always_inline void __do_flush_tlb_range(st=
ruct vm_area_struct *vma,
> =20
>  	asid =3D ASID(mm);
> =20
> -	switch (flags & (TLBF_NOWALKCACHE | TLBF_NOBROADCAST)) {
> -	case TLBF_NONE:
> -		__flush_s1_tlb_range_op(vae1is, start, pages, stride,
> -					asid, tlb_level);
> -		break;
[ ... ]
> +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104)) {
> +		__tlbi(vmalle1is);

[Severity: High]
Does this code inadvertently break the synchronization for local TLB flushe=
s?
When __do_flush_tlb_range() is called with the TLBF_NOBROADCAST flag (such
as from flush_tlb_fix_spurious_fault()), this block unconditionally upgrades
the local flush to a global broadcast (__tlbi(vmalle1is)).

However, later in the same function, if TLBF_NOBROADCAST is set, the code
synchronizes the operation using dsb(nsh) instead of dsb(ish). Emitting an
inner-shareable broadcast TLB instruction but only waiting for local
completion violates the hardware contract and can overwhelm the system
interconnect with DVM messages that are never waited for.

Should local flushes be upgraded to the local vmalle1 instead, or should
the synchronization be upgraded to dsb(ish)?

> +	} else {
> +		switch (flags & (TLBF_NOWALKCACHE | TLBF_NOBROADCAST)) {
> +		case TLBF_NONE:
[ ... ]
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 9142820160698..beb658a007d59 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -585,6 +585,12 @@ static void user_cache_maint_handler(unsigned long e=
sr, struct pt_regs *regs)
>  		__user_cache_maint("dc civac", address, ret);
>  		break;
>  	case ESR_ELx_SYS64_ISS_CRM_IC_IVAU:	/* IC IVAU */
> +		if (cpus_have_final_cap(ARM64_WORKAROUND_NXP_ERR050104)) {
> +			/* ERR050104: upgrade IC IVAU to IC IALLUIS */
> +			asm volatile("ic ialluis");
> +			ret =3D 0;
> +			break;
> +		}

[Severity: High]
Will this silently swallow faults if user space passes an invalid or kernel
pointer?

Normally, __user_cache_maint() checks if the address is >=3D TASK_SIZE_MAX =
and
sets -EFAULT, which correctly triggers a SIGSEGV for the offending user-spa=
ce
application.=20

Because this workaround executes the ic ialluis instruction and returns suc=
cess
(ret =3D 0) unconditionally, it bypasses the address validation entirely. C=
an we
preserve the TASK_SIZE_MAX check so that buggy or malicious programs aren't
silently ignored?

>  		__user_cache_maint("ic ivau", address, ret);
>  		break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729-imx8qm-cac=
he-coherency-v1-1-c9864e280437@nxp.com?part=3D1
