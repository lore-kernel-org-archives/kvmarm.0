Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A23E20ADF8;
	Sat, 13 Jun 2026 00:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310580; cv=none; b=s2ErxrIun3QeuR89wMRkOyINkTSq0TpfbfxKaVqMWuXiSag4LjPrABU/DpIohJVpDK0/KvEsvzd3B55ND5Q4GG/9xdHcv96SCGuR3bwBZbviOJ1yuYvK/efTWcM1Bfclnxf7MvoD/zUPyiwGogLWMyEBAGH51QeR6vV2wrPXk0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310580; c=relaxed/simple;
	bh=TDdiEcpsYiKFuDamStJR5XNCkNAV757W8S3QLBoyLT8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=coqHlyMEFgSOeFxcqdFMQl9aSJs1juJsIeYTAVw3C+bd19o1OUX4OEBFj4QOMFvBXisbQFlKjg08jM68cm+p4Ju/EF84oLRjlDVdgHcNPGLvpl3N5/G7L2ygMSaLVg3fJKPQFTIU81NM5Nb2BpfAqrkFCJkNyEnmOAuSRgiWyV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4dcvdcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4dcvdcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD2E1F000E9;
	Sat, 13 Jun 2026 00:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781310579;
	bh=g5ipfQM059JoZ+TS/RJlbht3cNCNw95VD0hAQB+sb/c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i4dcvdcVxlV292feL5yAmK5fJLZc1ZWmVWwWfuvlEBtEVI1N5v7qwHhq+XITjVVYB
	 caqnE9LkLWUaq4R9pgdagyU4diOHidKB2jg22nAeM9Aeq0BntpqI+50enMAKHajD6Z
	 O5ELhv85oOp3l43Qd7Pf5hR4cDEo/WYYiHBGOXgFR92F/TW0P/yOA7IraDDamtp7Rz
	 bcFd1c50zD1LU1fC+aqCK5ZnQlSS1kQYBmduUqXg4yaUYAcLOMEnQ8AODVxdKQWpte
	 J6+y+9SrOpVE9Z68mxeaphE0EFmh4FIbi0CBi+cF61yx+VFh1aklM5MxeMlSnesRjK
	 M5aTxzCFlsEnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 11/20] KVM: selftests: Verify interrupts are received
 when IRQ affinity changes in IRQ test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260613002031.745413-12-seanjc@google.com>
References: <20260613002031.745413-12-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 13 Jun 2026 00:29:38 +0000
Message-Id: <20260613002939.0AD2E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The test calculates the target host CPU for IRQ affinity using a=
 modulo of `get_nprocs()`, incorrectly assuming that CPU IDs are contiguous=
 and 0-indexed without gaps. This causes spurious test failures on sparse t=
opologies or systems with offline CPUs.
--

commit f0fe406c9bb6f2cc39673ee344b3e53be280d025
Author: David Matlack <dmatlack@google.com>

KVM: selftests: Verify interrupts are received when IRQ affinity changes in=
 IRQ test

This commit extends the eventfd IRQ test with a '-a' flag to randomly change
the device's host IRQ affinity to different physical CPUs during the test.
This ensures the kernel maintains correct interrupt routing when hardware I=
RQ
affinity changes dynamically.

> diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selft=
ests/kvm/irq_test.c
> index 6888be54ee4a9..c01aa313f7198 100644
> --- a/tools/testing/selftests/kvm/irq_test.c
> +++ b/tools/testing/selftests/kvm/irq_test.c

[ ... ]

> @@ -210,12 +220,19 @@ int main(int argc, char **argv)
>  			continue;
>  	}
> =20
> +	irq_cpu =3D -1;
> +
>  	for (i =3D 0; i < nr_irqs; i++) {
>  		struct kvm_vcpu *vcpu =3D vcpus[i % nr_vcpus];
>  		struct timespec start;
> =20
>  		kvm_route_msi(vm, gsi, vcpu, vector);
> =20
> +		if (irq_affinity) {
> +			irq_cpu =3D kvm_random_u64(&kvm_rng) % get_nprocs();

[Severity: Medium]
Does this code assume that CPU IDs are contiguous and 0-indexed?

If get_nprocs() returns the number of currently available processors, could
this modulo calculation yield an invalid or offline CPU ID on systems with
sparse CPU topologies or offline CPUs?

This regression might cause the subsequent call to proc_irq_set_smp_affinit=
y()
to fail with -EINVAL and spuriously abort the test.

> +			proc_irq_set_smp_affinity(irq, irq_cpu);
> +		}
> +
>  		for (j =3D 0; j < nr_vcpus; j++)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260613002031.7454=
13-1-seanjc@google.com?part=3D11
