Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFE23C09F2;
	Fri, 26 Jun 2026 21:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782510399; cv=none; b=Z8VSwAcp5St/AOw8P0/0pr+iUs4yPkBxF+2Bt3rsRIofw4j/Zr4OmRSUQAQ+xG7i1y7RjK+9SHzPuRDU9yQvHJYflr61LJTDhgwF9u0dc+rGJNf2PvFc+2Fl/3Qm4RUyX5pIUmDUSe9SPQclviptB2e+PsS8yZuY4zD+HMwxk2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782510399; c=relaxed/simple;
	bh=C4wgLAI6I+s7yZ68ALfFwN0EpWI3xGGCyUPIH+mVUWs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fHCh9f950J3sn8RgCpF8DDwo51GlUxR4kwOgA7fKTKO4HuGk6w/+iRqIMWJ5imigLRdX/jSq1xTm075Gv8BQFRwJfKXbIbykAGN74DCTF2ij3aQWwVBmHaISQjjEAp9bQTSDJF3BAookJfDsFi/0blJoiAe7fhZM6qKII7KkRAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSyCVgBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSyCVgBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9491F000E9;
	Fri, 26 Jun 2026 21:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782510397;
	bh=RQInNlw54DqgQSCTH3gwsUnHYvyM0SZaiZCeLKvN8ss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TSyCVgBIFf5W581/3gjk0a6bEvbQ12dYGegrXE/HCa8NIOnoFpSQo/4FVteRaUpjM
	 SbLAWC8yu9hsGw/yZfaqVgIzodZqCmKYUfBA88SDC93azvFROiw2Ksrk+vSWiLeYuf
	 hCIwQBnSztYnobbkbZNOkORhLnGBQJLe0gWwYWA4EsM0G2ZnO6xYOp05eoWGb3aF+z
	 SOCn/GcnoLz0m8AE/Qy+YFQqZda6xsr/1IoWGdMvKOk+XGU1bMW9Fklr2wmq5OnDIl
	 hik91VCgE+xOb/V8zthMKSfC28dlIlyUqVnY2VdCEbViDQDvFSERPfAVfTVboW5u1E
	 wOKOZ86MqlTjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 11/20] KVM: selftests: Verify interrupts are received
 when IRQ affinity changes in IRQ test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260626213534.3866178-12-seanjc@google.com>
References: <20260626213534.3866178-1-seanjc@google.com>
 <20260626213534.3866178-12-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 21:46:36 +0000
Message-Id: <20260626214636.DD9491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The IRQ affinity logic incorrectly assumes that CPU IDs are cont=
iguous and zero-indexed up to `get_nprocs() - 1`, which will cause spurious=
 test crashes on systems with sparse CPU topologies or offline CPUs.
--

commit 907b9a0cf2f427a532d2facb5d6393850a4b6083
Author: David Matlack <dmatlack@google.com>

KVM: selftests: Verify interrupts are received when IRQ affinity changes in=
 IRQ test

This commit extends the KVM eventfd IRQ selftest with a '-a' flag. This flag
randomly affinitizes the device's host IRQ to different physical CPUs to
stress KVM's interrupt routing logic while affinity changes dynamically.

> diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selft=
ests/kvm/irq_test.c
> index 70b2c9cac2790..fd386e3e9ac3e 100644
> --- a/tools/testing/selftests/kvm/irq_test.c
> +++ b/tools/testing/selftests/kvm/irq_test.c

[ ... ]

> @@ -228,6 +239,11 @@ int main(int argc, char **argv)
> =20
>  		kvm_route_msi(vm, gsi, vcpu, vector);
> =20
> +		if (irq_affinity) {
> +			irq_cpu =3D kvm_random_u64(&kvm_rng) % get_nprocs();
> +			proc_irq_set_smp_affinity(irq, irq_cpu);

[Severity: Medium]
Will this cause spurious test crashes on systems with non-contiguous CPU IDs
or offline CPUs?

Since get_nprocs() returns the count of currently online processors, using =
it
with a modulo operation in main() assumes that the online CPU IDs are
contiguous and start from 0. On a system where CPUs are offline or the
numbering is sparse (for example, if only CPUs 0 and 2 are online,
get_nprocs() returns 2, and the modulo yields 0 or 1), this could select an
offline or non-existent CPU ID.

Attempting to write an invalid CPU ID to /proc/irq/<irq>/smp_affinity_list
via proc_irq_set_smp_affinity() would then fail with -EINVAL and erroneously
crash the test.

> +		}
> +
>  		for (j =3D 0; j < nr_vcpus; j++)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626213534.3866=
178-1-seanjc@google.com?part=3D11
