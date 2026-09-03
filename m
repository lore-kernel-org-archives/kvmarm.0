Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889434EE863;
	Thu,  3 Sep 2026 16:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453587; cv=none; b=DRRSOzao/CMGTRJIZkyJeiGTPaVDi79f9IfnVTwcZfDXFVvmSLFLTrIivrj7g3TY7qtpx9Te4UPCWi6YXIRh6qYnOjXI3Miov8BUOJitoeJ8Cr5IZQFWJPjy1XyTK7uVU3d+9/oZTil1Xj9yt/AG/i0QwTkZXrnSDfQUg5esxJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453587; c=relaxed/simple;
	bh=4HN+auJuJy7pj5e7KNd8FbrTTIDGWhGxj6wIbUmeUJU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NRh/IfF19GA6LTAoZH/ip/ukCSJXHJqaUo+5b/G+siu41eNnrJ+/YzFYb8WnUoaHonYvpSoedhgtkxC+/SBrx9Y8D8h5/vH4mcVjD3NP/1/wkQDMAudqJ9UzKkWIDi1bb4FtPiV2l0nctCxTsKYwcLbCSOxLbJkXKErZg7v2kMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hx/KiUUx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hx/KiUUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAEF1F000E9;
	Thu,  3 Sep 2026 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788453585;
	bh=Ry09QqcwV9zWavnGfxaKEiTL018aYRfD2v5bzNUe1II=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hx/KiUUxFWB6twFSu+YZDnu/F6YYRqH6FSo2SB9+A43PWCpa0QXrndR2Wqq+KfNd1
	 MbQnGfHC00MNoR7fniQajRGdAXAbQtdxbkj0ZNDixTaeXqPHK484usqoIl8y6XvdyH
	 /CxQkQAUPxHbgqSm1GcOgkKWVfPQyA6mq1FMNgGljF1jnKBHoFF4xjuYexAxVGA3nh
	 JGNifnJLNxZGtPa+6BwFE2sssYPU+XHhRqJngghoNRr+bwdLcrCfW6sVT4+xyDRUkp
	 zsnhfD+s4HUQedIWqHeXAPaT3c8zAT4CSjxOgxLGnxXb/URgnMqCZPYooBZqlXHnz/
	 syTtyvZ+1A/5w==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 13/28] KVM: arm64: Add SPE VCPU device attribute
 to set the SPE device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260903160623.315525-14-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-14-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:39:44 +0000
Message-Id: <20260903163944.BCAEF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Incorrect declaration of `supported_cpus` causes stack corrupt=
ion and NULL pointer dereferences when `CONFIG_CPUMASK_OFFSTACK=3Dn`.
- [Medium] Changing the PMU identifier after SPE is configured incorrectly =
accumulates CPU mask restrictions, potentially rejecting valid reassignment=
s.
--

commit b2f754414c4648e5b2996f0b8f1a6f27ec6f0cf7
Author: Alexandru Elisei <alexandru.elisei@arm.com>

KVM: arm64: Add SPE VCPU device attribute to set the SPE device

This commit introduces a new KVM device attribute to assign an SPE
instance to a virtual machine. It adds support for tracking physical
CPUs that share the assigned SPE and PMU instances, ensuring VCPUs
only run on appropriate hardware.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 763b102dc51fa..132df44c30887 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

[ ... ]

> @@ -612,6 +614,47 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> =20
>  }
> =20
> +int kvm_update_supported_cpus(struct kvm *kvm, cpumask_t *pmu_cpus,
> +			      cpumask_t *spe_cpus)
> +{
> +	cpumask_t *supported_cpus;
> +	cpumask_t *cpus;
> +	int ret;
> +
> +	if (!zalloc_cpumask_var(&supported_cpus, GFP_KERNEL_ACCOUNT))
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Severity: Critical]
Does this cause stack memory corruption and a NULL pointer dereference
when CONFIG_CPUMASK_OFFSTACK=3Dn?

In kvm_update_supported_cpus(), supported_cpus is declared as a simple poin=
ter
rather than cpumask_var_t. When CONFIG_CPUMASK_OFFSTACK is disabled,
cpumask_var_t is defined as a 1-element array. Passing &supported_cpus to
zalloc_cpumask_var() will zero out NR_CPUS bits starting at the stack addre=
ss
of the pointer itself, overwriting the pointer and potentially adjacent
stack variables.

The subsequent cpumask_copy() then dereferences a NULL pointer. Could we
use cpumask_var_t for the declaration here?

> +		return -ENOMEM;
> +
> +	cpumask_copy(supported_cpus, kvm->arch.supported_cpus);
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	ret =3D -EINVAL;
> +	/* Cannot update for SPE and PMU at the same time. */
> +	if (WARN_ON_ONCE(pmu_cpus && spe_cpus))
> +		goto out;
> +
> +	if (pmu_cpus)
> +		cpus =3D pmu_cpus;
> +	else
> +		cpus =3D spe_cpus;
> +
> +	if ((spe_cpus && kvm->arch.arm_pmu) ||
> +	    (pmu_cpus && kvm_spe_pmu_set(kvm)))
> +		cpumask_and(supported_cpus, cpus, supported_cpus);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Severity: Medium]
Could this incorrectly accumulate CPU mask restrictions and reject valid
reassignments?

If userspace configures a VM by first setting a PMU, then setting the SPE I=
D,
and later changes the PMU to a different instance (which is permitted before
the VM runs), this logic intersects the new PMU mask with the
already-intersected kvm->arch.supported_cpus mask.

Since the current mask already includes the first PMU's restrictions, the n=
ew
mask accumulates both PMUs' restrictions instead of replacing the old PMU's
mask. If the two PMUs have disjoint CPU masks, the intersection becomes emp=
ty
and the operation fails with -EINVAL.=20

> +	else
> +		cpumask_copy(supported_cpus, cpus);
> +
> +	if (cpumask_empty(supported_cpus))
> +		goto out;
> +
> +	cpumask_copy(kvm->arch.supported_cpus, supported_cpus);
> +	ret =3D 0;
> +out:
> +	free_cpumask_var(supported_cpus);
> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D13
