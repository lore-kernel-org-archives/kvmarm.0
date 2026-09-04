Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13937348C6D;
	Fri,  4 Sep 2026 13:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530175; cv=none; b=AOZB9yVz3WFOCw4WHF1QkCnfGfwajpcUtkBjeeW8bdnbEZ9yOZsoWKqngspB5wISxMNwzAvPajlczvt/FvKJPbvHB90b8cljsPk1RvqmQrhrfAk1Sp0D8klXDfpgHeNOBJQoeaOAFRtUSWoAZOjirrZiaUkqm3nfJYLLpeLUtcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530175; c=relaxed/simple;
	bh=S9WhcU4xIkbV2OXXv+Lepa2M8c3t80ca5zbVtyxf4lE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GlximoQpXFj/4fuwi933KxU+fM8OthjDAG3t4xEPJYg+DnQxYFujheJtHQBVN8vK0SbvplQOk2Y9jZmc+9WG/Z0r0rMhe9QwHP3sdX1iWb+nWcg/SmpFT7dN2PGUT6dv+q0gCy2gNxqb1ylol4yjoDXvquhpO/f9KAbnPSxi9q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLlCQ0gk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLlCQ0gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521531F00A3D;
	Fri,  4 Sep 2026 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788530173;
	bh=QhPr7VD+ONRgAtLNbE+GRHLvBYy612pz6D+VCM/5TS4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eLlCQ0gkEUz2izzbXl3mS2gczM+EeZfMV6UyMwCHyjt0LZqgBcTq0D1VodsgVnWdz
	 hIt22gT+dt4n/bwWN5w0iA/Eq4KnzOqpCjL38HdvVLhw46phMY2uDJqphy0Ttp8LHp
	 SVKc9XqswfTrvakbMaSbknVCYjg42QZguocsJp/DkA8M22n6Pki7IDdFmgHqqcYu/3
	 5f6qJjjQWCFPUdQo7j6covVyQdAV8UhvtTtmMdJraTjqdu4odn7tmo0f6PmIPnJ5DG
	 aMQdqToSsPaENrOggTncnJwzPhv/3Gw8DPIEjfG5UDPvxWIEF56ThWufw0YnSeTp4L
	 eNXB1y/Qbmitg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 47/49] KVM: selftests: Add VGICv5 LPI delivery tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260904113404.4051341-48-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-48-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:56:12 +0000
Message-Id: <20260904135613.521531F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Relying on compiler constraints for the GIC CDEOI system instruc=
tion can lead to CONSTRAINED UNPREDICTABLE behavior.
--

commit 6f03c4ee5c0472fcc0bcfa5a518dc3c9f7d39892
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 LPI delivery tests

This commit adds a two-VPE VGICv5 LPI delivery test. It exercises the
virtual IRS ID registers and IST base configuration path by identity-mapping
a dedicated userspace memslot into the guest for the LPI IST.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index ea3451d850c22..c4c932f4c1d46 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
[ ... ]
> @@ -209,6 +298,67 @@ static void guest_spi_line_code(void)
[ ... ]
> +static void guest_lpi_irq_handler(struct ex_regs *regs)
> +{
[ ... ]
> +	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
> +	GUEST_ASSERT_EQ(hwirq, expected_hwirq);
> +
> +	gic_insn(hwirq, CDDI);
> +	gic_insn(0, CDEOI);

[Severity: Medium]
Does this instruction expansion rely on unsafe compiler constraints?

Using the gic_insn(0, CDEOI) macro here in guest_lpi_irq_handler() in
tools/testing/selftests/kvm/arm64/vgic_v5.c relies on the compiler selecting
a register for the CDEOI system instruction. If the compiler selects a
general-purpose register other than XZR (due to relying on the rZ
constraint), it can misencode the instruction and lead to constrained
unpredictable behavior, potentially causing the guest to hang or crash.

Should this system instruction explicitly hardcode the exact register in the
instruction string rather than relying on compiler constraints?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D47
