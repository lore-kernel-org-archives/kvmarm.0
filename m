Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4555239E9CF
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 21:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782250347; cv=none; b=GsQquCNl0Ybyj22+ZOvtSN+tqXguUUKFdeJDWRnNpu13SvLbMq+FBoXBb/i5cXOUSWNd72kmIN51pu9BSrzA2eC5M7+v7G9R0P6YS0QVekZK64mlTiQJ0Zes+1dagum9cdfz7kYU6uyU++Dk/M2mO6OLFBm23K4I5L+VTnzK4pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782250347; c=relaxed/simple;
	bh=YR+FCz4l9MFSdKhg6xkklyCiI52/vmAiqx8TtyDLI/c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ult7oaqfUvlVrVdcF0FiD/JYuw+JCNlb2pKn7QOWJLlQcjPxmd1jtz6LOShcOtu2bEUZHtCyhzySyPHqlrneqEV03reFreMglRveREuxKuwJAeGowfdZJR48YacAhWkDEwFyhfG2CKkMilBq8a80lB2LUJoXUoqOdVvI/+4KBgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMcoWyLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMcoWyLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89CF1F000E9;
	Tue, 23 Jun 2026 21:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782250345;
	bh=nEyyQAYyzJUXyTGH5UHUE3FveBtpbKe7dXKQfj6Qfx8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iMcoWyLjVClEH/eTK07GHPMSUhg6P2HZpmhAuW8+34lmtL0KRHnoGdg255jBwviYw
	 VWmnS2u0oAxX6FBXOJ4FDPhpw5BdXBJDXbHdoFBKc8Uu5UK+01aaKxQ5RcDVK8jfnH
	 JvgO5jQufIeI4/rOLQRE765yNDxKbe10BQZ6tdaj5wsPAt5q2Zs6gwpKbRmZAfnoIn
	 9pw4uk20Uc6TkEirwf1ikL5UQ3Ua7PutX6WXL+2MgIdaLFx8ABaGvCeic+oq+ZZHOy
	 NcZ9E9uccBeO8qNo2DpEI31LLtqF5/XKFKqq3o1jm87rUnK4yjOiyUIUqSOkzl3jEy
	 6JSqI2V1swUTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Check RW permissions for insn abort due
 to S1PTW
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260623211310.1529760-1-oupton@kernel.org>
References: <20260623211310.1529760-1-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 21:32:25 +0000
Message-Id: <20260623213225.A89CF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A malicious L1 guest can cause an infinite loop in KVM by configur=
ing a nested stage-2 page table entry as Write-Only, exploiting how KVM han=
dles S1PTW permission faults.
--

commit e1bdecc84b14199ce5782e0fa66a3e430d0be5da
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Check RW permissions for insn abort due to S1PTW

This patch modifies permission fault handling for instruction aborts with
S1PTW set. Instead of evaluating execute permissions, it falls through to
the read/write permission check.

Link: https://lore.kernel.org/kvmarm/20260623190607.7106B1F000E9@smtp.kerne=
l.org/

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 94df26de6990c..713fc44f362d9 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -918,7 +918,7 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, s=
truct kvm_s2_trans *trans)
>  	if (!kvm_vcpu_trap_is_permission_fault(vcpu))
>  		return 0;
> =20
> -	if (kvm_vcpu_trap_is_iabt(vcpu)) {
> +	if (kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu)) {
>  		if (vcpu_mode_priv(vcpu))
>  			forward_fault =3D !kvm_s2_trans_exec_el1(vcpu->kvm, trans);
>  		else

[Severity: High]
This isn't a bug introduced by this patch, but does this change expose
instruction aborts to an infinite loop if the L1 guest maps nested stage-2
memory as Write-Only?

By falling through to the else block in kvm_s2_handle_perm_fault(), S1PTW
instruction aborts are now evaluated for read/write permissions.

However, if the L1 guest mapped the nested stage-2 page table entry as
Write-Only, the hardware will still fault on the missing read permission
during the stage-1 translation table walk.

Looking at kvm_is_write_fault() in arch/arm64/include/asm/kvm_emulate.h:

static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
{
        if (kvm_vcpu_abt_iss1tw(vcpu)) {
                ...
                return kvm_vcpu_trap_is_permission_fault(vcpu);
        }
        ...
}

It unconditionally treats all permission faults on an S1PTW as write faults,
assuming they are Access Flag or Dirty Bit updates.

Back in the else block of kvm_s2_handle_perm_fault():

        bool write_fault =3D kvm_is_write_fault(vcpu);

        forward_fault =3D ((write_fault && !trans->writable) ||
                         (!write_fault && !trans->readable));

Because write_fault is true, it only evaluates !trans->writable. Since the
mapping is Write-Only, this check passes and KVM doesn't forward the fault.
Instead, KVM resumes the guest, which will immediately fault again on the
read, causing an infinite loop.

Is there a way to ensure we also check trans->readable when the walk is
failing due to missing read permissions?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623211310.1529=
760-1-oupton@kernel.org?part=3D1
