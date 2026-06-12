Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AE23093DD
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781248100; cv=none; b=dVgv+vD4nSkZeDf9E1sskEzyAkeak/aeDxpJewRwl18p5KEx3hjvrWEHXw/X43myzxD45iG1mbylt1yeMyeorXdZxhm3LiDnI5hJGa0kui05+C0zsgYWZr5m41l4tAOhGI/KsSjBeVfBRf6vZrFwsWL+a2r0f2NuktPyZ0desdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781248100; c=relaxed/simple;
	bh=WmbtPEpTFKDSq1DbaiqQq5uQX4ZE80Q0ZpAaWj7A95Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JkzTELtgziITEgW5UdBV6+NuhFw/ohMRFKuRbO1Q1vUlzVXPY0ulx7i38guSU3jh4ruILZEMHYcH6Ib8NkZ5fwm4IC8TusAnjS7ydFWZboXt0K49L+YgxRG6uvxPT5PHFNx8XM6RtI03yixQlnFmLAHSFqXcYDtXcwTU2Q/UbA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aYkRCEyN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYkRCEyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FE01F000E9;
	Fri, 12 Jun 2026 07:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781248099;
	bh=I6JnKhMq6CSo0RAs7VL2FnC3pM41lAEnzeI/GA3UzY4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aYkRCEyNohW1vCMgYlQMMpxX+o1GteD3ZthwE28XDOALH612lid8VTuhXG+nw+4Aq
	 mz51GLt/phDrT1RY8V3dGLhCK4Ivd2XDnb2TOLryEEiLW14eDHFgbNjMQ3tFekSiCF
	 P3knP2a8FwdXWW3kPNXwAeM8IdNOPXqWckbGWVlGasngV+oUfdP3DUqG5cjSsSgzKm
	 gTTCojZawKlkLYIaSRrjEJQI33H5wW1un15SgKBAQ01T8UzdZTG8kWN1pa3PLUogYq
	 0ttYKS3/z/SAzhU1mn1VaiOghewXlFdxSHT7ptZpO1HfuDbwb57ZUdHw2exP7cH9kx
	 piYoYysGQNsGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 08/11] KVM: arm64: Add host and hypervisor vCPU
 lookup primitives
Reply-To: sashiko-reviews@lists.linux.dev
To: tabba@google.com
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260612065925.755562-9-tabba@google.com>
References: <20260612065925.755562-9-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 07:08:18 +0000
Message-Id: <20260612070819.64FE01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] flush_hyp_vcpu() incorrectly copies MDCR_EL2 from the untrusted ho=
st context for protected VMs, violating EL2 security guidelines.
--

commit 11498ed516d4ebc65b4ad00086974239ee0e2eb4
Author: Marc Zyngier <maz@kernel.org>
KVM: arm64: Add host and hypervisor vCPU lookup primitives

This commit introduces primitives to translate a host vCPU into the
hypervisor's address space. It refactors handle___kvm_vcpu_run() to use
these new lookup primitives.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -214,23 +245,16 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_co=
ntext *host_ctxt)
>  			goto out;
>  		}
> =20
> -		if (!hyp_vcpu) {
> -			ret =3D -EINVAL;
> -			goto out;
> -		}
> -
>  		flush_hyp_vcpu(hyp_vcpu);

[Severity: High]
This is a pre-existing issue, but does flush_hyp_vcpu() incorrectly copy
mdcr_el2 from the untrusted host context for protected VMs?

Looking at flush_hyp_vcpu() in arch/arm64/kvm/hyp/nvhe/hyp-main.c:

static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
{
        struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
        [ ... ]
        hyp_vcpu->vcpu.arch.mdcr_el2 =3D host_vcpu->arch.mdcr_el2;
        [ ... ]
}

According to the pKVM EL2 Security and Trust Boundary guidelines, trap
configuration registers like mdcr_el2 must be initialized in an EL2-private
context for protected VMs. They must not rely on values written by the host.

Because host_vcpu resides in untrusted host memory, this unconditional
assignment could allow a compromised host to overwrite the mdcr_el2
configuration of a protected VM. This could potentially allow the host to
manipulate guest debug exceptions and break guest confidentiality or
hypervisor isolation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612065925.7555=
62-1-tabba@google.com?part=3D8
