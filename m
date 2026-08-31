Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C32338DC73
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 20:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788207731; cv=none; b=h2t1KqytIWY6FVDAOaJ9wMdFL7wW1KeJb1X5ySg3n8LMFw0ImcmNH6WZDmS6wZkiIxcsrFiydrU+VDmW95rI254DH52+3POsyjPIlzkU9sJ2tt9AXi8t6zqIIzaMnqjhbyas10VVtrTW4ZbSxYQ4eOnpxdzXYQkRYQozPtl/aOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788207731; c=relaxed/simple;
	bh=9itNZnJLLiqzrblXFbe8jGYTGwOg4HUeZAQuHJs/yNg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RopGiA032omC6gIUiNz2gPXSgEkyGc7ByVUlfe1lGQ7b2p3gPcoSKQKreHGgvWm4Camfoz7+fHaWNxyx3EAIQ6KjFUGtAojWj3mU9IMKAVug3Nj4qqin3fqhAzZ9O/VD+Lngbc4qtaGFnd71+s0k/76rqTtHP6FAMnkvgt3Ja1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dl/lGuPQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dl/lGuPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EAC1F000E9;
	Mon, 31 Aug 2026 20:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788207729;
	bh=qVx1S46+DdtY2VSzq0JfaOFXXpwpn4G7uT7Ky7JfF34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dl/lGuPQKbr13kShZuepfbShvd+2c2gNXHMgb6RKoBMfF+ftSBniu7nI0lhSlk/f+
	 Sz/RVvfesjxzC0m6LWPuDPGTeoTTc6c4Tm3Zho99lwnAALIkHaQbfYY1APqR+LGkrf
	 RD62X7acoqGslruNaS4o5u4PGKDDZzteFOFn2/jPg8BKoTYTEX1P8sC2uIqOpoho4+
	 c7WDYxomK6j6insHQkV84SpZoqcuEcT7oVH06EA0Gqop3vy82Q3a5XLrsMQCtCi0ca
	 iVUO8ayXmbS9eUz/D6bdCKpS3Xugpgtvjjlug1SupIXP7z0Vd64/VBIBHKYvYzzaxE
	 cxVQXdzZNwGwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/17] KVM: arm64: Add system register reset framework
 for protected VMs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260831163421.272420-8-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-8-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 20:22:08 +0000
Message-Id: <20260831202209.58EAC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] EL2 reads host-controlled system registers (ACTLR_EL1 and AMAIR_EL=
1) to initialize protected VM state, violating the pKVM trust boundary.
- [High] Host-provided vcpu_id is used to calculate the protected VM's MPID=
R_EL1 without uniqueness validation, violating architectural constraints.
--

commit 84ffa62c045287810116009ea32700416618900e
Author: Fuad Tabba <fuad.tabba@linux.dev>
Subject: KVM: arm64: Add system register reset framework for protected VMs

Reset a protected VM's system registers at EL2 rather than taking the
host's values: add kvm_reset_pvm_sys_regs() and the
pvm_sys_reg_reset_vals[] table that drives it, and call it from
init_pkvm_hyp_vcpu() for protected vCPUs. The values follow the
host-side reset in sys_regs.c, with a poison value where it resets to
UNKNOWN, and for VBAR_EL1 and CONTEXTIDR_EL1 in place of the 0 it
resets them to. MPIDR_EL1 is derived from vcpu_id, as for any KVM
guest.

> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe=
/sys_regs.c
> index 8758c68017765..ebfd48aa15b56 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c

[ ... ]

> +/* Hardware value, as sys_regs.c's reset_actlr()/reset_amair_el1(). */
> +static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
_reset *r)
> +{
> +	__vcpu_assign_sys_reg(vcpu, r->reg, read_sysreg(actlr_el1));
> +}
> +
> +static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc_reset *r)
> +{
> +	__vcpu_assign_sys_reg(vcpu, r->reg, read_sysreg(amair_el1));
> +}

[Severity: High]
Does this allow the host to dictate the protected guest's initial register
state?

Since EL1 has write access to both the actlr_el1 and amair_el1 hardware
registers, the host could set them to arbitrary values before the vCPU
creation hypercall is invoked. Seeding EL2-private state for a protected
guest by reading host-modifiable hardware registers instead of using
hardcoded architectural constants appears to breach the pKVM trust boundary.

> +
> +static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
_reset *r)
> +{
> +	__vcpu_assign_sys_reg(vcpu, r->reg, kvm_calculate_mpidr(vcpu));
> +}

[Severity: High]
Can a malicious host supply duplicate vcpu_id values?

Earlier in init_pkvm_hyp_vcpu(), hyp_vcpu->vcpu.vcpu_id is directly copied
from the untrusted host_vcpu. Since kvm_calculate_mpidr() calculates the
guest's MPIDR_EL1 value based on this unvalidated vcpu_id, could the host
use this to instantiate a protected VM with duplicate MPIDR_EL1 values
across its vCPUs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831163421.2724=
20-1-fuad.tabba@linux.dev?part=3D7
