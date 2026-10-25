Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792964894;
	b=0anK2rkhGGDR3KrbrwX2PSPoq42Ay5JeeCUkU6LCHLHhdo4P7HR+agEgaX46KL2xHC76
	 GtCZYh75V8ZhFeKlwG/xmg/aVUJllDEz7eDYxRN/2lpQ9pPLGA61prKEOj/XkH+sZfvyb
	 QbJvRcfEzMaYY673zp51gNTM2j1vflVE4Bi+LjLk89VidNmBMgZj3Y7gO+v5qGECtzpCH
	 pheISbfl/UVoId5sfLzz/vNfn5cZXl5CY+9jqpDyWEPuFVMKODsvXaI1ieIKO2IJqndi1
	 Y+zGCz3SG+YAbrHaqFf/yXcshkt1aLcc59fxriPD+MWTd5Mpw28c5N6Zr5kxE01FknQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792964894;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Cookie;
	bh=hDiTTg5aqjPLEBuvxWemMxO8n0pna/rsjNCyQxTZjbA=;
	b=GivsaRKAFiNMm7rQSc/fhDTeUrFXRWqySn7o5yHXHYttTpaKr3v1gs/BJKO/p4dKUJ6J
	 mgkKcsPVxHz38Lp6RvOYBVIKCYOEMCUW9BA+ABeQSFBPU2gdAlXNnRN7RvEU0/R5LpEW9
	 OQ+hgZXV95VDcjDKbGLZrkvMQHEa7bDwyrbGAAIJPvk33YKHJ8X7G46rfydFJkQpua84b
	 l2ovAij2801Hye0s1b3HsvlLDGLppEQ21silkrinXsXOrJ/o+7lcaw/upXcDlvZPYqvMx
	 NwI0v4IBwy4aFSRsUEYEvcnok3MY+timOYr9ECcbt4KaVThafbx/aFZCujLaX6MszJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RZlGFo4G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF592606A31B;
	Sun, 25 Oct 2026 21:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RZlGFo4G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A6A1F01825;
	Sun, 25 Oct 2026 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792964893;
	bh=hDiTTg5aqjPLEBuvxWemMxO8n0pna/rsjNCyQxTZjbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RZlGFo4GhsbFHSK9ofCYklD9mxJX6RDlW5nMeJqwBzaIhMeZVbyQhtm8Pht13aBUR
	 N5H2XX+HWnWprbfYsWvw/J5cApSoeX2zzOYbqxy85tpfvD059F9v0grCwJsIOKAuQG
	 kTzCQC7kDS9lO0NCB5/DVxrKb1zCkbbeEBVWgw7yeDF1GKd744CpAu/smx9T4lO4JK
	 zZECt8Y5BWSUUEg8iIHeg2IXFbbpKvbj1NKR5HLhoyKkgqMvHlw+5tAhVjDSg47L2i
	 SoEZuOciwHXr7s4WuKOlrUVnZZu3dqiEitjMl4fjy5wfjqifO/N8oQntht3VJIhPwc
	 ANFnmObSBJj3w==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 8C8FE1AC5994; Sun, 25 Oct 2026 21:48:10 +0000 (GMT)
Date: Sun, 25 Oct 2026 21:48:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: selftests: Skip ignored AArch32 ID regs in
 the failed-run test
Message-ID: <at55GhnsD67k2Xkg@sirena.co.uk>
References: <20261024161118.1007472-1-sashal@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XZ3wpwJ3w0pXiMRa"
Content-Disposition: inline
In-Reply-To: <20261024161118.1007472-1-sashal@kernel.org>
X-Cookie: FEELINGS are cascading over me!!!


--XZ3wpwJ3w0pXiMRa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 24, 2026 at 12:11:18PM -0400, Sasha Levin wrote:

> An ignored write leaves the register unchanged, so the ID registers are
> still immutable and only the test's expectation is wrong. Skip the
> AArch32 ID registers that KVM_ARM_GET_REG_WRITABLE_MASKS reports as not
> writable for this VM, which is decided by the same
> kvm_supports_32bit_el0() check as the write path. The aarch64_only flag

Another approach if we're going to change the test would be to have the
test support WI registers like the kernel does and also accept a
successful write that does not change the value, as you say this is also
maintaining immutability.  Doing that would handle anything else that
gets made WI.

> This does not change the AArch32 ID register readback issue under nested
> virtualization that Itaru reported:
> https://lore.kernel.org/all/as8x38o9taXgKZym@sm-arm-grace07/

It's been reported by a bunch of people, including me with the test
fixup that Itaru was mentioning.  It does seem like if we're going to
fix this in the test we should fix all the instances rather than just
one, or we should just fix the kernel like Marc previously requested
(given that we've just stepped on the same landmine...).

> +		/*
> +		 * KVM ignores writes to the AArch32 ID registers when it can't
> +		 * expose AArch32 EL0, and reports them as not writable.
> +		 */
> +		if (sys_reg_CRm(reg_id) < 4 && !masks[encoding_to_range_idx(reg_id)])
> +			continue;
> +
> +		val = vcpu_get_reg(vcpu, reg);

This is checking for AArch32 AFAICT because we're currently seeing
issues due to the lack of AArch32 making the registers WI but one would
expect the same issue to recur for any other ID registers which we end
up doing the same thing for.  If we're going to do this shouldn't we
just check for writability?  Adding the check for AAarch32 as well seems
to have the same papering over the cracks concern that Marc raised.

If writes are being accepted to things reported as unwritable at all
that seems like a separate issue to the finalization, we should test for
that separately.

--XZ3wpwJ3w0pXiMRa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCat55GgAKCRAv73Ows9A4
iWvMAQCfmdP6zPYprHHX9YOoVU356Zhd4rFs5rfa4rIZuFFTJwEAm+X1RFxCBYQi
PZV+kXkd55f3HK82Y3dOjL/RBH2InwA=
=6dZ9
-----END PGP SIGNATURE-----

--XZ3wpwJ3w0pXiMRa--
