Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B562D7398
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 11:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781265045; cv=none; b=B4jg9IuRP/7LA8oxJleWoepax+LsbwN3etldFWpXqdlo/qB3NEJcIa1Vpp3QyPMunSkhuuImxV+V7VXhgicRAvhrpF9Ie4qbWOeLYl5QQfRW5Zmz9j4++XJshsktOPxm11RqhAZaolTU2QgKogTWdumfApa75JwwnUUME9f104o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781265045; c=relaxed/simple;
	bh=0jnEfhXirP3IraZfJmei0q9m6dkCR6NE5J9D8/2N50s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZyA8FKbbc3I9JZ4hX29opQ987WwDfa+DmqXHG0TBSrJVkBird+kVxijcKrwN/i/n4gF83S52vmggtsVzyK1ZaSrmJaIGTSHMblkqDusvFlKowLANeFagRsog2xp0Kf2HpUqSWqhxFB1mObu42f8KbPcZ/ezvTnbbbtwi9TKEFYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LwSAOrLG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LwSAOrLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E3B1F000E9;
	Fri, 12 Jun 2026 11:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781265044;
	bh=1lmt8ScBon464NBEDwF7R5sybvUxa1f3m0xIZO6o68M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LwSAOrLGAw52+Ebv/2Kn+29zfyBUJEpdrApvfGGJootiELGOa56Vuxx/yCnMHxQOi
	 tIUe32gcEdxZng647Ctih3c+qrLKN3P/i7gGlIDSYHIdyTN8HvjBevirq2MY3uB/ht
	 lOsGRKV68i0ru7ugFi3RGzWLnGhH4lP0BJMZ5UULiKGNeN7qXq65bRDB9UzGE4zWKW
	 qzRjxYzKIEl0n95tuU3geRRvKq830wA7wCQm5FNimiKYli39E6SWsSAsw7u35SYSjB
	 HOb58CibYKXNfrPBcyVixIMTPLBLztP+Sid4wA4JzKW44MPuXn8R2K+4mZEcpKsC2Y
	 smfXRB3o/xvdw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Sync SPSR_EL1 when injecting an exception
 into a pVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260612113414.1022901-1-tabba@google.com>
References: <20260612113414.1022901-1-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:50:43 +0000
Message-Id: <20260612115044.16E3B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Stale `SCTLR_EL1` used during synchronous exception injection in p=
rotected VMs leads to incorrect `PSTATE` computation.
- [High] pKVM's `inject_undef64()` injects an undefined instruction excepti=
on with the `IL` (Instruction Length) bit cleared in `ESR_EL1`, incorrectly=
 indicating a 16-bit instruction to an AArch64 guest.
--

commit 5157ad995c29fa359271604075525691515c2f95
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Sync SPSR_EL1 when injecting an exception into a pVM

When pKVM injects a synchronous exception into a protected guest, it
re-enters without restoring the guest's EL1 sysregs. This commit ensures
SPSR_EL1 is written alongside the other exception registers to avoid
restoring a stale PSTATE on eret.

> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe=
/sys_regs.c
> index 8c3fbb413a06d..1a7d5cd16d723 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -268,6 +268,7 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u64 =
esr)
> =20
>  	write_sysreg_el1(esr, SYS_ESR);
>  	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);

[Severity: High]
This isn't a bug introduced by this patch, but since we are fixing sysreg
synchronization in inject_sync64(), is there also a missing synchronization
for SCTLR_EL1 before pending the exception?

Earlier in inject_sync64(), VBAR_EL1 is explicitly synchronized to memory
because traps are handled early:

arch/arm64/kvm/hyp/nvhe/sys_regs.c:inject_sync64()
	/*
	 * Make sure we have the latest update to VBAR_EL1, as pKVM
	 * handles traps very early, before sysregs are resync'ed
	 */
	__vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));

	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);

	__kvm_adjust_pc(vcpu);

However, when __kvm_adjust_pc() eventually invokes enter_exception64(), it
reads SCTLR_EL1 from memory to compute the new PSTATE:

arch/arm64/kvm/hyp/exception.c:enter_exception64()
	sctlr =3D __vcpu_read_sys_reg(vcpu, SCTLR_EL1);

Because SCTLR_EL1 wasn't synchronized from hardware like VBAR_EL1 was,
could the guest's exception handler end up executing with a stale PSTATE.PAN
and PSTATE.SSBS?

> +	write_sysreg_el1(read_sysreg_el2(SYS_SPSR), SYS_SPSR);
>  	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
>  	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
>  }

[Severity: High]
This is a pre-existing issue, but looking at the related inject_undef64()
function located just below inject_sync64():

arch/arm64/kvm/hyp/nvhe/sys_regs.c:inject_undef64()
static void inject_undef64(struct kvm_vcpu *vcpu)
{
	inject_sync64(vcpu, (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT));
}

Does this need to set the ESR_ELx_IL bit?

According to the ARM Architecture Reference Manual, for an Unknown reason
exception (EC =3D 0x00) originating from AArch64, the Instruction Length (I=
L)
bit must be set to 1 to indicate a 32-bit instruction.

Unconditionally leaving it as 0 by only bit-shifting ESR_ELx_EC_UNKNOWN
exposes an architecturally invalid exception syndrome register to the guest.

Could this cause the guest kernel's exception decoding logic to fail or
panic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612113414.1022=
901-1-tabba@google.com?part=3D1
