Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990842;
	b=ifsd/lA62sHwdClWzypX6wFuhym/GQwBwbFxQEquVda1hKWPyCvtEU1sxl4hbUZxUpFi
	 pb+vkGQ5FBi/U3HZ/Jt/T4Fsk8JGqmKipWDm5wxf5GiTvVXXTNhoy2xLRxK2LKu/Swei/
	 x596jMKF7zSE67ru5bQP7sxCeuDfcg6OD8G+GmA07ByQwWtuErSbOunWLvtuSbYWmVBCm
	 oRCYO6plm/qI3QZG7Mj/YED1b94g0hmmWUY+nlw+90omnLGfUCqcuo9RGjYu+TvKZvG/T
	 l8CTuAo2OK8OJXYmyexNYGbISJogDOMWY1qSGFjpCctKBewXrX/NyJBN0II638W8uJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990842;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=E5pWd1p/uO3orcOtmiupfEGeuBt7gaL0MvPBtV0tzcg=;
	b=AfgqzSg3acOw0XnTwofvRAPGyQTBfZT1ze1nxwb2lgAPcCb0W9LqRG8qH39shrexh3ST
	 NFmZqmY0Iqh2+dlMU6ig6rOv4hQoPr0oOR+MXWFD+DJTh91pWa0Rq5u37Jv7/wS/m4rE1
	 qwb8vRWJXTfjJbJwtPahpatSOkXPJwYyHQxAUpfX3nQQlEuRFRcMIr6Orjs+TSilIwbnq
	 AVrho1UUmOdvmnIwWWSKb1iVshZuOXnMJ20MXu+T2dk+sdyjUnc2nSboF2IecY73gmfNF
	 +W3dq9Z3dLWJGnWfxLYDew1XuSgzHrQ/O3Sb/LkFe5X1Y7xE0gFuupKdmysmZLI6eCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X8sl0MfZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCD5606A329
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X8sl0MfZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E141F0089F;
	Fri,  6 Nov 2026 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990841;
	bh=E5pWd1p/uO3orcOtmiupfEGeuBt7gaL0MvPBtV0tzcg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X8sl0MfZOPBHMrQZOMygQrgA9YtAsJH9NwvFL1zzBYemCjOtwbsKFJGPSWj/+8tKc
	 47+Lxd27+GOltjgs1RC9h2Ythr8cv/1k0lek2kC7ZFC/SBphlBy7K92ma56Td5gBgn
	 AnQY+zs4u3wnzzKe57X847Nlc1rE8Bsh+09fG5mNKrH8KZ8YwCAa6ellWMfQTOPLrP
	 nGb/0P/rLYegSu/YmqR1J8n1P1Yp9nqGhTiuU6kOA96h4ckQkOunRIluHupY/EmsSz
	 Wj0+tbUiAleeqLx/TxGt/skAxAnpI9XeFqaHxLyhzzP6e/VCDV3uZCM6XefxnffQPV
	 4VIk63GFuQHBw==
Message-ID: <sashiko-outbox-202099@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 8/8] KVM: arm64: Stop leaning on __kvm_inject_sea()
 for abort injection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261106183154.3590825-9-oupton@kernel.org>
References: <20261106183154.3590825-1-oupton@kernel.org>
 <20261106183154.3590825-9-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:47:20 +0000
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
- [Low] KVM: arm64: missing Fixes trailer for kvm_inject_size_fault()
  AArch32 PABT bug
--

commit f2d6dc968339775720bc3ec74dcb33374b8473b1
Author: Oliver Upton <oupton@kernel.org>

> KVM: arm64: Stop leaning on __kvm_inject_sea() for abort injection
>
> KVM's handling of local abort injection is, politely stated, a giant
> fscking mess. At surface level, things look somewhat innocuous: inject
> an SEA and directly update ESR_EL1 with the correct FSC afterwards. But
> this is broken for a couple reasons.
>
> For one, on implementations with FEAT_DoubleFault2 KVM may inject the
> SEA as an SError depending on the falue of SCTLR2_EL1.NMEA, meaning that
> the eventual non-SEA abort is incorrectly taken to the SError vector.
>
> AArch32 is also quite bitrotted. No surprise. The FSR value is written
> to IFSR not DFSR, when a prefetch abort is injected. So while DFSR is
> aliased to ESR_EL1 architecturally, fixing up ESR_EL1.FSC after
> injection has no effect on IFSR.
>
> Finally, injecting aborts into non-LPAE relics may use an invalid value
> for xFSC.FS, as KVM unconditionally uses the LPAE/VMSAv8-64 format.
>
> Fix the first two by tearing the whole mess, adding __kvm_inject_abort()
> for injecting non-SEA aborts which takes the desired FSC from the
> caller. Fix the third one by selecting a fault status value based on the
> LPAE-ness of the guest.
>
> Cc: stable@vger.kernel.org
> Fixes: fff97df2a0bd ("KVM: arm64: Route SEAs to the SError vector when EA=
SE is set")
> Fixes: 2937aeec9dc5 ("KVM: arm64: Handle DABT caused by LS64* instruction=
s on unsupported memory")
> Signed-off-by: Oliver Upton <oupton@kernel.org>

[Severity: Low]
Of the two functions changed here, only kvm_inject_size_fault() can inject
an AArch32 prefetch abort (where FSR is written to IFSR32_EL2 while the
post-injection fixup only cleared ESR_EL1).  Should this also include:

  Fixes: 85ea6b1ec915 ("KVM: arm64: Inject exception on out-of-IPA-range tr=
anslation fault")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106183154.3590=
825-1-oupton@kernel.org?part=3D8
