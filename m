Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D5C3EE1DB;
	Tue, 18 Aug 2026 11:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787053265; cv=none; b=su9NBhJrFIOGQVsrjWqqI6Lg7kndHGIUyXoeVgzgGUp5+kT/vVUhArX+JXC2hVMfNeLpOxzzJjCmVLpOqPKZNjoHN/rR0ptqX+gkU47rRuMtRdV9gP0EVKYxpB5HrRaEgOV2NGo0/y3L2CDE99Q3i6vPYeFQphZ/F9CdFEwoApQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787053265; c=relaxed/simple;
	bh=Gt0nQ5POVf88b1vkjzxEaBa2qAWOOMTbVpCTLai/XvA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Rzsr0b/bNzYhMOPnM1t7sFAo86sKZBWH7XFeuZObT0RRoPePDgwoZ/j7ZkyOYrU2yLnAwYmuJZm0ELEjko/1Ou0IOdSwE7BTNgBuT0/OurejzNgpn6ipPFgqHwpgMD3kF5eOnF/4JR8uvh+pcBgMIsXWZJPajJhNbSy+0zuzkZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pk5K8jrV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pk5K8jrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433F01F000E9;
	Tue, 18 Aug 2026 11:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787053263;
	bh=eC3z1t1tMyS5ComOCMyzhKgxHMgkwWh5+l0UwNYyrr4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pk5K8jrVXJdgYI6SuHfsJNvDvKsUUGD7sKclOITiEnKjk+UbVCw03Zh/ZNEUegCEe
	 FiJKej4PaheBNcEmLlUhwvmGTV7D34utSvjQItom3fhOeYqfURHZO0Y0IDMZ15SQIb
	 ACiw5dJw+T0JhdF/BVjfQIFUkbVVwckOOSndI5Gw9K78bCmuFMnJFrcp2ClPyMUsGR
	 W3xY5qIILUIUTR8X1d7usu67dQNSzR2K8If4MiuOT0mMS4Tzasx1xkg4uNYIE3g3jJ
	 70KAUVbzyL+EHTGgkUszBgO/tZATev/Ek4VQnY5vRnLN/NoHiwytDbL6+HanbsZv4t
	 A18q9bt7QLf3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] KVM: selftests: arm64: Skip sea_to_user when
 EINJ places no poison
Reply-To: sashiko-reviews@lists.linux.dev
To: "Like Xu" <like.xu.linux@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260818112920.26252-4-likexu@tencent.com>
References: <20260818112920.26252-1-likexu@tencent.com>
 <20260818112920.26252-4-likexu@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 11:41:02 +0000
Message-Id: <20260818114103.433F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The check skips the test unconditionally on any guest assertion =
failure, masking unrelated or future bugs.
--

--- Patch [3]: [PATCH v2 3/3] KVM: selftests: arm64: Skip sea_to_user when =
EINJ places no poison ---
commit 3bedaa634d562c6cc85fb3726d30fa40f0ed350d
Author: Like Xu <like.xu.linux@gmail.com>

KVM: selftests: arm64: Skip sea_to_user when EINJ places no poison

This commit modifies the sea_to_user selftest to skip rather than fail
when the firmware does not leave consumable poison in memory. It detects
this condition by checking if the exit reason is not KVM_EXIT_ARM_SEA
and a UCALL_ABORT is received from the guest.

> diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/test=
ing/selftests/kvm/arm64/sea_to_user.c
> index 7cf95da8e594d..d4af6e0eed288 100644
> --- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
> +++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
> @@ -215,13 +215,33 @@ static void run_vm(struct kvm_vm *vm, struct kvm_vc=
pu *vcpu)
> =20
>  	ksft_print_msg("Dump kvm_run info about KVM_EXIT_%s\n",
>  		       exit_reason_str(run->exit_reason));
> +
> +	/*
> +	 * The guest's read of the injected location is expected to trap to KVM
> +	 * as an SEA. If it does not, the injected error was never placed as
> +	 * consumable poison: some firmware honours EINJ's notrigger request by
> +	 * arming the poison only as part of the (now skipped) trigger step, so
> +	 * nothing is left in memory for the guest to consume. The guest then
> +	 * reads back the sentinel value and reports it via GUEST_FAIL, which
> +	 * arm64 delivers as a ucall over MMIO (hence a KVM_EXIT_MMIO here).
> +	 * Treat that as "this platform cannot host the test" and skip, matching
> +	 * the requirement documented at the top of this file, rather than
> +	 * failing on a hardware/firmware limitation the test cannot control.
> +	 */
> +	if (run->exit_reason !=3D KVM_EXIT_ARM_SEA &&
> +	    get_ucall(vcpu, &uc) =3D=3D UCALL_ABORT) {

[Severity: Medium]
Does this unconditionally skip the test on any guest assertion failure,
masking unrelated or future bugs?

If KVM fails to exit to userspace and instead incorrectly injects a
Data Abort to the guest with an unexpected syndrome, the guest's SEA
handler might fail a GUEST_ASSERT_EQ check. This would emit a
UCALL_ABORT over MMIO.

The host loop here interprets any UCALL_ABORT during this phase as a
missing EINJ poison limitation, skipping the test instead of reporting
the failure.

Can we check the specific assertion failure reason or uc.buffer string
instead of catching all UCALL_ABORTs?

> +		ksft_print_msg("Guest consumed no SEA: %s", uc.buffer);
> +		ksft_exit_skip("EINJ notrigger placed no consumable poison on this pla=
tform\n");
> +	}
> +
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
> +
> +	/* arm_sea holds valid data only for a KVM_EXIT_ARM_SEA exit. */
>  	ksft_print_msg("kvm_run.arm_sea: esr=3D%#llx, flags=3D%#llx\n",
>  		       run->arm_sea.esr, run->arm_sea.flags);
>  	ksft_print_msg("kvm_run.arm_sea: gva=3D%#llx, gpa=3D%#llx\n",

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818112920.2625=
2-1-likexu@tencent.com?part=3D3
