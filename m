Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4814D539778
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 11:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790075008; cv=none; b=izkkCjVbsXTk9YYNb70YEorYO1bsjnzje+PS+8E5NPK9wRES30Eh2WLDs/MO/SLWw9zcuxoChdzd5BRp1CW/fiqiZyYXRHZrFwgNrurw2eIcQ06TwsSaWojshYWeS9KbF1Oj4EBA8ysXGmC5PtTguzxRyDvw62NseKxobXJkbdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790075008; c=relaxed/simple;
	bh=AGHGlmQ2CTK7S4T59r44uJ665Z7OII1thpuwfU1M+nk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O3bX/LtskA76dYcbeRvqo5WYSVRlc3jOamCPVi49/4PfPH17n1Sg+bt5TjS4c0T/RRJAdPOg2JKOeBLkWRU1zawbI44pD03x6DOuNi+XQ/235BuVZ2vqBwu5fSCu5gNBVeZc1g3JlAMTbX86+I/3kObKsUqM8d3ULUHFIQcEk90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g02WpONc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g02WpONc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0491F000FF;
	Tue, 22 Sep 2026 11:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790075006;
	bh=u0N2S2HDxSKdRHxt7f1PIFt1Xy8P3j0sqGZeA8QvaRA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g02WpONcQo8hHyH1aL/OJQ51S1dRCGpHJOAXDQckJnDoSNC24+a+oY5AOnZZz5tyx
	 eEk/2vXyh8B219E1gOCznDmPfF7YSRRWOEs6GuPQLr8/Sv/3vUjogDsZrqNmYpck7M
	 VeKtynZIPlqUPE1DANcNo0NULYGtntCSgRuYcDIBqER6M9tgq5E3B+8Ak/XyfnaQbj
	 vg+w8Gn1JFSykaxnSjNM3aqkGbIqS+Xp+uIcefgbpSKaN3id3gwQUnmZ3Kc0C1Iojt
	 uplUXxOZEJXRZwxsx7ElskyB8x/mu52yHciHSCsoOhWcADDVpuUDmWC/8/G59BQUZ1
	 LqOEeVPWZLIrA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: selftests: arm64: Add test for cross-vCPU LPI
 disable race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuchao Zhang" <ndaugoing@gmail.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260922105331.40498-1-ndaugoing@gmail.com>
References: <20260922102959.41FFA1F000FF@smtp.kernel.org>
 <20260922105331.40498-1-ndaugoing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 11:03:26 +0000
Message-Id: <20260922110326.AA0491F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests: kvm: missing mandatory kvm_arch_has_default_irqchip()=
 check
--

commit 41b2f5071c9e0e643d02d3f1806d75461776914a
Author: Yuchao Zhang <ndaugoing@gmail.com>

KVM: selftests: arm64: Add test for cross-vCPU LPI disable race

This patch adds a selftest to validate the behavior of remote LPI disabling
while the target vCPU has in-flight or overflowing LPIs. It configures an
ITS with multiple LPIs targeting vCPU 0, forcing its List Registers to
overflow, while vCPU 1 repeatedly toggles GICR_CTLR.EnableLPIs on vCPU 0's
redistributor.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_disable.c b/tools=
/testing/selftests/kvm/arm64/vgic_lpi_disable.c
> new file mode 100644
> index 0000000000000..d3480369d7607
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_disable.c
[ ... ]
> +int main(int argc, char **argv)
> +{
> +	int opt;
> +
> +	TEST_REQUIRE(kvm_supports_vgic_v3());

[Severity: Medium]
Should this code also include a check for kvm_arch_has_default_irqchip()?

The KVM subsystem guidelines mandate that any selftest requiring an in-kern=
el
IRQ chip must call TEST_REQUIRE(kvm_arch_has_default_irqchip()). This ensur=
es
the test is correctly skipped on platforms without default IRQ chip support.

> +
> +	while ((opt =3D getopt(argc, argv, "i:e:h")) !=3D -1) {
> +		switch (opt) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922105331.4049=
8-1-ndaugoing@gmail.com?part=3D1
