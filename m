Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8566F2D1913
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 22:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300398; cv=none; b=SQSLLh85Dq/C0Nr9SLXJeY6Kik3rqwhTGcjDcVTA4EtKS3tE3sNwVbtj+DhneHDmCne6FxrEhlquDBq0T8+9q5iR4FN0jhXLt4dDTciHXOFMYf+/DC9An1XLzR8K0cVZjy6e1HIg1oKbKtTUvhBO1spSOqOtuvs2XABXx/IAQXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300398; c=relaxed/simple;
	bh=cRT+NCFhU0reNMZpJDBa92A6RnOAf73rHu7fKY17hig=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xbyxvs5SVid3NSPKHn6edJQVnUrdGL7m7hxFLjBuiYG1vKwRPtpy+TIAn2bWVjl44fFw2x8Cuach9aKzZ9FlyghbpjHdYDFV3ylmBLLLh/PumOwea6QrcdZZlPSew4jjgnpfzECYCKUIz/Az3Uk3a/Ocjl0o46b6j6AkMyJt+Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZ9RR3kC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZ9RR3kC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102E01F000E9;
	Tue,  1 Sep 2026 22:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788300397;
	bh=Bbx7Czafx85HpIiMv6IJkW9Ri1g1M7FbhiM+pQbDfsg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cZ9RR3kCZ+p8M/CNTysrbu163weW6EafDNBKvosYbY3JQNKKZ4EJp9PIKK1qEcrHG
	 CVXqlkOaZ71PxBcTm1zQxYZ9aqdM43uHZIUr3sfRpKt2vndW31fq1Vz6/Jf8je+YBi
	 VuvTm5RwsVOYe05F29OiJ853Z3qI5ck/wmtoByouLWTFxwM6xg3mBb9GzXDCp3V+rR
	 sZNbI6dv44xD8444G0fc1/KfjMwkQLxqTv2bWkZVHdns/Qp90PriQIOzB8lOK/vRJK
	 wz75c7Q0YByAp1q7HZE1CnBFf0sA3yeAkgafSKPiw4UnrutUSAgc9XfIZZ08XXIkuw
	 HSC6qxScLBdNg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering
 an exception
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260901-arm64-gcs-v20-5-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-5-f31750bdfadb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 22:06:36 +0000
Message-Id: <20260901220637.102E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incorrect GCSCR_ELx register selection based on the current cont=
ext instead of the target exception level.
--

commit 42f10f3e973b268a78dccd02e2f0ddbf5ed384fb
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Set PSTATE.EXLOCK when entering an exception

This commit implements managing PSTATE.EXLOCK when entering an exception.
When taking an exception to a lower EL, the bit is cleared, and when
entering from the same EL, it is set to GCSCR_ELx.EXLOCKEN.

> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exceptio=
n.c
> index 754e2dc1df54a..85c873644fe90 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -49,6 +49,38 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcp=
u, u64 val)
>  		vcpu->arch.ctxt.spsr_und =3D val;
>  }
> =20
> +static unsigned long compute_exlock(struct kvm_vcpu *vcpu,
> +				    unsigned long mode,
> +				    unsigned long target_mode)
> +{
> +	u64 gcscr;
[ ... ]
> +	/*
> +	 * When taking an exception to the same EL EXLOCK is set to
> +	 * the effective value of GCSR_ELx.EXLOCKEN.
> +	 */
> +	if (is_hyp_ctxt(vcpu))
> +		gcscr =3D vcpu_read_sys_reg(vcpu, GCSCR_EL2);
> +	else
> +		gcscr =3D vcpu_read_sys_reg(vcpu, GCSCR_EL1);

[Severity: Medium]
Could compute_exlock() read the wrong register when a nested guest
configures HCR_EL2.TGE =3D 1 while operating in EL1?

If KVM injects an exception to EL1 in this state (where target_mode is
PSR_MODE_EL1h), is_hyp_ctxt(vcpu) will evaluate to true because TGE is set.

This would cause the hypervisor to read GCSCR_EL2 instead of GCSCR_EL1,
leading to an incorrect PSTATE.EXLOCK value for the injected exception.

While a nested guest executing in EL1 with TGE=3D1 is architecturally
unpredictable in hardware, KVM's software model typically avoids
cross-wiring registers for different exception levels.

Should this logic strictly use the explicitly passed target_mode to
determine the target exception level, similar to how enter_exception64()
handles VBAR and SCTLR?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-arm64-gcs-=
v20-0-f31750bdfadb@kernel.org?part=3D5
