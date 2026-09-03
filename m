Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D498E417BDE;
	Thu,  3 Sep 2026 16:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454706; cv=none; b=IPLpIO6WaTE0A2zQcEK8304ZjBJCf10XvmDnfbPAItrVgrLuQmTP8BMu2Re6hy5DldLvrTBUEG9oJQsYeP7yaqUzogM3pkqcONufS/Vrcny18Mny5HqtwtwYYyZi180ios3kCNl8gPBbaEq+xd+v42raGrkDkOK09HvWCunY9Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454706; c=relaxed/simple;
	bh=kIUwFVGklX+Mkkro25Ni9eOhjkNm3RIZcJrI5g81CkQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T14qDTucFPi34p6NiLi2VPBl770qTWOGozItDSnmZXLRh8gkMU9xRPTlzzVNBF15YYctyMlYIc67pehWLyp/7TCReuKPIE1ORFc0DAZag1vVb3Qq30dxKBif2lfJik9GmDpMMwS8e9oH3k1ihQm2zTMD5Ne9oqLTi22Ruk6UeKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AiC+qv4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AiC+qv4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158A21F000E9;
	Thu,  3 Sep 2026 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788454704;
	bh=bhU/wKKCx01PSL7o/9M/LEfbkvf7275hZX8nvfOi4Y4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AiC+qv4FkXaIZm7IVfV0BFbKjo03mHpUCdIK+p/Zo1JmZUaGg0k/UAj84/6mZ7jAR
	 BffakrT0ughTRz/34mOiXkaWllttzI5DMSAGLsUHSr/ZxLcP3GlNWPijhPcvDGbzul
	 vzJwCRKj/76ihahWmiUbX7l2wHo7HpnvE6pXmtcCRAJReHICxMUXATs6ZHTaY/ILvO
	 JoxraKqsEp7klJsRRwDQ5BUHfHw3n5I0DCE4labmseC76aWpm9Co8Vi0GmgIrDMNS5
	 zNnAvWTHrL9+IxShDPq9D9ZDvGU8eVyS4rW7hQ/aUPlsTyPkIoalfYTKsZ6FyB7Vj3
	 tBnSRnnHC+zng==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 21/28] KVM: arm64: Handle SPE maintenance
 interrupts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260903160623.315525-22-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-22-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:58:23 +0000
Message-Id: <20260903165824.158A21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] SPE system registers are not cleared during VCPU reset, leaking =
stale state across warm resets.

Pre-existing issues:
- [High] Hardware profiling buffer is enabled before `PMBSR_EL1` is restore=
d, creating a race condition that clobbers hardware events.
--

commit 0111e834cf6f2849f99044fcfd2c2f6ef3480c83
Author: Alexandru Elisei <alexandru.elisei@arm.com>

KVM: arm64: Handle SPE maintenance interrupts

This commit introduces handling for SPE maintenance interrupts in KVM. It
injects the interrupt when the guest sets the PMBSR_EL1.S bit and re-injects
hardware-raised maintenance interrupts.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4c4bf88c9aa53..ebe1c933f8d55 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1595,6 +1595,11 @@ static int get_user_spe_sysreg(struct kvm_vcpu *vc=
pu, const struct sys_reg_desc
>  	return 0;
>  }
> =20
> +static u64 reset_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r)
> +{
> +	return kvm_spe_reset_sysreg(vcpu, r->reg);
> +}
> +

[Severity: Medium]
Does this change leak stale SPE register state across warm resets?

Previously, SPE registers used reset_val as their reset callback, which
actively updated the vCPU sysreg array via __vcpu_assign_sys_reg().

Here, the new reset_spe_sysreg() callback returns 0 but misses a call to
__vcpu_assign_sys_reg() to clear the VCPU's system register memory.
Because the KVM sysreg reset caller ignores the return value, the values in
vcpu->arch.ctxt.sys_regs remain untouched.

If a VM goes through a warm reset (e.g., via PSCI CPU_OFF / CPU_ON) while
profiling is active, the new OS environment inherits a stale profiling stat=
e.
Should kvm_spe_reset_sysreg() explicitly clear the register state?

>  static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params =
*p,
>  			   const struct sys_reg_desc *r)
>  {
> @@ -1642,7 +1647,7 @@ static bool access_spe_reg(struct kvm_vcpu *vcpu, s=
truct sys_reg_params *p,
> =20
>  #define SPE_SYS_REG(name)						\
>  	SYS_DESC(SYS_##name), .reg =3D name, .access =3D access_spe_reg,	\
> -	.reset =3D reset_val, .val =3D 0, .visibility =3D spe_visibility,	\
> +	.reset =3D reset_spe_sysreg, .visibility =3D spe_visibility,	\
>  	.set_user =3D set_user_spe_sysreg, .get_user =3D get_user_spe_sysreg

[Severity: High]
This is a pre-existing issue, but does __kvm_spe_restore_guest_state_vhe()
clobber hardware events by enabling the profiling buffer before restoring
PMBSR_EL1?

In arch/arm64/kvm/hyp/vhe/spe-sr.c:__kvm_spe_restore_guest_state_vhe():

	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
		isb();
		write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
		isb();
		/* A buffer management event preserves fields in PMBSR_EL1 */
		write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
	}

Because PMBLIMITR_EL1 is restored (with the E bit set) and an ISB executed
before PMBSR_EL1 is restored, hardware can autonomously trigger a buffer
management event right after the ISB if the buffer is near full.

KVM's subsequent software write of the guest's PMBSR_EL1 (which has S =3D 0)
overwrites the hardware register, wiping the event and clearing the
interrupt.

This violates the ARM Architecture Reference Manual D10.1.5, which forbids
software from writing to PMBSR_EL1 while PMBLIMITR_EL1.E =3D=3D 1.
Should PMBSR_EL1 be restored before PMBLIMITR_EL1 to prevent this race
condition?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D21
