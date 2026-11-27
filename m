Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795803250;
	b=GVsTVhbKAVJqrL9rsoTQ6+delPKdFOC83WTAPzP4aeyD7mfLHV5KchBVC0FAyVHSLv9h
	 5l0vN/FVFmSM+jRb4qMHgdPKO9oGKbHhQlpwQT3TrjoAR4yKd84B2MPb3dJHEQaTM1+0F
	 7FJ7ICRjVgDKppM3sD8oPBLsS0H62xmlXyc7GLh64cOo+NW+8fr9x0FePtewbm1oPpB4D
	 kzvlO/iNZGGTDXQPndHbxZH+vjV4APWplXVesZzPDyVST/S33JZdqOeh5RHl0JXFKTImr
	 s3nve/jDaHD3DHNYmkTlrDazCNo+iolLUN9fB0fL5sW6b8KwTSl1pSOU8oDn0kTUX5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795803250;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CKHTaSLzxdSV1614RGH74z1CYt8yFd3I+q3rL4tHKUE=;
	b=tWFaSSYIbc4OOvVVCKaIxGifgx0SSUp0wC1X1VjaKHzJ7VoWrITTeKCQak9p3ANrBoB4
	 FgS7OjvY+klG4BKSMssN097q+XYijJD++rYr0H0akv6u8r/RRbRgfFs8Ee5k7VfwGiuXx
	 n6RspKxOf2IC5w+SfeUyk9RRvFeqkQoJCMfcr6D6SfrQyCrjPyN6Mm87P6qqBbVMWRgT+
	 lHifQthdYrWljdyYV5I/zdUTOiUCpygIqO81Yviz2pYgs6WirLGzTCMuFrDMVk9tsS+PZ
	 bI0XQJDj9iqEcHqb85PluOQ8d4yOVVJv0cq/kwy2GiBXdYRyJJhQvKrD9HoIT9JqNwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eA1a1wqB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB6C606A31C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eA1a1wqB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FB51F00898;
	Fri, 27 Nov 2026 18:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795803249;
	bh=CKHTaSLzxdSV1614RGH74z1CYt8yFd3I+q3rL4tHKUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eA1a1wqBAk9Yx922OY96kc60iH8nuMWn0NLMyFvYWHu3wR5B+BwLDqXvbUM4At2Wf
	 v/3i0GraqGQgVRA7f/E/w5T52SO/8/HNCdzC5FuoSeNxjsraD5VUFp0h41FWdZAg1z
	 UowLnsWQovtdtaJF9TbDN3q+v4U6NQ6v4ymILTi5hwxPQL4T81kl4M/ppMi+qNlYrN
	 kXYwWMIZQy4UouehUjx2PkNzJZAMIM/9KWkklg3+RAMaqpdDHy9p2ovD0pLimpYR67
	 lfD8U3FUMYoxA5eOpSbLLycd8xwx41N2e2xCS4PzSvL7r4olJhWsKV7NtF/I74DdAi
	 c/XzQ0a/JY21A==
Message-ID: <sashiko-outbox-238059@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Drop a pending MMIO access when injecting
 an unmasked SError
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dan Carpenter" <dan@pereq.eu>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261127-serror-drop-mmio-v2-v1-1-96bd01bef6d8@pereq.eu>
References: <20261127-serror-drop-mmio-v2-v1-1-96bd01bef6d8@pereq.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 18:14:08 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] KVM: arm64: PSR_A_BIT check in kvm_inject_serror_esr() ignores
  SCTLR2_ELx.NMEA
--

commit 3baf52b3ece0a678fb430e38fdfba08de0591af4
Author: Dan Carpenter <dan@pereq.eu>

KVM: arm64: Drop a pending MMIO access when injecting an unmasked SError

This commit clears vcpu->mmio_needed when injecting an unmasked SError via
HCR_EL2.VSE so that non-NV vCPUs cancel a pending MMIO exit like NV vCPUs
do.

> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index aa2011cc0d5a0..61df0338290d9 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -386,6 +386,13 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64=
 esr)
>  		return 1;
>  	}
> =20
> +	/*
> +	 * Like the emulated entry above, an unmasked SError cancels the MMIO
> +	 * access the vcpu exited on.
> +	 */
> +	if (!(*vcpu_cpsr(vcpu) & PSR_A_BIT))
> +		vcpu->mmio_needed =3D false;

[Severity: Low]
Does hardware deliver a virtual SError pended via HCR_EL2.VSE when
PSTATE.A is 1 and the effective SCTLR2_ELx.NMEA bit is 1?

This rests on an architecture detail that could not be confirmed from the
kernel source.  Earlier in this file, serror_is_masked() treats SErrors as
unmasked when effective_sctlr2_nmea(vcpu) is set, and the NV path right
above emulates the exception entry and clears vcpu->mmio_needed in that
state:

arch/arm64/kvm/inject_fault.c:serror_is_masked() {
	return (*vcpu_cpsr(vcpu) & PSR_A_BIT) && !effective_sctlr2_nmea(vcpu);
}

If HCR_EL2.VSE also delivers the virtual SError when PSTATE.A is 1 and
effective SCTLR2_EL1.NMEA is 1, testing only PSR_A_BIT here leaves
vcpu->mmio_needed set on a non-NV vCPU, so the next KVM_RUN completes the
MMIO access and advances PC before the guest takes the SError.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-serror-dro=
p-mmio-v2-v1-1-96bd01bef6d8@pereq.eu?part=3D1
